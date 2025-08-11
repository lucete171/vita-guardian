// Flutter UI 시안 — main.dart
// 목적: 사용자가 요청한 초록색 중심의 건강관리 앱 메인 화면 UI 시안
// 메모: 백엔드/센서 연동 포인트는 TODO 주석으로 표시

import 'package:flutter/material.dart';

void main() {
  runApp(HealthApp());
}

class HealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenHealth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        scaffoldBackgroundColor: Color(0xFFF7FBF7),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 더미 데이터 (실제 연동 시 Health API나 센서 데이터로 교체)
  int steps = 7423;
  int stepGoal = 10000;
  int heartRate = 72;
  int spo2 = 97;
  int waterMl = 1200;

  int _selectedIndex = 0;

  double get stepProgress => (steps / stepGoal).clamp(0.0, 1.0);

  void _onNavTap(int idx) {
    setState(() {
      _selectedIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(),
              SizedBox(height: 16),
              _buildProgressRow(),
              SizedBox(height: 18),
              _buildMetricCards(),
              SizedBox(height: 18),
              _buildActionButtons(),
              SizedBox(height: 12),
              Expanded(child: _buildRecommendations()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('오늘의 건강'),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none),
          onPressed: () {
            // TODO: 알림 화면으로 이동
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.person, color: Color(0xFF388E3C)),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, 김우진님',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              '오늘 상태를 한눈에 확인하세요',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('08월 11일', style: TextStyle(color: Colors.black45)),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.wb_sunny, size: 16, color: Colors.orangeAccent),
                SizedBox(width: 6),
                Text('맑음 26°C', style: TextStyle(color: Colors.black45)),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buildProgressRow() {
    return Row(
      children: [
        _buildCircularStepProgress(),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('오늘의 걸음', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
              Text('$steps 걸음 / $stepGoal 걸음', style: TextStyle(color: Colors.black54)),
              SizedBox(height: 12),
              LinearProgressIndicator(value: stepProgress, minHeight: 8, backgroundColor: Color(0xFFE8F5E9), valueColor: AlwaysStoppedAnimation(Color(0xFF4CAF50))),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('목표까지 ${( (1-stepProgress)*stepGoal ).ceil()} 걸음 남음', style: TextStyle(fontSize: 12, color: Colors.black45)),
                  Text('활동량: 중간', style: TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCircularStepProgress() {
    return Container(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: CircularProgressIndicator(
              value: stepProgress,
              strokeWidth: 8,
              backgroundColor: Color(0xFFE8F5E9),
              valueColor: AlwaysStoppedAnimation(Color(0xFF4CAF50)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${(stepProgress*100).round()}%', style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('걸음', style: TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMetricCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _metricCard('심박수', '$heartRate bpm', Icons.favorite, Colors.redAccent),
        _metricCard('산소포화도', '$spo2%', Icons.bubble_chart, Colors.blueAccent),
        _metricCard('수분', '${(waterMl/1000).toStringAsFixed(1)}L', Icons.local_drink, Colors.teal),
      ],
    );
  }

  Widget _metricCard(String title, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 13, color: Colors.black54)),
                Icon(icon, color: iconColor, size: 20),
              ],
            ),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            SizedBox(height: 6),
            Text('최근 측정: 10분 전', style: TextStyle(fontSize: 11, color: Colors.black38)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: AI 분석 API 호출
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF388E3C),
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('AI 건강 분석', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        SizedBox(width: 12),
        OutlinedButton(
          onPressed: () {
            // TODO: 식단 추천 로직 또는 화면으로 이동
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: Color(0xFF81C784)),
          ),
          child: Row(
            children: [
              Icon(Icons.restaurant_menu, color: Color(0xFF388E3C)),
              SizedBox(width: 8),
              Text('식단 추천', style: TextStyle(color: Color(0xFF388E3C), fontWeight: FontWeight.w600)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRecommendations() {
    return ListView(
      children: [
        _recommendationCard(
          title: '오늘의 추천 식단',
          subtitle: '단백질 중심 · 1800 kcal',
          details: '현 활동량과 수분 섭취를 고려한 균형 식단입니다. 아침: 그릭요거트, 점심: 닭가슴살 샐러드, 저녁: 연어구이',
        ),
        SizedBox(height: 12),
        _recommendationCard(
          title: '건강 리포트',
          subtitle: '심혈관 위험도: 낮음',
          details: '심박수와 산소포화도는 정상 범위 내에 있으나, 활동량을 더 늘리면 혈관 건강에 추가 이득이 있습니다.',
        ),
        SizedBox(height: 12),
        _recommendationCard(
          title: '수분 권장',
          subtitle: '하루 목표 2.5L 중 1.2L 섭취',
          details: '다음 3시간 안에 400ml 섭취 권장',
        ),
      ],
    );
  }

  Widget _recommendationCard({required String title, required String subtitle, required String details}) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
              Text(subtitle, style: TextStyle(color: Colors.black45, fontSize: 12)),
            ],
          ),
          SizedBox(height: 8),
          Text(details, style: TextStyle(color: Colors.black54, fontSize: 13)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // TODO: 자세히 보기
                },
                child: Text('자세히', style: TextStyle(color: Color(0xFF4CAF50))),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onNavTap,
      selectedItemColor: Color(0xFF2E7D32),
      unselectedItemColor: Colors.black54,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.insert_chart_outlined), label: '리포트'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: '기록'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}

/*
추가 구현 가이드 (요약)
- 센서/헬스 연동: Google Fit / Apple HealthKit / 삼성 헬스 SDK 사용
- AI 분석: 서버에서 모델을 운영하고, 요약 결과를 JSON으로 앱에 전달
- 로컬 모델: TensorFlow Lite 또는 ONNX로 변환하여 일부 추론을 기기 내에서 수행
- 데이터 저장: 로컬 캐시(SQLite) + 원격 동기화(Firebase 등)
- 접근성: 폰트 크기, 다크모드 고려
*/
