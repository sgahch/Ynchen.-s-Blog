package xyz.kuailemao;

import lombok.extern.slf4j.Slf4j;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;

@EnableCaching
@MapperScan("xyz.kuailemao.mapper")
@SpringBootApplication
@EnableMethodSecurity
@Slf4j
public class BlogBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(BlogBackendApplication.class, args);

        log.info(
                """
                \n
                ---------------------------------------------------------恭喜你成功启动后端---------------------------------------------------------
                        
                        ██╗   ██╗    ███╗   ██╗     ██████╗    ██╗  ██╗    ███████╗    ███╗   ██╗      \s
                        ╚██╗ ██╔╝    ████╗  ██║    ██╔════╝    ██║  ██║    ██╔════╝    ████╗  ██║      \s
                         ╚████╔╝     ██╔██╗ ██║    ██║         ███████║    █████╗      ██╔██╗ ██║      \s
                          ╚██╔╝      ██║╚██╗██║    ██║         ██╔══██║    ██╔══╝      ██║╚██╗██║      \s
                           ██║       ██║ ╚████║    ╚██████╗    ██║  ██║    ███████╗    ██║ ╚████║    ██╗
                           ╚═╝       ╚═╝  ╚═══╝     ╚═════╝    ╚═╝  ╚═╝    ╚══════╝    ╚═╝  ╚═══╝    ╚═╝
                        
                        
                """
        );
    }
}
