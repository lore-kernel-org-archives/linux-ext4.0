From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 1/2] ext3: Support large blocksize up to PAGESIZE
Date: Mon, 01 Oct 2007 17:36:01 -0700
Message-ID: <1191285362.11737.59.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, Jan Kara <jack@suse.cz>, clameter@sgi.com,
	akpm@osdl.org
To: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48553 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbXJBAxo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 20:53:44 -0400
In-Reply-To: <1188434857.3799.76.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Support large blocksize up to PAGESIZE (max 64KB) for ext3

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
