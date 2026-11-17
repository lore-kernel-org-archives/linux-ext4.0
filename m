Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794895242;
	b=jZqocj6NHIM0ExOqa6WG12tl8lgZIuPNCP9E1vIla4Vn9G1IkK4KZE1z0ZRL+3P7lIEb
	 OKNABk2EnYL9R4rJXZtVN82NvL7tnLoDsdjVPF2IyL0AwmSIyVyeJ0Yj2zBYYVi1jBpQa
	 XbI8OU5o6PcpithBc8nsrNTAxCTJIEzczKXPJ6auKOboGoCvakKEScynlTqIZaltZguGd
	 53SmsCPuHKUts4NaGyyx5S3FHirATw1B4zCSpvd35qrTqCAayiiEVR9GiHMOBK7zEVkxF
	 gzdW8UC8rYyTD/U29weVmlMohDvxn7K9BIM/09WL1KS3FMDh7kYHGJbm7XewLXSVjXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794895242;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2dgNO4Uonv0vHthhyH5e1NUiAWBeS5iI8+TsutKNeHQ=;
	b=SZZ4sKwQhZs/tYmInyajWsWhLATTEorYU9elAPWwoICeCqDhFo0CCtYswVKfp2YeVBN5
	 sVU6fCYWrgvdSzfxpChNioJmsdx6ebfUxuBOXPVL3D1yceGuoiaPxfUyTKygTyc7TKvlN
	 ATXO23+Ro4P4zFT9adJPHd9vtsXY65xFs9st3U492RKw7y8mzivaIiL1qjXC72mnuSSUp
	 eBjiIuTtm1Fh6o+fw4JoMUNqnCoTM1ZXU7wDeay+GmS5qRE9repc9hpPHZAyqrVVk2/sz
	 XArFsi0YcxlFKuy0Pl62O6rcdmrO5JhZt51Ueg+4qw5NUueJ4ZhAX93xZDNHNEakJ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nUj79mXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06991606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 06:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nUj79mXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF0A1F000C4;
	Tue, 17 Nov 2026 06:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794895241;
	bh=2dgNO4Uonv0vHthhyH5e1NUiAWBeS5iI8+TsutKNeHQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nUj79mXNt87Mp6AKu+K9EFhMkX+T3gMBwjde/K6VdFJgB+0aTixp0j6IA51FfnNne
	 81MJZWdzmhvuvo6i6snPtFkeLnXVb7t8l0IScWGNWVp9e287yVGgRPORDLw/VKO+7C
	 0KYkFTVBbhnDQ1z3C5dW2JwCxzhlKXLyBlyLV3Cpy6J2soeQlHFntaXiCOQ06m2N4+
	 rDY4btgEqyxq8/lXps+Yc8RuYpnLm9cttHh1G3EQPpHQrcr2mdZlZzi7whUDfoeLMh
	 Pcs5DYkbmX5ylIyUOKCsndRMwpxMe2Z3HUuV5ka82UZ+896/ZKdzBUR7112qE4nrNh
	 92Ycd+bolOOCw==
Message-ID: <sashiko-outbox-218234@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] ext4: reserve quota credits in
 swap_inode_boot_loader()
Reply-To: sashiko-reviews@lists.linux.dev
To: "William Chuang" <founder@logarcheon.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261117052750.2955-2-founder@logarcheon.com>
References: <20261117052750.2955-1-founder@logarcheon.com>
 <20261117052750.2955-2-founder@logarcheon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 06:00:40 +0000
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
- [Critical] ext4: missing inode_bl type check in
  swap_inode_boot_loader() [1]
--

commit bcadebc925a37de0440a70c290c23f8fd547aadb
Author: William Chuang <founder@logarcheon.com>

ext4: reserve quota credits in swap_inode_boot_loader()

This commit reserves quota transaction credits in
swap_inode_boot_loader() to prevent running out of journal credits when
updating quota information during EXT4_IOC_SWAP_BOOT.

> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index e8e579498c990..ae03eb834c7ac 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -425,7 +425,12 @@ static long swap_inode_boot_loader(struct super_bloc=
k *sb,
>  	truncate_inode_pages(&inode->i_data, 0);
>  	truncate_inode_pages(&inode_bl->i_data, 0);
> =20
> -	handle =3D ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS, 2);
> +	/*
> +	 * Two inode table blocks, plus one quota block per quota type for
> +	 * the dquot_free_space()/dquot_alloc_space() update below.
> +	 */
> +	handle =3D ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS,
> +				    2 + EXT4_MAXQUOTAS_TRANS_BLOCKS(sb));
>  	if (IS_ERR(handle)) {
>  		err =3D -EINVAL;
>  		goto err_out;

[Severity: Critical]
This problem wasn't introduced by this patch, but can a crafted
filesystem where EXT4_BOOT_LOADER_INO is a directory trigger a warning
and corrupt VFS state in swap_inode_boot_loader() [1]?

fs/ext4/ioctl.c:swap_inode_boot_loader() {
	...
	inode_bl =3D ext4_iget(sb, EXT4_BOOT_LOADER_INO,
			EXT4_IGET_SPECIAL | EXT4_IGET_BAD);
	if (IS_ERR(inode_bl))
		return PTR_ERR(inode_bl);
	ei_bl =3D EXT4_I(inode_bl);

	lock_two_nondirectories(inode, inode_bl);
	...
	if (is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)) {
		...
		inode_bl->i_mode =3D S_IFREG;
	}
	...
}

inode_bl is passed to lock_two_nondirectories() before its mode is
checked, which triggers WARN_ON_ONCE(S_ISDIR(inode2->i_mode)).  Then the
!S_ISREG() branch overwrites inode_bl->i_mode with S_IFREG instead of
rejecting it, changing the type of a cached directory inode in place.

[1] https://sashiko.dev/#/bug/linux-8cfc8e22-8259-4c89-8a8b-64c16e4481a5

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117052750.2955=
-1-founder@logarcheon.com?part=3D1
