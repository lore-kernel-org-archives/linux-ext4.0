Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376601;
	b=TcoV8AULkPt5Z9Z9YmlZiSoP1f9/4HJzUum0XJ/DFqBEqPu2Vc/5NUiY2ywn/9nivZoP
	 bXTtcllyrgYm7Sj8uJkS4RF3YNW+YspbX4vTm5megKqQFlhDN+muODZoEpUdqVm0MB/F+
	 L3UWqQOK56P94PLigumhBvoJek/7xDwfGN0as2uHWm5n6yA1yQ1/IdgxcefUWN5H0cj4s
	 rAsEQ92VMbAkIo9HQ2Fu6u/1wQckxzxOEYk8ngfTZSiyr7N8hUOuav9jE1tXJixT7+y+I
	 9ZxNOPIB1Zt9U04QgLr6qLzCXuJ1bXnO8TxT9Q94BdgzMq8Jztilv//HaorH0ZJdGoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376601;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HpK7quIqCTgqV5DlEcheI+xByqT0+9Nk7U/tbf+hsfQ=;
	b=ae9p+jp78EEWKFCTIxqnLpETFyhx5JZCux3LvAgZY+vRSQzcw0y1ZMPfuKhGxjHQ10Gh
	 b+n+r54Fs19VC1TYNG9l+EPoLJmzSWwKJ/3aTiAWXSBqtwvMSOL3h0XQFoboKZslSSium
	 8yudFZ3+fq5qGcIVL9FtiTB3/5uQqbWT3SvcunxPO7VXZbmeFkXav6q7rnzkbpFxQdhJY
	 emI15J2j8iytO0sFmalTo3xRZhZ//gmpkL1PgmXFR7SWMibKJvQXXsr7WOgM0mfRiSC2Z
	 aXPUiMVEoJ7hAPInbksXaTWFOg5Fu3e8kzFhj3xuWHyW8qmX504J4DRsNzTEia/c69g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O9evMUe2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CB8606A31E
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O9evMUe2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A5C1F00A1C;
	Fri, 30 Oct 2026 16:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376601;
	bh=HpK7quIqCTgqV5DlEcheI+xByqT0+9Nk7U/tbf+hsfQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O9evMUe2b4wWpN9VBru5ojVZVbOeVb5AKHGFk1Ys2tkcTw76IEvTNV+FsoMB1QdU7
	 M+XBfgb/d82A0ME+Gs+cFHZTiyMJ4QsW9LKzUZ8wIZJxZ5kYO5SwkDH/bN+I2aL7VZ
	 uTcbFCcJc/6yq5pNfrhrShPnATrEk5KyyrnFR0yt1TN2RJSzVELvQZuX+tiKqQLfgP
	 xW4t9cEmcW1KvKY5/hSL8Rw8x4+MtDEgm917+DFdbOcRGifG75q5gIDu2VeCrK2wte
	 nb691xc6S6AkwKLPk9FkZU9B+dMUq8x172lCXt8qRcen8ZmiqDI7KnqRInYSZUyqQa
	 PO7aVhFtjw/sg==
Message-ID: <sashiko-outbox-191233@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/34] affs: don't set SB_RDONLY after filesystem
 errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-14-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-14-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:00 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> affs_error() sets SB_RDONLY from whatever context hit the error and
> without holding s_umount. If that happens while the filesystem is frozen
> through bdev_freeze(), e.g. by a device mapper suspend, thaw_super()
> sees a read-only superblock and leaves the s_writers rwsems locked so
> every writer hangs.
>=20
> So call sb_set_emergency_ro() instead and let the VFS refuse
> modifications. affs_write_inode() refuses as well and
> affs_commit_super() leaves the root block alone in that state.
>=20
> A remount to read-write fails until umount. A remount to read-only works
> and keeps the bitmap around because evict and the last close still free
> blocks, affs_kill_sb() frees it. Writes through file descriptors opened
> before the error fail with EROFS.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D14

