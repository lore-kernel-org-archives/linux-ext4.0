Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D00C282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 258CC20652
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 17:54:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gobsLPVi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbfDQRyK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:54:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19389 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733270AbfDQRyH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 13:54:07 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20190417175404epoutp0288c2fbb7ca6af33bd277708600d09162~WVINqVbF00937009370epoutp02a;
        Wed, 17 Apr 2019 17:54:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20190417175404epoutp0288c2fbb7ca6af33bd277708600d09162~WVINqVbF00937009370epoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555523644;
        bh=C76dKk0NmGHl/Qu5kKDvvmvO7y5dIxg97utO9LWSE00=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=gobsLPViFWW1QCh76rBkz9VUva+tHQTkAHLWfnqJfEt2VQeTqga40ps/uXfD9vYte
         TKZaGupcioY/yguegS6L2PShuTE+GGvVaef8wBup0SRUpLneK8FSwbfXraFw34W6kb
         yyucSUIQs/f6edb+TFZu1YXBCtgmG2pj+f6Jvus4=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190417175404epcas2p24c94ad70bd5598a486988dde7e5b5cf3~WVINZ8aPP0324203242epcas2p2O;
        Wed, 17 Apr 2019 17:54:04 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.68.04207.C3867BC5; Thu, 18 Apr 2019 02:54:04 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190417175404epcas2p1380bc5b15bd1e3c09866765c581a34c3~WVINFF7xW1198411984epcas2p1c;
        Wed, 17 Apr 2019 17:54:04 +0000 (GMT)
X-AuditID: b6c32a48-6a1ff7000000106f-01-5cb7683cfe84
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.EF.03620.B3867BC5; Thu, 18 Apr 2019 02:54:04 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PQ4006MF9PFCC30@mmp1.samsung.com>; Thu, 18 Apr 2019 02:54:03 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 7/7] fs/ext4,jbd2: add support for sending write-hint
 with journal
Date:   Wed, 17 Apr 2019 23:20:06 +0530
Message-id: <1555523406-2380-8-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCmha5NxvYYg78vRS2O/n/LZrH3lrbF
        zHl32Cz27D3JYnF51xw2i/nLnrJbXJmyiNmB3WPzknqPvi2rGD0+b5ILYI7isklJzcksSy3S
        t0vgyvjzajtbwTGFivX/5BsYu6W7GDk5JARMJP5tb2fsYuTiEBLYwSjx8fB0KOc7o8SG7m+M
        MFWflp9mgUjsZpS4vP0JM4QznUliz71vTF2MHBxsApoSFyaXgsRFBOYwSizbN40ZpJtZwE5i
        xrfXrCC2sEC4xPP+1ewgNouAqsShTafB4rwCThIPljSxQWyTk7h5rhOsl1PAWeLRlVtsIEMl
        BP6ySkz6twiqyEXi9oo+VghbWuLZqo1QpxZL/LpzlBmioYNR4nrDTBaIhL3ExT1/mSAu4pPo
        OPyXHeRqCQFeiY42IYgSD4mtd3eyQXw2jVGi8883xgmMEgsYGVYxiqUWFOempxYbFZjoFSfm
        Fpfmpesl5+duYgTHk5bHDsYD53wOMQpwMCrx8K5Q3R4jxJpYVlyZe4hRgoNZSYTXMWVLjBBv
        SmJlVWpRfnxRaU5q8SFGaQ4WJXHeh9Jzo4UE0hNLUrNTUwtSi2CyTBycUg2Mu3zeuS+XWGTK
        Wu5r/CN3UdqStpM155Y7nXazzldfITy3IM7mBO88K8d7jlEcOz9b391VnO7go3Roumjqp+q5
        0/cETezbu2DV2eoNHbIWZqlvdscLSSxnkNr1pnLtEwG2X3XyYd2MF6+vDYgIO75c2Wda67cj
        H7kaSjrtn60zr3VtFspKTYtQYinOSDTUYi4qTgQA9mJ9zqMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAV2bjO0xBnsvMlkc/f+WzWLvLW2L
        mfPusFns2XuSxeLyrjlsFvOXPWW3uDJlEbMDu8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqk
        b5fAlfHn1Xa2gmMKFev/yTcwdkt3MXJySAiYSHxafpqli5GLQ0hgJ6PElPe7WCGcmUwS+9af
        Y+ti5OBgE9CUuDC5FCQuIjCHUaJn93pWkG5mATuJGd9eg9nCAuESu54sZAexWQRUJQ5tOg0W
        5xVwkniwpIkNYpucxM1zncwgNqeAs8SjK7fA4kJANadX/WGfwMizgJFhFaNkakFxbnpusVGB
        UV5quV5xYm5xaV66XnJ+7iZGYLBsO6zVv4Px8ZL4Q4wCHIxKPLwrVLfHCLEmlhVX5h5ilOBg
        VhLhdUzZEiPEm5JYWZValB9fVJqTWnyIUZqDRUmclz//WKSQQHpiSWp2ampBahFMlomDU6qB
        kf9Cj9idz4uWpbl82b5R3+f+3weWP7eoCz0sWT19wxnP31Hr/tXVrDwi0zddYnny+umTdr1S
        WVW0u9zvTGN0/g5DZ6FTOtpzpLLXFjw4d3Nb8Dx23stcWytnmjz6dTpsQ/iSx4ed+XZurZlp
        f2FV4ZFHYY8956avPcc6f/0H1vC5OpUs8qdPN29WYinOSDTUYi4qTgQAkhwY3BICAAA=
X-CMS-MailID: 20190417175404epcas2p1380bc5b15bd1e3c09866765c581a34c3
CMS-TYPE: 102P
X-CMS-RootMailID: 20190417175404epcas2p1380bc5b15bd1e3c09866765c581a34c3
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175404epcas2p1380bc5b15bd1e3c09866765c581a34c3@epcas2p1.samsung.com>
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

