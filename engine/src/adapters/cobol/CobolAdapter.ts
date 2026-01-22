import type { Adapter } from "../../core/registry/Adapter.js";
import { CobolIndexStage } from "./stages/cobolIndex.stage.js";
import { CallGraphStage } from "./stages/callgraph.stage.js";
import { MetricsStage } from "./stages/metrics.stage.js";
import { RisksStage } from "./stages/risks.stage.js";
import { ReportStage } from "./stages/report.stage.js";

export const CobolAdapter: Adapter = {
    id: "cobol",
    description: "COBOL V1 Analysis Adapter using Static Regex",

    getStages() {
        return [
            CobolIndexStage,
            CallGraphStage,
            MetricsStage,
            RisksStage,
            ReportStage
        ];
    },

    kindMap: {
        ".cbl": "cobol",
        ".cob": "cobol",
        ".cobol": "cobol",
        ".pco": "cobol",
        ".cpy": "copybook",
        ".copy": "copybook",
        ".copybook": "copybook",
        ".jcl": "jcl"
    }
};
