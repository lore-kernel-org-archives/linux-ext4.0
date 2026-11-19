Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115863;
	b=QVFL6cG+w2nFGOhpZNf+rFz7Ziz2oRPYa1BbSrTJQBGm0Ak/9ygI++2GeNZ16wZ6NI+5
	 PbkBvHoDuAc9ji6A+noWQW6oABBZw+NNQaV7cUNDy/nbQn3sugogbZ8ZyX9ytga9gLZN/
	 bAGwuqJwrRfj0uY9VzP437qJmayII+UxS4SGwIMEEqcVcmgoZgKnBceLiwRa2HBWhEraZ
	 3WnewKKie3xfvTD5LucAyJG+erfF8GuavouBYTftu8LOj/TZebG4vIDeiLQoM6cRzT11H
	 ovpzF0gvVx4QPDO+/SIZsw8VCbe3rTp5wyCTBH+fe3Ef3NKKd97dr0k+/8w6kAFL82A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115863;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=X0Wu9FKYYJo2u044+VhXSMGUQItygBYZoeRhkgWHVho=;
	b=5DafEk9PZ5rQ8sleLG0tc6Vb3iww8QifgHJ2ekxZbojO2yQnrjP1ChDSKfRZjmmpiHth
	 IMR1S84hHMJ51kFwK44jM6miRfMyOKrg6RvJE/QLGDKOmSYxKlm/hBCS3zHQW7T5k4lKy
	 doETzXKsPKJQi0TbcwkHLKIUxotDWSzvbFh0JfZnWFT1xewa4WEgn/AlirWyNVAO/y5GW
	 VFokKyI1qZxv5TEXzPSiBF202jjN1lCreRycbfmWu61LaW3gzfhq2l/yGy5/6VK0SbBuN
	 Ru+iVy1ELaWdSNe+cRO38uIVe4xM94QOrQpvUMw4WUed44xm5kLaz1YUJIjBydRaCVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=haqqE8cj;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B214606A33F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B214606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=haqqE8cj
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYCt029960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=X0Wu9FKYYJo2u044+VhXSMGUQItygBYZoeRhkgWHVho=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=haqqE8cjmGTzWDPl0d1/MP7bf2cMwozm3wkSna2s1gaphIRw7sIQGGv4hrpcEZFL+
	 I/UFqdE3r1LC6kGXBD3STpYtLBtQhHKJxw7CjSYyVD7J7hMgK2W+5HuRn0BqHzPJ99
	 fi+rUYUH2rJn62p8tjQxLm/p3j8CnHcZT60SGn7arMlHnfhfqM6IvInK4Z0lftEJ5E
	 BzSEomw1Ey6TiNTxse/cZAqTk2+QY6AFGT9FHe9EUZ1VpTax/mN6LMYd9SLyI/oP3w
	 rlad9zy+R7wHUkrqPy8EQkCjX/dTbPyVcbXA5lm2c19h6U5Yv22SnPBv4v9P/AgjD3
	 5/p3+rplIBetQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5AAD32E015C; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 23/32] ext4: initialize inline dir block under buffer lock before raising i_size
Date: Thu, 19 Nov 2026 14:17:10 -0500
Message-ID: <20261119191719.1943298-24-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119191719.1943298-1-tytso@mit.edu>
References: <20261119191719.1943298-1-tytso@mit.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When ext4_convert_inline_data_nolock() converts an inline directory to a
normal directory block, it unlocked data_bh and raised inode->i_size
(with both a redundant bare store and i_size_write()) BEFORE calling
ext4_init_dirblock() to populate ".", "..", copied entries, checksum,
and buffer uptodate/verified flags.  Furthermore, ext4_init_dirblock()
set buffer_uptodate and buffer_verified before calling
ext4_dirblock_csum_set().

This opened a race window where concurrent lookups or readers could
observe an unlocked, uninitialized, or unchecksummed directory block
after i_size was already increased, and also left i_size/i_disksize
bumped if ext4_handle_dirty_metadata() failed and fell back to
ext4_restore_inline_data().

Factor out ext4_init_dirblock_bh() which writes the directory entries,
initializes the dirent tail, computes the metadata checksum, and only
then marks the buffer uptodate and verified.  Call it while holding
lock_buffer(data_bh), unlock data_bh before calling
ext4_handle_dirty_metadata() (avoiding any lock_buffer() recursion in
no-journal sync_dirty_buffer() paths), and only update i_size/i_disksize
(rolling them back if ext4_mark_inode_dirty() fails) after the block is
fully initialized and dirtied.

Extend test_inline_dir_conversion_and_corruptions() in ext4_inline_test
to verify the buffer flags, valid metadata checksum, deferred i_size
update, and rollback on dirty-metadata failure.

