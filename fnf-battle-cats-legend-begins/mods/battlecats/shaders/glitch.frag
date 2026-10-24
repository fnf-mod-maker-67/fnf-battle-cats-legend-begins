#pragma header

uniform float iTime;
uniform float uIntensity;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = openfl_TextureCoordv;
    
    float glitchTime = floor(iTime * 20.0);
    float noise = rand(vec2(floor(uv.y * 35.0), glitchTime));
    
    if (noise < 0.25 * uIntensity) {
        float offset = (rand(vec2(glitchTime, uv.y)) - 0.5) * 0.04 * uIntensity;
        uv.x = clamp(uv.x + offset, 0.0, 1.0);
    }

    vec4 col = flixel_texture2D(bitmap, uv);

    if (noise < 0.15 * uIntensity) {
        float split = 0.01 * uIntensity;
        vec2 uvR = vec2(clamp(uv.x + split, 0.0, 1.0), uv.y);
        vec2 uvB = vec2(clamp(uv.x - split, 0.0, 1.0), uv.y);
        col.r = flixel_texture2D(bitmap, uvR).r;
        col.b = flixel_texture2D(bitmap, uvB).b;
    }

    gl_FragColor = col;
}