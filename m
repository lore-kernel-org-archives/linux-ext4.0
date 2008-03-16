From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] jbd2: Add commit time into the commit block
Date: Sun, 16 Mar 2008 23:16:17 +0800
Message-ID: <20080316151617.GA3542@webber.adilger.int>
References: <1205629144-25994-1-git-send-email-tytso@mit.edu>
 <20080316012602.GZ3542@webber.adilger.int> <20080316031039.GJ27847@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43310 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYCPPQ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Mar 2008 11:16:58 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2GFGv2R017376
	for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2008 08:16:57 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXT00B01X3E2H00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 16 Mar 2008 08:16:57 -0700 (PDT)
In-reply-to: <20080316031039.GJ27847@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 15, 2008  23:10 -0400, Theodore Ts'o wrote:
> On Sun, Mar 16, 2008 at 09:26:02AM +0800, Andreas Dilger wrote:
> > Note that we'd still be a lot further ahead undelete- and performance-wise
> > if we avoided overwriting the indirect blocks in the first place...  As
> > it is, this is only really useful if you pull the plug after the delete.
> > No harm in doing it, but won't help you recover as much as you could.
> 
> Yeah, I looked at that at one point, but I never had time to try to
> code it up.  The concept would is that we only need to zero out the
> block pointers if we end up dirtying enough bitmap blocks that we've
> run out of space in the journal and so we need to close the
> transaction.  Of course, the problem is that we need to either (a)
> figure out in advance exactly how many bitmap blocks we need to dirty
> (which means we have to read all the indirect blocks twice to figure
> it out for ext3; this is easier for ext4) so we know whether it will
> fit in one transaction,

While it's true it is a two-pass algorithm, I think it can actually
improve overall performance.  One major win is that we don't have
to write out indirect blocks, saving about 32/33 (IIRC) of the IO
needed for the current truncate.  The second win is that we can do
async prefetching of all the (d)indirect blocks from the {dt}indirect
blocks in forward order instead of the current block-at-a-time reads.
Finally, on the second pass the blocks will normally be in RAM already
so not nearly so slow.

> (b) if we try to do it in a single pass, we
> need to allow enough safety margin so that when we *do* decide we
> can't make it fit, we still do have enough space in the journal to
> zero out the blocks in the indirect blocks and in the inode.

We'd still have to truncate from the end in this case...

> I guess the third alternative, (c), is that we don't update *any* of
> the superblock or block group descriptors until the very end of the
> transaction, and don't update any of the blocks.  So we just update
> the bitmap blocks first, and then in a second pass update all of the
> blockgroup descriptors and superblock.  This would require assuring
> that the update of all of the block group descriptors, superblock, and
> removing the inode from the orphan linked list, can all fit in a
> single transaction. If not, this scheme wouldn't work at all.

I'm not sure I understand this.  Wouldn't this possibly lead to those
blocks being re-allocated after a crash?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

