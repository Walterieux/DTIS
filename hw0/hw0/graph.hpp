#pragma once

#include <iostream>
#include <set>

namespace hw0
{

  class Graph
  {
  public:
    Graph(uint32_t num_nodes)
    {
      nodes_links = new std::set<uint32_t>[num_nodes];
      nb_nodes = num_nodes;
    }

    ~Graph()
    {
      delete[] nodes_links;
    }

    void add_edge(uint32_t from, uint32_t to)
    {
      std::cout << "[i] add edge from " << from << " to " << to << std::endl;
      if (from != to)
      {
        // add edge to both since the graph is undirected
        nodes_links[from].insert(to);
        nodes_links[to].insert(from);
      }
    }

    uint32_t num_degree_k(uint32_t k) const
    {
      int nb = 0;
      for (size_t i = 0; i < nb_nodes; i++)
      {
        if (nodes_links[i].size() == k)
        {
          nb++;
        }
      }

      return nb;
    }

  private:
    std::set<uint32_t> *nodes_links;
    uint32_t nb_nodes;
  };

} // namespace hw0