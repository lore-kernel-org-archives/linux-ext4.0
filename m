From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] jbd2: Speedup jbd2_journal_get_[write|undo]_access()
Date: Wed, 17 Jun 2015 18:39:47 +0200
Message-ID: <20150617163947.GF1614@quack.suse.cz>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-5-git-send-email-jack@suse.cz>
 <20150608164726.GM19168@thunk.org>
 <20150608223230.GO19168@thunk.org>
 <20150609052450.GQ19168@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbbFQQjx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2015 12:39:53 -0400
Content-Disposition: inline
In-Reply-To: <20150609052450.GQ19168@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 09-06-15 01:24:50, Ted Tso wrote:
> On Mon, Jun 08, 2015 at 06:32:30PM -0400, Theodore Ts'o wrote:
> > 
> > .... and this patch is causing generic/011 to fail.
> > 
> > generic/011 2s ...  [18:26:52][   13.085375] run fstests generic/011 at 2015-06-08 18:26:52
> > [   13.698245] ------------[ cut here ]------------
> > [   13.699093] kernel BUG at /usr/projects/linux/ext4/fs/jbd2/transaction.c:1329!
> > [   13.700354] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> > [   13.701388] Modules linked in:
> > [   13.701505] CPU: 0 PID: 3947 Comm: dirstress Not tainted 4.1.0-rc4-00034-g562bef4 #2758
> > [   13.701505] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > [   13.701505] task: ee1bc110 ti: ec080000 task.ti: ec080000
> > [   13.701505] EIP: 0060:[<c02eeb96>] EFLAGS: 00210206 CPU: 0
> > [   13.701505] EIP is at jbd2_journal_dirty_metadata+0x5e/0x1da
> > [   13.701505] EAX: 00000000 EBX: eccde090 ECX: f03fd580 EDX: f03fd580
> > [   13.701505] ESI: eee85860 EDI: ed918cc0 EBP: ec081e14 ESP: ec081e00
> > [   13.701505]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [   13.701505] CR0: 8005003b CR2: b73fbb20 CR3: 2fd58700 CR4: 000006f0
> > [   13.701505] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > [   13.701505] DR6: fffe0ff0 DR7: 00000400
> > [   13.701505] Stack:
> > [   13.701505]  000000f7 f03fd580 ed918cc0 eee85860 00000000 ec081e30 c02d7fc8 00001179
> > [   13.701505]  c0865c3c eae67c30 ee17f800 00000000 ec081e84 c02b6458 00000000 ed918cc0
> > [   13.701505]  c02ee941 00000000 00000000 00000000 eae67b20 00000000 00000000 eae67e78
> > [   13.701505] Call Trace:
> > [   13.701505]  [<c02d7fc8>] __ext4_handle_dirty_metadata+0xd4/0x19d
> > [   13.701505]  [<c02b6458>] ext4_mark_iloc_dirty+0x458/0x577
> > [   13.701505]  [<c02ee941>] ? jbd2_journal_get_write_access+0x3d/0x48
> > [   13.701505]  [<c02b66e4>] ext4_mark_inode_dirty+0x105/0x252
> > [   13.701505]  [<c02b121b>] __ext4_new_inode+0xcb6/0xe9b
> > [   13.701505]  [<c02bd87d>] ext4_mknod+0x8b/0x11c
> > [   13.701505]  [<c025ffbe>] vfs_mknod+0x7e/0x9e
> > [   13.701505]  [<c0263a0a>] SyS_mknodat+0x119/0x15a
> > [   13.701505]  [<c0263a65>] SyS_mknod+0x1a/0x1c
> > [   13.701505]  [<c083292a>] syscall_call+0x7/0x7
> > [   13.701505] Code: 00 00 8b 5f 24 8b 4b 18 39 d1 74 07 39 53 1c 74 02 0f 0b 83 7b 0c 01 75 14 39 d1 0f 85 7e 01 00 00 83 7b 08 01 0f 84 74 01 00 00 <0f> 0b 8b 02 53 68 16 2c ac c0 68 36 05 00 00 68 14 81 86 c0 68
> > [   13.701505] EIP: [<c02eeb96>] jbd2_journal_dirty_metadata+0x5e/0x1da SS:ESP 0068:ec081e00
> > [   13.734150] ---[ end trace eb359de3ec6c3af4 ]---
> > 
> > I will drop 4/5 and 5/5 from this patch series from the ext4 tree for
> > now.  Could you take a look at this?
> 
> It looks like the problem is really caused by the patch #5/5, not
> patch #4/5.  So I'll drop patch #5 and do more in-depth testing with
> the first four patches in the patch series.
  Yeah, sorry. I had fixed this locally (the assertion I have added had
false positives) but I didn't resend. I have checked and I don't have any
other changes locally. New version of the patch 5/5 is attached.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--/9DWx/yDrRhgMJTb
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0005-jbd2-Speedup-jbd2_journal_dirty_metadata.patch"

>From 00168e5ef68e927fad169d8fc54d10e066b6883b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 18 Mar 2015 14:29:13 +0100
Subject: [PATCH 5/5] jbd2: Speedup jbd2_journal_dirty_metadata()

It is often the case that we mark buffer as having dirty metadata when
the buffer is already in that state (frequent for bitmaps, inode table
blocks, superblock). Thus it is unnecessary to contend on grabbing
journal head reference and bh_state lock. Avoid that by checking whether
any modification to the buffer is needed before grabbing any locks or
references.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a91f639af6c3..7a3ffd0c855f 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1290,8 +1290,6 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
 	triggers->t_abort(triggers, jh2bh(jh));
 }
 
-
-
 /**
  * int jbd2_journal_dirty_metadata() -  mark a buffer as containing dirty metadata
  * @handle: transaction to add buffer to.
@@ -1325,12 +1323,36 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	WARN_ON(!transaction);
 	if (is_handle_aborted(handle))
 		return -EROFS;
-	journal = transaction->t_journal;
-	jh = jbd2_journal_grab_journal_head(bh);
-	if (!jh) {
+	if (!buffer_jbd(bh)) {
 		ret = -EUCLEAN;
 		goto out;
 	}
+	/*
+	 * We don't grab jh reference here since the buffer must be part
+	 * of the running transaction.
+	 */
+	jh = bh2jh(bh);
+	J_ASSERT_JH(jh, jh->b_transaction == transaction ||
+			jh->b_next_transaction == transaction);
+	if (jh->b_modified == 1) {
+		/*
+		 * If it's in our transaction it must be in BJ_Metadata list.
+		 * The assertion is unreliable since we may see jh in
+		 * inconsistent state unless we grab bh_state lock. But this
+		 * is crutial to catch bugs so let's do a reliable check until
+		 * the lockless handling is fully proven.
+		 */
+		if (jh->b_transaction == transaction &&
+		    jh->b_jlist != BJ_Metadata) {
+			jbd_lock_bh_state(bh);
+			J_ASSERT_JH(jh, jh->b_transaction != transaction ||
+					jh->b_jlist == BJ_Metadata);
+			jbd_lock_bh_state(bh);
+		}
+		goto out;
+	}
+
+	journal = transaction->t_journal;
 	jbd_debug(5, "journal_head %p\n", jh);
 	JBUFFER_TRACE(jh, "entry");
 
@@ -1421,7 +1443,6 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	spin_unlock(&journal->j_list_lock);
 out_unlock_bh:
 	jbd_unlock_bh_state(bh);
-	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
 	return ret;
-- 
2.1.4


--/9DWx/yDrRhgMJTb--
