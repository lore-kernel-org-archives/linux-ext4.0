Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F44C10F03
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9099B20645
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 11:24:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aNPZ16MP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbfDYLYV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:24:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30713 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387624AbfDYLYL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 07:24:11 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190425112408epoutp01b2d61ce0294a373a6259eb77e27ed697~Ys_CzMAyq1921819218epoutp01S;
        Thu, 25 Apr 2019 11:24:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190425112408epoutp01b2d61ce0294a373a6259eb77e27ed697~Ys_CzMAyq1921819218epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1556191448;
        bh=C76dKk0NmGHl/Qu5kKDvvmvO7y5dIxg97utO9LWSE00=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=aNPZ16MPX4xsbeNO6I6B3SQWrijtqOKpEIzqKZLrebADGg0GJad7qHA8Mna5Asyjt
         k8CYuCdzh4dW75C0iY1pUociQm861LX1Vzw6934qBefxD7kD9ctcnbqf0J8oUe0x2O
         FLoKzXf17FcwJXalpY2MacLmkFGXB+182z2jTEaI=
Received: from epsmges2p3.samsung.com (unknown [182.195.42.71]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20190425112408epcas2p30eecd8269be3909764b5a2e35ad36a9b~Ys_CbZvyq3170231702epcas2p3k;
        Thu, 25 Apr 2019 11:24:08 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.C9.04206.8D891CC5; Thu, 25 Apr 2019 20:24:08 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190425112408epcas2p2ddba9fdf175645dd2647da191eac5e1c~Ys_CRhRhI0083200832epcas2p2G;
        Thu, 25 Apr 2019 11:24:08 +0000 (GMT)
X-AuditID: b6c32a47-14bff7000000106e-f1-5cc198d8b568
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p2new.samsung.com
        (Symantec Messaging Gateway) with SMTP id BB.4D.03620.8D891CC5; Thu, 25 Apr
        2019 20:24:08 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp2.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQI007Z2KZ7JR40@mmp2.samsung.com>; Thu, 25 Apr 2019 20:24:08 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, anshul@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 7/7] fs/ext4,jbd2: add support for sending write-hint
 with journal
Date:   Thu, 25 Apr 2019 16:50:02 +0530
Message-id: <1556191202-3245-8-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCmue6NGQdjDP78lrX4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGX9ebWcrOKZQsf6ffANjt3QXIyeHhICJxM2T/9m7GLk4hAR2MEp8ubEDyvnO
        KLGjZQsLTNXtgzvZIBIbGCWm7HvGBOFMZ5LYdfYQUIaDg01AU+LC5FKQuIjAHEaJZfumMYN0
        MwuESKx4sooFpEZYIFyi80EpiMkioCrxcY4MSAWvgJPElm3T2CB2yUncPNcJ1skp4Czx4gfE
        KgmBDjaJ5tenGCGKXCR6bj1mhrClJZ6t2ggVL5b4decoM1QDo8T1hplQH9hLXNzzlwniHj6J
        jsN/2UGOkBDglehoE4Io8ZC4cPYB1F/TGCWe3dnLNIFRYgEjwypGsdSC4tz01GKjAmO94sTc
        4tK8dL3k/NxNjOCo0nLfwbjtnM8hRgEORiUeXoXIAzFCrIllxZW5hxglOJiVRHjVTQ/GCPGm
        JFZWpRblxxeV5qQWH2KU5mBREud9KD03WkggPbEkNTs1tSC1CCbLxMEp1cCo/DJEuX6hiEXV
        ndBnjv+bbM8ucPaJeHBgu7DG5959fdpXzj5+2Mb85d3KFRXyP1+5GSn9uXjoxaeuWeGN7LKb
        z3w2PN9/xFj+SF6X3ztLNdGZ78R9GFdVBBRtPmFRMG/+qexUybRYB/WWc9uOdxX779F71L/+
        eu2HC2lGp64bCS4oCZigz22mxFKckWioxVxUnAgA9ozqpqYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42I5/e+xoO6NGQdjDB4eEbb4PX0Kq8XR/2/Z
        LPbe0raYOe8Om8WevSdZLC7vmsNmMX/ZU3aLK1MWMTtweGxeUu/Rt2UVo8fnTXIBzFFcNimp
        OZllqUX6dglcGX9ebWcrOKZQsf6ffANjt3QXIyeHhICJxO2DO9m6GLk4hATWMUo0/jnPCOHM
        ZJK4+7SRvYuRg4NNQFPiwuRSkLiIwBxGiZ7d61lBupkFQiRmPXvMBmILC4RLNLTuBqtnEVCV
        +DhHBiTMK+AksWXbNDaIZXISN891MoPYnALOEi9+PGMCsYWAaq5N28Q+gZFnASPDKkbJ1ILi
        3PTcYqMCo7zUcr3ixNzi0rx0veT83E2MwKDZdlirfwfj4yXxhxgFOBiVeHgVIg/ECLEmlhVX
        5h5ilOBgVhLhVTc9GCPEm5JYWZValB9fVJqTWnyIUZqDRUmclz//WKSQQHpiSWp2ampBahFM
        lomDU6qBMTRO8NoijrUqC/lza/edjLOQe839pTd8FUtM4Pk3k6Uf1WuzO8t5t55hOVPzdvrq
        3m+/lE+fL7pjrBP2yWBTXsLxW4IHjuZO9ug/MVF9w5W5jSuXnv+3sO+m/XV23Q72jKdHcl/d
        Z/4YX/2r4LxdwNKqT+VXi95MtVB+VvXxwXVui8JdP8+/XaDEUpyRaKjFXFScCADnuS1mFgIA
        AA==
