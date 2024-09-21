package hello.world;

import hello.world.commands.AppCommands;
import io.micronaut.runtime.Micronaut;

public class Application {

    public static void main(String[] args) {
        if (args.length > 1 && args[0].equals("cli")) {
            // arg[0] を除いた引数を渡す
            var newArgs = new String[args.length - 1];
            System.arraycopy(args, 1, newArgs, 0, args.length - 1);
            AppCommands.main(newArgs);
            return;
        }
        Micronaut.run(Application.class, args);
    }
}
