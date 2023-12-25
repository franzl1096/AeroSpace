private struct RawMoveWorkspaceToMonitorCmdArgs: RawCmdArgs {
    var monitorTarget: MoveWorkspaceToMonitorCmdArgs.MonitorTarget? // todo introduce --wrap-around flag

    static let parser: CmdParser<Self> = cmdParser(
        kind: .moveWorkspaceToMonitor,
        allowInConfig: true,
        help: """
              USAGE: move-workspace-to-monitor [-h|--help] (next|prev)

              OPTIONS:
                -h, --help              Print help
              """,
        options: [:],
        arguments: [ArgParser(\.monitorTarget, parseMonitorTarget)]
    )
}

public struct MoveWorkspaceToMonitorCmdArgs: CmdArgs {
    public static let info: CmdStaticInfo = RawMoveWorkspaceToMonitorCmdArgs.info

    public let target: MonitorTarget
    public enum MonitorTarget: String, CaseIterable {
        case next, prev
    }
}

public func parseMoveWorkspaceToMonitorCmdArgs(_ args: [String]) -> ParsedCmd<MoveWorkspaceToMonitorCmdArgs> {
    parseRawCmdArgs(RawMoveWorkspaceToMonitorCmdArgs(), args)
        .flatMap { raw in
            guard let target = raw.monitorTarget else {
                return .failure("<workspace-name> is mandatory argument")
            }
            return .cmd(MoveWorkspaceToMonitorCmdArgs(
                target: target
            ))
        }
}

private func parseMonitorTarget(_ arg: String) -> Parsed<MoveWorkspaceToMonitorCmdArgs.MonitorTarget> {
    parseEnum(arg, MoveWorkspaceToMonitorCmdArgs.MonitorTarget.self)
}