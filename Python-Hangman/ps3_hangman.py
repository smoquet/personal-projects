import random
import string

WORDLIST_FILENAME = "fill_in_path_to_words.txt"

def loadWords():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    """
    print "Loading word list from file..."
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r', 0)
    # line: string
    line = inFile.readline()
    # wordlist: list of strings
    wordlist = string.split(line)
    print "  ", len(wordlist), "words loaded."
    return wordlist

def chooseWord(wordlist):
    """
    wordlist (list): list of words (strings)

    Returns a word from wordlist at random
    """
    return random.choice(wordlist)

# Load the list of words into the variable wordlist
wordlist = loadWords()

def isWordGuessed(secretWord, lettersGuessed):
    collapsed_word = []
    for x in secretWord:
         if x not in collapsed_word:
             collapsed_word.append(x)  
    aantal_correcte_letters = 0
    collapsed_letters_guessed = []
    
    for x in lettersGuessed:
        if x not in collapsed_letters_guessed:
            collapsed_letters_guessed.append(x)
            
    for x in collapsed_letters_guessed:
        if x in collapsed_word:
            aantal_correcte_letters += 1
    return aantal_correcte_letters == len(collapsed_word)


def getGuessedWord(secretWord, lettersGuessed):
    resultaat = []
    for x in secretWord:
        if x in lettersGuessed:
            resultaat.append(x)
        else:
            resultaat.append(' _ ')
    return ''.join(resultaat)
    
def getAvailableLetters(lettersGuessed):
    import string
    resultaat =[]
    for x in string.ascii_lowercase:
        if x not in lettersGuessed:
            resultaat.append(x)
    return ''.join(resultaat)

####################################################################

def hangman(secretWord):
    '''
    Main function
    '''
    letter = ''
    lijst_geraden_letters = []
    geheim_woord = secretWord
    lijst_geraden_letters.append(letter)
    aantal_pogingen = 8
    
    print "Welcome to the game, Hangman!"
    print "I am thinking of a word that is ", len(secretWord), " letters long."
    while aantal_pogingen > 0:
        print "-----------"
        print "You have ", aantal_pogingen, " guesses left."
        print 'Available letters: ', getAvailableLetters(lijst_geraden_letters)
        letter = raw_input('Please guess a letter: ').lower()
        while letter in lijst_geraden_letters:
            print "Oops! You've already guessed that letter: ", getGuessedWord(geheim_woord, lijst_geraden_letters) 
            print "-----------"
            print "You have ", aantal_pogingen, " guesses left."
            print 'Available letters: ',  getAvailableLetters(lijst_geraden_letters)
            letter = raw_input('Please guess a letter: ').lower()
        lijst_geraden_letters.append(letter)
        if letter not in geheim_woord:
            aantal_pogingen -= 1
            print "Oops! That letter is not in my word: ", getGuessedWord(geheim_woord, lijst_geraden_letters)
        if letter in geheim_woord:
            print 'Good guess: ', getGuessedWord(geheim_woord, lijst_geraden_letters)
        if isWordGuessed(geheim_woord, lijst_geraden_letters) == True:
            break
        
    if isWordGuessed(geheim_woord, lijst_geraden_letters) == False:
        print '-----------'
        print 'Sorry, you ran out of guesses. The word was ', secretWord
    elif isWordGuessed(geheim_woord, lijst_geraden_letters) == True:
        print '-----------'
        print 'Congratulations, you won!'


secretWord = chooseWord(wordlist).lower()
hangman(secretWord)
