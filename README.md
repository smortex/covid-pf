# COVID19 en Polynésie Française

Agrégation des données brutes sur la situation du COVID19 en Polynésie Française et outils d'import dans ElasticSearch.

## Contenu du dépôt

* `covid.sc` Feuille de calcul `sc(1)` où les données sont agrégées lorsqu'elles sont publiées;
* `covid-extract.rb` Script de conversion d'un export texte de la feuille de calcul vers le format [jsonl] (utiliser `T` dans `sc(1)` pour exporter les données au format texte);
* `insert.sh` Script qui lit des lignes au format [jsonl] (e.g. celles générées par le script ci-dessus) et les insère dans un index ElasticSearch 6 créé (et nettoyé) pour l'occasion.

Cas d'usage:

```sh-session
romain@zappy ~/covid-pf % sc covid.sc # Puis 'T<CR>q' pour exporter et quitter
romain@zappy ~/covid-pf % ./covid-extract.rb covid.cln | ./insert.sh
```

## Usage

Une fois les données dans ElasticSearch, faites ce qui vous plaît, par exemple visualisez les cas actifs avec Timelion:

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
