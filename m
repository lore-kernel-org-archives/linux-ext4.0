From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: Remove arbitrary block value in __es_remove_extent()
Date: Tue, 15 Apr 2014 20:08:21 +0200
Message-ID: <1397585302-27175-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaDOSIc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 14:08:32 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3FI8WRo009841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2014 14:08:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In __es_remove_extent() we're storing seemingly arbitrary value
0x7FDEADBEEF into block variable. I assume that the reason is just to
initialize the variable before the use because the actual value does not
matter at this point.

Just remove the arbitrary value and initialized block variable to zero
which is much less suspicious.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents_status.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 33682aa..3c47b4e 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -782,7 +782,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	struct extent_status *es;
 	struct extent_status orig_es;
 	ext4_lblk_t len1, len2;
-	ext4_fsblk_t block;
+	ext4_fsblk_t block = 0;
 	int err;
 
 retry:
@@ -810,7 +810,6 @@ retry:
 
 			newes.es_lblk = end + 1;
 			newes.es_len = len2;
-			block = 0x7FDEADBEEF;
 			if (ext4_es_is_written(&orig_es) ||
 			    ext4_es_is_unwritten(&orig_es))
 				block = ext4_es_pblock(&orig_es) +
-- 
1.8.3.1

