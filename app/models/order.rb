class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy

  monetize :total_cents, numericality: true

  validates :stripe_charge_id, presence: true

  def total_price
    total_cents / 100.0
  end
end
