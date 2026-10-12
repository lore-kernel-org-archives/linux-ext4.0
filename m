Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C315385D75
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801337; cv=none; b=tTnZdkTEeFfmGuntheZSORGM/Hts/jym3dCVv7HnFUr421hu+YXVrvyIlGM3SeX3LLow9ZKW+A5VUhfNw6wxgpEvnn4CdBvRxeRNHINtMXvvGTitOr/gc4YVlV0sN507yWpTULp1g2D2j9U38aMRgIS+ZeiWcuRG/dkkV3k6YeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801337; c=relaxed/simple;
	bh=ZlgzHZlWgUNd/A5ZEWfSN00wcH36+fb7BoNkh9oiQGQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fpXg5tMBZ2YqHhIyFVhAwEDdZCl+RXyTawpVIPzGv+55nZCfHo4pKa1xZ7ntdBSYBW4YpXFJR1xjz9kI20ZZkyxB2V0G8I3iRmviF9lzDqHblWwpkxBhFS0lwusXYP4Wu5YW/9Mm0Utp2Z6oQlaCwt2MdECsB/Dz2uFDU0DCLAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYJI137F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYJI137F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A7D1F0089B;
	Mon, 12 Oct 2026 10:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801336;
	bh=KKAJY2lOGy4l5BbFsQaS9OVib4E+kNBmyZLfocqQbh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UYJI137F73HV9ati7khPP9yqiy+brpPfIA4lpNEmpJ5NInBsZufC+BDBKn4vUi1C2
	 MhJ8WIWJ+2rsXmjxEIe3UBEBgbdzRu2/teSN1xiJXBIebJCLAaINz/qI+t5OQXnvur
	 AGbny8M90hQR7CsJ1JDHZJ5N664YSBR9KntkkbLldqMrL4NSs9kxLIE0PF8PNdAhyc
	 zXBpaEbs5UGStQgJzfYIWXEY4MscV6i99ItnZ4jn2rxSTkbRsHO/XuhUNPFzvuqAeG
	 aJcWYoiL7Vk3kdJB2WwQOrmVJHlwpgr6mbxulxgnATsin4mI6XEtfRD56Cun9o3kV3
	 M8WcHI1V/1s9g==
Message-ID: <sashiko-outbox-167966@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 13/28] hpfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joseph Qi" <joseph.qi@linux.alibaba.com>, dsterba@suse.cz, "Mark Fasheh" <mark@fasheh.com>, linux-ext4@vger.kernel.org, tytso@mit.edu, "Joel
 Becker" <jlbec@evilplan.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-13-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-13-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:35:35 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] vfs: hpfs: writeback, mmap, and eviction bypass emergency RO state
- [Medium] vfs: hpfs: read-write remount bypasses -EROFS rejection
--

commit fff4d175276350a79a5a1bcb72eb2e0bb0259054
Author: Christian Brauner <brauner@kernel.org>
hpfs: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY with a new HPFS_STATE_EMERGENCY_RO
flag during runtime filesystem errors. This avoids blocking on s_writers
locks if the filesystem is frozen.

> diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
> index 8fbdbf0806276..cff963cabbb63 100644
> --- a/fs/hpfs/super.c
> +++ b/fs/hpfs/super.c
> @@ -81,7 +81,18 @@ void hpfs_error(struct super_block *s, const char *fmt=
, ...)
>  			else {
>  				pr_cont("; remounting read-only\n");
>  				mark_dirty(s, 0);
> -				s->s_flags |=3D SB_RDONLY;
> +				/*
> +				 * Only a mount in progress may still set
> +				 * SB_RDONLY: later that needs s->s_umount,
> +				 * and on a frozen superblock it makes
> +				 * thaw_super() leave s_writers locked.
> +				 * Refuse modifications until umount instead.
> +				 */
> +				if (s->s_flags & SB_BORN)
> +					set_bit(HPFS_STATE_EMERGENCY_RO,
> +						&hpfs_sb(s)->sb_state);
> +				else
> +					s->s_flags |=3D SB_RDONLY;

[Severity: High]
Because the VFS SB_RDONLY flag is no longer set here, the VFS background
writeback thread and generic memory-mapped page faults will no longer
automatically skip the filesystem.

While the namespace operations were appropriately updated, could this allow
dirty pages from mmap to be written out since hpfs_writepages() doesn't
check the emergency read-only state? Similarly, could hpfs_evict_inode()
mutate the btree and sector bitmaps on a corrupted filesystem when an
unlinked inode is evicted?

[ ... ]

> @@ -426,6 +437,11 @@ static int hpfs_reconfigure(struct fs_context *fc)
>  	struct super_block *s =3D fc->root->d_sb;
>  	struct hpfs_sb_info *sbi =3D hpfs_sb(s);
> =20
> +	/* After an error, refuse going back to read-write until umount. */
> +	if (hpfs_emergency_ro(s) && sb_rdonly(s) &&
> +	    !(fc->sb_flags & SB_RDONLY))
> +		return -EROFS;

[Severity: Medium]
The commit message states "A remount to read-write fails with -EROFS until
umount". However, if the filesystem experienced the runtime error while
originally mounted read-write, hpfs_error() sets HPFS_STATE_EMERGENCY_RO
but not SB_RDONLY.

In that scenario, sb_rdonly(s) is false. When a user subsequently executes
a read-write remount, does this check inadvertently bypass the -EROFS
rejection and allow the remount to succeed since sb_rdonly(s) evaluates
to false?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D13
