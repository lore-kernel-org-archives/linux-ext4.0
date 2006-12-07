From: akpm@osdl.org
Subject: - jbd2-wait-for-already-submitted-t_sync_datalist-buffer.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:08:56 -0800
Message-ID: <200612072308.kB7N8uOs030448@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
To: hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz,
	linux-ext4@vger.kernel.org, sct@redhat.com,
	mm-commits@vger.kernel.org
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: wait for already submitted t_sync_datalist buffer to complete
has been removed from the -mm tree.  Its filename was
     jbd2-wait-for-already-submitted-t_sync_datalist-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jbd2: wait for already submitted t_sync_datalist buffer to complete
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

In the current jbd code, if a buffer on BJ_SyncData list is dirty and not
locked, the buffer is refiled to BJ_Locked list, submitted to the IO and
waited for IO completion.

But the fsstress test showed the case that when a buffer was already
submitted to the IO just before the buffer_dirty(bh) check, the buffer was
not waited for IO completion.

Following patch solves this problem.  If it is assumed that a buffer is
submitted to the IO before the buffer_dirty(bh) check and still being
written to disk, this buffer is refiled to BJ_Locked list.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Jan Kara <jack@ucw.cz>
Cc: "Stephen C. Tweedie" <sct@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jbd2/commit.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/jbd2/commit.c~jbd2-wait-for-already-submitted-t_sync_datalist-buffer fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~jbd2-wait-for-already-submitted-t_sync_datalist-buffer
+++ a/fs/jbd2/commit.c
@@ -248,8 +248,12 @@ write_out_data:
 				bufs = 0;
 				goto write_out_data;
 			}
-		}
-		else {
+		} else if (!locked && buffer_locked(bh)) {
+			__jbd2_journal_file_buffer(jh, commit_transaction,
+						BJ_Locked);
+			jbd_unlock_bh_state(bh);
+			put_bh(bh);
+		} else {
 			BUFFER_TRACE(bh, "writeout complete: unfile");
 			__jbd2_journal_unfile_buffer(jh);
 			jbd_unlock_bh_state(bh);
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

origin.patch
jbd-wait-for-already-submitted-t_sync_datalist-buffer.patch

