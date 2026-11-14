Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657802;
	b=viqqv2flLp/jBULlJ/JBOsRtl49wwUBVr9jxmwzaoFbW23IHlegrFUU+yg4w8DQBlLX5
	 4q5QwBbNDInh2Jef8s5vLrWhUu8ZXZbigbEG0+KpI/N8VlxdY9uoPi1tM+UXYV6sNtiuh
	 xjd1Dm4rAjFtKlja3ZiqpacfAnoySB7oMyoY8hM392G9KFiJDAxOZaUE/y98rPKxGxIk1
	 +pT3dn0ISj2LcDeFu/AQTPE6CoJgfDtiRR4tUOqZFQd06ECroYp9jHg8EMpokoyT6zHp0
	 PwZ49Wd5viuF2rHxA1oHe4Ck9NmDAUznY7QeTzos1jEbm9rduhjJrRm0s8R/cVkCqcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657802;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7GWFMygbnLQavtOBdXIKT0dl2BmInrSql04ijr71sJQ=;
	b=plwkazogG+CKXlCzYR2AnmP1lwA5htBaUWW0LxVzMMwjg1CCI7A56qIB8EYRwnP/WEuA
	 aaSpyBL+gdsjwO6/lFwrLoT5XA2sk3L73kVNoflRCLh8ZjZLeSKu/6uASSAap7DSv3b4+
	 tBTPJdUPVpuMoshd4dNvmRoUffxkISnQGFpx4bYU7QgcEGtDPNI3l1fIjUqlrG0kKlumk
	 Yauyr2V17BkQE6GvM7ICWFrLxYwZeaX3kNZG794QSO9wB4HC1BRpCm6G53Kmc5LigK/L+
	 zV15dB8iXm9sA6zW1SeQ4FKaTSrxVT6VILmSbIuVajRRG7KUv+hpFUQfSMVRNuvtR4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gUfFRUsy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D57606A334
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gUfFRUsy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1131F000C5;
	Sat, 14 Nov 2026 12:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657802;
	bh=7GWFMygbnLQavtOBdXIKT0dl2BmInrSql04ijr71sJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gUfFRUsyuj3gwkKXFLOz9Cl6AvzbkttpiknXoosum+GO6sdykJZutdlzZ74MtA4M6
	 sFYQZnFiI5js7tgoHuhWuFff+b5em4pGwjrlRHAX4cE6MREX4rYgwhilCiGMzLmQje
	 Fdp3tXF+dhhbuc4enz4oaE1ZyU7GYTh4a+5YQbHNATgXyrs6Btpls/E8ga+9UsGB1E
	 vb9vDLRNLNXb52aVKP5TO8lccxyrExde5HIU62bFm1Kkn6tw/ER9KHOXp3I3h2jEB0
	 HyGmTP2t2Y12eoW5xCAV2pngEs7QqFfRBnQijqcvnGt5pahDTtF5X7kAi8QUWbVAND
	 NxYsKcE0V61Bg==
Message-ID: <sashiko-outbox-214453@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/33] jfs: use jfs_symlink_inode_operations in
 jfs_iget()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-2-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-2-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> jfs_symlink() gives slow symlinks jfs_symlink_inode_operations but
> jfs_iget() gives them page_symlink_inode_operations. So once the inode
> has been evicted a chown doesn't go through jfs_setattr() anymore and
> skips dquot_transfer(), and listxattr(2) doesn't see the symlink's
> xattrs. Use jfs_symlink_inode_operations in jfs_iget() as well like it
> already does for fast symlinks.
>=20
> Fixes: c7f2e1f0ac14 ("jfs: add jfs specific ->setattr call")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D2

