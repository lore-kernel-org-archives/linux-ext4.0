Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376614;
	b=tdBaDC74xATh7Z9NNpvyNCW3bcOB2QWlJbSlKD+ghHyubzcacifesBI0jaL6N6dzsEfL
	 djhSY7TaXZItBV2zkTVsS62+5uOaPbNke+a1VX35ydUioefbmlRnpxg8JDLPUxfQQfQ48
	 dSqN2TjVPSbHAnUMS/ibQg27fmOooFCQh9sOacZ1yOiWpluVy7BW25xUCJ39YQEj9ktz9
	 TbyJ+aknl5n1stzCVMUta7LHFSQt6W0VSQ1cWA4ayclO5T1mSgS+alptc7HP+tVc4d9X3
	 mvSfYQf4MSTNp2IImKxL6j6OpHUnikP80XVsRdsOwTFhkysXECKvAe9p5CwChTAjXxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376614;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kLGiOaM5EUWqm7lxwoF2UsR2ciqN7c2RgJlxKOKu87k=;
	b=HbegaQd4mOruA6W7Y6xC+yeK9mdtd14HsY+XiqJFeqP9dgSoH+uO7Ig/Q5MWebNqhqpZ
	 lFsZW3OiygTvAZio4In7T7WKnuW8vGLMbBUc8IgfeE6LOxcN1lMf2t3Ad1lDqnToJH/MM
	 zNotwv4TBJZ3eAtZcOXJQmyfpjeG0rGU6mVQ1jxwq7SVwwXWmaMMjPl1mXtvFe9ghKiet
	 UfU3bPIv8dyrfFv3FpltoDPTPV1cuE4IdKKvnnzD7xRbb6hKlHmhJav0UvRpn5UANAFWS
	 ioe0bY22/7z5AgH5qivZML79iyMGOWw1UJhaeayR048Lau/FmwKc2PxM6SJDSuymvmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KWwD3hPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01706606A321
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KWwD3hPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579BD1F0093A;
	Fri, 30 Oct 2026 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376613;
	bh=kLGiOaM5EUWqm7lxwoF2UsR2ciqN7c2RgJlxKOKu87k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KWwD3hPA3fsQ6lrmDE8u7YxrkmhP5KugxV1uJDt4mqymUp2wdFm67IgiLGRuK9c7n
	 /rPMVG11t+E585wXN7wwfOuHhYOgXLCRozBXt6x9Ts0ywjL0eTt36g5xu802uXD9I+
	 6IGsyheVwu3P/dkfXG/drZ5ORK2sQTCvpJoYToK1M8ScZnlgEVBZhWl2My4A7HqDyx
	 6sCnelw/OgEbIFeO7yU7ksDM+oTp7pwB6vw9/tNrjlNLYDFDPaC01H0h1MQzrgxwsW
	 cudNwAtL3K41FV/6T3nyWgvTKUvbdoHvEUjMUHukgtGgmVL2QFnz+lhK1jNwvtgBfr
	 bJyLCjb/xyNRQ==
Message-ID: <sashiko-outbox-191248@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 29/34] selftests/filesystems: test filesystem errors
 while frozen
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-29-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-29-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:13 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add tests for filesystems that hit an error while they are frozen:
>=20
> - ext2, jfs and nilfs2: look up a file in a corrupted directory while
>   frozen and thaw
> - the superblock shows "ro", statfs() reports ST_RDONLY and statmount()
>   SB_RDONLY
> - create, write, chmod, mkdir, rename, unlink, truncate and write opens
>   fail with EROFS instead of blocking, also after another freeze
> - remounting read-only works, read-write fails with EROFS
> - remount read-only and umount after a write, fsync fails with EROFS
> - gfs2: withdraw while frozen and thaw, writes fail instead of blocking
>   and freezing a withdrawn gfs2 fails
>=20
> Everything skips without root, loop devices, the filesystem or its mkfs
> tool.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D29

