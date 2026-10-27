Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793136582;
	b=rQ4Tx7+kDl/GJZxm9q0fAucGTc62hTbVFy59TkNEoR4vmL7nn0sFzJdeqFw3CCf8MBBf
	 9bbbda411GNLsia5Bh8rku78r3oSLcz/3qWZ+4znk/5CgapQwPRmqJvZDNxrd3amjESt3
	 sYN5iMZNBYBCP7RtZbmk9HFlJ8iq65c2G1Rlrk1PMLVZkOdfRysAvXr5ucLOihY1PcRqX
	 uhsH4ubusxjg6JhQ2Jm72Emo5G1l5hRHFdfSmjfHBfb9s9OB0pDr60ZwfK4kpmMdb5tn4
	 wgW5cEesN5P292x+6YwW0IpfxlHzVsbWM6wo2qW23k+Gnh3zDBMhB+uSbgcU6hYgcYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793136582;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=D8hN4gRDj8y0+YZqfEQuAKol2pkI0bZtH/rh6zCPucA=;
	b=yq+CcDWU2PQhb8Z1bRSzfF5v7RfEdWfNgytaYqxjLQwud0/yin4WZsToI0lHJTVaEOvs
	 bYPrHviKI5fyrQpksk/JPLIwAI4qT8cWiv94ITswRIJNQZlHs6Q8BJASGGymdz8rMewc/
	 7QBxjJccdLMxoziDf8qYqqA0lKllLwTACcRo4egMfwM6il1MqG96ejM2MjprBqVhlQr3a
	 Oal502X1RAejq7pftpabEmnH9GhDgc3Cn7zwRtHqSA4E6AD3eIXaktnGHVcNuXU7ty38n
	 snjazOUDADGZCK4LRkL3F8julxaBGxrWZjRDq3JyfKkAtS0gpoci8F0z2uQoVnF5LsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZLP5+Bx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD211606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZLP5+Bx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B171F01825;
	Tue, 27 Oct 2026 21:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793136581;
	bh=D8hN4gRDj8y0+YZqfEQuAKol2pkI0bZtH/rh6zCPucA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NZLP5+Bx1esp6t1CQHn+uHVXjG4rGC6SrlV0WCvkUuicWjolMYJRZMg0qM7PmZaJD
	 p8a2WNgKdsViw7qLjT5tn1zHwdGIZ+Hx3ALPfy8IKunFkDeCeuV2PABacIX5H9FSya
	 MnSj9nVjUh9U720se8YKtWvgg82Gg8Ad84CVIro2zRdxptRjCB9op3t40matfrOlSx
	 RWqyCh/lAaFHLgprwxIpGGkfmdledH1Sj7jEsbR/rUIsH4OGisZmbt/XYJrqQUxBhM
	 SUTtptOxzEkHzg3qqZnwGkQRtubn5TlUONF1d4Nzw+xNV2JIjs/Y7UlPrqS1jNEMQ+
	 DnCzfSHJggHEA==
Message-ID: <sashiko-outbox-187122@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/10] ovl: cache dirty overlayfs' inode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-8-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-8-802e512379a6@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 21:29:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Chengguang Xu <cgxu519@mykernel.net>
>=20
> An overlay inode is dropped with its last reference, dirty or not.  Its
> upper inode may well have dirty data at that point, and once the overlay
> inode is gone nothing says that this data came from this overlay.
>=20
> Only drop clean inodes.  A dirty one stays in the cache until it has been
> written back, and is then reclaimed from the lru list.  One which was
> unlinked is still dropped at once, so that its space is freed.
>=20
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> [josef: an inode under writeback isn't clean either, no need to look for =
an
>  upper inode, rebased, new commit message]
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-b4-ovl-con=
tainerized-sync-v1-0-802e512379a6@toxicpanda.com?part=3D8

