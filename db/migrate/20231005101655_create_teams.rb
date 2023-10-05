class CreateTeams < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      CREATE TYPE division
      AS ENUM(
          'division_a',
          'division_b'
        );
    SQL

    create_table :teams do |t|
      t.string :name
      t.column :division, :division
      t.column :stage, :tournament_stage, null: false, default: 'registration'
      t.references :tournament, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :teams

    execute <<~SQL
      DROP TYPE division;
    SQL
  end
end