X-CMS-MailID: 20190425112408epcas2p2ddba9fdf175645dd2647da191eac5e1c
CMS-TYPE: 102P
X-CMS-RootMailID: 20190425112408epcas2p2ddba9fdf175645dd2647da191eac5e1c
References: <1556191202-3245-1-git-send-email-joshi.k@samsung.com>
        <CGME20190425112408epcas2p2ddba9fdf175645dd2647da191eac5e1c@epcas2p2.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

For NAND based SSDs, mixing of data with different life-time reduces
efficiency of internal garbage-collection. During FS operations,
series of journal updates will follow/precede series of data/meta
updates, causing intermixing inside SSD. By passing a write-hint with
journal, its write can be isolated from other data/meta writes, leading
to endurance/performance benefit on SSD.
This patch introduces "j_writehint" member in JBD2 journal, using which
Ext4 specifies write-hint for journal.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/ext4/ext4_jbd2.h  |  1 +
 fs/ext4/super.c      |  2 ++
 fs/jbd2/commit.c     | 11 +++++++----
 fs/jbd2/journal.c    |  3 ++-
 fs/jbd2/revoke.c     |  3 ++-
 include/linux/jbd2.h |  8 ++++++++
 6 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 75a5309..ade47b2 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -16,6 +16,7 @@
 #include <linux/jbd2.h>
 #include "ext4.h"
 
+#define EXT4_JOURNAL_WRITE_HINT (WRITE_LIFE_KERN_MIN)
 #define EXT4_JOURNAL(inode)	(EXT4_SB((inode)->i_sb)->s_journal)
 
 /* Define the number of blocks we need to account to a transaction to
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6ed4eb8..238c0b5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4298,6 +4298,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
+	sbi->s_journal->j_writehint = EXT4_JOURNAL_WRITE_HINT;
+
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
 
 no_journal:
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index efd0ce9..be3a0b9 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -153,10 +153,12 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !jbd2_has_feature_async_commit(journal))
-		ret = submit_bh(REQ_OP_WRITE,
-			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh);
+		ret = submit_bh_write_hint(REQ_OP_WRITE,
+			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh,
+			journal->j_writehint);
 	else
-		ret = submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
+		ret = submit_bh_write_hint(REQ_OP_WRITE, REQ_SYNC, bh,
+			journal->j_writehint);
 
 	*cbh = bh;
 	return ret;
@@ -713,7 +715,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
+				submit_bh_write_hint(REQ_OP_WRITE, REQ_SYNC,
+						bh, journal->j_writehint);
 			}
 			cond_resched();
 			stats.run.rs_blocks_logged += bufs;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 382c030..6dc7c9a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1372,7 +1372,8 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 		sb->s_checksum = jbd2_superblock_csum(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
-	ret = submit_bh(REQ_OP_WRITE, write_flags, bh);
+	ret = submit_bh_write_hint(REQ_OP_WRITE, write_flags, bh,
+				   journal->j_writehint);
 	wait_on_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		clear_buffer_write_io_error(bh);
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index a1143e5..376b1d8 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -642,7 +642,8 @@ static void flush_descriptor(journal_t *journal,
 	set_buffer_jwrite(descriptor);
 	BUFFER_TRACE(descriptor, "write");
 	set_buffer_dirty(descriptor);
-	write_dirty_buffer(descriptor, REQ_SYNC);
+	write_dirty_buffer_with_hint(descriptor, REQ_SYNC,
+				journal->j_writehint);
 }
 #endif
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0f919d5..918f21e 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1139,6 +1139,14 @@ struct journal_s
 	 */
 	__u32 j_csum_seed;
 
+	/**
+	 * @j_writehint:
+	 *
+	 * write-hint for journal (set by FS).
+	 */
+	enum rw_hint	j_writehint;
+
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/**
 	 * @j_trans_commit_map:
-- 
2.7.4

