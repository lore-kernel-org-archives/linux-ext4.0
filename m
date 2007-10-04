From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Support large blocksize up to PAGESIZE (max 64KB) for ext3
Date: Thu,  4 Oct 2007 01:50:50 -0400
Message-ID: <1191477059-5357-16-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
 <1191477059-5357-4-git-send-email-tytso@mit.edu>
 <1191477059-5357-5-git-send-email-tytso@mit.edu>
 <1191477059-5357-6-git-send-email-tytso@mit.edu>
 <1191477059-5357-7-git-send-email-tytso@mit.edu>
 <1191477059-5357-8-git-send-email-tytso@mit.edu>
 <1191477059-5357-9-git-send-email-tytso@mit.edu>
 <1191477059-5357-10-git-send-email-tytso@mit.edu>
 <1191477059-5357-11-git-send-email-tytso@mit.edu>
 <1191477059-5357-12-git-send-email-tytso@mit.edu>
 <1191477059-5357-13-git-send-email-tytso@mit.edu>
 <1191477059-5357-14-git-send-email-tytso@mit.edu>
 <1191477059-5357-15-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Takashi Sato <sho@tnes.nec.co.jp>,
	Mingming Cao <cmm@us.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44846 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbXJDFvL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:11 -0400
In-Reply-To: <1191477059-5357-15-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Takashi Sato <sho@tnes.nec.co.jp>

This patch set supports large block size(>4k, <=64k) in ext3
just enlarging the block size limit. But it is NOT possible to have 64kB
blocksize on ext3 without some changes to the directory handling
code.  The reason is that an empty 64kB directory block would have a
rec_len == (__u16)2^16 == 0, and this would cause an error to be hit in
the filesystem.  The proposed solution is treat 64k rec_len
with a an impossible value like rec_len = 0xffff to handle this.

The Patch-set consists of the following 2 patches.
  [1/2]  ext3: enlarge blocksize
         - Allow blocksize up to pagesize

  [2/2]  ext3: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Now on 64k page ppc64 box runs with this patch set we could create a 64k
block size ext3, and able to handle empty directory block.

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext3/super.c         |    6 +++++-
 include/linux/ext3_fs.h |    4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 9537316..b4bfd36 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1549,7 +1549,11 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		}
 
 		brelse (bh);
-		sb_set_blocksize(sb, blocksize);
+		if (!sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "EXT3-fs: bad blocksize %d.\n",
+				blocksize);
+			goto out_fail;
+		}
 		logic_sb_block = (sb_block * EXT3_MIN_BLOCK_SIZE) / blocksize;
 		offset = (sb_block * EXT3_MIN_BLOCK_SIZE) % blocksize;
 		bh = sb_bread(sb, logic_sb_block);
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index ece49a8..7aa5556 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -76,8 +76,8 @@
  * Macro-instructions used to manage several block sizes
  */
 #define EXT3_MIN_BLOCK_SIZE		1024
-#define	EXT3_MAX_BLOCK_SIZE		4096
-#define EXT3_MIN_BLOCK_LOG_SIZE		  10
+#define	EXT3_MAX_BLOCK_SIZE		65536
+#define EXT3_MIN_BLOCK_LOG_SIZE		10
 #ifdef __KERNEL__
 # define EXT3_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
-- 
1.5.3.2.81.g17ed
