# frozen_string_literal: true
RSpec.describe HTTP::PrettyPrinter do
  class FakeRe
    include HTTP::Headers::Mixin
    include HTTP::PrettyPrinter

    attr_accessor :body

    def initialize
      @headers = HTTP::Headers.new
    end

    private

    def headline
      "FakeRe headline"
    end
  end

  let(:fake) do
    fake = FakeRe.new
    fake.headers.set :my_header, "My value"
    fake.headers.set :set_cookie, %w(hoo=ray woo=hoo)
    fake.body = "Work my body over"
    fake
  end

  describe "#inspect" do
    subject { fake.inspect }
    it { is_expected.to eq "FakeRe headline\nMy-Header: My value\nSet-Cookie: hoo=ray; woo=hoo" }
  end

  describe "#pretty_print" do
    context "using default options" do
      subject { fake.pretty_print }

      it { is_expected.to eq "FakeRe headline" }
    end

    context "with headers" do
      subject { fake.pretty_print(:skip_headers => false) }

      it { is_expected.to eq "FakeRe headline\nMy-Header: My value\nSet-Cookie: hoo=ray; woo=hoo" }
    end

    context "with headers and body" do
      subject { fake.pretty_print(:skip_headers => false, :skip_body => false) }

      it { is_expected.to eq "FakeRe headline\nMy-Header: My value\nSet-Cookie: hoo=ray; woo=hoo\nWork my body over" }
    end

    context "with body, but without headers" do
      subject { fake.pretty_print(:skip_body => false) }

      it { is_expected.to eq "FakeRe headline" }
    end

    context "supplying a separator" do
      subject { fake.pretty_print(:skip_headers => false, :skip_body => false, :separator => " | ") }

      it { is_expected.to eq "FakeRe headline | My-Header: My value | Set-Cookie: hoo=ray; woo=hoo | Work my body over" }
    end
  end
end