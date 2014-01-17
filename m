From: vitalif@yourcmc.ru
Subject: Re: A tool that allows changing inode table sizes
Date: Fri, 17 Jan 2014 17:21:09 +0400
Message-ID: <fd7e830011c29ef068ff877e4b7d9b90@yourcmc.ru>
References: <ea490dfe40d0de3a5c0cb388e749f172@yourcmc.ru>
 <555DD664-E495-409D-9DAB-6E0A52C98273@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yourcmc.ru ([195.24.71.121]:55054 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaAQNVM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jan 2014 08:21:12 -0500
In-Reply-To: <555DD664-E495-409D-9DAB-6E0A52C98273@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

Thanks for answering!

> Interesting.  I did something years ago for ext2/3 filesystem resizing
> (ext2resize), but that has since become obsolete as the functionality
> was included into e2fsprogs.  I'd recommend that you also work to get
> your functionality included into e2fsprogs sooner rather than later.
> 
> Ideally this would be part of resize2fs, but I'm not sure it would be
> easily implemented there.

I agree including into e2fsprogs would be the best option! I only 
slightly fear the contribution process because I didn't try it 
(particularly with this project :)) experience that I've mostly had by 
now - contributing to MediaWiki - isn't easy... :(

I've first thought of tune2fs (inode count is an fs option?), but it 
seems you're right and resize2fs is more similar in terms of code logic.

Although my main concern about resize2fs is that now it's suited for 
just one specific task and as I understand big part of its code flow 
will need to be rearranged to do inode table resizing instead of device 
resizing... And I don't know how would Theodore, as a e2fsprogs 
maintainer, like such a patch. :)

>> Anyone is welcome to test it of course if it's of any interest for you 
>> - the source is here 
>> http://svn.yourcmc.ru/viewvc.py/vitalif/trunk/ext4-realloc-inodes/ 
>> ('download tarball') (maybe it would be better to move it into a 
>> separate git repo, of course)
>> 
>> I didn't test it on a real hard drive yet :-D, only on small fs images 
>> with different settings (block, block group, flex_bg size, ext2/3/4, 
>> bigalloc and etc). There are even some auto-tests (ran by 'make 
>> test').
> 
> Note that it is critical to refuse to do anything on filesystems that
> have any feature that your tool doesn't understand.  Otherwise, it has
> a good possibility to corrupt the filesystem.

Didn't check it, thanks. As I understand some compatibility checks are 
already done by libext2fs, but they're not enough as libext2fs may 
support more features than the tool.

Also I have a question - check_block_uninit() and check_inode_uninit() 
are copypasted into my tool from libext2fs alloc.c. There's some code in 
check_block_uninit() that looks as duplicated with 
ext2fs_reserve_super_and_bgd() to me - am I correct?

>> The tools works without problem on all small test images that I've 
>> created, though I didn't try to run it on bigger filesystems (of 
>> course I'll do it in the nearest future).
>> 
>> As this is a highly destructive process that involves overwriting ALL 
>> inode numbers in ALL directory entries across the whole filesystem, 
>> I've also implemented a simple method of safely applying/rolling back 
>> changes. First I've tried to use undo_io_manager, but it appears to be 
>> very slow because of frequent commits, which are of course needed for 
>> it to be safe.
> 
> Would it be possible to speed up undo_io_manager if it had larger IO
> groups or similar?  How does the speed of running with undo_io_manager
> compare to running your patch_io_manager doing both a backup and apply?

As I understand undo_io_manager needs to commit each write to TDB 
database just before issuing the write request to underlying I/O 
manager, because otherwise it may be possible that a block backup is not 
really written on disk while the block itself is already overwritten... 
So you're correct about larger IO groups - I think the only way to make 
it faster is to buffer write requests and do only one commit operation 
for many blocks.

About the performance: I only tested it on small images because after 
that undo_io code was already removed from my tool. On such images (32M 
and 128M) inode table resizing operation is normally finished almost 
instantly - as without any undo method, as under patch_io. But the same 
operation under undo_io took some couple (maybe tens) of seconds. This 
was very slow for such small images, and I didn't run further tests but 
instantly decided to implement patch_io... :)

