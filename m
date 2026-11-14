Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657803;
	b=N+jCNBI5aIcaqztRB+MOMIDdIDCn0HDsCIASAzHPF3M+ioI6DVW13ZPdMSmlliyV+jO3
	 7CGe6+mvpSSJHbHc3NmyzvRMNj61BKnqp31otiQCjyN2u5vlghOsz4BY5qf5wyPd7Ne6u
	 AIOc2CQOyZ7RNpGT7n4Qblw55LvcFAEHPFlD04raupiJHSXnU3Kf2hH2MohGM+CVdICAa
	 Cu1f04JCnYsftHW/gMy/nU3F6mmekkHyXJYch4pCf2kSKAydbJW870eVclmMDEw5DHI9m
	 1JsgGYja+MXBbZcuQmfc3MJBViWEwbaHqCcW3mIQERKRYhCcXJlctXarv3kpmN1Fp8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657803;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lX46Hm8f2Zcq/BanUShUpeGp+CkaUe+tPRiyAWj1aFI=;
	b=XMWiDQxiY0TkYMMFVPSX48jgsZBNNvm3i+BjDDj8K8DbMKTjbi2lYAGLQtrxF4oQMIbH
	 j+cFivQrGWsBS6+2igFhklRoIekDq1AKTHBnA+UdeMzPciWYNUL8EENQf/M3lszSRc9ju
	 5z4eDPv0JgcywKTZRnuL0cypMm02xTGIJ8Xg6XUs6qbG3MKFfqxq3yb/2PiMMIjTmfL/M
	 xtQZ/mXsnhXZ1UM54nK+74RDdbQFFPWZDSfbs2ERUPZISPe8KRgPiRKR/RcgUEcuVOqKh
	 ZJDsE6xB5cnLVrbipBsI7XZOx4pRUpAbSZxaVW1pm8RS/sGDJ+4B0UjMr9vBRKatf1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TcDEvu66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C8D606A335
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TcDEvu66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287F11F000C4;
	Sat, 14 Nov 2026 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657803;
	bh=lX46Hm8f2Zcq/BanUShUpeGp+CkaUe+tPRiyAWj1aFI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TcDEvu665UHAIPXiTPyixOUKkr3NzOwniM6zYJgj9eppvsFp4KBGbBEeDroCzPOOf
	 w1wwWH5PIGgiLhISPc0DG8DUZyFncJMcl6NUnWrMF7xqYA6av2uIddicTeuYqpv1hD
	 hlrnmoqyPOKe18MntgLbYy3lj+pqzeEmZuv6HZgorrHkhyX9YkiEphkvK377VO1FCc
	 N79Ma4A9ugZobBaIJxGFysYgP8IIPJAZdVTGQgt9E3cDG+alvq0FVzkFE/h3ubp+77
	 N8GMi/ZHlam+lhaiLE+yBALpAhSTuhMmmi8Uo78xu5cRCzU9LPSLpmdvLA08Xvp8/E
	 h/kzMVw8DIdDA==
Message-ID: <sashiko-outbox-214454@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/33] ecryptfs: don't leak the inode when a lookup
 can't open the lower file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-3-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-3-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ecryptfs_lookup_interpose() opens the lower file of a regular file to
> read the size from the header. If that fails it marks the inode bad and
> returns, but a new inode is still I_NEW and nobody ever unlocks or puts
> it. So it leaks together with its lower inode, a concurrent lookup
> through another hard link waits for it forever and umount complains
> about busy inodes. The lower open fails e.g. with ETXTBSY while the
> lower file is executed. A cached inode is marked bad for all its other
> users instead.
>=20
> Use iget_failed() for a new inode and iput() for a cached one.
>=20
> Fixes: 3b06b3ebf441 ("eCryptfs: Fix new inode race condition")
> Cc: stable@vger.kernel.org
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes: https://lore.kernel.org/r/CA+0ovCgYP920GT68hAJK6Trjyv1kGv2dZAuem4=
LEunycQ=3DPOww@mail.gmail.com
> Acked-by: Tyler Hicks <code@tyhicks.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D3

