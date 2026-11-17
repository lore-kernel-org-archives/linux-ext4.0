Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794955990;
	b=qFSINagW5OCZ7GGayx/D/qDUhLPHqJyEU/H2ZQ2/csmhKLvoMqpDzChjl7jP9jOrAhh8
	 oawNnPHGypXnL/ICNAnHro1z10/3tIKDduRhqqOCZOWGVP/mawpgvCRmZ73eOCmSw2nTp
	 oXwiFXogDR0LsjwgA76PExTZ3LzxolHieuTLnd9s+KnnXrvrFeeDLnjdH+054M4aDmBSO
	 ivcJWXdDwupDKSTz/W4D7WTydMbsfa5sre5ohQXUtqDdMUjWtRr4dzrwbMZWD49ZgmdVu
	 8XvnqwDeHaERtZLCjXGQksg74bSxta82Cd+RN5uQGtXO6RgbiM067BPm/4Hg8fv91sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794955990;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f1lrv79m3Xc7cMj+HW0nyjesz5qdPr309hMVvc6Q8M4=;
	b=YCE6R1XWRIUU/+jIlnQvviyO1muWunsEliiOr/yYdzVIePNpHpPck9gZG4tTvN8yl64a
	 F6eQ0guuLxBF7pq9OiF3MhS3JU5y2P9/f2vzsBdGCuZuPEcG3GlyYLN1xWXIb7FIb077Y
	 HJBk+NPfT1wETb6ONwtude/Fev3rM3uTixYJTllj0P6+RvVVPiIDNjE0IbdCmHX3/n17v
	 L9EY5q3RdcFiBaFwpSxzbyceXYNXpOwoscPhiAh6QeaKhXCt8SL3kHsj/U/+jNBSBrFHE
	 OnEHlm1zrY1fuD1WKwWdXoFnjf9ES3sWfoE7gOIlg65pf/awWCTody9oHe0ZYxptR+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwr7Cv42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE75606A330
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 22:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwr7Cv42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463541F000C4;
	Tue, 17 Nov 2026 22:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794955989;
	bh=f1lrv79m3Xc7cMj+HW0nyjesz5qdPr309hMVvc6Q8M4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hwr7Cv42iNICCm4atdsV2wymJxYyPXRqcgqczZySzmuJwDHlFWgG19E0Y5zOOnw8S
	 k792QdTjCWVTr6y9ZTygCHA5LoXpPlLU1R0V1SdJ3zkyijoP+9FtYGB0dFArv6N1+w
	 XaM9fAVK/kPSfOQesckBWD46z+HDqHz5Z+vTiEhcYwqrjhxVedYz1X8XIY4SCePrHa
	 iOZpN6MHe3vOV5O+K2QiOAHo9vH+PE0RuLNjvnbdsmUT++fgRRFLBuq9BP5OIzWtN5
	 rV2FzfgBsrsuPg91v50QtIJDCx5oXy1qB3IXAdYAhBc/sxYQi9C8RtYOQelgU/z/BI
	 u34i+dqzY0Ipg==
Message-ID: <sashiko-outbox-219766@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: reject a non-regular boot loader inode in
 EXT4_IOC_SWAP_BOOT
Reply-To: sashiko-reviews@lists.linux.dev
To: "William Chuang" <founder@logarcheon.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261117223350.6920-1-founder@logarcheon.com>
References: <20261117061822.3826-1-founder@logarcheon.com>
 <20261117065645.4409-1-founder@logarcheon.com>
 <20261117223350.6920-1-founder@logarcheon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 22:53:08 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> swap_inode_boot_loader() gets the boot loader inode (inode 5) with
> EXT4_IGET_BAD.  On a new filesystem that inode is unused, its mode is
> 0, and ext4_iget() returns it as a bad inode, which make_bad_inode()
> sets to S_IFREG.  On a corrupted or crafted filesystem, ext4_iget()
> can instead return inode 5 as a directory or another non-regular type,
> fully set up with that type's inode and file operations.
>=20
> Such an inode is first passed to lock_two_nondirectories(), which
> warns if it is a directory:
>=20
>   WARNING: fs/inode.c:1271 at lock_two_nondirectories
>    swap_inode_boot_loader
>    __ext4_ioctl
>=20
> The "never used as a boot loader" branch then sets inode_bl->i_mode
> [ ... ]
> Fixes: 991ed014de08 ("ext4: fix bug_on in __es_tree_search caused by bad =
boot loader inode")
> Suggested-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://lore.kernel.org/all/tencent_DABB2333139E8D1BCF4B5D1B2725FAB=
A9108@qq.com/T/
> Link: https://sashiko.dev/#/bug/linux-8cfc8e22-8259-4c89-8a8b-64c16e4481a5
> Signed-off-by: William Chuang <founder@logarcheon.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117223350.6920=
-1-founder@logarcheon.com?part=3D1

