// 매 프레임 연산을 건너뛰기 위한 토글 변수
var skipFrame:Bool = false;

override function update(elapsed:Float) {
    // 1. 프레임 스킵 토글 (한 프레임은 true, 다음 프레임은 false)
    skipFrame = !skipFrame;

    // 현재 플레이스테이트의 모든 멤버(오브젝트/그룹) 목록을 긁어옴
    var allObjects:Array<Dynamic> = FlxG.state.members;

    for (obj in allObjects) {
        if (obj == null) continue;

        // [픽셀 퍼펙트 정수 연산 강제] 
        // 소수점 단위의 무거운 그래픽 행렬 연산을 제거해 CPU/GPU 오버헤드를 극적으로 줄임
        if (obj.pixelPerfectRender != null && !obj.pixelPerfectRender) {
            obj.pixelPerfectRender = true;
        }

        // [핵심 최적화: 움직이는 오브젝트 연산 반토막]
        // 캐릭터(보프, 불칸보어)와 HUD(노트, UI)는 60fps로 정밀하게 굴리고, 
        // 움직이는 배경 덩어리나 FlxSpriteGroup들은 30fps 속도로만 좌표를 갱신하도록 스킵함.
        if (Std.isOfType(obj, Character) || (obj.cameras != null && obj.cameras.contains(camHUD))) {
            // 주요 캐릭터와 UI는 매 프레임(60fps) 정상 연산
            continue; 
        }

        // 배경이나 일반 움직이는 오브젝트들은 한 프레임씩 건너뛰며 연산하게 강제 제어
        if (obj.active != null) {
            obj.active = skipFrame; 
            // active가 false가 되는 프레임에는 좌표 이동 연산 루프를 통째로 패스함 (CPU 자원 확보)
        }
    }

    // 2. 엔진 원본의 전체 시스템 업데이트 실행
    super.update(elapsed);
}
