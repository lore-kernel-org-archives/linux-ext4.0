Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115863;
	b=t7vVOhcU4owXh0aQsBpAiojn6+VhHmEJCDQs8To6f2XeTUzDa3brtB5vk7E1IE04i1EV
	 kTNnDw2WZwUvhLcToCdya3xXJAmp6U1EEwf+FmlGUeGcUFmWQr4zI6GdYd/481pSktCbw
	 9s156DgEKdV4jT6yjiglTUEZ4x+la447Tf+tg6ht0bTsd4xbWCBgpytOkuPRsTDUjPSuu
	 su3Ri+V6Njrji8k0p/EOD3STEUFD6Z3pwN/MXkhj07B5zxzfavhRcEMcOBPpZ6STIHqVH
	 OlYgdMw5/qhBnWBj25uOdD9w7aFQfKoaERdqrbnVuXolvt9M55ZfAR4WqEJgcLE5Z5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115863;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SEt0oz4n3wuDlQVCyDaGRUIUq1buoXI0UULWJ8A8bTU=;
	b=mTXgMAlxo3qk6WOZqCVznLTvM8YyHQlnWIHWKj/2Qo17cyZCz1m07uPfCuxzxRcHrmEu
	 d3jzpuEYO0lqCBT/a+cPVG9zE2qCnSsUhw8kJeJZDaQmrS7UtVJQCso3wz8xSX5LpP3DJ
	 VH3l0OKFalvurPphyXn8I6l9NzlAlWz9HUPUW154Pc1flWRIUXQAkW2HqVNU6x3Dee7A5
	 mfrMYQJGGbq3/+VB30Oj8jmn7j4Q1MMzJcCni35pFeow3W4fSL/JmPCfNaY58Ng4FcqFY
	 XVmKcxnPjTXP8sRdrXcJQIeHeUL+zCWrOvDxOJD7M23wgFEhFv/mmMJkDEPP028Dfwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=YzxyLxCB;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686A9606A33D
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 686A9606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=YzxyLxCB
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYxq029950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=SEt0oz4n3wuDlQVCyDaGRUIUq1buoXI0UULWJ8A8bTU=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=YzxyLxCBjYSp5F01YcRQe66rLSn4d0hrNZ4/+a6uvJ21cqaY2Zbm1A0WlMfG2yFcR
	 bevCOTWK3h9Mnfd5rpeAkTe7cwUPjDJs6d39zx/SQm0wLKKEsLd8DFO57FIMJjditb
	 K2q6lW+1IsrIVIrOwvQBCyYaMr/DurTb+GD/YLMhG7oPqfSRFF3UayY2X7LENBAAi8
	 fwxAZQorr1K/JORtsp9gGHfCpsdKK3fbQwkD/MQxD4i9wiRD6vL95JrvGViJ1rQjj6
	 J7WcOkjrOQbv5401vvZaIyf0hZjPpypwgSzXqOiPM1ECjX+6xorkEEpco0rT8ab++0
	 iOX4X1f7pB/3A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 53E3D2E015A; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 21/32] ext4: don't read dirent hashes from fake directory entries
Date: Thu, 19 Nov 2026 14:17:08 -0500
Message-ID: <20261119191719.1943298-22-tytso@mit.edu>
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

__ext4_check_dir_entry() exempts fake directory entries ('.', '..', and
EXT4_FT_DIR_CSUM checksum tails) from the 8-byte ext4_dir_entry_hash
trailer required by casefolded encrypted directories.  However, every
reader of EXT4_DIRENT_HASH() / EXT4_DIRENT_MINOR_HASH() failed to check
whether the entry is a fake entry before reading the stored hash:

 - On a crafted filesystem without metadata_csum, a 12-byte '..' or an
   EXT4_FT_DIR_CSUM entry with a nonzero inode placed at the exact end
   of a directory block causes ext4_readdir(), htree_dirblock_to_tree(),
   dx_make_map(), and ext4_match() (via ext4_find_dest_de()) to read up
   to 8 bytes past the end of the directory block buffer.  On a keyless
   encrypted directory, those over-read bytes can leak into the no-key
   filename presented to userspace.
 - Even on a valid casefolded encrypted directory, dx_make_map() reads
   the header of the adjacent entry as the hash for '.' and '..'.
 - ext4_inlinedir_to_tree() reads uninitialized stack bytes from the
   synthetic '.' and '..' entries and reads past dir_buf for trailing
   fake or empty entries.
 - __ext4_check_dir_entry() did not reject EXT4_FT_DIR_CSUM entries with
   a nonzero inode or name_len, even though a real directory checksum
   tail always has both fields set to zero.

