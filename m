From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 unlink performance
Date: Wed, 19 Nov 2008 12:10:01 -0600
Message-ID: <20081119181000.GD3186@webber.adilger.int>
References: <20081113185712.GB11204@untroubled.org>
 <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu>
 <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu>
 <20081115204423.GA4671@untroubled.org> <20081116005610.GI22948@mit.edu>
 <20081117004330.GC3436@webber.adilger.int> <20081119024021.GA10185@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63177 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbYKSSKi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Nov 2008 13:10:38 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAJIAZAQ002429
	for <linux-ext4@vger.kernel.org>; Wed, 19 Nov 2008 10:10:37 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAL00E01CHWYB00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 19 Nov 2008 10:10:32 -0800 (PST)
In-reply-to: <20081119024021.GA10185@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 18, 2008  21:40 -0500, Theodore Ts'o wrote:
> Looking at the blkparse profiles, doing an rm -rf given the ext4
> produced layout required 5130 megabytes.  The exact same directory
> hierarchy, as laied out by ext3, required only 1294 megabytes.
> Looking at a few selected inode allocation bitmaps, we see that ext4
> will often need to write (and thus journal) the same block allocation
> bitmap block 4 or 5 times:
> 
> 254,7    0      352     0.166492349  9376  C   R 8216 + 8 [0]
> 254,7    0   348788   212.885545554     0  C   W 8216 + 8 [0]
> 254,7    0   461448   309.533613765     0  C   W 8216 + 8 [0]
> 254,7    0   827687   558.781690434     0  C   W 8216 + 8 [0]
> 254,7    0  1210492   760.738217014     0  C   W 8216 + 8 [0]
> 
> However, the same block allocation block bitmap is only written once
> or twice.
> 
> 254,8    0     3119     9.535331283     0  C   R 524288 + 8 [0]
> 254,8    0    24504    45.253431031     0  C   W 524288 + 8 [0]
> 254,8    0    85476   144.455205555 23903  C   W 524288 + 8 [0]

Looking at the seekwatcher graphs, it is clear that the ext4 layout
is doing fewer seeks, and packing the data into a smaller part of
the filesystem, which is counter-intuitive to the performance result.

Even though the IO bandwidth is ostensibly higher (usually a good thing
on metadata benchmarks) that isn't any good if we are doing more writes.


It isn't immediately clear that _just_ the case of rewriting the same
block multiple times is a culprit in itself, because in the ext3 case
there would be more block bitmaps affeted that would _each_ be written
out 1 or 2 times, while the closer packing of ext4 allocations results
in fewer total bimaps being used.

One would think in the case of more sharing of a block bitmap would
result in a performance _increase_ because there is more chance that
it will be re-used within the same transaction.

> ext4:
>  Reads Completed:    59947,   239788KiB
>  Writes Completed:     1282K,     5130MiB
>
> ext3:
>  Reads Completed:    64856,   259424KiB
>  Writes Completed:   323582,     1294MiB

The reads look the about same, writes are 4x higher.  What would be
useful to examine is the inode number grouping of files in the same
subdirectory, along with the blocks they are allocating.  It seems
like the inodes are being packed more closely together, but the
blocks (and hence block bitmap writes) are spread further apart.

That may be a side-effect of the mballoc per-CPU cache again, where
files being written in the same subdirectory are spread apart because
of the write thread being rescheduled to different cores.

I discussed this in the past with Eric, in the case of a file doing
small writes+fsync and the blocks being fragmented needlessly between
different parts of the filesystem.  The proposed solution in that case
(that Aneesh could probably fix quickly) is to attach an inode to the
per-CPU preallocation group on the first write (for small files).  If it
doesn't get any more writes that is fine, but if it does then the same
PA would be used for further allocations regardless of what CPU is doing
the IO.

Another solution for that case, and (as I speculate) this case, is to
attach the PA to the parent directory and have all small files in the
same directory use that PA.  This would ensure that blocks allocated to
small inodes in the same directory are kept together.  The drawback is
that this could hurt performance for multiple threads writing to the
same directory.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

