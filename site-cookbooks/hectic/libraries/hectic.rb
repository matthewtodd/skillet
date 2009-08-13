class Hectic
  def self.be_sure_we_have_mysql
    begin
      require 'mysql'
    rescue LoadError
      Gem.clear_paths
      require 'mysql' # if that didn't help, we're sunk
    end
  end

  def self.query(sql)
    be_sure_we_have_mysql

    results = []
    # FIXME DRY up my usage of hectic db attributes -- see also postfix config files
    begin
      mysql = Mysql.new('localhost', 'root', node[:mysql][:server_root_password], node[:hectic][:db][:database])
      mysql.query(sql) { |rows| rows.each_hash { |row| results.push(row) } }
    ensure
      mysql.close if mysql
    end

    results
  end

  def self.hosts
    query('SELECT * FROM hosts ORDER BY name')
  end

  def self.accounts
    query('SELECT * FROM hosts JOIN accounts ON hosts.id=accounts.host_id ORDER BY hosts.name, accounts.username')
  end

  def self.base_mailbox_paths
    accounts.map { |account| account['mailbox_path'] }.map do |mailbox_path|
      if mailbox_path.ends_with?('/')
        mailbox_path
      else
        ::File.basename(mailbox_path)
      end
    end.uniq
  end

  def self.local_hostnames
    hosts.map { |host| host['local_name'] }
  end
end
