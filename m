From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: inconsistent file placement
Date: Tue, 06 Jul 2010 18:34:26 -0500
Message-ID: <4C33BD82.2090708@redhat.com>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com> <20100706185548.GA26677@thunk.org> <4C337D16.9000200@redhat.com> <469D2D911E4BF043BFC8AD32E8E30F5B24AEDB@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, amir73il@gmail.com, linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0GFXed (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jul 2010 19:34:33 -0400
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEDB@wdscexbe07.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Daniel Taylor wrote:
>  
> 
>> -----Original Message-----
>> From: Eric Sandeen [mailto:sandeen@redhat.com] 
>> Sent: Tuesday, July 06, 2010 12:00 PM
>> To: tytso@mit.edu
>> Cc: Daniel Taylor; linux-ext4@vger.kernel.org
>> Subject: Re: inconsistent file placement
>>
>> tytso@mit.edu wrote:
>>> On Mon, Jul 05, 2010 at 06:49:34PM -0700, Daniel Taylor wrote:
>>>> I realize that it is enerally not a good idea to tune
>>>> an operating system, or subsystem, for benchmarking, but
>>>> there's something that I don't understand about ext[234]
>>>> that is badly affecting our product.  File placement on
>>>> newly-created file systems is inconsistent.  I can't,
>>>> yet, call it a bug, but I really need to understand what
>>>> is happening, and I cannot find, in the source code, the
>>>> source of the randomization (related to "goal"???).
>>> In ext3, it really is random.  The randomness you're looking for can
>>> be found in fs/ext3/ialloc.c:find_group_orlov(), when it calls
>>> get_random_bytes().  This is responsible for "spreading" directories
>>> so they are spread across the block groups, to try to prevent
>>> fragmented files.  Yes, if all you care about is benchmarks 
>> which only
>>> use 10% of the entire file system, and for which the 
>> benchmarks don't
>>> adequately simulate file system aging, the algorithms in ext3 will
>>> cause a lot of variability.
>> However, from the test description it looks like it is writing
>> a file to the root dir, so there should be no parent-dir 
>> random spreading,
>> right?
>>
>> -Eric
>>
>>
> 
> In all of my recent tests, there has only been one file created, in
> the root directory of the freshly created and mounted file system.
> 
> mkfs.ext[234] -b 65536 /dev/sda4
> mount <some options tested> /dev/sda4 /DataVolume
> touch /DataVolume/hex.txt
> "for i in 1 2 3 4 5; do dd if=/hex.txt bs=64K; \
> done >>/DataVolume/hex.txt"
> umount /DataVolume
> dumpe2fs /dev/sda4 >/<log file>
> 
> where /hex.txt is a 1G file on the NFS root.
> 
> I tried with, and without, orlov on ext3 (-o orlov and -o oldalloc)
> and didn't see any change in the behavior.  In ext4, there seemed
> to be less variability, but it is still present, and the "less" may
> just be the small sample size.

orlov is an inode allocator for directory inodes; since you
are creating 1 file in the root dir, they won't matter.

It affects file placement because files prefer to be close to their
parent dir, more or less, but in your case you are never allocating
a directory so the point is moot.

-o orlov is the default, FWIW.

> Now, at least, I understand that the placement algorithm does not
> always start at first free block.
> 
> It is an unfortunate fact of life that simplistic benchmarks often
> drive sales.  This product will be a consumer NAS and when our
> internal runs of the common NAS benchmarks get inconsistent results,
> it creates a lot of concern.
> 
> There's an option for ext4 (delayed allocation) that looks like it
> bypasses the "pid % 16" coloration.  I'll tinker some more with
> that and see how it goes.

delalloc is the default as well.

filefrag -v output would be much more enlightening than what you've
shown so far...

-Eric

> Thank you all for your input.

