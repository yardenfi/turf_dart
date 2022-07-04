import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:turf/helpers.dart';
import 'package:turf/src/booleans/boolean_equal.dart';

main() {
  group('boolean_crosses', () {
    var inDir = Directory('./test/examples/booleans/equal/true');
    for (var file in inDir.listSync(recursive: true)) {
      if (file is File && file.path.endsWith('.geojson')) {
        test(file.path, () {
          // True Fixtures
          var inSource = file.readAsStringSync();
          var inGeom = GeoJSONObject.fromJson(jsonDecode(inSource));

          var feature1 = (inGeom as FeatureCollection).features[0];
          var feature2 = inGeom.features[1];
          Map<String, dynamic> json = jsonDecode(inSource);
          var options = json['properties'];
          var result =
              booleanEqual(feature1, feature2, precision: options['precision']);

          expect(result, true);
        });
        // False Fixtures
        var inDir = Directory('./test/examples/booleans/equal/false');
        for (var file in inDir.listSync(recursive: true)) {
          if (file is File && file.path.endsWith('.geojson')) {
            test(file.path, () {
              // True Fixtures
              var inSource = file.readAsStringSync();
              var inGeom = GeoJSONObject.fromJson(jsonDecode(inSource));

              var feature1 = (inGeom as FeatureCollection).features[0];
              var feature2 = inGeom.features[1];

              Map<String, dynamic> json = jsonDecode(inSource);
              var options = json['properties'];
              var result = booleanEqual(feature1, feature2,
                  precision: options['precision']);

              expect(result, true);
            });

            var pt = Point(coordinates: Position.of([9, 50]));
            var line1 = Feature(
              geometry: LineString(coordinates: [
                Position.of([7, 50]),
                Position.of([8, 50]),
                Position.of([9, 50]),
              ]),
            );
            var line2 = Feature(
              geometry: LineString(coordinates: [
                Position.of([7, 50]),
                Position.of([8, 50]),
                Position.of([9, 50]),
              ]),
            );
            var poly1 = Feature(
              geometry: Polygon(coordinates: [
                [
                  Position.of([8.5, 50]),
                  Position.of([9.5, 50]),
                  Position.of([9.5, 49]),
                  Position.of([8.5, 49]),
                  Position.of([8.5, 50]),
                ],
              ]),
            );
            var poly2 = Feature(
              geometry: Polygon(coordinates: [
                [
                  Position.of([8.5, 50]),
                  Position.of([9.5, 50]),
                  Position.of([9.5, 49]),
                  Position.of([8.5, 49]),
                  Position.of([8.5, 50]),
                ],
              ]),
            );
            var poly3 = Feature(
              geometry: Polygon(coordinates: [
                [
                  Position.of([10, 50]),
                  Position.of([10.5, 50]),
                  Position.of([10.5, 49]),
                  Position.of([10, 49]),
                  Position.of([10, 50]),
                ],
              ]),
            );

            test("turf-boolean-equal -- geometries", () {
              // "[true] LineString geometry"
              expect(booleanEqual(line1.geometry!, line2.geometry!), true);

              // "[true] Polygon geometry"
              expect(booleanEqual(poly1.geometry!, poly2.geometry!), true);

              // "[false] Polygon geometry"
              expect(booleanEqual(poly1.geometry!, poly3.geometry!), false);

              // "[false] different types"
              expect(booleanEqual(pt, line1), false);
            });

            test("turf-boolean-equal -- throws", () {
              //t.throws(() => equal(null, line1), /feature1 is required/, 'missing feature1');
              //t.throws(() => equal(line1, null), /feature2 is required/, 'missing feature2');

              //     "precision must be a number"

              expect(
                  () => booleanEqual(line1.geometry!, line2.geometry!,
                      precision: 1),
                  throwsA(isA<Exception>()));
              //"precision must be positive"
              expect(
                  () => booleanEqual(line1.geometry!, line2.geometry!,
                      precision: -1),
                  throwsA(isA<Exception>()));
            });
          }
        }
      }
    }
  });
}
