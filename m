Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794897833;
	b=MIAANvu4ZUet/GelPTHRZhA0f14iLRSzNBO9OhD0hAybjaLEkCwr056vkSPCWQnXC4Jk
	 4umsn+koB666cUX7VBe7GmRo/FBINMXClXb1cIkJwGAASjq1x0g35tud47xtHlDK4GDVz
	 e8Ssg8JaKH6pxJhmUCxSflcQTqUXBlt0iWsn5wS4BarSThTcTSxsaaNkvkcteB/m0wHu2
	 1HKCfmOfE6SEjv9vsnD9JbRKV5fNw3koTeFRu7vzgKcju9+DPrmee9YNZ8WitiLvSpp/b
	 2S2cVybOUrUE2oK503ZnZ6i7sPY4fdQocuZzQwkxDFGgC2uMwvt6PGdRGladUdTNdZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794897833;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FfhjyB5RIiatD0P/QADHmPIIhktXBjIqOrPO1QgRqko=;
	b=lXMIvAXn2S0dkrt9HUkfUwNd/EZTNv4Iaq1desre3ctl3f1MnVonH9p+UXI1nB25jQdS
	 JoY2xDtTSpEJ2GSCBUWjivYaVd79XTolqkKu6Sfod8zrLuR3pNy3eSP5L/dm2MWE4wC7l
	 VImBO16Klk1ptgo36AxxTGV4vYdyOEs4sFl3RelxbIJl2Bq5A6lRZ4Wl78rha7LAHupsm
	 g0SvQDfHW+WQM55MVSYbxOjUQL+ZINGr6bigRCxY3p/a+4yuPQalora5VSA6rlJJabX8D
	 mEIv59n2lq3RhNyPKThtVdCfnLmwFFUhaq0sdaZXQXsdAkSbJYUFNhOeNyL7ONJxE9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AXwe4NGc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3B606A323
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 06:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AXwe4NGc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B180A1F000C6;
	Tue, 17 Nov 2026 06:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794897832;
	bh=FfhjyB5RIiatD0P/QADHmPIIhktXBjIqOrPO1QgRqko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AXwe4NGcQELIow+fhaWEbBz8trMOYFc+YOpoYwyZHC3H0xkwyrYAHgyN96g0awIYb
	 j0CUlijQyfHjtjMwAxgb+47TGNpe3XizOQZzLpg3Y1WghiTjp0vtJUJK00Cy+Q0nQI
	 PFyqC4IVW6QLEsrfoL7qk7rYBkJMFB5AkA/IutmSzmUfQBvkLjw1hsjP+uzuSZVmfA
	 7GxLq1TIQgfaGo9qPKyfdQ/Njr4wGiEV52xgD5uGRCpNp4+p3GCQn4D4/xxE18aRbS
	 RRioCqA5g5ZEtloMC0qlgsaZyy9hYfp3KNwts/UkRwULsD93ZX+YQVOGnQ0K0OHzRU
	 9QhPHP7WsdjAw==
Message-ID: <sashiko-outbox-218276@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: reject a non-regular boot loader inode in
 EXT4_IOC_SWAP_BOOT
Reply-To: sashiko-reviews@lists.linux.dev
To: "William Chuang" <founder@logarcheon.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261117061822.3826-1-founder@logarcheon.com>
References: <20261117061822.3826-1-founder@logarcheon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 06:43:52 +0000
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
- [Medium] ext4: missing make_bad_inode() before iput() in
  swap_inode_boot_loader()
--

commit f760f0ea1cf04164f03ebca7f4659e4130a0b1ed
Author: William Chuang <founder@logarcheon.com>

ext4: reject a non-regular boot loader inode in EXT4_IOC_SWAP_BOOT

This commit rejects a boot loader inode (inode 5) in
swap_inode_boot_loader() with -EFSCORRUPTED if its mode after ext4_iget()
is not S_IFREG.

Link: https://lore.kernel.org/all/tencent_DABB2333139E8D1BCF4B5D1B2725FABA9=
108@qq.com/T/
Link: https://sashiko.dev/#/bug/linux-8cfc8e22-8259-4c89-8a8b-64c16e4481a5

> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index e8e579498c990..cf005fe2da34f 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -390,6 +390,20 @@ static long swap_inode_boot_loader(struct super_bloc=
k *sb,
>  		return PTR_ERR(inode_bl);
>  	ei_bl =3D EXT4_I(inode_bl);
> =20
> +	/*
> +	 * An unused boot loader inode comes back from ext4_iget() as a bad
> +	 * inode, which make_bad_inode() leaves as S_IFREG.  Any other type
> +	 * means the on-disk inode is corrupted; its type cannot be changed
> +	 * in place below.
> +	 */
> +	if (!S_ISREG(inode_bl->i_mode)) {
> +		EXT4_ERROR_INODE(inode_bl,
> +				 "boot loader inode is not a regular file (mode 0%o)",
> +				 inode_bl->i_mode);
> +		iput(inode_bl);
> +		return -EFSCORRUPTED;
> +	}

[Severity: Medium]
Should this error path call make_bad_inode(inode_bl) before iput(inode_bl),
similar to ext4_get_journal_inode()?

__ext4_iget() exempts EXT4_BOOT_LOADER_INO from the i_nlink =3D=3D 0 check =
and
only marks it bad when i_mode is not a recognized file type:

fs/ext4/inode.c:__ext4_iget() {
    ...
	if (inode->i_nlink =3D=3D 0) {
		if ((inode->i_mode =3D=3D 0 || flags & EXT4_IGET_SPECIAL ||
		     !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) &&
		    ino !=3D EXT4_BOOT_LOADER_INO) {
    ...
}

When a corrupted inode 5 has a valid non-regular i_mode (such as S_IFDIR or
S_IFCHR) and i_nlink =3D=3D 0, __ext4_iget() returns a live, non-bad inode.
Under errors=3Dcontinue, iput(inode_bl) then enters ext4_evict_inode(), whi=
ch
only skips truncation and on-disk deletion when is_bad_inode(inode) is
true, causing it to truncate inode 5, dirty it on disk, and call
ext4_free_inode() on the reserved inode.  If i_nlink > 0, the corrupted
non-regular inode stays hashed in the inode cache instead of being evicted.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117061822.3826=
-1-founder@logarcheon.com?part=3D1
