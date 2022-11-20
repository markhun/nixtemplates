{
  description = "markhun's flake templates";

  outputs = { self, ... }: {
    templates = {
      python-template = {
        path = ./python-template;
        description = "A Python project";
      };
    };
  };
}