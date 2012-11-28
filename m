From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: include journal blocks in df overhead calcs
Date: Wed, 28 Nov 2012 14:51:21 -0600
Message-ID: <50B67949.60104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab2K1UvW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2012 15:51:22 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qASKpMeD017647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2012 15:51:22 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qASKpLYH009242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2012 15:51:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To more accurately calculate overhead for "bsd" style
df reporting, we should count the journal blocks as
overhead as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Tested-by: Eric Whitney <enwlinux@gmail.com>
---

I don't think this needs any special treatment for
big allocclusters, does it?  df still reports
blocks?

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
+		overhead += sbi->s_journal->j_maxlen;
+
 	sbi->s_overhead = overhead;
 	smp_wmb();
 	free_page((unsigned long) buf);
