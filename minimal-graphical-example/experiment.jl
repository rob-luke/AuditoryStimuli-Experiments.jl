using TerminalUserInterfaces
const TUI = TerminalUserInterfaces
using Markdown
using AuditoryStimuli, Pipe, Unitful, PortAudio

source = NoiseSource(Float64, 44.1u"kHz", 1, 0.2)
function get_soundcard_stream(soundcard::String="Fireface")
    a = PortAudio.devices()
    println(a)
    idx = [occursin(soundcard, d.name) for d in a]
    if sum(idx) > 1
        error("Multiple soundcards with requested name ($soundcard) were found: $a")
    end
    name = a[findfirst(idx)].name
    println("Using device: $name")
    stream = PortAudioStream(name, 0, 2)
end
sink = get_soundcard_stream()

function play_sound(duration = 1u"s")
    @pipe read(source, duration) |> write(sink, _)
end

function get_response_and_clear(t)
    c = TUI.get_event(t)
    while isready(t.stdin_channel)
        take!(t.stdin_channel)
    end
    return c
end


function main()


    TUI.initialize()
    t = TUI.Terminal()
    TUI.clear_screen()
    TUI.hide_cursor()

    streaming = Threads.@spawn play_sound(0.2u"s")
    
    instructions = "Select duration of the sound (1, 2, 3)? NA"
    split_instructions = split(instructions, " ")

    while true

        # Draw outer experiment box
        w, h = TUI.terminal_size()
        r = TUI.Rect(1, 1, w, h)
        b = TUI.Block(title = "Auditory Experiment")
        # p = TUI.Paragraph(b, [TUI.Word("Test", TUI.Crayon())], 1)
        p = TUI.Paragraph(b, [], 1)
        TUI.draw(t, p, r)

        # Draw description box
        r = TUI.Rect(5, h-35, w-10, 3)
        b = TUI.Block()
        p = TUI.Paragraph(b, [TUI.Word(t, TUI.Crayon()) for t in split("When you press either 1, 2, 3 it will play noise for that long")], 1)

        TUI.draw(t, p, r)
        # Draw response box
        r = TUI.Rect(5, h-25, w-10, 3)
        b = TUI.Block()
        p = TUI.Paragraph(b, [TUI.Word(t, TUI.Crayon()) for t in split_instructions], 1)
        TUI.draw(t, p, r)

        TUI.flush(t, false)

        fetch(streaming)

        c = get_response_and_clear(t)

        if c == '1'
            split_instructions[9] = "1"
            streaming = Threads.@spawn play_sound(1u"s")
        elseif c == '2'
            split_instructions[9] = "2"
            streaming = Threads.@spawn play_sound(2u"s")
        elseif c == '3'
            split_instructions[9] = "3"
            streaming = Threads.@spawn play_sound(3u"s")
        elseif c == 'q'
            break
        elseif c == '\x03'
            # keyboard interrupt
            break
        end

    end

    TUI.cleanup()
end


main()
