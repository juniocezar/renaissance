package org.renaissance;

public class DummyResult implements BenchmarkResult {
  public DummyResult() {
  }

  @Override
  public void validate() {
    throw new ValidationException("Not implemented");
  }
}
