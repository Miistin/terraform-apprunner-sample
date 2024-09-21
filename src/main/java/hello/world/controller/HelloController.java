package hello.world.controller;

import io.micronaut.http.HttpResponse;
import io.micronaut.http.MediaType;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import lombok.extern.slf4j.Slf4j;
import software.amazon.awssdk.services.ecs.EcsClient;
import software.amazon.awssdk.services.ecs.model.*;

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

    @Get(value = "/runbatch")
    public HttpResponse<String> ecstest() {
        try(var client = EcsClient.create()) {
            var runTaskRequest = RunTaskRequest.builder()
                    .cluster("my-batch-cluster")
                    .taskDefinition("my-batch-task")
                    .launchType(LaunchType.FARGATE)
                    .networkConfiguration(NetworkConfiguration.builder()
                            .awsvpcConfiguration(
                                AwsVpcConfiguration.builder()
                                        .subnets(System.getenv("SUBNET_IDS").split(","))
                                        .securityGroups(System.getenv("SECURITY_GROUP_ID"))
                                        .assignPublicIp(AssignPublicIp.ENABLED)
                                        .build()
                            ).build())
                    .build();
            var runTaskResponse = client.runTask(runTaskRequest);
            if (runTaskResponse.failures().size() > 0) {
                log.error("Failed to run task: {}", runTaskResponse.failures());
                return HttpResponse.serverError("Failed to run task: " + runTaskResponse.failures());
            } else {
                log.info("Task started: {}", runTaskResponse.tasks());
            }
        } finally {
            log.info("ECS Client closed");
        }
        return HttpResponse.ok("Hello ECS Tasks!");
    }
}
