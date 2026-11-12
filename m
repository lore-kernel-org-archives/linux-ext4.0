Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458479;
	b=oGGjMe+vPz47HROCYLRRHvGKiaRoGiOoCFFcRzzowApMf26Gg13WZyyCMZeuv490z03B
	 7pjaKL4RkHn1X9Dgtbhlx/7iY3LWE/ZaQFcnqkFVCwbQpXZ82MrUh5+F7bgJPEqPqGQ/K
	 KLlEEGRtmGxbjkCaS/8rKDkuQXGaIXqXtyeZ300iJ5K9X0GqlhXZvMlNxNJ6vX/QBL0cp
	 46H4r7goLPohBbvgTJbhGLBE/4lwTw3eK2hq7BVsVbatwm+HMe9AEg0hNvMOotmcp/WvG
	 IPPw81ZlSURIrx+MEjf03Nm5egtlh6kVH1VgfowhjjcvWVOh4esJmno7RdlqwjG8hvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458479;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lq0SkpQcHNH4MQnYNxzSaU7mL/4WKQmsA+H2Rkgdf+M=;
	b=jTs7Hch6te0mIb5ZMrfFIVkF/BJem7DunqV3hnBvAROketC/BMoa9u0/oETpv5IiHtxC
	 OVswVfUvQEuTgTZbXcACBGlSYAYSxh7welpzggsOoKfERV0D9mkcIX0zIYLzHC0zZcM2Q
	 rNidUa8rzqtPV+Ux647LPUBW+b8o6yte7QTIECRi5bBhIBt3UL0Ri97ZM9Hg2wlLSJII5
	 jPCajHccGDZ3/GkeZP7dBvLxLsDTf6eM0uumnADvBSJQrZ0/uwHI9+IDnrkMjCDNnTmTj
	 HgOmjTnCl4DLmuks4fVsaicTPC9FGJwguL7BYeAWN0DqlAUrHT8IemCdv+pLMpooMrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mSulYH8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5DE606A32A
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mSulYH8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9401F00A05;
	Thu, 12 Nov 2026 04:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794458478;
	bh=lq0SkpQcHNH4MQnYNxzSaU7mL/4WKQmsA+H2Rkgdf+M=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=mSulYH8rT636MwGr2728XI2nDtRZ+mRQ9oZi6iGB75HboYOjWtg2tf0cCG6DCuj1I
	 vY4vASwCBJMQBXVomYS3L5uhczhG7iElr4zUqinhRhUSRygWeZt25E7b/4euqxyeEQ
	 +3uskeLfwNEvr7CLavskN0GYwCRZqu53GkL5jNnze8OpumPC2yNKBzV9aL3eZEtUTi
	 VgY1U7zsq8WWH5dl+DYC4o+Id9AvBUCtcZT57kOMRaD7yfv7qwRqAM1iKHXvvtqoTX
	 X4aTGvY6sVCOD6XNHEdx8bzSqxgKLyswg33wdDEd7AwwaqTlbviOZXBdobMvBcur3G
	 a8LPi+tCID2wQ==
Message-ID: <sashiko-outbox-210377@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 27/27] ext4: add KUnit tests for fs/ext4/dir.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-28-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-28-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:41:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] ext4: uninitialized i_size_seqcount in dir_test_init() on 32-bit
  SMP
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] ext4: out-of-bounds read in ext4_readdir() on fake dirents
  [1]
--

commit 789413bd80e96edcb89e48a8973879c9137951c1
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/dir.c

This commit adds a KUnit test suite for fs/ext4/dir.c covering directory
entry validation, hash-cookie helpers, directory llseek, and linear and
HTree directory iteration, and exports helper symbols for testing.

> diff --git a/fs/ext4/dir-test.c b/fs/ext4/dir-test.c
> new file mode 100644
> index 0000000000000..4d7c7c89e8b90
> --- /dev/null
> +++ b/fs/ext4/dir-test.c

[ ... ]

