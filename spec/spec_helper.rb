gem_root = File.dirname(File.dirname(__FILE__))
$LOAD_PATH << File.join(gem_root, 'lib')
require "txtboard"

def load_column(c)
	require_relative File.join("columns", c)
end