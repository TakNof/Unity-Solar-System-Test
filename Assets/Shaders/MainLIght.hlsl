void MainLight_half(float3 WorldPos, out half3 Direction, out half3 Color, out half DistanceAtten, out half ShadowAtten)
{
    #if SHADERGRAPH_PREVIEW
        Direction = half3(0.5, 0.5, 0);
        Color = 1;
        DistanceAtten = 1;
        ShadowAtten = 1;
    #else
        #if !defined(_MAIN_LIGHT_SHADOWS) || defined(_RECEIVE_SHADOWS_OFF)
            ShadowAtten = 1.0h;
        #endif

        #if SHADOWS_SCREEN
            half4 clipPos = TransformWorldToHClip(WorldPos);
            half4 shadowCoord = ComputeScreenPos(clipPos);
            ShadowAtten = SampleScreenSpaceShadowmap(shadowCoord);
        #else
            half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
            ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
            half shadowStrength = GetMainLightShadowStrength();
            ShadowAtten = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture,
            sampler_MainLightShadowmapTexture),
            shadowSamplingData, shadowStrength, false);
        #endif

        Light mainLight = GetMainLight(shadowCoord);
        Direction = mainLight.direction;
        Color = mainLight.color;    
        DistanceAtten = mainLight.distanceAttenuation;
    #endif
}