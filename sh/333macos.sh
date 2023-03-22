显示地址栏
defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE;killall Finder
隐藏地址栏
defaults delete com.apple.finder _FXShowPosixPathInTitle;killall Finder



#brew 太慢
1、替换现有上游 
git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git 
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git 
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
brew update

2、复原方法
git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git 
git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git 
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git 
brew update
