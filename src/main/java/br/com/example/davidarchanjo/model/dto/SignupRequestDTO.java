package br.com.example.davidarchanjo.model.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

@Data
@NoArgsConstructor
public class SignupRequestDTO {

    @NotEmpty
    @Email
    private String email;

    @NotEmpty
    @Size(min = 6, max = 100)
    private String password;

    @JsonProperty("fullName")
    private String fullName;

    @Builder
    public SignupRequestDTO(String email, String password, String fullName) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
    }
}
