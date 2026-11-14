Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657810;
	b=3TFUHeM23ecXTY+NAgB/u8Ss4JYgPB+GVeaO3EXBbB3PyJUPfUOKkMerzdmunz+oD8UC
	 XJxp6SqAA5UVfTP+1MJOSxrYudRx5G1v0eHC6cYce59/Zsa8bTqO/vd5zJ/dpxYOB3oJy
	 jcbJMcfmBsOv37MCB8KDuoUzG43HrCbuNtq8oPaUQwmtfD6bFgnoAq5V1kYWEoMODI2/a
	 Pwm2J4QcgrDL98LtFVBZIIHJuENkxGo7zf5XfR7vcP2jsOchVjhYF0u/3zGIHY7UNgxS7
	 z2uOwNLOai0jc/7A9joj3i7hwaoLnhZPmgxnYqDOX/Cfx1CV2cxlYxr78MaWn3wXKGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657810;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fzJQnWudTQCHm+uqR9sgBU+g3viRh3WjJWkpcZqPhVY=;
	b=ZIC44VFls8B09IFdv2UJncBUv/tWHUrm/vG0COCG33hYDPFzTQHHqIwxb9YWK+h3xjQv
	 UyUgwhFUYidg1hRlEKayYmhhjfn0mdbsDjle95Hs9itZDuIBnLoz1pF2aLwrhXyhFrHws
	 aW/rl/6AAx4nP8LbZi5fO9boqTMyuN5IfQG+VKAMi64fwMKyhA6d15ors+J37DHxmXQEr
	 Pu4dIaMHZvgHEqDTYqT5HTTjVhOvqF4xWEOBr3SO74Luj0z/yS4P7ej+zcnwcO3BqZeiv
	 zizaEoJeCFxsQTIxMJgq7EtcQ6Vj5lRDnX+w06vipPBdkl6muy7RufVkGNB1n7s2VtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NwjhBWLw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E42606A884
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NwjhBWLw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A87B1F000C4;
	Sat, 14 Nov 2026 12:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657809;
	bh=fzJQnWudTQCHm+uqR9sgBU+g3viRh3WjJWkpcZqPhVY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NwjhBWLwOrSToTBxY/bl8kOG29WtArNyd1eD3cd9v9TBnrDmChCO2AdlYwA6y3+ez
	 +SXRKbdqNWci1JJh4fihOdI+fKUvbTSZa5waJrdJv6Ycmf0Dknwmd2bh/MC5tXNd8B
	 SifcCNw2UqshHh19q/vG4+x9HxV1h8+sunOfLHal6mWsj4qOLqdtem1sj3uDNOOBQe
	 X7qtL81LK0WUNDfw5S+MOl/q4sUboJKzRV5LQQVwHBRGPYkrSryunWa+NaquDZutp4
	 AB/b+YoFRCFrzqwbhw5cHNdxMd0oC2o9n8Yc+aOqivXGRCNk0Y5Fzj3HHU8BDxi/ap
	 oXbQDBuK9eYlw==
Message-ID: <sashiko-outbox-214461@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/33] exfat: keep the current mount options on
 remount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-10-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-10-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> exfat_init_fs_context() only inherits uid, gid, fmask and dmask for a
> reconfigure. But exfat_reconfigure() refuses to change iocharset,
> keep_last_dots, sys_tz, time_offset and allow_utime. So every remount
> that doesn't repeat a non-default value for one of them fails with
> EINVAL, including emergency remount (sysrq u) which passes no options at
> all. And an option-less remount silently resets errors=3D, zero_size_dir
> and discard.
>=20
> So start a reconfigure from the current options like gfs2 does. The
> iocharset string stays NULL in the new context because
> ->init_fs_context() runs without s_umount for mount(2) and a concurrent
> remount could free it. It's only compared if the remount names one. A
> shutdown turns discard off for good so exfat_reconfigure() keeps it off.
>=20
> The next patch stops exfat from setting SB_RDONLY after errors. An
> errored exfat then stays read-write and emergency remount would run into
> this as well.
>=20
> Fixes: e6fd5d3a4317 ("exfat: support modifying mount options via remount")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D10

