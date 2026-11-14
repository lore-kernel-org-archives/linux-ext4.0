Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657812;
	b=BE3c1aw23vgGIBRYsILPeAm0NSP/OqlCGTxjizXF9FOwgXq9pJ2LiP4wS3iyN9W5H7Rx
	 F+IA0GCyPp80AU7QJ07+X0T+Vaaf4TN/Gbcxm8DsNjRx12LwpTZ1WQFKj5Gz64UJjD6Ui
	 sHzzIrClBkgwl2H8XraKPs0hFPXayEu/0ZdpGbcYa8qW5u4EWvIXgrps6oYZWs+3AjpDp
	 C46OTsplZucYYXqtlvm5usVRgpEmNv/iekHld3xCxwri407cp7UvbwCrsR3mmlKkP1o2W
	 IkyJVgbXSXWl6sm3D3kEPsRCEYaSkCNmL6K7UW5WFCEZIiLfClFl2OkX8mQellcf/cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657812;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qsiCTf5/ZDJAgI16zRoAOBgO8sIWPIPaiYYrEaqBQl0=;
	b=GW9rhcxv5JbRPSkXfssY3I0HjLXDpPB3tA7wNmJmSIQBw7+FEXqYwj4y7+DpS72bSRaD
	 Rl+YHmfYVkSEBZxpmuYZ3Hs3qH9b2czBwTgvGHmXgDNWHJQ2vnkApTxTJL+RMg70rclEl
	 NYLrsXmbm3NsgZwtXta+cnC1fNqBfdBcJWzSj3eil84lrQYr5tTYajUnD1lT0Esu+p+od
	 gOxwtApOxSesoaX5vsHk63XuzG4HOuBQrRx9Oq2Xo529yO0ezi3WOJ5trrwi3B4H1hUIB
	 1zOLX0uVr4p/EmEt3AAzUiIiM7GjCBXRwQOdlTCFuTB57s1SBKKSE8fvs8LhE2iMtiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNbrcs4Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9F606A333;
	Sat, 14 Nov 2026 12:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNbrcs4Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA991F000C5;
	Sat, 14 Nov 2026 12:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657812;
	bh=qsiCTf5/ZDJAgI16zRoAOBgO8sIWPIPaiYYrEaqBQl0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LNbrcs4YE9ttSburmbb6iJ9AMZSDEZsciXFVPdhD9V9DlJQLfjlM7FPiVXi7l9Gwe
	 nYeFvAv5JAjF9k8eBJ27Z/pvT/pGhWSE0qlDGGLMnYhWbsNJByvQdKxRGdUgOnOd3T
	 FrNF2fag/r/bvDutXeoOnOVYgZEH/qpnkaplk+hKj0lyEdJyDPzRy+DTwDrHTwcBWd
	 O3oFIPg2Xhd2sNcsEFmNdC8+wgVXv0X58KKsMxRHlQ1NE8HXpLiqzHwqYlwUONMoEJ
	 Eh58T9nMmlbVadQRoGpQvkVYHUInJjGW235heNs7vHgQ3+zEg+xtEqQsCbamIG7jEW
	 4919mVQ2HqZ1Q==
Message-ID: <sashiko-outbox-214463@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/33] exfat: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-12-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-12-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:31 +0000
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
- [Medium] exfat: race with emergency read-only transition in
  exfat_force_shutdown()
--

commit 55555fc2a6a36c47e1e61fcbe8c22b69f7d5a5f8
Author: Christian Brauner <brauner@kernel.org>

exfat: use the generic emergency read-only state

This commit replaces EXFAT_FLAGS_EMERGENCY_RO with the VFS generic
SB_STATE_EMERGENCY_RO state and skips freezing in exfat_force_shutdown()
when the superblock is already in the emergency read-only state.

> diff --git a/fs/exfat/super.c b/fs/exfat/super.c
> index feeda41a80741..e3587ed270245 100644
> --- a/fs/exfat/super.c
> +++ b/fs/exfat/super.c

[ ... ]

> @@ -176,6 +176,11 @@ int exfat_force_shutdown(struct super_block *sb, u32=
 flags)
>  	if (exfat_forced_shutdown(sb))
>  		return 0;
> =20
> +	/* After an error there is nothing to sync and freezing fails. */
> +	if ((flags =3D=3D EXFAT_GOING_DOWN_DEFAULT ||
> +	     flags =3D=3D EXFAT_GOING_DOWN_FULLSYNC) && sb_emergency_ro(sb))
> +		flags =3D EXFAT_GOING_DOWN_NOSYNC;
> +
>  	switch (flags) {
>  	case EXFAT_GOING_DOWN_DEFAULT:
>  	case EXFAT_GOING_DOWN_FULLSYNC:

[Severity: Medium]
Can exfat_force_shutdown() abort without setting EXFAT_FLAGS_SHUTDOWN if a
filesystem error sets SB_STATE_EMERGENCY_RO while bdev_freeze() is running?

CPU0                                    CPU1
exfat_force_shutdown()
  sb_emergency_ro(sb) -> false
  bdev_freeze(sb->s_bdev)
    ...
    freeze_super(sb, ...)
      sb_wait_write(sb, ...) /
      sync_filesystem(sb)
                                        __exfat_fs_error(sb, ...)
                                          sb_set_emergency_ro(sb)
      if (!ret && sb_emergency_ro(sb))
        ret =3D -EROFS;
  if (ret)
    return ret;  <-- aborts without shutting down

Because freeze_super() checks sb_emergency_ro(sb) both on entry and after
sync_filesystem(sb), an in-flight writer or writeback error during the
freeze makes bdev_freeze() return -EROFS.  exfat_force_shutdown() then
returns -EROFS without setting EXFAT_FLAGS_SHUTDOWN or clearing
opts->discard.  Ignoring -EROFS from bdev_freeze() when sb_emergency_ro(sb)
is set would still complete the shutdown.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D12
