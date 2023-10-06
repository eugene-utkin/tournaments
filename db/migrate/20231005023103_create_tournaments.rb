class CreateTournaments < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      CREATE TYPE tournament_stage
      AS ENUM(
          'in_progress',
          'completed'
        );
    SQL

    create_table :tournaments do |t|
      t.string :name, null: false
      t.column :stage, :tournament_stage, null: false, default: 'in_progress'

      t.timestamps
    end
  end

  def down
    drop_table :tournaments

    execute <<~SQL
      DROP TYPE tournament_stage;
    SQL
  end
end
