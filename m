From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Corrupted superblock? But disk still mounts.
Date: Fri, 22 Aug 2014 11:09:53 -0500
Message-ID: <53F76B51.5090709@redhat.com>
References: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com>	<53F247D5.4030502@redhat.com>	<CAMJSjjucoP1rGRYKECEb=eoLz29bZQ=z=GHgaz+TUYDf=815ng@mail.gmail.com>	<53F360FB.1090809@redhat.com> <CAMJSjjs=gRuoi5gYeR2hp4Nd9kT6TJb4xxH0cTv2zSEh976UHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Mark Ballard <markjballard@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaHVQJs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 12:09:48 -0400
In-Reply-To: <CAMJSjjs=gRuoi5gYeR2hp4Nd9kT6TJb4xxH0cTv2zSEh976UHA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/22/14, 9:19 AM, Mark Ballard wrote:
> Ya. It did look that way. 'Scuse me for not checking first.
> 
> But my point is that it may still be a problem for ext4, dumpe2fs,
> e2fsck, fsck and presumably gparted and so on.
> 
> That is, would it not be polite of them to report the error ...<drum
> roll>... accurately?

Ah, I see.  So you don't like "corrupted" - you'd like to know that it's
something else perfectly valid, just not the thing you were looking for.

Maybe like:

# misc/dumpe2fs /dev/sdc1
dumpe2fs 1.43-WIP (09-Jul-2014)
misc/dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/sdc1
Couldn't find valid filesystem superblock.
/dev/sdc1 contains a xfs file system


# misc/dumpe2fs /dev/sdc
dumpe2fs 1.43-WIP (09-Jul-2014)
misc/dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/sdc
Couldn't find valid filesystem superblock.
/dev/sdc is entire device, not just one partition!

-Eric

> (No irony intended.)
> 
> 
> On 19 August 2014 15:36, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 8/18/14, 3:23 PM, Mark Ballard wrote:
>>>> I'm guessing that it's the encryption getting in your way.
>>>
>>> Cheers, Eric. Does rather look that way. But for the sake of a user report...
>>>
>>>>
>>>> How is /dev/sdb1 encrypted?  Usually this is done with something like dm-crypt.
>>>> Or is it hardware encryption managed in the bios?  Did you unlock it?
>>>
>>> Done with crytpsetup using luks.
>>>
>>>>
>>>> What does "blkid /dev/sdb1" say?
>>>>
>>>
>>> It says Luks.
>>
>> and not ext4 - so you need to unlock it via mumblemumbleLuksStuffmumblemumble
>> before you can operate on it with e2fsprogs tools.
>>
>> # cryptsetup luksOpen /dev/sdb1 <name>... or something.  Sorry, I'm not a LUKS
>> expert...
>>
>> Anyway, not an ext4 problem.  Your superblock isn't corrupted, it's encrypted.  :)
>>
>> -Eric
>>

