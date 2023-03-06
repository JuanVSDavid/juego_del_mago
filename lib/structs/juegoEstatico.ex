defmodule Structs.JuegoEstatico do
  defstruct puertas: [
              %{opcion: 1, display: "P1", tieneLlanta?: true, dinero: 0, abierta?: false},
              %{opcion: 2, display: "P2", tieneLlanta?: false, dinero: 100, abierta?: false},
              %{opcion: 3, display: "P3", tieneLlanta?: false, dinero: 200, abierta?: false},
              %{opcion: 4, display: "P4", tieneLlanta?: false, dinero: 250, abierta?: false},
              %{opcion: 5, display: "P5", tieneLlanta?: false, dinero: 1, abierta?: false},
              %{opcion: 6, display: "P6", tieneLlanta?: true, dinero: 0, abierta?: false},
              %{opcion: 7, display: "P7", tieneLlanta?: false, dinero: 3, abierta?: false},
              %{opcion: 8, display: "P8", tieneLlanta?: false, dinero: 333, abierta?: false},
              %{opcion: 9, display: "P9", tieneLlanta?: true, dinero: 0, abierta?: false},
              %{opcion: 10, display: "P10", tieneLlanta?: true, dinero: 0, abierta?: false}
            ]
end
