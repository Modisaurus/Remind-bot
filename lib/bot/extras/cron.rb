def cronjobs_start
	scheduler = Rufus::Scheduler.new
	scheduler.cron '*/1 * * * *' do
		clock=Time.new
		puts "[#{clock.inspect}] Checking for reminders"

		Dir["botfiles/reminders/*"].each { |file| 

			userid = file
			userid.slice! "botfiles/reminders/"
			puts "Checking reminders for: #{userid}"
			userreminders = loadArr(userreminders,"botfiles/reminders/#{userid}")
			pos = 0
			begin
				t4 = userreminders[pos]
				t4 = Time.parse(t4)
				if t4.past?
					$bot.user(userid).pm("Your reminder: #{userreminders[pos+1]}")
					userreminders.delete_at(pos+1)
					userreminders.delete_at(pos) 
				end
				pos += 2
			end while pos < userreminders.length
		}
	end
	scheduler.cron '5 */3 * * *' do
		$bot.stop
	end
	puts 'Cron jobs scheduled!'
end