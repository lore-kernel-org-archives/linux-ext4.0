From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] ext3: provide function to release metadata pages under memory pressure
Date: Sat,  3 Jan 2009 10:09:17 -0500
Message-ID: <1230995358-24013-3-git-send-email-tytso@mit.edu>
References: <20081226050138.GU28946@ZenIV.linux.org.uk>
 <1230995358-24013-1-git-send-email-tytso@mit.edu>
 <1230995358-24013-2-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37211 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbZACPJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Jan 2009 10:09:54 -0500
In-Reply-To: <1230995358-24013-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

Pages in the page cache belonging to ext3 data files are released via
the ext3_releasepage() function specified in the ext3 inode's
address_space_ops.  However, metadata blocks (such as indirect blocks,
directory blocks, etc) are managed via the block device
address_space_ops, and they can not be released by
try_to_free_buffers() if they have a journal head attached to them.

To address this, we supply a try_to_free_pages() function which calls
journal_try_to_free_buffers() function to free the metadata, and which
is called by the block device's blkdev_releasepage() function.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/ext3/super.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 541d5e4..93655a6 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -682,6 +682,25 @@ static struct dentry *ext3_fh_to_parent(struct super_block *sb, struct fid *fid,
 				    ext3_nfs_get_inode);
 }
 
+/*
+ * Try to release metadata pages (indirect blocks, directories) which are
+ * mapped via the block device.  Since these pages could have journal heads
+ * which would prevent try_to_free_buffers() from freeing them, we must use
+ * jbd layer's try_to_free_buffers() function to release them.
+ */
+static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
+				 gfp_t wait)
+{
+	journal_t *journal = EXT3_SB(sb)->s_journal;
+
+	WARN_ON(PageChecked(page));
+	if (!page_has_buffers(page))
+		return 0;
+	if (journal)
+		return journal_try_to_free_buffers(journal, page, wait);
+	return try_to_free_buffers(page);
+}
+
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t)==USRQUOTA?"user":"group")
 #define QTYPE2MOPT(on, t) ((t)==USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
@@ -746,6 +765,7 @@ static const struct super_operations ext3_sops = {
 	.quota_read	= ext3_quota_read,
 	.quota_write	= ext3_quota_write,
 #endif
+	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
 
 static const struct export_operations ext3_export_ops = {
-- 
1.6.0.4.8.g36f27.dirty

