From: Liuwenyi <qingshenlwy@gmail.com>
Subject: [PATCHv2 04/12]posix_acl: Add the check items
Date: Mon, 21 Dec 2009 19:56:30 +0800
Message-ID: <4B2F626E.3090402@gmail.com>
Reply-To: qingshenlwy@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, adilger@sun.com,
	viro@zeniv.linux.org.uk, jmorris@namei.org, joel.becker@oracle.com,
	serue@us.ibm.com, jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kerne
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35401 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZLULxL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Dec 2009 06:53:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---

Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 82ba341..3758304 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -432,13 +432,11 @@ ext3_xattr_set_acl(struct dentry *dentry, const
char *name, const void *value,

if (value) {
acl = posix_acl_from_xattr(value, size);
- if (IS_ERR(acl))
- return PTR_ERR(acl);
- else if (acl) {
- error = posix_acl_valid(acl);
- if (error)
- goto release_and_out;
- }
+
+ error = posix_acl_valid(acl);
+ if (error)
+ goto release_and_out;
+
} else
acl = NULL;


-- 
Best Regards,
Liuwenyi

