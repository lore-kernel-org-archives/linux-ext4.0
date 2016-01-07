From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Thu, 7 Jan 2016 12:47:36 +0100
Message-ID: <20160107114736.GC8380@quack.suse.cz>
References: <697280a570654ae0aa1723fb7d11f51e@SGPMBX1004.APAC.bosch.com>
 <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbcAGLr2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jan 2016 06:47:28 -0500
Content-Disposition: inline
In-Reply-To: <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 07-01-16 11:02:29, HUANG Weller (CM/ESW12-CN) wrote:
> > -----Original Message-----
> > From: Jan Kara [mailto:jack@suse.cz]
> > Sent: Thursday, January 07, 2016 6:24 PM
> > To: HUANG Weller (CM/ESW12-CN) <Weller.Huang@cn.bosch.com>
> > Cc: Jan Kara <jack@suse.cz>; linux-ext4@vger.kernel.org
> > Subject: Re: ext4 out of order when use cfq scheduler
> > 
> > On Thu 07-01-16 06:43:00, HUANG Weller (CM/ESW12-CN) wrote:
> > > > -----Original Message-----
> > > > From: Jan Kara [mailto:jack@suse.cz]
> > > > Sent: Wednesday, January 06, 2016 6:06 PM
> > > > To: HUANG Weller (CM/ESW12-CN) <Weller.Huang@cn.bosch.com>
> > > > Subject: Re: ext4 out of order when use cfq scheduler
> > > >
> > > > On Wed 06-01-16 02:39:15, HUANG Weller (CM/ESW12-CN) wrote:
> > > > > > So you are running in 'ws' mode of your tool, am I right? Just
> > > > > > looking into the sources you've sent me I've noticed that
> > > > > > although you set O_SYNC in openflg when mode == MODE_WS, you do
> > > > > > not use openflg at all. So file won't be synced at all. That
> > > > > > would well explain why you see that not all file contents is
> > > > > > written. So did you just send me a different version of the
> > > > > > source or is your test program
> > > > really buggy?
> > > > > >
> > > > >
> > > > > Yes, it is a bug of the test code. So the test tool create files
> > > > > without O_SYNC flag actually.  But , even in this case, is the out
> > > > > of order acceptable ? or is it normal ?
> > > >
> > > > Without fsync(2) or O_SYNC, it is perfectly possible that some files
> > > > are written and others are not since nobody guarantees order of
> > > > writeback of inodes. OTOH you shouldn't ever see uninitialized data
> > > > in the inode (but so far it isn't clear to me whether you really see
> > > > unitialized data or whether we really wrote zeros to those blocks -
> > > > ext4 can sometimes decide to do so).  Your traces and disk contents
> > > > show that the problematic inode has extent of length 128 blocks
> > > > starting at block
> > > > 0x12c00 and then extent of lenght 1 block starting at block 0x1268e.
> > > > What is the block size of the filesystem?  Because inode size is only 0x40010.
> > > >
> > > > Some suggestions to try:
> > > > 1) Print also length of a write request in addition to the starting
> > > > block so that we can see how much actually got written
> > >
> > > Please see below failure analysis.
> > >
> > > > 2) Initialize the device to 0xff so that we can distinguish
> > > > uninitialized blocks from zeroed-out blocks.
> > >
> > > Yes, i Initialize the device to 0xff this time.
> > >
> > > > 3) Report exactly for which 512-byte blocks checksum matches and for
> > > > which it is wrong.
> > > The wrong contents are old file contents which are created in previous
> > > test round.  It is caused by the "wrong" sequence inode data(in
> > > journal) and  the file contents. So the file contents are not updated.
> > 
> > So this confuses me somewhat. You previously said that you always remove files
> > after each test round and then new ones are created. Is it still the case? So the old
> > file contents you speak about above is just some random contents that happened
> > to be in disk blocks we freshly allocated to the file, am I right?
> 
> Yes. You are right.
>  The "old file contents" means that the disk blocks which the contents is generated from last test round, and they are allocated to a new file in new test round.
> 
> 
> > 
> > OK, so I was looking into the code and indeed, reality is correct and my mental
> > model was wrong! ;) I thought that inode gets added to the list of inodes for which
> > we need to wait for data IO completion during transaction commit during block
> > allocation. And I was wrong. It used to happen in
> > mpage_da_map_and_submit() until commit f3b59291a69d (ext4: remove calls to
> > ext4_jbd2_file_inode() from delalloc write path) where it got removed. And that was
> > wrong because although we submit data writes before dropping handle for
> > allocating transaction and updating i_size, nobody guarantees that data IO is not
> > delayed in the block layer until transaction commit.
> > Which seems to happen in your case. I'll send a fix. Thanks for your report and
> > persistence!
> > 
> 
> Thanks a lot for your feedback :-)
> Because I am not familiar with the detail of the ext4 internal code.  I will try to understand your explanation which you describe above.  And have a look on related funcations.
> Could you send the fix in this mail ?
> And whether the kernel 3.14 also have such issue, right ?

