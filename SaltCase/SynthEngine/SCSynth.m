#import "SCSynth.h"

const UInt32 kSCBufferPacketLength = 1024;
const UInt32 kSCNumberOfBuffers = 3;
const float kSCSamplingFrameRate = 44100.0f;

@interface SCSynth() {
    AudioQueueRef audioQueueObject;
}
@property (assign) UInt32 bufferPacketLength;
@property float* renderBuffer;
@property UInt32 renderedPackets;
- (void)render;
@end

@implementation SCSynth
@synthesize bufferPacketLength, renderBuffer, renderedPackets;
static void outputCallback(void *                  inUserData,
                           AudioQueueRef           inAQ,
                           AudioQueueBufferRef     inBuffer)
{
    SCSynth *player =(__bridge SCSynth*)inUserData;
	[player render];
    
	UInt32 numPackets = player.bufferPacketLength;
    UInt32 numBytes = numPackets * sizeof(SInt16) * 2;
	SInt16 *output = inBuffer->mAudioData;
    
    static float prevValue[2];
    prevValue[0] = 0.0f, prevValue[1] = 0.0f;

    // Limitter and Low-pass filter (to protect speakers / ears).
	float volume = 0.5f;
    for(int i = 0; i < numPackets * 2; i++){
        float rawSignal = player.renderBuffer[i] * volume;
		rawSignal = fmin(0.999f, rawSignal);
		rawSignal = fmax(-0.999f,rawSignal);
        
        SInt64 limittedSignal = (prevValue[i % 2] + rawSignal) * 16384.0f;
        prevValue[i % 2] = rawSignal;
        
        *output++ = limittedSignal;
    }
    
    inBuffer->mAudioDataByteSize = numBytes;
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    
    player.renderedPackets += numPackets;
    [[NSNotificationCenter defaultCenter] postNotificationName:SCBufferUpdateNotification object:player];
}

- (void)render {
    // Test: Sine wave
    static float theta = 0.0f;
    for (int i = 0; i < bufferPacketLength; i++) {
        theta += 0.05f;
        if (theta >= 6.28) theta -= 6.28;
        float wave = sin(theta) * 0.5f;
        renderBuffer[i * 2] = wave; // Left
        renderBuffer[i * 2 + 1] = wave; // Right
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.bufferPacketLength = kSCBufferPacketLength;
    }
    return self;
}
-(void)prepareAudioQueues{
    renderBuffer = (float*)malloc(sizeof(float) * bufferPacketLength * 2);
    for (int i = 0; i < bufferPacketLength; i++) renderBuffer[i] = 0.0f;
    self.renderedPackets = 0;
    
    // 16bit Stereo 44100Hz
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate			= kSCSamplingFrameRate;
    audioFormat.mFormatID			= kAudioFormatLinearPCM;
    audioFormat.mFormatFlags		= kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    audioFormat.mFramesPerPacket	= 1;
    audioFormat.mChannelsPerFrame	= 2;
    audioFormat.mBitsPerChannel		= 16;
    audioFormat.mBytesPerPacket		= 4;
    audioFormat.mBytesPerFrame		= 4;
    audioFormat.mReserved			= 0;
    
    AudioQueueNewOutput(&audioFormat, outputCallback, (__bridge void*)self,
                        NULL,NULL,0, &audioQueueObject);
    
    AudioQueueBufferRef  buffers[kSCNumberOfBuffers];
    UInt32 bufferByteSize = bufferPacketLength * audioFormat.mBytesPerPacket;
    
    // Allocate audio queue buffers and fill them.
    for(int i = 0; i < kSCNumberOfBuffers; i++){
        AudioQueueAllocateBuffer(audioQueueObject, bufferByteSize, &buffers[i]);
        outputCallback((__bridge void*)self,audioQueueObject,buffers[i]);
    }
}
- (void)start {
    [self prepareAudioQueues];
    AudioQueueStart(audioQueueObject, NULL);
}
- (void)stop:(BOOL)shouldStopImmediately {
    AudioQueueStop(audioQueueObject, shouldStopImmediately);
	AudioQueueDispose(audioQueueObject, YES);
    free(renderBuffer);
}
- (void)dealloc
{
    free(renderBuffer);
    AudioQueueDispose(audioQueueObject, YES);
}

- (NSTimeInterval)timeElapsed {
    return self.renderedPackets / kSCSamplingFrameRate;
}
@end
