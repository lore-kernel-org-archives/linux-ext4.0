From: Mark Ballard <markjballard@googlemail.com>
Subject: Re: Corrupted superblock? But disk still mounts.
Date: Fri, 22 Aug 2014 15:19:23 +0100
Message-ID: <CAMJSjjs=gRuoi5gYeR2hp4Nd9kT6TJb4xxH0cTv2zSEh976UHA@mail.gmail.com>
References: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com>
	<53F247D5.4030502@redhat.com>
	<CAMJSjjucoP1rGRYKECEb=eoLz29bZQ=z=GHgaz+TUYDf=815ng@mail.gmail.com>
	<53F360FB.1090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:45122 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbaHVOTX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2014 10:19:23 -0400
Received: by mail-ie0-f180.google.com with SMTP id at20so6557732iec.39
        for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2014 07:19:23 -0700 (PDT)
In-Reply-To: <53F360FB.1090809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ya. It did look that way. 'Scuse me for not checking first.

But my point is that it may still be a problem for ext4, dumpe2fs,
e2fsck, fsck and presumably gparted and so on.

That is, would it not be polite of them to report the error ...<drum
roll>... accurately?

(No irony intended.)


On 19 August 2014 15:36, Eric Sandeen <sandeen@redhat.com> wrote:
> On 8/18/14, 3:23 PM, Mark Ballard wrote:
>>> I'm guessing that it's the encryption getting in your way.
>>
>> Cheers, Eric. Does rather look that way. But for the sake of a user report...
>>
>>>
>>> How is /dev/sdb1 encrypted?  Usually this is done with something like dm-crypt.
>>> Or is it hardware encryption managed in the bios?  Did you unlock it?
>>
>> Done with crytpsetup using luks.
>>
>>>
>>> What does "blkid /dev/sdb1" say?
>>>
>>
>> It says Luks.
>
> and not ext4 - so you need to unlock it via mumblemumbleLuksStuffmumblemumble
> before you can operate on it with e2fsprogs tools.
>
> # cryptsetup luksOpen /dev/sdb1 <name>... or something.  Sorry, I'm not a LUKS
> expert...
>
> Anyway, not an ext4 problem.  Your superblock isn't corrupted, it's encrypted.  :)
>
> -Eric
>
