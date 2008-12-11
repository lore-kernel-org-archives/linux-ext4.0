From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH, v2] ext2: ensure link targets are NUL-terminated
Date: Thu, 11 Dec 2008 22:23:59 +0000
Message-ID: <20081211222359.GA18665@dastardly.home.dghda.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1229022995-9898-5-git-send-email-duaneg@dghda.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

V2: terminate when the link is read instead of every time it is
followed, as suggested by Dave Kleikamp.

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7658b33..9bacf35 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1286,9 +1286,10 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		else
 			inode->i_mapping->a_ops = &ext2_aops;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext2_inode_is_fast_symlink(inode))
+		if (ext2_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext2_fast_symlink_inode_operations;
-		else {
+			((char *) ei->i_data)[inode->i_size] = '\0';
+		} else {
 			inode->i_op = &ext2_symlink_inode_operations;
 			if (test_opt(inode->i_sb, NOBH))
 				inode->i_mapping->a_ops = &ext2_nobh_aops;
-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
