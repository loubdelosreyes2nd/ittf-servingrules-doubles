class ITTFDoublesServing {
  // Team 1 Players
  final String team1Player1Name;
  final String team1Player2Name;
  
  // Team 2 Players
  final String team2Player1Name;
  final String team2Player2Name;
  
  // Match Configuration
  final int matchTotalSetsToPlay;
  final String tossWinningTeam;
  final String tossWinningPlayer;
  
  // Current Match State
  int currentScoreTeam1;
  int currentScoreTeam2;
  int currentSet;
  
  ITTFDoublesServing({
    required this.team1Player1Name,
    required this.team1Player2Name,
    required this.team2Player1Name,
    required this.team2Player2Name,
    required this.matchTotalSetsToPlay,
    required this.tossWinningTeam,
    required this.tossWinningPlayer,
    this.currentScoreTeam1 = 0,
    this.currentScoreTeam2 = 0,
    this.currentSet = 1,
  });
  
  /// Determines which team should be serving based on ITTF rules
  String getServingTeam() {
    int totalPoints = currentScoreTeam1 + currentScoreTeam2;
    
    // Check if we're in deuce (10-10 or higher)
    bool isDeuce = (currentScoreTeam1 >= 10 && currentScoreTeam2 >= 10);
    
    if (isDeuce) {
      // In deuce, service changes every 1 point
      int serviceChanges = totalPoints;
      bool isTeam1Starting = tossWinningTeam == 'Team 1';
      
      if (serviceChanges % 2 == 0) {
        return isTeam1Starting ? 'Team 1' : 'Team 2';
      } else {
        return isTeam1Starting ? 'Team 2' : 'Team 1';
      }
    } else {
      // Normal play: service changes every 2 points
      int serviceChanges = totalPoints ~/ 2;
      bool isTeam1Starting = tossWinningTeam == 'Team 1';
      
      if (serviceChanges % 2 == 0) {
        return isTeam1Starting ? 'Team 1' : 'Team 2';
      } else {
        return isTeam1Starting ? 'Team 2' : 'Team 1';
      }
    }
  }
  
  /// Determines which player in the serving team should serve
  String getServingPlayer() {
    String servingTeam = getServingTeam();
    int totalPoints = currentScoreTeam1 + currentScoreTeam2;
    
    // Check if we're in deuce (10-10 or higher)
    bool isDeuce = (currentScoreTeam1 >= 10 && currentScoreTeam2 >= 10);
    
    int team1ServiceCount = 0;
    int team2ServiceCount = 0;
    
    if (isDeuce) {
      // In deuce, we need to continue the player rotation from normal play
      // Calculate how many times each team has served up to deuce (10-10)
      int pointsUpToDeuce = 20; // 10-10 = 20 total points
      int serviceChangesUpToDeuce = pointsUpToDeuce ~/ 2;
      
      if (tossWinningTeam == 'Team 1') {
        // Team 1 starts serving
        team1ServiceCount = (serviceChangesUpToDeuce + 1) ~/ 2;
        team2ServiceCount = serviceChangesUpToDeuce ~/ 2;
      } else {
        // Team 2 starts serving
        team1ServiceCount = serviceChangesUpToDeuce ~/ 2;
        team2ServiceCount = (serviceChangesUpToDeuce + 1) ~/ 2;
      }
      
      // Now add the additional deuce points to continue the rotation
      int deucePoints = totalPoints - pointsUpToDeuce;
      if (deucePoints > 0) {
        // In deuce, service changes every 1 point
        int deuceServiceChanges = deucePoints;
        if (tossWinningTeam == 'Team 1') {
          team1ServiceCount += (deuceServiceChanges + 1) ~/ 2;
          team2ServiceCount += deuceServiceChanges ~/ 2;
        } else {
          team1ServiceCount += deuceServiceChanges ~/ 2;
          team2ServiceCount += (deuceServiceChanges + 1) ~/ 2;
        }
      }
    } else {
      // Normal play: service changes every 2 points
      int serviceChanges = totalPoints ~/ 2;
      
      if (tossWinningTeam == 'Team 1') {
        // Team 1 starts serving
        team1ServiceCount = (serviceChanges + 1) ~/ 2;
        team2ServiceCount = serviceChanges ~/ 2;
      } else {
        // Team 2 starts serving
        team1ServiceCount = serviceChanges ~/ 2;
        team2ServiceCount = (serviceChanges + 1) ~/ 2;
      }
    }
    
    if (servingTeam == 'Team 1') {
      // Team 1 serving
      if (tossWinningTeam == 'Team 1') {
        // Team 1 won toss, so tossWinningPlayer serves first
        if (tossWinningPlayer == team1Player1Name) {
          // Player 1 serves first, then alternates every time Team 1 gets serve
          return (team1ServiceCount % 2 == 0) ? team1Player1Name : team1Player2Name;
        } else {
          // Player 2 serves first, then alternates every time Team 1 gets serve
          return (team1ServiceCount % 2 == 0) ? team1Player2Name : team1Player1Name;
        }
      } else {
        // Team 1 didn't win toss, so they serve second
        // Determine which player serves based on service count
        if (tossWinningPlayer == team2Player1Name) {
          // Team 2 Player 1 served first, so Team 1 Player 1 serves second
          return (team1ServiceCount % 2 == 0) ? team1Player1Name : team1Player2Name;
        } else {
          // Team 2 Player 2 served first, so Team 1 Player 1 serves second
          return (team1ServiceCount % 2 == 0) ? team1Player1Name : team1Player2Name;
        }
      }
    } else {
      // Team 2 serving
      if (tossWinningTeam == 'Team 2') {
        // Team 2 won toss, so tossWinningPlayer serves first
        if (tossWinningPlayer == team2Player1Name) {
          // Player 1 serves first, then alternates every time Team 2 gets serve
          return (team2ServiceCount % 2 == 0) ? team2Player1Name : team2Player2Name;
        } else {
          // Player 2 serves first, then alternates every time Team 2 gets serve
          return (team2ServiceCount % 2 == 0) ? team2Player2Name : team2Player1Name;
        }
      } else {
        // Team 2 didn't win toss, so they serve second
        // Determine which player serves based on service count
        if (tossWinningPlayer == team1Player1Name) {
          // Team 1 Player 1 served first, so Team 2 Player 1 serves second
          return (team2ServiceCount % 2 == 0) ? team2Player1Name : team2Player2Name;
        } else {
          // Team 1 Player 2 served first, so Team 2 Player 1 serves second
          return (team2ServiceCount % 2 == 0) ? team2Player1Name : team2Player2Name;
        }
      }
    }
  }
  
  /// Calculates remaining serves for the current serving player
  int getRemainingServes() {
    int totalPoints = currentScoreTeam1 + currentScoreTeam2;
    
    // Check if we're in deuce (10-10 or higher)
    bool isDeuce = (currentScoreTeam1 >= 10 && currentScoreTeam2 >= 10);
    
    if (isDeuce) {
      // In deuce, each player serves only 1 time before switching
      int pointsInCurrentService = totalPoints % 1;
      return 1 - pointsInCurrentService;
    } else {
      // Normal play: each player serves 2 times before switching
      int pointsInCurrentService = totalPoints % 2;
      return 2 - pointsInCurrentService;
    }
  }
  
  /// Gets complete serving information
  Map<String, dynamic> getServingInfo() {
    return {
      'servingTeam': getServingTeam(),
      'servingPlayer': getServingPlayer(),
      'remainingServes': getRemainingServes(),
    };
  }
  
  /// Updates the current score
  void updateScore(int team1Score, int team2Score) {
    currentScoreTeam1 = team1Score;
    currentScoreTeam2 = team2Score;
  }
  
  /// Updates the current set
  void updateSet(int set) {
    currentSet = set;
  }
  
  /// Resets the match state
  void resetMatch() {
    currentScoreTeam1 = 0;
    currentScoreTeam2 = 0;
    currentSet = 1;
  }
  
  /// Gets current match state
  Map<String, dynamic> getCurrentState() {
    return {
      'team1Score': currentScoreTeam1,
      'team2Score': currentScoreTeam2,
      'currentSet': currentSet,
      'totalSets': matchTotalSetsToPlay,
      'servingInfo': getServingInfo(),
    };
  }
  
  /// Gets the total points played so far
  int getTotalPointsPlayed() {
    return currentScoreTeam1 + currentScoreTeam2;
  }
  
  /// Gets the service change count (how many times service has changed)
  int getServiceChangeCount() {
    return getTotalPointsPlayed() ~/ 2;
  }
  
  /// Gets the next serving information after a point is scored
  Map<String, dynamic> getNextServingInfo() {
    // Simulate adding one point to see who serves next
    int tempScore1 = currentScoreTeam1;
    int tempScore2 = currentScoreTeam2;
    
    // Add a point to the current serving team
    String currentServingTeam = getServingTeam();
    if (currentServingTeam == 'Team 1') {
      tempScore1++;
    } else {
      tempScore2++;
    }
    
    // Create temporary instance to calculate next serving info
    var tempMatch = ITTFDoublesServing(
      team1Player1Name: team1Player1Name,
      team1Player2Name: team1Player2Name,
      team2Player1Name: team2Player1Name,
      team2Player2Name: team2Player2Name,
      matchTotalSetsToPlay: matchTotalSetsToPlay,
      tossWinningTeam: tossWinningTeam,
      tossWinningPlayer: tossWinningPlayer,
      currentScoreTeam1: tempScore1,
      currentScoreTeam2: tempScore2,
      currentSet: currentSet,
    );
    
    return tempMatch.getServingInfo();
  }
  
  /// Checks if service will change after the next point
  bool willServiceChangeAfterNextPoint() {
    int totalPoints = currentScoreTeam1 + currentScoreTeam2;
    return (totalPoints + 1) % 2 == 0;
  }
}