The problem is in all kernels starting with 3.8. Attached is a patch which
should fix the issue. Can you test whether it fixes the problem for you?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--gKMricLos+KVdGMg
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-data-exposure-after-a-crash.patch"

>From 4dd4ac4bec65620a71df5e3f893e6728863f05c3 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 7 Jan 2016 12:21:25 +0100
Subject: [PATCH] ext4: Fix data exposure after a crash

Huang has reported that in his powerfail testing he is seeing stale
block contents in some of recently allocated blocks although he mounts
ext4 in data=ordered mode. After some investigation I have found out
that indeed when delayed allocation is used, we don't add inode to
transaction's list of inodes needing flushing before commit. Originally
we were doing that but commit f3b59291a69d removed the logic with a
flawed argument that it is not needed.

The problem is that although for delayed allocated blocks we write their
contents immediately after allocating them, there is no guarantee that
the IO scheduler or device doesn't reorder things and thus transaction
allocating blocks and attaching them to inode can reach stable storage
before actual block contents. Actually whenever we attach freshly
allocated blocks to inode using a written extent, we should add inode to
transaction's ordered inode list to make sure we properly wait for block
contents to be written before committing the transaction. So that is
what we do in this patch. This also handles other cases where stale data
exposure was possible - like filling hole via mmap in
data=ordered,nodelalloc mode.

The only exception to the above rule are extending direct IO writes where
blkdev_direct_IO() waits for IO to complete before increasing i_size and
thus stale data exposure is not possible. For now we don't complicate
the code with optimizing this special case since the overhead is pretty
low. In case this is observed to be a performance problem we can always
handle it using a special flag to ext4_map_blocks().

CC: stable@vger.kernel.org
Fixes: f3b59291a69d0b734be1fc8be489fef2dd846d3d
Reported-by: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ff2f3cd38522..b216a3eb41a8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -682,6 +682,20 @@ out_sem:
 		ret = check_block_validity(inode, map);
 		if (ret != 0)
 			return ret;
+
+		/*
+		 * Inodes with freshly allocated blocks where contents will be
+		 * visible after transaction commit must be on transaction's
+		 * ordered data list.
+		 */
+		if (map->m_flags & EXT4_MAP_NEW &&
+		    !(map->m_flags & EXT4_MAP_UNWRITTEN) &&
+		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
+		    ext4_should_order_data(inode)) {
+			ret = ext4_jbd2_file_inode(handle, inode);
+			if (ret)
+				return ret;
+		}
 	}
 	return retval;
 }
@@ -1135,15 +1149,6 @@ static int ext4_write_end(struct file *file,
 	int i_size_changed = 0;
 
 	trace_ext4_write_end(inode, pos, len, copied);
-	if (ext4_test_inode_state(inode, EXT4_STATE_ORDERED_MODE)) {
-		ret = ext4_jbd2_file_inode(handle, inode);
-		if (ret) {
-			unlock_page(page);
-			page_cache_release(page);
-			goto errout;
-		}
-	}
--gKMricLos+KVdGMg--
