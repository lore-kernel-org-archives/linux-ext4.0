Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376605;
	b=KvuxFZ0KFGAyb9M+uIIvcqPRZ6GybYJRpsnzrWgsscGM3cwbKXhNSMJQfnCvWof3LIHv
	 7YngNfjDwYJh64BRw4mSzayBQ0p6urn7LBP1wQFzlzVZHllOOXOAsj2ElM0htHRUdr6MN
	 qmoYae1AiJqpANrryx7qm1WxfM9bWmQSRh+GBOD3B62/2NEnRouvQLBT2jJKU9P6vpfdi
	 vH0sQmq6KL2IlJMp7gOVpONy6qdhCW7MrVouWlgvwd9j0pXu8Uc1jgYzVRvKjRLWl6nkK
	 ZG6S4G2MdnciDYU5kTp18Oz8IaLHqdACHO6unU6q4z+JSDXijU0ItIFPafXVOnX0Ypw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376605;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ExWaGHT0UjZYp0VWk6xlrUDcd7RC+K5lFj0Xzb5KZjc=;
	b=pX1hTTSeH8aM2fbpOxlh5h0mu3zH64o/uCPJ/p0g0K5tfmrr3tPKvBMss18RP8K5J6qe
	 LhoOU1h6JmTfaUNSXEsG8CCgw3jheKbmbvh4JlpXrp/gVa213fwsniWPSUIoIvtuGDSPb
	 J0doTjHxAmiSo2ARC8zcICXTQNsPLuqS4rTY/GnytiQwl9tslEyWa6BN08Qe9nmab+X1B
	 CoqfCx0VUtcLo/YVsG0NSUGSaa1Zm4tx80zQIntIVcUrthpHaJDNRZaaM/3mw665uw8b/
	 MW9R+9sW6VovzcHzN9msKQbyyF5MfG9oQ7p85dZYmCalij5UlUg+26Z5C+Sjz3Fnr9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTjD1Fxp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77859606A321
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTjD1Fxp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB451F0093A;
	Fri, 30 Oct 2026 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376605;
	bh=ExWaGHT0UjZYp0VWk6xlrUDcd7RC+K5lFj0Xzb5KZjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LTjD1FxpGZXSO8HoDVO/Mqii+GdT/11qpfrzogZXvItmvUgQ3Op46WKd3azY13ZOx
	 H8ayhnVRxJ/fHcY2J3JV4Ldg4/68xTd71O6HlAI6wxqNGhGUTUU6noyFJxX0ugjJeV
	 e+9YKtaZAeKiDUnpsWxvwNTdfebCRC//8E3+ynQQXjAgDdZe8wuknt5V2SDe/UJvK3
	 RhGJQH50cXvk+t98CW96Fbrbc3GYGzRA0TK3uMmM7vgUfMPNrxlqvRj3OLRnwToBvx
	 uz3ltQSjXdNwd25bNFuDkrci6LBinnKBf36GDTX3V7/kqwEq/I3A94uYfEgTrwzSNg
	 d54DttRh60pcQ==
Message-ID: <sashiko-outbox-191238@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 19/34] ocfs2: keep the current mount options on
 remount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:10:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ocfs2_init_fs_context() doesn't inherit the current mount options for a
> reconfigure. But ocfs2_check_set_options() insists on exactly one
> heartbeat mode and ocfs2_reconfigure() refuses to change the data mode.
> So every remount without heartbeat=3D fails with EINVAL, including
> emergency remount (sysrq u) which passes no options at all, and that
> WARNs for every ocfs2 mounted read-write. A remount that does pass
> heartbeat=3D silently resets every option it doesn't repeat, e.g. noacl,
> errors=3D, barrier=3D and preferred_slot=3D.
>=20
> So start a reconfigure from the current options like exfat and gfs2 do.
> Asking for a different data or heartbeat mode still fails with EINVAL.
>=20
> The next patch stops ocfs2 from setting SB_RDONLY after errors. An
> errored ocfs2 then stays read-write and emergency remount would run into
> this as well.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D19

