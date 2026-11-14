Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657829;
	b=JRXW/xHljot4T+di4KQnX+gKbF1pIpQSf/1gnNpgUa+RqKA+66O3WD/cQIoCmdZpbEMy
	 yW3NZ9MSROKB/RenKRegv+YcRIYQiD4resNu6MQ4cE/oQzw5JKWrycdj4GEs4RPCUW5po
	 jNhhQ/7ryVgJln3SYBl8OREWME3JQQwd8NtBc+iZV7sl7PPFlAtR8rrG4ZnCAdX0QY0F2
	 6GJgwIzt7WtoG5Ngyg6vWuAck2cyByGAiMdHedqXuWJhsLhcp4HJufTiOQp33iF6TAJuO
	 0lZxiJE3tAONvnARyqhNBjQ1ckJf+dVN8RvFlBkpPhxyIE76mcvK2rliPrPAUsnnSLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657829;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9cNpf83TDNUnfk8nTN2RZCY5xNHmz1XB5OVMQtWPcy4=;
	b=xRb3nFApSjRTfWexrc+o/wTkPlW3cywKyWrpUM7hKXJwFiLdQhb5lhFS6/BQOOAGgkSz
	 qEZ0Sx6WrhfljI+jMYseCQLzxuZQ+nWkam7HJsdH0xQVsBx2vqY4iOWWfkkSNrCO53ZwT
	 1x/cQEDtHBeWvtMnMsdcifgjkuCFPqxmUTW66LVM3iwa75j14ge/Y68w6HSQYY/5m2ykV
	 DTNAn+9j92cEI7x+2JIipSVUlPwj4o+vpIso6ONfgaTw2WV+e5RtWZByi0Cgc+a/D3jLu
	 954Gi26WwMeMvp29iJrWj1pP0a+C3Z2kzbi2PvY05WOC5sasCkEUrFgK7t9ZS45UFPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z9kpMK2v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CEC606A33B;
	Sat, 14 Nov 2026 12:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z9kpMK2v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290A21F000C5;
	Sat, 14 Nov 2026 12:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657829;
	bh=9cNpf83TDNUnfk8nTN2RZCY5xNHmz1XB5OVMQtWPcy4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z9kpMK2vr/pVp2iNWYURY8dh/iimkz0Ia1et9sthC6M1MBJaQsDwXRUSwglxFmELm
	 rhi/1FAU8VuXaPq5wxlYsTBfb32WNnHvUE9n37itucz8C/s1XMJ9ESPaBJA8e6TwT1
	 NvW8CYR487VKk2EBACE2P/YEBYTDjG2kB1y1In6mC73iqAzjeLod4Ks8sUZ/EyClc6
	 5Ium761EssSaBlqaAUvj8BQJa85SJ2kg1xnpmJR+7NnrlwRdI53yHUwpVuPiD/GWDQ
	 K6lJRLJ1caDd+9Eh41NHAPcytnfX30ZhN3D+u5y09MO5qKWyBgi1c3oXulVewl6bgv
	 ToDQcETgKP/Nw==
Message-ID: <sashiko-outbox-214477@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 26/33] btrfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-26-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-26-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:48 +0000
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
- [Medium] btrfs: btrfs_super_sync_fs() and btrfs_freeze() return 0 on
  shutdown or error
- [Medium] btrfs: race between BTRFS_FS_STATE_RO and
  sb_set_emergency_ro() on fs error
--

commit 3d297b218ce5c34d64ff204c632eaa6ac7a2526b
Author: Christian Brauner <brauner@kernel.org>

btrfs: don't set SB_RDONLY after filesystem errors

This commit stops setting SB_RDONLY in __btrfs_handle_fs_error(), using
BTRFS_FS_STATE_RO and sb_set_emergency_ro() instead, and updates shutdown,
remount, sync_fs, and freeze handling for the new read-only state.

> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 024c3ec7d0583..39fd1a04d25ba 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
[ ... ]
> @@ -1233,15 +1232,12 @@ static inline bool btrfs_is_shutdown(const struct=
 btrfs_fs_info *fs_info)
