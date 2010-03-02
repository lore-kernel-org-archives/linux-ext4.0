From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 21/28] ext4: explicitly remove inode from orphan list after failed direct io
Date: Tue,  2 Mar 2010 13:18:38 -0500
Message-ID: <1267553925-6308-22-git-send-email-tytso@mit.edu>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43062 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0CBSS4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 13:18:56 -0500
In-Reply-To: <1267553925-6308-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

Otherwise non-empty orphan list will be triggered on umount.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index edb7edc..427f469 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3438,6 +3438,9 @@ retry:
 			 * but cannot extend i_size. Bail out and pretend
 			 * the write failed... */
 			ret = PTR_ERR(handle);
+			if (inode->i_nlink)
+				ext4_orphan_del(NULL, inode);
+
 			goto out;
 		}
 		if (inode->i_nlink)
-- 
1.6.6.1.1.g974db.dirty

