# WhisperMind 앱 UI/UX 디자인 가이드

## 1. 앱 소개 및 분석

WhisperMind는 상실과 슬픔에 특화된 AI 기반 저널링 애플리케이션으로, 사용자의 감정을 이해하고 치유하는 여정을 지원합니다. 사용자가 자신의 감정을 안전하게 표현하고 관리할 수 있는 디지털 공간을 제공합니다.

### 1.1 핵심 기능
- 감정 기록 및 일기 작성
- AI 기반 감정 분석
- 타임캡슐 (미래의 자신에게 메시지 전달)
- 추억 앨범 (소중한 기억 보관)
- 감정 추적 및 시각화
- 감정 회복 챌린지

### 1.2 타겟 사용자
- 상실을 경험한 성인 (가족, 친구, 반려동물 등)
- 정서적 지원이 필요한 사람들
- 자기 성찰 및 감정 관리에 관심 있는 사용자

## 2. 브랜드 아이덴티티

### 2.1 브랜드 철학
WhisperMind는 사용자의 내면의 목소리에 귀 기울이고, 감정을 안전하게 표현하며, 치유의 여정을 함께하는 디지털 동반자입니다. 디자인은 이 여정을 지원하는 안전하고 따뜻한 공간을 제공합니다.

### 2.2 색상 팔레트