In fact I also think patch_io is better because the idea of writing 
modifications to a separate file is initially safer...

>> My method is called patch_io_manager and does a different thing - it 
>> does not overwrite the initial FS image, but writes all modified 
>> blocks into a separate sparse file + writes a bitmap of modified 
>> blocks in the end when it finishes. I.e. the initial filesystem stays 
>> unmodified.
> 
> This is essentially implementing a journal in userspace for e2fsprogs.
> You could even use the journal file in the filesystem.  The journal
> MUST be clean before the inode renumbering, or journal replay will
> corrupt the filesystem after your resize.  Does your tool check this?

I've copied a check from resize2fs code - it checks for !EXT2_ERROR_FS 
&& EXT2_VALID_FS and suggests running e2fsck if the check fails. Is this 
check sufficient to guarantee that the journal is empty?

> That said, there may not be enough space in the journal for full data
> journaling, but it might be enough for logical journaling of the inodes
> to be moved and the directories that need to be updated?

It may be sufficient, but just updating the directory blocks without 
moving inode tables and updating block group descriptors and superblock 
will also ruin the filesystem... So even if you are able to run inode 
number change operation through the journal, it won't really make the 
process safer.

>> Then, using e2patch utility (it's in the same repository), you can a) 
>> backup the blocks that will be modified into another patch file 
>> (e2patch backup <fs> <patch> <backup>) and b) apply the patch to real 
>> filesystem. If the applying process gets interrupted (for example by 
>> the power outage) it can be restarted from the beginning because it 
>> does nothing except just overwriting some blocks.
> 
> This is exactly like journal replay.

Overall you're right about the "userspace journal", I've also thought of 
using the real journal, but then refused it because a) as you said, the 
journal is likely to be too small to hold all inode tables during moving 
and b) journal inode may be moved during the process, and sometimes 
journal data and extent blocks may also be moved. In the latter case my 
tool will also fragment the journal, which is probably bad for 
performance (am I correct here?), so I have a TODO item for fixing it...

In fact I think there should be a way to resize inode tables safely only 
using the journal - for example: first free inodes/blocks, then shrink 
inode tables without moving them, then <strike>haha, exit :D as I 
understand it's not mandatory to move inode tables at all</strike> move 
them one flex_bg at a time, all using the journal. Or, in case of 
growing - move inode tables one flex_bg at a time and grow them after. 
But I think it would be harder to implement (is there any journal write 
code in libext2fs?) and you'll still have problems if the journal isn't 
big enough to hold inode tables for a single flex_bg (although that 
should be a very rare case).

One more feature that highly resembles patch_io is LVM snapshots which 
I've thought of only after posting my message here :) if they worked 
good, they would of course be better and more convenient than patch_io 
(for example you can run e2fsck on a writable snapshot and you can't do 
it on a 'patched' device). But just after thinking of snapshots, I've 
tried to test them by resizing inode tables on that 3 TB hard drive + 
LVM snapshot on loopback COW device... and I ended up with freezed 
./realloc-inodes process and had to reboot :)

I.e. there was no problem until it started to move inode tables, maybe 
it even managed to move some - but then, ./realloc-inodes hanged in 'D' 
state (with the system being more or less responsive overall). Details 
are in my post to linux-lvm: 
http://www.redhat.com/archives/linux-lvm/2014-January/msg00016.html - 
but there's no answer until now.

>> And if the FS changes appear to be bad at all, you can restore the 
>> backup in a same way. So the process should be safe at least to some 
>> extent.
> 
> Looks interesting.  Of course, I always recommend doing a full backup
> before any operation like this.  At that point, it would also be
> possible to just format a new filesystem and copy the data over.  That
> has the advantage of also allowing other filesystem features to be
> enabled and defragmenting the data, but could be slower if the files
> are large (as in your case) and relatively few inodes are moved.

As I understand, the resize2fs utility also isn't totally safe [in case 
of an interrupt]?
