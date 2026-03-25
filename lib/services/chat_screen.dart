// Add to _ChatScreenState
Future<void> _inviteFriend() async {
  final response = await ApiService.mintReward(widget.user, 'invite');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Earned ${response['points']} Bonga Points!')),
  );
}
