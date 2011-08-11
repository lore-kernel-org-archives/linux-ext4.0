From: Jan Kara <jack@suse.cz>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Thu, 11 Aug 2011 16:01:01 +0200
Message-ID: <20110811140101.GA18802@quack.suse.cz>
References: <4E4262A5.6030903@msgid.tls.msk.ru>
 <20110811115943.GF4755@quack.suse.cz>
 <4E43C956.3060507@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1HKOBD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 10:01:03 -0400
Content-Disposition: inline
In-Reply-To: <4E43C956.3060507@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Thu 11-08-11 16:21:42, Michael Tokarev wrote:
> 11.08.2011 15:59, Jan Kara wrote:
> > On Wed 10-08-11 14:51:17, Michael Tokarev wrote:
> >> For a few days I'm evaluating various options to use
> >> storage.  I'm interested in concurrent direct I/O
> >> (oracle rdbms workload).
> >>
> >> I noticed that somehow, ext4fs in mixed read-write
> >> test greatly prefers writes over reads - writes goes
> >> at full speed while reads are almost non-existent.
> >>
> >> Sandeen on IRC pointed me at dioread_nolock mount
> >> option, which I tried with great results, if not
> >> one "but".
> >>
> >> There's a deadlock somewhere, which I can't trigger
> >> "on demand" - I can't hit the right condition.  It
> >> happened twice in a row already, each time after the
> >> same scenario (more about that later).
> >>
> >> When it happens, a process doing direct AIO stalls
> >> infinitely, with the following backtrace:
> >>
> >> [87550.759848] INFO: task oracle:23176 blocked for more than 120 seconds.
> >> [87550.759892] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> [87550.759955] oracle          D 0000000000000000     0 23176      1 0x00000000
> >> [87550.760006]  ffff8820457b47d0 0000000000000082 ffff880600000000 ffff881278e3f7d0
> >> [87550.760085]  ffff8806215c1fd8 ffff8806215c1fd8 ffff8806215c1fd8 ffff8820457b47d0
> >> [87550.760163]  ffffea0010bd7c68 ffffffff00000000 ffff882045512ef8 ffffffff810eeda2
> >> [87550.760245] Call Trace:
> >> [87550.760285]  [<ffffffff810eeda2>] ? __do_fault+0x422/0x520
> >> [87550.760327]  [<ffffffff81111ded>] ? kmem_getpages+0x5d/0x170
> >> [87550.760367]  [<ffffffff81112e58>] ? ____cache_alloc_node+0x48/0x140
> >> [87550.760430]  [<ffffffffa0123e6d>] ? ext4_file_write+0x20d/0x260 [ext4]
> >> [87550.760475]  [<ffffffff8106aee0>] ? abort_exclusive_wait+0xb0/0xb0
> >> [87550.760523]  [<ffffffffa0123c60>] ? ext4_llseek+0x120/0x120 [ext4]
> >> [87550.760566]  [<ffffffff81162173>] ? aio_rw_vect_retry+0x73/0x1d0
> >> [87550.760607]  [<ffffffff8116302f>] ? aio_run_iocb+0x5f/0x160
> >> [87550.760646]  [<ffffffff81164258>] ? do_io_submit+0x4f8/0x600
> >> [87550.760689]  [<ffffffff81359b52>] ? system_call_fastpath+0x16/0x1b
> >   Hmm, the stack trace does not quite make sense to me - the part between
> > __do_fault and aio_rw_vect_retry is somehow broken. I can imagine we
> > blocked in ext4_file_write() but I don't see any place there where we would
> > allocate memory. By any chance, are there messages like "Unaligned AIO/DIO
> > on inode ..." in the kernel log?
> 
> Yes, there are warnings about unaligned DIO, referring to this same
> process actually. Oracle does almost good job at aligning writes
> (usually it does i/o by its blocks which are 4Kb by default but
> are set to something larger - like 16Kb - for larger database).
> Except of a few cases, and lgwr process is one of them (*) - it
> writes logfiles using 512b blocks.  This is okay for a raw device
> with 512bytes blocks, but ext4 expects 4k writes at min.
> 
> (*) another case is writing to control file, which is also done in
> 512byte chunks.
  Ah, OK. I think the code ext4_end_io_nolock() handling the wait queue
might be racy. waitqueue_active() check is missing a barrier I think.
Does attached (untested) patch fix the issue for you?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--ew6BAiZeqk4r7MaW
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-missed-wakeups.patch"

>From a5dd84bbe3c55b2717150ac26f8b9011d8f9181f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 11 Aug 2011 15:57:51 +0200
Subject: [PATCH] ext4: Fix missed wakeups

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/page-io.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 430c401..34d01d4 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -79,9 +79,11 @@ void ext4_free_io_end(ext4_io_end_t *io)
 		put_io_page(io->pages[i]);
 	io->num_io_pages = 0;
 	wq = ext4_ioend_wq(io->inode);
-	if (atomic_dec_and_test(&EXT4_I(io->inode)->i_ioend_count) &&
-	    waitqueue_active(wq))
-		wake_up_all(wq);
+	if (atomic_dec_and_test(&EXT4_I(io->inode)->i_ioend_count)) {
+		smp_mb__after_atomic_dec();
+		if (waitqueue_active(wq))
+			wake_up_all(wq);
+	}
 	kmem_cache_free(io_end_cachep, io);
 }
 
@@ -122,9 +124,10 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 		io->flag &= ~EXT4_IO_END_UNWRITTEN;
 		/* Wake up anyone waiting on unwritten extent conversion */
 		wq = ext4_ioend_wq(io->inode);
-		if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten) &&
-		    waitqueue_active(wq)) {
-			wake_up_all(wq);
+		if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten)) {
+			smp_mb__after_atomic_dec();
+			if (waitqueue_active(wq))
+				wake_up_all(wq);
 		}
 	}
 
-- 
1.7.1


--ew6BAiZeqk4r7MaW--
