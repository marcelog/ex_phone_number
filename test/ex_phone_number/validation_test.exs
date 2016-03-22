defmodule ExPhoneNumber.ValidationSpec do
  use Pavlov.Case, async: true

  doctest ExPhoneNumber.Validation
  import ExPhoneNumber.Validation

  describe ".validate_length" do
    context "length less or equal to Constant.Value.max_input_string_length" do
      subject do: "1234567890"
      it "returns {:ok, number}" do
        assert {:ok, _} = validate_length(subject)
      end
    end

    context "length larger than Constant.Value.max_input_string_length" do
      subject do: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890x"
      it "returns {:error, message}" do
        assert {:error, _} = validate_length(subject)
      end
    end
  end

  describe ".viable_phone_number?" do
    context "ascii chars" do
      it "should contain at least 2 chars" do
        refute viable_phone_number?("1")
      end

      it "should allow only one or two digits before strange non-possible puntuaction" do
        refute viable_phone_number?("1+1+1")
        refute viable_phone_number?("80+0")
      end

      it "should allow two or more digits" do
        assert viable_phone_number?("00")
        assert viable_phone_number?("111")
      end

      it "should allow alpha numbers" do
        assert viable_phone_number?("0800-4-pizza")
        assert viable_phone_number?("0800-4-PIZZA")
      end

      it "should contain at least three digits before any alpha char" do
        refute viable_phone_number?("08-PIZZA")
        refute viable_phone_number?("8-PIZZA")
        refute viable_phone_number?("12. March")
      end
    end

    context "non-ascii chars" do
      it "should allow only one or two digits before strange non-possible puntuaction" do
        assert viable_phone_number?("1\u300034")
        refute viable_phone_number?("1\u30003+4")
      end

      it "should allow unicode variants of starting chars" do
        assert viable_phone_number?("\uFF081\uFF09\u30003456789")
      end

      it "should allow leading plus sign" do
        assert viable_phone_number?("+1\uFF09\u30003456789")
      end
    end
  end

end