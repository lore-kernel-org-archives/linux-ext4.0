Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC41541F7EE
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 11:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791803132; cv=none; b=ap0W9axDUQIeCG5IIyv18+IK5cr/bFrZAtKrwvgSdg8KioU1/tRl6Ba9OoQipc3JCn3Ml1WCJTF3XBD4cNDSJaBQYglIQ0r5E2UCoSnwuhHgLUWDrInss4+Gqah5Nd3leQYE5tDTzI9KodhWJnnjYqZelVMg6cidGWMZfoLOV6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791803132; c=relaxed/simple;
	bh=tc5AWAoxeGNGEWblEMXakujP0P4Rjw7+mPe3HAJeqgI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UN78W6tJRMREjX1zdNFev3TNtSb4piJq99IKTQTmHCnSFhrAMAfz2hNv1r5omTMiejYbtD+Gmw+1TK6kMSnM3Rrx3c7B78Tlx8LZADht4rZM8AAFmafEC3HTooIRjnuMLuDHRideDSnMifPx2REJzcvUl8omB7g2vWq8vcUlu10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRIfapXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRIfapXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C081F0089B;
	Mon, 12 Oct 2026 11:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791803128;
	bh=oRJFflfFl6VwfL/AFjCDCWw9r9FfFqr+AYvBr1MdvQQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SRIfapXwxgiK92gkHA2IpkM3QBvMluyqDdMkbvzjLKhv3bgrXaluJUQFbSafL1P7l
	 HpYDN1lTqgXR/mMwQ+IwoIWQmboJOBBw3X8E6kPmtMcM7k+7NRnl7QpSqh79RaqQAI
	 eovUM99SXTU++iEGnhqyHl/AjBKnS/r9geZQ0TYDJZvxroDrmvHfSGthdVwJ8x1y6G
	 yrTlojcitBIl9Rx7IM1GqAWFHgZ53NY+BpJ3TVlbyMy5LkzQ24Ef04R21H1DvZU/n3
	 5UhZgqgUcsyAJsaB/fHH1QDVEV9FmnbtEcAvhkHyVgIaPBnjmnpkCiARmRVj1328zO
	 /kGY4R4bcLWkQ==
Message-ID: <sashiko-outbox-168005@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 23/28] ubifs: don't set SB_RDONLY after errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joseph Qi" <joseph.qi@linux.alibaba.com>, tytso@mit.edu, linux-ext4@vger.kernel.org, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, dsterba@suse.cz
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-23-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-23-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 11:05:26 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] fs/ubifs: Data race on bitfields ro_error and ro_mount causes lost=
 updates
--

commit 3576c210f3d797e4caeeb6fb96d4f74501988ba8
Author: Christian Brauner <brauner@kernel.org>

ubifs: don't set SB_RDONLY after errors

The commit stops UBIFS from asynchronously setting SB_RDONLY on the VFS
superblock when an error occurs, to avoid racing with VFS operations.
Instead, it relies on the c->ro_error flag to reject writes, returning
-EROFS from various file operations after an error.

> diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
> index 6c6d682427793..3d01529a07540 100644
> --- a/fs/ubifs/io.c
> +++ b/fs/ubifs/io.c
> @@ -72,7 +72,12 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
>  	if (!c->ro_error) {
>  		c->ro_error =3D 1;
>  		c->no_chk_data_crc =3D 0;
> -		c->vfs_sb->s_flags |=3D SB_RDONLY;
> +		/*
> +		 * Only a mount in progress may set SB_RDONLY, later that needs
> +		 * s_umount. UBIFS refuses modifications itself afterwards.
> +		 */
> +		if (!(c->vfs_sb->s_flags & SB_BORN))
> +			c->vfs_sb->s_flags |=3D SB_RDONLY;

[Severity: High]
Does this change risk losing the ro_error flag update due to a data race on
adjacent bitfields?

In struct ubifs_info, ro_error, ro_media, and ro_mount are adjacent bitfiel=
ds
sharing the same unsigned int.

ubifs_ro_mode() locklessly sets c->ro_error =3D 1 from any context, includi=
ng
hardware interrupt or softirq contexts during I/O error completions.

Concurrently, ubifs_remount_ro() modifies c->ro_mount while holding
c->umount_mutex:

fs/ubifs/super.c:ubifs_remount_ro() {
    ...
    ubifs_lpt_free(c, 1);
    c->ro_mount =3D 1;
    err =3D dbg_check_space_info(c);
    ...
}

Because bitfield assignments are implemented as read-modify-write operations
on the entire word, an interrupt firing during the RMW cycle of
ubifs_remount_ro() will cause the ro_error update to be silently clobbered
and lost.

Now that the asynchronous setting of SB_RDONLY is removed, the filesystem
is entirely dependent on c->ro_error to reject subsequent writes. If ro_err=
or
is lost, could the filesystem erroneously continue attempting writes to a
broken medium during a concurrent remount?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D23
