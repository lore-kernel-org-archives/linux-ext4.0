Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376597;
	b=BetRvWbGZHCGrtIBWgJX27j2qI3YMa6t9iSkfnrYx7zmcgOI2OiZ6RJ/lKIVuaTxZ8WV
	 sCeON9psMTkgsDJRCMGcg24UanNzltnYDlIOjLiL1Atc5IY90CkZ0O6Lp4ZGzmbCndWd6
	 8Fsj6oJvBNQx0mdgwDNjwG47ZF2+g5uQjAnMafYYWLaCKfUO+PWZagea2lHh2RGUi6VPs
	 OVGrIrlrk2DxDflPOGzi+1JgB6eUZOcU6E4WM+iCZBnjg5Q5aNdB5Pbezpznl0E935J/T
	 42T+mUrz2Wp1zr/mY7PU6wJlSN/bGq+MhWhiBqQeRlROLVqJNWSoyU3W+X6G9XtCsNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376597;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rxveYFT6QpDhrP31/KqFxVPakYspiuvj9sanDbLeonM=;
	b=m3dLLrP1zn+KvVawpRyg0INlkTaqcIPbhgoTcl4o5zGD490b17J/4deiYUxZ7t/dyKmq
	 gELO4UNjMw0+A8njoTuSqKWCVvDu8Il4Vqa+AfrzF36XG5XFR2GcRPxMrY2jdGIETrAcH
	 XhuvLycg6W7HBhIpGW6VYwurumSI9RmgBcVzn8T7+HU1PZMkgunQSjHqz9VFYFEuUFnBR
	 8/OSO8WiJta1tClx/6n8iAp5zsfDI2gQkRUCZZZq938NkJ8nFaf50pU0IgmUf1ajYj773
	 zfJNMWcFL4Yok2dzYaSVlwGGaukSVGnH0tCw2eUp1pGCmR6q3CvDJA8/vpn5MKLOJXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KB7UIQsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34988606A321
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KB7UIQsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9138C1F000C1;
	Fri, 30 Oct 2026 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376596;
	bh=rxveYFT6QpDhrP31/KqFxVPakYspiuvj9sanDbLeonM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KB7UIQskdZkeO76du9AxmVQ6iMOVW7/chzkKPCwyUkbxTQHvDSnJde3iWQRqzpJk7
	 9CcxDdu6jhkppLvFCG2017RoIFgPFN71Lgb2LUvE/qGgRSEfKTAboLvi54O3BjvITZ
	 NxbSpUjYt9B6gvSEe1twjBPnLRhx0885xznVhxzGDfRJNdzlDzTQa8ZZAU6wVxZp2Q
	 JWZdsugjaxxZQQ63E0+mfWlxwtcvMibXx7SMupC1V/DB1/MmL++oPXXEbB7pDdIBil
	 XWD3ARar5aOZL6lyvgAaduGl+apYpvtQOvyDjEuWEhSPJYyoi3qGhs5YTo7ZZSL1qb
	 LtWY0nykbz6sg==
Message-ID: <sashiko-outbox-191229@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/34] exfat: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-10-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-10-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Set SB_STATE_EMERGENCY_RO instead of a private bit when an error makes
> the filesystem read-only. exfat_emergency_state() keeps telling a
> shutdown (EIO) and the emergency state (EROFS) apart so none of its
> callers change. The VFS refuses the remount to read-write now so exfat
> doesn't have to, and /proc/mounts shows the filesystem read-only again.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D10

