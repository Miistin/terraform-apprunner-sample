package hello.world.commands;

import lombok.extern.slf4j.Slf4j;
import picocli.CommandLine.Command;

@Command(name = "hello", description = "Prints a greeting")
@Slf4j
public class HelloCommand implements Runnable {
    public void run() {
        log.info("Hello Fargate Tasks!");
    }
}
