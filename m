Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376618;
	b=M5mFoGidYMB4duNSslF3bI/9SsUx+isCb3O6ha/+DM1vF5pi/f5Zg308KDvvmL8wP7l5
	 6efhJk8BgP9ZNcAU3yZQAUq8XGH/PXeRrHra4ofNsA9GwJzDZFL7RMicaILzBrlUKQk9K
	 AT4srgZrG8e1X4soo8uznt/W7+nIyfS2GTVXsOf6HEWDfN6DdR94V/10on4AFXL0b52rb
	 GZaA4FaIZw+swawb7Lrdf71ZCJ3UUmnGp+gXnzgMw6H8fKK/CE+b8u3F95XxMhmIRy00t
	 hrALDIsJTSG2EXuku4Vdd1RHft8qgwnYzSzNCQEKjfM7kzfOdbjtOVaDJcyJAMeZT/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376618;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zGtSNretumjfpozE49BKx60LAcgTruERa3ARvCXsj1w=;
	b=OUXcWUSRjUrPgPCT5Br+fpP1LggI3VK3MmKqUebvz6KXa0aocODoPI+NY2MU51kT4byG
	 LIcR4LVxbvdH0zBkiT50jZCQ1RMY+kTNINttbfPx/zi993Rth+B9NN3DCeXm6pRE0I0Gm
	 D4RFG2BLU7bdMp+Ikfe6kJJnXQ9XCiKFmW6Y4EWxMzpums2mp/GAC+o98EDOofEGahxgx
	 +PkLoatHJwEqcCMe97I5URIaQLlbd5sWebKKESA96bwPP3atfXpw6y4cz0vFSW0eofBSj
	 98bnJFNLEO2ZigFgfO+CkN/+SSdyMZEWDaaq/3HJeaPmQ7bZ3MqZub47oq56MOdaxFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d14a0MyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BEC60A2606
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d14a0MyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC9F1F000C1;
	Fri, 30 Oct 2026 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376617;
	bh=zGtSNretumjfpozE49BKx60LAcgTruERa3ARvCXsj1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d14a0MyBtNAQM51tKMSoMnxfPYrhoUkkt5dDtXBPt7uVt5lgQRPDMx3XCsErdXhMO
	 sOLBoFClQcX7hupUa+sTA/7IoZoiu9aRqaLzUNu9BrwBEpSRxqVKmlwg0lqMGtP8vv
	 kQdI1gR0i4QxUGkxZUUfyQ4PHfM/PsDJhgYFNkxhojGeyPlUluZs2upuXvrXNtM8ju
	 QMpndzfuoWOYQ8rxDHWLF8SPqehhYOjAwVIp9XYt9b89WqVLsipRQaqbA3YPnRZkWu
	 ziOogRVK/yKHZithaGHx9Phzw1b43ceJXozFs6cFORLhoVd+SaPqPIM1LsUnbTP/L4
	 EbInpmFyDzphQ==
Message-ID: <sashiko-outbox-191253@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 34/34] selftests/filesystems: test xfs remounts after
 a shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-34-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-34-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add tests for remounting xfs after FS_IOC_SHUTDOWN with the default, the
> logflush and the nologflush flags and after a shutdown that the remount
> to read-only causes itself:
>=20
> - option-only remount keeps it read-write
> - remount to read-only works
> - remount to read-write fails with EIO
>=20
> The image lives on a tmpfs of its own. For the last variant the test
> punches out the log and shrinks the tmpfs so the log write during the
> remount fails with ENOSPC.
>=20
> The tests need root, loop devices and mkfs.xfs.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D34

