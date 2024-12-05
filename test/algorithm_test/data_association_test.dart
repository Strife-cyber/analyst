import 'package:analyst/algorithms/data_association.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Data Association Tests', () {
    final transactions = [
      {'Math_High', 'Physics_High', 'Chemistry_Medium'},
      {'Math_Medium', 'Physics_High', 'Chemistry_High'},
      {'Math_Low', 'Physics_Low', 'Chemistry_Medium'},
      {'Math_High', 'Physics_High', 'Chemistry_High'}
    ];

    final dataAssociation =
        DataAssociation(minSupport: 0.5, minConfidence: 0.6);

    test('Test generateFrequentItemsets()', () {
      final frequentItemsets =
          dataAssociation.generateFrequentItemsets(transactions);

      // Check if the frequent itemsets contain expected sets with support values
      expect(frequentItemsets.containsKey({'Math_High', 'Physics_High'}), true);
      expect(
          frequentItemsets.containsKey({'Math_High', 'Chemistry_High'}), true);
      expect(frequentItemsets.containsKey({'Physics_High', 'Chemistry_High'}),
          true);

      expect(frequentItemsets[{'Math_High', 'Physics_High'}],
          0.75); // Support should be 3/4 = 0.75
    });

    test('Test generateRules()', () {
      final frequentItemsets =
          dataAssociation.generateFrequentItemsets(transactions);
      final rules = dataAssociation.generateRules(frequentItemsets);

      expect(rules.isNotEmpty, true); // Should generate some association rules
      expect(rules[0]['antecedent'],
          {'Math_High', 'Physics_High'}); // Example expected antecedent
      expect(rules[0]['consequent'],
          {'Chemistry_High'}); // Example expected consequent
      expect(rules[0]['support'], 0.75); // Example expected support
      expect(rules[0]['confidence'], 0.6667); // Example expected confidence
    });

    test('Test generateRules() with no rules for low confidence', () {
      final lowConfidenceAssociation =
          DataAssociation(minSupport: 0.5, minConfidence: 1.0);
      final frequentItemsets =
          lowConfidenceAssociation.generateFrequentItemsets(transactions);
      final rules = lowConfidenceAssociation.generateRules(frequentItemsets);

      expect(rules.isEmpty,
          true); // No rules should be generated because confidence is set to 1.0
    });
  });
}