Promote ext4_is_fake_dir_entry() (tightened so it only inspects bytes
within name_len) and add ext4_dirent_has_hash() to fs/ext4/ext4.h.
Reject EXT4_FT_DIR_CSUM entries with a nonzero inode or name_len in
__ext4_check_dir_entry(), and skip EXT4_DIRENT_HASH() /
EXT4_DIRENT_MINOR_HASH() on fake entries across dir.c, namei.c, and
inline.c (using 0 where a hash value is needed rather than falling back
to ext4fs_dirhash(), which fails with -EINVAL for DX_HASH_SIPHASH
without a key).

Add KUnit regression tests in dir-test.c, namei-test.c, and
inline-test.c covering crafted EXT4_FT_DIR_CSUM entries and exact-end
fake entries on casefolded encrypted directories.

Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/dir-test.c    | 157 ++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/dir.c         |  19 ++---
 fs/ext4/ext4.h        |  18 +++++
 fs/ext4/inline-test.c |  14 ++++
 fs/ext4/inline.c      |  10 ++-
 fs/ext4/namei-test.c  | 129 ++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c       |  19 +++--
 7 files changed, 343 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/dir-test.c b/fs/ext4/dir-test.c
index 7ec661919760..8698016456d5 100644
--- a/fs/ext4/dir-test.c
+++ b/fs/ext4/dir-test.c
@@ -87,6 +87,21 @@ enum dir_htree_stub_mode {
 static const struct super_operations dir_test_sops = {
 };
 
+#ifdef CONFIG_FS_ENCRYPTION
+static int dir_test_get_context(struct inode *inode, void *ctx, size_t len)
+{
+	return -ERANGE;
+}
+
+static const struct fscrypt_operations dir_test_cryptops = {
+	.inode_info_offs	= (int)offsetof(struct ext4_inode_info,
+						i_crypt_info) -
+				  (int)offsetof(struct ext4_inode_info,
+						vfs_inode),
+	.get_context		= dir_test_get_context,
+};
+#endif
+
 static void init_mock_dir_file(struct dir_test_ctx *ctx, fmode_t extra_mode)
 {
 	struct inode *dir = &ctx->dir_ei.vfs_inode;
@@ -971,6 +986,147 @@ static void test_dx_readdir(struct kunit *test)
 	ctx->filp.private_data = NULL;
 }
 
+/*
+ * Test 7: Verify fake directory entries ('.', '..', EXT4_FT_DIR_CSUM) never
+ * trigger out-of-bounds EXT4_DIRENT_HASH() reads in encrypted+casefolded dirs,
+ * and crafted EXT4_FT_DIR_CSUM entries with nonzero inode/name_len are rejected.
+ */
+static void test_fake_dirent_hash_bounds(struct kunit *test)
+{
+	struct dir_test_ctx *ctx = test->priv;
+	struct inode *dir = &ctx->dir_ei.vfs_inode;
+	struct buffer_head *bh;
+	struct ext4_dir_entry_2 *de;
+	char *exact_buf, *saved_data;
+
+	exact_buf = kunit_kzalloc(test, DIR_TEST_BLK_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, exact_buf);
+
+	bh = alloc_dir_lblk(ctx, 0);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	saved_data = bh->b_data;
+	bh->b_data = exact_buf;
+
+	ext4_clear_feature_metadata_csum(&ctx->sb);
+	ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
+	dir->i_flags |= S_CASEFOLD | S_ENCRYPTED;
+	i_size_write(dir, DIR_TEST_BLK_SIZE);
+	dir->i_blocks = DIR_TEST_BLK_SIZE >> 9;
+
+	/* Helper checks */
+	write_de(exact_buf, 0, DIR_TEST_DIR_INO, 12, EXT4_FT_DIR, ".");
+	de = (struct ext4_dir_entry_2 *)exact_buf;
+	KUNIT_EXPECT_TRUE(test, ext4_is_fake_dir_entry(de));
+	KUNIT_EXPECT_FALSE(test, ext4_dirent_has_hash(dir, de));
+
+	write_de(exact_buf, 12, DIR_TEST_ROOT_INO, 12, EXT4_FT_DIR, "..");
+	de = (struct ext4_dir_entry_2 *)(exact_buf + 12);
+	KUNIT_EXPECT_TRUE(test, ext4_is_fake_dir_entry(de));
+	KUNIT_EXPECT_FALSE(test, ext4_dirent_has_hash(dir, de));
+
+	write_de(exact_buf, 24, 15, 24, EXT4_FT_REG_FILE, "file");
+	de = (struct ext4_dir_entry_2 *)(exact_buf + 24);
+	KUNIT_EXPECT_FALSE(test, ext4_is_fake_dir_entry(de));
+	KUNIT_EXPECT_TRUE(test, ext4_dirent_has_hash(dir, de));
+
+	/*
+	 * 1. Crafted EXT4_FT_DIR_CSUM at exact block end (DIR_TEST_BLK_SIZE - 20)
+	 * with nonzero inode and name_len=12 must be rejected.
+	 */
+	memset(exact_buf, 0, DIR_TEST_BLK_SIZE);
+	write_de(exact_buf, 0, DIR_TEST_DIR_INO, DIR_TEST_BLK_SIZE - 20,
+		 EXT4_FT_DIR, ".");
+	write_de(exact_buf, DIR_TEST_BLK_SIZE - 20, 15, 20,
+		 EXT4_FT_DIR_CSUM, "crafted_csum");
+	de = (struct ext4_dir_entry_2 *)(exact_buf + DIR_TEST_BLK_SIZE - 20);
+	KUNIT_EXPECT_TRUE(test, ext4_is_fake_dir_entry(de));
+	KUNIT_EXPECT_FALSE(test, ext4_dirent_has_hash(dir, de));
+	KUNIT_EXPECT_EQ(test, __ext4_check_dir_entry(__func__, __LINE__, dir,
+						     NULL, de, bh, exact_buf,
+						     DIR_TEST_BLK_SIZE,
+						     DIR_TEST_BLK_SIZE - 20),
+			1);
+
+	/* Nonzero inode alone or nonzero name_len alone on CSUM entry rejected */
+	de->name_len = 0;
+	KUNIT_EXPECT_EQ(test, __ext4_check_dir_entry(__func__, __LINE__, dir,
+						     NULL, de, bh, exact_buf,
+						     DIR_TEST_BLK_SIZE,
+						     DIR_TEST_BLK_SIZE - 20),
+			1);
+	de->inode = 0;
+	de->name_len = 1;
+	KUNIT_EXPECT_EQ(test, __ext4_check_dir_entry(__func__, __LINE__, dir,
+						     NULL, de, bh, exact_buf,
+						     DIR_TEST_BLK_SIZE,
+						     DIR_TEST_BLK_SIZE - 20),
+			1);
+	/* Legitimate CSUM tail (inode == 0, name_len == 0) is accepted */
+	de->name_len = 0;
+	KUNIT_EXPECT_EQ(test, __ext4_check_dir_entry(__func__, __LINE__, dir,
+						     NULL, de, bh, exact_buf,
+						     DIR_TEST_BLK_SIZE,
+						     DIR_TEST_BLK_SIZE - 20),
+			0);
+
+#ifdef CONFIG_FS_ENCRYPTION
+	{
+		int err;
+
+		ctx->sb.s_cop = &dir_test_cryptops;
+		KUNIT_ASSERT_EQ(test, ext4_dir_operations.open(dir, &ctx->filp),
+				0);
+
+		/*
+		 * 2a. ext4_readdir() skips crafted CSUM entry at block end
+		 * without an out-of-bounds EXT4_DIRENT_HASH() read.
+		 */
+		write_de(exact_buf, DIR_TEST_BLK_SIZE - 20, 15, 20,
+			 EXT4_FT_DIR_CSUM, "crafted_csum");
+		reset_capture(&ctx->cap, 0, 0);
+		inode_lock_shared(dir);
+		err = ext4_dir_operations.iterate_shared(&ctx->filp,
+							 &ctx->cap.ctx);
+		inode_unlock_shared(dir);
+		KUNIT_ASSERT_EQ(test, err, 0);
+		KUNIT_ASSERT_EQ(test, ctx->cap.count, 1);
+		KUNIT_EXPECT_STREQ(test, ctx->cap.recs[0].name, ".");
+
+		/*
+		 * 2b. 12-byte '..' at the exact end of the allocation must not
+		 * trigger an 8-byte OOB read past exact_buf in ext4_readdir().
+		 */
+		ext4_set_feature_metadata_csum(&ctx->sb);
+		set_buffer_verified(bh);
+		memset(exact_buf, 0, DIR_TEST_BLK_SIZE);
+		write_de(exact_buf, 0, DIR_TEST_DIR_INO, DIR_TEST_BLK_SIZE - 12,
+			 EXT4_FT_DIR, ".");
+		write_de(exact_buf, DIR_TEST_BLK_SIZE - 12, DIR_TEST_ROOT_INO,
+			 12, EXT4_FT_DIR, "..");
+
+		reset_capture(&ctx->cap, 0, 0);
+		inode_lock_shared(dir);
+		err = ext4_dir_operations.iterate_shared(&ctx->filp,
+							 &ctx->cap.ctx);
+		inode_unlock_shared(dir);
+		KUNIT_ASSERT_EQ(test, err, 0);
+		KUNIT_ASSERT_EQ(test, ctx->cap.count, 2);
+		KUNIT_EXPECT_STREQ(test, ctx->cap.recs[0].name, ".");
+		KUNIT_EXPECT_STREQ(test, ctx->cap.recs[1].name, "..");
+
+		KUNIT_EXPECT_EQ(test,
+				ext4_dir_operations.release(dir, &ctx->filp),
+				0);
+		ctx->filp.private_data = NULL;
+		ctx->sb.s_cop = NULL;
+	}
+#endif
+
+	dir->i_flags &= ~(S_CASEFOLD | S_ENCRYPTED);
+	ext4_set_feature_metadata_csum(&ctx->sb);
+	bh->b_data = saved_data;
+}
+
 static struct kunit_case ext4_dir_test_cases[] = {
 	KUNIT_CASE(test_check_dir_entry_and_all_de),
 	KUNIT_CASE(test_dx_detection_and_hash_pos_cookies),
@@ -978,6 +1134,7 @@ static struct kunit_case ext4_dir_test_cases[] = {
 	KUNIT_CASE(test_htree_store_dirent_and_free),
 	KUNIT_CASE(test_linear_readdir),
 	KUNIT_CASE(test_dx_readdir),
+	KUNIT_CASE(test_fake_dirent_hash_bounds),
 	{}
 };
 
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 43f4f2d451aa..288166892bea 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -56,18 +56,6 @@ static int is_dx_dir(struct inode *inode)
 	return 0;
 }
 
-static bool is_fake_dir_entry(struct ext4_dir_entry_2 *de)
-{
-	/* Check if . or .. , or skip if namelen is 0 */
-	if ((de->name_len > 0) && (de->name_len <= 2) && (de->name[0] == '.') &&
-	    (de->name[1] == '.' || de->name[1] == '\0'))
-		return true;
-	/* Check if this is a csum entry */
-	if (de->file_type == EXT4_FT_DIR_CSUM)
-		return true;
-	return false;
-}
-
 /*
  * Return 0 if the directory entry is OK, and 1 if there is a problem
  *
@@ -86,7 +74,7 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	const int rlen = ext4_rec_len_from_disk(de->rec_len,
 						dir->i_sb->s_blocksize);
 	const int next_offset = ((char *) de - buf) + rlen;
-	bool fake = is_fake_dir_entry(de);
+	bool fake = ext4_is_fake_dir_entry(de);
 	bool has_csum = ext4_has_feature_metadata_csum(dir->i_sb);
 
 	if (unlikely(rlen < ext4_dir_rec_len(1, fake ? NULL : dir)))
@@ -108,6 +96,9 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	else if (unlikely(next_offset == size && de->name_len == 1 &&
 			  de->name[0] == '.'))
 		error_msg = "'.' directory cannot be the last in data block";
+	else if (unlikely(de->file_type == EXT4_FT_DIR_CSUM &&
+			  (de->inode || de->name_len)))
+		error_msg = "invalid directory checksum entry";
 	else
 		return 0;
 
@@ -303,7 +294,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 					u32 hash;
 					u32 minor_hash;
 
-					if (IS_CASEFOLDED(inode)) {
+					if (ext4_dirent_has_hash(inode, de)) {
 						hash = EXT4_DIRENT_HASH(de);
 						minor_hash = EXT4_DIRENT_MINOR_HASH(de);
 					} else {
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 788cf8a126b5..eb0ba9edfc99 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2634,6 +2634,24 @@ static inline unsigned int ext4_dir_rec_len(__u8 name_len,
 	return (rec_len & ~EXT4_DIR_ROUND);
 }
 
+static inline bool ext4_is_fake_dir_entry(const struct ext4_dir_entry_2 *de)
+{
+	/* Check if . or .. , or skip if namelen is 0 */
+	if ((de->name_len == 1 && de->name[0] == '.') ||
+	    (de->name_len == 2 && de->name[0] == '.' && de->name[1] == '.'))
+		return true;
+	/* Check if this is a csum entry */
+	if (de->file_type == EXT4_FT_DIR_CSUM)
+		return true;
+	return false;
+}
+
+static inline bool ext4_dirent_has_hash(const struct inode *dir,
+					const struct ext4_dir_entry_2 *de)
+{
+	return ext4_hash_in_dirent(dir) && !ext4_is_fake_dir_entry(de);
+}
+
 static inline unsigned int
 ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
 {
diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
index 0198ce8311c7..451ebc61cbf6 100644
--- a/fs/ext4/inline-test.c
+++ b/fs/ext4/inline-test.c
@@ -1672,6 +1672,20 @@ static void test_inline_dir_lifecycle_and_operations(struct kunit *test)
 					     &has_inline_data);
 		KUNIT_EXPECT_GE(test, ret, 0);
 		ext4_htree_free_dir_info(info);
