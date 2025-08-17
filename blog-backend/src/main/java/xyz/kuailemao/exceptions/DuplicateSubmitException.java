package xyz.kuailemao.exceptions;

public class DuplicateSubmitException extends RuntimeException {
    public DuplicateSubmitException(String message) {
        super(message);
    }
}