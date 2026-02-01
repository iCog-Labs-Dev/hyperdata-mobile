String formatPrice(num amount) {
  if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(amount % 1000000 == 0 ? 0 : 2)}M Br.';
  } else if (amount >= 10000) {
    return '${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 2)}K Br.';
  } else {
    return '${amount.toStringAsFixed(2)} Br.';
  }
}
