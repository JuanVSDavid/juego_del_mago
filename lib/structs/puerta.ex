defmodule Structs.Puerta do
  defstruct [:opcion, :display, :tieneLlanta?, :dinero, abierta?: false]

  def crearPuertaConLlanta(opcion) do
    crearPuerta(opcion, true, 0)
  end

  def crearPuertaConDinero(opcion) do
    dineroRandom = Enum.random([50, 100, 200])
    crearPuerta(opcion, false, dineroRandom)
  end

  def crearPuertaConNada(opcion) do
    crearPuerta(opcion, false, 0)
  end

  def crearPuerta(opcion, tieneLlanta?, dinero) do
    %__MODULE__{opcion: opcion, display: "P#{opcion}", tieneLlanta?: tieneLlanta?, dinero: dinero}
  end
end
