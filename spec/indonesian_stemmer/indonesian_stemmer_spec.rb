require 'indonesian_stemmer'

describe IndonesianStemmer do
  describe '#total_syllables' do
    it "'memasak' should return 3" do
      IndonesianStemmer.total_syllables('memasak').should == 3
    end

    it "'mewarnai' should return 3" do
      IndonesianStemmer.total_syllables('mewarnai').should == 4
    end

    it "'permainan' should return 4" do
      IndonesianStemmer.total_syllables('permainan').should == 4
    end
  end

  describe '#remove_particle' do
    describe 'should remove these particles at the end of the word' do
      it "'kah'" do
        should_transform(:remove_particle, 'manakah', 'mana')
      end

      it "'lah'" do
        should_transform(:remove_particle, 'kembalilah', 'kembali')
      end

      it "'pun'" do
        should_transform(:remove_particle, 'bagaimanapun', 'bagaimana')
      end
    end

    describe 'should not remove these particles at the rest part of the word' do
      it "'kah'" do
        should_not_transform(:remove_particle, 'kahak')
        should_not_transform(:remove_particle, 'pernikahan')
      end

      it "'lah'" do
        should_not_transform(:remove_particle, 'lahiriah')
        should_not_transform(:remove_particle, 'kelahiran')
      end

      it "'pun'" do
        should_not_transform(:remove_particle, 'punya')
        should_not_transform(:remove_particle, 'kepunyaan')
      end
    end
  end

  describe '#remove_possessive_pronoun' do
    describe 'should remove these possessive pronouns at the end of the word' do
      it "'ku'" do
        should_transform(:remove_possessive_pronoun, 'mainanku', 'mainan')
      end

      it "'mu'" do
        should_transform(:remove_possessive_pronoun, 'mobilmu', 'mobil')
      end

      it "'nya'" do
        should_transform(:remove_possessive_pronoun, 'gelasnya', 'gelas')
      end
    end

    describe 'should not remove these possessive pronouns at the rest part of the word' do
      it "'ku'" do
        should_not_transform(:remove_possessive_pronoun, 'kumakan')
        should_not_transform(:remove_possessive_pronoun, 'kekurangan')
      end

      it "'mu'" do
        should_not_transform(:remove_possessive_pronoun, 'murahan')
        should_not_transform(:remove_possessive_pronoun, 'kemurkaan')
      end

      it "'nya'" do
        should_not_transform(:remove_possessive_pronoun, 'nyapu')
        should_not_transform(:remove_possessive_pronoun, 'menyambung')
      end
    end
  end

  describe '#remove_first_order_prefix' do
    describe "words with these special characters" do
      describe "at the begining" do
        describe "followed by a vowel, should remove and substitute the last character" do
          it "'meny'" do
            should_transform(:remove_first_order_prefix, 'menyambung', 'sambung')
          end

          it "'peny'" do
            should_transform(:remove_first_order_prefix, 'penyantap', 'santap')
          end

          it "'pen'" do
            should_transform(:remove_first_order_prefix, 'penata', 'tata')
          end
        end

        describe "followed by consonant, should only remove the special characters" do
          it "'meny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'menyxxx', 'xxx')
          end

          it "'peny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'penyxxx', 'xxx')
          end

          it "'pen'" do
            should_transform(:remove_first_order_prefix, 'penjahat', 'jahat')
          end
        end
      end

      describe "at the rest part of the word" do
        describe "followed by a vowel, should not do anything" do
          it "'meny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxmenyaxx', 'xxxmenyaxx')
            should_transform(:remove_first_order_prefix, 'xxxmenya', 'xxxmenya')
          end

          it "'peny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxpenyaxx', 'xxxpenyaxx')
            should_transform(:remove_first_order_prefix, 'xxxpenya', 'xxxpenya')
          end

          it "'pen'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxpenexx', 'xxxpenexx')
            should_transform(:remove_first_order_prefix, 'xxxpeno', 'xxxpeno')
          end
        end

        describe "followed by consonant, should not do anything" do
          it "'meny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxmenykxx', 'xxxmenykxx')
            should_transform(:remove_first_order_prefix, 'xxxmenyk', 'xxxmenyk')
          end

          it "'peny'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxpenykxx', 'xxxpenykxx')
            should_transform(:remove_first_order_prefix, 'xxxpenyk', 'xxxpenyk')
          end

          it "'pen'" do
            # TODO: Find a real indonesian word for this case
            should_transform(:remove_first_order_prefix, 'xxxpenrxx', 'xxxpenrxx')
            should_transform(:remove_first_order_prefix, 'xxxpenr', 'xxxpenr')
          end
        end
      end
    end
  end
end

def should_transform(method_name, word, transformed_word)
  IndonesianStemmer.send(method_name, word).should == transformed_word
end

def should_not_transform(method_name, word)
  IndonesianStemmer.send(method_name, word).should == word
end