+
+		/*
+		 * Casefolded + encrypted inline directory must not read
+		 * uninitialized/OOB EXT4_DIRENT_HASH() bytes on '.' / '..'.
+		 */
+		dir->i_flags |= S_CASEFOLD | S_ENCRYPTED;
+		info = kzalloc_obj(*info, GFP_KERNEL);
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, info);
+		env->filp.private_data = info;
+		ret = ext4_inlinedir_to_tree(&env->filp, dir, 0, &hinfo,
+					     0, 0, &has_inline_data);
+		KUNIT_EXPECT_GE(test, ret, 2);
+		ext4_htree_free_dir_info(info);
+		dir->i_flags &= ~(S_CASEFOLD | S_ENCRYPTED);
 	}
 
 	/*
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index acdc65ce4796..5ac45258cc96 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1369,8 +1369,14 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 		}
 
 		if (ext4_hash_in_dirent(dir)) {
-			hinfo->hash = EXT4_DIRENT_HASH(de);
-			hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+			if (de->name_len && de->inode &&
+			    !ext4_is_fake_dir_entry(de)) {
+				hinfo->hash = EXT4_DIRENT_HASH(de);
+				hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+			} else {
+				hinfo->hash = 0;
+				hinfo->minor_hash = 0;
+			}
 		} else {
 			err = ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
 			if (err) {
diff --git a/fs/ext4/namei-test.c b/fs/ext4/namei-test.c
index cce3f8d5b36d..3126ec43e85e 100644
--- a/fs/ext4/namei-test.c
+++ b/fs/ext4/namei-test.c
@@ -126,6 +126,7 @@ static void init_mock_inode_slot(struct namei_test_ctx *ctx,
 
 	spin_lock_init(&inode->i_lock);
 	init_rwsem(&inode->i_rwsem);
+	i_size_ordered_init(inode);
 	INIT_LIST_HEAD(&inode->i_io_list);
 	INIT_LIST_HEAD(&inode->i_wb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
@@ -2313,6 +2314,133 @@ static void test_namei_casefold_lookup_and_strict(struct kunit *test)
 }
 #endif /* CONFIG_UNICODE */
 
