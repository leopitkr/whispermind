# WhisperMind 앱 데이터베이스 ERD

## 개체-관계 다이어그램 (ERD)

```
+---------------------+       +----------------------+       +---------------------+
|       Users         |       |     EmotionalJournals|       |    EmotionTags      |
+---------------------+       +----------------------+       +---------------------+
| PK: user_id         |       | PK: journal_id       |       | PK: tag_id          |
| email               |<----->| FK: user_id          |<----->| name                |
| password_hash       |       | title                |       | description         |
| name                |       | content              |       | color_code          |
| profile_image       |   1:N | emotion_intensity    |   N:M | category            |
| created_at          |       | recorded_date        |       | is_default          |
| last_login          |       | location             |       | created_at          |
| subscription_status |       | created_at           |       | updated_at          |
| subscription_expiry |       | updated_at           |       +---------------------+
| settings            |       | privacy_level        |
| status              |       | analysis_result      |       +---------------------+
+---------------------+       +----------------------+       |  JournalTags        |
        |                             |                      +---------------------+
        |                             |                      | PK: journal_tag_id  |
        |                      N:1    |                      | FK: journal_id      |
        |                      +----------------------+      | FK: tag_id          |
        |                      |    MediaAttachments   |     +---------------------+
        |                      +----------------------+
        |                      | PK: media_id         |      +---------------------+
        |                      | FK: journal_id       |      |  EmotionAnalysis    |
        |                      | type                 |      +---------------------+
        |                      | url                  |      | PK: analysis_id     |
        |                      | thumbnail_url        |      | FK: journal_id      |
        |                      | description          |      | primary_emotion     |
        |                      | created_at           |      | emotion_keywords    |
        |                      +----------------------+      | intensity_score     |
        |                                                    | pattern_identified  |
        |                                                    | recommendations     |
        |                                                    | created_at          |
        |              +---------------------+               +---------------------+
        |              |     TimeCapsules    |
        |              +---------------------+               +---------------------+
        |              | PK: capsule_id      |               |  Notifications      |
        |         1:N  | FK: user_id         |               +---------------------+
        +------------->| title               |               | PK: notification_id |
                       | message             |               | FK: user_id         |
                       | scheduled_date      |<--------------| type                |
                       | is_opened           |          1:N  | title               |
                       | recipient_type      |               | message             |
                       | created_at          |               | is_read             |
                       | updated_at          |               | created_at          |
                       +---------------------+               | action_url          |
                             |                               +---------------------+
                             |
                        N:1  |
                       +----------------------+
                       |  CapsuleAttachments  |
                       +----------------------+
                       | PK: attachment_id    |
                       | FK: capsule_id       |
                       | type                 |
                       | url                  |
                       | description          |
                       | created_at           |
                       +----------------------+

+---------------------+       +----------------------+       +---------------------+
|   MemoryAlbums      |       |    MemoryItems       |       |    Anniversaries    |
+---------------------+       +----------------------+       +---------------------+
| PK: album_id        |       | PK: item_id          |       | PK: anniversary_id  |
| FK: user_id         |<----->| FK: album_id         |       | FK: user_id         |
| title               |   1:N | type                 |       | title               |
| description         |       | url                  |       | description         |
| cover_image         |       | thumbnail_url        |       | date                |
| related_person      |       | title                |       | repeat_type         |
| tags                |       | description          |       | reminder_days       |
| created_at          |       | recorded_date        |       | created_at          |
| updated_at          |       | tags                 |       | updated_at          |
+---------------------+       | created_at           |       +---------------------+
                              | updated_at           |
                              +----------------------+

+---------------------+       +----------------------+       +---------------------+
|     Challenges      |       |   ChallengeActivities|       |   UserChallenges    |
+---------------------+       +----------------------+       +---------------------+
| PK: challenge_id    |       | PK: activity_id      |       | PK: user_challenge_id|
| title               |<----->| FK: challenge_id     |<----->| FK: user_id         |
| description         |   1:N | title                |   1:N | FK: challenge_id    |
| duration_days       |       | description          |       | start_date          |
| difficulty          |       | day_number           |       | current_day         |
| category            |       | activity_type        |       | status              |
| cover_image         |       | completion_criteria  |       | completed_activities|
| created_at          |       | created_at           |       | completed_at        |
| updated_at          |       | updated_at           |       | created_at          |
+---------------------+       +----------------------+       | updated_at          |
                                                             +---------------------+

+---------------------+       +----------------------+
|   EmotionDiagnosis  |       |   CommunityPosts     |
+---------------------+       +----------------------+
| PK: diagnosis_id    |       | PK: post_id          |
| FK: user_id         |       | FK: user_id          |
| diagnosis_date      |       | anonymous_name       |
| emotional_state     |       | title                |
| primary_emotions    |       | content              |
| balance_score       |       | emotion_tag          |
| insights            |       | likes_count          |
| recommendations     |       | comments_count       |
| prev_diagnosis_id   |       | created_at           |
| created_at          |       | updated_at           |
+---------------------+       | status               |
                              +----------------------+
                                        |
                                        |
                                   1:N  |
                              +----------------------+
                              |   CommunityComments  |
                              +----------------------+
                              | PK: comment_id       |
                              | FK: post_id          |
                              | FK: user_id          |
                              | anonymous_name       |
                              | content              |
                              | likes_count          |
                              | created_at           |
                              | updated_at           |
                              | status               |
                              +----------------------+

+---------------------+
|  EmotionStatistics  |
+---------------------+
| PK: stat_id         |
| FK: user_id         |
| date                |
| period_type         |
| emotion_distribution|
| primary_emotion     |
| average_intensity   |
| journal_count       |
| created_at          |
| updated_at          |
+---------------------+
```

