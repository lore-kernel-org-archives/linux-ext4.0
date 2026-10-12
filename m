Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFF83F9263
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801914; cv=none; b=i2hyyTToOmx14ErJm20A/+z+QrT1Zd6rhsR0T+V2f2OAsf3Bt9MOlplJedS6i03TjkBvQ9ausCH077WhyTH2eBEcIBbwQ4e9IzWfRtFM7A9hUhTAVjiAojHsdU50HqgGD0CuW4mHVrR31m/PkbkU92M4yKWMlhBqtGvbchBN2WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801914; c=relaxed/simple;
	bh=NTnWnrg9UWX8iiudonIdk+PjLYiWIq9XCiumeXju04Y=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=If9t/3WJiQUuitKktTBPn0QyKuFc6B0OHGmbGYnBAkmZ7Bpz5GFswh5wEXUIRqOHRFMTSpXV0OFcNPxhrg/3dzwIJk+sAFAoYdRI9xJ/2UWKGanopSqD6K1dQ7ROnWrN1DB1zxmHu+LstTc7nFPWcmYSlRksrfM2citcpYQZmjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCQbtlGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCQbtlGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9802F1F0089C;
	Mon, 12 Oct 2026 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801913;
	bh=DfHWEdkBlUWdTbHthxhBkBwWfaEpMdsoryW/yRuS6EU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iCQbtlGeKJ1wz5QDtqCPkRbSDVxVVVjUU9Xkie3vb+pUv/1oPwTgRog+e7XKD6YXY
	 CADQqD6YW7pAsm1jSPGm+SbeBnl62Dy4ch1oFpUzyBtRvUAP9Hr8Y9oKnieZZeJ6Af
	 RUiew6VO9Ma43BvzzUH1Tw/vytp8FmeKK5Gpcq1MQ3qW34HRwy6F2orWNn/EVc3ueV
	 5a7oW9Gs94LbYVbChPmqJhsLRdwso39SdkwcTqVj7WGKohhu58VeLf4OylPT+nvyNe
	 DGURhtaNt1Iy+iiDphJJGVIgZoS8pbFdnfykcfhvKB+fhdABjjTETOQL9ro/z60/GO
	 v10s2yfKIqvKA==
Message-ID: <sashiko-outbox-167983@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 14/28] ntfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: tytso@mit.edu, "Joel Becker" <jlbec@evilplan.org>, "Mark Fasheh" <mark@fasheh.com>, dsterba@suse.cz, "Joseph
 Qi" <joseph.qi@linux.alibaba.com>, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-14-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:45:12 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] vfs: ABBA deadlock between umount and thaw_super on frozen NTFS
--

commit dfc5fc432ef752d67cfa9b90f071205bebdf7f7a
Author: Christian Brauner <brauner@kernel.org>

ntfs: don't set SB_RDONLY after filesystem errors

This commit updates NTFS to handle errors by setting NV_EmergencyRO instead
of SB_RDONLY to avoid leaving s_writers locked after thawing. It introduces
an asynchronous work item to mark the volume dirty on disk and flushes/syncs
this work during unmount.

> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 4066bacabe377..12ad2ce938ba9 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c

[ ... ]

> @@ -423,6 +446,29 @@ int ntfs_set_volume_flags(struct ntfs_volume *vol, _=
_le16 flags)
>  	return ntfs_write_volume_flags(vol, vol->vol_flags | flags);
>  }
> =20
> +/*
> + * ntfs_error_work - mark the volume dirty on disk after an error
> + * @work:	the error_work of the ntfs volume
> + *
> + * VOLUME_IS_DIRTY makes chkdsk check the volume. It is set lazily on th=
e first
> + * modification and ntfs_sync_fs() clears it again, so it may not be on =
disk
> + * when an error makes the volume read-only, and the inode writeback tha=
t would
> + * write it is refused from then on. __ntfs_write_inode() still writes $=
Volume
> + * in that state. This runs from a work item because ntfs_error() may be=
 called
> + * with mft records locked. sb_start_intwrite() waits for a frozen volum=
e to be
> + * thawed.
> + */
> +static void ntfs_error_work(struct work_struct *work)
> +{
> +	struct ntfs_volume *vol =3D container_of(work, struct ntfs_volume,
> +					       error_work);
> +
> +	sb_start_intwrite(vol->sb);

[Severity: High]
Could this cause an ABBA deadlock if an error occurs while the filesystem
is frozen?=20

If the filesystem is frozen via freeze_super(), the VFS holds a write lock
on sb->s_writers.rw_sem. The worker executing ntfs_error_work() blocks here
indefinitely waiting for a thaw operation to release that lock.

> +	if (!ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY))
> +		ntfs_commit_inode(vol->vol_ino);
> +	sb_end_intwrite(vol->sb);
> +}

[ ... ]

> @@ -1716,6 +1762,15 @@ static void ntfs_put_super(struct super_block *sb)
> =20
>  	cancel_work_sync(&vol->precalc_work);
> =20
> +	/*
> +	 * If an error made the volume read-only, make sure it is marked dirty
> +	 * even if the error work didn't get to run. The commit of $Volume
> +	 * below writes it.
> +	 */
> +	disable_work_sync(&vol->error_work);

[Severity: High]
Does this sequence lead to an unresolvable 3-way deadlock between the error=
=20
worker, umount, and thaw_super()?

If the error worker is blocked on sb_start_intwrite() as noted above, and
the user attempts to unmount the filesystem, deactivate_super() acquires
down_write(&sb->s_umount) before calling ntfs_put_super().

The disable_work_sync() call here will block forever waiting for the worker
to finish, keeping sb->s_umount held by the unmount process.=20

To recover the filesystem, the user must call thaw_super(), but that
requires acquiring down_write(&sb->s_umount), which is now stuck behind
the blocked unmount.

> +	if (NVolEmergencyRO(vol))
> +		ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY);
> +
>  	/*
>  	 * Commit all inodes while they are still open in case some of them
>  	 * cause others to be dirtied.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D14
