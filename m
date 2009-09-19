From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Does ext4 perform online update of the bad blocks inode?
Date: Sat, 19 Sep 2009 08:59:06 -0500
Message-ID: <4AB4E3AA.2040103@redhat.com>
References: <loom.20090918T221210-583@post.gmane.org>	 <20090918211100.GG2537@webber.adilger.int> <b13782500909190431m1e6c8cebi321c2b60f4bbd9f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Francesco Pretto <ceztkoml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbZISN7J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Sep 2009 09:59:09 -0400
In-Reply-To: <b13782500909190431m1e6c8cebi321c2b60f4bbd9f1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Francesco Pretto wrote:
> 2009/9/18 Andreas Dilger <adilger@sun.com>:

...

>> Since most
>> disks will internally relocate bad blocks on writes, it is very
>> unlikely that "badblocks" will ever find a problem on a new disk.
>>
> 
> I'd like to believe you but please read the "smartctl --all" output
> (attached) for a Toshiba 120GB notebook drive I recently replaced, or
> just observe this excerpt:
> 
>   5 Reallocated_Sector_Ct   0x0033   100   100   050    Pre-fail
> Always       -       2
> 196 Reallocated_Event_Count 0x0032   100   100   000    Old_age
> Always       -       2
> ....
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed: read failure       00%      6366
>       57398211
> # 2  Extended offline    Completed: read failure       00%      6350
>       57398211
> 
> So, just 2 sectors reallocated but still read failures that are
> visible on the linux block device layer.

The disk won't reallocate on a read, only on a write.  So this is quite 
possible.

> I can guarantee this: I
> extensively repeated read tests on the disk, no way I could force the
> drive to relocate more failing sectors using its own SMART mechanism.
> So, what I mean is that hw bad blocks relocate features could not work
> as expected even on modern drives. Because of bugged implementation?
> Don't know.

No, it's expected.  Blocks can only be reallocated on a write (on a 
read, if it fails, what do you put into the new block?  You don't know 
what was there before so no idea what goes in the new block).

If the unreadable block is not in use on the fileystem, it's ok, because 
eventually when the fs writes to it the drive should reallocate.

If the unreadable block -is- in use, you're a little stuck; hopefully 
the fs gives you enough info about which block it is, and you could do a 
judicious "dd" of /dev/zero into it to force a reallocation, followed by 
a fsck I guess.

> You didn't answer my main question: does ext4 do something in case of
> a read/write failure that is detected in the block device layer?
> Exotic filesystems like NTFS (when running Windows, sure) seems to
> update its bad blocks list online, so it doesn't seems a bad think for
> notebook/desktop users.

Certainly not in kernelspace (well, it will return an EIO error to you, 
and possibly abort the filesystem, but that's all).

I've always felt like the badblocks list is a decades-old relic of the 
floppy days, to be honest.

If you have a sector you can't write to, you're done - the drive would 
have reallocated if it could, so get what you can off the drive and 
recycle it.

If you have a sector you can't read, it should be reallocated on the 
next write.

In neither case is a bad blocks list useful, IMHO.

-Eric

> The same problem is open for DM users: since evms is deprecated,
> there's no more a BBR target. So, for example, your buggy hard drive
> doesn't intercept the first and the only failing sector? The error
> arrives in the block device layer and the failing drive is
> deactived/removed from the RAID volume. Not good for me to throw away
> a disk for just one failing sector. This is matter for another mailing
> list, so please ignore.
> 
> Regards,
> Francesco

