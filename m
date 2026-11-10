Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317356;
	b=aGWb6i+55/2d5ZgVt0AUreZjAU+piqCpKAGwmDQfm00EI5u/YlRxqBSQf0OkBe7dlVvS
	 w5s+XuZ6N5zQzrZCa9pLOqZU6p6hnIzWtS12Yup52Zr3TV6BpTZuX4pmCu2f7xcnIBXzE
	 IeXU2GhpFP0+aXopTHxE1p58FM/WiJYm9Dh/b4fY3F78ks0ZWJcY8J0lUG4H179oRef3l
	 Y5nUOP4zeUz8k0F5/NEVtcuTJnjjXrVd2FOqlkOy8PLzBa1pGJbUa3v3e74YvEe2ZojVT
	 tM+nel99cuciVngg/TN3Er8KLuMdEW873N+ua4ItkbpCElmIiuS5n3/DBVPiEFmNGwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317356;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cG+V0dLM3AiB1HstVW5BfH/0/Bln2t/d9EsioqxD2NE=;
	b=G2plruNyqKmVvnnbZBqNRBCwXQiRrceeIr5vXnL3Z2KWytMwGOv6pH3KTwwirRLcMlW7
	 39+VBQYLXPnSpB+XaRux+oTJHx8mplDx7XZRi3LpZR6Wll6iIkY2UCj6M/8ze0EvlAvB+
	 XpCqseV7GSW0gnUwrNr+r/WDSrKZ8C3A+Ug69GgrWScdFgYqLVv/RgPbtNJ5ks1nKOtil
	 f6XfN150DHFyr6q8F11eGssabYvzSShL+E+/G9Ka6EhIECp4yv+qbtOY8PxT35b76WLdW
	 UiUgzqQjLn1YFaHJeIoGQaCivrdSvcCKZhFcXTiYy1AW4GA6IdDsokGpchDLPyR8emg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5BW7rey;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9BE606AF02
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 13:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5BW7rey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBADA1F0089F;
	Tue, 10 Nov 2026 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794317356;
	bh=cG+V0dLM3AiB1HstVW5BfH/0/Bln2t/d9EsioqxD2NE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A5BW7reyiekZqtBAIi6ZdLLA+2kBWGmT5C1IfipdX/aJSQoQyasKp4O7sqwcch4ze
	 vcRc1d6ZksQsu6fylUaBCsEvN8BIuCC3nFFl/ipxGJCClb0s0Eu+waj/0G7VIxL4UA
	 Xn0rFtJlCfdm4m7XUwgd4gMX9LfuaFChXKiYyG+Lea86f6oAddEhwf6x7GPhLe4f1k
	 349QDHnaR5gdccsiariBSHL4CbAqQh+U88aqYhKMFGsuhnyu5nzy7v30wQX3zVzU47
	 NrDhkm9QVBYY1I8fW2hD6ejM3DG3rCn95aH9Cf2VMZSdDPQTXrHhEgrxzpoZaZZTz/
	 V8+SkSKba+1Sw==
Message-ID: <sashiko-outbox-207121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: make concurrent DEFAULT shutdown waits killable
Reply-To: sashiko-reviews@lists.linux.dev
To: diasyzhangqing@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261110132118.11265-1-diasyzhangqing@gmail.com>
References: <6af1e75f.3e87765f.91969.0010.GAE@google.com>
 <20261110132118.11265-1-diasyzhangqing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:29:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Qing Zhang <diasyzhang@tencent.com>
>=20
> Concurrent DEFAULT shutdown callers can all pass the shutdown flag
> check before the first caller finishes bdev_freeze().  They then wait
> uninterruptibly on bd_fsfreeze_mutex and may perform redundant
> freeze/thaw operations, triggering hung-task reports if the initial
> freeze takes long enough.
>=20
> Serialize DEFAULT shutdown attempts with a per-superblock mutex
> acquired killably.  Re-check the shutdown flag after acquiring it to
> skip the freeze after a successful attempt, or retry if the previous
> attempt failed.
>=20
> Leave LOGFLUSH and NOLOGFLUSH unchanged.  The ->shutdown callback uses
> NOLOGFLUSH with s_umount held, so it must not acquire a mutex held
> across a freeze.  This does not shorten the initial freeze or prevent
> hung-task reports for the active freezer and other freeze-blocked
> tasks.
>=20
> Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
> Reported-by: syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd4ecb9a1e5b3dcf8baec
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110132118.1126=
5-1-diasyzhangqing@gmail.com?part=3D1

