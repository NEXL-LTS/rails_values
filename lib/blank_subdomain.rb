class BlankSubdomain < Blank
  include Comparable

  def <=>(other)
    to_str <=> other.to_str
  end

  def eql?(other)
    other.blank?
  end

  delegate :hash, to: :to_str

  def free_email?
    false
  end

  def local_email(*)
    raise 'Cannot generate local email from blank subdomain'
  end

  def student?
    false
  end

  def to_str
    ''
  end

  def parts
    []
  end
end
