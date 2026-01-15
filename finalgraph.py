import networkx as nx
import matplotlib.pyplot as plt

# Create graph
G = nx.Graph()
G.add_edges_from([
    ("Vindaya", "Shivalik"),
    ("Himalaya", "Ajanta"),
    ("Himalaya", "Health care center"),
    ("Health care center", "Ajanta"),
    ("Health care center", "Kailash"),
    ("Health care center", "Girl's mess"),
    ("Girl's mess", "Vindaya"),
    ("Girl's mess", "Aravali"),
    ("Aravali", "Nilgiri"),
    ("Nilgiri", "Satpura"),
    ("Satpura", "Kailash"),
    ("Satpura", "Health care center"),
    ("Himalaya", "School of education"),
    ("School of education", "School of law"),
    ("School of education", "School of management"),
    ("School of management", "School of law"),
    ("Girl's mess", "Nilgiri"),
    ("Girl's mess", "Shivalik"),
    ("Kailash", "School of education"),
    ("School of law", "Main Gate"),
    ("School of management", "Roundabout"),
    ("Roundabout", "Football field"),
    ("Kailash", "Football field"),
    ("Roundabout", "Grocery block"),
    ("Grocery block", "Engineering block"),
    ("Football field", "Engineering block"),
    ("Kailash", "Engineering block"),
    ("Roundabout", "Centre for Executive Education"),
    ("Centre for Executive Education", "New guest house"),
    ("New guest house", "IT mess"),
    ("Roundabout", "IT block 1"),
    ("IT block 1", "IT block 2"),
    ("IT block 1", "IT mess"),
    ("IT block 2", "IT mess"),
    ("New guest house", "MU phase 3"),
    ("MU phase 3", "MU phase 2"),
    ("MU phase 1", "MU phase 2"),
    ("MU phase 1", "MU phase 3"),
    ("Main mess", "MU phase 1"),
    ("Main mess", "MU phase 2"),
    ("Main mess", "MU phase 3"),
    ("IT mess", "MU phase 3"),
    ("IT mess", "MU phase 2"),
    ("Engineering block", "Civil Department Laboratories"),
    ("Civil Department Laboratories", "MU phase 1"),
    ("Engineering block", "MU phase 1"),
    ("Roundabout", "Y intersection"),
    ("Y intersection", "IT block 2"),
    ("Y intersection", "IT block 1"),
    ("Y intersection", "Basket ball court"),
    ("Y intersection", "Swimming pool"),
    ("Swimming pool", "Gym"),
    ("Convention Hall", "Library"),
    ("Gym", "Convention Hall"),
    ("Library", "IT block 1"),
    ("Library", "IT mess"),
    ("Library", "IT block 2"),
    ("MU phase 2", "Library"),
    ("Library", "Y intersection"),
	("Main Gate", "Roundabout")
])

# Draw graph
plt.figure(figsize=(12, 8))  # Adjust figure size
pos = nx.spring_layout(G, seed=42)  # Fix layout for consistency
nx.draw(
    G, pos, with_labels=True, node_color='lightblue', node_size=1000,
    edge_color='gray', font_size=6, font_weight='bold'
)

plt.title("Campus Graph (No Weights)", fontsize=12)
plt.show()
