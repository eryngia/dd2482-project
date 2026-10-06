package br.com.example.davidarchanjo.model.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
public class LoginRequestDTO {

    @NotEmpty
    @Email
    private String email;

    @NotEmpty
    private String password;

    @Builder
    public LoginRequestDTO(String email, String password) {
        this.email = email;
        this.password = password;
    }
}
