Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376593;
	b=L4ey7Hs72Nn0LUMj7bp5Im3n+i9beKXQjEO7/rr49JfS5zsJcZWWWmkp26397gf/S9Kp
	 HynXM3ZjP3/0aVVzkeLM1nzOtA+kcAo12yjyZvuClKFkPpUNn9JCvndFSFEGk6zSMYyQX
	 4RYZsz8EXFnjost3WoHKW3qixPrK4ZSFD/zrN6P4/ZFnI9CTZVSUg1zOWCdi1Wfyh/fkr
	 85fOIBOz5lYNPGU8upard4xi9SsmmBs5hT+jouLfgZtFSO92EzJoaJ4jQmCQ/E81zUmZX
	 SwmW/tRUz79e2cLOCgOo4wmcy68tA5KgFLf18OTLYoDBIJxlzykOovUXgGObK1aiM4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376593;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2dFc8Ot80oApMbDR2tgbKCiRs0Ur7pPi8cDZxbTcx58=;
	b=iDlJqG1Nf39yp6iRd7qvwr+WfHM7GdHYRKLQgywCKOmbhVn/eGJPIggNmQIRXAje2EH7
	 5dvCHuIrA4LmN15BWoII5g4zn5h9p0Hz/OyXa0bCl7oMks7jMpJ42Ek52qVao08Fg5xJO
	 mciJp0MvlqQI5pgRfUdklVjuZgKfNiYQo5K5D5GgH54yOkGRvKCS7FJmAdMvVMUHdu8WP
	 S+tn1N761o5I+RH4YZ+tS1k7x57WFQxpP1nTzLnaHw0XsxxrI4ogc097g7fxc59SfwZFP
	 a5X7fOyFMOkzdiqEMSBrNk5zy5DLswIHGTysn3G5QcwcyBE02uSK8dRz/YNP45Y/wXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lTf12mwh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548DB606A333;
	Fri, 30 Oct 2026 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lTf12mwh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6618E1F00A1E;
	Fri, 30 Oct 2026 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376593;
	bh=2dFc8Ot80oApMbDR2tgbKCiRs0Ur7pPi8cDZxbTcx58=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lTf12mwhklBjlUqb3cRkM5KDg5S3wMQNXUK8Ps1PQrb4lDrPs+8SUUbNfVM9k60go
	 sq33nmWdNJP2/ooVyv/A8JtR7SqRH1xaFrIb1wTwPo6tno8R1kmwlWzPOuOQO/Wb36
	 OQY6IWhqk7dvfdBO1gkPftxQ7EYxAYANZe7W/+pTCbn5N4f7GprOcmdd+PU1OuXero
	 I3kdHZd+ycOzNZzOm6wuypLOO/3NkhATjsTlOiNSsaojyULc7J7O95lp2mt2K1FBC9
	 AOyCAtn5x2auHrMhdvw/Z7ZVbCv6dUGswZKj0CubKY1dOwMHIwIGzJXqAoIISsFj0c
	 FMOYsOZHnc1Pw==
Message-ID: <sashiko-outbox-191225@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Karl
 Mehltretter" <kmehltretter@gmail.com>, "Ryusuke Konishi" <konishi.ryusuke@gmail.com>, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:52 +0000
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
- [Medium] nilfs2: nilfs_reconfigure() and nilfs_get_tree() bypass sb_emerg=
ency_ro()
--

commit ff163f1297bca8964f03776869c3a8bc9e3c38ba
Author: Christian Brauner <brauner@kernel.org>

nilfs2: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY in __nilfs_error() with
sb_set_emergency_ro() and introduces nilfs_sb_rdonly() to guard write paths
after filesystem errors without taking s_umount.

Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com

> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 2e3b591c117c9..edb7d379ecbdf 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -137,12 +137,13 @@ void __nilfs_error(struct super_block *sb, const ch=
ar *function,
> =20
>  	va_end(args);
> =20
> -	if (!sb_rdonly(sb)) {
> +	if (!nilfs_sb_rdonly(sb)) {
>  		nilfs_set_error(sb);
> =20
>  		if (nilfs_test_opt(nilfs, ERRORS_RO)) {
>  			printk(KERN_CRIT "Remounting filesystem read-only\n");
> -			sb->s_flags |=3D SB_RDONLY;
> +			/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
> +			sb_set_emergency_ro(sb);
>  		}
>  	}

[ ... ]

> @@ -1141,6 +1146,10 @@ static int nilfs_reconfigure(struct fs_context *fc)
>  	if (fc->sb_flags & SB_RDONLY) {
>  		sb->s_flags |=3D SB_RDONLY;
> =20
> +		/* After an error nothing may be written, just go read-only. */
> +		if (sb_emergency_ro(sb))
> +			goto out;
> +
>  		/*
>  		 * Remounting a valid RW partition RDONLY, so set
>  		 * the RDONLY flag and then mark the partition as valid again.
> @@ -1152,6 +1161,12 @@ static int nilfs_reconfigure(struct fs_context *fc)
>  		__u64 features;
>  		struct nilfs_root *root;
> =20
> +		/* The VFS doesn't refuse this when nilfs_get_tree() calls us. */
> +		if (sb_emergency_ro(sb)) {
> +			err =3D -EROFS;
> +			goto ignore_opts;
> +		}
> +

[Severity: Medium]
Can this sb_emergency_ro(sb) check in the else branch of nilfs_reconfigure()
be bypassed after an error on a read-write mount?

When __nilfs_error() calls sb_set_emergency_ro(sb) on a read-write mount,
SB_RDONLY is not set in sb->s_flags, so sb_rdonly(sb) remains false.

In nilfs_reconfigure(), right before the if (fc->sb_flags & SB_RDONLY) bloc=
k:

	if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
		goto out;

When a read-write mount or remount is requested (!(fc->sb_flags & SB_RDONLY=
))
on a superblock where sb_emergency_ro(sb) is true and sb_rdonly(sb) is still
false (for example, via nilfs_get_tree() -> nilfs_reconfigure() when the
superblock was kept alive by a snapshot after the corrupted read-write mount
was unmounted, or via reconfigure_super() -> nilfs_reconfigure() on a direct
remount,rw without an intermediate remount,ro), this comparison evaluates
false =3D=3D false and jumps straight to out, overwriting nilfs->ns_mount_o=
pt and
returning 0 instead of -EROFS.

Also, in nilfs_get_tree(), when nilfs_tree_is_busy(s->s_root) is true:

	} else if (!ctx->cno) {
		if (nilfs_tree_is_busy(s->s_root)) {
			if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
				nilfs_err(s,
					  "the device already has a %s mount.",
					  sb_rdonly(s) ? "read-only" : "read/write");
				err =3D -EBUSY;
				goto failed_super;
			}

Because s->s_flags does not have SB_RDONLY set after sb_set_emergency_ro(s),
doesn't this treat the emergency read-only superblock as read/write, reject=
ing
a secondary read-only mount with -EBUSY while allowing a secondary read-wri=
te
mount?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D6
