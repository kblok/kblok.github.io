---
title: How do you spell 👹 in C#?
tags: csharp
permalink: /blog/how-to-spell-ogre-in-csharp
---

A few days ago, I had to implement a new feature on Puppeteer-Sharp. The library needed to be able to send emojis through its typing simulation.
Trying to send and read an 👹 from a WebSocket might be quite confusing. You could get an □ on the other side or an �� on your side, and you would think that's an encoding issue. Maybe it's not. Let's see what the deal is with emojis.

If you know nothing about programming, I bet you would at least feel that emojis are a different kind of character.
If you know something about programming, you know that emojis are not ASCII characters, they are a different thing.
If you’ve coded something related with characters, you might know that they’re related to Unicode.

Let's declare a variable called emojis
```cs
var emojis = "👹 in 🇯🇵";
Console.WriteLine(emojis);
```
_note: The flag might break your IDE. Don't try this at home._ 
>👹 in 🇯🇵

Cool. It works. Now let's try to "spell" that string using ToCharArray.

```cs
foreach(var c in emojis)
{
    Console.WriteLine(c);
}
````
_Note: This is getting fun. This code broke dotnetfiddle.com. Switching to VS Code._

We get this beautiful result:

>�  
>�
> 
>i  
>n
> 
>�  
>�  
>�  
>�

# What is a char?
This [definition of a char](https://docs.microsoft.com/en-us/dotnet/api/system.char?view=netframework-4.7.2) at docs.microsoft.com:

>The .NET Framework uses the Char structure to represent a Unicode character. The Unicode Standard identifies each Unicode character with a unique 21-bit scalar number called a code point and defines the UTF-16 encoding form that specifies how a code point is encoded into a sequence of one or more 16-bit values. Each 16-bit value ranges from hexadecimal 0x0000 through 0xFFFF and is stored in a Char structure. The value of a Char object is its 16-bit numeric (ordinal) value.

Two important things here: Chars are Unicode, and chars are 16-bit (2 bytes) objects.

# What is an 👹

Most emojis are 32-bit characters so they won't fit on a 16-bit char. So when we make a `ToCharArray` of `\u1F479` (the ogre) we get a `\u1F47` and a `9` .

# What is Japan?

Flags are even more interesting because they are [emoji sequence](http://unicode.org/reports/tr51/#Emoji_Sequences). In the case of the Japanese flag, it's the sequence of the Regional Indicator Symbol Letter J "🇯" and the Regional Indicator Symbol Letter P "🇵". This makes the Japanese flag a 64-bit character.

Now we can understand why we were getting the following:

>�  
>�  
> 
>i  
>n
> 
>�  
>�  
>�  
>�

If we use `ToCharArray` for emojis, we are "breaking" them.

# StringInfo to the rescue

According to [its documentation](https://docs.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo?view=netframework-4.7.2):

>StringInfo provides functionality to split a string into text elements and to iterate through those text elements.

StringInfo provides a method called [GetTextElementEnumerator](https://docs.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo.gettextelementenumerator?view=netframework-4.7.2#System_Globalization_StringInfo_GetTextElementEnumerator_System_String_) which helps us split a string not in chars, but into text elements. 

So now, if we do this:

```cs
var textParts = StringInfo.GetTextElementEnumerator(emojis);
while (textParts.MoveNext())
{
    Console.WriteLine(textParts.Current);
}
```

We get:
>👹
> 
>i  
>n  
> 
>🇯  
>🇵

`GetTextElementEnumerator`  splits the Japanese flag into its two emoji characters, but it won't break it. If you type a 🇯 and then a 🇵, you'll get a 🇯🇵. 

Try it by yourself copying and pasting those characters in this input element.
<input>

Don't stop coding!
