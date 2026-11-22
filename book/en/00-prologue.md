---
title: "Prologue: One question and a lot of files"
---

## October 2018 on the Pajares Pass

At the end of October 2018, winter came early to Pajares. Heavy snow fell while the trees were still in leaf. The snow clung to the crowns, and the trees snapped and came down on the lines. They blocked the roads too, so the line crews struggled even to reach the faults [1, 2]. On the third day, 679 Viesgo customers were still without power [1].

In the mountains, a fallen tree does two things at once: it brings down the conductor and it blocks the road to it.

## An engineer's question

Let's say we're responsible for patrolling the high-voltage lines on the pass. Five 400 kV lines run through here: 33 towers and 34 spans, about 9.5 km in all. Before winter, there aren't enough people or hours to do everything. We need to decide which spans to inspect first.

The regulation for overhead lines, ITC-LAT 07, requires in section 5.12.1 that trees be felled if they could reach the conductors when they fall [3]. So the regulation is asking a question about **distance**: how close is the tree to the conductor, and how tall is it?

But distance alone isn't enough for an honest answer. We also need to know:

- what kind of forest grows along the span, and how tall it is;
- how steep the slope beneath it is;
- whether that forest has burned in recent years: burnt trees snap and fall in the first strong wind [4];
- whether there's a road nearby that a crew can use to reach the tower;
- which municipality the span is in, and what its outage record looks like.

## Where the answers are

All this data exists, and all of it is open. But each dataset lives in its own file, in its own format, and often in its own coordinate reference system:

- towers and spans in CSV tables and GeoPackage files;
- land use and forest in a separate layer;
- terrain in a raster with a 2-metre cell size;
- the 78 municipalities of Asturias and 14,847 road segments from OpenStreetMap;
- satellite fire detections: 13,388 points for 2012–2025 from the NASA FIRMS archive [5];
- outage figures in Excel spreadsheets.

With two files, we can open them in QGIS and look at them by eye. With ten, the trouble starts. Every time, we open everything again and repeat the same steps by hand. A month later a new survey comes out, and everything has to be recalculated. A colleague works on their own copy of a file, and we end up with different numbers. And to check someone else's result, we have to reconstruct from memory exactly what was done.

## Data can mislead us too

There's a second problem. The original FIRMS archive has more than 31,000 points for Asturias over the same years. The archive itself flags more than half of them as persistent heat sources: factories on the industrial coast that are hot every single day [5]. Our file already has these points removed, which is why it holds 13,388. If we don't remove them, the most 'fire-prone' place in Asturias turns out to be a steelworks.

So before we answer the question, we need to check the data. And we need to do it in a way that lets us repeat the check.

## What a database gives us

A database solves both problems at once:

- **all the data in one place.** Towers, forest, terrain, roads and fires sit side by side, in one coordinate reference system, and everyone can see them: psql, QGIS, Python and our colleague;
- **the server keeps things in order.** It won't let us write text into a height column, or lose the link between a span and its towers;
- **the question is written down as text.** An SQL query is itself the record of what we did. We can reread it, hand it to a colleague and run it again on new data;
- **geometry inside SQL.** With the PostGIS extension, the question 'which trees are closer to the conductor than their own height?' becomes a single query.

## The road ahead

First we install PostgreSQL and learn to ask questions of ordinary tables: towers and spans. Then we add geometry and, step by step, gather the forest, slope, fires and roads for every span. After that, we set up a database for a storm catalogue the way it's done on real projects. And at the end, we see that the same queries work in DuckDB, QGIS and Python.

## Our question

**Which spans of the lines on the Pajares Pass are most at risk from forest and fire, and how does a database help us find them and check the answer?**

We'll answer it one step per lesson. And we start at the very beginning: by working out how PostgreSQL is put together.

## Questions to check

1. **What question does the ITC-LAT 07 regulation ask, and why is it a question about distance?**

   :::{dropdown} Answer
   Whether a tree could reach the conductor when it falls. To answer it, we need to know how far the tree is from the conductor and how tall it is.
   :::

2. **Why are ten files awkward, even if each of them is good?**

   :::{dropdown} Answer
   Every time, we have to open everything and repeat the steps by hand, colleagues' copies drift apart, and checking a result is hard because the steps aren't written down anywhere.
   :::

3. **What happens if we take all the FIRMS points without checking them?**

   :::{dropdown} Answer
   Persistent heat sources, that is, factories, look like fires, and the most fire-prone place turns out to be a factory.
   :::

## Sources

1. OKDiario, 30 October 2018. https://okdiario.com/espana/temporal-deja-sin-luz-tres-dias-mas-4-500-personas-asturias-3291859
2. La Voz del Trubia, 29 October 2018. https://lavozdeltrubia.es/2018/10/29/somiedo-teverga-y-parte-de-quiros-siguen-sin-luz-por-el-temporal/
3. ITC-LAT 07 (RD 223/2008), section 5.12.1. https://normatia.com/es/normativa/reglamento-lineas-alta-tension/2025/instruccion-tecnica-complementaria-itc-lat-07-lineas-aereas-con-conductores/
4. BPA, How wildfires can contribute to power outages. https://www.bpa.gov/learn-and-participate/community-education/wildfires-and-public-safety
5. NASA FIRMS, VIIRS S-NPP 375 m archive, Asturias, 2012–2025; field TYPE = 2 (persistent heat source). https://firms.modaps.eosdis.nasa.gov/download/