## 엔티티 및 속성 설명

### 1. Users (사용자)
- **user_id**: 사용자 고유 식별자 (기본키)
- **email**: 로그인 이메일
- **password_hash**: 암호화된 비밀번호
- **name**: 사용자 이름
- **profile_image**: 프로필 이미지 URL
- **created_at**: 계정 생성 일시
- **last_login**: 마지막 로그인 일시
- **subscription_status**: 구독 상태 (무료, 프리미엄 등)
- **subscription_expiry**: 구독 만료 일자
- **settings**: 사용자 설정 (JSON)
- **status**: 계정 상태 (활성, 비활성 등)

### 2. EmotionalJournals (감정 일기)
- **journal_id**: 일기 고유 식별자 (기본키)
- **user_id**: 작성자 ID (외래키)
- **title**: 일기 제목
- **content**: 일기 내용
- **emotion_intensity**: 감정 강도 (1-10)
- **recorded_date**: 기록 일자
- **location**: 위치 정보 (선택적)
- **created_at**: 생성 일시
- **updated_at**: 수정 일시
- **privacy_level**: 개인정보 보호 수준
- **analysis_result**: 분석 결과 참조

### 3. EmotionTags (감정 태그)
- **tag_id**: 태그 고유 식별자 (기본키)
- **name**: 태그 이름 (슬픔, 그리움, 분노 등)
- **description**: 태그 설명
- **color_code**: 색상 코드
- **category**: 태그 카테고리
- **is_default**: 기본 제공 태그 여부
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

### 4. JournalTags (일기-태그 연결)
- **journal_tag_id**: 연결 고유 식별자 (기본키)
- **journal_id**: 일기 ID (외래키)
- **tag_id**: 태그 ID (외래키)

### 5. MediaAttachments (미디어 첨부)
- **media_id**: 미디어 고유 식별자 (기본키)
- **journal_id**: 관련 일기 ID (외래키)
- **type**: 미디어 유형 (이미지, 오디오, 비디오)
- **url**: 미디어 파일 URL
- **thumbnail_url**: 썸네일 URL
- **description**: 미디어 설명
- **created_at**: 생성 일시

