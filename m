Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457619;
	b=qS0skMVOgDcOH/mbafV1PHxyXa0Mk3NOUHYndA3kqsJp/9JiUKGG3GYa9LS/3+CFw5Bn
	 IHwbae4ehhwL8zLmKoVJdHZ3l8CLd5MbJPw4Gp0qSCek1KjsD3pUNhedCE63CDBTp9g1F
	 VCV8jIcvcnnUPU5S6gGO2SSevgCk21400Tft39C/yn2qfRmrEd/ueYEKXB01LCn58vIcf
	 Z/ATpPz7OW3tP+p1JZp3cphkAvcZfxEMpTGs02NUwL6HoW8g0O3l9Wp6isbdsd4leLYLw
	 cHB4K63bWNcRIqHXvb3w8kOsehthgFYkTiI1WxtKTLbgjhG/4yRJxt4wCJ7R8MadD/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457619;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8KyvYs4cmiXUsT4/RBesRgK1sClGKiNRVjypU7zVv4U=;
	b=X3kW6cYYFO+3/FIplA178kE27OH6OpyNrbBZfF0RM3vy9+9DC+RYyT9Ps62yNsHzVLSA
	 AS0mNOuidCD/cyWQSgGh6k/eXDX8RpBIX64PF6vS0oMDVa4NxAhBVUVFoPIe7dE+cuqsj
	 7kPeSAQwyNnhZL+rDQ+TYSOD6H2CGtJEJpiOWBkkQv56blzxzXboHWa8thh92ldJsa21b
	 ZRK3+1JNVkTN5151p+rsxHRzh268o+nKCiKznK/zmclDzhMFJgCxSxkwkK6cbShzHHyQe
	 RaTmlAknlVdfuBGX5gCFNh3ZmsiduaAMBqYXzMyNPaa38twO9MXC8ClnrC7S/y47mEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FMnZqI1x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA38B606A332
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FMnZqI1x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBD21F00A05;
	Thu, 12 Nov 2026 04:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457619;
	bh=8KyvYs4cmiXUsT4/RBesRgK1sClGKiNRVjypU7zVv4U=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FMnZqI1xqgAIQ9Lr98XJlmYpDKgKbPUjXC44OSBC/oTDYfJCqBBGq+9P0pzPtaV+t
	 s8/ipTvzbjG+DUN5e9Zi6aH95hpvvXfF6Q2Nn8c4B6kZkPYujBvCpEWP1qb3Yz0IpL
	 uZdOnz0ZEkNGs5RCZ5TfzSgE5zRb+Lny2vD21VtRlZOvf39xZusXi7uUxAMYehKMEi
	 iOyxQFJvCeErIZ5GEUn/ghySRILpvsbcKWB3VtV7qHcVul2ezTe273x+07aXANECCb
	 lhjffmqBD1fdRks+jcN3AQJk/aAC/tJEdayxgPkMz/12cTXJCfGgRhHFijAqGl2eiu
	 6IDQ0tXAUdMQw==
Message-ID: <sashiko-outbox-210335@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/27] ext4: add KUnit tests for fs/ext4/xattr.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-5-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-5-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:26:58 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] ext4: uninitialized e_name in test_xattr_check_inode()
  bypasses value checks
- [Low] ext4: stack frame size warning in
  test_xattr_credits_usage_expand_and_delete()
- [Low] ext4: missing i_size_ordered_init() in init_mock_inode_slot()
--

commit b81033fe08ff323ec6a5c24275644912bdfe1108
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/xattr.c

This commit adds a KUnit test suite in fs/ext4/xattr-test.c to exercise
extended attribute operations in fs/ext4/xattr.c using static stubs and
exports.

> diff --git a/fs/ext4/xattr-test.c b/fs/ext4/xattr-test.c
> new file mode 100644
> index 0000000000000..35be150353a20
> --- /dev/null
> +++ b/fs/ext4/xattr-test.c

[ ... ]

