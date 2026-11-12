Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458197;
	b=HVP36fU+epc+Rg2xJTg6TcK2sLhvb5li6pTQ0yidYM4jd5ziVuuBKkncycC8mGF+1TmR
	 LdZtlw8rnSXfPL7diqKLzen6xsiBsMeZItVIz4gRNwBePOg+/K++hlSUEoQdafVd5Uc6B
	 0i8P59/zmDjoH34J9TvvGmC56ko2XKgUhxOh5BCC4QC7/SB8/ltUKK5ENBgPn9E+S924Q
	 4ZyX4wQl+NG5qONQfaZapvbxa6IjCsiQfxeEpednJKlTsPlo/zsHYTZcIKkTDnyIqhhzX
	 bOG9xVSm8+wAsJnMs308rVkbBY4zoxOeEujlj6HhkUXC2/5KSzXZWg8yTr3iRqhwBxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458197;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jhSBBiRUK7znQM63LSQFI154AEQv+XJ53PmyEEA5SRk=;
	b=LhAWyfKX+UPYdCopZpgCqH8b9xVQVE30sLV6VRJpE4Sb5OO2N79DhtP9B6TN42didgwU
	 ITqF53/ei8m28MZUOYdCEWjMXIIbXdah7pXVEn/OBE4Fr6RiTL+xN9dFHV3HBp/M9J6ko
	 U9GDtOLcf+P21o+wUXKPsWB2jEZ5ruH5mYNxFZX5rK7LLLIZyOccjs6h6Jw3sE8HnRyg4
	 qJ8zIRQ2GkKXp+BFGnSNDjh9ZnnfHLb+eTBWlp60dVDIdTTICokZXdDxKgMTs9JCs0/xX
	 EGH71D4Gob4vUd2YcG1Cv68YA/+nvPO8A3J3OMRu2FfG/dfyFH5/zyTfCTByniajTZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qs9IaVWv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F83D606D470
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qs9IaVWv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870D91F00A06;
	Thu, 12 Nov 2026 04:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794458196;
	bh=jhSBBiRUK7znQM63LSQFI154AEQv+XJ53PmyEEA5SRk=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Qs9IaVWvJIU/8kpMp2QzzqXz92c2t2Z9+T7oJNHLCyhb7Yxfvyu9S1yZkTLQH9JYa
	 H1J2SuOTD6UH0FbY3pVRIJb2mxpFLPQwxXvEXirlvpA1475kyVC283q2+GT+NjpmHY
	 eVx/C4ERZfbZLqSDT2Oiny1TsYgz9lbC+QXZrOiwdAzawH/1im3bVGWaRZP2Bx+QaC
	 K5tltOLDciiX4K4hvvng7xyYpcnQ/Y08kuvBg0XwmU5w4b8uc5e2fvJ/QwgFRmrIhP
	 hGr/hhe7/jnbJ+ucWH/fI8M68Wh4mMXY65Zv1EmZ+oMar6EwWkJjgGtEz9Sgr72waz
	 /hGybgl8zG9Zg==
Message-ID: <sashiko-outbox-210368@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 25/27] ext4: add KUnit tests for fs/ext4/move_extent.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-26-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-26-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:36:36 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] ext4: 64KB page failure in test_mext_check_adjust_range()
- [Medium] ext4: sub-folio dirty buffer -EBUSY in move_extent-test.c on
  >4KB pages
--

commit abdff1b8eb818ad1bc77ee7f502a090b450df395
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/move_extent.c

This commit adds a KUnit test suite covering lock ordering, validity and
range checks, and extent swapping in fs/ext4/move_extent.c.

