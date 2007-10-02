From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 1/2] ext4: Support large blocksize up to PAGESIZE
Date: Mon, 01 Oct 2007 17:34:58 -0700
Message-ID: <1191285298.11737.53.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sho@tnes.nec.co.jp, Jan Kara <jack@suse.cz>, clameter@sgi.com,
	tytso@mit.edu
To: ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46408 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbXJBAfC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Oct 2007 20:35:02 -0400
In-Reply-To: <1188434857.3799.76.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Support large blocksize up to PAGESIZE (max 64KB) for ext4. 

From: Takashi Sato <sho@tnes.nec.co.jp>

This patch set supports large block size(>4k, <=64k) in ext4,
just enlarging the block size limit. But it is NOT possible to have 64kB
blocksize on ext4 without some changes to the directory handling
code.  The reason is that an empty 64kB directory block would have a
rec_len == (__u16)2^16 == 0, and this would cause an error to be hit in
the filesystem.  The proposed solution is treat 64k rec_len
with a an impossible value like rec_len = 0xffff to handle this.

The Patch-set consists of the following 2 patches.
  [1/2]  ext4: enlarge blocksize
         - Allow blocksize up to pagesize

  [2/2]  ext4: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Now on 64k page ppc64 box runs with this patch set we could create a 64k
block size ext4dev, and able to handle empty directory block.
Patch consider to be merge to 2.6.24-rc1.

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---

 fs/ext4/super.c         |    5 +++++
 include/linux/ext4_fs.h |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 619db84..d8bb279 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1548,6 +1548,11 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		goto out_fail;
 	}
 
+	if (!sb_set_blocksize(sb, blocksize)) {
+		printk(KERN_ERR "EXT4-fs: bad blocksize %d.\n", blocksize);
+		goto out_fail;
+	}
+
 	/*
 	 * The ext4 superblock will not be buffer aligned for other than 1kB
 	 * block sizes.  We need to calculate the offset from buffer start.
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index f9881b6..d15a15e 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -77,8 +77,8 @@
  * Macro-instructions used to manage several block sizes
  */
 #define EXT4_MIN_BLOCK_SIZE		1024
-#define	EXT4_MAX_BLOCK_SIZE		4096
-#define EXT4_MIN_BLOCK_LOG_SIZE		  10
+#define	EXT4_MAX_BLOCK_SIZE		65536
+#define EXT4_MIN_BLOCK_LOG_SIZE		10
 #ifdef __KERNEL__
 # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
