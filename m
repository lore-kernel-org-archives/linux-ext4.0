Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EC1C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB572183E
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 07:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vcSXNcZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbfC2H6G (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 03:58:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54866 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729071AbfC2H6D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 03:58:03 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190329075801epoutp04c1fec108b32434df87f50f4976867607~QXvXaO8VO1708117081epoutp046;
        Fri, 29 Mar 2019 07:58:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190329075801epoutp04c1fec108b32434df87f50f4976867607~QXvXaO8VO1708117081epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1553846281;
        bh=E5wwBsBEqszLu5dTyefaKQBskuNKhYnyGEq6jYRnGPQ=;
        h=From:To:Cc:Subject:Date:In-reply-to:References:From;
        b=vcSXNcZaK2KYvTw9gaPG62J5NAvWFwx87eGFZf/lVlJx/wLIUbdixXYuo7fGfeX5F
         ipkRU586slxkBvfks8M2nzCrHsgChConZr+9hW1gnN8CdREGAKOsDA3UlAszVY4Ubg
         GUXAbiCajkpCW0SJ8NkZrbBJiZrwkZTY5xyx03k0=
Received: from epsmges2p4.samsung.com (unknown [182.195.42.72]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20190329075801epcas2p1f79fdc4bebe14068fc0ef8d40df69182~QXvXCSoRn1450114501epcas2p13;
        Fri, 29 Mar 2019 07:58:01 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.02.04207.800DD9C5; Fri, 29 Mar 2019 16:58:01 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20190329075800epcas2p4731f10eabf7d70dc7096117d161b05a3~QXvWypcB-2067620676epcas2p4A;
        Fri, 29 Mar 2019 07:58:00 +0000 (GMT)
X-AuditID: b6c32a48-6a1ff7000000106f-5d-5c9dd008d417
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.CF.03620.800DD9C5; Fri, 29 Mar 2019 16:58:00 +0900 (KST)
Received: from test-PowerEdge-R720.sa.corp.samsungelectronics.net
        ([107.108.221.212]) by mmp1.samsung.com (Oracle Communications Messaging
        Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PP40008VBFTTN20@mmp1.samsung.com>; Fri, 29 Mar 2019 16:58:00 +0900 (KST)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Cc:     axboe@fb.com, prakash.v@samsung.com, anshul@samsung.com,
        joshiiitr@gmail.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v3 7/7] fs/ext4,jbd2: add support for passing write-hint
 with journal
Date:   Fri, 29 Mar 2019 13:23:52 +0530
Message-id: <1553846032-4451-8-git-send-email-joshi.k@samsung.com>
X-Mailer: git-send-email 2.7.4
In-reply-to: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCmhS7nhbkxBlfjLX5Pn8Jq8X/PMTaL
        o//fslmcf3uYyWLvLW2LmfPusFns2XuSxeLyrjlsFvOXPWW3uDJlEbMDl8fE5nfsHjtn3WX3
        2Lyk3qNvyypGj8+b5AJYo7hsUlJzMstSi/TtErgypjQqFxxUqFi28wZbA2OHdBcjJ4eEgInE
        u2NHWLoYuTiEBHYwSqx5/JkJwvnOKNH66T0jTNWxBY9YQGwhgd2MEjemF0IUTWeSmP2vGaiI
        g4NNQFPiwuRSkLiIwBxGiWX7pjGDNDALlEv8nXIVbJCwQLjEp8dbwAaxCKhKXJzXDhbnFXCS
        mHt8HivEMjmJm+c6wXo5BZwlPl5vBjtPQmABm0TbncnsIMskBFwkbm31hqiXlni2aiPUocUS
        v+4cZYao72CUuN4wkwUiYS9xcc9fJoiD+CQ6Dv+FmsMr0dEmBFHiIfFi2hs2iMemMUqs7TvL
        PoFRYgEjwypGsdSC4tz01GKjAhO94sTc4tK8dL3k/NxNjODY0/LYwXjgnM8hRgEORiUe3g+7
        58QIsSaWFVfmHmKU4GBWEuENPDc3Rog3JbGyKrUoP76oNCe1+BCjNAeLkjjvQ+m50UIC6Ykl
        qdmpqQWpRTBZJg5OqQbG1h7ZObr1CS7bL637u/c3n5KINoOcf5h0dJb+tyW7z6WflW85derq
        X8ezvWKtd6+3at7yWxFzhEm7U+uFo2W9g/Sj1brR1xPsVmiFstd7XLRu121lX72B1XLz4e/2
        czMrfOUXnmbamblxc5G+0C2lizJdG8xvOnd/2O19dtN8hrym5xq/+mKUWIozEg21mIuKEwH9
        +aQ6uQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jAV2OC3NjDBbf1LP4PX0Kq8X/PcfY
        LI7+f8tmcf7tYSaLvbe0LWbOu8NmsWfvSRaLy7vmsFnMX/aU3eLKlEXMDlweE5vfsXvsnHWX
        3WPzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgypjSqFxwUKFi2c4bbA2MHdJdjJwcEgIm
        EscWPGIBsYUEdjJKrNhc2cXIBWTPZJL49+s/YxcjBwebgKbEhcmlIHERgTmMEj2717OCxJkF
        yiWmbOIE6RUWCJe4+u4sK4jNIqAqcXFeOyOIzSvgJDH3+DxWiF1yEjfPdTKD2JwCzhIfrzdD
        7XWSWHu/gX0CI88CRoZVjJKpBcW56bnFRgVGeanlesWJucWleel6yfm5mxiBobXtsFb/DsbH
        S+IPMQpwMCrx8M7YOSdGiDWxrLgy9xCjBAezkghv4Lm5MUK8KYmVValF+fFFpTmpxYcYpTlY
        lMR5+fOPRQoJpCeWpGanphakFsFkmTg4pRoYJQ/Zsl9o7d/JVxt9IP6V3d/8wNk7beUeCP/g
        5Nw74ef68tCtz02OXAi0b/XUc994zN1NTezu7JT6Fd7JXwK2twRdarJb9pk1/lS83MQn7r4l
        QaVmDx6edN7/8txXh/bQ2BtMorPey31sul8+3UHt19T0CWsPr4yZXSBT2hzO1brUcYdZkZKp
        EktxRqKhFnNRcSIAZVPYiCkCAAA=
X-CMS-MailID: 20190329075800epcas2p4731f10eabf7d70dc7096117d161b05a3
CMS-TYPE: 102P
X-CMS-RootMailID: 20190329075800epcas2p4731f10eabf7d70dc7096117d161b05a3
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075800epcas2p4731f10eabf7d70dc7096117d161b05a3@epcas2p4.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

For NAND based SSDs, mixing of data with different life-time reduces
efficiency of internal garbage-collection. During FS operations, series
of journal updates will follow/precede series of data/meta updates, causing
intermixing inside SSD. By passing a write-hint with journal, its write
can be isolated from other data/meta writes, leading to endurance/performance
benefit on SSD.

This patch introduces "j_writehint" member in JBD2 journal, using which
Ext4 specifies write-hint (as SHORT) for journal

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
index 15b6dd7..b589ca4 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -16,6 +16,7 @@
 #include <linux/jbd2.h>
 #include "ext4.h"
 
+#define EXT4_JOURNAL_WRITE_HINT (WRITE_LIFE_KERN_MIN)
 #define EXT4_JOURNAL(inode)	(EXT4_SB((inode)->i_sb)->s_journal)
 
 /* Define the number of blocks we need to account to a transaction to
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fb12d3c..9c2c73e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4289,6 +4289,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
+	sbi->s_journal->j_writehint = EXT4_JOURNAL_WRITE_HINT;
+
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
 
 no_journal:
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2eb55c3..6da4c28 100644
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
@@ -711,7 +713,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
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
index 8ef6b6d..804dc2c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1384,7 +1384,8 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 	jbd2_superblock_csum_set(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
-	ret = submit_bh(REQ_OP_WRITE, write_flags, bh);
+	ret = submit_bh_write_hint(REQ_OP_WRITE, write_flags, bh,
+				journal->j_writehint);
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

