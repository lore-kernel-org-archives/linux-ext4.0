From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problem with delayed allocation
Date: Sat, 2 Aug 2008 18:40:16 -0400
Message-ID: <20080802224016.GA9007@mit.edu>
References: <E1KPNNn-0003IN-0B@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40334 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750818AbYHBWkT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 18:40:19 -0400
Content-Disposition: inline
In-Reply-To: <E1KPNNn-0003IN-0B@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One update on the delayed allocation writes not getting pushed
problem; the problem existed with the patch queue as of July 10th, but
it is *much* worse with recent kernels.  I found out why; the V2
version of the journal writepages patch had this comment:

   1) fix  writepages() inefficency issue. sync() will invoke writepages()
   twice (not sure exactly why), the second time all the pages are clean so
   it waste the cpu time to walk though all pages and find they are not
   dirty . But it's simple to workaround by skip writepages() if there is
   no dirty pages pointed by the mapping.

It is quite deliberate for sync to invoke writepages() twice.
__fsync_super() calls sync_inodes_sb() twice, once with wait=0, and
once with want=1.  This results in sync_inodes_sb() calling
sync_sb_inodes(), first with wbc.sync_mode set to WB_SYNC_HOLD (in the
wait==0 case), and then later with wbc.sync_mode set to WB_SYNC_ALL
(in the wait==1 case). 

sync_sb_inodes() calls generic_sync_sb_inodes(), which iterates over
all inodes in sb->s_io, and calls __writeback_single(inode, wbc),
which will write out the dirty pages by calling __sync_single_inode().

__sync_single_inode is responsible for writing out a single inode's
dirty pages and inode data to disk.  If wbc.sync_mode is set to
WB_SYNC_ALL, it will wait for the writeout by calling
filemap_fdatawait() after it calls do_writepages().

It is do_writepages(mapping, wbc), which calls the filesystem-specific
writepages (i.e., the ext4_da_writepages) or generic_writepages().

When writing out a 300 megabytes of a Linux kernel source,
approximately 100 megabytes of data don't make it to disk if the
filesystem is remounted read-only right after the untar finishes.  In
an earlier version of the patch series, without the journal credits
patch, only 20 megabytes of data is lost.  So the journal_credits
patch seems to make things worse.

For this reason, I'm not going to push the journal credits patch to
Linus right away, because I suspect it is implicated in a regression.
I'm also going to suggest that we split up the patch into simpler
pieces, so we can audit the obvious bits and get them upstream more
quickly.

The data writeback paths are *complicated* (possibly unduly
complicated), and I'm not sure I understand them completely.  So we're
going to need to back off and study this carefully.  This is why I
think we really are going to have to break up this patch.

      	 	      	 	    	     	     - Ted
