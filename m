From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 06/40] ext4: explicitly remove inode from orphan list after failed direct io
Date: Tue,  1 Jun 2010 08:02:53 -0400
Message-ID: <1275393807-14369-6-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47263 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit da1dafca84413145f5ac59998b4cdd06fb89f721 upstream (as of v2.6.33-git11)

Otherwise non-empty orphan list will be triggered on umount.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26a3d54..4e8759a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3437,6 +3437,9 @@ retry:
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

