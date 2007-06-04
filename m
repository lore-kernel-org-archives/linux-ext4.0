From: Vasily Averin <vvs@sw.ru>
Subject: [PATCH ext3/ext4] orphan list check on destroy_inode
Date: Mon, 04 Jun 2007 09:18:55 +0400
Message-ID: <4663A0BF.9010008@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
	linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
	adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:2230 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbXFDFTW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jun 2007 01:19:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Customers claims to ext3-related errors, investigation showed that ext3 orphan list has been corrupted and have the reference to non-ext3 inode. The following debug helps to understand the reasons of this issue.

Signed-off-by:	Vasily Averin <vvs@sw.ru>

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 6e30629..46e2fa6 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -459,6 +459,21 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 
 static void ext3_destroy_inode(struct inode *inode)
 {
+	if (!list_empty(&(EXT3_I(inode)->i_orphan))) {
+		int i, imax;
+		unsigned int *p;
+
+		p = (unsigned int *)EXT3_I(inode);
+		imax = sizeof(struct ext3_inode_info) / sizeof(unsigned int);
+		printk("Inode %p: orphan list check failed!\n", EXT3_I(inode));
+		for (i = 0; i < imax; i++) {
+			if (i && ((i % 8) == 0))
+				printk("\n");
+			printk("%08x ", *p++);
+		}
+		printk("\n");
+		dump_stack();
+	}
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb9afdd..f86e0ac 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -510,6 +510,21 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 
 static void ext4_destroy_inode(struct inode *inode)
 {
+	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
+		int i, imax;
+		unsigned int *p;
+
+		p = (unsigned int *)EXT4_I(inode);
+		imax = sizeof(struct ext4_inode_info) / sizeof(unsigned int);
+		printk("Inode %p: orphan list check failed!\n", EXT4_I(inode));
+		for (i = 0; i < imax; i++) {
+			if (i && ((i % 8) == 0))
+				printk("\n");
+			printk("%08x ", *p++);
+		}
+		printk("\n");
+		dump_stack();
+	}
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
