From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 22/40] ext4: fix quota accounting in case of fallocate
Date: Tue,  1 Jun 2010 08:03:09 -0400
Message-ID: <1275393807-14369-22-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47347 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab0FAMDl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:41 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 35121c9860316d7799cea0fbc359a9186e7c2747 upstream (as of v2.6.34-git13)

allocated_meta_data is already included in 'used' variable.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e06a5d..f01fe28 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1107,7 +1107,8 @@ void ext4_da_update_reserve_space(struct inode *inode,
 		 */
 		if (allocated_meta_blocks)
 			vfs_dq_claim_block(inode, allocated_meta_blocks);
-		vfs_dq_release_reservation_block(inode, mdb_free + used);
+		vfs_dq_release_reservation_block(inode, mdb_free + used -
+						allocated_meta_blocks);
 	}
 
 	/*
-- 
1.6.6.1.1.g974db.dirty

