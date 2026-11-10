Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794342949;
	b=mErtQbNhXg/sI5Wc3rbe0tED8VQ5ieDwEkVR7ycNw7qK3iC3KOlYJJoM5Qiu7fNXp8Hj
	 8MCJdoPAjawJkozNsQrlUsAI/GNRC6XsLEsFHvmA8aYxrtYpgWEf4XldMASqqtf4SJwXL
	 fHZCay2oDfZ/Iv/7pOeI1JSMi+HxO/Jz+Y0yrxTIJkz0jn7xvYU8EZVk546WCAoKE/3Ja
	 WnfQ0h6ws9xvNSgU+s/HOMBXvW5YIFyt8heU9fGrbZCr/Tn2Ly9LwtKCrq/eD3K6jVoBg
	 NejKRV8gGLIg1vJyNNtjlRCRRLnAPVC7jydhAXb7u5DzwI8OWyOUTypYQ4rJPCJdSqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794342949;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=H/yC0PobEp394m3I+tt1fmMC8uiuzh4RYEWUPIL8538=;
	b=yuz3S1VoeX+vLIl9AdViWGactSv1FzEWk8Aow9Ts2ws09lkR6WTCWd1f+N513tj2T3eL
	 NPCDT21nqOvsTTWW+2S8XL+cdieQBPHgqb/Cjmui9qePqwfTKukrWR3DP+zlpiG6wk35o
	 Khy/R5T0TSyRRp+YVpzvzeLkvI8aVGrD8oVmVVDNPvNNkpj6AQPc9haMDjFZ6sZGjKVHF
	 LLhoEZuO8w7ZrLSlIbQdarJ4cdFkoa3PMhC7Y2XE6HTZuaGCTxYrx6ZBfhN23RgGa30HD
	 zzDhSKI0nfzx5AKmpdpH4OPaj73pZoU6qSRKuS/3ByZDC25+oflSB5OM0zp+GKbWdug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h1naUZDf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF55606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 20:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h1naUZDf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4431F0089F;
	Tue, 10 Nov 2026 20:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342949;
	bh=H/yC0PobEp394m3I+tt1fmMC8uiuzh4RYEWUPIL8538=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h1naUZDfmPAqjo4M2wphGHQxnFPTg2XHgX6DBn7G+7vkCAlh8ywMEjkGVHCWFdWKK
	 OjJbLNjXrrEfpB/bEHtxJ37BfQmm4/o04E/myJ9nOK/Gi8Aedhg2826SYG5KJhSNSN
	 osjz972yx+boQyV4AZLvUXs8FbNUwc2UZs4uN9DDIgxxfXZPKSeSelZVxj9erPgVEC
	 iy7r8NuWzwsHS+75SbRV4lTmrQteBIe3dhTklk3Z7y93nNFB0ZF8eVEA1o7dE8l5ps
	 lB1bVvzu+tdv56Nq/g5EMTsP7BI5G9rcCu9GAdSdGLTvIxAxqBdveqpLg6k3FZq5d+
	 Jsib9UQFdhlvg==
Message-ID: <sashiko-outbox-207714@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 11/11] xfs: restart faults racing with realtime flag
 changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-13-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-13-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:35:48 +0000
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
- [High] xfs: transaction reservation mismatch in
  xfs_iomap_write_direct() on flag race
- [High] xfs: missing xfs_get_extsz_hint() recheck in
  xfs_buffered_write_iomap_begin()
--

commit b8ad8d7e86ab00a3a7fbbde54047f3e1c17b5837
Author: Chris Mason <mason@kernel.org>

xfs: restart faults racing with realtime flag changes

This commit rechecks xfs_is_zoned_inode() under the ILOCK in the write
iomap paths and returns -EAGAIN if the realtime flag changed during a
page fault.

> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c3465204b8d52..83ff105154b55 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c

[ ... ]

> @@ -334,6 +351,11 @@ xfs_iomap_write_direct(
>  	if (error)
>  		return error;
> =20
> +	if (xfs_is_zoned_inode(ip)) {
> +		error =3D xfs_iomap_rtflag_changed(ip);
> +		goto out_trans_cancel;
> +	}
> +

[Severity: High]
Can xfs_iomap_write_direct() still proceed with a mismatched transaction
block reservation when FS_IOC_FSSETXATTR races before
xfs_trans_alloc_inode() takes XFS_ILOCK_EXCL?

xfs_direct_write_iomap_begin() drops XFS_ILOCK before calling
xfs_iomap_write_direct(), which then reads xfs_get_extsz_hint(ip) and
XFS_IS_REALTIME_INODE(ip) unlocked to compute resaligned, dblocks and
rblocks:

fs/xfs/xfs_iomap.c:xfs_iomap_write_direct() {
	...
	resaligned =3D xfs_aligned_fsb_count(offset_fsb, count_fsb,
					   xfs_get_extsz_hint(ip));
	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
		dblocks =3D XFS_DIOSTRAT_SPACE_RES(mp, 0);
		rblocks =3D resaligned;
	} else {
		dblocks =3D XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
		rblocks =3D 0;
	}
	...
	error =3D xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
			rblocks, force, &tp);
}

