package hello.world.controller;

import io.micronaut.http.HttpResponse;
import io.micronaut.http.MediaType;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import lombok.extern.slf4j.Slf4j;

import java.util.Optional;

@Controller("/")
@Slf4j
public class HelloController {
    @Get(value = "/", produces = MediaType.TEXT_PLAIN)
    public HttpResponse<String> hello(@QueryValue("name") Optional<String> name) {
        var result = name.orElse("world");
        log.info("Hello - {}", result);
        return HttpResponse.ok("Hello " + result + "!");
    }
}
