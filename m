Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376615;
	b=WGQ4Fni2sz3/Fm/YYYA/KqNU7cqDjrFTcJHD8wMmag1pyr4nB+OVOFl8elDeDg8KZ2lw
	 nxJK4mpEFt83PQm5xWAJ0oscikbfTydKensI+pYeXzUQNM+TMVgA9qr4kr2wrpIYuJrNe
	 q7JSseZub+/EH7NVfT3DJfGz2wdVax3rRvpZiQtIILw50oA9jZG9/Bepq+xDR7NVvg3vl
	 chTFq99iwAPBei0GgFtL8F3hiLuO4QVPIUO6i+woPzq/568SY5HpUSEbwosT7xWF7Jbh+
	 9NXb5W31ohdyHAKOQqnALf2LH9avhdh6qPR0nCbcaZco2Lpl77+m9yaqYsClPnJWeFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376615;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nZ5CjxKYMxp6AvMrB6LJT0c626rwp+hXPRn0vBANzMg=;
	b=jcCiJgYbh06KlsPW/2NyvPJ7sZOpRfHixEQsAzWTQyA58p2pCnjVtdew//8m2jd5fM69
	 BUt1LoP1Pt+gRPdRPMJKqgJGbpWAMUDiFmHn9dOCX868HI+0bagLMQk6eP3nqRmuT6h5c
	 gCcy1KCKUMOs6DVUaLs1quDbqN0bF19M1MtmvGCV+KMA4/hN4ztIOPATf0mXSvZ07dEjf
	 OnSK2aUeesNoBEZ2dyyzpz1/zRGUaZkqGKYDtK58xB3TcQRiBZMb6AVeQAKa1OXjve0YL
	 hHidvOG+o+lxkkNWV0bxc0p6Xn9bVTILELtc1Z2g55G4zp1aWoLo25vmxDd59Ioe7kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D59pI8pH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F354606A33C
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D59pI8pH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACA91F0093A;
	Fri, 30 Oct 2026 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376615;
	bh=nZ5CjxKYMxp6AvMrB6LJT0c626rwp+hXPRn0vBANzMg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D59pI8pHsqsekVMFFnVLaaX+I7sbsSkdrfCGH9qsK51zSuCIilljvPSwy8MxHw5Us
	 KOSeCCejraEQYexnMGBBe+YL8AFKyC++ZD8YvwY4LzJfqAJD1dxlbFqNmBlh5vy1VR
	 dFQzUZ7iid5IKQESoXQ6NoSH4K3wfETzF+yNbqNlwcfsa0CVeQ/hCSdwGlGoS9VTif
	 iCSgBO9eoU8WsQgnkfXUxxT/RhQV2l8SiJgHwda2UICMcMFBrkCUq/FGKpcTtgmf9g
	 DeulN7YqSdfolgytXdEFVGAzNpieDAeJdQMroJkI0uabQZ1Bbni0o2DBi/scT63Fx0
	 8UUG8niN1uVpA==
Message-ID: <sashiko-outbox-191250@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 31/34] ext4: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-31-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-31-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Set SB_STATE_EMERGENCY_RO next to EXT4_FLAGS_EMERGENCY_RO when an error
> makes the filesystem read-only. The VFS then refuses modifications
> before they reach ext4 and reports the superblock as read-only like it
> did when ext4 still set SB_RDONLY. The shutdown state stays ext4's own
> and so do all of ext4's checks because they cover both states. ext4
> keeps showing "emergency_ro" in its mount options.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D31

