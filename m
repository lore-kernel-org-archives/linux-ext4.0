From: Chen Gang <gang.chen@asianux.com>
Subject: [PATCH] fs/ext3: use kzalloc instead of kmalloc
Date: Mon, 24 Dec 2012 13:28:53 +0800
Message-ID: <50D7E815.6050503@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jack@suse.cz, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:56007 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2LXF17 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2012 00:27:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  better to use kzalloc instead of kmalloc.
    if acl_e->e_tag is neither ACL_USER, nor ACL_GROUP.
    entry->e_id will not be initialized

  we can not say it is a bug, but suggest to initialize it, too.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 fs/ext3/acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index dbb5ad5..5121c5b 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -91,7 +91,7 @@ ext3_acl_to_disk(const struct posix_acl *acl, size_t *size)
 	size_t n;
 
 	*size = ext3_acl_size(acl->a_count);
-	ext_acl = kmalloc(sizeof(ext3_acl_header) + acl->a_count *
+	ext_acl = kzalloc(sizeof(ext3_acl_header) + acl->a_count *
 			sizeof(ext3_acl_entry), GFP_NOFS);
 	if (!ext_acl)
 		return ERR_PTR(-ENOMEM);
-- 
1.7.10.4
