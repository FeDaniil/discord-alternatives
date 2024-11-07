import { SvelteComponent } from "svelte";
import type { ModeWatcherProps } from "./types.js";
declare const __propDef: {
    props: ModeWatcherProps;
    events: {
        [evt: string]: CustomEvent<any>;
    };
    slots: {};
    exports?: {} | undefined;
    bindings?: string | undefined;
};
type ModeWatcherProps_ = typeof __propDef.props;
export { ModeWatcherProps_ as ModeWatcherProps };
export type ModeWatcherEvents = typeof __propDef.events;
export type ModeWatcherSlots = typeof __propDef.slots;
export default class ModeWatcher extends SvelteComponent<ModeWatcherProps_, ModeWatcherEvents, ModeWatcherSlots> {
}
