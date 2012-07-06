From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] ext4: fix comment in extents.c/ext4_ext_check_cache
Date: Fri, 06 Jul 2012 10:21:52 +0800
Message-ID: <4FF64BC0.40607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For the branch test, it means no valid data cached.
Fix the comment here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91341ec..5207b7b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2121,7 +2121,7 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 	cex = &EXT4_I(inode)->i_cached_extent;
 	sbi = EXT4_SB(inode->i_sb);
 
-	/* has cache valid data? */
+	/* do not cache valid data? */
 	if (cex->ec_len == 0)
 		goto errout;
 
-- 
1.7.1