### 6. EmotionAnalysis (감정 분석)
- **analysis_id**: 분석 고유 식별자 (기본키)
- **journal_id**: 관련 일기 ID (외래키)
- **primary_emotion**: 주요 감정
- **emotion_keywords**: 감정 키워드 (배열/JSON)
- **intensity_score**: 감정 강도 점수
- **pattern_identified**: 식별된 패턴
- **recommendations**: 추천 활동 (배열/JSON)
- **created_at**: 생성 일시

### 7. TimeCapsules (타임캡슐)
- **capsule_id**: 캡슐 고유 식별자 (기본키)
- **user_id**: 작성자 ID (외래키)
- **title**: 캡슐 제목
- **message**: 캡슐 메시지
- **scheduled_date**: 열람 예정 일시
- **is_opened**: 열람 여부
- **recipient_type**: 수신자 유형 (미래의 나, 특정인 등)
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

### 8. CapsuleAttachments (타임캡슐 첨부)
- **attachment_id**: 첨부 고유 식별자 (기본키)
- **capsule_id**: 관련 캡슐 ID (외래키)
- **type**: 첨부 유형 (이미지, 오디오 등)
- **url**: 첨부 파일 URL
- **description**: 첨부 설명
- **created_at**: 생성 일시

### 9. Notifications (알림)
- **notification_id**: 알림 고유 식별자 (기본키)
- **user_id**: 사용자 ID (외래키)
- **type**: 알림 유형 (타임캡슐, 기념일, 활동 등)
- **title**: 알림 제목
- **message**: 알림 메시지
- **is_read**: 읽음 여부
- **created_at**: 생성 일시
- **action_url**: 알림 관련 액션 URL

### 10. MemoryAlbums (추억 앨범)
- **album_id**: 앨범 고유 식별자 (기본키)
- **user_id**: 소유자 ID (외래키)
- **title**: 앨범 제목
- **description**: 앨범 설명
- **cover_image**: 커버 이미지 URL
- **related_person**: 관련 인물/반려동물
- **tags**: 앨범 태그 (배열/JSON)
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

### 11. MemoryItems (추억 항목)
- **item_id**: 항목 고유 식별자 (기본키)
- **album_id**: 소속 앨범 ID (외래키)
- **type**: 항목 유형 (사진, 비디오, 오디오, 텍스트)
- **url**: 미디어 파일 URL
- **thumbnail_url**: 썸네일 URL
- **title**: 항목 제목
- **description**: 항목 설명
- **recorded_date**: 기록 일자
- **tags**: 항목 태그 (배열/JSON)
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

### 12. Anniversaries (기념일)
- **anniversary_id**: 기념일 고유 식별자 (기본키)
- **user_id**: 사용자 ID (외래키)
- **title**: 기념일 제목
- **description**: 기념일 설명
- **date**: 기념일 날짜
- **repeat_type**: 반복 유형 (매년, 매월 등)
- **reminder_days**: 미리 알림 일수
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

### 13. Challenges (챌린지)
- **challenge_id**: 챌린지 고유 식별자 (기본키)
- **title**: 챌린지 제목
- **description**: 챌린지 설명
- **duration_days**: 지속 일수
- **difficulty**: 난이도
- **category**: 카테고리
- **cover_image**: 커버 이미지 URL
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

### 14. ChallengeActivities (챌린지 활동)
- **activity_id**: 활동 고유 식별자 (기본키)
- **challenge_id**: 챌린지 ID (외래키)
- **title**: 활동 제목
- **description**: 활동 설명
- **day_number**: 활동 일차
- **activity_type**: 활동 유형
- **completion_criteria**: 완료 기준
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

### 15. UserChallenges (사용자 챌린지)
- **user_challenge_id**: 사용자 챌린지 고유 식별자 (기본키)
- **user_id**: 사용자 ID (외래키)
- **challenge_id**: 챌린지 ID (외래키)
- **start_date**: 시작 일자
- **current_day**: 현재 일차
- **status**: 상태 (진행 중, 완료, 포기 등)
- **completed_activities**: 완료한 활동 (배열/JSON)
- **completed_at**: 완료 일시
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