#### 주요 컬러
- **딥 퍼플 (#6B4E98)**: 신뢰와 안정을 상징, 앱의 정체성을 나타내는 주요 컬러
- **라벤더 (#A284CF)**: 평온함과 치유를 상징, 주요 버튼 및 강조 요소
- **밤하늘 블루 (#304E7D)**: 깊이와 평온함을 제공, 이차 요소 및 강조점

#### 감정 컬러 시스템
- **슬픔 (#5E8BBA)**: 차분한 푸른색으로 슬픔의 감정을 표현
- **그리움 (#8884C4)**: 보라색 계열로 그리움과 아련함을 표현
- **분노 (#D16D6F)**: 차분한 적색으로 분노 감정을 표현
- **불안 (#D9A76A)**: 따뜻한 오렌지 계열로 불안 감정을 표현
- **희망 (#78B38A)**: 부드러운 녹색으로 희망과 회복을 표현
- **평온 (#7AD0DE)**: 하늘색 계열로 평온함을 표현

#### 중립 컬러
- **화이트 (#FFFFFF)**: 배경 및 카드 요소
- **오프 화이트 (#F8F5FF)**: 세컨더리 배경, 퍼플 틴트 적용
- **라이트 그레이 (#EFEAF7)**: 구분선 및 저강도 요소
- **미드 그레이 (#BBBAC1)**: 보조 텍스트
- **다크 그레이 (#574B6A)**: 주요 텍스트
- **나이트 (#232038)**: 다크 모드 배경

### 2.3 타이포그래피

#### 주요 서체
- **제목**: Nunito (산세리프)
  - 제목: Semi-Bold, 24pt
  - 부제목: Medium, 20pt
  - 섹션 제목: Medium, 18pt

- **본문**: Inter (산세리프)
  - 기본 텍스트: Regular, 16pt
  - 보조 텍스트: Light, 14pt
  - 캡션: Regular, 12pt

## 3. 디자인 원칙

### 3.1 핵심 원칙
1. **정서적 안전감 제공**
   - 부드러운 시각 요소
   - 급격한 변화나 날카로운 모서리 최소화
   - 사용자의 감정 상태를 고려한 인터페이스

2. **직관적 표현과 이해**
   - 감정 표현을 돕는 시각적 단서
   - 복잡하지 않은 인터페이스
   - 명확한 네비게이션 경로

3. **맞춤형 경험**
   - 사용자의 감정 상태에 반응하는 UI
   - 개인화된 콘텐츠 배치
   - 사용자 행동에 따른 적응형 인터페이스

4. **사려 깊은 피드백**
   - 사용자 행동에 대한 섬세한 응답
   - 긍정적인 강화와 지원적인 메시지
   - 비판적이지 않은 안내

5. **존중과 프라이버시**
   - 민감한 데이터에 대한 명확한 보안 표시
   - 사용자 통제권 강화
   - 프라이버시 설정의 접근성

## 4. UI 컴포넌트

### 4.1 기본 요소

#### 버튼
- **주요 버튼**: 라벤더 색상, 부드러운 그림자, 8px 둥근 모서리
- **보조 버튼**: 화이트 배경, 라벤더 테두리, 8px 둥근 모서리
- **텍스트 버튼**: 밑줄 없음, 호버 시 연한 배경
- **아이콘 버튼**: 원형, 투명 배경, 터치 영역 충분히 확보

#### 입력 필드
- **텍스트 필드**: 부드러운 배경, 최소 48px 높이, 라벤더 포커스 상태
- **검색 필드**: 둥근 모서리, 내장 아이콘, 즉각적 결과 표시
- **선택기**: 감정 태그, 날짜 선택기 등 직관적 시각 요소 활용

#### 카드
- **일기 카드**: 감정 색상 엣지, 부드러운 그림자, 미리보기 텍스트
- **활동 카드**: 이미지 영역, 간결한 설명, 선명한 CTA
- **통계 카드**: 데이터 시각화, 간결한 요약 텍스트, 확장 옵션

#### 탭 및 네비게이션
- **하단 탭 바**: 밝은 배경, 아이콘 및 라벨, 선택 상태 강조
- **세그먼트 컨트롤**: 일정 기간, 필터 등 선택을 위한 분할 컨트롤
- **진행 표시기**: 다단계 프로세스에서 현재 위치와 전체 과정 표시

### 4.2 특화 컴포넌트

#### 감정 선택기
- 직관적인 이모티콘 그리드
- 감정 강도 슬라이더 (1-10)
- 최근/자주 사용하는 감정 빠른 접근

#### 감정 트래커
- 주간/월간 감정 흐름 그래프
- 색상 코딩된 감정 분포 원형 차트
- 치유 여정 진행 표시기

#### 타임캡슐 컴포넌트
- 타임라인 기반 캡슐 표시
- 캡슐 상태 시각적 구분 (대기 중, 열람 가능, 완료)
- 특별한 열람 인터페이스 (애니메이션 효과)

#### 추억 앨범 컴포넌트
- 다양한 그리드 레이아웃
- 미디어 유형 표시
- 멀티미디어 미리보기 및 재생 컨트롤

#### 챌린지 컴포넌트
- 진행상황 표시기
- 일일 활동 카드
- 성취 배지 및 보상 시각화

## 5. 주요 화면 디자인

### 5.1 메인 홈 화면 (대시보드)

홈 화면은 사용자의 현재 감정 상태와 주요 기능에 빠르게 접근할 수 있는 중앙 허브 역할을 합니다.

#### 디자인 요소
- **헤더**: 앱 로고와 사용자 인사말, 프로필 아이콘
- **오늘의 감정**: 현재 감정 상태 이모티콘, 강도 표시기, 기록 시간
- **최근 감정 일기**: 최신 일기 미리보기 카드, 감정 태그 표시
- **추천 활동**: 수평 스크롤 가능한 활동 카드 3-4개
- **감정 요약 차트**: 주간 감정 변화 시각화, 트렌드 요약
- **다가오는 기념일**: 가장 가까운 기념일 알림
- **하단 네비게이션**: 5개 주요 섹션 아이콘과 중앙 플로팅 작성 버튼

#### 컬러 적용
- 배경: 부드러운 퍼플 그라데이션 (#F8F5FF → #F0E6FF)
- 카드 배경: 화이트 (#FFFFFF)
- 강조 요소: 딥 퍼플 (#6B4E98)
- 감정 시각화: 해당 감정 색상 (예: 평온함 - #7AD0DE)

#### 레이아웃
- 수직 스크롤 콘텐츠 구조
- 카드 기반 정보 표시
- 여백과 간격의 일관성

### 5.2 감정 일기 작성 화면

사용자가 감정을 선택하고 일기를 작성하는 핵심 기능 화면입니다.

#### 디자인 요소
- **단계 표시기**: 상단 진행 상태 표시
- **감정 선택 그리드**: 이모티콘 기반 감정 선택기
- **감정 강도 설정**: 슬라이더 컨트롤
- **감정 태그 선택기**: 태그 칩 UI
- **텍스트 에디터**: 깔끔한 작성 공간
- **미디어 추가 옵션**: 하단 도구 모음
- **저장/분석 버튼**: 하단 CTA 버튼

#### 컬러 적용
- 배경: 화이트 (#FFFFFF)
- 선택된 감정: 해당 감정 색상으로 강조
- 버튼: 라벤더 (#A284CF)
- 텍스트: 다크 그레이 (#574B6A)

### 5.3 통계 및 인사이트 화면

감정 추적 및 분석 결과를 시각적으로 표현하는 화면입니다.

#### 디자인 요소
- **기간 선택기**: 상단 세그먼트 컨트롤
- **감정 트렌드 차트**: 시간에 따른 감정 변화 라인 차트
- **감정 분포 도넛 차트**: 감정 비율 시각화
- **인사이트 카드**: AI 분석 결과 요약
- **주요 패턴**: 감정 패턴 하이라이트
- **관련 일기 링크**: 연관 일기 바로가기

#### 컬러 적용
- 배경: 오프 화이트 (#F8F5FF)
- 차트 요소: 감정 색상 시스템 활용
- 카드 배경: 화이트 (#FFFFFF)
- 강조 텍스트: 딥 퍼플 (#6B4E98)

## 6. 애니메이션 및 트랜지션

### 6.1 화면 전환
- 페이지 간 자연스러운 페이드/슬라이드 효과
- 모달 표시 시 부드러운 확대/축소
- 깊이감을 주는 계층적 전환

### 6.2 마이크로인터랙션
- 버튼 누름 효과: 스케일 감소 (95%) + 색상 변화
- 스와이프 액션 피드백
- 슬라이더 조작 시 부드러운 반응
- 성취 완료 시 축하 애니메이션

### 6.3 감정 시각화 애니메이션
- 감정 선택 시 부드러운 색상 변화
- 감정 강도 표현을 위한 파동 효과
- 통계 차트 로딩 애니메이션

## 7. 접근성 고려사항

### 7.1 색상 및 대비
- WCAG 2.1 AA 기준 준수 (대비율 최소 4.5:1)
- 색상만으로 정보를 구분하지 않음
- 감정 색상에 부가적인 텍스트 라벨 제공

### 7.2 터치 영역 및 네비게이션
- 모든 상호작용 요소 최소 44x44px 터치 영역
- 키보드 네비게이션 지원
- 논리적 포커스 순서

### 7.3 텍스트 및 가독성
- 최소 텍스트 크기 16pt
- 조절 가능한 텍스트 크기 (최대 200%)
- 충분한 줄 간격 및 문단 간격

### 7.4 보조 기술 지원
- 스크린 리더 호환성
- 적절한 대체 텍스트
- ARIA 속성 활용

## 8. 반응형 디자인 전략

### 8.1 모바일 우선 접근법
- 8점 그리드 시스템
- 일관된 여백 및 간격
- 기기별 최적화된 레이아웃

### 8.2 다양한 화면 크기 대응
- 스마트폰 세로 및 가로 모드
- 태블릿 레이아웃
- 요소 크기 및 간격 자동 조정

### 8.3 다크 모드 지원
- 자동/수동 다크 모드 전환
- 최적화된 다크 모드 색상 팔레트
- 요소별 명확한 대비 유지

## 9. 구현 가이드라인

### 9.1 개발 리소스
- Figma 디자인 에셋 라이브러리
- 컴포넌트 명세 및 동작 문서
- 애니메이션 타이밍 및 이징 함수 가이드

### 9.2 품질 관리
- 디자인 QA 체크리스트
- 접근성 검증 프로세스
- 사용자 테스트 가이드라인

### 9.3 확장성 고려사항
- 새로운 기능 추가를 위한 확장 가능한 구조
- 다국어 지원을 위한 텍스트 공간 확보
- 미래 플랫폼 확장 (웨어러블, 태블릿 등)

## 10. 결론

WhisperMind의 UI/UX 디자인은 감정적 안전감, 직관적 표현, 개인화된 경험이라는 핵심 원칙을 바탕으로 합니다. 부드러운 색상 팔레트, 친근한 타이포그래피, 감성적인 애니메이션을 통해 사용자가 자신의 감정을 안전하게 표현하고 치유의 여정을 함께 할 수 있는 디지털 공간을 제공합니다.

디자인은 단순히 시각적 요소를 넘어 사용자의 감정적 경험을 풍부하게 하는 도구로 기능합니다. WhisperMind는 이러한 디자인 철학을 통해 사용자가 자신의 감정을 이해하고 치유하는 과정을 돕는 진정한 디지털 동반자로 자리매김할 것입니다.