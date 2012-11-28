From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] ext4: include journal blocks in df overhead calcs
Date: Wed, 28 Nov 2012 15:48:24 -0600
Message-ID: <50B686A8.2010101@redhat.com>
References: <50B67949.60104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Whitney <enwlinux@gmail.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab2K1VsZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2012 16:48:25 -0500
In-Reply-To: <50B67949.60104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To more accurately calculate overhead for "bsd" style
df reporting, we should count the journal blocks as
overhead as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Tested-by: Eric Whitney <enwlinux@gmail.com>
---

V2: I guess s_overhead _is_ in clusters, so do
that conversion after all.  Ted, if I'm wrong, you
can pick the other patch ;)

Editorial/soapbox:

TBH it's hard to keep track of what fields are
now stored as "clusters" not blocks . . .

Esp. when we do things like use local vars named "blk" -

	blks = count_overhead(sb, i, buf);

but count_overhead() returns *clusters*, so it's
really quite confusing to keep it all straight.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..b441daa 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3229,6 +3229,10 @@ int ext4_calculate_overhead(struct super_block *sb)
 			memset(buf, 0, PAGE_SIZE);
 		cond_resched();
 	}
+	/* Add the journal blocks as well */
+	if (sbi->s_journal)
+		overhead += EXT4_B2C(sbi, sbi->s_journal->j_maxlen);
+
 	sbi->s_overhead = overhead;
 	smp_wmb();
 	free_page((unsigned long) buf);

