class CreateMatches < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      CREATE TYPE match_stage
      AS ENUM(
          'division_a',
          'division_b',
          'playoff'
        );
      CREATE TYPE match_result
      AS ENUM(
          'not_played_yet',
          'team_a_won',
          'team_b_won'
        );
    SQL

    create_table :matches do |t|
      t.integer :playoff_number, null: false, default: 0
      t.column :stage, :match_stage, null: false
      t.column :result, :match_result, null: false, default: 'not_played_yet'
      t.references :tournament, foreign_key: true
      t.references :team_a
      t.references :team_b

      t.timestamps
    end

    add_foreign_key :matches, :teams, column: :team_a_id, primary_key: :id
    add_foreign_key :matches, :teams, column: :team_b_id, primary_key: :id
  end

  def down
    drop_table :matches

    execute <<~SQL
      DROP TYPE match_stage;
      DROP TYPE match_result;
    SQL
  end
end
