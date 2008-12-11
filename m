From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH, v2] ext3: ensure link targets are NULL-terminated
Date: Thu, 11 Dec 2008 22:26:05 +0000
Message-ID: <20081211222605.GB18665@dastardly.home.dghda.com>
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com> <1229022995-9898-6-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Boaz Harrosh <bharrosh@panasas.com>, Stephen@kumera.dghda.com,
	Tweedie@kumera.dghda.com, sct@redhat.com, Andrew@kumera.dghda.com,
	Morton@kumera.dghda.com, akpm@linux-foundation.org,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1229022995-9898-6-git-send-email-duaneg@dghda.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

V2: terminate when the link is read instead of every time it is
followed, as suggested by Dave Kleikamp.

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index f8424ad..c168781 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2817,9 +2817,10 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &ext3_dir_inode_operations;
 		inode->i_fop = &ext3_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
-		if (ext3_inode_is_fast_symlink(inode))
+		if (ext3_inode_is_fast_symlink(inode)) {
 			inode->i_op = &ext3_fast_symlink_inode_operations;
-		else {
+			((char *) ei->i_data)[inode->i_size] = '\0';
+		} else {
 			inode->i_op = &ext3_symlink_inode_operations;
 			ext3_set_aops(inode);
 		}
-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
