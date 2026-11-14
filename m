Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657805;
	b=m7VOzfw0D2SFYB5dzx4jWbx+uIHI5fMmJggFq/LhFDinNPkhoB/nV1hiBVlxlxWh8lPk
	 mmFI6gp9KrFvylnp8qrIQVkhBQKtN6FGWsGaXjvV8Hp7EatkNNJKPn5gA0T/QYsZzlO/V
	 JJRlkNrgwAVCWARhhE19R29MpefQYusMb6EyCDhdrZfv0MpiG9IF9ObCUnYv3AIQDsgA+
	 oF6X+rqOspIwB5IbDDk0cLrC5jwclBzb6UckwtzRMCHGA256FPyVljRZ+oGb5DVFqbU0L
	 DZqTOPlNX7WeSt/+gCv19l4BoslVKInMU5n5VpCRRvfXpFkXiNXbn3L+eoNchHDTtFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657805;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ALzGtljZmngZ99TYML6vyT57I3K5d0MlyVrwhGLF07s=;
	b=pdpI0fmQ6p/v0LEks4DyWaMb9NqATRkrcBb3iIUi4ZX4iZ0NvkqMZ4bqavI1MQbv5jWR
	 N3TRmdSYLy/0ThlGx02SK6TnjZ10aRglsmHwAkmDk+AflcFnQaYgC5BNkkM2d6Tq6pgYi
	 5iCSG7geaJjswwalzLzf+TXoWgMBt58j20ve/k00G3wt66jVK1vGzLZ0rASJRBOjYDKLY
	 EDyptfMEvGookAZzmGuexaQkJ8sCXphb9rNxevuFbToQqMP7HuG/uDmY29VLdeAfBht1D
	 XsiHpWvPHH4GfYwnxcKojsdJxeJ+ZoXTcdDCwtjO1Fx0Yr6qwGEU5jsEKAz2vTUUksw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8ZTGEn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F37606A327;
	Sat, 14 Nov 2026 12:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d8ZTGEn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89B21F000C4;
	Sat, 14 Nov 2026 12:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657805;
	bh=ALzGtljZmngZ99TYML6vyT57I3K5d0MlyVrwhGLF07s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d8ZTGEn0qxni0o2KqxTpTR9WvaZxwMw6wYgcu+OafMRCtiRzDVAXMU7/wZ74rgbDB
	 1LocND40CPQPdchDfZSgOlZusuV2b2Jm6PmSzxbXe+UtcgCZxhq7Cayx0Jg+WQs+5S
	 Fgn0yDEfY6VuTU6Kbg6xIhCMSNZtGpQHRSHQT7Ov+hnlN+QHxRE11/pIkaAJwpMSC3
	 85ZDbU7OiQ6CVDl/omSbOx09QyAE6AQk8ZxkNWDw19sm6FcfmyGeBCn4P7CMz0EUvA
	 NEqvQjJ0iP60FlMW/wnjotiw8rWjZFrDQALOU/tpxLhx8piKaT0N8cCt57zYhs9fOY
	 bSV/RrIKt+71g==
Message-ID: <sashiko-outbox-214456@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/33] fs: add a generic emergency read-only state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, "Jan
 Kara" <jack@suse.cz>, dsterba@suse.cz, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-5-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-5-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] vfs: change_mount_ro_state() skips mnt_make_readonly() on
  sb_emergency_ro()
- [Low] quota: do_quotactl() misses sb_emergency_ro() in Q_XQUOTASYNC
  and Q_SYNC
--

commit aa167d356b416c1c40da72fb215b9d988cb411bc
Author: Christian Brauner <brauner@kernel.org>

fs: add a generic emergency read-only state

This commit adds an SB_STATE_EMERGENCY_RO superblock state flag and
updates VFS paths to reject modifications with -EROFS when a filesystem
switches to emergency read-only mode without setting SB_RDONLY.

> diff --git a/fs/namespace.c b/fs/namespace.c
> index 9f6ec35c7b9cd..55fa09818ef90 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -396,7 +396,7 @@ static struct mount *alloc_vfsmnt(const char *name)
>   */
>  bool __mnt_is_readonly(const struct vfsmount *mnt)
>  {
> -	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb);
> +	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly_any(mnt->mnt_sb);
>  }
>  EXPORT_SYMBOL_GPL(__mnt_is_readonly);

[Severity: Medium]
Does changing __mnt_is_readonly() to check sb_rdonly_any() cause
change_mount_ro_state() to skip mnt_make_readonly() when sb_emergency_ro()
is set?

fs/namespace.c:change_mount_ro_state() {
	bool readonly_request =3D (mnt_flags & MNT_READONLY);

	if (readonly_request =3D=3D __mnt_is_readonly(&mnt->mnt))
		return 0;

	if (readonly_request)
		return mnt_make_readonly(mnt);
    ...
}

When a read-write mount has open writable files or active writers and the
filesystem enters SB_STATE_EMERGENCY_RO, a mount(2) call with
MS_REMOUNT | MS_BIND | MS_RDONLY (do_reconfigure_mnt()) sees
__mnt_is_readonly() =3D=3D true, skips mnt_make_readonly(), and sets
MNT_READONLY via set_mount_attributes() without calling
mnt_hold_writers().  If reconfigure_super() is later called to remount the
superblock read-only, sb_prepare_remount_readonly() skips mounts that
already have MNT_READONLY set and transitions the superblock to SB_RDONLY
while active writers remain on that mount.

[ ... ]

> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 33bacd7075800..b488fb1f9cc44 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -783,6 +783,19 @@ static int do_quotactl(struct super_block *sb, int t=
ype, int cmd, qid_t id,
>  	if (ret < 0)
>  		return ret;
> =20
> +	/* An error made the filesystem read-only. */
> +	if (sb_emergency_ro(sb)) {
> +		switch (cmd) {
> +		case Q_QUOTAON:
> +		case Q_SETINFO:
> +		case Q_SETQUOTA:
> +		case Q_XQUOTAON:
> +		case Q_XQUOTARM:
> +		case Q_XSETQLIM:
> +			return -EROFS;
> +		}
> +	}
> +
>  	switch (cmd) {
>  	case Q_QUOTAON:
>  		return quota_quotaon(sb, type, id, path);

[Severity: Low]
Should Q_XQUOTASYNC and Q_SYNC also be rejected here when
sb_emergency_ro(sb) is set (and quota_sync_one() guarded by
!sb_rdonly_any(sb))?

In do_quotactl(), Q_XQUOTASYNC still checks sb_rdonly(sb) instead of
sb_rdonly_any(sb), returning 0 rather than -EROFS in emergency read-only
mode:

fs/quota/quota.c:do_quotactl() {
    ...
	case Q_XQUOTASYNC:
		if (sb_rdonly(sb))
			return -EROFS;
		/* XFS quotas are fully coherent now, making this call a noop */
		return 0;
    ...
}

Q_SYNC and quota_sync_one() also call ->quota_sync() directly, relying on
dquot_quota_sync() rather than do_quotactl() to reject emergency read-only
superblocks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D5
