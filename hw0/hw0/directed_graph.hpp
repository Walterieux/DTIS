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
      edge_in = new std::set<uint32_t>[num_nodes];
      edge_out = new std::set<uint32_t>[num_nodes];
      nb_nodes = num_nodes;
    }

    ~Graph()
    {
      delete[] edge_in;
      delete[] edge_out;
    }

    void add_edge(uint32_t from, uint32_t to)
    {
      std::cout << "[i] add edge from " << from << " to " << to << std::endl;
      // skip if a node has an edge to itself
      if (from != to)
      {
        edge_out[from].insert(to);
        edge_in[to].insert(from);
      }
    }

    uint32_t num_degree_k(uint32_t k) const
    {
      int nb = 0;
      for (size_t i = 0; i < nb_nodes; i++)
      {
        if (edge_in[i].size() + edge_out[i].size() == k)
        {
          nb++;
        }
      }

      return nb;
    }

    uint32_t num_in_degree_k(uint32_t k) const
    {
      int nb = 0;
      for (size_t i = 0; i < nb_nodes; i++)
      {
        if (edge_in[i].size() == k)
        {
          nb++;
        }
      }

      return nb;
    }

    uint32_t num_out_degree_k(uint32_t k) const
    {
      int nb = 0;
      for (size_t i = 0; i < nb_nodes; i++)
      {
        if (edge_out[i].size() == k)
        {
          nb++;
        }
      }

      return nb;
    }

  private:
    std::set<uint32_t> *edge_in = nullptr;
    std::set<uint32_t> *edge_out = nullptr;
    int nb_nodes;
  };

} // namespace hw0