//
//  SingularizeTests.swift
//  SwiftFormatTests
//
//  Created by Nick Lockwood on 02/01/2024.
//  Copyright © 2024 Nick Lockwood. All rights reserved.
//

import XCTest
@testable import SwiftFormat

class SingularizeTests: XCTestCase {
    func testSingularization() {
        XCTAssertEqual("addenda".singularized(), "addendum")
        XCTAssertEqual("aircraft".singularized(), "aircraft")
        XCTAssertEqual("aliases".singularized(), "alias")
        XCTAssertEqual("alumnae".singularized(), "alumna")
        XCTAssertEqual("alumni".singularized(), "alumnus")
        XCTAssertEqual("analyses".singularized(), "analysis")
        XCTAssertEqual("antennae".singularized(), "antenna")
        XCTAssertEqual("antennas".singularized(), "antenna")
        XCTAssertEqual("apexes".singularized(), "apex")
        XCTAssertEqual("apices".singularized(), "apex")
        XCTAssertEqual("appendices".singularized(), "appendix")
        XCTAssertEqual("axes".singularized(), "axis")
        XCTAssertEqual("bacilli".singularized(), "bacillus")
        XCTAssertEqual("backhoes".singularized(), "backhoe")
        XCTAssertEqual("bacteria".singularized(), "bacterium")
        XCTAssertEqual("bases".singularized(), "base")
        XCTAssertEqual("bison".singularized(), "bison")
        XCTAssertEqual("buses".singularized(), "bus")
        XCTAssertEqual("bureaux".singularized(), "bureau")
        XCTAssertEqual("cacti".singularized(), "cactus")
        XCTAssertEqual("centers".singularized(), "center")
        XCTAssertEqual("children".singularized(), "child")
        XCTAssertEqual("cilia".singularized(), "cilium")
        XCTAssertEqual("codices".singularized(), "codex")
        XCTAssertEqual("curricula".singularized(), "curriculum")
        XCTAssertEqual("criteria".singularized(), "criterion")
        XCTAssertEqual("criteria".singularized(), "criterion")
        XCTAssertEqual("deer".singularized(), "deer")
        XCTAssertEqual("diagnoses".singularized(), "diagnosis")
        XCTAssertEqual("dice".singularized(), "die")
        XCTAssertEqual("dogs".singularized(), "dog")
        XCTAssertEqual("doormice".singularized(), "doormouse")
        XCTAssertEqual("dwarves".singularized(), "dwarf")
        XCTAssertEqual("ellipses".singularized(), "ellipsis")
        XCTAssertEqual("errata".singularized(), "erratum")
        XCTAssertEqual("fairies".singularized(), "fairy")
        XCTAssertEqual("faxes".singularized(), "fax")
        XCTAssertEqual("fezes".singularized(), "fez")
        XCTAssertEqual("fezzes".singularized(), "fez")
        XCTAssertEqual("fish".singularized(), "fish")
        XCTAssertEqual("fishes".singularized(), "fish")
        XCTAssertEqual("foci".singularized(), "focus")
        XCTAssertEqual("foes".singularized(), "foe")
        XCTAssertEqual("formulae".singularized(), "formula")
        XCTAssertEqual("foxes".singularized(), "fox")
        XCTAssertEqual("fruit".singularized(), "fruit")
        XCTAssertEqual("fruits".singularized(), "fruit")
        XCTAssertEqual("fungi".singularized(), "fungus")
        XCTAssertEqual("funguses".singularized(), "fungus")
        XCTAssertEqual("geese".singularized(), "goose")
        XCTAssertEqual("genera".singularized(), "genus")
        XCTAssertEqual("graffiti".singularized(), "graffito")
        XCTAssertEqual("grandchildren".singularized(), "grandchild")
        XCTAssertEqual("grouse".singularized(), "grouse")
        XCTAssertEqual("grouses".singularized(), "grouse")
        XCTAssertEqual("halves".singularized(), "half")
        XCTAssertEqual("hooves".singularized(), "hoof")
        XCTAssertEqual("indices".singularized(), "index")
        XCTAssertEqual("items".singularized(), "item")
        XCTAssertEqual("knives".singularized(), "knife")
        XCTAssertEqual("larvae".singularized(), "larva")
        XCTAssertEqual("larvas".singularized(), "larva")
        XCTAssertEqual("leaves".singularized(), "leaf")
        XCTAssertEqual("libretti".singularized(), "libretto")
        XCTAssertEqual("librettos".singularized(), "libretto")
        XCTAssertEqual("lives".singularized(), "life")
        XCTAssertEqual("loaves".singularized(), "loaf")
        XCTAssertEqual("loci".singularized(), "locus")
        XCTAssertEqual("matrices".singularized(), "matrix")
        XCTAssertEqual("matrixes".singularized(), "matrix")
        XCTAssertEqual("memoranda".singularized(), "memorandum")
        XCTAssertEqual("mice".singularized(), "mouse")
        XCTAssertEqual("millennia".singularized(), "millennium")
        XCTAssertEqual("minutiae".singularized(), "minutia")
        XCTAssertEqual("moves".singularized(), "move")
        XCTAssertEqual("movies".singularized(), "movie")
        XCTAssertEqual("noobies".singularized(), "nooby")
        XCTAssertEqual("nebulae".singularized(), "nebula")
        XCTAssertEqual("nucleae".singularized(), "nucleus")
        XCTAssertEqual("oases".singularized(), "oasis")
        XCTAssertEqual("octopuses".singularized(), "octopus")
        XCTAssertEqual("octopi".singularized(), "octopus")
        XCTAssertEqual("offspring".singularized(), "offspring")
        XCTAssertEqual("opera".singularized(), "opus")
        XCTAssertEqual("opuses".singularized(), "opus")
        XCTAssertEqual("ova".singularized(), "ovum")
        XCTAssertEqual("oxen".singularized(), "ox")
        XCTAssertEqual("parentheses".singularized(), "parenthesis")
        XCTAssertEqual("people".singularized(), "person")
        XCTAssertEqual("phenomena".singularized(), "phenomenon")
        XCTAssertEqual("phenomenons".singularized(), "phenomenon")
        XCTAssertEqual("phyla".singularized(), "phylum")
        XCTAssertEqual("potatoes".singularized(), "potato")
        XCTAssertEqual("praxes".singularized(), "praxis")
        XCTAssertEqual("quizzes".singularized(), "quiz")
        XCTAssertEqual("radii".singularized(), "radius")
        XCTAssertEqual("referenda".singularized(), "referendum")
        XCTAssertEqual("referendums".singularized(), "referendum")
        XCTAssertEqual("salmon".singularized(), "salmon")
        XCTAssertEqual("scarfs".singularized(), "scarf")
        XCTAssertEqual("scarves".singularized(), "scarf")
        XCTAssertEqual("selves".singularized(), "self")
        XCTAssertEqual("series".singularized(), "series")
        XCTAssertEqual("sheep".singularized(), "sheep")
        XCTAssertEqual("shoes".singularized(), "shoe")
        XCTAssertEqual("shrimp".singularized(), "shrimp")
        XCTAssertEqual("shrimps".singularized(), "shrimp")
        XCTAssertEqual("sofas".singularized(), "sofa")
        XCTAssertEqual("species".singularized(), "species")
        XCTAssertEqual("statuses".singularized(), "status")
        XCTAssertEqual("stimuli".singularized(), "stimulus")
        XCTAssertEqual("strata".singularized(), "stratum")
        XCTAssertEqual("syllabi".singularized(), "syllabus")
        XCTAssertEqual("syllabuses".singularized(), "syllabus")
        XCTAssertEqual("symposia".singularized(), "symposium")
        XCTAssertEqual("symposiums".singularized(), "symposium")
        XCTAssertEqual("synopses".singularized(), "synopsis")
        XCTAssertEqual("swine".singularized(), "swine")
        XCTAssertEqual("tableaux".singularized(), "tableau")
        XCTAssertEqual("taxes".singularized(), "tax")
        XCTAssertEqual("teeth".singularized(), "tooth")
        XCTAssertEqual("theses".singularized(), "thesis")
        XCTAssertEqual("thieves".singularized(), "thief")
        XCTAssertEqual("toes".singularized(), "toe")
        XCTAssertEqual("tomatoes".singularized(), "tomato")
        XCTAssertEqual("trout".singularized(), "trout")
        XCTAssertEqual("trouts".singularized(), "trout")
        XCTAssertEqual("tuna".singularized(), "tuna")
        XCTAssertEqual("tunas".singularized(), "tuna")
        XCTAssertEqual("vertebrae".singularized(), "vertebra")
        XCTAssertEqual("vertebras".singularized(), "vertebra")
        XCTAssertEqual("vertices".singularized(), "vertex")
        XCTAssertEqual("villae".singularized(), "villa")
        XCTAssertEqual("viruses".singularized(), "virus")
        XCTAssertEqual("virii".singularized(), "virus")
        XCTAssertEqual("viri".singularized(), "virus")
        XCTAssertEqual("vitae".singularized(), "vita")
        XCTAssertEqual("vortexes".singularized(), "vortex")
        XCTAssertEqual("vortices".singularized(), "vortex")
        XCTAssertEqual("wharfs".singularized(), "wharf")
        XCTAssertEqual("wharves".singularized(), "wharf")
        XCTAssertEqual("wives".singularized(), "wife")
        XCTAssertEqual("wolves".singularized(), "wolf")
        XCTAssertEqual("women".singularized(), "woman")
        XCTAssertEqual("zombies".singularized(), "zombie")
    }

    func testPreserveCase() {
        XCTAssertEqual("Axes".singularized(), "Axis")
        XCTAssertEqual("COMPUTERS".singularized(), "COMPUTER")
        XCTAssertEqual("Teeth".singularized(), "Tooth")
    }

    func testStripAllPrefix() {
        XCTAssertEqual("allWindows".singularized(), "window")
        XCTAssertEqual("AllTargets".singularized(), "Target")
    }

    func testDontUseDatumOrMedium() {
        XCTAssertEqual("data".singularized(), "data")
        XCTAssertEqual("media".singularized(), "media")
        XCTAssertEqual("allMedia".singularized(), "media")
    }

    func testDontSingularizeNonPlurals() {
        XCTAssertNil("uppercase".singularized())
        XCTAssertNil("uppercased".singularized())
        XCTAssertNil("rotate".singularized())
        XCTAssertNil("map".singularized())
        XCTAssertNil("filter".singularized())
        XCTAssertNil("capitalize".singularized())
        XCTAssertNil("tessellate".singularized())
    }
}