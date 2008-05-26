From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: What to do when the journal checksum is incorrect
Date: Mon, 26 May 2008 17:28:30 -0400
Message-ID: <483B2B7E.3060906@gmail.com>
References: <E1K02Jh-0002wf-2e@closure.thunk.org> <20080525063024.GG3516@webber.adilger.int> <20080525113842.GE5970@mit.edu> <20080526182428.GT3516@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org,
	Girish Shilamkar <Girish.Shilamkar@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:30249 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbYEZV2f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 17:28:35 -0400
Received: by an-out-0708.google.com with SMTP id d40so444979and.103
        for <linux-ext4@vger.kernel.org>; Mon, 26 May 2008 14:28:34 -0700 (PDT)
In-Reply-To: <20080526182428.GT3516@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On May 25, 2008  07:38 -0400, Theodore Ts'o wrote:
>> Well, what are the alternatives?  Remember, we could have potentially
>> 50-100 megabytes of stale metadata that haven't been written to
>> filesystem.  And unlike ext2, we've deliberately held back writing
>> back metadata by pinning it so, things could be much worse.  So let's
>> tick off the possibilities:
>>
>> * An individual data block is bad --- we write complete garbage into
>>   the filesystem, which means in the worst case we lose 32 inodes
>>   (unless that inode table block is repeated later in the journal), 1
>>   directory block (causing files to land in lost+found), one bitmap
>>   block (which e2fsck can regenerate), or a data block (if data=jouranalled).
>>
>> * A journal descriptor block is bad --- if it's just a bit-flip, we
>>   could end up writing a data block in the wrong place, which would be
>>   bad; if it's complete garbage, we will probably assume the journal
>>   ended early, and leave the filesystem silently badly corrupted.
>>
>> * The journal commit block is bad --- probably we will just silently
>>   assume the journal ended early, unless the bit-flip happened exactly
>>   in the CRC field.
>>
>> The most common case is that one or more individual data blocks in the
>> journal are bad, and the question is whether writing that garbage into
>> the filesystem is better or worse than aborting the journal right then
>> and there.
> 
> You are focussing on the case where 1 or 2 filesystem blocks in the
> journal are bad, but I suspect the real-world cases are more likely to
> be 1 or 2MB of data are bad, or more.  Considering that a disk sector
> is at least 4 or 64kB in size, and problems like track misalignment
> (overpowered seek), write failure (high-flying write), or device cache
> reordering problems will result in a large number of bad blocks in the
> journal, I don't think 1 or 2 filesystem is a realistic failure scenario
> anymore.

Disk sectors are still (almost always) 512 bytes today, but the industry is 
pushing hard to get 4k byte sectors out since that has a promise of getting 
better data protection and denser layout. Disk arrays have internal "sectors" 
that can be really big (64k or bigger).

What seems to be most common is a small number of bad sectors that will be 
unreadable (IO errors on read). I would be surprised to see megabytes of 
continuous errors, but you could see 10's of kilobytes.

What the checksums will probably be most useful in catching is problems with 
memory parts - either non-ECC DRAM in your server, bad DRAM in the disk cache 
itself, etc. The interesting thing about these errors is that they will tend to 
repeat (depending on where that stuck bit is) and you can see it all over the place.

One thing that will be really neat is to actually put in counters to track the 
rate and validate these assumptions.


ric
