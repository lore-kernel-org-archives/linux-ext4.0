From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Use kstrtoul() instead of parse_strtoul()
Date: Tue,  9 Apr 2013 15:12:28 +0200
Message-ID: <1365513148-23358-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759009Ab3DINMc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 09:12:32 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r39DCWU2020394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Apr 2013 09:12:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In parse_strtoul() we're still using deprecated simple_strtoul(). Remove
parse_strtoul() altogether and replace it with kstrtoul()

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 525beb6..af76375 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2382,19 +2382,6 @@ struct ext4_attr {
 	int offset;
 };
 
-static int parse_strtoul(const char *buf,
-		unsigned long max, unsigned long *value)
-{
-	char *endp;
-
-	*value = simple_strtoul(skip_spaces(buf), &endp, 0);
-	endp = skip_spaces(endp);
-	if (*endp || *value > max)
-		return -EINVAL;
-
-	return 0;
-}
-
 static ssize_t delayed_allocation_blocks_show(struct ext4_attr *a,
 					      struct ext4_sb_info *sbi,
 					      char *buf)
@@ -2434,11 +2421,13 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 					  const char *buf, size_t count)
 {
 	unsigned long t;
+	int ret;
 
-	if (parse_strtoul(buf, 0x40000000, &t))
-		return -EINVAL;
+	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	if (ret)
+		return ret;
 
-	if (t && !is_power_of_2(t))
+	if (t && (!is_power_of_2(t) || t > 0x40000000))
 		return -EINVAL;
 
 	sbi->s_inode_readahead_blks = t;
@@ -2459,9 +2448,11 @@ static ssize_t sbi_ui_store(struct ext4_attr *a,
 {
 	unsigned int *ui = (unsigned int *) (((char *) sbi) + a->offset);
 	unsigned long t;
+	int ret;
 
-	if (parse_strtoul(buf, 0xffffffff, &t))
-		return -EINVAL;
+	ret = kstrtoul(skip_spaces(buf), 0, &t);
+	if (ret)
+		return ret;
 	*ui = t;
 	return count;
 }
-- 
1.7.7.6

