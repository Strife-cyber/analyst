class DataAssociation {
  // Done by Apriori
  final double minSupport;
  final double minConfidence;

  DataAssociation({required this.minSupport, required this.minConfidence});

  // Count occurrences of itemsets
  Map<Set<String>, int> _countItemSets(
      List<Set<String>> transactions, Set<String> itemset) {
    Map<Set<String>, int> itemsetCounts = {};
    for (var transaction in transactions) {
      if (itemset.every((item) => transaction.contains(item))) {
        itemsetCounts[itemset] = (itemsetCounts[itemset] ?? 0) + 1;
      }
    }
    return itemsetCounts;
  }

  // Generate candidate itemsets
  List<Set<String>> _generateCandidates(
      List<Set<String>> frequentItemsets, int k) {
    List<Set<String>> candidates = [];
    for (var i = 0; i < frequentItemsets.length; i++) {
      for (var j = i + 1; j < frequentItemsets.length; j++) {
        var candidate = frequentItemsets[i].union(frequentItemsets[j]);
        if (candidate.length == k) {
          candidates.add(candidate);
        }
      }
    }
    return candidates;
  }

  // Generate frequent itemsets
  Map<Set<String>, double> generateFrequentItemsets(
      List<Set<String>> transactions) {
    Map<Set<String>, double> frequentItemsets = {};
    List<Set<String>> currentItemsets =
        transactions.expand((t) => t).map((e) => {e}).toList();

    int k = 1;
    while (currentItemsets.isNotEmpty) {
      Map<Set<String>, int> itemsetCounts = {};
      for (var itemset in currentItemsets) {
        itemsetCounts.addAll(_countItemSets(transactions, itemset));
      }

      currentItemsets = itemsetCounts.keys
          .where((itemset) =>
              (itemsetCounts[itemset]! / transactions.length) >= minSupport)
          .toList();

      for (var itemset in currentItemsets) {
        frequentItemsets[itemset] =
            itemsetCounts[itemset]! / transactions.length;
      }

      currentItemsets = _generateCandidates(currentItemsets, ++k);
    }

    return frequentItemsets;
  }

  // Generate association rules
  List<Map<String, dynamic>> generateRules(
      Map<Set<String>, double> frequentItemsets) {
    List<Map<String, dynamic>> rules = [];

    for (var itemset in frequentItemsets.keys) {
      if (itemset.length > 1) {
        for (var item in itemset) {
          var antecedent = itemset.difference({item});
          var consequent = {item};
          var support = frequentItemsets[itemset];
          var confidence = support! / frequentItemsets[antecedent]!;

          if (confidence >= minConfidence) {
            rules.add({
              'antecedent': antecedent,
              'consequent': consequent,
              'support': support,
              'confidence': confidence,
            });
          }
        }
      }
    }

    return rules;
  }
}
