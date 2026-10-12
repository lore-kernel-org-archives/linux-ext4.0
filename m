Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAC03ACF1D
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 10:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801897; cv=none; b=jtMoYjjsW9NZFPm1ztKsNk787gpv3ty/xIBTOTHu8yVrVpuvn0jSrOcpuBTdoDANGENBiYHS0oACyin4ZigKas4ifT/2DG8ipub2B2nfY9b3SsCB1cWfg+CrmYrfLAKpEpAES1abIzflRAiT4yQzPbhbmGKTmkC/301X2NW50Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801897; c=relaxed/simple;
	bh=os0XtyoLueiPT1ewQ9ulh3/J1Sge0IW4gI+n1ZfoaTE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YxunqyTlEyDBXqwXZhLZoZFB5nJMTTCvgdoX7dPKkZblrTr7RwZDGTgAfnivPmrDrY/F4Rcl6JxnD9F1lGm/swMeGRb/v843bJEEmWJiTVKqsH5jWjwcGezaJOCtpKq/al0YrUavGeY9hhnEwatGncaYNzX76h9nuZS9OlQuiA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWAvVQIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWAvVQIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2531F0089B;
	Mon, 12 Oct 2026 10:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801896;
	bh=0O1RnapxLGlAavDoNW3ELVSHExfsm5FMX6X3avLW7b4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UWAvVQIguAOccM3vE2j6A2QpN8ia7GX4GKEvXQGG+QmBSLULQ32OW0ePort0gP+f3
	 7SoNF82uG+HIQJLIjpVjB1YPKeEkGyI/1ZNB4S12vrv3SU/Q9RY53/rIZ4bsVPv2Yd
	 4JndTPcOMVJL+BfYPh/GUflsyryhg/x7MiJ+3xP7nP9/8lrvflsBYIhv1F/++tutDA
	 n1nhkcDLjVVgvjyWFdX647rOW/KfDkf7Hc/lvE2xh9iKSrlRyZR+IKqY2cHOX48egZ
	 VMbTG0dbLz/os1a7ACbq7z+oNxefgWdYLiicDdaHwomOFQumG2UyPaz+P4tDhx4HYB
	 xas+rsmaE4F/g==
Message-ID: <sashiko-outbox-167981@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 03/28] ext2: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>, tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz, "Mark
 Fasheh" <mark@fasheh.com>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-3-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
 <20261012-work-fs-sb_rdonly-v1-3-60743a3dc326@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:44:55 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When ext2 is mounted with errors=3Dremount-ro ext2_error() sets SB_RDONLY.
> It does that without holding sb->s_umount and from whatever context
> found the error. That includes a frozen filesystem. FIFREEZE doesn't
> block reads so a lookup in a corrupted directory is enough to get there.
>=20
> That's a problem because freeze_super() and thaw_super() both look at
> sb_rdonly() to figure out whether the s_writers rwsems need to be taken
> or released. A read-only superblock is frozen without taking them. So if
> SB_RDONLY gets set while the filesystem is frozen thaw_super() takes the
> read-only shortcut, skips ->unfreeze_fs() and sb_freeze_unlock() and
> marks the superblock unfrozen with all three rwsems still write-locked.
> Every writer after that blocks forever in sb_start_write():
>=20
>   EXT2-fs (vda): error: ext2_check_folio: bad entry in directory #12: : r=
ec_len is smaller than minimal - offset=3D24, inode=3D13, rec_len=3D0, name=
_len=3D1
>   EXT2-fs (vda): error: remounting filesystem read-only
> [ ... ]
> [1]: https://lore.kernel.org/r/hyhuckyohsabx2suvq3z7uy3pbgmihva6wgzxr3op7=
pzcrlu33@p7zzlgp2ehjf
>=20
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.=
com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-work-fs-sb=
_rdonly-v1-0-60743a3dc326@kernel.org?part=3D3