> +static int dir_test_init(struct kunit *test)
> +{
> +	struct dir_test_ctx *ctx;
> +	struct inode *dir;
> +	int i;
> +
> +	ctx =3D kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
> +	test->priv =3D ctx;

[ ... ]

> +	dir =3D &ctx->dir_ei.vfs_inode;
> +	dir->i_sb =3D &ctx->sb;
> +	dir->i_ino =3D DIR_TEST_DIR_INO;
> +	dir->i_mode =3D S_IFDIR | 0755;
> +	dir->i_blkbits =3D DIR_TEST_BLK_BITS;
> +	dir->i_mapping =3D &dir->i_data;
> +	dir->i_data.host =3D dir;
> +	set_nlink(dir, 2);\n> +	atomic_set(&dir->i_count, 1);
> +	spin_lock_init(&dir->i_lock);
> +	init_rwsem(&dir->i_rwsem);
> +	INIT_LIST_HEAD(&dir->i_io_list);
> +	INIT_LIST_HEAD(&dir->i_wb_list);
> +	INIT_LIST_HEAD(&dir->i_lru);
> +	INIT_HLIST_NODE(&dir->i_hash);
> +	inode_state_set_raw(dir, I_DIRTY);
> +	inode_set_iversion_raw(dir, 10);

[Severity: Low]
Does dir_test_init() leave dir->i_size_seqcount uninitialized on 32-bit SMP
builds?

Because ctx is allocated on the heap via kunit_kzalloc() without calling
i_size_ordered_init(dir) (or inode_init_once(dir)), i_size_write(dir, ...)
and i_size_read(dir) in the test cases pass an uninitialized lockdep_map to
write_seqcount_begin() and read_seqcount_begin() when CONFIG_DEBUG_LOCK_ALL=
OC
is enabled, triggering a non-static key warning and disabling lockdep.

> +
> +	init_rwsem(&ctx->dir_ei.xattr_sem);

[ ... ]

> +static void test_check_dir_entry_and_all_de(struct kunit *test)
> +{

[ ... ]

> +	/*
> +	 * 4. Casefolded + encrypted directory requires space for
> +	 * ext4_dir_entry_hash (+8 bytes) on regular entries, while fake
> +	 * entries ('.', '..', csum tail) remain 12 bytes.
> +	 */
> +	dir->i_flags |=3D S_CASEFOLD | S_ENCRYPTED;
> +	write_de(buf, 24, 15, 16, EXT4_FT_REG_FILE, "ab");
> +	de =3D (struct ext4_dir_entry_2 *)(buf + 24);
> +	KUNIT_EXPECT_EQ(test, __ext4_check_dir_entry(__func__, __LINE__, dir,
> +						     NULL, de, bh, buf,
> +						     DIR_TEST_BLK_SIZE, 24), 1);

[Severity: Critical]
This problem wasn't introduced by this patch, but can ext4_readdir() perform
an 8-byte out-of-bounds read past the end of the directory block buffer on
fake entries [1]?

In encrypted and casefolded directories, __ext4_check_dir_entry() passes
NULL instead of dir to ext4_dir_rec_len() when is_fake_dir_entry(de) is
true, so it does not require space for the 8-byte ext4_dir_entry_hash:

fs/ext4/dir.c:__ext4_check_dir_entry() {
	...
	bool fake =3D is_fake_dir_entry(de);
	...
	if (unlikely(rlen < ext4_dir_rec_len(1, fake ? NULL : dir)))
		error_msg =3D "rec_len is smaller than minimal";
	else if (unlikely(rlen % 4 !=3D 0))
		error_msg =3D "rec_len % 4 !=3D 0";
	else if (unlikely(rlen < ext4_dir_rec_len(de->name_len,
							fake ? NULL : dir)))
		error_msg =3D "rec_len is too small for name_len";
	...
}

However, ext4_readdir() only checks that de->inode is non-zero before
reading EXT4_DIRENT_HASH(de) and EXT4_DIRENT_MINOR_HASH(de):

fs/ext4/dir.c:ext4_readdir() {
	...
			if (le32_to_cpu(de->inode)) {
				if (!IS_ENCRYPTED(inode)) {
					...
				} else {
					...
					if (IS_CASEFOLDED(inode)) {
						hash =3D EXT4_DIRENT_HASH(de);
						minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
					}
	...
}

If a corrupted directory places a fake entry (such as "." or "..", or an
entry with file_type set to EXT4_FT_DIR_CSUM and a non-zero de->inode) at
the end of the block with rlen sized without the 8-byte hash, reading the
hash accesses 8 bytes past bh->b_data + sb->s_blocksize, which can fault on
an unmapped page or leak adjacent memory to userspace via nokey_name.dirhas=
h.

[1] https://sashiko.dev/#/bug/linux-7bcf348c-5fde-4625-bb87-69ecef239378

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D27
