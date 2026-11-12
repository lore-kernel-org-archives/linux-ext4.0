Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457285;
	b=Ru9xYk7iHUo/7uKfP2qmMPBmaF2V1/aadosZRnnDM0DYtfTS+UfZJsRhYMpZL9KAzWX2
	 u6mBghlWpCkSMZXw02zAPAHKFHCL47k4dgn4DnNGyDeg6YWrxM0yw5TqzVbRklPzlzny0
	 VSEUPQoMPUkETeYOxV0E+CSfsTmj2emE1UP7VanxKnS2Q34JBhEVYbZmLmL2XFn2VNWTB
	 Zg34+2Z9GYEAREe+0h5Wk1zc+gIbrgo3O8GWqohRs3uA9R69mD9H0Foaz8Unsph55kapF
	 js1HS768E6fu42jy31lpet0wnxjTQgxNcBZwnb8/7jXmZI3GW1o/MMYzQRj58h3b1EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457285;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=X64UwcY//X+Uyursm8BW8LkuDX5odxwlqUFpdTlKvXE=;
	b=YJ8N0/qWwKxeBrYcGx1+rv+zyUERIpqUJi/IiryFe+qY/zVx0ALLGrm864/y2J3bPlP7
	 BGaeNYuq0qz6g9iKd9MeY4HyDhtc65ZIamVO4DRA71nJyXKbcWk7zO67Sqnvdi6Nttr+h
	 afRVtOThgGTDwh3hkisGrCxGbPqOUZKx6YlTJd+k/AFz0RAiV2Lppu8jN4RgnkPpdyBjJ
	 ojfLx0aRXSFV1T1F8EdPlHSuG2pmdWiitdO2jxnd9mBPR4jRtqprdq0gdaGYVirGYNp+n
	 fbtGSfZ72hahdi/+mJeJk5HiID9ng0q0exHUUNbtmfKYQ2GpnvqsmUbGr1PdXaswfqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ka8suLzA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995F1606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ka8suLzA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133EA1F00A05;
	Thu, 12 Nov 2026 04:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457285;
	bh=X64UwcY//X+Uyursm8BW8LkuDX5odxwlqUFpdTlKvXE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Ka8suLzA41B0FC6gyQdIS4hS+P15qeK4iPjoE6cC8dRu3VdrAR0LysMmBjNZo2QSN
	 t6GLj2exqllrmAmZi9rbVcWQqTcRI+0wf/njKDQ9NeokYmLG+UcZBO0BsDKQW6/UDW
	 MnmpHKA9wrcZa7n6dBoy/XmG87jDvwdwwW4PnlNo+TvIIx4U4FbFMw6vVQH2ZE5xtd
	 HHN82pmpfnMv+G/334aknxX5hfCiTAr+kwK79zH7NMDZ/7sPgERFGEpxZrU5dxsIo9
	 W0ORZspfczJVlgglBMfeVQ9OFyPnj7/e8AnD3f0sLKhyhFpDFDWgBsNMP0LITQDkI0
	 +a0SnPUL3Ae5A==
Message-ID: <sashiko-outbox-210330@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/27] ext4: add KUnit tests for fs/ext4/namei.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-6-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-6-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:21:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] ext4: out-of-bounds read due to missing dx_entry validation in
  ext4_htree_next_block() [1]
--

commit 2ae6fd1b46635dda6b69ee78cd382ff9c0d0450a
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/namei.c

This commit adds a KUnit test suite for directory lookup, HTree indexing,
and namespace operations in fs/ext4/namei.c, and exports the internal
HTree definitions and helper wrappers needed by the tests.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a6386c1d237f1..63d01a9711a27 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -4249,3 +4103,159 @@ const struct inode_operations ext4_special_inode_=
operations =3D {
>  	.get_inode_acl	=3D ext4_get_acl,
>  	.set_acl	=3D ext4_set_acl,
>  };
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_special_inode_operations);
> +
> +#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)

[ ... ]

> +int ext4_htree_next_block_test(struct inode *dir, __u32 hash,
> +			       struct dx_frame *frame,
> +			       struct dx_frame *frames, __u32 *start_hash)
> +{
> +	return ext4_htree_next_block(dir, hash, frame, frames, start_hash);
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_htree_next_block_test);

[Severity: High]
This problem wasn't introduced by this patch, but can
ext4_htree_next_block() read out of bounds past bh->b_data [1] when
loading a sibling interior dx_node block?

fs/ext4/namei.c:ext4_htree_next_block() {
	...
	while (1) {
		if (++(p->at) < p->entries + dx_get_count(p->entries))
			break;
		if (p =3D=3D frames)
			return 0;
		num_frames++;
		p--;
	}
	...
	while (num_frames--) {
		bh =3D ext4_read_dirblock(dir, dx_get_block(p->at), INDEX);
		if (IS_ERR(bh))
			return PTR_ERR(bh);
		p++;
		brelse(p->bh);
		p->bh =3D bh;
		p->at =3D p->entries =3D ((struct dx_node *) bh->b_data)->entries;
	}
	return 1;
}

Unlike dx_probe(), which checks dx_get_limit() against dx_node_limit() and
verifies that dx_get_count() is non-zero and within dx_get_limit(),
ext4_htree_next_block() assigns p->entries directly from bh->b_data without
validating the new node's count or limit.  If a corrupted interior node has
an out-of-bounds count (for example, when metadata_csum is disabled or
buffer_verified(bh) is already set), later calls to ext4_htree_next_block()
advance p->at up to p->entries + dx_get_count(p->entries) and dereference
it via dx_get_hash() and dx_get_block(), reading past the end of bh->b_data.

[1] https://sashiko.dev/#/bug/linux-c6639d9a-25ec-49eb-a6a4-468135552f9a

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D5
