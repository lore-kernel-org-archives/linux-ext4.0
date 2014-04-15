From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] ext4: Use EXT_MAX_BLOCKS in ext4_es_can_be_merged()
Date: Tue, 15 Apr 2014 20:08:22 +0200
Message-ID: <1397585302-27175-2-git-send-email-lczerner@redhat.com>
References: <1397585302-27175-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbaDOSIe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 14:08:34 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3FI8Xcf017067
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2014 14:08:34 -0400
In-Reply-To: <1397585302-27175-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_es_can_be_merged() when checking whether we can merge two
extents we should use EXT_MAX_BLOCKS instead of defining it manually.
Also if it is really the case we should notify userspace because clearly
there is a bug in extent status tree implementation since this should
never happen.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents_status.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 3c47b4e..b38d71a 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -344,8 +344,14 @@ static int ext4_es_can_be_merged(struct extent_status *es1,
 	if (ext4_es_status(es1) != ext4_es_status(es2))
 		return 0;
 
-	if (((__u64) es1->es_len) + es2->es_len > 0xFFFFFFFFULL)
+	if (((__u64) es1->es_len) + es2->es_len > EXT_MAX_BLOCKS) {
+		pr_warn("ES assertion failed when merging extents. "
+			"The sum of lengths of es1 (%d) and es2 (%d) "
+			"is bigger than allowed file size (%d)\n",
+			es1->es_len, es2->es_len, EXT_MAX_BLOCKS);
+		WARN_ON(1);
 		return 0;
+	}
 
 	if (((__u64) es1->es_lblk) + es1->es_len != es2->es_lblk)
 		return 0;
-- 
1.8.3.1

