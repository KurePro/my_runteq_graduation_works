class FoodsSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :search_keyword, :string
  attribute :category_id, :integer
  attribute :expiry_status, :string

  def search(current_user)
    relation = current_user.foods.includes(:category)

    relation = relation.by_category(category_id) if category_id.present?

    foods_search_words.each do |word|
      relation = relation.name_contain(word)
    end

    case expiry_status
    when "expiry_3_days_notice"
      relation = relation.for_expiry_3_days_notice
    when "expiry_day_notice"
      relation = relation.for_expiry_day_notice
    when "expired_notice"
      relation = relation.for_expired_notice
    end
    relation
  end

    private

    def foods_search_words
      search_keyword.present? ? search_keyword.split(/[[:blank:]]+/) : []
    end
end