On a zoned filesystem, toggling FS_XFLAG_REALTIME on and off before
xfs_trans_alloc_inode() locks the inode leaves xfs_is_zoned_inode(ip)
false at the check above, while tp->t_blk_res only covers metadata split
blocks:

CPU0 (write fault)                CPU1 (FS_IOC_FSSETXATTR)
xfs_direct_write_iomap_begin()
  xfs_iunlock(ip, lockmode)
                                  sets XFS_DIFLAG_REALTIME
xfs_iomap_write_direct()
  XFS_IS_REALTIME_INODE(ip) =3D=3D true
  dblocks =3D XFS_DIOSTRAT_SPACE_RES(mp, 0)
  rblocks =3D resaligned
                                  clears XFS_DIFLAG_REALTIME
  xfs_trans_alloc_inode()
    xfs_ilock(ip, XFS_ILOCK_EXCL)
  xfs_is_zoned_inode(ip) =3D=3D false
  xfs_bmapi_write()
    xfs_bmap_btalloc()
      xfs_trans_mod_sb()
        tp->t_blk_res_used > tp->t_blk_res
          xfs_force_shutdown()    <-- forced shutdown

While FS_XFLAG_REALTIME is set at the unlocked check, passing rblocks > 0
to xfs_trans_alloc_inode() on a zoned mount also calls xfs_dec_frextents()
directly and can fail with -ENOSPC (returning SIGBUS to the fault) before
reaching the xfs_is_zoned_inode(ip) check.  The same reservation mismatch
happens in a single step if FS_IOC_FSSETXATTR changes FS_XFLAG_REALTIME on
a non-zoned realtime mount or increases ip->i_extsize in that window.

[ ... ]

> @@ -1865,6 +1896,11 @@ xfs_buffered_write_iomap_begin(
>  	if (error)
>  		return error;
> =20
> +	if (xfs_is_zoned_inode(ip)) {
> +		error =3D xfs_iomap_rtflag_changed(ip);
> +		goto out_unlock;
> +	}
> +

[Severity: High]
Should xfs_buffered_write_iomap_begin() also recheck xfs_get_extsz_hint(ip)
after acquiring XFS_ILOCK?

xfs_buffered_write_iomap_begin() checks xfs_get_extsz_hint(ip) before
taking XFS_ILOCK because delayed allocations cannot be used with extent
size hints.  In xfs_get_extsz_hint(ip), the return value depends on
!xfs_is_always_cow_inode(ip), XFS_DIFLAG_EXTSIZE and
XFS_IS_REALTIME_INODE(ip):

CPU0 (write fault)                CPU1 (FS_IOC_FSSETXATTR)
xfs_buffered_write_iomap_begin()
  xfs_is_zoned_inode(ip) =3D=3D false
  xfs_get_extsz_hint(ip) =3D=3D 0
                                  sets XFS_DIFLAG_REALTIME
                                  (non-zoned RT with sb_rextsize > 1)
  xfs_ilock_for_iomap()
  xfs_is_zoned_inode(ip) =3D=3D false
  xfs_bmapi_reserve_delalloc()    <-- delalloc with extsz_hint > 0

On a zoned filesystem, the same state is reached if an inode with
XFS_DIFLAG_EXTSIZE has XFS_DIFLAG_REALTIME set when xfs_get_extsz_hint(ip)
runs (which returns 0 because xfs_is_always_cow_inode(ip) is true) and
cleared before xfs_ilock_for_iomap() acquires XFS_ILOCK, or if
FS_IOC_FSSETXATTR sets XFS_DIFLAG_EXTSIZE directly.

When a 1-block fault proceeds through xfs_bmapi_reserve_delalloc() on a
realtime inode with sb_rextsize > 1, xfs_blen_to_rtbxlen(mp, 1) rounds down
to 0, creating a delalloc extent with 0 reserved realtime extents that
later trips assertions in xfs_rtallocate_align() and underflows maxlen in
xfs_rtallocate_extent_size() during writeback.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D11
