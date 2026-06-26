require_relative "input_parser"
require_relative "parsed_input"
# require_relative "command_factory"
# require_relative "error_handler"

class Application
    def initialize
        @command_factory = CommandFactory.new
        # @error_handler = ErrorHandler.new
    end

    # アプリケーションの処理開始
    def start_system_loop # quitコマンドが実行されるまでループ
        loop do
            input = wait_input # 利用者からの入力を取得

            # 入力内容を解析
            parsed_input = InputParser.parse(input)

            if parsed_input.is_a?(Integer)
                # @error_handler.print_error(parsed_input)
              
                ## テスト用
                case parsed_input
                when 1
                    # 存在しないコマンドの場合
                    puts "エラー：無効なコマンドです．"
                    puts "マニュアルを参照し，有効なコマンドを入力してください．"            
                when 2
                    # 存在しないオプションの場合
                    puts "エラー：無効なオプションです．"
                    puts "マニュアルを参照し，有効なオプションを入力してください．"
                when 3
                    # オプションに引数がない場合
                    puts "エラー：オプションの引数が指定されていません．" 
                    puts "マニュアルを参照し，オプションに必要な引数を指定してください．"
                end
            
                next
            end 

            # コマンドのインスタンスを作成
            command = @command_factory.create(parsed_input)
            command_result = command.execute # コマンドを実行

            # コマンドに失敗した場合
            unless command_result.success?
                puts "コマンドの実行に失敗しました" 
                # @error_handler.print_error(command_result.error_number)
            end

            stop_system if command_result.exit_flag # exit_flagが立っていたら終了
        end
    end

    # 利用者からの入力待ち
    def wait_input
        print "> "

        $stdin.set_encoding(Encoding::UTF_8)
        input = $stdin.gets # 入力を受け取る
        return nil if input.nil?

        input.chomp # 改行コードを削除
    end

    # システムの終了
    def stop_system
        puts "システムが終了しました．"
        exit
    end
end

## ここから下は動作確認用の仮実装
class CommandFactory
    def create(parsed_input)
        case parsed_input.command_name
        when "read", "write", "create", "print", "select"
          TestCommand.new(parsed_input)
        
        when "quit"
        TestQuitCommand.new
        end
    end
end

class TestCommand
    def initialize(parsed_input)
        @parsed_input = parsed_input
    end
  
    def execute
        puts "コマンド名：#{@parsed_input.command_name}"
        puts "引数：#{@parsed_input.arguments.inspect}"
        puts "オプション：#{@parsed_input.options.inspect}"
      
        CommandResult.new(
          success: true,
          exit_flag: false
        )
    end
end
  
class TestQuitCommand
    def execute
        CommandResult.new(
          success: true,
          exit_flag: true
        )
    end
end
  
class CommandResult
    attr_reader :exit_flag
  
    def initialize(success:, exit_flag:)
        @success = success
        @exit_flag = exit_flag
    end
  
    def success?
        @success
    end
end