From: Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] ext3: dump dentry in ext3_dx_add_entry
Date: Tue,  3 Feb 2015 10:22:29 +0100
Message-ID: <1422955349-19631-1-git-send-email-olaf@aepfle.de>
Cc: Olaf Hering <olaf@aepfle.de>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:17713 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbbBCJWh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2015 04:22:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
---
 fs/ext3/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index f197736..0692058 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1529,7 +1529,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 		if (levels && (dx_get_count(frames->entries) ==
 			       dx_get_limit(frames->entries))) {
 			ext3_warning(sb, __func__,
-				     "Directory index full!");
+				     "Directory index full! %pd4 %pd", dentry->d_parent, dentry);
 			err = -ENOSPC;
 			goto cleanup;
 		}
