Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446853ED11B
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801338; cv=none; b=RStxQhuyizd6kv+IVNhQEAsMx4b52BTewq91nu+cUU/wbcUTxgJsVe1pAg5MeX5vu3eMjhW8dvURBQP3cg39SVRMHcVAGD5EBZSsoUiuteP/aBSdbIu+T/ibfJVsTDNbxNSH7DaQCccYklz8ELt2KXdCoN3jntNS7BBKwUtMskw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801338; c=relaxed/simple;
	bh=0P/9VeL7DyTnF2ZfstI9kv5LutyIEoUKs7loTG2u9H0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=dR1E5ea/HwAbu15Omhkp2zH5qfCism36NaR43ikY8GtrCVHKQOMuKlWAxqQ3Iwbx5pefKcmHi8+Avn3IVteEbvD3YuLDrarCZfvDKXLsRPkchsM4nZ6fgPY2+bYRmmmmPL5GPbRI4o3y2xd9KlUS5f5G2RjY0SlT0yvcIGeb2L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LslRiyMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LslRiyMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DC71F0089C;
	Mon, 12 Oct 2026 10:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801336;
	bh=l0o6LKk5kTcB3aprx/4oZ3mDR6xA4KDYbY8TMfZxGVs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LslRiyMiZMc5qahjdn9w8UqpYBFgWOFpZpqgQPfSSqeYNLwtyrr8OC18riGngWCTo
	 lvKdpQwE1Gwz7FTM0dxDBDgYB0h7jg3xZMBVdCqy3ImOjRoxpyHvvU8VSbFwDzyEp4
	 BwKOq4UdSxUYgj6ZOM2rC33h2a9rlyOiakStDua9VG8Six2RxJzD5cbLaHSJ/fm41b
	 pTwMmJYEU+1Lq/n/l7sUue9YTIZoM69Nx5ryjdfs2Bij26v1G9h/BghaTQR96vxFdH
	 zytsjK9zL4PVaX8B9miOEC13DL0BcBzE7z9zbiqBsTJcjCCK1437iC4CUeR6OoWrDS
	 xoz9C7XBqimHQ==
Message-ID: <sashiko-outbox-167967@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 08/28] exfat: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joseph Qi" <joseph.qi@linux.alibaba.com>, "Joel Becker" <jlbec@evilplan.org>, dsterba@suse.cz, "Mark
 Fasheh" <mark@fasheh.com>, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-8-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-8-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:35:36 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] fs/exfat: exfat_evict_inode bypasses emergency_ro state causing re=
ad-only violation
--

commit 3964e8f2b3e07c51599bfa953e3997f549740387
Author: Christian Brauner <brauner@kernel.org>

    exfat: don't set SB_RDONLY after filesystem errors
   =20
    With errors=3Dremount-ro, the exfat default, __exfat_fs_error() sets
    SB_RDONLY without holding sb->s_umount.
   =20
    freeze_super() and thaw_super() both look at sb_rdonly() to figure out
    whether the s_writers rwsems need to be taken or released.
   =20
    [ ... ]

> diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
> index ccd13630187e1..9fcd1a1255b06 100644
> --- a/fs/exfat/inode.c
> +++ b/fs/exfat/inode.c
> @@ -113,8 +113,9 @@ int exfat_write_inode(struct inode *inode, struct wri=
teback_control *wbc)
>  {
>  	int ret;
> =20
> -	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
> -		return -EIO;
> +	ret =3D exfat_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> =20
>  	mutex_lock(&EXFAT_SB(inode->i_sb)->s_lock);
>  	ret =3D __exfat_write_inode(inode, wbc->sync_mode =3D=3D WB_SYNC_ALL);

[Severity: High]
While many VFS entry points were updated to check for the emergency read-on=
ly
state, it appears exfat_evict_inode() might have been missed.

If an unlinked file (i_nlink =3D=3D 0) is held open, its clusters are not f=
reed
until the final file descriptor is closed.=20

If the filesystem enters the emergency RO state before this final close,
exfat_evict_inode() unconditionally invokes __exfat_truncate():

fs/exfat/inode.c:exfat_evict_inode() {
	if (!inode->i_nlink) {
		i_size_write(inode, 0);
		mutex_lock(&EXFAT_SB(inode->i_sb)->s_lock);
		__exfat_truncate(inode);
		mutex_unlock(&EXFAT_SB(inode->i_sb)->s_lock);
	}
}

Could this bypass the intended read-only protection and mutate the corrupted
filesystem on disk by modifying the FAT chain and allocation bitmap?

Since this also submits synchronous I/O to the block device, does this need
an exfat_emergency_state() check before truncating the inode?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D8
