Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657827;
	b=vUNV+zf0jEIe/4/XkjFuZ9sJtXavU+LbbkExznALIIk4rrOrZ+UhM+JJAX6zcOlj5WDF
	 eZuxxmQuVkZBytPpWsWtTc+GlDhn9KeCOskRdi3kIXcsj5nCjZck0a8hfKfM6V8ks6CmH
	 f4oTqNbFHhDC7X+bcWK+mpi+FCsep09+t6gsfH0/gvsYjdhxNGQOg3NoYrol2NEa4QN43
	 UP8iVThJX+LmU2A7rLfbuTbLK0fsDFoaw6pzHR6mQwgAQ/Rx8Eog3cRQWEnpZcM43WoHx
	 Vl1koKbN+HkcBmy8Yzyq/I7cGJBPjakjqpofqmFw+8AJvcHfzYFFi1t+Sbv8DhUa7OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657827;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JJm9nfB7C7r+XTvqMLxAZhLsCSVxQL6AYJnn4sY2W+g=;
	b=WSr4O/ytT46QKYPkI6bP/TZLMS2IPPdD9CVabfYnowHagnCXeOk6QwP++fWW+qSej1UX
	 E2t0p101WIGDpxCrHr2whp/qu8ajPRXhS+AYjaLaNbQu+bPvSxM+1XKvYGYjWCcLsEWRc
	 nhyxhSey+CSRa/W0h0YZOT4QD5QkMEHPwB6e23HJnxgHUBc9VBL4CrBJ7e2GheX94ei2N
	 pMwvGKrhMH7G+8E097zMziOSt2pYsI5mN7TQxWFowu49qUEpxvx2H+ka5ZxfZxCLIXKhX
	 ZioJySjsUGssKIqsKwpkaawAcHAAAUF/aA6Ba7VpA90Eeu7l1SGx+rJ8qVwxUkyQImQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Y+jXO/xt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A92D606A336
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y+jXO/xt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C301F000C5;
	Sat, 14 Nov 2026 12:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657827;
	bh=JJm9nfB7C7r+XTvqMLxAZhLsCSVxQL6AYJnn4sY2W+g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y+jXO/xtUP4uGfz7VgMGPLNXa3ztyyR9uAHoR5vYrkbjhsdxsOUff9v/fKtIHD5Fk
	 bssQgepjUdwKjTGg7q88GyMtQPynYkoEKRQHCfkeKw6CamMKJ7CwJQkCf+wgZkVq8S
	 qYZAD+9VLPfPc+2wc/aPQbVaM+C8NgBHsERJ9Aqk4bAfIH/ozbGqI+jF9YpMuvkK1D
	 hFPH9Nvh3Rpnoj3Z8GSLbUA3fq5TluKMevuOGSe6Kq4v0cnOFItbbsTrOhr+Yait7H
	 YC5D6/+6yBvzzcTXK8RyHoSWsfLl6U47cbSkI541ZmDCw23Sp12QtGSBk1N/dQCjd1
	 xvYOacKYz7DvA==
Message-ID: <sashiko-outbox-214474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 23/33] zonefs: don't set SB_RDONLY after I/O errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-23-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-23-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> zonefs sets SB_RDONLY from its I/O error handling without holding
> s_umount: with errors=3Dremount-ro, when the zone report fails and when
> closing an explicitly opened zone fails. If that happens while the
> filesystem is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked. Writers hang and even
> a remount to read-write doesn't help because the next freeze blocks
> forever.
>=20
> So record the error in a new ZONEFS_SB_EMERGENCY_RO bit instead. All
> three places go through zonefs_set_emergency_ro() which keeps printing
> the warning once. Write opens, write_iter and setattr fail with EROFS
> and page_mkwrite with SIGBUS. An error on a read-only mount doesn't set
> the bit.
>=20
> The state lasts until umount and zonefs.rst says so. A remount to
> read-only works and writes nothing. /proc/mounts keeps showing the
> filesystem read-write. ftruncate() and write faults through file
> descriptors and mappings from before the error are refused now too.
>=20
> Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D23

