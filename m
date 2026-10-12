Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F5E3D8912
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801774; cv=none; b=ONccZuIC7PiBHgApjtaeOgNixix0VeXTimdqEJHrVn29jazHkiNuLtuOvaXjzOeWFjnR/FT0v+fKlV7LaqL7NgLlNAYviwktwjYmt+ekiF1oSnS7oYi1EZ+nD/fk4i9fnjZUk+jC9ysJivAPpIk1jfUFmnnnZ4eoZqqNr5t0SqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801774; c=relaxed/simple;
	bh=zF1Wrqx6Z6MJuSc9ehQixbOfSi1GRbLAM50xsJAVhGc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=kt0BIP5qhlmueyKnOIcc8geO2ykA2oC2KS8UpPCv0TgoQ0befdwXkHvb730uP0a1skYfzOyy0s7XX5w1LXSoPDDYk0jgBBKr+siOUjkl/oZ3lrHeZ6I9ixYKvstyM7AQBHKXTO9hqTn9P4Ao2v7Lhw4PLScNC0l5/Fzsw5Ctsgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7gsm3iE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7gsm3iE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E315F1F0089B;
	Mon, 12 Oct 2026 10:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801773;
	bh=CLFmBgWUqXZgOnChpXCbjh7/wdXN0m0XG9GuX5Ldu7k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W7gsm3iE+53jeEhperKtTk3cQEGvww4ncpg0L+H6GxhGAqIGUA0n9o8JnmXhTX6Ib
	 49n0BrttLig4/7tmEzc033o5marnUvIKBsFpA0F2BenCzwtdMprHMTwqo4QL18kyFG
	 AvQSOo9+ChlKMxKxMWh7vqZdRAp4Eng0PCoUQSGCTJisq51MwCC4IHOa6vXwB9+J7r
	 CrsDdZbxT9fi/CpSfLDiJPDydkPJdEYbEDI2iXE7XeVIe1SYXvz8k0wBouAMSehFO+
	 fg9LrcvXZAjQeEC6f967QO6Vq/7Jn4NYOiXYEUjmjXToJcofs4WVkoHcuyVP7z5+iW
	 uAPIivSq3Pp0Q==
Message-ID: <sashiko-outbox-167978@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 17/28] zonefs: don't set SB_RDONLY after I/O errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu, "Joel
 Becker" <jlbec@evilplan.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-17-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-17-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:42:52 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] zonefs: missing ZONEFS_SB_EMERGENCY_RO on read-only mount allows=
 bypassing errors=3Dremount-ro
--

commit 51c4c88472fcc9d9e49452a7673d858c48222e8e
Author: Christian Brauner <brauner@kernel.org>

zonefs: don't set SB_RDONLY after I/O errors

This commit changes zonefs to use a new ZONEFS_SB_EMERGENCY_RO state bit
instead of SB_RDONLY when handling I/O errors. This prevents rwsem deadlocks
during freeze/thaw cycles by enforcing that the filesystem refuses writes
until it is unmounted.

Cc: stable@vger.kernel.org

> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index ff43d6d1ea30a..367d657febe5f 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -247,6 +247,20 @@ static void zonefs_inode_update_mode(struct inode *i=
node)
>  	z->z_mode =3D inode->i_mode;
>  }
> =20
> +/*
> + * Make the file system refuse writes after an error. Don't set SB_RDONL=
Y:
> + * that needs sb->s_umount and a proper remount, and setting it while th=
e file
> + * system is frozen makes thaw_super() leave the s_writers rwsems locked.
> + */
> +void zonefs_set_emergency_ro(struct super_block *sb)
> +{
> +	if (sb_rdonly(sb) ||
> +	    test_and_set_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state))
> +		return;

[Severity: Medium]
Does skipping the ZONEFS_SB_EMERGENCY_RO bit when the filesystem is already
read-only allow writes to be re-enabled later?

If an I/O error occurs while the filesystem is mounted read-only, this
condition returns early without setting the emergency bit.

[ ... ]

> @@ -1369,6 +1385,11 @@ static int zonefs_reconfigure(struct fs_context *f=
c)
>  	struct super_block *sb =3D fc->root->d_sb;
>  	struct zonefs_sb_info *sbi =3D sb->s_fs_info;
> =20
> +	/* An error made the file system read-only until it is unmounted. */
> +	if (sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY) &&
> +	    zonefs_emergency_ro(sb))
> +		return -EROFS;

[Severity: Medium]
If a read-only filesystem experiences an I/O error and the administrator
subsequently remounts the filesystem read-write, zonefs_emergency_ro(sb)
will evaluate to false because the bit was bypassed in
zonefs_set_emergency_ro().

Could this allow the remount to succeed and re-enable writes on a faulty
block device, bypassing the intended policy?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D17
