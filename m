From: akpm@osdl.org
Subject: + jbd2-wait-for-already-submitted-t_sync_datalist-buffer.patch added to -mm tree
Date: Wed, 29 Nov 2006 14:34:10 -0800
Message-ID: <200611292234.kATMYA9n013762@shell0.pdx.osdl.net>
Cc: hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz,
	linux-ext4@vger.kernel.org, sct@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42441 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1758893AbWK2WeX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 17:34:23 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: wait for already submitted t_sync_datalist buffer to complete
has been added to the -mm tree.  Its filename is
     jbd2-wait-for-already-submitted-t_sync_datalist-buffer.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 2 deletions(-)

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

jbd-wait-for-already-submitted-t_sync_datalist-buffer.patch
