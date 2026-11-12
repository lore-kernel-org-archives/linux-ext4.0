Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443210;
	b=gIUgsxMxOXUSIubeHHQGXgTq3FKRAhvqE96avxTfLrOkrWVnKxGveyhNVE3SxrUZyGDh
	 lWh59S5VjdKLEiHC17HS2D6Vxg2xA1sQIvRbXss33uJVGMhhfTS2ojOmt2vbeDXU4qhGZ
	 p05nN8xdY+KMi2a8m9lRYU6VT8IQUm7s6Q9NBFyZ2QWlGsEdCcrbxcEhmfhcuMk3T1uwY
	 lPKo4ndcl8e95UGH83ueOmsXGj99Fw2qAmvQjbxhntM6X5/2Suzdojhmf5Gpg87eNxjnF
	 Fsj4H0h54R/rgFnn2VRjeDl4HbmqFC6LG+/w+o4o1bOH28XiKM2+9j3eCXuC8IX9c1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443210;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ENo42OiAYTs0oyFu33Aa0dfmE1oD4vQ+W8HQjmbg+2w=;
	b=gu/E2UuypIpPwyA1Ib/2tkZ3cN/AI0PRW6lgWwefPsq5JjL8lgNu8u+NOxmg/kuvkEro
	 YUM3p5WTeeErNXcgnPDtmBkRKv8QUF6djVknBM85xZgdMuZu71Kl4jR4USVKgA2E8HX9S
	 BAklPdSF075grcTXgGAEI0ATgcDY7kKNwhoTrXDfRqU4nGezcFsUJWf0A8Y/T2Lnm8MWe
	 danuJh4VmBau7WoCw9MbToh8KpcD/hlPEzLo8b89InGmog455DJ2el5cr1j0J5/xeF8fd
	 0ZkwRsqxtSt7J6Ly3yp2pewxN95GlFo/xCgc9SLZjdwc8NyZFECy/iydeZZPamTNr2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRe1wjjh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6216606A326
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 00:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bRe1wjjh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89971F00A06;
	Thu, 12 Nov 2026 00:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443210;
	bh=ENo42OiAYTs0oyFu33Aa0dfmE1oD4vQ+W8HQjmbg+2w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bRe1wjjhyn3XnzWj4OgZo5hKpJJWBofxQQM+Slv9jEltOe0GUWu8Xt9mDcG7G+QWJ
	 I8LCnf+67oetoCAOXTykwoYwEnFUwMchtpO32/HKfGL8ESZauaR8liClUPKithOIFp
	 2I6ne2UL4PAOG6K0DhKh6HLnBUFvm8sqsAIvz302cNSxpQB9Ci8ItgtKViA1+pPA7N
	 m1mH2pKzGLiPU5WNdEgqlgJLbq60M9/YnQp77tgqI4oU7CxmHbcQfTyZMp7WrB6eyA
	 DRAHnCvee46ehmkStMrB8Xk318+sLJ/6rOrGP2LZEnlPu1ijQ+fD5GFA/6c4cGiIdC
	 T255QMG1wpNEg==
Message-ID: <sashiko-outbox-209914@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] ext4: fix directory i_blocks after fast commit
 replay
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261111-ext4-fc-replay-mkdir-v1-2-4b20be29aed8@columbia.edu>
References: <20261111-ext4-fc-replay-mkdir-v1-0-4b20be29aed8@columbia.edu>
 <20261111-ext4-fc-replay-mkdir-v1-2-4b20be29aed8@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:26:49 +0000
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
- [High] ext4: missing EXT4_INODE_EXTENTS check before
  ext4_ext_replay_set_iblocks()
- [High] ext4: ext4_ext_replay_set_iblocks() drops directory xattr
  blocks in i_blocks
- [Medium] ext4: skipped dir i_blocks recount on -EEXIST in
  ext4_fc_replay_link_internal()
--

commit bd9227cad3ab9ec91535ca3b97b88447eed97729
Author: Mani Tofigh <mt4022@columbia.edu>

ext4: fix directory i_blocks after fast commit replay

This commit recounts i_blocks via ext4_ext_replay_set_iblocks() for newly
initialized directories and parent directories modified during fast commit
replay.

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0eac7be3f58c2..9c170986f0b21 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -1858,6 +1858,9 @@ static int ext4_fc_replay_link_internal(struct supe=
r_block *sb,
>  		goto out;
>  	}
> =20
> +	/* The replay allocator doesn't count blocks added to the dir */
> +	if (!ret && !ext4_test_inode_flag(dir, EXT4_INODE_INLINE_DATA))
> +		ext4_ext_replay_set_iblocks(dir);

[Severity: High]
Does calling ext4_ext_replay_set_iblocks(dir) lose external xattr block
accounting on dir->i_blocks?

ext4_ext_replay_set_iblocks() overwrites inode->i_blocks with only the
extent data and tree block count:

fs/ext4/extents.c:ext4_ext_replay_set_iblocks() {
    ...
out:
	inode->i_blocks =3D numblks << (inode->i_sb->s_blocksize_bits - 9);
	ext4_mark_inode_dirty(NULL, inode);
    ...
}

If dir already has an external xattr block (EXT4_I(dir)->i_file_acl) or
ea_inode blocks from an earlier transaction, replaying any link or file
creation in dir drops those blocks from dir->i_blocks.  Besides corrupting
on-disk i_blocks, later removing the directory or its xattrs frees
i_file_acl and underflows dir->i_blocks.

[Severity: Medium]
Does gating ext4_ext_replay_set_iblocks(dir) on !ret skip the i_blocks
recount if a previous replay crashed after __ext4_link() persisted the new
directory block and dirent, when the re-run of __ext4_link() returns
-EEXIST?

>  	ret =3D 0;
>  out:
>  	if (dir)
> @@ -2070,6 +2073,9 @@ static int ext4_fc_replay_create(struct super_block=
 *sb,
>  			ret =3D 0;
>  			goto out;
>  		}
> +		/* The replay allocator doesn't count the new dir block */
> +		if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
> +			ext4_ext_replay_set_iblocks(inode);

[Severity: High]
Can this (and the matching check in ext4_fc_replay_link_internal()) call
ext4_ext_replay_set_iblocks() on an indirect-mapped directory that does not
have EXT4_INODE_EXTENTS set?

A directory will lack EXT4_INODE_EXTENTS if the filesystem was formatted
without the extents feature or if EXT4_EXTENTS_FL was cleared on the
directory via FS_IOC_SETFLAGS in an earlier transaction.  During fast
commit replay, __ext4_iget() skips extent header validation, and
ext4_ext_replay_set_iblocks() calls ext4_find_extent(..., EXT4_EX_NOCACHE),
which reinterprets the direct block numbers in EXT4_I(inode)->i_data[] as a
struct ext4_extent_header and binary-searches past i_data[] into adjacent
slab memory or corrupts i_blocks.

Checking ext4_test_inode_flag(..., EXT4_INODE_EXTENTS) as
ext4_fc_replay_inode() does would avoid calling into the extent tree
walker on non-extent directories.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ext4-fc-re=
play-mkdir-v1-0-4b20be29aed8@columbia.edu?part=3D2
