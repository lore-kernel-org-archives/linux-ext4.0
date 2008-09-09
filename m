From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH -mm] jbd: test BH_Write_EIO to detect errors on metadata
    buffers
Date: Tue, 09 Sep 2008 17:42:41 +0900
Message-ID: <48C63701.6090700@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	adilger@sun.com, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com, nickpiggin@yahoo.com.au
To: akpm@linux-foundation.org, sct@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44734 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIIInb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 04:43:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

__try_to_free_cp_buf(), __process_buffer(), and __wait_cp_io()
test BH_Uptodate flag to detect write I/O errors on metadata
buffers.  But by commit 95450f5a7e53d5752ce1a0d0b8282e10fe745ae0
"ext3: don't read inode block if the buffer has a write error"(*),
BH_Uptodate flag can be set to inode buffers with BH_Write_EIO
in order to avoid reading old inode data.  So now, we have to
test BH_Write_EIO flag of checkpointing inode buffers instead
of BH_Uptodate.  This patch does it.

(*) http://lkml.org/lkml/2008/6/23/126

This patch depends on the following patch set in -mm:

#1 jbd: abort when failed to log metadata buffers
   http://lkml.org/lkml/2008/7/24/160
#2 jbd: fix error handling for checkpoint io
   http://lkml.org/lkml/2008/7/24/163
#3 ext3: add checks for errors from jbd
   http://lkml.org/lkml/2008/7/29/539
#4 jbd: don't dirty original metadata buffer on abort
   http://lkml.org/lkml/2008/7/24/168

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/checkpoint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.27-rc5-mm1/fs/jbd/checkpoint.c
===================================================================
--- linux-2.6.27-rc5-mm1.orig/fs/jbd/checkpoint.c
+++ linux-2.6.27-rc5-mm1/fs/jbd/checkpoint.c
@@ -94,7 +94,7 @@ static int __try_to_free_cp_buf(struct j
 	struct buffer_head *bh = jh2bh(jh);
 
 	if (jh->b_jlist == BJ_None && !buffer_locked(bh) &&
-	    !buffer_dirty(bh) && buffer_uptodate(bh)) {
+	    !buffer_dirty(bh) && !buffer_write_io_error(bh)) {
 		JBUFFER_TRACE(jh, "remove from checkpoint list");
 		ret = __journal_remove_checkpoint(jh) + 1;
 		jbd_unlock_bh_state(bh);
@@ -214,7 +214,7 @@ restart:
 			spin_lock(&journal->j_list_lock);
 			goto restart;
 		}
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			ret = -EIO;
 
 		/*
@@ -283,7 +283,7 @@ static int __process_buffer(journal_t *j
 		ret = 1;
 	} else if (!buffer_dirty(bh)) {
 		ret = 1;
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			ret = -EIO;
 		J_ASSERT_JH(jh, !buffer_jbddirty(bh));
 		BUFFER_TRACE(bh, "remove from checkpoint");


