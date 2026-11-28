Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795842540;
	b=cKACILPxDWPnqLz84kZBiNjadh9CwspFfWWAArdT+qn9p8kwPjyLeMgPUPwXuHqMtLiR
	 i2AoHNMDcuPyc1HXLri2i6j/R7wIai1a3rSf85cddCA0nI72f/uLO6t/0vX4vIj/COcOG
	 4OS2+nyUkUCvQ+3newpRa+Ko/4HmbvA6/TCG0sYeD5aukX48m+9GQCsiWdObB2euyG1l4
	 gA5ESYYa+zGiBhRUcj/sSM6p8dk2EfX69/Oik93YgfUiH5Sg50z20/dCabF4qADUe/b95
	 P/v8Npa+Mcu4BGtM8Y0hwI99fUT8GGz5cmgXb81SJ0Y8+DmW/Z1urG0Q/tQk+xfjMiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795842540;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0LVLOw4wgoLs5IkODAjSo4Eno4t8oX1HJVub9mXnceM=;
	b=vKvdLMgqFuvN4+RbrKlTGNYCTl0NyG2776ASfbeZW40Xj8le2a8+8Wz17E/Rp8uB0cuO
	 JhPJa1GiRuyYcQyF6VtsuO1M/QR1FDuxcPsNqIFAQXIramnPuwTRxDTwZOh+5MctLcn6T
	 BZHP2h76zxiznga7Aw7VnVvoJtkjMZEaaaWlnqlXTVa2q8Sek47feeRwOuy6vECgBdTPe
	 sggdQ/95N078r5NAK4yrHjAxzlpuq8rSmingsKN4+qKe8PgIwMehPWkN+ukan1kE9+pRd
	 lEORPw5Ojv+HgeeADoJ9loWEFqYTFMybLzdUglUGBUXa6LcRlbcDnwCHHTu7lXP6ydA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SWKp0i3K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D98606A31C
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 05:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SWKp0i3K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0FE1F0089A;
	Sat, 28 Nov 2026 05:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795842540;
	bh=0LVLOw4wgoLs5IkODAjSo4Eno4t8oX1HJVub9mXnceM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SWKp0i3KYKOWMKcIFC5edwGFm6fMjsN84OgSsZn8IFU+tVQw/EFSqP91H8gbmlW+p
	 DPMobbTAj4E0qNKApEezeLJr6zwrZpKlWyl3WuNWbhm2WRaASEldzasCQ4cXJcQ0I5
	 cWQCHAjrFY1iN701wxVHGn9XPCSrjUPxtgcARFGzAjbTvyloQS8C6iQ902lxGXr0Qw
	 x/WdfBFuIty1yWuiV4uLiTExDgNi5CpYp6Byl1SxMDewF5PgVv3C97SDGnG12omqbt
	 0AEeJWNO8RbZ3017p5aaWaJpyZIkkHwuee8NsZX8lsFpk57lxmzWRpCsc9VgsJ4RGr
	 24zVt/46TIZnA==
Message-ID: <sashiko-outbox-238466@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: validate directory entries before rename
Reply-To: sashiko-reviews@lists.linux.dev
To: shaos <shawnq1@163.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261128045214.2649994-1-shawnq1@163.com>
References: <20261128045214.2649994-1-shawnq1@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 05:08:59 +0000
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
- [High] ext2, ufs: i_nlink underflow in ext2_rmdir() and ufs_rmdir()
  [1]
--

commit de08d578a699530700ffcced108cd1f48e146ca0
Author: shaos <shawnq1@163.com>

ext2: validate directory entries before rename

This commit validates the '.' and '..' entries in ext2_dotdot() and checks
that '..' points to old_dir in ext2_rename() before updating directory link=
s.

> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index bfb6a463a95e0..a5b5aff1cfb45 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -350,6 +350,12 @@ static int ext2_rename (const struct mnt_idmap * idm=
ap,
>  		dir_de =3D ext2_dotdot(old_inode, &dir_folio);
>  		if (!dir_de)
>  			goto out_old;
> +		if (le32_to_cpu(dir_de->inode) !=3D old_dir->i_ino) {
> +			ext2_error(old_inode->i_sb, __func__,
> +				   "directory #%llu has incorrect '..' entry",
> +				   (unsigned long long)old_inode->i_ino);
> +			goto out_dir;
> +		}
>  	}
> =20
>  	if (new_inode) {

[Severity: High]
This problem wasn't introduced by this patch, but can new_inode->i_nlink
underflow when overwriting an existing directory in ext2_rename()
[1]?

In the if (new_inode) block just below, overwriting a directory calls
drop_nlink(new_inode) followed immediately by
inode_dec_link_count(new_inode) (and ext2_rmdir() similarly calls
ext2_unlink() followed by inode_dec_link_count()):

fs/ext2/namei.c:ext2_rename() {
    ...
	if (new_inode) {
    ...
		if (old_is_dir)
			drop_nlink(new_inode);
		inode_dec_link_count(new_inode);
	} else {
    ...
}

On a corrupted filesystem image where a directory inode has an on-disk
i_nlink of 0 or 1, these two unconditional decrements wrap
new_inode->i_nlink to UINT_MAX, triggering kernel warnings and corrupting
inode lifetime tracking.

[1] https://sashiko.dev/#/bug/linux-218ca4cb-3bec-4504-bb15-b7247a83953c

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128045214.2649=
994-1-shawnq1@163.com?part=3D1
