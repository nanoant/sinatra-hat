class Date
  silence_warnings do
    MONTHNAMES = [nil,
      N_('January'),
      N_('February'),
      N_('March'),
      N_('April'),
      N_('May'),
      N_('June'),
      N_('July'),
      N_('August'),
      N_('September'),
      N_('October'),
      N_('November'),
      N_('December')]

    BASE_MONTHNAMES = [nil,
      N_('b|January'),
      N_('b|February'),
      N_('b|March'),
      N_('b|April'),
      N_('b|May'),
      N_('b|June'),
      N_('b|July'),
      N_('b|August'),
      N_('b|September'),
      N_('b|October'),
      N_('b|November'),
      N_('b|December')]

    DAYNAMES = [
      N_('Sunday'),
      N_('Monday'),
      N_('Tuesday'),
      N_('Wednesday'),
      N_('Thursday'),
      N_('Friday'),
      N_('Saturday')]

    ABBR_MONTHNAMES = [nil,
      N_('Jan'),
      N_('Feb'),
      N_('Mar'),
      N_('Apr'),
      N_('May'),
      N_('Jun'),
      N_('Jul'),
      N_('Aug'),
      N_('Sep'),
      N_('Oct'),
      N_('Nov'),
      N_('Dec')]

    ABBR_DAYNAMES = [
      N_('Sun'),
      N_('Mon'),
      N_('Tue'),
      N_('Wed'),
      N_('Thu'),
      N_('Fri'),
      N_('Sat')]
  end
end

class Time
  alias :strftime_nolocale :strftime

  def strftime_gettext(format)
    format = format.dup
    format.gsub!(/%a/, _(Date::ABBR_DAYNAMES[self.wday]))
    format.gsub!(/%A/, _(Date::DAYNAMES[self.wday]))
    format.gsub!(/%b/, _(Date::ABBR_MONTHNAMES[self.mon]))
    format.gsub!(/%B/, _(Date::MONTHNAMES[self.mon]))
    self.strftime_nolocale(format)
  end

  def to_s
    strftime_gettext _('%I:%M %p, %A, %B %d, %Y')
  end
end
