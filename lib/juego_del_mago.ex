defmodule JuegoDelMago do
  def daleAlJuego(juego, ronda) do
    cond do
      termino?(ronda, juego) ->
        :ok

      true ->
        mostrarLasPuertasConSuEstadoActual(juego) |> IO.puts()
        %{puertaSeleccionada: puerta, juego: juegoActual} = seleccionarUnaPuerta(juego, ronda)
        mostrarElPremioDeLaPuertaSeleccionada(puerta) |> IO.puts()

        %{dineroAcumulado: dinero, llantasEncontradas: conteoDeLlantas} =
          obtenerLosPremiosAcumuladosDelJuego(juegoActual)

        IO.puts("Total acumulado: $#{dinero}\nLlantas encontradas: #{conteoDeLlantas}\n")
        daleAlJuego(juegoActual, ronda + 1)
    end
  end

  def termino?(ronda, juegoActual) do
    cond do
      ronda == 7 or obtenerLosPremiosAcumuladosDelJuego(juegoActual).llantasEncontradas == 4 or
          obtenerLosPremiosAcumuladosDelJuego(juegoActual).errores == 3 ->
        obtenerElResultadoDelJuego(juegoActual)
        true

      true ->
        false
    end
  end

  def obtenerElResultadoDelJuego(juegoActual) do
    mostrarLasPuertasConSuEstadoActual(juegoActual) |> IO.puts()
    IO.puts("\n!Se ha terminado el juego!")

    %{dineroAcumulado: dinero, llantasEncontradas: conteoDeLlantas} =
      obtenerLosPremiosAcumuladosDelJuego(juegoActual)

    cond do
      conteoDeLlantas == 4 and dinero > 0 ->
        IO.puts("¡Has ganado el carro!\n Y también dinerico $#{dinero}")

      conteoDeLlantas == 4 ->
        IO.puts("¡Has ganado el carro!")

      dinero > 0 ->
        IO.puts("Ganancia: $#{dinero}")

      true ->
        IO.puts("No ganaste nada :(")
    end
  end

  def juego() do
    daleAlJuego(Structs.Juego.crearJuego(3, 4, 3), 1)
  end

  def obtenerLosPremiosAcumuladosDelJuego(juegoActual) do
    Enum.reduce(
      Enum.filter(juegoActual.puertas, & &1.abierta?),
      %{dineroAcumulado: 0, llantasEncontradas: 0, errores: 0},
      fn puerta, acc ->
        %{
          dineroAcumulado: acc.dineroAcumulado + puerta.dinero,
          llantasEncontradas: acc.llantasEncontradas + if(puerta.tieneLlanta?, do: 1, else: 0),
          errores: acc.errores + if(puerta.dinero == 0 and !puerta.tieneLlanta?, do: 1, else: 0)
        }
      end
    )
  end

  def mostrarElPremioDeLaPuertaSeleccionada(puerta) do
    case puerta do
      %{abierta?: true} ->
        "Ya estaba abierta :(\n"

      %{tieneLlanta?: true} ->
        "Has encontrado una llanta.\n"

      %{dinero: dinero} when dinero != 0 ->
        "Has obtenido $#{dinero}\n"

      %{dinero: 0, display: display} ->
        "No hay nada en la #{display}\n"

      _ ->
        puerta.display
    end
  end

  def seleccionarUnaPuerta(juegoActual, ronda) do
    IO.puts("\nRonda##{ronda}\nSelecciona una puerta:")
    resultado = IO.gets("") |> String.trim() |> opcionCorrectaDeLaPuerta()

    case resultado do
      %{esValido?: true, opcionPuerta: opcion} ->
        %{
          puertaSeleccionada: obtenerLaPuertaSeleccionada(juegoActual, opcion),
          juego: actualizarElEstadoDeLaPuertaDelJuego(juegoActual, opcion)
        }

      %{esValido?: false, opcionPuerta: nil} ->
        IO.puts("Opcion invalida :(")
        seleccionarUnaPuerta(juegoActual, ronda)
    end
  end

  def obtenerLaPuertaSeleccionada(juego, opcion) do
    Enum.find(juego.puertas, fn puerta -> puerta |> Map.get(:opcion) == opcion end)
  end

  def actualizarElEstadoDeLaPuertaDelJuego(juego, opcion) do
    %{
      juego
      | puertas:
          juego.puertas
          |> Enum.map(fn puerta ->
            if puerta |> Map.get(:opcion) == opcion do
              %{puerta | abierta?: true}
            else
              puerta
            end
          end)
    }
  end

  def opcionCorrectaDeLaPuerta(seleccion) do
    case String.to_integer(seleccion) do
      opcion when is_integer(opcion) and opcion > 0 and opcion < 11 ->
        %{esValido?: true, opcionPuerta: opcion}

      _ ->
        %{esValido?: false, opcionPuerta: nil}
    end
  end

  def mostrarLasPuertasConSuEstadoActual(juego) do
    juego.puertas
    |> Enum.map(&obtenerElEstadoActualDeLaPuerta/1)
    |> Enum.join(" | ")
  end

  def obtenerElEstadoActualDeLaPuerta(puerta) do
    case puerta do
      %{abierta?: true, tieneLlanta?: true} ->
        "0"

      %{abierta?: true, dinero: dinero} when dinero != 0 ->
        "$#{dinero}"

      %{abierta?: true, dinero: 0} ->
        "X"

      _ ->
        puerta.display
    end
  end
end
