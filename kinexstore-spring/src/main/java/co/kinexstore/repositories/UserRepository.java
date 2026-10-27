package co.kinexstore.repositories;

import co.kinexstore.enums.Rol;
import co.kinexstore.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByEmail(String email);

    List<User> findByRol(Rol rol);

    List<User> findByActivoTrue();

    boolean existsByEmail(String email);
}