> diff --git a/fs/ext4/move_extent-test.c b/fs/ext4/move_extent-test.c
> new file mode 100644
> index 0000000000000..e29a392eeebe3
> --- /dev/null
> +++ b/fs/ext4/move_extent-test.c
[ ... ]
> +static void test_mext_check_adjust_range(struct kunit *test)
> +{
> +	struct mext_test_ctx *ctx =3D mext_setup_ctx(test);
> +	struct inode *orig =3D ctx->orig_inode;
> +	struct inode *donor =3D ctx->donor_inode;
> +	__u64 len;
> +	int ret;
> +
> +	/* Sub-page block alignment check when blocksize (1024) < PAGE_SIZE */
> +	orig->i_blkbits =3D 10;
> +	donor->i_blkbits =3D 10;
> +	i_size_write(orig, 32 * 1024);
> +	i_size_write(donor, 32 * 1024);
> +
> +	len =3D 4;
> +	ret =3D ext4_mext_check_adjust_range_test(orig, donor, 1, 2, &len);
> +	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
> +
> +	len =3D 4;
> +	ret =3D ext4_mext_check_adjust_range_test(orig, donor, 1,
> +						1 + (PAGE_SIZE >> 10), &len);
> +	KUNIT_EXPECT_EQ(test, ret, 0);
> +	KUNIT_EXPECT_EQ(test, len, 4ULL);

[Severity: Medium]
Does this sub-page alignment check fail on kernels with 64KB pages?

With i_blkbits set to 10 and i_size set to 32KB, donor_eof is 32 blocks,
while donor_start =3D 1 + (PAGE_SIZE >> 10) evaluates to 65 when PAGE_SIZE
is 65536.  mext_check_adjust_range() sees donor_eof <=3D donor_start, clamps
*len to 0, and returns -EINVAL instead of 0.  Sizing orig and donor
relative to PAGE_SIZE (for example, max_t(loff_t, 32 * 1024, 4 * PAGE_SIZE))
would avoid this.

[ ... ]

> +static void test_move_extents_written_copy_data_and_split(struct kunit *=
test)
> +{
> +	struct mext_test_ctx *ctx =3D mext_setup_ctx(test);
> +	struct inode *orig =3D ctx->orig_inode;
> +	struct inode *donor =3D ctx->donor_inode;
> +	ext4_lblk_t lblk;
> +	__u64 moved_len =3D 0;
> +	int ret;
> +
> +	/*
> +	 * orig:  [0, 6) written -> pblk 400..405, uptodate folios pre-filled
> +	 * donor: [1, 2) written -> pblk 501, [2, 3) hole,
> +	 *        [3, 5) unwritten -> pblk 503..504
> +	 *
> +	 * Moving [1, 5) exercises MEXT_COPY_DATA, left/right extent splits on
> +	 * orig, donor hole skipping at lblk 2, written preservation on orig,
> +	 * mark_unwritten=3D1 on donor, and page cache data preservation.
> +	 */
> +	i_size_write(orig, 6 * MEXT_TEST_BLK_SIZE);
> +	EXT4_I(orig)->i_disksize =3D 6 * MEXT_TEST_BLK_SIZE;
> +	i_size_write(donor, 6 * MEXT_TEST_BLK_SIZE);
> +	EXT4_I(donor)->i_disksize =3D 6 * MEXT_TEST_BLK_SIZE;
> +
> +	mext_insert_extent(test, orig, 0, 6, 400, false);
> +	mext_insert_extent(test, donor, 1, 1, 501, false);
> +	mext_insert_extent(test, donor, 3, 2, 503, true);
> +
> +	for (lblk =3D 0; lblk < 6; lblk++)
> +		mext_populate_folio_block(test, orig, lblk, 0xA0 + lblk);
> +
> +	ret =3D ext4_move_extents(&ctx->orig_file, &ctx->donor_file, 1, 1, 4,
> +				&moved_len);
> +	KUNIT_EXPECT_EQ(test, ret, 0);
> +	KUNIT_EXPECT_EQ(test, moved_len, 3ULL);

[Severity: Medium]
Does ext4_move_extents() fail with -EBUSY here when PAGE_SIZE > 4096?

With a 4KB block size on 16KB or 64KB page kernels, logical blocks 1 and 3
share folio 0 in orig->i_mapping.  Moving lblk 1 via MEXT_COPY_DATA calls
mext_folio_mkwrite() -> block_commit_write(), which attaches buffer_heads
to orig's folio 0 and marks lblk 1's buffer dirty.  After skipping the
donor hole at lblk 2, mext_move_extent() tries to move lblk 3..4 in the
same folio and calls filemap_release_folio(folio[0], 0) ->
ext4_release_folio() -> try_to_free_buffers(), which refuses to drop the
dirty buffer from lblk 1 and aborts the move with -EBUSY and moved_len =3D =
1.

Similarly, in test_move_extents_unwritten_orig_and_ebusy(), moving
lblk 0..1 leaves dirty buffers on orig's folio 0 when PAGE_SIZE >=3D 16384,
so the subsequent move of lblk 2 fails filemap_release_folio() on orig
before reaching the PG_checked donor_folio under test.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D25
