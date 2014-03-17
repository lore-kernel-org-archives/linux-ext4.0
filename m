From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext3: explicitly remove inode from orphan list after failed
 direct io
Date: Mon, 17 Mar 2014 14:13:00 -0500
Message-ID: <5327493C.7060801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaCQTNH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2014 15:13:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise non-empty orphan list will be triggered on umount.

This is just an application of commit da1daf by Dmitry Monakhov
to the same code in ext3.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 384b6eb..caf4c4a 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1925,6 +1925,8 @@ retry:
 			 * and pretend the write failed... */
 			ext3_truncate_failed_direct_write(inode);
 			ret = PTR_ERR(handle);
+			if (inode->i_nlink)
+				ext3_orphan_del(NULL, inode);
 			goto out;
 		}
 		if (inode->i_nlink)
