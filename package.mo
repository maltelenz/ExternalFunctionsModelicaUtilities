package ExternalFunctionsModelicaUtilities
  package BaseFunctions "Common interface declarations for functions"
    replaceable function sizef "Returns size of arrays based on name input"
      input String name;
      output Integer N;
    end sizef;
    
    replaceable function compute "Compute a function of x based on the name input"
      input String name;
      input Real x;
      output Real y;
    end compute;
  end BaseFunctions;

  package ModelicaFunctions "Modelica implementation"
    extends BaseFunctions;
    redeclare function extends sizef
    algorithm
      if name == "foobar" then
        N := 3;
      else
        assert(false, "Unsupported name");
      end if;
    end sizef;
    
    redeclare function extends compute
      input String name;
      input Real x;
      output Real y;
    algorithm
      if name == "foobar" then
        y := 1 + x^2;
        assert(y <= 10, "Value of x = " + String(x) + " could be too high", AssertionLevel.warning);
        assert(y <= 17, "Value of x = "+ String(x) + " is too high");
      else
        assert(false, "Unsupported name");
      end if;
    end compute;
  end ModelicaFunctions;
  
  package ExternalFunctions
    extends BaseFunctions;

    redeclare function extends sizef
      external "C";
    annotation(
      LibraryDirectory="modelica://ExternalFunctionsModelicaUtilities/Resources/Source/build",
      Library="functions",
      IncludeDirectory="modelica://ExternalFunctionsModelicaUtilities/Resources/Source",
      Include="#include \"functions.h\"");
    end sizef;
    
    redeclare function extends compute
      external "C";
    annotation(
      LibraryDirectory="modelica://ExternalFunctionsModelicaUtilities/Resources/Source/build",
      Library="functions",
      IncludeDirectory="modelica://ExternalFunctionsModelicaUtilities/Resources/Source",
      Include="#include \"functions.h\"");
    end compute;
  end ExternalFunctions;

  partial model M "The mother of all test models"
    replaceable package P = BaseFunctions;
    parameter String name = "undefined";
    parameter Integer N = P.sizef(name) annotation(Evaluate = true);
    Real y[N];
  equation
    for i in 1:N loop
      y[i] = P.compute(name, time/i);
    end for;
  end M;
  
  model M1M "Should fail at compile time with Undefined name error"
    extends M(redeclare package P = ModelicaFunctions);
    annotation(experiment(StopTime = 10));
  end M1M;
  
  model M2M "Shoud simulate until time = 4 with warning at time = 3, then fail"
    extends M(redeclare package P = ModelicaFunctions, name = "foobar");
    annotation(experiment(StopTime = 10));
  end M2M;

  model M3M "Same as M2M but N is provided by a literal, not by a function"
    extends M(redeclare package P = ModelicaFunctions, name = "foobar", N = 3);
    annotation(experiment(StopTime = 10));
  end M3M;

  model M1E "Same as M1M with external function implementation"
    extends M1M(redeclare package P = ExternalFunctions);
    annotation(experiment(StopTime = 10));
  end M1E;
  
  model M2E "Same as M2M with external function implementation"
    extends M2M(redeclare package P = ExternalFunctions, name = "foobar");
    annotation(experiment(StopTime = 10));
  end M2E;

  model M3E "Same as M3M with external function implementation"
    extends M3M(redeclare package P = ExternalFunctions, name = "foobar", N = 3);
    annotation(experiment(StopTime = 10));
  end M3E;
end ExternalFunctionsModelicaUtilities;
