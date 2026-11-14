Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657820;
	b=G7JhtHYBOtxRgWHq8/5A84WTBQoYbZjW8nEVhusZZCAee7vJ1v5ap8QLFWZ7VpmLZXxu
	 GB3nJ53v6hv17JLOXz3F80ZpAzhwgRoFUCBICbEjfV2Ahpu5VkTnZ4DBO1A3o1HO15zYk
	 +phpvXJ4Ut6QfVa9ClpnXb/o3qrXU9P4ecott356NZU/8rC1sdfGs5jPtIVg2BDXkiIWw
	 E4I5qGj9T5k3XLxHEDj2NSSfAClqrPKWsrcHnM5uIZI/Qj/G5HgppuOF5IqqXtv5DMtpO
	 +i+aupiNP51GGYGaufzGFPZLKLH2CqtDybglDwIlwsslLfXwUMJ3tJymErgHZMRbqng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657820;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i/KYa3UJ+vAFbs7NcbhfOHJmaPLTvaBxJddS/GfOWco=;
	b=aSPm+MiL2kbi4haQ98Edd5pjPlUxSKamQmhEZ6OrBPiaUk+ZW4c4VLOghY/T2VEGLTRV
	 lDRdRC2DP8/On4AMBmXFStb0+VeWu6sZJt9QK4zqR5q6FNkx1+JfifI6jRmLFkw2s5rAk
	 gUiOVCVirTX3qvll8VHNXn/7C9V/TOo4PSwqbCT5SqjJ6gdjbQtuVlTxpSwdPBgqi2NdR
	 hw1sgyNoDWa6sJlShV42qE9veTgBNwmCZDZCiKu80wnkKHFpk0OVHzcBLj5iR3fQvGe7D
	 2+PIxLazrGRYB3dsDzytNNmZIVWbT4zfnAQdnY+hKy3cRlxdzIwqW/EAA23sgrR/CTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f69SiW3T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC420606A337;
	Sat, 14 Nov 2026 12:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f69SiW3T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAFA1F000C5;
	Sat, 14 Nov 2026 12:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657820;
	bh=i/KYa3UJ+vAFbs7NcbhfOHJmaPLTvaBxJddS/GfOWco=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f69SiW3T4Q7A6/VsOz19IJcDTbc2284jaDxgfyilDNG1Mci6VQQ0XsUIBzmCI2qyW
	 jBaCIXM0+pGMbZU6+HsTbwcuLPsb2hzKKEbMRuKK4DOQw/dU5Ns9uMCz52Jnzj9tF5
	 AXH/9yDypM1F5LtJdPmEAkLH4UA7aJwzK9MLeRyuesvkSJjk6XuJlznUHMW2Vc4Awm
	 BtcYalXD+cdcCtN0E28SgqskmS21t/xSbEIhlpoLv2451rm/ZPCa/BhesuHFKDJLNb
	 sT27WrI12rYRWzsaabg7n85XlDTqlHu6y6vW8o/+iQEOAYtkvM/L4JnWcrRwRiTkYU
	 9J1nIjwgbU3lA==
Message-ID: <sashiko-outbox-214470@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 19/33] ntfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Hyunchul
 Lee" <hyc.lee@gmail.com>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-19-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-19-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:39 +0000
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
- [Medium] ntfs: unlocked sb->s_flags RMW in ntfs_handle_error() via
  precalc_work
--

commit 41f5366b5799dc9babb537d585f77ff9063831e1
Author: Christian Brauner <brauner@kernel.org>

ntfs: don't set SB_RDONLY after filesystem errors

This commit replaces setting SB_RDONLY on runtime filesystem errors under
errors=3Dremount-ro with an NV_EmergencyRO volume flag and an asynchronous
work item to persist the volume dirty bit.

> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 71f0aea46bf8f..91290688d2898 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
[ ... ]
> @@ -434,7 +436,21 @@ void ntfs_handle_error(struct super_block *sb)
>  		return;
> =20
>  	if (vol->on_errors =3D=3D ON_ERRORS_REMOUNT_RO) {
> -		sb->s_flags |=3D SB_RDONLY;
> +		if (!(sb->s_flags & SB_BORN)) {
> +			/* Before SB_BORN the mounter holds s_umount. */
> +			sb->s_flags |=3D SB_RDONLY;
> +		} else {

[Severity: Medium]
Can precalc_free_clusters() reach this branch on a kworker thread before
SB_BORN is set, racing on sb->s_flags without holding s_umount?

ntfs_fill_super() queues vol->precalc_work before returning to
get_tree_bdev_flags() and vfs_get_tree():

CPU0 (mounter)                    CPU1 (kworker)
vfs_get_tree()
  get_tree_bdev_flags()
    ntfs_fill_super()
      queue_work(..., &vol->precalc_work)
                                  precalc_free_clusters()
                                    get_nr_free_clusters()
                                      ...
                                        ntfs_error()
                                          ntfs_handle_error()
                                            /* !(sb->s_flags & SB_BORN) */
  super_wake(sb, SB_BORN)                   sb->s_flags |=3D SB_RDONLY;
    smp_store_release(&sb->s_flags,           <-- unlocked RMW race
                      sb->s_flags | SB_BORN);

During mount, load_system_files() does not populate the runlist for
$Bitmap, so get_nr_free_clusters() decompresses $Bitmap's mapping pairs on
the workqueue and calls ntfs_error() if reading or decompressing fails.

Because neither side updates sb->s_flags atomically and the kworker does
not hold s_umount, the RMW in ntfs_handle_error() can overwrite SB_BORN
(leaving later super_lock() callers hung waiting for SB_BORN) or lose
SB_RDONLY.  Taking the !SB_BORN branch from the workqueue also skips
NVolSetErrors(vol) and NV_EmergencyRO, allowing a subsequent remount,rw in
ntfs_reconfigure() to succeed despite the error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D19
