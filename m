Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E68C27A92D
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801447; cv=none; b=KBPGDY6B2dOMZz3TBxkzmO/gqd1Og2apCDnK859kUznh8ZTni79x3pO2pGJP9ltJE4tDfz7bUGEsLq0LCojndJ9oa5kh/DJLkpl7g4iuQgm5ifihNwhYazVCwaSDmT6nLJuAKggnelVMqVOGtpQDzOCDvVB35ecrdStRQXZF8x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801447; c=relaxed/simple;
	bh=5lz9y8l0OxY7KXf0j5aDlLMfaK53ozLqhSG2ByD6Ap0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XE0ByaEHcR1kz/efC+vPUVxtyzDT9zEJrcu0TfJM7+a0pJsvR8+zrSLxgPyzZRzvNZEbQDDB56u3KrmMevCXaPI230tVI3236Tv+x6xpYkyit6DSNRXhMul/MKrypiC2ezU+d6U+qp1S+/mntJxvPdPkooxLUgYLQ1AsJSru6WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsP6cvUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsP6cvUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F8A1F0089F;
	Mon, 12 Oct 2026 10:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801445;
	bh=l6MepkO6ybgYZXqdCKlsEM5YstDLNFk/1UW3Cuh2dPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IsP6cvUg7ZKgz6lapo30ZjmOv+LXi+bDdkxU8mGl/L+7238NVkAycfqTgfabAbiLX
	 97M4vSnryLcnO8yqPcsKUP7J8lB5sBHagLbvE7GwlSRYsEFRKPn4yZOASzhf5BzQn4
	 ZaoiPj/QR7JniUxXEcxrep0BvRdrFfj1FhkxwRSQ30vQgDGsiG+NsCPzPU4OHjA26v
	 162JGFyWOZt7EUtHoa99Qqkkm+cqX2s19dfjQSzugEvYwz7jBovo1NookSyipn/Y97
	 3itu/1WfqLGk2qGEg03DS1cFmwNqxLuFxyD/1lJd+Et7eGn6zP1hE6Y6Rdmz34943j
	 tjOUUMBWS/7Zg==
Message-ID: <sashiko-outbox-167971@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 06/28] fat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, dsterba@suse.cz, tytso@mit.edu, "Joseph
 Qi" <joseph.qi@linux.alibaba.com>, "Joel Becker" <jlbec@evilplan.org>, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-6-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-6-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:37:24 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] fat: logical bypass of emergency RO flag on read-only mounts
- [Medium] fat: TOCTOU race in directory operations bypasses emergency RO s=
tate
--

commit e77264e006a2ef4a1ac604c047b873a1d5b45bb5
Author: Christian Brauner <brauner@kernel.org>

    fat: don't set SB_RDONLY after filesystem errors

This commit introduces a new FAT_FLAGS_EMERGENCY_RO bit to handle filesystem
errors instead of setting SB_RDONLY directly. This prevents hangs when erro=
rs
occur while the filesystem is frozen, and various filesystem operations are
updated to check this new flag to refuse modifications.

> diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> index e79762cf19754..ecba57df83ca2 100644
> --- a/fs/fat/misc.c
> +++ b/fs/fat/misc.c
[ ... ]
> @@ -32,10 +33,22 @@ void __fat_fs_error(struct super_block *sb, int repor=
t, const char *fmt, ...)
>  		va_end(args);
>  	}
> =20
> -	if (opts->errors =3D=3D FAT_ERRORS_PANIC)
> +	if (opts->errors =3D=3D FAT_ERRORS_PANIC) {
>  		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
> -	else if (opts->errors =3D=3D FAT_ERRORS_RO && !sb_rdonly(sb)) {
> -		sb->s_flags |=3D SB_RDONLY;
> +	} else if (opts->errors =3D=3D FAT_ERRORS_RO && !sb_rdonly(sb)) {
> +		/*
> +		 * Only a mount in progress may still set SB_RDONLY: the
> +		 * mounter holds s_umount and nothing can freeze the superblock
> +		 * before SB_BORN. Later, setting it without s_umount on a
> +		 * frozen superblock makes thaw_super() mark it unfrozen but
> +		 * skip sb_freeze_unlock(), so the s_writers rwsems stay
> +		 * write-locked and every writer hangs. Refuse modifications
> +		 * until umount instead.
> +		 */
> +		if (!(sb->s_flags & SB_BORN))
> +			sb->s_flags |=3D SB_RDONLY;
> +		else if (test_and_set_bit(FAT_FLAGS_EMERGENCY_RO, &sbi->flags))
> +			return;

[Severity: High]
Does this logic bypass setting the emergency read-only flag if the filesyst=
em
is already mounted read-only when the error occurs?

If an error happens on a read-only mount, the !sb_rdonly(sb) condition skips
setting the FAT_FLAGS_EMERGENCY_RO bit, meaning the filesystem won't
persistently record its corrupted emergency state.

If the administrator later remounts the filesystem as read-write,
fat_reconfigure() allows the remount because fat_emergency_ro(sb) will retu=
rn
false. Could this allow modifying a known-corrupted filesystem?

> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index da3e89c0b16ac..73f7f11b05907 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -791,6 +791,9 @@ static int vfat_rmdir(struct inode *dir, struct dentr=
y *dentry)
>  	struct fat_slot_info sinfo;
>  	int err;
> =20
> +	if (unlikely(fat_emergency_ro(sb)))
> +		return -EROFS;
> +
>  	mutex_lock(&MSDOS_SB(sb)->s_lock);
> =20
>  	err =3D fat_dir_empty(inode);

[Severity: Medium]
Could this lockless check introduce a TOCTOU race?

If a separate thread encounters an error and locklessly sets
FAT_FLAGS_EMERGENCY_RO, and concurrently a thread executing vfat_rmdir() pa=
sses
this check and waits on s_lock, the rmdir thread will proceed with the
operation once it acquires the lock.

Since fat_remove_entries() is called later inside s_lock but doesn't perform
its own internal check of the emergency read-only flag (unlike
fat_add_entries()), could directory modifications be written to disk despite
the filesystem having entered an emergency read-only state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D6
