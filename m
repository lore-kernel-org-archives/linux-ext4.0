Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794846259;
	b=VtxVWCoi2L12PbBtzNOkwaFhoosEU3/ekDSVh+NNHDYGhySrjWX6CC9ULc6A4pDZeNuu
	 bnvqiXiPqI9ZEzqmaX/vfnYNYuKYlVoa0jDe0cGEdcO2yKJUpiKiHxPNc6LPldEpOnm5N
	 7sG8aqsdCcHJsdNcYyNeqAs39b+NbrEcLafELy4qstuMG+Tv2pxppa0aAt6rLXsCl3wff
	 0MAK1QY3E6o/Z9QxD5EpyKcFA74/MPV+oCrEcb94/kBubMMzNWMAEqNWi34JOLqGfJb+k
	 48xdrP98t8GiVZEXH8lT5w+4YNROKqykpXBs2iz49Xppam84tOQsUxE/exjxSUg1aUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794846259;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fdtKdOXm01sWF3CnzBpOEwVlaEElmASHxsdqvkX9BjM=;
	b=N1U255PPhf1jJwYmPrnv2h7AGR+4DVN0NiUY0VDfbQfTO87OapeaGjhbyhhJIxiEoY5t
	 zZVr9Hc+tlwvxgJ9PCL+n2y0DF0vJoAx1SjP2k24FTVHVa49uoZ8EEXNGVIeFKe9AiDKM
	 b/+8dNpp313X3Fvcy9YHybmBrhZ8fbouLm1gTbaVo65Eoe/n/hz6Fj+NwyfZcLoiGYT84
	 dJULUtZVY5FKVJnU9PnUoChIwiA6LwVCU4EFdQV81rJ8nP4CEsf5ZBG1S30z222YDe0JV
	 CML7HsHYaemQNQGCVQM38mpNIL+O5WIU4rUEGL5WtA1mSdsnhA6qO6Q0EJQ1vcdndsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QyaMc+1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858CA606A32F
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QyaMc+1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7F01F000C4;
	Mon, 16 Nov 2026 16:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794846259;
	bh=fdtKdOXm01sWF3CnzBpOEwVlaEElmASHxsdqvkX9BjM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QyaMc+1R/IzhX1yaLJ4UJCqH+a0RSGI3YSdSaJQgi3vpZ03oRPfOtrS3uu0d+eWST
	 AqKm8uX40SzhpUzyghMF8J5yyKDNyMyBDBbIkeXOi6QG6jtsbORS/+BCDiUIvHGyKF
	 Bkuv2YGTxOdmo7TmTIexJk4T2TCFuBlEzQwGq8emRQwxPkMRDSWlS5QrTZyPTuTyK4
	 6bQ8n9DKBc06paUn09sx2KAmjgcbUtss74SvBcApvbidCvJwmP3C8quVc9NKEyGIUg
	 zAZwF9ih34mMVADgz4ZaHPjmxGUllxMIFuShmNpVHIwNIy08MEBDy9W0uVU2deDLh2
	 8UetM5W0+BO1w==
Message-ID: <sashiko-outbox-217361@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix wrong unit of ratelimit_interval_ms sysfs
 attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sang-Heon Jeon" <ekffu200098@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261116161701.3664310-1-ekffu200098@gmail.com>
References: <20261116161701.3664310-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 16:24:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The interval of ratelimit_state is in jiffies. But the
> ratelimit_interval_ms sysfs attributes are read and written without
> converting the interval, so the values are in milliseconds only if HZ
> is 1000.
>=20
> If HZ is 250, the default interval of 5 seconds is read as 1250, and
> writing 5000 sets the interval to 20 seconds.
>=20
> So use jiffies_to_msecs() and msecs_to_jiffies() when reading and
> writing. Also reject values which are too large for the interval.
>=20
> Fixes: efbed4dc5857 ("ext4: add ratelimiting to ext4 messages")
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116161701.3664=
310-1-ekffu200098@gmail.com?part=3D1

