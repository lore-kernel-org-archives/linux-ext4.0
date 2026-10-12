Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D87372EF0
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801386; cv=none; b=lNnrKA2LTRM4uvSg1aUsOdHSpEbyN4vatwLk3Mf7omELn7OIJ9KZZ4nFwG9gYocl+gPhD+J7H5JSJCcNhWDGhkqTQ91qKeAl1inNMlWh5jEt3ie6Fh4Z5tuy60rNZ90F8ZuHRQ1b4OgI3gMTK774YjpKz21SK2Zt6WpOq6cj8bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801386; c=relaxed/simple;
	bh=shBVTPJD9y/Wh4YRUCY1jZ8K6HZJD9GgzwpMe1Atuog=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FyonY5FkTHVbJBdEd4y3dcYXqXrsutxXR+bvIYkrPdpfeKDxqEg71GtyeQyYkBPyEiHmaP3jNoTJzHIZhQBU7IsAbVFYs4IaOKhrswAs1+AMNUbU+oZta5y7STUx29MxEgsBHATmeSMShodbOnXLaB/lpBuGBHb3xHcWgaGXyu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=juOFQuiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juOFQuiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AD81F0089B;
	Mon, 12 Oct 2026 10:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801384;
	bh=W1QyqFeChvcdjBYmWQhHSItuYi5isur6mrVjfuPpJM0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=juOFQuiQU4kHVfBGR9HkyZh+Wmm3ILDIBywIy11o0HpBXgDJ5WX6i5cC2rraOxmF0
	 1Dys8p9QoGn2lreRPI3/NrNCANQezocTB3xIM211oUpFQ+5anEc3DwMjIY/gSRcn4p
	 n/UxMRRIV99qrWzn3WBTRn3vSeZpJckb4OU96ji9xuuwq8ARzXNXECmIeQuzpkV1uc
	 fN7BNfV/h6zkpgmwPZyZfJoZIl+whLXezydhk3TxL1MzWdoe7G+FtBLJQTs1NKOcZM
	 lSFX3pFO7rVyb7OgX/bKrWyHlQ2NozTtFaAxVdHVaZjEmwiC6CJAZfIX8bMSPhpfIR
	 BvkX2EO7bq4LQ==
Message-ID: <sashiko-outbox-167970@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 07/28] exfat: keep the current mount options on
 remount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Mark Fasheh" <mark@fasheh.com>, dsterba@suse.cz, "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Joel
 Becker" <jlbec@evilplan.org>, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-7-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-7-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:36:24 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] exfat: data race and torn struct read during remount options copy
--

commit 2d6a9e734992913f68b1b7acddc9bc5d1eb92428
Author: Christian Brauner <brauner@kernel.org>

exfat: keep the current mount options on remount

This commit modifies exfat_init_fs_context() to initialize the filesystem
context with the current superblock mount options during a reconfiguration.
It resolves an issue where remounting without options, such as an emergency
remount, would inadvertently reset mount options like errors=3Dcontinue to
defaults.

> diff --git a/fs/exfat/super.c b/fs/exfat/super.c
> index a9ea36ba26938..71a348d10c26a 100644
> --- a/fs/exfat/super.c
> +++ b/fs/exfat/super.c
[ ... ]
> @@ -805,6 +807,11 @@ static int exfat_reconfigure(struct fs_context *fc)
>  	}
> =20
>  	swap(*cur_opts, *new_opts);

[Severity: Medium]
Could this swap operation race with a concurrent read?

In exfat_init_fs_context(), the mount options struct is read locklessly
before the s_umount lock is acquired. Concurrently modifying the same
struct here via swap(*cur_opts, *new_opts) allows the compiler to use
non-atomic memory operations, which might lead to a torn read.

> +	/*
> +	 * The iocharset can't change, keep the current string. The new
> +	 * options have none if the remount didn't specify one.
> +	 */
> +	swap(cur_opts->iocharset, new_opts->iocharset);
[ ... ]
> @@ -831,23 +838,27 @@ static int exfat_init_fs_context(struct fs_context =
*fc)
> =20
>  	if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE && fc->root) {
>  		struct super_block *sb =3D fc->root->d_sb;
> -		struct exfat_mount_options *cur_opts =3D &EXFAT_SB(sb)->options;
> =20
> -		sbi->options.fs_uid =3D cur_opts->fs_uid;
> -		sbi->options.fs_gid =3D cur_opts->fs_gid;
> -		sbi->options.fs_fmask =3D cur_opts->fs_fmask;
> -		sbi->options.fs_dmask =3D cur_opts->fs_dmask;
> +		/*
> +		 * Start from the current options so a remount only changes
> +		 * what it specifies. exfat_reconfigure() refuses to change
> +		 * most of them, so a remount that doesn't repeat them all
> +		 * would fail, e.g. emergency remount which passes none. The
> +		 * iocharset string stays with the superblock and is only
> +		 * compared if the remount names one, see exfat_reconfigure().
> +		 */
> +		sbi->options =3D EXFAT_SB(sb)->options;

[Severity: Medium]
Can this struct assignment race with a concurrent remount?

When a user process calls mount -o remount or fsconfig, exfat_init_fs_conte=
xt()
is invoked and locklessly reads EXFAT_SB(sb)->options. Concurrently, another
thread executing a remount might be modifying this same struct via
swap(*cur_opts, *new_opts) in exfat_reconfigure().

Since exfat_init_fs_context() executes before s_umount is acquired, this
concurrent access allows the compiler to use non-atomic memory operations.
Could this result in a torn read of the 32-bit word containing the bitfields
such as utf8, sys_tz, discard, or keep_last_dots, yielding an unintended
mixture of old and new options during the remount?

> +		sbi->options.iocharset =3D NULL;
>  	} else {
>  		sbi->options.fs_uid =3D current_uid();
>  		sbi->options.fs_gid =3D current_gid();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D7
