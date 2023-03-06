defmodule Structs.Juego do
  defstruct [:puertas]

  def crearJuego(puertasConDinero, puertasConLlantas, puertasSinNada)
      when puertasConDinero + puertasConLlantas + puertasSinNada == 10 do
    puertas = Enum.to_list(1..10)

    %{puertasCreadas: puertasCreadasConDinero, puertasNoUtilizadas: puertasDisponibles} =
      crearPuertaDelJuego(
        &Structs.Puerta.crearPuertaConDinero/1,
        puertas,
        puertasConDinero
      )

    puertas = puertasDisponibles

    %{puertasCreadas: puertasCreadasConNada, puertasNoUtilizadas: puertasDisponibles} =
      crearPuertaDelJuego(
        &Structs.Puerta.crearPuertaConNada/1,
        puertas,
        puertasSinNada
      )

    puertas = puertasDisponibles

    %{puertasCreadas: puertasCreadasConLlanta, puertasNoUtilizadas: _puertasDisponibles} =
      crearPuertaDelJuego(
        &Structs.Puerta.crearPuertaConLlanta/1,
        puertas,
        puertasConLlantas
      )

    %Structs.Juego{
      puertas:
        Enum.sort(
          puertasCreadasConDinero ++ puertasCreadasConNada ++ puertasCreadasConLlanta,
          fn puerta1, puerta2 -> puerta1.opcion <= puerta2.opcion end
        )
    }
  end

  def crearPuertaDelJuego(callback, puertasDisponibles, cantidadDeRepeticiones) do
    crearPuertaDelJuego(callback, puertasDisponibles, cantidadDeRepeticiones, [])
  end

  def crearPuertaDelJuego(callback, puertasDisponibles, cantidadDeRepeticiones, puertasCreadas)
      when cantidadDeRepeticiones != 0 do
    puertaRandom = Enum.random(puertasDisponibles)
    puertasDisponibles = puertasDisponibles -- [puertaRandom]
    puertasCreadas = [callback.(puertaRandom) | puertasCreadas]
    crearPuertaDelJuego(callback, puertasDisponibles, cantidadDeRepeticiones - 1, puertasCreadas)
  end

  def crearPuertaDelJuego(_, puertasDisponibles, cantidadDeRepeticiones, puertasCreadas)
      when cantidadDeRepeticiones == 0 do
    %{puertasCreadas: puertasCreadas, puertasNoUtilizadas: puertasDisponibles}
  end

  def crearJuego(_, _, _) do
    IO.puts("No se puede crear el juego")
  end
end