>  static inline void btrfs_force_shutdown(struct btrfs_fs_info *fs_info)
>  {
>  	/*
> -	 * Here we do not want to use handle_fs_error(), which will mark the fs
> -	 * read-only.
> -	 * Some call sites like shutdown ioctl will mark the fs shutdown when
> -	 * the fs is frozen. But thaw path will handle RO and RW fs
> -	 * differently.
> -	 *
> -	 * So here we only mark the fs error without flipping it RO.
> +	 * A shutdown isn't an error, so don't use btrfs_handle_fs_error().
> +	 * BTRFS_FS_STATE_RO doesn't touch SB_RDONLY, so it's fine while the
> +	 * filesystem is frozen, e.g. for the shutdown ioctl.
>  	 */
>  	WRITE_ONCE(fs_info->fs_error, -EIO);
> +	set_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
>  	if (!test_and_set_bit(BTRFS_FS_STATE_EMERGENCY_SHUTDOWN, &fs_info->fs_s=
tate)) {
>  		btrfs_crit(fs_info, "emergency shutdown");
>  		fserror_report_shutdown(fs_info->sb, GFP_KERNEL);
[ ... ]
> diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
> index cedca40508315..3a768e2ac1ccf 100644
> --- a/fs/btrfs/messages.c
> +++ b/fs/btrfs/messages.c
> @@ -173,8 +173,12 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *f=
s_info, const char *function
> =20
>  	btrfs_discard_stop(fs_info);
> =20
> -	/* Handle error by forcing the filesystem readonly. */
> -	btrfs_set_sb_rdonly(sb);
> +	/*
> +	 * Handle error by forcing the filesystem readonly. SB_RDONLY needs
> +	 * s_umount, see sb_set_emergency_ro().
> +	 */
> +	set_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
> +	sb_set_emergency_ro(sb);
>  	btrfs_info(fs_info, "forced readonly");

[Severity: Medium]
Can setting BTRFS_FS_STATE_RO before sb_set_emergency_ro(sb) let concurrent
callers observe btrfs_fs_rdonly() =3D=3D true while sb_emergency_ro(sb) is =
still
false?

set_bit() is a relaxed atomic operation and __btrfs_handle_fs_error() retur=
ns
early when btrfs_fs_rdonly(fs_info) is already set:

CPU0                                  CPU1
__btrfs_handle_fs_error()
  set_bit(BTRFS_FS_STATE_RO, ...)
                                      ksys_syncfs()
                                        sync_filesystem(sb)
                                          btrfs_super_sync_fs(sb, 1)
                                            if (btrfs_fs_rdonly(...))
                                              return 0;
                                        if (sb_emergency_ro(sb))
                                          /* still false, returns 0 */
  sb_set_emergency_ro(sb)

During this window, syncfs(2) and freeze_super() can see btrfs_fs_rdonly() =
=3D=3D
true in btrfs_super_sync_fs() and sb_emergency_ro(sb) =3D=3D false in the V=
FS, so
they return 0 without syncing instead of failing with -EROFS.  Similarly, a
second thread entering __btrfs_handle_fs_error() sees btrfs_fs_rdonly(fs_in=
fo)
and returns early to its caller before CPU0 sets SB_STATE_EMERGENCY_RO, so a
subsequent btrfs_ioctl_shutdown() or VFS call on CPU1 can still observe
sb_emergency_ro(sb) =3D=3D false.

> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b424cc836bd4a..ff61ec9ebfa79 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1041,6 +1041,18 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  	return btrfs_commit_transaction(trans);
>  }
> =20
> +/*
> + * Nothing can be committed after an error, don't fail syncfs(2) and fre=
ezing.
> + * BTRFS_IOC_SYNC calls btrfs_sync_fs() directly and still gets the erro=
r.
> + */
> +static int btrfs_super_sync_fs(struct super_block *sb, int wait)
> +{
> +	if (btrfs_fs_rdonly(btrfs_sb(sb)))
> +		return 0;
> +
> +	return btrfs_sync_fs(sb, wait);
> +}
[ ... ]
> @@ -2308,6 +2326,9 @@ static int btrfs_freeze(struct super_block *sb)
>  	struct btrfs_fs_info *fs_info =3D btrfs_sb(sb);
> =20
>  	set_bit(BTRFS_FS_FROZEN, &fs_info->flags);
> +	/* Nothing can be committed after an error. */
> +	if (btrfs_fs_rdonly(fs_info))
> +		return 0;
>  	/*
>  	 * We don't need a barrier here, we'll wait for any transaction that
>  	 * could be in progress on other threads (and do delayed iputs that

[Severity: Medium]
Does returning 0 when btrfs_fs_rdonly() is true cause syncfs(2) and
freeze_super() to succeed without flushing after a forced shutdown?

btrfs_force_shutdown() now sets BTRFS_FS_STATE_RO without calling
sb_set_emergency_ro(sb).  After BTRFS_IOC_SHUTDOWN with
BTRFS_SHUTDOWN_FLAGS_NOLOGFLUSH (or btrfs_shutdown()), dirty data and
transactions were not flushed, yet sb_emergency_ro(sb) and sb_rdonly(sb) are
both false.  Calling syncfs(2) or FIFREEZE then reaches btrfs_super_sync_fs=
()
and btrfs_freeze(), which see btrfs_fs_rdonly() =3D=3D true and return 0 in=
stead
of failing as btrfs_sync_fs() and btrfs_commit_current_transaction() did via
BTRFS_FS_ERROR(fs_info).

In addition, if an in-flight transaction aborts while freeze_super() is
waiting in sb_wait_write(sb, SB_FREEZE_FS) (after freeze_super() already
checked sb_emergency_ro(sb)), btrfs_freeze() now returns 0 and lets the fre=
eze
succeed on an errored filesystem.  The comment above btrfs_super_sync_fs()
also says not to fail syncfs(2) and freezing after an error, whereas the VFS
fails both with -EROFS when sb_emergency_ro(sb) is set.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D26
