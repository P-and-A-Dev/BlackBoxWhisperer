export interface CobolProgramIndex {
    file: string;
    sha256: string;
    programId?: string;
    calls: Array<{ target?: string; raw: string; line: number }>;
    performs: Array<{ target?: string; raw: string; line: number }>;
    copies: Array<{ target?: string; raw: string; line: number }>;
}

export interface CobolIndexArtifactV1 {
    schemaVersion: "1.0";
    adapter: "cobol";
    generatedFrom: { fileCount: number };
    programs: CobolProgramIndex[];
}
