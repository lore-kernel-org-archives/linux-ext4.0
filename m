Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376603;
	b=uSZTMRSFE+LB02ZniPo2bI98qcT6wYoY8wpqW83WoUcI3TbTsI+hCc/ALv8jvM5ryrNs
	 M4cGA/ZvbjGjMR8vPrEdwGOFYxOLD6fqsO0AAhnq8qaFp7Ue0rtYlSEGvngL91Ono9fFP
	 tLTCL99Z1DrIWM2XsJ7fW380snprEvfFeT4isPlvsaqjrttQX0kaLAu8xLoeHCLTRwwU2
	 Xot++BaAhRZphWnMkadxhQvuqeTMAAJuqg1En2SFJSEeZMpkgPb0QFyGtsHwiO+0CY2T3
	 G3BhwYlDj0ryP53Fo7i7cA+44mRPJ+CRm+TFOnSDKZTfGjBEOsuP7rPBOZzShkjCqfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376603;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=W80RP8FoHcI+JtK0co8C0FcIxUgtBISIXczR1g6Mk8A=;
	b=DxCMMoZ44jolOx9RN21kyW6mFYF1rFccW7beVCH/J3+349qNBfhK86uhUx6E4jh5QljE
	 6T3WHEQ53LFJCr4xfUy0agpOQLelhnHvQiXGB4wJgX0XuYuVmqSpdQX7a9B0HC7KH/hTD
	 UQ1G7Y3d41yd2laEvB9OFZqLLd+9KNggTYyKtUsQ3dQgkxXZ2u4JYBpo3jqNF1O/fKYWd
	 0SUH5cqN6bux3KPHdGR5MzpX1RE6w73/QJgGv4q1bnVj1OEcVKYo31OGrN7paSsEcLu08
	 Maa25aMX56MvYQlo5a8In99Ylf4ZRihpGCEkzKB9upDLKUFyaacuIjj6zre9YVhcooQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oz9Ftrt2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36D2606A332;
	Fri, 30 Oct 2026 16:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oz9Ftrt2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA371F0093A;
	Fri, 30 Oct 2026 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376602;
	bh=W80RP8FoHcI+JtK0co8C0FcIxUgtBISIXczR1g6Mk8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oz9Ftrt2DCKtVYEclvb2IsRVsVZY0+KLOxvclWtXQMyQkAc2/gr9d/pToHs7+DGSD
	 6QaBUMlIR5kFTl7XlSBE0o+nfLKzimy+hsd+qtIDOI3ThoAk0HUt8Cfmofb/3I8cBd
	 S7bFfYj5Zw6JrrYKw24Sqze4VYer6x/zxNqvyM+9iXMdiX7lC7YYr47CzmRa0ldb0x
	 NLewi3zJ9/UYqMrg1QDri/X9tBEtDWCxZzMDZVqY+u6+5vV5z8CCgm3DqM2A8OMwHV
	 nH6lkHTv4tiKlb9q69Y3HR7qFyZJs3b5eL/s+fHMxOiIiLPNmDEamztcGjWBJAjK3u
	 ic88NhQqJjWdA==
Message-ID: <sashiko-outbox-191235@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/34] hpfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-16-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-16-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:01 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] hpfs: remount rw after error succeeds and writes spare block in =
mark_dirty()
--

commit 1e8d846622af872ec2aab29caf0990fcc20ac2f2
Author: Christian Brauner <brauner@kernel.org>

hpfs: don't set SB_RDONLY after filesystem errors

This commit updates hpfs_error() to call sb_set_emergency_ro() instead of
setting SB_RDONLY directly once SB_BORN is set, avoiding a hang in
thaw_super() when an error occurs while the filesystem is frozen. It also
updates hpfs_trim_fs(), hpfs_lookup(), hpfs_map_dnode(), and unmark_dirty()
to check sb_emergency_ro().

> diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
> index 8fbdbf0806276..ab89e624cd517 100644
> --- a/fs/hpfs/super.c
> +++ b/fs/hpfs/super.c
[ ... ]
> @@ -81,7 +81,14 @@ void hpfs_error(struct super_block *s, const char *fmt=
, ...)
>  			else {
>  				pr_cont("; remounting read-only\n");
>  				mark_dirty(s, 0);
> -				s->s_flags |=3D SB_RDONLY;
> +				/*
> +				 * Before SB_BORN the mounter holds s_umount,
> +				 * later see sb_set_emergency_ro().
> +				 */
> +				if (s->s_flags & SB_BORN)
> +					sb_set_emergency_ro(s);
> +				else
> +					s->s_flags |=3D SB_RDONLY;

[Severity: Medium]
When a runtime error occurs on a read-write mount after SB_BORN is set,
hpfs_error() calls sb_set_emergency_ro(s) without setting SB_RDONLY in
s->s_flags, leaving sb_rdonly(s) false.

If userspace then attempts to remount read-write (or reconfigures mount
options without SB_RDONLY), reconfigure_super() in fs/super.c checks:

	remount_rw =3D !(fc->sb_flags & SB_RDONLY) && sb_rdonly(sb);
	remount_ro =3D (fc->sb_flags & SB_RDONLY) && !sb_rdonly(sb);
    ...
	if (remount_rw && sb_emergency_ro(sb))
		return -EROFS;

Because sb_rdonly(sb) is false, remount_rw evaluates to false and bypasses
the -EROFS check. reconfigure_super() then proceeds into hpfs_reconfigure()
in fs/hpfs/super.c:

	if (!(fc->sb_flags & SB_RDONLY)) mark_dirty(s, 1);

	hpfs_unlock(s);
	return 0;

And mark_dirty() in fs/hpfs/super.c checks:

	if (hpfs_sb(s)->sb_chkdsk && (remount || !sb_rdonly(s))) {
		struct buffer_head *bh;
		struct hpfs_spare_block *sb;
		if ((sb =3D hpfs_map_sector(s, 17, &bh, 0))) {
			sb->dirty =3D 1;
			sb->old_wrote =3D 0;
			mark_buffer_dirty(bh);
			sync_dirty_buffer(bh);
			brelse(bh);
		}
	}

Unlike unmark_dirty(), neither hpfs_reconfigure() nor mark_dirty() checks
sb_emergency_ro(s).

Does this allow a read-write remount or reconfigure after an error to
succeed and synchronously write the spare block at sector 17 via
mark_dirty()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D16
