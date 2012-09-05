From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH] ext4: ext4_mknod:  always set i_op
Date: Wed, 05 Sep 2012 18:51:04 +0200
Message-ID: <504782F8.2080005@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:34112 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2IEQvJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Sep 2012 12:51:09 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id q85Gp6m3030980
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 5 Sep 2012 18:51:07 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While I was looking through the code, I noticed i_op 
is not always initialized, although operations such 
as setattr probably always should be set.


ext4: ext4_mknod:  always set i_op

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

ext4_special_inode_operations have their own ifdef CONFIG_EXT4_FS_XATTR
to mask those methods. And ext4_iget also always sets it, so there is
an inconsistency.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 fs/ext4/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a42cc0..d13873d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2149,9 +2149,7 @@ retry:
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
-#ifdef CONFIG_EXT4_FS_XATTR
 		inode->i_op = &ext4_special_inode_operations;
-#endif
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);


