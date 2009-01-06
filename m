From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] add releasepage hooks to block devices which can
	be used by file systems
Date: Mon, 5 Jan 2009 23:29:38 -0500
Message-ID: <20090106042938.GB21733@mit.edu>
References: <20081226050138.GU28946@ZenIV.linux.org.uk> <1230995358-24013-1-git-send-email-tytso@mit.edu> <1230995358-24013-2-git-send-email-tytso@mit.edu> <4961C1C8.2080300@jp.fujitsu.com> <20090105160514.GA8939@mit.edu> <4962D8FF.2000409@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4962D8FF.2000409@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 06, 2009 at 01:07:27PM +0900, Toshiyuki Okajima wrote:
> > Sounds like a deadlock caused by the fact that we're no longer masking
> > __GFP_WAIT, probably on journal->j_wait_done_commit.  Presumably the
> > system came under pressure during a commit operation, which makes
> > sense, and so we ended up with a deadlock between kjournald and
> > kswapd.  The fix is pretty simple; we just need to mask out the
> > __GFP_WAIT in the filesystem-specific callback, since this is a
> > restriction imposed by the filesystem's use of the jbd/jbd2 layer.
>
> Your opinion is correct.
> A detailed investigation is done, and the root cause has been understood.

Thanks for confirming my supposition.  I've checked the following
modified patches into the ext4 patch queue, which will be sent to
Linus shortly.

						- Ted

ext3: provide function to release metadata pages under memory pressure

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
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 541d5e4..6900ff0 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -682,6 +682,26 @@ static struct dentry *ext3_fh_to_parent(struct super_block *sb, struct fid *fid,
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
+		return journal_try_to_free_buffers(journal, page, 
+						   wait & ~__GFP_WAIT);
+	return try_to_free_buffers(page);
+}
+
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t)==USRQUOTA?"user":"group")
 #define QTYPE2MOPT(on, t) ((t)==USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
@@ -746,6 +766,7 @@ static const struct super_operations ext3_sops = {
 	.quota_read	= ext3_quota_read,
 	.quota_write	= ext3_quota_write,
 #endif
+	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
 
 static const struct export_operations ext3_export_ops = {

----------------------

ext4: provide function to release metadata pages under memory pressure

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

Pages in the page cache belonging to ext4 data files are released via
the ext4_releasepage() function specified in the ext4 inode's
address_space_ops.  However, metadata blocks (such as indirect blocks,
directory blocks, etc) are managed via the block device
address_space_ops, and they can not be released by
try_to_free_buffers() if they have a journal head attached to them.

To address this, we supply a release_metadata function which calls
jbd2_journal_try_to_free_buffers() function to free the metadata, and
which is called by the block device's blkdev_releasepage() function.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0023ca9..5cfac23 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -908,6 +908,25 @@ static struct dentry *ext4_fh_to_parent(struct super_block *sb, struct fid *fid,
 				    ext4_nfs_get_inode);
 }
 
+/*
+ * Try to release metadata pages (indirect blocks, directories) which are
+ * mapped via the block device.  Since these pages could have journal heads
+ * which would prevent try_to_free_buffers() from freeing them, we must use
+ * jbd2 layer's try_to_free_buffers() function to release them.
+ */
+static int bdev_try_to_free_page(struct super_block *sb, struct page *page, gfp_t wait)
+{
+	journal_t *journal = EXT4_SB(sb)->s_journal;
+
+	WARN_ON(PageChecked(page));
+	if (!page_has_buffers(page))
+		return 0;
+	if (journal)
+		return jbd2_journal_try_to_free_buffers(journal, page,
+							wait & ~__GFP_WAIT);
+	return try_to_free_buffers(page);
+}
+
 #ifdef CONFIG_QUOTA
 #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
 #define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
@@ -972,6 +991,7 @@ static const struct super_operations ext4_sops = {
 	.quota_read	= ext4_quota_read,
 	.quota_write	= ext4_quota_write,
 #endif
+	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
 
 static const struct export_operations ext4_export_ops = {
