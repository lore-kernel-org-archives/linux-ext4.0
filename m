From: Liuwenyi <qingshenlwy@gmail.com>
Subject: [PATCHv2 05/12]posix_acl: Add the check items
Date: Mon, 21 Dec 2009 19:57:19 +0800
Message-ID: <4B2F629F.1000401@gmail.com>
Reply-To: qingshenlwy@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, adilger@sun.com, viro@zeniv.linux.org.uk,
	jmorris@namei.org, joel.becker@oracle.com, serue@us.ibm.com,
	hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:36504 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbZLULyM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Dec 2009 06:54:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

move the ACL validation check in to fs/posix_acl.c.
Including nullpointer check and PTR_ERR check.

---
Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 8a2a29d..aeb41ca 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -430,13 +430,11 @@ ext4_xattr_set_acl(struct dentry *dentry, const
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

