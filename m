From: akpm@osdl.org
Subject: [patch 272/354] jbd2: wait for already submitted t_sync_datalist buffer to complete
Date: Wed, 06 Dec 2006 20:39:17 -0800
Message-ID: <200612070439.kB74dHkn029993@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz,
	linux-ext4@vger.kernel.org, sct@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47261 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968756AbWLGEjd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:39:33 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