> +static void init_mock_inode_slot(struct xattr_test_ctx *ctx,
> +				 struct mock_inode_slot *slot,
> +				 unsigned long ino)
> +{
> +	struct inode *inode =3D &slot->ei.vfs_inode;
> +	struct ext4_inode *raw_inode;
> +
> +	memset(slot, 0, sizeof(*slot));
> +	slot->allocated =3D true;
> +
> +	inode->i_sb =3D &ctx->sb;
> +	inode->i_ino =3D ino;
> +	inode->i_mode =3D S_IFREG | 0644;
> +	inode->i_blkbits =3D TEST_BLK_BITS;
> +	inode->i_mapping =3D &inode->i_data;
> +	set_nlink(inode, 1);
> +	atomic_set(&inode->i_count, 1);
> +
> +	spin_lock_init(&inode->i_lock);
> +	init_rwsem(&inode->i_rwsem);

[Severity: Low]
Should init_mock_inode_slot() also call i_size_ordered_init(inode)?

On 32-bit SMP builds with CONFIG_DEBUG_LOCK_ALLOC=3Dy, struct inode embeds
i_size_seqcount, so calling i_size_write() or i_size_read() on the mock
EA inodes triggers a lockdep warning for an uninitialized key and
disables lockdep.

[ ... ]

> +static void test_xattr_check_inode(struct kunit *test)
> +{
> +	const struct xattr_check_param *p =3D test->param_value;
> +	struct xattr_test_ctx *ctx =3D test->priv;
> +	struct inode *inode =3D &ctx->primary.ei.vfs_inode;
> +	struct ext4_inode *raw_inode =3D (struct ext4_inode *)ctx->primary.raw_=
buf;
> +	struct ext4_xattr_ibody_header *hdr =3D IHDR(inode, raw_inode);
> +	struct ext4_xattr_entry *e1, *e2;
> +	void *end =3D ITAIL(inode, raw_inode);
> +	size_t total_size =3D (char *)end - (char *)IFIRST(hdr);
> +	int ret;
> +
> +	memset(hdr, 0, (char *)end - (char *)hdr);
> +	hdr->h_magic =3D cpu_to_le32(EXT4_XATTR_MAGIC);
> +	e1 =3D IFIRST(hdr);
> +
> +	switch (p->id) {

[ ... ]

> +	case CHECK_NONZERO_OFFS_WITH_INUM:
> +		e1->e_name_len =3D 1;
> +		e1->e_value_inum =3D cpu_to_le32(20);
> +		e1->e_value_offs =3D cpu_to_le16(total_size - 4);
> +		break;
> +	case CHECK_VALUE_SIZE_GT_TOTAL:
> +		e1->e_name_len =3D 1;
> +		e1->e_value_size =3D cpu_to_le32(total_size + 4);
> +		e1->e_value_offs =3D cpu_to_le16(total_size - 4);
> +		break;
> +	case CHECK_VALUE_OFFS_OVERLAPS_ENTRY:
> +		e1->e_name_len =3D 1;
> +		e1->e_value_size =3D cpu_to_le32(4);
> +		/* Offset points inside e1 + 4-byte terminator */
> +		e1->e_value_offs =3D cpu_to_le16(EXT4_XATTR_LEN(1));
> +		break;
> +	case CHECK_VALUE_END_EXCEEDS_TOTAL:
> +		e1->e_name_len =3D 1;
> +		e1->e_value_size =3D cpu_to_le32(8);
> +		e1->e_value_offs =3D cpu_to_le16(total_size - 4);
> +		break;
> +	}

[Severity: Medium]
Do these four cases reach the value checks in check_xattrs()?

Because hdr is zeroed with memset() and e1->e_name[0] is left as NUL
while e1->e_name_len is 1, check_xattrs() rejects all four cases in the
entry-name loop before reaching the value-validation loop:

fs/ext4/xattr.c:check_xattrs() {
    ...
	while (!IS_LAST_ENTRY(e)) {
		...
		if (strnlen(e->e_name, e->e_name_len) !=3D e->e_name_len) {
			err_str =3D "bad e_name length";
			goto errout;
		}
		e =3D next;
	}

	/* Check the values */
	while (!IS_LAST_ENTRY(entry)) {
    ...
}

In addition, check_xattrs() only inspects e_value_offs when
entry->e_value_inum =3D=3D 0, so CHECK_NONZERO_OFFS_WITH_INUM does not test=
 a
check that check_xattrs() performs; even with e1->e_name[0] set, it would
fail on the missing EXT4_FEATURE_INCOMPAT_EA_INODE feature or zero
e_value_size instead.

[ ... ]

> +static void test_xattr_credits_usage_expand_and_delete(struct kunit *tes=
t)
> +{
> +	struct xattr_test_ctx *ctx =3D test->priv;
> +	struct inode *inode =3D &ctx->primary.ei.vfs_inode;
> +	struct ext4_inode *raw =3D (struct ext4_inode *)ctx->primary.raw_buf;
> +	journal_t fake_journal =3D {
> +		.j_revoke_records_per_block =3D 64,
> +	};

[Severity: Low]
Can placing fake_journal on the stack exceed CONFIG_FRAME_WARN?

journal_t (struct journal_s) is ~1.3 KB on 64-bit builds and over 2.2 KB
when lock debugging is enabled, which triggers -Wframe-larger-than=3D
warnings on 32-bit builds or 64-bit debug configurations.  Moving
fake_journal into struct xattr_test_ctx or allocating it with
kunit_kzalloc() would avoid the large stack frame.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D4
