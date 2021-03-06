class Category < ActiveRecord::Base
  before_validation :create_slug
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { case_senstive: false }
  has_many :animals

  def self.all_names
    all.map{ |category| [ category.name, category.id ] }
  end

  private

  def create_slug
    self.slug = name.parameterize
  end

  def to_param
    slug
  end
end
