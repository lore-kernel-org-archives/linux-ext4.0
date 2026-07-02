Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7873A9625
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016510; cv=none; b=hzPO36Pugvgn6V7Bz32oQfveBeT74rJ6lrwDDOFsfwg6RKRSRy4tmC5pVR70DqxMojLalThbAsDiLmGhCwZG2/LnViodIHajmPOWg8He4oLsNE7Dw4T/OHfCjSjgMmKVy22Xwbf12Vtul+z85q2kPBHvUNRW2914UAtTjADpktU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016510; c=relaxed/simple;
	bh=4jjyqjg9gqZDUEg686oAbvl4a0CZj6qwHDfV3eaTcFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVujWsvLxUjvDvZ4b3eIZ6z87F7f19q6mv7WusBx2h6xgQOSlSYoGnyppeJ3tlZQIcsd7C2gg25R2jIbg/ILZbx9vRCpajJx8+nPBy9hFlL3Vyr+hg6Ujsy4W9hKdxS/ij2T7qqvqp65Pp5fWOzk12hksuMLKy8gPQ5A4cQZYP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A5A274361;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7161A779AA;
	Thu,  2 Jul 2026 18:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h4qsGyGsRmoOGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 18:21:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4EA47A10B0; Thu, 02 Jul 2026 20:21:16 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	aivazian.tigran@gmail.com,
	Ted Tso <tytso@mit.edu>,
	<linux-ext4@vger.kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v3 14/19] minix: Fix data integrity writeout issues
Date: Thu,  2 Jul 2026 20:21:11 +0200
Message-ID: <20260702182057.2832980-33-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260702175436.12226-1-jack@suse.cz>
References: <20260702175436.12226-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5911; i=jack@suse.cz; h=from:subject; bh=4jjyqjg9gqZDUEg686oAbvl4a0CZj6qwHDfV3eaTcFo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqRqwUL1/lvRx8yFNmEMDsxlHE/cIIJcW8tppll 9zdr+MBzP+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCakasFAAKCRCcnaoHP2RA 2VcEB/wLf9VyYt5qfBJzeag3a/jnDgvdL1EDLOLS9106UJh7PoqSwwYGINtD+qoAfpbVsIREIXc n5ampuxBJqf4dol0hyUIhYa06EEYSmPOI82h+b6j2qaxSlIAGU/IxSE9os/V2UisoIcTH09eils 3I8ceBl4tIMcsXmuwvQKT9yGD8jYOfWPGEDATuR4CU+KBWSYPpXX2E+ITrRGLphcPJp7MZSdH9k AW+kG9kCKxydCM3YDJ9Qcuung54DWZdbt5XsIUB6T6+mRj15WcpD9WXh+xuCKQOUNpzs7JFU9// 4zqAXSIe5SzuDo+Hor019n/hWYmNoQb7p5JL9Y5Sd/nBs4VK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 9A5A274361
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]

Minix could fail to properly write out inode on fsync(2) due to races
with WB_SYNC_NONE writeback. Several racing fsyncs could also result in
some fsync returning earlier than all metadata buffers were properly
persisted. Furthermore DIRSYNC handling missed writing inode related
metadata.

Fix all these issues by using new .sync_inode_metadata method which
makes sure all inode related metadata is written to disk during any
WB_SYNC_ALL writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/dir.c   |  2 +-
 fs/minix/file.c  |  9 +--------
 fs/minix/inode.c | 50 ++++++++++++++++++++++++++++++++----------------
 3 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 361d26d87d2e..2ca16f849d5a 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -23,7 +23,7 @@ const struct file_operations minix_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= minix_readdir,
