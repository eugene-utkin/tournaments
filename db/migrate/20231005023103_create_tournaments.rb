class CreateTournaments < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      CREATE TYPE tournament_stage
      AS ENUM(
          'start',
          'divisions',
          'playoffs',
          'completed'
        );
    SQL

    create_table :tournaments do |t|
      t.string :name
      t.column :stage, :tournament_stage, null: false, default: "start"

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
