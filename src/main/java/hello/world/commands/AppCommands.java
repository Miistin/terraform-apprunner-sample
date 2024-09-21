package hello.world.commands;

import io.micronaut.configuration.picocli.PicocliRunner;
import lombok.extern.slf4j.Slf4j;
import picocli.CommandLine.Command;

@Slf4j
@Command(name = "app", description = "Application commands", subcommands = {HelloCommand.class})
public class AppCommands implements Runnable {
    public void run() {
        // This method is called when the command is invoked
    }

    public static void main(String[] args) {
        log.info("Executing app commands");
        PicocliRunner.run(AppCommands.class, args);
        log.info("Executed app commands");
        System.exit(0);
    }
}