+#ifdef CONFIG_FS_ENCRYPTION
+static int namei_test_get_context(struct inode *inode, void *ctx, size_t len)
+{
+	return -ERANGE;
+}
+
+static const struct fscrypt_operations namei_test_cryptops = {
+	.inode_info_offs	= (int)offsetof(struct ext4_inode_info,
+						i_crypt_info) -
+				  (int)offsetof(struct ext4_inode_info,
+						vfs_inode),
+	.get_context		= namei_test_get_context,
+};
+#endif
+
+/*
+ * Verify dx_make_map() and htree_dirblock_to_tree() never read stored hashes
+ * from fake entries ('.', '..', EXT4_FT_DIR_CSUM) in encrypted+casefolded dirs.
+ */
+static void test_namei_fake_dirent_hash_bounds(struct kunit *test)
+{
+	struct namei_test_ctx *ctx = test->priv;
+	struct inode *dir = get_mock_inode(ctx, TEST_DIR_INO);
+	struct buffer_head *bh, *bh2;
+	struct ext4_dir_entry_2 *de;
+	struct dx_hash_info hinfo = {
+		.hash_version = DX_HASH_SIPHASH,
+		.seed = ctx->sbi.s_hash_seed,
+	};
+	struct dx_map_entry *map;
+	char *exact_buf, *saved_data;
+	int count;
+
+	exact_buf = kunit_kzalloc(test, TEST_BLK_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, exact_buf);
+
+	bh = map_and_get_dir_bh(ctx, dir, 0);
+	bh2 = map_and_get_dir_bh(ctx, dir, 1);
+	KUNIT_ASSERT_NOT_NULL(test, bh);
+	KUNIT_ASSERT_NOT_NULL(test, bh2);
+	saved_data = bh->b_data;
+	bh->b_data = exact_buf;
+
+	ext4_clear_feature_metadata_csum(&ctx->sb);
+	ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
+	dir->i_flags |= S_CASEFOLD | S_ENCRYPTED;
+	i_size_write(dir, TEST_BLK_SIZE);
+
+	/*
+	 * 12-byte '.' and '..' followed by a real entry with stored hash:
+	 * dx_make_map() must assign hash 0 to '.' and '..' instead of reading
+	 * the following entry's inode/rec_len as a hash trailer.
+	 */
+	de = (struct ext4_dir_entry_2 *)exact_buf;
+	de->inode = cpu_to_le32(TEST_DIR_INO);
+	de->rec_len = ext4_rec_len_to_disk(12, TEST_BLK_SIZE);
+	de->name_len = 1;
+	de->file_type = EXT4_FT_DIR;
+	memcpy(de->name, ".", 2);
+
+	de = (struct ext4_dir_entry_2 *)(exact_buf + 12);
+	de->inode = cpu_to_le32(TEST_ROOT_INO);
+	de->rec_len = ext4_rec_len_to_disk(12, TEST_BLK_SIZE);
+	de->name_len = 2;
+	de->file_type = EXT4_FT_DIR;
+	memcpy(de->name, "..", 3);
+
+	de = (struct ext4_dir_entry_2 *)(exact_buf + 24);
+	de->inode = cpu_to_le32(TEST_FILE1_INO);
+	de->rec_len = ext4_rec_len_to_disk(TEST_BLK_SIZE - 24, TEST_BLK_SIZE);
+	de->name_len = 16;
+	de->file_type = EXT4_FT_REG_FILE;
+	memcpy(de->name, "0123456789abcdef", 16);
+	EXT4_DIRENT_HASHES(de)->hash = cpu_to_le32(0x11223344U);
+	EXT4_DIRENT_HASHES(de)->minor_hash = cpu_to_le32(0x55667788U);
+
+	map = (struct dx_map_entry *)(bh2->b_data + TEST_BLK_SIZE);
+	count = dx_make_map_test(dir, bh, &hinfo, map);
+	KUNIT_ASSERT_EQ(test, count, 3);
+	map -= count;
+	/* map[2] = '.', map[1] = '..', map[0] = 'file1' */
+	KUNIT_EXPECT_EQ(test, map[2].hash, 0U);
+	KUNIT_EXPECT_EQ(test, map[1].hash, 0U);
+	KUNIT_EXPECT_EQ(test, map[0].hash, 0x11223344U);
+
+	/* Crafted EXT4_FT_DIR_CSUM at exact block end must fail validation */
+	de->rec_len = ext4_rec_len_to_disk(TEST_BLK_SIZE - 24 - 20,
+					   TEST_BLK_SIZE);
+	de = (struct ext4_dir_entry_2 *)(exact_buf + TEST_BLK_SIZE - 20);
+	de->inode = cpu_to_le32(TEST_FILE2_INO);
+	de->rec_len = ext4_rec_len_to_disk(20, TEST_BLK_SIZE);
+	de->name_len = 12;
+	de->file_type = EXT4_FT_DIR_CSUM;
+	memcpy(de->name, "crafted_csum", 12);
+
+	map = (struct dx_map_entry *)(bh2->b_data + TEST_BLK_SIZE);
+	KUNIT_EXPECT_EQ(test, dx_make_map_test(dir, bh, &hinfo, map),
+			-EFSCORRUPTED);
+
+#ifdef CONFIG_FS_ENCRYPTION
+	{
+		struct file dir_file = { .f_inode = dir };
+		struct dir_private_info *info;
+		__u32 next_hash = 0;
+
+		ctx->sb.s_cop = &namei_test_cryptops;
+		info = kzalloc_obj(*info, GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, info);
+		dir_file.private_data = info;
+
+		/*
+		 * htree_dirblock_to_tree() must store '.', '..', and the
+		 * regular entry without falling into SipHash or over-reading
+		 * the crafted CSUM entry at exact block end.
+		 */
+		count = ext4_htree_fill_tree(&dir_file, 0, 0, &next_hash);
+		KUNIT_EXPECT_EQ(test, count, 3);
+		ext4_htree_free_dir_info(info);
+		ctx->sb.s_cop = &ext4_cryptops;
+	}
+#endif
+
+	dir->i_flags &= ~(S_CASEFOLD | S_ENCRYPTED);
+	ext4_set_feature_metadata_csum(&ctx->sb);
+	bh->b_data = saved_data;
+}
+
 static struct kunit_case namei_test_cases[] = {
 	KUNIT_CASE(test_namei_dirent_tail_and_csum),
 	KUNIT_CASE(test_namei_dx_helpers_and_csum),
@@ -2329,6 +2457,7 @@ static struct kunit_case namei_test_cases[] = {
 	KUNIT_CASE(test_namei_nlink_and_lookup_parent),
 	KUNIT_CASE(test_namei_link_unlink_and_rmdir),
 	KUNIT_CASE(test_namei_rename_and_exchange),
+	KUNIT_CASE(test_namei_fake_dirent_hash_bounds),
 #if IS_ENABLED(CONFIG_UNICODE)
 	KUNIT_CASE(test_namei_casefold_lookup_and_strict),
 #endif
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b2753daad49f..f1d4a99af1a8 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -520,7 +520,8 @@ static struct stats dx_show_leaf(struct inode *dir,
 						len = fname_crypto_str.len;
 					}
 					if (IS_CASEFOLDED(dir))
-						h.hash = EXT4_DIRENT_HASH(de);
+						h.hash = ext4_is_fake_dir_entry(de) ?
+							0 : EXT4_DIRENT_HASH(de);
 					else
 						(void) ext4fs_dirhash(dir,
 							de->name,
@@ -924,7 +925,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 			break;
 		}
 		if (ext4_hash_in_dirent(dir)) {
-			if (de->name_len && de->inode) {
+			if (de->name_len && de->inode &&
+			    !ext4_is_fake_dir_entry(de)) {
 				hinfo->hash = EXT4_DIRENT_HASH(de);
 				hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
 			} else {
@@ -1142,9 +1144,12 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 					 ((char *)de) - base))
 			return -EFSCORRUPTED;
 		if (de->name_len && de->inode) {
-			if (ext4_hash_in_dirent(dir))
-				h.hash = EXT4_DIRENT_HASH(de);
-			else {
+			if (ext4_hash_in_dirent(dir)) {
+				if (!ext4_is_fake_dir_entry(de))
+					h.hash = EXT4_DIRENT_HASH(de);
+				else
+					h.hash = 0;
+			} else {
 				int err = ext4fs_dirhash(dir, de->name,
 						     de->name_len, &h);
 				if (err < 0)
@@ -1278,7 +1283,7 @@ static bool ext4_match(struct inode *parent,
 		 * considering the calculated hash.
 		 */
 		if (sb_no_casefold_compat_fallback(parent->i_sb) &&
-		    IS_ENCRYPTED(parent) && fname->cf_name.name &&
+		    ext4_dirent_has_hash(parent, de) && fname->cf_name.name &&
 		    (fname->hinfo.hash != EXT4_DIRENT_HASH(de) ||
 		     fname->hinfo.minor_hash != EXT4_DIRENT_MINOR_HASH(de)))
 			return false;
@@ -1314,7 +1319,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 		if (de->name + de->name_len <= dlimit &&
-		    (!ext4_hash_in_dirent(dir) ||
+		    (!ext4_dirent_has_hash(dir, de) ||
 		     (char *)de + ext4_dir_rec_len(de->name_len, dir) <= dlimit) &&
 		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
-- 
2.56.1.708.g77570a6a1d-goog

