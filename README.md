# PageRank-Style Rankings for Pokémon Types
 
===========================================

Simple code/data for setting up and analyzing Pokémon types and type-relations using a directed graph. Initial goal was to use a PageRank-like algorithm to rank types and type combinations, but the graph data could also be used for other purposes.

## Explanation
 
All 171 possible Pokémon typings (single and dual) were considered. The type relationships were represented as a directed, fully connected graph. Each edge was weighted by the damage multiplier if the source node were the attacker and the target node were the defender. For example, the edge from the "Fire" node to the "Grass" node had an edge weight of 2, and the edge from the "Grass" node to the "Flying" node had an edge weight of 1/2. For dual-type attackers, the multiplier for each of the attacker's two types on the defender were calculated, and the maximum of those multipliers was taken.
 
Unlike PageRank, this model involves the flow of two different ranking values, one for offense, and one for defense. The nodes with good offensive scores have more influence on the defensive scores of other nodes, because it is "better" to have a resistance to an offensively threatening type (e.g. Ground) rather than an offensively non-threatening type (e.g. Normal). Conversely, the nodes with good defensive scores have more influence on the offensive scores of other nodes, because it is more useful to be able to threaten defensively strong types (e.g. Steel) than it is to be able to threaten defensively weak types (e.g. Ice). The ranks are represented as two stochastic 171-element vectors, "attack" and "defense".
 
The model is represented as a coupled system of two equations. The first is the "attack" equation, involving the transfer of defensive score to offensive score, and is as follows:
 
`attack = damping + d*Danger*defense`
 
"d" is the typical damping parameter used in PageRank. The final rankings were stable without a damping term, where d = 1. In this case, "damping" was a zero-vector, but in general it would be a uniform vector with elements (1-d)/171. "Danger" is a matrix representing the "danger" that each type poses to other types. More precisely, if "G" is the 171-node type-relationship graph, "Danger" is the column-normalized transpose of the weighted adjacency matrix of "G". Column-normalized means that all of the columns sum to 1, making "Danger" a stochastic matrix.
 
The second "resistance" equation involves the transfer of offensive score to defensive score, and is as follows:
 
`defense = damping + d*(Base - Damage*attack)`
 
"Damage" is a matrix representing how susceptible each type is to other types. It is the column-normalized weighted adjacency matrix of "G". Hence, "Damage" is also stochastic. The negative sign is used in front of the "Damage*attack" term so that a higher amount of damage sustained corresponds to a lower defensive score.
 
"Base" is a uniform vector representing a "base amount of damage" that a type would receive from a type-less attack. Its purpose is to ensure that the term "Base - Damage*attack" remains stochastic. "Base" is defined as a uniform vector with elements equal to 2/171.
 
The system of equations was solved to achieve the rankings. Overall ranking values were calculated by simply averaging the "attack" and "defense" score vectors.
 
Each pure type was scored for offense, defense, and overall by summing the scores of each type-combination containing that type. Each resulting 18-element vector was then normalized to be consistent with the other rank vectors.

## Results

### Overall
- Best Overall (Dual): Ground/Steel
- Best Overall (Pure): Ground
- Worst Overall (Dual): Grass/Bug
- Worst Overall (Pure): Grass

### Offensive
- Best Offensive (Dual): Ice/Ground
- Best Offensive (Pure): Ground
- Worst Offensive (Dual): Normal
- Worst Offensive (Pure): Normal

### Defensive
- Best Defensive (Dual): Steel/Fairy
- Best Defensive (Pure): Steel
- Worst Defensive (Dual): Ice/Rock
- Worst Defensive (Pure): Rock

[Full rankings can be found here.](https://pastebin.com/sGkT2wWg)