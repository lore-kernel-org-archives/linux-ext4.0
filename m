From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 13/40] ext4: Fixed inode allocator to correctly track a flex_bg's used_dirs
Date: Tue,  1 Jun 2010 08:03:00 -0400
Message-ID: <1275393807-14369-13-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47472 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab0FAMEF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:04:05 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

commit c4caae25187ff3f5e837c6f04eb1acc2723c72d3 upstream (as of v2.6.34-rc3)

When used_dirs was introduced for the flex_groups struct, it looks
like the accounting was not put into place properly, in some places
manipulating free_inodes rather than used_dirs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ialloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 179e45c..8b4bb11 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -268,7 +268,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 					ext4_group_t f;
 
 					f = ext4_flex_group(sbi, block_group);
-					atomic_dec(&sbi->s_flex_groups[f].free_inodes);
+					atomic_dec(&sbi->s_flex_groups[f].used_dirs);
 				}
 
 			}
@@ -779,7 +779,7 @@ static int ext4_claim_inode(struct super_block *sb,
 		if (sbi->s_log_groups_per_flex) {
 			ext4_group_t f = ext4_flex_group(sbi, group);
 
-			atomic_inc(&sbi->s_flex_groups[f].free_inodes);
+			atomic_inc(&sbi->s_flex_groups[f].used_dirs);
 		}
 	}
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
-- 
1.6.6.1.1.g974db.dirty

