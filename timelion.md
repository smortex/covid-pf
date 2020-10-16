# Cas actifs vs. cas guéris

```
.es(*, index=covid,metric=avg:curred_case_count).label("Cas guéris").fit(carry).lines(fill=1, width=2),
.es(*, index=covid,metric=avg:active_case_count).label("Cas actifs").fit(carry).lines(fill=1, width=2)
```

# Décès

```
.es(*, index=covid,metric=avg:death_count).label("Décès").fit(carry).lines(fill=1, width=2)
```

# Hospitalisations

```
.es(*, index=covid,metric=avg:hospitalization_count).label("Hospitalisations").fit(carry).lines(fill=1, width=2),
.es(*, index=covid,metric=avg:intensive_care_count).label("Soins intensifs").fit(carry).lines(fill=1, width=2)
```

# Mortalité

```
.es(*, index=covid,metric=avg:death_count).fit(carry).lines(fill=1, width=2).divide(
.es(*, index=covid,metric=avg:confirmed_case_count).fit(carry).lines(fill=1, width=2)).label("Mortalité")
```

# Évolution du R0 sur 20 jours

```
.es(*, index=covid,metric=avg:active_case_count).fit(carry).divide(.es(*, index=covid,metric=avg:active_case_count,offset=-20d).fit(carry)).lines(width=2,fill=1).label("R0"),
.value(1).lines(width=1).label("R0 = 1")
```

# Évolution du nombre de cas confirmés

```
.es(*, index=covid,metric=avg:confirmed_case_count).label("Cas confirmés").points()
```

# Évolution du nombre de nouveaux cas par semaine

```
.es(*, index=covid,metric=avg:confirmed_case_count).label("Nouveaux cas confirmés").fit(carry).derivative().bars()
```
