require_relative "../models/address_book"

class MenuController
   attr_reader :address_book
   
   def initialize
      @address_book = AddressBook.new 
   end
   
   def main_menu
      puts "Main Menu - #{address_book.entries.count} entries"
      puts "1 - View all entries"
      puts "2 - View entry number n"
      puts "3 - Create an entry"
      puts "4 - Search for an entry"
      puts "5 - Import entries from a CSV"
      puts "6 - Exit"
      puts "7 - Annihilate all entries!"
      puts "Enter your selection"
      
      selection = gets.to_i
      
      puts "You selected #{selection}"
      
      case selection
         when 1
            system "clear"
            view_all_entries
            main_menu
         when 2
            system "clear"
            view_entry_number
            main_menu
         when 3
            #system "clear"
            create_entry
            main_menu
         when 4
            system "clear"
            search_entries
            main_menu
         when 5
            system "clear"
            read_csv
            main_menu
         when 6
            puts "Goodbye!"
            exit(0)
         when 7
            system "clear"
            annihilate_all
         else
            system "clear"
            puts "Sorry that is not a valid entry"
            main_menu
      end
   end
   
   
   
   
   def view_all_entries
      system "clear"
      address_book.entries.each do |entry|
         puts entry.to_s
            
         entry_submenu(entry)
      end
   end
   
   def view_entry_number
      system "clear"
      puts "Enter the entry number: "
      selection = gets.to_i
      selection -= 1
      system "clear"
      if address_book.entries[selection] and selection > 0
         puts address_book.entries[selection]
      else
         puts "Not a valid entry number"
      end

   end
      
   def create_entry
      system "clear"
      puts "New Address Book entry"
      print "Name: "
      name = gets.chomp
      print "Phone Number: "
      phone_number = gets.chomp
      print "Email: "
      email = gets.chomp
         
      address_book.add_entry(name, phone_number, email)
      system "clear"
      puts "New entry created"
   end
      
   def search_entries
      puts "Search by name: "
      name = gets.chomp
      
      match = address_book.binary_search(name)
      
      if match
         system "clear"
         puts match.to_s
         search_submenu(match)
      else
         puts "No match found for #{name}"
      end
   end
      
   def read_csv
      print "Enter CSV file to import: "
      file_name = gets.chomp
      
      if file_name.empty?
         system "clear"
         puts "No CSV file read"
         main_menu
      end
      
      begin
         entry_count = address_book.import_from_csv(file_name).count
         system "clear"
         puts "#{entry_count} entries were read from #{file_name}"
      rescue
         puts "#{file_name} is not a valid CSV file"
         read_csv
      end
   end
      
   def entry_submenu(entry)
      puts "n - next entry"
      puts "d - delete entry"
      puts "e - edit this entry"
      puts "m - return to main menu"
         
      selection = gets.chomp
         
      case selection
         when "n"
         when "d"
            delete_entry(entry)
         when "e"
            edit_entry(entry)
            entry_submenu(entry)
         when "m"
            system "clear"
            main_menu
         else
            system "clear"
            puts "#{selection} is not a valid input"
            entry_submenu(entry)
      end
   end
   
   def delete_entry(entry)
      address_book.entries.delete(entry)
      puts "#{entry.name} has been deleted"
   end
   
   def edit_entry(entry)
      puts "Updated Name: "
      name = gets.chomp
      puts "Updated Phone Number: "
      phone_number = gets.chomp
      puts "Updated Email: "
      email = gets.chomp
      
      entry.name = name if !name.empty?
      entry.phone_number = phone_number if !phone_number.empty?
      entry.email = email if !email.empty?
      
      puts "Updated entry: "
      puts entry
   end
   
   def search_submenu(entry)
      puts "\nd - delete entry"
      puts "e - edit this entry"
      puts "m - return to main menu"
      
      selection = gets.chomp
      
      case selection
         when "d"
            system "clear"
            delete_entry(entry)
            main_menu
         when "e"
            system "clear"
            edit_entry(entry)
            main_menu
         when "m"
            system "clear"
            main_menu
         else
            system "clear"
            puts "#{selection} is not a valid entry"
            puts entry.to_s
            search_submenu(entry)
      end
   end
   
   def annihilate_all
      puts "Are you sure you want to delete all entries?(Y or N)"
      answer = gets.chomp
      if answer.downcase == "y"
         puts "Again, Are you sure?! (Y or N)"
         answer = gets.chomp
         if answer.downcase == "y"
            
            num = address_book.entries.length - 1
            while num >=0  
               delete_entry(address_book.entries[num])
               num -= 1
            end
            main_menu
         else
            main_menu
         end
      else
         main_menu
      end
   end
end