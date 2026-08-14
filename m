Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5207543CE5E
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702171; cv=none; b=h1RDkhpuNOahSH0kAkNsKn2NrUvVc3nMLq/x850PpS8uzTTtQNHsjIOXI2ZvRxwMTJTA8+FBHdZb29KjDuUGHVd0aIjdMMPEDEV9bzhKMTcTvvOwguAnoKNp1cV/VaNWl4X8fac3IwHnX4958civx50JLQcAeEm6hJwd5PDESPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702171; c=relaxed/simple;
	bh=gomLP9GVMcGQXjv/xWZX0t7qanA1dtsxf1BS1Vx7pww=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nAtc4eXBDu4+4A7ZC1mtFXgE10CVHBssl9c51pgVn7x2we83xcApJE548qhZ5Y0J16z7k4C0EdQpr6CIIX1Sh0V4l/LcyqEfcRgKgbpSp1EvSbC4a0h7fdcbs/sgjaNeRactMENd0sxRjQs8y1AOZdPn2yvFPcZwUG3zjA0hMU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mhe5LHFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mhe5LHFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2301F000E9;
	Fri, 14 Aug 2026 10:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702158;
	bh=QBUric2P4uOCpeVpB+nulrpRVfaQWNA+qqzOaENSjf8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mhe5LHFsQ/HbD0H0s0eehRtiHMByYSw532c+xgT0+50434uYM3UuTKLkyLK5XNwdO
	 5WsMh+uKCTouLbNjG6rmIfn2PqZ0w8zitRAjPT49TTukKYqNkpokDOktH0xd8i97HT
	 qICkZarEXaaHLaKSgRTKmfATjYRd8LluAoc9okKD3aSob2tvr7jIB6FG5lwTtPisel
	 6Tqqyrqe0gZVw6/ZUGlW1llizsbSZ6h4ZUDSCAeJ9GHivPwJZ1AEOpCBWMVaveH5rj
	 RuoReqmCZg5FGJWh6+gAyfl/ti358Hy25o5eP3PIeWKWmwDCLiPNXDo8CWAWvbj5ar
	 5gNZmfhwXNj5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 19/32] ext4: tolerate unexpected holes in
 ext4_convert_unwritten_extents()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814093331.1703882-20-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-20-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:09:17 +0000
Message-Id: <20260814100917.CB2301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] The patch masks a severe physical block Use-After-Free that ca=
uses silent data corruption by suppressing the warning when IO completion o=
bserves a hole.
--

--- Patch [19]: [PATCH -next v5 19/32] ext4: tolerate unexpected holes in e=
xt4_convert_unwritten_extents() ---
commit 024b041d5cfa7f6f30a260ff0a2a3cd17336e881
Author: Zhang Yi <yi.zhang@huawei.com>
Subject: ext4: tolerate unexpected holes in ext4_convert_unwritten_extents()

This patch suppresses the warning in ext4_convert_unwritten_extents() when
ext4_map_blocks() returns 0 (indicating a hole). It aims to handle the case
where a punch hole operation races with writeback when folio sizes are larg=
er
than the block size.

Link: https://lore.kernel.org/linux-ext4/a638a8fb-c184-4069-ae33-379ec12cd5=
14@huaweicloud.com/

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c

[ ... ]

> @@ -5166,19 +5166,21 @@ int ext4_convert_unwritten_extents(handle_t *hand=
le, struct inode *inode,
>  		ret =3D ext4_map_blocks(handle, inode, &map,
>  				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
>  				      EXT4_EX_NOCACHE);
> -		if (ret <=3D 0) {
> -			/*
> -			 * If the ret is zero, an unexpected hole may cause
> -			 * conversion to fail.  To avoid data loss during I/O
> -			 * end conversion, skip the hole and continue
> -			 * converting subsequent blocks.
> -			 */
> +		/*
> +		 * A return value of zero means an unexpected hole was found.
> +		 * This can happen when writeback races with a concurrent
> +		 * punch hole in the iomap path. Because iomap may not create
> +		 * ifs for folios larger than block size, the dirty bit can
> +		 * be set again after punching. If writeback happens between
> +		 * partial folio invalidation and extent removal, a hole is
> +		 * observed at I/O completion.
> +		 */
> +		if (ret < 0)
>  			ext4_warning(inode->i_sb,
>  				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
>  				     inode->i_ino, map.m_lblk, map.m_len, ret);
> -		} else {
> +		else if (ret > 0)
>  			conv_blocks +=3D map.m_len;

[Severity: Critical]
Does masking the ret =3D=3D 0 case here hide a physical block use-after-fre=
e?

If background writeback via ext4_iomap_writepages() submits a write bio for
the dirty folio, and a concurrent ext4_punch_hole() removes the extent, the
physical blocks are freed.

Since JBD2 does not wait for this in-flight bio during transaction commit
(due to data=3Dordered mode being disabled for iomap inodes), those blocks
return to the free pool and can be reallocated to another file.

When the in-flight write bio finally completes, will it silently overwrite
the newly reallocated blocks and cause data corruption?

Instead of silencing the warning during IO completion in
ext4_convert_unwritten_extents(), could the underlying race be prevented by
ensuring sub-folio dirty state is properly tracked so that punched blocks
are not submitted for writeback in the first place?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D19
