From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Corrupted superblock? But disk still mounts.
Date: Tue, 19 Aug 2014 09:36:43 -0500
Message-ID: <53F360FB.1090809@redhat.com>
References: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com>	<53F247D5.4030502@redhat.com> <CAMJSjjucoP1rGRYKECEb=eoLz29bZQ=z=GHgaz+TUYDf=815ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Mark Ballard <markjballard@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbaHSOgo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Aug 2014 10:36:44 -0400
In-Reply-To: <CAMJSjjucoP1rGRYKECEb=eoLz29bZQ=z=GHgaz+TUYDf=815ng@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/18/14, 3:23 PM, Mark Ballard wrote:
>> I'm guessing that it's the encryption getting in your way.
> 
> Cheers, Eric. Does rather look that way. But for the sake of a user report...
> 
>>
>> How is /dev/sdb1 encrypted?  Usually this is done with something like dm-crypt.
>> Or is it hardware encryption managed in the bios?  Did you unlock it?
> 
> Done with crytpsetup using luks.
> 
>>
>> What does "blkid /dev/sdb1" say?
>>
> 
> It says Luks.

and not ext4 - so you need to unlock it via mumblemumbleLuksStuffmumblemumble
before you can operate on it with e2fsprogs tools.

# cryptsetup luksOpen /dev/sdb1 <name>... or something.  Sorry, I'm not a LUKS
expert...

Anyway, not an ext4 problem.  Your superblock isn't corrupted, it's encrypted.  :)

-Eric

