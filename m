Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44504 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730420AbeIYAS7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2018 20:18:59 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RESEND] ext4: Fix build error when DX_DEBUG is defined
Date: Mon, 24 Sep 2018 14:15:24 -0400
Message-Id: <20180924181524.4921-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enabling DX_DEBUG triggers the build error below.  info is an attribute
of  the dxroot structure.

linux/fs/ext4/namei.c:2264:12: error: ‘info’
undeclared (first use in this function); did you mean ‘insl’?
	   	  info->indirect_levels));

Fixes: e08ac99fa2a2 ("ext4: add largedir feature")
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 377d516c475f..67a38532032a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2261,7 +2261,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			dxroot->info.indirect_levels += 1;
 			dxtrace(printk(KERN_DEBUG
 				       "Creating %d level index...\n",
-				       info->indirect_levels));
+				       dxroot->info.indirect_levels));
 			err = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 			if (err)
 				goto journal_error;
-- 
2.19.0
