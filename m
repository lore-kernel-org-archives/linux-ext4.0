Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105020;
	b=ZjAoiYbg5afVJWAGsflRpXz4qgfCoB9gGUMTI/DDQOy1ISOGFhR1OZ8Z78tYw4aviDy0
	 e3LBM8GVFrjW0gn0m/hAgwz15ojVACPPd9fECPIo9Nj6VmP7bvipRmLyI4SKSV/ZYHLbi
	 63xaU1fXpgaJh1E1EqvL2CUSyluwrLyhns9sZvl6DVpd/UfQVQdQ4v4lEDHHYgpjgNNUH
	 CVm4+mFoGwswND71tcAj088u4xsBUo/XkYaPR2U4VqRC+0Aiy+kXLQU2uR/H49SQBsYwG
	 0TIJsdvjlxE5LCJXZdtXck7/PtZf4sOZxaE5kfVQniFVap3dmDu7pw+9Dn56unYtf9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105020;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UqqGQc7XH52fXGbQHRVNBSRf4oeaIZ3mKRhsZ6Y1GTU=;
	b=qxL5QJHn3f410mIp5Bj81WN39bZpQkmkGLAlzNdFM0w64EnEGf7lLL8Z4u5f/hjaow/L
	 KBz7oR41onJrKDilv4aY/gpTuRRoY5CvqWmf9C+Gu7XSymjVOL7/wPG+Lv2BGjdKHqp+C
	 rM+FHhaeu3gfulxwebvKTLtpVVZOy0fggXrwNzGEd2lBHf7XeEkNdDvKtMIk1m07UR199
	 +r1eKkTTp+DwNjMcuB/vSH/XVKQD0aDjoN8vWPd2IVd6vtxUE8I/FgtGOUgrtjdiUVS6h
	 ILHHdcUxCTVJjZylpGhzDeMVobqPUma+VBuw2X6/YnmJVVtMG1kf6trsMgYmEmzUeKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nF4JtNch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BF7606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nF4JtNch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C769A1F000C6;
	Thu, 19 Nov 2026 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795105020;
	bh=UqqGQc7XH52fXGbQHRVNBSRf4oeaIZ3mKRhsZ6Y1GTU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=nF4JtNch7pmY91yUyQkyYPB1oom1jq2Lq5Il/iqclBxWOtbnIGyS1W5dNqpArYbF+
	 qJqMVWL3tqFa+YEhUuWaXjygzrNoOUTO2HOHQKRNIXAsvVp6FWbMCYtEQKM3sitC9K
	 xW2il3llhZubfa97N+jtVhvRhrqu21UzT76AVk1rfZum+nn/Kuw3lMi6kusGhKh8GY
	 DRdQdrWtDAsWIJtl2aOIcQym6w42PMyjgZ7NcXoNrPGmuDJp6CpRILTTFkNxCxTmIy
	 cCPtIk0HQvMxRY+TOtD3p1fjaP4PcQM8FNDnHHnUJh5oYIXA0MLO41anj140cnFw7i
	 HRhaJBUzDcOEA==
Message-ID: <sashiko-outbox-223504@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 20/26] ext4: add KUnit tests for fs/ext4/indirect.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-21-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-21-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:16:59 +0000
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
- [Low] ext4: leak of test inode and handle on KUNIT_ASSERT abort in
  indirect-test.c
--

commit ac1d07e8010829fce0fd4a0596e2f92e79885c99
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/indirect.c

This commit adds the ext4_indirect_test KUnit test suite covering legacy
indirect block mapping, truncation, and hole punching in fs/ext4/indirect.c.

> diff --git a/fs/ext4/indirect-test.c b/fs/ext4/indirect-test.c
> new file mode 100644
> index 0000000000000..8d4a430ecb272
> --- /dev/null
> +++ b/fs/ext4/indirect-test.c

[ ... ]

> +static __le32 *ind_blk_ptrs(struct kunit *test, ext4_fsblk_t blk)
> +{
> +	struct ind_test_ctx *ctx =3D test->priv;
> +	struct buffer_head *bh;
> +
> +	bh =3D ind_get_or_create_bh(ctx, blk);
> +	KUNIT_ASSERT_NOT_NULL(test, bh);
> +	brelse(bh);
> +	return (__le32 *)bh->b_data;
> +}
> +
> +static struct inode *ind_make_test_inode(struct kunit *test, unsigned lo=
ng ino)
> +{
> +	struct ind_test_ctx *ctx =3D test->priv;
> +	struct inode *inode;
> +
> +	inode =3D new_inode(ctx->sb);
> +	KUNIT_ASSERT_NOT_NULL(test, inode);
> +	inode->i_ino =3D ino;
> +	inode->i_mode =3D S_IFREG | 0644;
> +	inode->i_blkbits =3D IND_TEST_BLK_BITS;
> +	inode->i_flags |=3D S_NOQUOTA;
> +	EXT4_I(inode)->i_block_group =3D 0;
> +	return inode;
> +}

[ ... ]

> +static void test_ind_remove_space_levels_and_convergence(struct kunit *t=
est)
> +{
> +	struct ind_test_ctx *ctx =3D test->priv;
> +	struct inode *inode =3D ind_make_test_inode(test, 17);
> +	__le32 *ind, *dind, *c0, *c1, *c2;
> +	handle_t *handle;
> +	unsigned int i;
> +	int ret;
> +
> +	handle =3D ext4_journal_start(inode, EXT4_HT_TRUNCATE, 8);
> +	KUNIT_ASSERT_FALSE(test, IS_ERR(handle));

[ ... ]

> +	EXT4_I(inode)->i_data[EXT4_IND_BLOCK] =3D cpu_to_le32(510);
> +	ind =3D ind_blk_ptrs(test, 510);

[Severity: Low]
Can a KUNIT_ASSERT_* failure after ind_make_test_inode() or
ext4_journal_start() leak the test inode and journal handle?

If ind_get_or_create_bh() fails inside ind_blk_ptrs() (or in
test_ind_map_blocks_errors_and_alloc_branch_unwind()), or if
ext4_journal_start() fails after ind_make_test_inode(), the test aborts
before reaching ext4_journal_stop() and iput().  That leaves the no-journal
handle in current->journal_info with memalloc_nofs_save() active on the
KUnit runner thread, and leaves an active inode on ctx->sb->s_inodes when
ind_test_cleanup() calls deactivate_super(sb).  Registering KUnit cleanup
actions for the inode (as in migrate_make_test_inode()) and handle, or
releasing them before aborting, would avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D20
