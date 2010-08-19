From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Thu, 19 Aug 2010 13:03:06 -0600
Message-ID: <ABE19F5B-74C8-47E9-B359-D3FB2C137087@dilger.ca>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca> <20100819130123.GU16603@skl-net.de>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 development <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:47263 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0HSTDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Aug 2010 15:03:07 -0400
In-Reply-To: <20100819130123.GU16603@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-19, at 07:01, Andre Noll wrote:
> On Wed, Aug 18, 14:20, Andreas Dilger wrote:
>>> This is an old 32 bit system with only 1G of ram and a 2.6.24 distro
>>> kernel. I added _lots_ of swap but this did not help.
>> 
>> Yeah, it is possible to have filesystems that are too large for the
>> node they are running on.  There are low-priority discussions for how
>> to reduce memory usage of e2fsck, but they have never been a priority
>> to implement.
> 
> But e2fsck runs entirely in user space, so all memory should be
> swappable, no? I think the system did not swap at all.

I think the problem isn't just the TOTAL amount of RAM being used, but the fact that this piece of code is trying to do a SINGLE allocation that is HUGE.  The second problem is that the constant re-allocation of this huge array (every 100 insertions) means that it can never really exceed 1/2 of RAM in size.

>>> Since the file system is corrupt anyway, it is maybe easiest
>>> to delete inode 245859898 with debugfs, but maybe there is
>>> a better option. Moreover, since this might be some kind of
>>> e2fsck-trusts-corrupt-data issue, you might be interested in looking
>>> at this.
>> 
>> No, I don't think this will help.  The problem is not with that inode,
>> just that it is needing to allocate a structure because of nlinks=2
>> (this is normal).
>> 
>> In theory it might be possible to avoid allocating icount structures
>> for every directory inode (which have icount == 2 normally), if we
>> used the "fs->inode_dir_map" bit as "+1" for the inode link count.
>> 
>> In any case, this is a non-trivial fix.
> 
> I'm not sure I can follow. Are you saying we currently allocate two
> struct ext2_icount for a directory inode even if .  and .. are the
> only two references?

Well, one per directory, yes.  Whether the directory count is the core problem (which could be fixed by this hack) or the many hard-linked files is the core problem I can't really say without more information.

> So we could just omit this allocation in the
> common icount == 2 case because we know it is a directory inode
> (so we have one additional reference) if fs->inode_dir_map is not NULL.

Yes, that was my idea.  The main problem is that this would tie together parts of the e2fsck code that are currently independent, and I don't know how cleanly this can be done.  It deserves some further investigation, even for normal e2fsck usage, because it would likely eliminate 75% of the extra allocations in icount due to leaf directories (internal directories will have nlink > 2 due to child directories)

>>> Further info: The ext3 file system lives on a lv within a vg whose
>>> single pv is the 12 disk raid6 array. The file system stores hard
>>> link based backups, so it contains _lots_ of hard links.
>> 
>> Ah, that is also a major user of memory, and not necessarily one that
>> optimizing the internal bitmap will help significantly.  It may well
>> be that your swap cannot be used if a single allocation is in the same
>> neighbourhood as the total RAM size.
> 
> Is playing with the memory overcommit knobs likely going to help?

Probably not.

>> Every file with nlink > 1 will need an additional 8 bytes of data, and
>> the insert_icount_el() function reallocates this structure every 100
>> elements, so it can use AT MOST 1/2 of all memory before the new copy
>> and the old one fill all available memory.
>> 
>> It would probably make sense to modify the internal icount structure
>> to hold a 2-level tree of arrays of e.g. 8kB chunks, or other advanced
>> data structure so that it doesn't force reallocation and average .51
>> memory copies of the WHOLE LIST on every insert.  This is probably
>> doable with some light understanding of e2fsprogs, since the icount
>> interface is well encapsulated, but it isn't something I have time for
>> now.
> 
> I'm interested in having a look at the icount structure and see what
> can be done to reduce memory usage.

One simple way that this could be fixed fairly easily (which would presumably allow swap to be used) is to have a 2-level (or N-level) tree of allocations for the icount->list array, with the first level being just an array of pointers to individually-allocated arrays of ext2_icount_el.  The sub-arrays can be some reasonable size (maybe 64kB), which would give us a fan-out of 64k / 8 = 8k, and if the top-level array is (re-)allocated in chunks of, say 64 pointers, the number of times the top-level array needs to be reallocated would only be every 64 * 8192 insertions, and only the pointer array needs to be reallocated/copied.

That said, any insert-optimized tree structure with a high fan-out would be suitable.  Elements are almost never deleted, and we would never need to compact the tree (it is freed as a whole when it is done).

> Here's a first question: There is ext2fs_create_icount() and
> ext2fs_create_icount_tdb(). Is is correct that they do the same thing,
> the only difference being that the tdb variant uses an on-disk
> database while ext2fs_create_icount stores everything in memory?

Correct.

> If so we might want to discuss first whether it is more important
> to improve the performance of the on-disk database or to decrease
> the memory requirements of the in-memory variant. The answer likely
> depends on the amounts of disk space and RAM a typical system will
> have in 5 or 10 years from now.

I suspect that using multi-level arrays + swap is always going to be more efficient than using an on-disk database.  This will maximize the RAM usage due to very compact storage of the icount_el data instead of database records with much more (2x at least) overhead, and it will also avoid all disk IO unless the system is actually running out of RAM.  Finally, all of the swap IO will be in at least PAGE_SIZE chunks, while tdb and friends often write 512-byte sparse records randomly.

>> If you are interested to hack/improve e2fsprogs I'd be willing to
>> guide you, but if not I'd just suggest connecting this array to
>> another node to run e2fsck, and consider spending the $200 needed to
>> get a 64-bit system with a few GB of RAM.
> 
> Yeah right. There is already a 64bit system waiting to replace the
> old one. Moving the old disks would be a PITA though because of the
> lack of hot swap bays...

If you have a new system ready to go, you may be ahead by just doing a raw copy of the filesystem over to the new storage, and running e2fsck on that.  This also gives you the security of doing the e2fsck on a copy of the data, in case it does something bad.

You could start the raw copy even if you have your current e2fsck running, since I suspect the current tdb-based e2fsck will be totally IO-bound on the database and not on IO from the filesystem.

Cheers, Andreas





