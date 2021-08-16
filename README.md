# COVID19 en Polynésie Française

Agrégation des données brutes sur la situation du COVID19 en Polynésie Française et outils d'import dans OpenSearch.

## Contenu du dépôt

* `covid.sc` Feuille de calcul `sc(1)` où les données sont agrégées lorsqu'elles sont publiées;
* `covid-extract.rb` Script de conversion de la feuille de calcul vers le format [jsonl];
* `insert.sh` Script qui lit des lignes au format [jsonl] (e.g. celles générées par le script ci-dessus) et les insère dans un index OpenSearch créé (et nettoyé) pour l'occasion.

Cas d'usage:

```sh-session
romain@zappy ~/covid-pf % ./covid-extract.rb covid.sc | ./insert.sh
```

## Usage

Une fois les données dans OpenSearch, faites ce qui vous plaît, par exemple visualisez les cas actifs avec Timelion:

```
.es(index=covid,metric=avg:confirmed_case_count).subtract(.es(index=covid,metric=avg:confirmed_case_count,offset="-7d")).points().label("Cas actifs").title("Cas actifs (calculé à partir des cas confirmés)")
```

Vous êtes invité·e a consulter et contribuer d'autres exemples dans le [wiki du projet].

## Licence

C'est compliqué :-) Ce projet reproduit des données publiques mises à disposition sans qu'une licence ne leurs soient attribuée.  La source est systématiquement indiquée.

## Contribution

Il manque des données ?  Vous avez repéré un problème ?  Merci d'ouvrir une demande de fusion pour apporter les modifications souhaitées *en référençant la source* de vos données.

[jsonl]: https://jsonlines.org/
[wiki du projet]: https://github.com/smortex/covid-pf/wiki
