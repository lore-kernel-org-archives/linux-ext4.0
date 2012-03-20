From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH v1 1/9] ext4: do not mark superblock as dirty unnecessarily
Date: Tue, 20 Mar 2012 16:41:21 +0200
Message-ID: <1332254489-2300-2-git-send-email-dedekind1@gmail.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759160Ab2CTOle (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Mar 2012 10:41:34 -0400
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Commit a0375156ca1041574b5d47cc7e32f10b891151b0 cleaned up superblock dirtying
handling, but missed one place. This patch does what was intended: if we have
the journal, then we update the superblock through the journal rather than
doing this directly.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext4/inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..e040403 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3924,10 +3924,8 @@ static int ext4_do_update_inode(handle_t *handle,
 			ext4_update_dynamic_rev(sb);
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
-			sb->s_dirt = 1;
 			ext4_handle_sync(handle);
-			err = ext4_handle_dirty_metadata(handle, NULL,
-					EXT4_SB(sb)->s_sbh);
+			err = ext4_handle_dirty_super(handle, sb);
 		}
 	}
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
-- 
1.7.7.6

