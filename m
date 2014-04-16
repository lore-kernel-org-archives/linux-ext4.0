From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/5] ext4: fix removing status extents in ext4_collapse_range()
Date: Wed, 16 Apr 2014 20:32:59 +0200
Message-ID: <1397673182-5326-2-git-send-email-lczerner@redhat.com>
References: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Cc: linkinjeon@gmail.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbaDPSdk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2014 14:33:40 -0400
In-Reply-To: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in ext4_collapse_range() when calling ext4_es_remove_extent() to
remove status extents we're passing (EXT_MAX_BLOCKS - punch_start - 1)
in order to remove all extents from start of the collapse range to the
end of the file. However this is wrong because we might miss the
possible extent covering the last block of the file.

Fix it by removing the -1.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 821c1d4..25ed60f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5422,7 +5422,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	ext4_discard_preallocations(inode);
 
 	ret = ext4_es_remove_extent(inode, punch_start,
-				    EXT_MAX_BLOCKS - punch_start - 1);
+				    EXT_MAX_BLOCKS - punch_start);
 	if (ret) {
 		up_write(&EXT4_I(inode)->i_data_sem);
 		goto out_stop;
-- 
1.8.3.1

