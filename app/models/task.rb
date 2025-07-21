class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true

  before_update :set_completion_details, if: :will_save_change_to_completed?

  private

  def set_completion_details
    if completed
      self.completed_at = Time.current
      assign_tagline
    else
      self.completed_at = nil
      self.tagline = nil
    end
  end

  def assign_tagline
    return unless due_time.present?

    if completed_at <= due_time
      self.tagline = fast_or_on_time_taglines.sample
    else
      self.tagline = late_completion_taglines.sample
    end
  end

  def fast_or_on_time_taglines
    [
      "Nee speed choosi Google kuda buffer avuthundi!",
      "Nuvvu cheyyadam kaadu… rocket launch chesinattu undi!",
      "Task ayipoyindi… Swiggy kante fast delivery!",
      "Time ki complete chesav… mummy kuda proud!",
      "Inka task start ayyela undi… nuvvu already finish chesav?"
    ]
  end

  def late_completion_taglines
    [
      "Ee pani ki pension vacchesindhi ra!",
      "Enni janmalu padindi task ki?",
      "Task ayipoyindi… Kumbh Mela taruvatha kalavata la undi!",
      "NASA kuda track cheyyatam apesindhi… nuvvu ippude complete chesav!",
      "Task pending ki museum lo petali!"
    ]
  end
end
