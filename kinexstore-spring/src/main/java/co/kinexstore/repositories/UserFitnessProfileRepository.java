package co.kinexstore.repositories;

import co.kinexstore.models.UserFitnessProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserFitnessProfileRepository extends JpaRepository<UserFitnessProfile, Long> {

    Optional<UserFitnessProfile> findByUserId(Long userId);

    boolean existsByUserId(Long userId);
}
