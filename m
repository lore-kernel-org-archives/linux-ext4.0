From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: don't count external journal blocks as overhead
Date: Fri, 14 Nov 2014 12:39:47 -0600
Message-ID: <54664C73.60409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161518AbaKNSju (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Nov 2014 13:39:50 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAEIdm5N018976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2014 13:39:49 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sAEIdlkp028436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2014 13:39:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was fixed for ext3 with:

e6d8fb3 ext3: Count internal journal as bsddf overhead in ext3_statfs

but was never fixed for ext4.

With a large external journal and no used disk blocks, df comes
out negative without this, as journal blocks are added to the
overhead & subtracted from used blocks unconditionally.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

ps: since this is stored in the on-disk superblock now, I'm not
sure how to fix up old filesystems, or if it matters much.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2c9e686..9674578 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3338,8 +3338,8 @@ int ext4_calculate_overhead(struct super_block *sb)
 			memset(buf, 0, PAGE_SIZE);
 		cond_resched();
 	}
-	/* Add the journal blocks as well */
-	if (sbi->s_journal)
+	/* Add the internal journal blocks as well */
+	if (sbi->s_journal && !sbi->journal_bdev)
 		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
 
 	sbi->s_overhead = overhead;

