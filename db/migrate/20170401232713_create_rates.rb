class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.string :provider
      t.float :usdclp
      t.float :eurclp
      t.float :gbpclp

      t.timestamps
    end
  end
end
