Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657804;
	b=R1A/PwBtHwRYAT32ZRdUcetK666BcfUw3WUU0pwxJfAn0eketvpyJ34cmpwFsec+XSIa
	 2ndp4etiB9HImd+uINhY21pVj/0U9B4TXk147cbPm0JE1Lr+sdNRcecMMehHjtYDkkCbO
	 lMlOc66h0f6BTISZLPQKn3DE/WV/KojPUAwCl+WuJ6R6fZFo72dbrwuu6dkOaoBrCnQ9T
	 B91ZPG8Esfimcy9trC9Cz7+dMMEm2FhfpDvwLc7/0VWdr999VWr2JO7vjdGG+mxcwSwce
	 dr+77Zu5V8RCJr5X3K99pm38+Rp+RpQ+KzGY3ZdOweFJDScc+90tcOqa1w1NtC0RUwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657804;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DO68Rzpo89jO31dHffp5gsVpEYwW9jdfExydDw1OVz8=;
	b=YRv8b6Dl6cPCauU07rluAVttiJlB7mSidu/Ihz2qgyzAmeY1PUXI+iLyvv5kXoFGZ0xB
	 eRNLfgyry2RVo7pby2761usr2n8dAdtRpPp7tGVecY6UGtoeHOBipF62QzvG04tljsAnR
	 TxBI4+aeRHO9SDXHg5k85RuMi6Mgso/7F4TVtVFvuIp74BW+DoVMffCe6taljR3cq3d/P
	 36Jql8Pn+/stQweCDmtEQA6HGQRAlkjE7BPPpxAXc3nonDYfMqt7btlNZedqPucsAnzKg
	 LQtErVjxyllGMc05kOhaJXsXN+oh85WjfD5B8YTVhuemcL0bv7TNT+RVhfb1VLbkg0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FbiTVbWm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612B2606A881
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FbiTVbWm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB50B1F000C4;
	Sat, 14 Nov 2026 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657804;
	bh=DO68Rzpo89jO31dHffp5gsVpEYwW9jdfExydDw1OVz8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FbiTVbWm64MfiO52sGP0MCGvASqoV43xfSgNUPSOT6cnBN0T1Xt/Q0Wzuwcr0XiLO
	 9MInfYOdGmBRoSQ34iAdUwmSkd0Xp008H0ku9FlBCGFoxRFgGb20Rx5+IambCPQPor
	 9oPsNPWEhZAh/V71C4ChMxAPw2XwZCXTS5pQRK7cNjIoza0qL7N73xc4pDLwrfwiKh
	 8T+/UOa2XHsfyzfvpVjz+CqjvmXrCvIYiSZP/viNiS3JMvMYXcieqPxyLLWuqqfGk+
	 VDp0GQVpqWv8yMMdlYB1rVTCo7JrYdl2V77htwKmubbDFlSRJHqL9nxGOLGLWkIDaR
	 u/jQ0FG9Xv0Pg==
Message-ID: <sashiko-outbox-214455@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/33] ecryptfs: fall back to a read-only lower file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-4-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-4-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:23 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ecryptfs opens the lower file read-write unless the lower inode is
> IS_RDONLY(). A read-only mount underneath refuses that and so does ext4
> after an error since commit d3476f3dad4a ("ext4: don't set SB_RDONLY
> after filesystem errors"). Then every lookup of a regular file fails
> with EROFS. The other filesystems are about to behave like ext4, so fall
> back to opening the lower file read-only. Opening an ecryptfs file for
> writing then fails with EPERM like on top of a read-only superblock.
>=20
> truncate(2) and creating a file still write to the lower file and
> would trip the WARN_ON_ONCE() in __kernel_write_iter(). So let
> ecryptfs_write_lower() and __ecryptfs_truncate() refuse that with EROFS.
> Opening an empty file doesn't try to write the header through a
> read-only lower file at all, read_or_initialize_metadata() skips it and
> the open fails with EIO.
>=20
> Note that ecryptfs never takes write access on the lower mount. On a
> read-only bind mount that was only a problem for directories so far.
> With this regular files can be unlinked and changed through it too.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D4

