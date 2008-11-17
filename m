From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 unlink performance
Date: Sun, 16 Nov 2008 18:43:30 -0600
Message-ID: <20081117004330.GC3436@webber.adilger.int>
References: <20081113185712.GB11204@untroubled.org>
 <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu>
 <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu>
 <20081115204423.GA4671@untroubled.org> <20081116005610.GI22948@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:39874 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYKQAnd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2008 19:43:33 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAH0hWBI000606
	for <linux-ext4@vger.kernel.org>; Sun, 16 Nov 2008 16:43:32 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAG00M01CJIY800@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 16 Nov 2008 16:43:32 -0800 (PST)
In-reply-to: <20081116005610.GI22948@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 15, 2008  19:56 -0500, Theodore Ts'o wrote:
> The problem is definitely in how we choose the directory and file
> inode numbers for ext4.  A quick look of the free block and free inode
> counts from the dumpe2fs of your ext3 and ext4 256-byte inode e2images
> tells the tail.  Ext4 is using blocks and inodes packed up against the
> beginning of the filesystem, and ext3 has the blocks and inodes spread
> out for better locality.
> 
> We didn't change the ext4's inode allocation algorithms,

That isn't true, in ext4 the inode allocation algorithm is different
when FLEX_BG is enabled.

> so I'm guessing that it's interacting very poorly with ext4's block delayed
> allocation algorithms.  Bruce, how much memory did you have in your
> system?  Do you have a large amount of memory, say 6-8 gigs, by any
> chance?  When the filesystem creates a new directory, if the block
> group is especially full, it will choose a new block group for the
> directory, to spread things out.  However, if the blocks haven't been
> allocated yet, then the directories won't be spread out appropriately,
> and then the inodes will be allocated close to the directories, and
> then things go downhill from there.

It isn't clear this is the root of the problem yet.  In fact, packing
the inodes and directories together should improve performance, because
there is no seeking when accessing the file metadata.  If the file data
is not "close" to the inode that doesn't really matter, because unlinks
do not need to access the file data.

Even with the old algorithm the data is not right beside the inode so
there will always have to be a seek of some kind to access it, and the
difference in performance between a short seek and a long seek is not
that much.

> This is much more likely to
> happen if you have a large number of small files, and a large amount
> of memory, and when you are unpacking a tar file and so are write out
> a large number of these small files spaced very closely in time,
> before they have a chance to get forced out to disk and thus allocated
> so the filesystem can take block group fullness into account when
> deciding how to allocate inode numbers.

Presumably the below listings are ext3 first, ext4 second?

>   29566 free blocks, 15551 free inodes, 95 directories
>   30568 free blocks, 16285 free inodes, 0 directories
>   31581 free blocks, 16312 free inodes, 0 directories
>   30484 free blocks, 16266 free inodes, 0 directories
>   31187 free blocks, 15954 free inodes, 0 directories
>   30693 free blocks, 16359 free inodes, 0 directories
>   31282 free blocks, 16276 free inodes, 0 directories
>   30689 free blocks, 16355 free inodes, 0 directories
>   31589 free blocks, 16258 free inodes, 0 directories
>   13310 free blocks, 14144 free inodes, 0 directories
:
: [snip]
:
>   13556 free blocks, 16218 free inodes, 0 directories
>   31510 free blocks, 16256 free inodes, 0 directories
>   13310 free blocks, 0 free inodes, 400 directories
>   0 free blocks, 9462 free inodes, 671 directories
>   3870 free blocks, 9683 free inodes, 401 directories
>   0 free blocks, 10254 free inodes, 1036 directories
>   0 free blocks, 12830 free inodes, 1040 directories
>   0 free blocks, 13954 free inodes, 886 directories
>   5497 free blocks, 15126 free inodes, 536 directories

In the ext3 case there are possibly a hundred different groups that
need to be updated, spread all over the disk.

>   685 free blocks, 0 free inodes, 1199 directories
>   4096 free blocks, 0 free inodes, 547 directories
>   3823 free blocks, 0 free inodes, 362 directories
>   4604 free blocks, 0 free inodes, 268 directories
>   2168 free blocks, 0 free inodes, 232 directories
:
: [snip]
:
>   2899 free blocks, 0 free inodes, 19 directories
>   6290 free blocks, 5438 free inodes, 15 directories, 5438 unused inodes
>   32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
>   32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
>   32768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
>   30768 free blocks, 16384 free inodes, 0 directories, 16384 unused inodes
:

In the ext4 case, there are maybe a dozen groups that are filled completely,
and the rest of the groups are untouched.  This would suggest that less
seeking is needed to access the metadata for all of these files, instead
of more.

Recall again that we don't really care where the file data is
located in the unlink case, except that we need to need to update the
block bitmaps when the blocks are freed.  Again in the ext4 case, since
there are fewer groups holding the inodes, there are also fewer groups
with blocks and it _should_ be that fewer block bitmaps need updating.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