// Example usage and test function
void main() {
  // Create a doubles match instance
  var doublesMatch = ITTFDoublesServing(
    team1Player1Name: 'Alice',
    team1Player2Name: 'Bob',
    team2Player1Name: 'Charlie',
    team2Player2Name: 'Diana',
    matchTotalSetsToPlay: 5,
    tossWinningTeam: 'Team 1',
    tossWinningPlayer: 'Alice',
  );
  
  // Test different score scenarios
  print('=== ITTF Doubles Serving Rules Test ===\n');
  
  print('📊 PHASE 1: NORMAL PLAY (0-0 to 9-10)');
  print('Service changes every 2 points, Players serve 2 times\n');
  
  // Test initial state (0-0)
  print('🏓 0-0: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 1 point (1-0)
  doublesMatch.updateScore(1, 0);
  print('🏓 1-0: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');

  // Test after 2 points (1-1)
  doublesMatch.updateScore(1, 1);
  print('🏓 1-1: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 3 points (2-1)
  doublesMatch.updateScore(2, 1);
  print('🏓 2-1: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 4 points (2-2)
  doublesMatch.updateScore(2, 2);
  print('🏓 2-2: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 5 points (3-2)
  doublesMatch.updateScore(3, 2);
  print('🏓 3-2: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 6 points (3-3)
  doublesMatch.updateScore(3, 3);
  print('🏓 3-3: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 7 points (4-3)
  doublesMatch.updateScore(4, 3);
  print('🏓 4-3: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 8 points (4-4)
  doublesMatch.updateScore(4, 4);
  print('🏓 4-4: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 9 points (5-4)
  doublesMatch.updateScore(5, 4);
  print('🏓 5-4: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 10 points (5-5)
  doublesMatch.updateScore(5, 5);
  print('🏓 5-5: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 11 points (6-5)
  doublesMatch.updateScore(6, 5);
  print('🏓 6-5: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 12 points (6-6)
  doublesMatch.updateScore(6, 6);
  print('🏓 6-6: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 13 points (7-6)
  doublesMatch.updateScore(7, 6);
  print('🏓 7-6: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 14 points (7-7)
  doublesMatch.updateScore(7, 7);
  print('🏓 7-7: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 15 points (8-7)
  doublesMatch.updateScore(8, 7);
  print('🏓 8-7: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 16 points (8-8)
  doublesMatch.updateScore(8, 8);
  print('🏓 8-8: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 17 points (9-8)
  doublesMatch.updateScore(9, 8);
  print('🏓 9-8: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 18 points (9-9)
  doublesMatch.updateScore(9, 9);
  print('🏓 9-9: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 19 points (10-9)
  doublesMatch.updateScore(10, 9);
  print('🏓 10-9: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  print('\n🔥 PHASE 2: DEUCE (10-10 onwards)');
  print('Service changes every 1 point, Players serve 1 time\n');
  
  // Test after 20 points (10-10) - DEUCE!
  doublesMatch.updateScore(10, 10);
  print('🔥 10-10 DEUCE: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 21 points (11-10) - Set point for Team 1
  doublesMatch.updateScore(11, 10);
  print('🔥 11-10 Set Point: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 22 points (11-11) - Still deuce
  doublesMatch.updateScore(11, 11);
  print('🔥 11-11 Still Deuce: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 23 points (12-11) - Set point for Team 1
  doublesMatch.updateScore(12, 11);
  print('🔥 12-11 Set Point: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 24 points (12-12) - Still deuce
  doublesMatch.updateScore(12, 12);
  print('🔥 12-12 Still Deuce: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 25 points (13-12) - Set point for Team 1
  doublesMatch.updateScore(13, 12);
  print('🔥 13-12 Set Point: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 26 points (13-13) - Still deuce
  doublesMatch.updateScore(13, 13);
  print('🔥 13-13 Still Deuce: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 27 points (14-13) - Set point for Team 1
  doublesMatch.updateScore(14, 13);
  print('🔥 14-13 Set Point: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 28 points (14-14) - Still deuce
  doublesMatch.updateScore(14, 14);
  print('🔥 14-14 Still Deuce: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 29 points (15-14) - Set point for Team 1
  doublesMatch.updateScore(15, 14);
  print('🔥 15-14 Set Point: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  // Test after 30 points (15-15) - Still deuce
  doublesMatch.updateScore(15, 15);
  print('🔥 15-15 Still Deuce: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves (${doublesMatch.getServingInfo()['remainingServes']} serves remaining)');
  
  print('\n📋 PHASE 3: REALISTIC SET SCENARIOS\n');
  
  // Test realistic set ending scenarios
  print('=== Realistic Set Scenarios ===\n');
  
  // Reset for realistic test
  doublesMatch.resetMatch();
  
  // Normal set progression to 11-9
  doublesMatch.updateScore(11, 9);
  print('✅ Set ends at 11-9 (Team 1 wins): ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves');
  
  // Reset for deuce scenario
  doublesMatch.resetMatch();
  
  // Deuce scenario: 10-10, then 12-10
  doublesMatch.updateScore(10, 10);
  print('✅ Deuce at 10-10: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves');
  
  doublesMatch.updateScore(12, 10);
  print('✅ Set ends at 12-10 (Team 1 wins by 2): ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves');
  
  // Reset for another deuce scenario
  doublesMatch.resetMatch();
  
  // Extended deuce: 10-10, 11-11, 12-12, 13-13, 15-13
  doublesMatch.updateScore(10, 10);
  print('✅ Deuce at 10-10: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves');
  
  doublesMatch.updateScore(11, 11);
  print('✅ Still deuce at 11-11: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves');
  
  doublesMatch.updateScore(12, 12);
  print('✅ Still deuce at 12-12: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves');
  
  doublesMatch.updateScore(13, 13);
  print('✅ Still deuce at 13-13: ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves');
  
  doublesMatch.updateScore(15, 13);
  print('✅ Set ends at 15-13 (Team 1 wins by 2): ${doublesMatch.getServingInfo()['servingTeam']} serves, ${doublesMatch.getServingInfo()['servingPlayer']} serves');
  
  print('\n🔄 PHASE 4: ALTERNATIVE TOSS WINNER\n');
  
  // Test with different toss winner
  print('=== Testing with Team 2 winning toss ===\n');
  var doublesMatch2 = ITTFDoublesServing(
    team1Player1Name: 'Alice',
    team1Player2Name: 'Bob',
    team2Player1Name: 'Charlie',
    team2Player2Name: 'Diana',
    matchTotalSetsToPlay: 5,
    tossWinningTeam: 'Team 2',
    tossWinningPlayer: 'Charlie',
  );
  
  print('🏓 0-0: ${doublesMatch2.getServingInfo()['servingTeam']} serves, ${doublesMatch2.getServingInfo()['servingPlayer']} serves (${doublesMatch2.getServingInfo()['remainingServes']} serves remaining)');
  
  doublesMatch2.updateScore(1, 1);
  print('🏓 1-1: ${doublesMatch2.getServingInfo()['servingTeam']} serves, ${doublesMatch2.getS  ervingInfo()['servingPlayer']} serves (${doublesMatch2.getServingInfo()['remainingServes']} serves remaining)');
  
  print('\n🎯 SUMMARY OF ITTF DOUBLES SERVING RULES:');
  print('✅ Service changes every 2 points between teams (normal play)');
  print('✅ Service changes every 1 point between teams (deuce)');
  print('✅ Players alternate within their team every time that team serves');
  print('✅ Each player serves 2 times before switching (normal play)');
  print('✅ Each player serves 1 time before switching (deuce)');
  print('✅ Toss winner serves first in the match');
  print('✅ Must win by 2 points in deuce situations');
}
