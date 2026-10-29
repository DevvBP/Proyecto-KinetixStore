package co.kinexstore.controllers;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Manejador global de excepciones para KinexStore.
 * Captura excepciones no controladas y proporciona respuestas elegantes tanto
 * para la capa web (JSP) como para los clientes de la API RESTful.
 */
@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(IllegalArgumentException.class)
    public Object handleIllegalArgument(IllegalArgumentException ex, HttpServletRequest request) {
        log.warn("Excepción de argumento no válido en [{}]: {}", request.getRequestURI(), ex.getMessage());
        if (esPeticionApi(request)) {
            return construirRespuestaApi(HttpStatus.BAD_REQUEST, ex.getMessage(), request.getRequestURI());
        }
        ModelAndView mav = new ModelAndView("error");
        mav.addObject("errorCodigo", 400);
        mav.addObject("errorMensaje", ex.getMessage());
        return mav;
    }

    @ExceptionHandler(Exception.class)
    public Object handleGlobalException(Exception ex, HttpServletRequest request) {
        log.error("Excepción inesperada en [{}]: {}", request.getRequestURI(), ex.getMessage(), ex);
        if (esPeticionApi(request)) {
            return construirRespuestaApi(HttpStatus.INTERNAL_SERVER_ERROR, "Ha ocurrido un error interno en el servidor", request.getRequestURI());
        }
        ModelAndView mav = new ModelAndView("error");
        mav.addObject("errorCodigo", 500);
        mav.addObject("errorMensaje", "Ocurrió una anomalía inesperada al procesar tu solicitud. Por favor intenta nuevamente.");
        return mav;
    }

    private boolean esPeticionApi(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String accept = request.getHeader("Accept");
        return uri.startsWith("/api/") || (accept != null && accept.contains("application/json"));
    }

    private ResponseEntity<Map<String, Object>> construirRespuestaApi(HttpStatus status, String mensaje, String path) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", LocalDateTime.now());
        body.put("status", status.value());
        body.put("error", status.getReasonPhrase());
        body.put("mensaje", mensaje);
        body.put("path", path);
        return ResponseEntity.status(status).body(body);
    }
}