### 16. EmotionDiagnosis (감정 진단)
- **diagnosis_id**: 진단 고유 식별자 (기본키)
- **user_id**: 사용자 ID (외래키)
- **diagnosis_date**: 진단 일자
- **emotional_state**: 감정 상태 요약
- **primary_emotions**: 주요 감정 (배열/JSON)
- **balance_score**: 감정 균형 점수
- **insights**: 인사이트 (JSON)
- **recommendations**: 권장 사항 (JSON)
- **prev_diagnosis_id**: 이전 진단 ID (자기 참조)
- **created_at**: 생성 일시

### 17. CommunityPosts (커뮤니티 게시물)
- **post_id**: 게시물 고유 식별자 (기본키)
- **user_id**: 작성자 ID (외래키)
- **anonymous_name**: 익명 닉네임
- **title**: 게시물 제목
- **content**: 게시물 내용
- **emotion_tag**: 감정 태그
- **likes_count**: 공감 수
- **comments_count**: 댓글 수
- **created_at**: 생성 일시
- **updated_at**: 수정 일시
- **status**: 상태 (활성, 비활성 등)

### 18. CommunityComments (커뮤니티 댓글)
- **comment_id**: 댓글 고유 식별자 (기본키)
- **post_id**: 게시물 ID (외래키)
- **user_id**: 작성자 ID (외래키)
- **anonymous_name**: 익명 닉네임
- **content**: 댓글 내용
- **likes_count**: 공감 수
- **created_at**: 생성 일시
- **updated_at**: 수정 일시
- **status**: 상태 (활성, 비활성 등)

### 19. EmotionStatistics (감정 통계)
- **stat_id**: 통계 고유 식별자 (기본키)
- **user_id**: 사용자 ID (외래키)
- **date**: 통계 날짜
- **period_type**: 기간 유형 (일간, 주간, 월간, 연간)
- **emotion_distribution**: 감정 분포 (JSON)
- **primary_emotion**: 주요 감정
- **average_intensity**: 평균 감정 강도
- **journal_count**: 일기 작성 수
- **created_at**: 생성 일시
- **updated_at**: 수정 일시

## 관계 설명

1. **Users -> EmotionalJournals**: 1:N (한 사용자는 여러 감정 일기를 작성할 수 있음)
2. **Users -> TimeCapsules**: 1:N (한 사용자는 여러 타임캡슐을 생성할 수 있음)
3. **Users -> MemoryAlbums**: 1:N (한 사용자는 여러 추억 앨범을 가질 수 있음)
4. **Users -> Notifications**: 1:N (한 사용자는 여러 알림을 받을 수 있음)
5. **Users -> UserChallenges**: 1:N (한 사용자는 여러 챌린지에 참여할 수 있음)
6. **Users -> EmotionDiagnosis**: 1:N (한 사용자는 여러 감정 진단을 받을 수 있음)
7. **EmotionalJournals <-> EmotionTags**: N:M (JournalTags 테이블을 통해 연결)
8. **EmotionalJournals -> MediaAttachments**: 1:N (한 일기에 여러 미디어를 첨부할 수 있음)
9. **EmotionalJournals -> EmotionAnalysis**: 1:1 (각 일기는 하나의 감정 분석 결과를 가짐)
10. **TimeCapsules -> CapsuleAttachments**: 1:N (한 타임캡슐에 여러 첨부파일을 포함할 수 있음)
11. **MemoryAlbums -> MemoryItems**: 1:N (한 앨범에 여러 추억 항목을 포함할 수 있음)
12. **Challenges -> ChallengeActivities**: 1:N (한 챌린지는 여러 활동으로 구성됨)
13. **Challenges <-> Users**: N:M (UserChallenges 테이블을 통해 연결)
14. **CommunityPosts -> CommunityComments**: 1:N (한 게시물에 여러 댓글을 달 수 있음)

이 ERD는 WhisperMind 앱의 데이터 구조를 기반으로 설계되었으며, Firebase Firestore 또는 관계형 데이터베이스 시스템에서 구현할 수 있습니다. 실제 구현 시에는 성능 최적화 및 확장성을 고려한 추가 설계가 필요할 수 있습니다.