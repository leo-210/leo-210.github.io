const {
    Renderer,
    Stave,
    StaveNote,
    Formatter,
    Beam
} = Vex.Flow;

const key = "c/5"
const duration_converter = {
    1: "16",
    2: "8",
    4: "q"
}


function render(notes) {
    const div = document.getElementById("output");
    const renderer = new Renderer(div, Renderer.Backends.SVG);

    // renderer.resize(1020, 1400);
    renderer.resize(1020, 1010);
    const context = renderer.getContext();

    let measures = []

    let x = 10
    let y = 0

    for (let i = 0; i < 4; i++) {
        for (let j = 0; j < 4; j++) {
            const notes_index = i * 4 + j
            if (!notes[notes_index]) break

            let measure = new Stave(x, y, 250)
                .setContext(context)
                .draw();

            measures.push(measure)
            x += measures[measures.length - 1].width

            let notes_to_draw = [];
            let k = 0;

            while (notes[notes_index].length > 0 && k < 1000) {
                let duration = getDuration(notes[notes_index]);

                let type = "";
                if (notes[notes_index][0] !== "o") {
                    type = "r";
                }

                notes_to_draw.push(new StaveNote({
                    keys: [key],
                    duration: duration_converter[duration],
                    type: type
                }));

                notes[notes_index] = notes[notes_index].slice(duration);

                k++;
            }

            const beams = Beam.generateBeams(notes_to_draw);
            Formatter.FormatAndDraw(context, measure, notes_to_draw);
            beams.forEach((b) => {
                b.setContext(context).draw();
            });
        }
        x = 10
        y += 100
    }

    measures[0].addClef("treble").addTimeSignature("4/4")
}

function getDuration(notes) {
    let current_index = 1;

    while (notes.length > current_index &&
        notes[current_index] !== "o" &&
        current_index < 4) { current_index++; }

    if (current_index === 3) {
        return 2
    }
    return current_index;
}
