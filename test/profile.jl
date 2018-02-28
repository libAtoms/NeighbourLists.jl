using NeighbourLists
using JuLIP
using BenchmarkTools
using PyCall
using ProfileView

# @pyimport matscipy.neighbours as matscipy_neighbours
matscipy_neighbours = pyimport("matscipy.neighbours")

function matscipy_nlist(at, cutoff)
   pycall(matscipy_neighbours["neighbour_list"],
          NTuple{5, PyArray}, "ijdDS", at.po, cutoff)
end

print("L = 4")
# si, non-cubic cell, mixed bc
at = bulk("Si", cubic=true) * 4
println(", N = $(length(at))")
set_pbc!(at, (true, false, true))
C = JMat(cell(at))
X = positions(at)
perbc = JVec(pbc(at))
cutoff = 2.1 * rnn("Si")

println("Julia Nlist")
@btime CellList(X, cutoff, C, perbc)
println("Matscipy Nlist")
@btime matscipy_nlist(at, cutoff)


print("L = 10")
# si, non-cubic cell, mixed bc
at = bulk("Si", cubic=true) * 10
println(", N = $(length(at))")
set_pbc!(at, (true, false, true))
C = JMat(cell(at))
X = positions(at)
perbc = JVec(pbc(at))
cutoff = 2.1 * rnn("Si")

println("Julia Nlist")
@btime CellList(X, cutoff, C, perbc)
println("Matscipy Nlist")
@btime matscipy_nlist(at, cutoff)


# print("L = 30")
# # si, non-cubic cell, mixed bc
# at = bulk("Si", cubic=true) * 30
# println(", N = $(length(at))")
# set_pbc!(at, (true, false, true))
# C = JMat(cell(at))
# X = positions(at)
# perbc = JVec(pbc(at))
# cutoff = 2.1 * rnn("Si")
#
# println("Julia Nlist")
# @btime NeighbourLists.neighbour_list(C, perbc, X, cutoff)
# println("Matscipy Nlist")
# @btime matscipy_nlist(at, cutoff)
