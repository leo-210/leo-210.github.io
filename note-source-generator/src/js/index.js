function generateNotes(max_notes, measure_quantity) {
    let notes = []
    for (let i = 0; i < measure_quantity; i++) {
        let notes_ = "----------------"
        
        for (let j = 0; j < max_notes; j++) {
            let index = (Math.random() * 17) >> 0
            notes_ = notes_.substring(0,index) + "o" + notes_.substring(index+1);
        }

        notes.push(notes_)
    }
    console.log(notes)
    return notes
}

render(generateNotes(5, 16))
let svg = document.getElementById("output").firstElementChild
svg.removeAttribute("style")
svg.removeAttribute("width")
svg.removeAttribute("height")
