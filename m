From: Jan Kara <jack@suse.cz>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1
 kernel
Date: Wed, 8 Jun 2016 14:56:31 +0200
Message-ID: <20160608125631.GA19589@quack2.suse.cz>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
 <20160531154017.GC5357@thunk.org>
 <20160601063822.GH10350@eguan.usersys.redhat.com>
 <20160601165800.GI10350@eguan.usersys.redhat.com>
 <20160602085840.GH19636@quack2.suse.cz>
 <20160602121750.GC32574@quack2.suse.cz>
 <20160603101612.GJ10350@eguan.usersys.redhat.com>
 <20160603115844.GB2470@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Eryu Guan <eguan@redhat.com>, linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161222AbcFHM4f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2016 08:56:35 -0400
Content-Disposition: inline
In-Reply-To: <20160603115844.GB2470@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 03-06-16 13:58:44, Jan Kara wrote:
> On Fri 03-06-16 18:16:12, Eryu Guan wrote:
> > On Thu, Jun 02, 2016 at 02:17:50PM +0200, Jan Kara wrote:
> > > 
> > > So I was trying but I could not reproduce the hang either. Can you find out
> > > which page is jbd2 thread waiting for and dump page->index, page->flags and
> > > also bh->b_state, bh->b_blocknr of all 4 buffer heads attached to it via
> > > page->private? Maybe that will shed some light...
> > 
> > I'm using crash on live system when the hang happens, so I got the page
> > address from "bt -f"
> > 
> >  #6 [ffff880212343b40] wait_on_page_bit at ffffffff8119009e
> >     ffff880212343b48: ffffea0002c23600 000000000000000d 
> >     ffff880212343b58: 0000000000000000 0000000000000000 
> >     ffff880212343b68: ffff880213251480 ffffffff810cd000 
> >     ffff880212343b78: ffff88021ff27218 ffff88021ff27218 
> >     ffff880212343b88: 00000000c1b4a75a ffff880212343c68 
> >     ffff880212343b98: ffffffff811901bf
> 
> Thanks for debugging! In the end I was able to reproduce the issue on my
> UML instance as well and I'm debugging what's going on.

Attached patch fixes the issue for me. I'll submit it once a full xfstests
run finishes for it (which may take a while as our server room is currently
moving to a different place).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--+QahgC5+KEYLbs62
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-deadlock-during-page-writeback.patch"

>From 3a120841a5d9a6c42bf196389467e9e663cf1cf8 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 8 Jun 2016 10:01:45 +0200
Subject: [PATCH] ext4: Fix deadlock during page writeback

Commit 06bd3c36a733 (ext4: fix data exposure after a crash) uncovered a
deadlock in ext4_writepages() which was previously much harder to hit.
After this commit xfstest generic/130 reproduces the deadlock on small
filesystems.

The problem happens when ext4_do_update_inode() sets LARGE_FILE feature
and marks current inode handle as synchronous. That subsequently results
in ext4_journal_stop() called from ext4_writepages() to block waiting for
transaction commit while still holding page locks, reference to io_end,
and some prepared bio in mpd structure each of which can possibly block
transaction commit from completing and thus results in deadlock.

Fix the problem by releasing page locks, io_end reference, and
submitting prepared bio before calling ext4_journal_stop().

Reported-by: Eryu Guan <eguan@redhat.com>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f7140ca66e3b..ba04d57656d4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2748,13 +2748,27 @@ retry:
 				done = true;
 			}
 		}
-		ext4_journal_stop(handle);
 		/* Submit prepared bio */
 		ext4_io_submit(&mpd.io_submit);
 		/* Unlock pages we didn't use */
 		mpage_release_unused_pages(&mpd, give_up_on_write);
-		/* Drop our io_end reference we got from init */
-		ext4_put_io_end(mpd.io_submit.io_end);
+		/*
+		 * Drop our io_end reference we got from init. We have to be
+		 * careful and use deferred io_end finishing as we can release
+		 * the last reference to io_end which may end up doing unwritten
+		 * extent conversion which we cannot do while holding
+		 * transaction handle.
+		 */
+		ext4_put_io_end_defer(mpd.io_submit.io_end);
+		/*
+		 * Caution: ext4_journal_stop() can wait for transaction commit
+		 * to finish which may depend on writeback of pages to complete
+		 * or on page lock to be released. So we can call it only
+		 * after we have submitted all the IO, released page locks
+		 * we hold, and dropped io_end reference (for extent conversion
+		 * to be able to complete).
+		 */
+		ext4_journal_stop(handle);
 
 		if (ret == -ENOSPC && sbi->s_journal) {
 			/*
-- 
2.6.6


--+QahgC5+KEYLbs62--
