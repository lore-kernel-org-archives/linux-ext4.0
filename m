Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457759;
	b=ZBfKQZRe3paqil4cfzYhJSzovsOforAajj+/+W+g7iMp8HFJTAtsChVUOC0ZwMjQfqYw
	 pKbAKLKz34r8X8FjeExdf1MA/ns5XnglIyOKHdb6tJlZJxNoaRtFw7OTutX80bt8E+y/q
	 ybN1z9ZT4u3TZ2j6ZD4D63dmPHyCszNvwoX5sDo2baRN35/vyM5Hnb8gvKWR61fvujzYP
	 t63aU9h9grNAYhX51X/Hg97p7KtlWpM/ie+T6fD5xzRNWKY0KHokSspXS4x6/8zGvBytI
	 So0wwQ4lOAW4YkZ7Y1beIR56Edr7PSP44tAlAWQEd0C1rZDKHhzqKfj1TuyWWtCWZOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457759;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mhlHFUu5HIbCCv8iaBs/kRAN3g4ObIUaLQTuwCIgE6w=;
	b=YBh5tvs8kaRmGPx1VJvLzPOkQm414msm1U8RnqReRzhrZuw/7CWBHAyTYF0X4I+/mqUF
	 eTlyKN/S6c6ZMBl60wV64j7jLrSWyvZtP4WwqwENOXKX2ACBO1YuAQzleQX2mtT7BOdd0
	 X3pskq1L7SIdgs7qyeU9OR8G1n9Clmf5Dz+Ze+lzP8qlJ5at+7XMgoNuHSe2F7xWc5iVo
	 MCDzKHi+eut15OCd0w/aCi1Ccp+a08ukDXDXYSXfdQMJ4URu5Rfw+c/eihKTPr64q4DZI
	 JrFdwme7GRmCrmea+MuLDnSVXRkrQYkvUxCdH4UH320ZSWOcEE3x3SL4Zx8owx7PcYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K4WrTh7E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D1B606A323
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K4WrTh7E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3171F00A05;
	Thu, 12 Nov 2026 04:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457759;
	bh=mhlHFUu5HIbCCv8iaBs/kRAN3g4ObIUaLQTuwCIgE6w=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=K4WrTh7E/ncivaWE9xt3bQMQGnexLInQQZ+pZN+rWhnenIEWj4Xp5UzHN3PwAkTks
	 /0ApIIWErYukci76HjJrp0YrJyvUEO4whpx2UZ4UkKRBOCoikT5pYj7FAEX/jkjBVu
	 L8aU4j3QREhiZqlLqh9kP7F35o+a29eWnTuRda8hPSc6V0Y6gXcji6896hJ2qL0aEj
	 k1IPnvvxeHtxxNgGz9WSINA0p54q4Ee90pKdn1C0UNRFF7tFMFFM6abLL7zuCwylaN
	 3lGglW5/wW5g+xc+WMnUWoqDUWhYL2sTaYnekv8WNH2aJ5+g0OqfUwNIX/g8eblOpc
	 3Ck4ZzLlP9aSw==
Message-ID: <sashiko-outbox-210339@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/27] ext4: add KUnit tests for fs/ext4/inline.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-8-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-8-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:29:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Low] ext4: unexercised dioread_nolock branch in inline conversion
  KUnit test
- [Low] ext4: unexercised iversion revalidation in test_filldir_actor()
- [Low] ext4: inaccurate comment on ext4_inlinedir_to_tree() in
  inline-test.c
- [Low] ext4: missing i_size_ordered_init() on mock inode in
  inline_test_init()
It also noticed 2 related pre-existing issues this patch does not
introduce:
- [Critical] ext4: TOCTOU race condition in
  ext4_convert_inline_data_nolock() [1]
- [Critical] ext4: 32-bit i_size truncation in
  ext4_inline_data_truncate() [2]
--

commit 2474f0318caf555f2d6839372e8f1734082921e5
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/inline.c

This commit adds a KUnit test suite in fs/ext4/inline-test.c to exercise
ext4 inline data operations for regular files, symlinks, and directories,
along with static stub hooks and symbol exports for the tested functions.

> diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
> new file mode 100644
> index 0000000000000..a75f46475c4a9
> --- /dev/null
> +++ b/fs/ext4/inline-test.c
[ ... ]
> +static int inline_test_init(struct kunit *test)
> +{
[ ... ]
> +	/* Initialize mock ext4_inode_info and embedded vfs_inode */
> +	inode =3D &ctx->ei.vfs_inode;
> +	inode->i_sb =3D &ctx->sb;
> +	inode->i_ino =3D TEST_INO;
> +	inode->i_blkbits =3D TEST_BLOCK_BITS;
> +	set_nlink(inode, 1);
> +	atomic_set(&inode->i_count, 1);
> +	spin_lock_init(&inode->i_lock);
> +	init_rwsem(&inode->i_rwsem);

[Severity: Low]
Does the mock inode initialization in inline_test_init() miss a call to
i_size_ordered_init(inode) (or inode_init_once())?

On 32-bit SMP kernels with CONFIG_DEBUG_LOCK_ALLOC enabled, struct inode
embeds seqcount_t i_size_seqcount.  Because ctx is allocated from the heap
via kunit_kzalloc(), calling i_size_write() or i_size_read() in
create_inline_file() and the tested inline helpers accesses an
uninitialized lockdep_map key on inode->i_size_seqcount, triggering a
lockdep warning and disabling lockdep.

[ ... ]

> +static void test_write_triggers_inline_to_extent_conversion(struct kunit=
 *test)
> +{
[ ... ]
> +	/*
> +	 * 2. Conversion with DIOREAD_NOLOCK + DELALLOC enabled and journal_data
> +	 * mode (exercises ext4_should_dioread_nolock and ext4_should_journal_d=
ata
> +	 * branches in ext4_convert_inline_data_to_extent).
> +	 */
> +	reset_inode_state(ctx, S_IFREG | 0644);
> +	ret =3D create_inline_file(inode, buf, sizeof(buf));
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +
> +	set_opt(&ctx->sb, DIOREAD_NOLOCK);
> +	set_opt(&ctx->sb, DELALLOC);
> +	ctx->journal_mode =3D EXT4_INODE_JOURNAL_DATA_MODE;
> +
> +	inode_lock(inode);
> +	folio =3D NULL;
> +	ret =3D ext4_try_to_write_inline_data(&inode->i_data, inode, 0, 200,
> +					    &folio);
> +	inode_unlock(inode);

[Severity: Low]
Does setting ctx->journal_mode to EXT4_INODE_JOURNAL_DATA_MODE here prevent
the ext4_should_dioread_nolock() branch in
ext4_convert_inline_data_to_extent() from being exercised?

ext4_should_dioread_nolock() returns 0 whenever
ext4_should_journal_data(inode) is true:

fs/ext4/ext4_jbd2.h:ext4_should_dioread_nolock() {
    ...
	if (ext4_should_journal_data(inode))
		return 0;
    ...
}

Testing the DIOREAD_NOLOCK + DELALLOC unwritten-extent conversion path
requires a separate call with a non-journaled data mode such as
EXT4_INODE_WRITEBACK_DATA_MODE.

[ ... ]

> +static bool test_filldir_actor(struct dir_context *dctx, const char *nam=
e,
> +			       int namelen, loff_t offset, u64 ino,
> +			       unsigned int d_type)
> +{
> +	struct test_dir_ctx *tctx =3D
> +		container_of(dctx, struct test_dir_ctx, ctx);
> +
> +	if (tctx->max_emit > 0 && tctx->count >=3D tctx->max_emit)
> +		return false;

[ ... ]

> +	/* Mutating inode iversion during iteration triggers offset revalidatio=
n */
> +	memset(&env->dctx, 0, sizeof(env->dctx));
> +	env->dctx.ctx.actor =3D test_filldir_actor;
> +	env->dctx.ctx.pos =3D 0;
> +	env->dctx.mutate_inode_on_second =3D dir;
> +	ret =3D ext4_read_inline_dir(&env->filp, &env->dctx.ctx,
> +				   &has_inline_data);
> +	KUNIT_EXPECT_EQ(test, ret, 0);
> +	KUNIT_EXPECT_EQ(test, env->dctx.count, 6);

[Severity: Low]
Does this subtest ever exercise partial iteration or the iversion
revalidation loop in ext4_read_inline_dir()?

tctx->max_emit is never set to a non-zero value anywhere in the file, and
ext4_read_inline_dir() is only called once starting from ctx.pos =3D 0.
When test_filldir_actor() increments dir's iversion on the second entry,
ext4_read_inline_dir() has already passed the
!inode_eq_iversion(inode, info->cookie) check at the top of the function
and continues emitting all 6 entries in the same call without ever
re-entering at a non-zero ctx.pos.

[ ... ]

> +static void test_inline_dir_conversion_and_corruptions(struct kunit *tes=
t)
> +{
[ ... ]
> +	/*
> +	 * 4. Corrupted inline directory checks:
> +	 *   4a. Parent ino ("..") =3D=3D 0 -> empty_inline_dir returns false.
> +	 *   4b. Zero rec_len dirent -> empty_inline_dir returns false,
> +	 *       ext4_inlinedir_to_tree returns -EFSCORRUPTED, and
> +	 *       ext4_convert_inline_data_nolock aborts via ext4_check_all_de.
> +	 */
> +	reset_inode_state(ctx, S_IFDIR | 0755);
> +	handle =3D ext4_journal_start(dir, EXT4_HT_DIR, 1);
> +	KUNIT_ASSERT_FALSE(test, IS_ERR(handle));
> +	ret =3D ext4_try_create_inline_dir(handle, &env->parent, dir);
> +	ext4_journal_stop(handle);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +
> +	/* Corrupt parent ino to 0 */
> +	*(__le32 *)raw_inline_i_block(ctx) =3D cpu_to_le32(0);
> +	KUNIT_EXPECT_FALSE(test, empty_inline_dir(dir, &has_inline_data));
> +	*(__le32 *)raw_inline_i_block(ctx) =3D cpu_to_le32(TEST_PARENT_INO);
> +
> +	/* Corrupt first dirent rec_len to 0 */
> +	de =3D (struct ext4_dir_entry_2 *)((char *)raw_inline_i_block(ctx) +
> +					 EXT4_INLINE_DOTDOT_SIZE);
> +	de->rec_len =3D cpu_to_le16(0);
> +	KUNIT_EXPECT_FALSE(test, empty_inline_dir(dir, &has_inline_data));
> +
> +	/* ext4_convert_inline_data on corrupted inline dir fails in ext4_check=
_all_de */
> +	ret =3D ext4_convert_inline_data(dir);
> +	KUNIT_EXPECT_EQ(test, ret, -EFSCORRUPTED);
> +	KUNIT_EXPECT_TRUE(test, ext4_has_inline_data(dir));
> +}

[Severity: Low]
This isn't a bug, but comment 4b states that a zero rec_len dirent causes
ext4_inlinedir_to_tree() to return -EFSCORRUPTED, whereas the test does
not call ext4_inlinedir_to_tree() here and ext4_inlinedir_to_tree() breaks
out of its loop and returns the count of already-processed entries (2 for
"." and "..") when ext4_check_dir_entry() fails.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 0e662a9f7574c..97cc2c61ce25d 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
[ ... ]
> @@ -1144,7 +1152,7 @@ static int ext4_convert_inline_data_nolock(handle_t=
 *handle,
>  		goto out_restore;
>  	}
> =20
> -	data_bh =3D sb_getblk(inode->i_sb, map.m_pblk);
> +	data_bh =3D ext4_inline_getblk(inode->i_sb, map.m_pblk);
>  	if (!data_bh) {
>  		error =3D -ENOMEM;
>  		goto out_restore;

[Severity: Critical]
This problem wasn't introduced by this patch, but can unlocking data_bh
before ext4_init_dirblock() in ext4_convert_inline_data_nolock() expose an
uninitialized directory block to concurrent readers [1]?

CPU0                                    CPU1
ext4_convert_inline_data_nolock()
  ext4_destroy_inline_data_nolock()
  ext4_map_blocks()
  data_bh =3D ext4_inline_getblk()
  lock_buffer(data_bh)
  memset(data_bh->b_data, 0, ...)
  unlock_buffer(data_bh)
  i_size_write(inode, s_blocksize)
                                        ext4_get_parent()
                                          ext4_find_entry()
                                            ...
                                              ext4_dirblock_csum_verify()
                                                <-- fails on zeroed block
  ext4_init_dirblock(data_bh)
    set_buffer_uptodate(data_bh)
    set_buffer_verified(data_bh)
    ext4_handle_dirty_dirblock()

In the S_ISDIR branch of ext4_convert_inline_data_nolock(), data_bh is
zeroed, unlocked, and published via i_size_write() before
ext4_init_dirblock() populates the directory entries and computes the
block checksum:

fs/ext4/inline.c:ext4_convert_inline_data_nolock() {
    ...
	} else {
		unlock_buffer(data_bh);
		inode->i_size =3D inode->i_sb->s_blocksize;
		i_size_write(inode, inode->i_sb->s_blocksize);
		EXT4_I(inode)->i_disksize =3D inode->i_sb->s_blocksize;

		error =3D ext4_init_dirblock(handle, inode, data_bh,
			  le32_to_cpu(((struct ext4_dir_entry_2 *)buf)->inode),
			  buf + EXT4_INLINE_DOTDOT_SIZE,
			  inline_size - EXT4_INLINE_DOTDOT_SIZE);
    ...
}

In addition, ext4_init_dirblock() sets buffer_uptodate and buffer_verified
before ext4_handle_dirty_dirblock() calculates the checksum.  A concurrent
reader (such as NFS export lookup via ext4_get_parent()) can read the
partially initialized or unchecksummed block and fail
ext4_dirblock_csum_verify(), triggering an ext4 filesystem error (and a
read-only remount or panic).

> @@ -2018,5 +2026,25 @@ int ext4_convert_inline_data(struct inode *inode)
>  }
> =20
>  #if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
[ ... ]
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_inline_data_truncate);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_convert_inline_data);
>  #endif

[Severity: Critical]
This problem wasn't introduced by this patch, but can
ext4_inline_data_truncate() truncate the 64-bit inode->i_size into a
32-bit size_t on 32-bit architectures [2]?

fs/ext4/inline.c:ext4_inline_data_truncate() {
    ...
	size_t i_size;
    ...
	down_write(&EXT4_I(inode)->i_data_sem);
	i_size =3D inode->i_size;
	inline_size =3D ext4_get_inline_size(inode);
	EXT4_I(inode)->i_disksize =3D i_size;

	if (i_size < inline_size) {
		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
			ext4_lblk_t lblk =3D EXT4_B_TO_LBLK(inode, i_size);

			ext4_es_remove_extent(inode, lblk,
					      EXT_MAX_BLOCKS - lblk);
		}
    ...
}

When an inline file is converted to delayed-allocation extents via a
buffered write at an offset of 4 GiB or greater, EXT4_STATE_MAY_INLINE_DATA
is cleared while EXT4_INODE_INLINE_DATA remains set until writeback.  If a
subsequent truncate or ext4_truncate_failed_write() calls
ext4_inline_data_truncate() before writeback on a 32-bit system, assigning
inode->i_size to the 32-bit i_size local variable discards the upper 32
bits, corrupting EXT4_I(inode)->i_disksize.  When the lower 32 bits are
smaller than inline_size, it also enters the i_size < inline_size branch,
removing live delayed extents from the extent status tree and zeroing the
inline data buffer.

[1] https://sashiko.dev/#/bug/linux-48900fa2-4764-4787-990d-c127e7cf2417
[2] https://sashiko.dev/#/bug/linux-d1c56a9e-62e9-4eeb-addd-143c371dbdca

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D7
