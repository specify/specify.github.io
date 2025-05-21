# Extended Age Query

## Query Paths

Table paths from CollectionObject to Absoluteage or GeologicTimePeriod:
- collectionobject->absoluteage
- collectionobject->relativeage->chronostrat
- collectionobject->paleocontext->chronostrat
- collectionobject->collectionevent->paleocontext->chronostrat
- collectionobject->collectionevent->locality->paleocontext->chronostrat

Field Paths from CollectionObject to Absoluteage or GeologicTimePeriod:
- collectionobject__absoluteage__absoluteage
- collectionobject__relativeage__agename__startperiod
- collectionobject__relativeage__agename__endperiod
- collectionobject__relativeage__agenameend__startperiod
- collectionobject__relativeage__agenameend__endperiod
- collectionobject__paleocontext__chronosstrat__startperiod
- collectionobject__paleocontext__chronosstrat__endperiod
- collectionobject__paleocontext__chronosstratend__startperiod
- collectionobject__paleocontext__chronosstratend__endperiod
- collectionobject__collectingevent__paleocontext__chronosstrat__startperiod
- collectionobject__collectingevent__paleocontext__chronosstrat__endperiod
- collectionobject__collectingevent__paleocontext__chronosstratend__startperiod
- collectionobject__collectingevent__paleocontext__chronosstratend__endperiod
- collectionobject__collectingevent__locality__paleocontext__chronosstrat__startperiod
- collectionobject__collectingevent__locality__paleocontext__chronosstrat__endperiod
- collectionobject__collectingevent__locality__paleocontext__chronosstratend__startperiod
- collectionobject__collectingevent__locality__paleocontext__chronosstratend__endperiod

## Query Logic

Given:
- an age query start period `x`
- an age query end period `y`
- with constraint that `x >= y`
- for each collection object, a meta start period `a` is decided, and a meta end period `b` is decided.
- with constraint that `a >= b`

Strict Filter: (full overlap, a-b is within x-y)
`a <= x` and `b >= y`

Non-Strict Filter: (partial age range overlap, any overlap so x-y can be within a-b or a-b can be within x-y)
(` a<= x` and `a >= y`) or (`b <= x` and `b >= y`) or (`a >= x` and `b <= y`)

This is omitting the complication of uncertainty values.

The meta age range for each collection object should appear in the age column of the query results.

The "Any" age query bug is being push to a later issue. For now, do a Age Range query from "13800" to "0" to get all COs with age data (query all of time, the age of the universe 😀