Fixes: 90f097b1403f ("ext4: refactor the inline directory conversion and new directory codepaths")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h        |  3 ++
 fs/ext4/inline-test.c | 73 ++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/inline.c      | 19 +++++++----
 fs/ext4/namei.c       | 18 ++++++++---
 4 files changed, 94 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index eb0ba9edfc99..22500ade662b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4132,6 +4132,9 @@ static inline int ext4_has_inline_data(struct inode *inode)
 extern const struct inode_operations ext4_dir_inode_operations;
 extern const struct inode_operations ext4_special_inode_operations;
 extern struct dentry *ext4_get_parent(struct dentry *child);
+extern void ext4_init_dirblock_bh(struct inode *inode, struct buffer_head *bh,
+				  unsigned int parent_ino, void *inline_buf,
+				  int inline_size);
 extern int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			      struct buffer_head *dir_block,
 			      unsigned int parent_ino, void *inline_buf,
diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
index 2c57e1a79754..d8f3c40198a3 100644
--- a/fs/ext4/inline-test.c
+++ b/fs/ext4/inline-test.c
@@ -63,6 +63,12 @@ struct inline_test_ctx {
 	int da_get_block_prep_err;
 	int journal_mode;
 	bool es_stats_inited;
+	bool dirty_data_bh_seen;
+	bool dirty_data_bh_locked;
+	bool dirty_data_bh_uptodate;
+	bool dirty_data_bh_verified;
+	int dirty_data_bh_csum_ok;
+	loff_t dirty_data_bh_isize;
 };
 
 static struct inline_test_ctx *t_ctx;
