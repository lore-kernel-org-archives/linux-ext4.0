From: =?utf-8?B?0JLQuNGC0LDQu9C40Lkg0KTQuNC70LjQv9C/0L7Qsg==?=
        <vitalif@yourcmc.ru>
Subject: Re: A tool that allows changing inode table sizes
Date: Mon, 26 Sep 2016 00:23:56 +0300
Message-ID: <op.yoc616nwvqcmy1@gnusmas>
References: <ea490dfe40d0de3a5c0cb388e749f172@yourcmc.ru>
 <555DD664-E495-409D-9DAB-6E0A52C98273@dilger.ca>
 <20140117002530.GK9229@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: "Ext4 Developers List" <linux-ext4@vger.kernel.org>
To: "Andreas Dilger" <adilger@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yourcmc.ru ([195.209.40.11]:57888 "EHLO yourcmc.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935055AbcIYVcD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 25 Sep 2016 17:32:03 -0400
In-Reply-To: <20140117002530.GK9229@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone!

(After > 2.5 years have passed :)!)

At last, I've integrated my inode table resize tool into resize2fs. The  
code is not very clean yet so I'm not sending it here, but it seems it  
works on testcases which I've used to test my previous tool. It also  
includes patch_io manager as `-T` option for e2fsck and resize2fs (in  
separate commits, of course).

It can even change inode count and resize the filesystem simultaneously  
(shrink fs + extend inode tables gives some errors now, but I think it  
should also be easy to fix and I'll do it shortly).

I'll clean it up and send for review, but at the current point you can  
take a look at it here: https://github.com/vitalif/e2fsprogs (better check  
a squashed diff of last commits if you want to look at the code... some  
lines are rewritten, I'll send it squashed)

My only questions are:
1) now I'm using my own move_inode_tables() instead of move_itables(). I  
see there's some strange logic in there - which cases does it handle? Is  
it something to handle overlaps during move?
2) interesting point of inode table allocation is that in case of a  
bigalloc FS it's done based on per-block (not per-cluster) bitmap during  
mke2fs. so, to reproduce that behavior I should either allocate similar  
per-block bitmap or force their position by a kind of hack (do not mark  
allocated inode tables in bitmap and set inode_table_loc to  
inode_table_loc of previous BG + inode_blocks_per_group). the second  
works, but the first seems more correct, so should I use that approach?

> On Thu, Jan 16, 2014 at 05:05:45PM -0700, Andreas Dilger wrote:
>>
>> On Jan 15, 2014, at 6:28 AM, vitalif@yourcmc.ru wrote:
>> > As I understand it was a well-known fact that ext2/3/4 does not allow  
>> changing inode table size without recreating the filesystem. And I  
>> didn't have any experience in linux filesystem internals until  
>> recently, when I've discovered that inode tables take 45 GB on one of  
>> my hard drives (3 TB in size) :-):-) that hard drive is, of course,  
>> full of movies, not 16Kb files, so the inode tables are almost 100%  
>> unused.
>> >
>> > So, I've thought it would be good if it it would possible to change  
>> inode table sizes. So I've written a tool that in fact allows to do it,  
>> and I want to present it to the community! :)
>>
>> Interesting.  I did something years ago for ext2/3 filesystem resizing
>> (ext2resize), but that has since become obsolete as the functionality
>> was included into e2fsprogs.  I'd recommend that you also work to get
>> your functionality included into e2fsprogs sooner rather than later.
>>
>> Ideally this would be part of resize2fs, but I'm not sure it would be
>> easily implemented there.
>
> I don't think it would be too difficult, since there's already code to  
> move
> blocks and inodes around.  I guess the big question is how well does it  
> respond
> to having inodes_per_group change?
>
> <shrug>
>
> --D
>>
>> > Anyone is welcome to test it of course if it's of any interest for  
>> you - the source is here  
>> http://svn.yourcmc.ru/viewvc.py/vitalif/trunk/ext4-realloc-inodes/  
>> ('download tarball') (maybe it would be better to move it into a  
>> separate git repo, of course)
>> >
>> > I didn't test it on a real hard drive yet :-D, only on small fs  
>> images with different settings (block, block group, flex_bg size,  
>> ext2/3/4, bigalloc and etc). There are even some auto-tests (ran by  
>> 'make test').
>>
>> Note that it is critical to refuse to do anything on filesystems that
>> have any feature that your tool doesn't understand.  Otherwise, it has
>> a good possibility to corrupt the filesystem.
>>
>> > The tools works without problem on all small test images that I've  
>> created, though I didn't try to run it on bigger filesystems (of course  
>> I'll do it in the nearest future).
>> >
>> > As this is a highly destructive process that involves overwriting ALL  
>> inode numbers in ALL directory entries across the whole filesystem,  
>> I've also implemented a simple method of safely applying/rolling back  
>> changes. First I've tried to use undo_io_manager, but it appears to be  
>> very slow because of frequent commits, which are of course needed for  
>> it to be safe.
>>
>> Would it be possible to speed up undo_io_manager if it had larger IO
>> groups or similar?  How does the speed of running with undo_io_manager
>> compare to running your patch_io_manager doing both a backup and apply?
>>
>> > My method is called patch_io_manager and does a different thing - it  
>> does not overwrite the initial FS image, but writes all modified blocks  
>> into a separate sparse file + writes a bitmap of modified blocks in the  
>> end when it finishes. I.e. the initial filesystem stays unmodified.
>>
>> This is essentially implementing a journal in userspace for e2fsprogs.
>> You could even use the journal file in the filesystem.  The journal
>> MUST be clean before the inode renumbering, or journal replay will
>> corrupt the filesystem after your resize.  Does your tool check this?
>>
>> That said, there may not be enough space in the journal for full data
>> journaling, but it might be enough for logical journaling of the inodes
>> to be moved and the directories that need to be updated?
>>
>> > Then, using e2patch utility (it's in the same repository), you can a)  
>> backup the blocks that will be modified into another patch file  
>> (e2patch backup <fs> <patch> <backup>) and b) apply the patch to real  
>> filesystem. If the applying process gets interrupted (for example by  
>> the power outage) it can be restarted from the beginning because it  
>> does nothing except just overwriting some blocks.
>>
>> This is exactly like journal replay.
>>
>> > And if the FS changes appear to be bad at all, you can restore the  
>> backup in a same way. So the process should be safe at least to some  
>> extent.
>>
>> Looks interesting.  Of course, I always recommend doing a full backup
>> before any operation like this.  At that point, it would also be
>> possible to just format a new filesystem and copy the data over.  That
>> has the advantage of also allowing other filesystem features to be
>> enabled and defragmenting the data, but could be slower if the files
>> are large (as in your case) and relatively few inodes are moved.
>>
>> Cheers, Andreas

-- 
With best regards,
   Vitaliy Filippov