-	.fsync		= minix_fsync,
+	.fsync		= simple_fsync,
 };
 
 /*
diff --git a/fs/minix/file.c b/fs/minix/file.c
index 86e5943cd2ff..02aabbdb5dea 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -10,13 +10,6 @@
 #include <linux/buffer_head.h>
 #include "minix.h"
 
-int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync)
-{
-	return mmb_fsync(file,
-			&minix_i(file->f_mapping->host)->i_metadata_bhs,
-			start, end, datasync);
-}
-
 /*
  * We have mostly NULLs here: the current defaults are OK for
  * the minix filesystem.
@@ -26,7 +19,7 @@ const struct file_operations minix_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= minix_fsync,
+	.fsync		= simple_fsync,
 	.splice_read	= filemap_splice_read,
 };
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index c30cc590698d..95267d93ef39 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -24,6 +24,8 @@
 
 static int minix_write_inode(struct inode *inode,
 		struct writeback_control *wbc);
+static int minix_sync_inode_metadata(struct inode *inode,
+				     struct writeback_control *wbc);
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf);
 
 void __minix_error_inode(struct inode *inode, const char *function,
@@ -128,6 +130,7 @@ static const struct super_operations minix_sops = {
 	.alloc_inode	= minix_alloc_inode,
 	.free_inode	= minix_free_in_core_inode,
 	.write_inode	= minix_write_inode,
+	.sync_inode_metadata = minix_sync_inode_metadata,
 	.evict_inode	= minix_evict_inode,
 	.put_super	= minix_put_super,
 	.statfs		= minix_statfs,
@@ -630,7 +633,7 @@ struct inode *minix_iget(struct super_block *sb, unsigned long ino)
 /*
  * The minix V1 function to synchronize an inode.
  */
-static struct buffer_head * V1_minix_update_inode(struct inode * inode)
+static int V1_minix_update_inode(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix_inode * raw_inode;
@@ -639,7 +642,7 @@ static struct buffer_head * V1_minix_update_inode(struct inode * inode)
 
 	raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	if (!raw_inode)
-		return NULL;
+		return -EIO;
 	raw_inode->i_mode = inode->i_mode;
 	raw_inode->i_uid = fs_high2lowuid(i_uid_read(inode));
 	raw_inode->i_gid = fs_high2lowgid(i_gid_read(inode));
@@ -651,13 +654,15 @@ static struct buffer_head * V1_minix_update_inode(struct inode * inode)
 	else for (i = 0; i < 9; i++)
 		raw_inode->i_zone[i] = minix_inode->u.i1_data[i];
 	mark_buffer_dirty(bh);
-	return bh;
+	brelse(bh);
+	set_inode_metadata_writeback(inode);
+	return 0;
 }
 
 /*
  * The minix V2 function to synchronize an inode.
  */
-static struct buffer_head * V2_minix_update_inode(struct inode * inode)
+static int V2_minix_update_inode(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix2_inode * raw_inode;
@@ -666,7 +671,7 @@ static struct buffer_head * V2_minix_update_inode(struct inode * inode)
 
 	raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	if (!raw_inode)
-		return NULL;
+		return -EIO;
 	raw_inode->i_mode = inode->i_mode;
 	raw_inode->i_uid = fs_high2lowuid(i_uid_read(inode));
 	raw_inode->i_gid = fs_high2lowgid(i_gid_read(inode));
@@ -680,29 +685,40 @@ static struct buffer_head * V2_minix_update_inode(struct inode * inode)
 	else for (i = 0; i < 10; i++)
 		raw_inode->i_zone[i] = minix_inode->u.i2_data[i];
 	mark_buffer_dirty(bh);
-	return bh;
+	brelse(bh);
+	set_inode_metadata_writeback(inode);
+	return 0;
 }
 
 static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	if (INODE_VERSION(inode) == MINIX_V1)
+		return V1_minix_update_inode(inode);
+	return V2_minix_update_inode(inode);
+}
+
+static int minix_sync_inode_metadata(struct inode *inode,
+				     struct writeback_control *wbc)
 {
 	int err = 0;
 	struct buffer_head *bh;
+	void *raw_inode;
 
 	if (INODE_VERSION(inode) == MINIX_V1)
-		bh = V1_minix_update_inode(inode);
+		raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	else
-		bh = V2_minix_update_inode(inode);
-	if (!bh)
+		raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
+	if (!raw_inode)
 		return -EIO;
-	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk("IO error syncing minix inode [%s:%08llx]\n",
-				inode->i_sb->s_id, inode->i_ino);
-			err = -EIO;
-		}
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		printk("IO error syncing minix inode [%s:%08llx]\n",
+			inode->i_sb->s_id, inode->i_ino);
+		err = -EIO;
 	}
-	brelse (bh);
+	err = mmb_sync(&minix_i(inode)->i_metadata_bhs);
+out:
+	brelse(bh);
 	return err;
 }
 
-- 
2.51.0