@@ -110,6 +116,15 @@ static int stub_handle_dirty_metadata(const char *where, unsigned int line,
 				      handle_t *handle, struct inode *inode,
 				      struct buffer_head *bh)
 {
+	if (bh == &t_ctx->data_bh && inode && S_ISDIR(inode->i_mode)) {
+		t_ctx->dirty_data_bh_seen = true;
+		t_ctx->dirty_data_bh_locked = buffer_locked(bh);
+		t_ctx->dirty_data_bh_uptodate = buffer_uptodate(bh);
+		t_ctx->dirty_data_bh_verified = buffer_verified(bh);
+		t_ctx->dirty_data_bh_csum_ok =
+			ext4_dirblock_csum_verify(inode, bh);
+		t_ctx->dirty_data_bh_isize = i_size_read(inode);
+	}
 	t_ctx->dirty_metadata_calls++;
 	if (t_ctx->dirty_metadata_fail_on_call > 0 &&
 	    t_ctx->dirty_metadata_calls == t_ctx->dirty_metadata_fail_on_call)
@@ -1858,15 +1873,57 @@ static void test_inline_dir_conversion_and_corruptions(struct kunit *test)
 	 * 2. Successful conversion of full inline directory to a normal
 	 * 1024-byte directory block -> ext4_try_add_inline_entry returns 0
 	 * and data_block_buf starts with "." and ".." followed by copied entries.
+	 * Verify checksum, uptodate, and verified flags are already set while
+	 * data_bh is unlocked and before i_size is raised to blocksize, and
+	 * that a dirty-metadata error does not leave i_size bumped.
 	 */
-	memset(ctx->data_block_buf, 0, sizeof(ctx->data_block_buf));
-	handle = ext4_journal_start(dir, EXT4_HT_DIR, 1);
-	KUNIT_ASSERT_FALSE(test, IS_ERR(handle));
-	ret = ext4_try_add_inline_entry(handle, &env->fname, dir, &env->child);
-	ext4_journal_stop(handle);
-	KUNIT_EXPECT_EQ(test, ret, 0);
-	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(dir));
-	KUNIT_EXPECT_EQ(test, i_size_read(dir), (loff_t)TEST_BLOCK_SIZE);
+	{
+		loff_t old_isize = i_size_read(dir);
+
+		ctx->es.s_feature_ro_compat |=
+			cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+
+		clear_buffer_uptodate(&ctx->data_bh);
+		clear_buffer_verified(&ctx->data_bh);
+		ctx->dirty_data_bh_seen = false;
+		ctx->dirty_metadata_err = -EIO;
+		ctx->dirty_metadata_fail_on_call = 0;
+		handle = ext4_journal_start(dir, EXT4_HT_DIR, 1);
+		KUNIT_ASSERT_FALSE(test, IS_ERR(handle));
+		ret = ext4_try_add_inline_entry(handle, &env->fname, dir,
+						&env->child);
+		ext4_journal_stop(handle);
+		ctx->dirty_metadata_err = 0;
+		KUNIT_EXPECT_EQ(test, ret, -EIO);
+		KUNIT_EXPECT_TRUE(test, ext4_has_inline_data(dir));
+		KUNIT_EXPECT_EQ(test, i_size_read(dir), old_isize);
+		KUNIT_EXPECT_EQ(test, ctx->ei.i_disksize, old_isize);
+
+		memset(ctx->data_block_buf, 0, sizeof(ctx->data_block_buf));
+		clear_buffer_uptodate(&ctx->data_bh);
+		clear_buffer_verified(&ctx->data_bh);
+		ctx->dirty_data_bh_seen = false;
+		handle = ext4_journal_start(dir, EXT4_HT_DIR, 1);
+		KUNIT_ASSERT_FALSE(test, IS_ERR(handle));
+		ret = ext4_try_add_inline_entry(handle, &env->fname, dir,
+						&env->child);
+		ext4_journal_stop(handle);
+		KUNIT_EXPECT_EQ(test, ret, 0);
+		KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(dir));
+		KUNIT_EXPECT_TRUE(test, ctx->dirty_data_bh_seen);
+		KUNIT_EXPECT_FALSE(test, ctx->dirty_data_bh_locked);
+		KUNIT_EXPECT_TRUE(test, ctx->dirty_data_bh_uptodate);
+		KUNIT_EXPECT_TRUE(test, ctx->dirty_data_bh_verified);
+		KUNIT_EXPECT_EQ(test, ctx->dirty_data_bh_csum_ok, 1);
+		KUNIT_EXPECT_EQ(test, ctx->dirty_data_bh_isize, old_isize);
+		KUNIT_EXPECT_EQ(test, i_size_read(dir),
+				(loff_t)TEST_BLOCK_SIZE);
+		KUNIT_EXPECT_EQ(test, ctx->ei.i_disksize,
+				(loff_t)TEST_BLOCK_SIZE);
+
+		ctx->es.s_feature_ro_compat &=
+			~cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+	}
 
 	/* Verify "." and ".." headers in converted block */
 	de = (struct ext4_dir_entry_2 *)ctx->data_block_buf;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 3e77f46f7774..00411808ed01 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1191,17 +1191,24 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 		error = ext4_handle_dirty_metadata(handle,
 						   inode, data_bh);
 	} else {
-		unlock_buffer(data_bh);
-		inode->i_size = inode->i_sb->s_blocksize;
-		i_size_write(inode, inode->i_sb->s_blocksize);
-		EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
+		loff_t old_size = i_size_read(inode);
+		loff_t old_disksize = EXT4_I(inode)->i_disksize;
 
-		error = ext4_init_dirblock(handle, inode, data_bh,
+		ext4_init_dirblock_bh(inode, data_bh,
 			  le32_to_cpu(((struct ext4_dir_entry_2 *)buf)->inode),
 			  buf + EXT4_INLINE_DOTDOT_SIZE,
 			  inline_size - EXT4_INLINE_DOTDOT_SIZE);
-		if (!error)
+		unlock_buffer(data_bh);
+		error = ext4_handle_dirty_metadata(handle, inode, data_bh);
+		if (!error) {
+			i_size_write(inode, inode->i_sb->s_blocksize);
+			EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
 			error = ext4_mark_inode_dirty(handle, inode);
+			if (error) {
+				i_size_write(inode, old_size);
+				EXT4_I(inode)->i_disksize = old_disksize;
+			}
+		}
 	}
 
 out_restore:
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f1d4a99af1a8..863a30d50535 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2779,9 +2779,9 @@ static int ext4_tmpfile(const struct mnt_idmap *idmap, struct inode *dir,
 	return err;
 }
 
-int ext4_init_dirblock(handle_t *handle, struct inode *inode,
-		       struct buffer_head *bh, unsigned int parent_ino,
-		       void *inline_buf, int inline_size)
+void ext4_init_dirblock_bh(struct inode *inode, struct buffer_head *bh,
+			   unsigned int parent_ino, void *inline_buf,
+			   int inline_size)
 {
 	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) bh->b_data;
 	size_t			blocksize = bh->b_size;
@@ -2819,10 +2819,18 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 
 	if (csum_size)
 		ext4_initialize_dirent_tail(bh, blocksize);
-	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
+	ext4_dirblock_csum_set(inode, bh);
 	set_buffer_uptodate(bh);
 	set_buffer_verified(bh);
-	return ext4_handle_dirty_dirblock(handle, inode, bh);
+}
+
+int ext4_init_dirblock(handle_t *handle, struct inode *inode,
+		       struct buffer_head *bh, unsigned int parent_ino,
+		       void *inline_buf, int inline_size)
+{
+	ext4_init_dirblock_bh(inode, bh, parent_ino, inline_buf, inline_size);
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	return ext4_handle_dirty_metadata(handle, inode, bh);
 }
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_init_dirblock);
 
-- 
2.56.1.708.g77570a6a1d-goog

