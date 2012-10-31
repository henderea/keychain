module CF
  typedef :pointer, :cfnumberref
  enum :cf_number_type, [
    :kCFNumberSInt8Type,1,
    :kCFNumberSInt16Type,2,
    :kCFNumberSInt32Type,3,
    :kCFNumberSInt64Type,4,
    :kCFNumberFloat32Type,5,
    :kCFNumberFloat64Type,6,
    :kCFNumberCharType,7,
    :kCFNumberShortType,8,
    :kCFNumberIntType,9,
    :kCFNumberLongType,10,
    :kCFNumberLongLongType,11,
    :kCFNumberFloatType,12,
    :kCFNumberDoubleType,13,
    :kCFNumberCFIndexType,14,
    :kCFNumberNSIntegerType,15,
    :kCFNumberCGFloatType,16,
    :kCFNumberMaxType,16
  ]

  attach_function 'CFNumberGetValue', [:cfnumberref, :cf_number_type, :pointer], :bool
  attach_function 'CFNumberCreate', [:pointer, :cf_number_type, :pointer], :cfnumberref

  class Number < Base
    register_type 'CFNumber'
    def self.from_f(float)
      p = FFI::MemoryPointer.new(:double)
      p.write_double(float.to_f)
      new(CF.CFNumberCreate(nil, :kCFNumberDoubleType, p)).release_on_gc
    end

    def self.from_i(int)
      p = FFI::MemoryPointer.new(:int64)
      p.write_int64(int.to_i)
      new(CF.CFNumberCreate(nil, :kCFNumberSInt64Type, p)).release_on_gc
    end

    def to_i
      p = FFI::MemoryPointer.new(:int64)
      if CF.CFNumberGetValue(self, :kCFNumberSInt64Type, p)
        p.read_int64
      else
        raise "CF.CFNumberGetValue failed to convert #{self.inspect} to kCFNumberSInt64Type"
      end
    end

    def to_f
      p = FFI::MemoryPointer.new(:double)
      if CF.CFNumberGetValue(self, :kCFNumberDoubleType, p)
        p.read_double
      else
        raise "CF.CFNumberGetValue failed to convert #{self.inspect} to kCFNumberDoubleType"
      end
    end
  end
end