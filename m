From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 0/5] ext4: Shut down block groups when damage is
 detected
Date: Fri, 9 Aug 2013 23:02:12 -0700
Message-ID: <20130810060212.GA6945@blackbox.djwong.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130721143226.GA13473@gmail.com>
 <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36282 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3HJGCX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Aug 2013 02:02:23 -0400
Content-Disposition: inline
In-Reply-To: <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 11:28:38AM -0400, Jeff Moyer wrote:
> Zheng Liu <gnehzuil.liu@gmail.com> writes:
> 
> > My idea is to let file system can ignore the currurted block.  Namely,
> > when we meet a currupted block, we will track it as bad block in bad
> > block inode and find another block to save data.  This currupted block
> > will never be used.  The first step in my mind is to detect a currpted
> > block and mark it as bad block.  After reading the thread and Darrick's
> > original patch, I think Darrick's patch is a good start.
> 
> I think it's important to call out the exact failure scenario you're
> trying to address.  For hard disks, if you get a read error, it can
> typically be recovered by re-writing the block.  I imagine this is what
> fsck would be doing for metadata repair.  So, I'm not at all sure why
> you'd want to track bad blocks in the file system itself.  Could you
> elaborate, please?

Sorry, was on vacation.

Actually, I had a few different scenarios in mind when I was writing this
patchset.  I've observed that feeding bad block bitmaps to ext4 (misplaced
write, for example) results in it using the garbage bitmap for allocations and
smashing the fs.  Metadata checksumming (and the other sanity checks) at least
help us to detect these situations, but even with that, the allocators will
repeatedly beat on broken block groups.  The repetition causes log spew and in
a few cases the block allocator will go into an infinite loop looking for
space.  This patch set fixes the log spew and the infinite loops.

--D
> 
> Cheers,
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
