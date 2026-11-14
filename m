Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657819;
	b=M4YK8JaCytmAtrox+7A4z2WT4Q9VKAoYYeVcbcZNGf5y8Hoazls51n4y4hxdT4blzweR
	 eeL4dY6E+2bpRkpIq3XO+VfuNTwVDlCT/NRIjDIAxPOOTqIQ8Mlm5JB+sL3SJ4bARgFZ4
	 jJx8HDPKIlu7jpSTuOMeE3cgOHRuFFHdLRtKfoZwqDLBkif6MntrRhjkUwSZgyRgYkrH8
	 kdRLQ9djgnJiRehnJFdmRSVw0J3i9CJWPl4XImXXvaLMMf/Qmg6fXPbFQGJGhZk7v9Evs
	 PADXk7gsed+HJN6apDYXSQS3o2dhen6AeqDjTY3U0vocIo+7vJOwOzGKRiC+4FbhTgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657819;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VJvTxxxVKFSKaVy4VwipIwjtqqi4NX20dtdLW1nv+Hc=;
	b=QbRUHOfouxDJWRWtaC58xL1pVNZP+pLC1CmT8A4ludYe9FghSHmaFwhWcdnFPLLG91kt
	 VMRzn/q4OdvKVtm/OR2DwM78tQRBdgLjdldevmWde5jnJ3IyIKUDAPPXR0XDnOTxxqcsc
	 qeiB9khSIfiGmxtFuH0Uek/lThRv8me/Pye5xpjZ3vZ2pK1t2ToOadhf70atXwPCMwRGn
	 ZS+ro+Rd/bHS0dVb0gmNvDPaRuuCr599gRlkyzzcJy4cL0dv9VmfAPhUhk4bZArOOIzk2
	 ugKLNOFQvBQevoreUOt5IHqlNoWscCY7GQeXkvA1+WsZP1ojX6+lcxxinRRPclNCjnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJXRZ7UC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93C6606A88E;
	Sat, 14 Nov 2026 12:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJXRZ7UC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA6C1F000C4;
	Sat, 14 Nov 2026 12:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657818;
	bh=VJvTxxxVKFSKaVy4VwipIwjtqqi4NX20dtdLW1nv+Hc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SJXRZ7UCCdy3QZyo+FxMDY7k8UIUGk6IYo89lBu3JfDwkdzTs3BZnWyGaCc/ULTNn
	 hTClA74WxBneCreuWBl8YFI8tBn7zxnnD9TXVlOMqnV+xQ6uV8PhP1S9SPwJ6ZTpSO
	 5zAHKao9moTQQgbLDO8sbnPffmS1wkAjk8AyR8QA7xbPlYrXri8uKa7QkpNcwLQwID
	 Wxo2z8l+5N6HHOqpdrXitXhs30JB45pi0jnIIoiIE1pk9b1JjFa/5wKPTdMicUZTzV
	 9CQoNePsc39FBbjGyiptDy9bf0aHlUaDlJQsHsyhfRni7RfJyClfhj54WdR0L/qJMM
	 FNvbQxj3FfiCg==
Message-ID: <sashiko-outbox-214468@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/33] ufs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-17-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-17-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:35 +0000
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
- [Medium] ufs: cylinder group leak and SB_RDONLY clear in
  ufs_reconfigure()
--

commit eaf412f5390fa6f1c30001040b118660141a9bd6
Author: Christian Brauner <brauner@kernel.org>

ufs: don't set SB_RDONLY after filesystem errors

This commit switches ufs_error() and ufs_panic() from setting SB_RDONLY to
calling sb_set_emergency_ro(), and keeps cylinder group structures allocated
across read-only remounts after an error so inode eviction can still use
them.

> diff --git a/fs/ufs/super.c b/fs/ufs/super.c
> index 3569ac92b065b..d82cf73360a79 100644
> --- a/fs/ufs/super.c
> +++ b/fs/ufs/super.c

[ ... ]

> @@ -1265,14 +1281,20 @@ static int ufs_reconfigure(struct fs_context *fc)
>  	 * fs was mouted as rw, remounting ro
>  	 */
>  	if (fc->sb_flags & SB_RDONLY) {
> -		ufs_put_super_internal(sb);
> -		usb1->fs_time =3D ufs_get_seconds(sb);
> -		if ((flags & UFS_ST_MASK) =3D=3D UFS_ST_SUN
> -		  || (flags & UFS_ST_MASK) =3D=3D UFS_ST_SUNOS
> -		  || (flags & UFS_ST_MASK) =3D=3D UFS_ST_SUNx86)=20
> -			ufs_set_fs_state(sb, usb1, usb3,
> -				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
> -		ubh_mark_buffer_dirty (USPI_UBH(uspi));
> +		/*
> +		 * After an error leave the superblock alone and keep the
> +		 * cylinder groups, evict still needs them.
> +		 */
> +		if (!sb_emergency_ro(sb)) {
> +			ufs_put_super_internal(sb);
> +			usb1->fs_time =3D ufs_get_seconds(sb);
> +			if ((flags & UFS_ST_MASK) =3D=3D UFS_ST_SUN
> +			  || (flags & UFS_ST_MASK) =3D=3D UFS_ST_SUNOS
> +			  || (flags & UFS_ST_MASK) =3D=3D UFS_ST_SUNx86)
> +				ufs_set_fs_state(sb, usb1, usb3,
> +					UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
> +			ubh_mark_buffer_dirty (USPI_UBH(uspi));
> +		}
>  		sb->s_flags |=3D SB_RDONLY;
>  	} else {
>  	/*

[Severity: Medium]
Can reconfiguring via fspick() after an error and a read-only remount
leak the retained cylinder group structures and clear SB_RDONLY?

When a read-write mount hits an error and is then remounted read-only,
this branch skips ufs_put_super_internal() so sbi->s_csp, sbi->s_ucg, and
sbi->s_ucpi stay allocated while SB_RDONLY is set on sb->s_flags.

If userspace then reconfigures the mount via fspick() and fsconfig()
without specifying ro or rw (for example, changing onerror=3D), fc->sb_flags
and fc->sb_flags_mask are both 0.  reconfigure_super() only rejects
sb_emergency_ro(sb) when SB_RDONLY is in fc->sb_flags_mask, and
ufs_reconfigure() checks (bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(=
sb)
without consulting fc->sb_flags_mask.  Execution then falls into the else
branch, where ufs_read_cylinder_structures() overwrites the existing
sbi->s_csp, sbi->s_ucg, and sbi->s_ucpi pointers (leaking memory and
buffer_heads) and clears SB_RDONLY from sb->s_flags.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D17
