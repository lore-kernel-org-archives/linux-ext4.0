Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657819;
	b=20tAKDX7xXSKklAHlmxnvjkzS4lBxwUNE7dkW1J4Ksa/UUWnw/avorpw71uPDEvVNGzm
	 1UyIF2CRtrotSpR9E+WSZNKHgg0+Ui0s8w0GBzmkc8CR5lY3kpuGcoWxyEbhkE7YMJ5oy
	 /nkGy6M0c0G9TkPUn/Az9RdqF/Juti6FpYWfhXTwKJh3qW96kqGxqzvcx5xWp20Berkb7
	 BFOdIIDpQZjkWvUN+wSHn+469Zq10sHwpjflHhychCnIc2XyqTIzMSboA8/RREnB5Tycn
	 SNIJf0q6yc03T7JIbtjGOFubsZ5zSipPVA8Q9n0XODqI9IsT7YQoq4KufTVBgMEg6FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657819;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O9aEDQnPlgsg5A+33Arr73AkdxoSxY8KrxbvcSsrOk0=;
	b=sV+lQcX4TUWoWqhk4hur4K7MtA1LQqN4k1N+eBJnXje+ZSy44KtiYCcezsH2KyZXCd0x
	 R03gwwXZTO03ZlOSuiZmjSTrA/XT19CzxZWMJRXQZDFybBYOoR3rrrkORNDT/SkXIjB0s
	 osgSci7q2BO4E1pnW+xZrZ+WQ9a74B1hNXScuFAPr3axxFrlLpAouypdIDA96TUy5w8K2
	 sWYVx+gHeU/mnuDcdUhafSMqEpP/C4UEdI0AcMPn5NJZrJn5363U76yjyRpBE2TbhoeEn
	 lnhd7DNDcLkgFC3h1JWJOTSdJ6M81tptWKWUmt3d7g9YQxhuVLB/jPxciCG+8qaOI+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fc+jfklO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889D2606A880
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fc+jfklO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAAC1F000C5;
	Sat, 14 Nov 2026 12:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657819;
	bh=O9aEDQnPlgsg5A+33Arr73AkdxoSxY8KrxbvcSsrOk0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fc+jfklOmIr9g20OFdXsPQjh/o4zomReP5PkmG0MgAuC2c6dvIPa9ZVpbiXF3o0bC
	 n5q8DZxDAMlEUycawkiod6xTi5DCxk1IIF667P0HK6954vXb4l/bAGlt0qEz9Yiice
	 MuZuceJe/iMCLuWd7jeBBj2muNvF1uVkN6nNSQ8yS0srMIHhKCnpI/FCA1bhkMREEQ
	 dnGP8ZGQubClkIueh/XP05DIY95u14R8YNJr0PHe+nYTAC+uCx2oqKsTR0eJgXevJl
	 J3aXRRSy5LAei1NCKfHVsrvDBg6kETGY/v/UdXQuTXQZXmfbHrecuheBgGJ2nRXeGw
	 Asc6zR03Wf13w==
Message-ID: <sashiko-outbox-214469@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 18/33] hpfs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-18-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-18-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:38 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> With errors=3Dremount-ro, the hpfs default, hpfs_error() sets SB_RDONLY on
> the first error without holding s_umount. If that happens while the
> filesystem is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked so every writer hangs.
>=20
> hpfs_error() is also called from hpfs_fill_super() where nothing can
> freeze the superblock yet, so keep setting SB_RDONLY there. After that
> call sb_set_emergency_ro() instead and let the VFS refuse modifications.
> FITRIM is refused and unmark_dirty() does nothing in that state so the
> next mount reports the volume as improperly stopped. hpfs_map_dnode()
> and hpfs_lookup() treat the state like read-only so lookups behave as
> before.
>=20
> After a remount to read-only a remount to read-write fails until umount.
> A plain remount to read-write right after the error succeeds but the
> filesystem stays read-only. A remount to read-only doesn't write the
> spare block. Writes through file descriptors opened before the error
> fail with EROFS.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D18

