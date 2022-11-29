class BankAccount
  attr_accessor :pin, :balance, :overdraft_limit, :transactions

  def initialize(pin, balance, overdraft_limit)
    @pin = pin
    @balance = balance
    @overdraft_limit = overdraft_limit
    @transactions = []
  end

  def deposit(amount, bank_account)
    bank_account.balance += amount

    bank_account.transactions << {type: 'credit', amount: amount, balance: bank_account.balance, recorded_at: Time.now}

    display_balance(bank_account.pin, bank_account)
  end

  def display_balance(pin, bank_account)
    return display_invalid_pin if bank_account.pin != pin

    puts "Balance: #{bank_account.balance}"
  end

  def display_statement(pin, bank_account)
    return display_invalid_pin if bank_account.pin != pin

    i = 0
    rows = ''

    while i < bank_account.transactions.size
      record = bank_account.transactions[i]

      rows << (
        "#{record[:recorded_at].strftime("%Y-%m-%d")} | " +
        "#{record[:type]} | " +
        "#{record[:amount]} | " +
        "#{record[:balance]} \n"
      )

      i += 1
    end

    puts "date       | type | amount | balance", rows
  end

  def display_invalid_pin
    puts('Access denied: invalid PIN.')
  end

  def withdraw(amount, pin, bank_account)
    return display_invalid_pin if bank_account.pin != pin

    return puts 'Insufficient funds!' if (bank_account.balance + bank_account.overdraft_limit) < amount

    bank_account.balance -= amount

    bank_account.transactions << {type: 'debit', amount: amount, balance: bank_account.balance, recorded_at: Time.now}

    puts "Withdrawn: #{amount} | New balance: #{bank_account.balance}"
  end
end

