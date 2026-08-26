Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA77425891;
	Wed, 26 Aug 2026 09:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738070; cv=none; b=QYvRLruc0jZ8z1ior2bQ2CTzIM1KhqGgo0T4g8JUT3goUznNPO/4wCueKNndg1sWI3U9mDTP0jwMb9toOtQR+hEKrE05E06RVMBnf4OGSKat61V3fi7vo7oJZz8hzuEyslyDwgBQKcNa2VOJy4N0bsFmpCqkBCFRTUQxFyTbpXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738070; c=relaxed/simple;
	bh=cxBgEzmehlG9CsxGajfqjeHN9H6tt+rUzRThgZ2GrDc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R4dqbnsRsTmz54ZD+lfgZ2EP6u/D5cz8Ct3dsB9+0e2LnLSJgAlc6v24i0HlBRtnRIxjWARgvbIv5i/KbVnbJLZYDzukQEVrXUyjT0SGFrAHGxq/EJrsXpOMQ2pGVGQMhoJl6kqlQTJTs8/7jMPVWxQzUCXoc6/4YXqUOEk5Zng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AR31seH+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AR31seH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C941F00A3E;
	Wed, 26 Aug 2026 09:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738068;
	bh=cxBgEzmehlG9CsxGajfqjeHN9H6tt+rUzRThgZ2GrDc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AR31seH+ywIps89vZ6zCNL54bukm5MK/lZMNaMd+mQXX1+N7RzmN8bPPoWuK7gyFQ
	 Vt8Urf7+yH4uG6qk0E4FGlKtOA05Qpimw8Tp7n/4Nlu5oxnSDr9pUSUQjsS9ALpwki
	 mNtZeFrKPv1LM79NP1/5E/eiFkqmDgod72r4nZuO1dsVyuMQ8mSiwx/MCbjU8p3Vhh
	 kgHkP1fdh3edPU79rcRMQ068/S6hwTNhOj36Z6JqWF/31z/GTEhrBCwdJjkmdMTEfP
	 HssChQ9Y5/RONWc/4UJfRUHvU+nPRIRTgItR4IJMoDH43QtiNIhY3SL+xMCOcqb8ll
	 gbycbeCh4VrVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/11] soreuseport: publish num_socks with
 acquire/release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Oleksij Rempel" <o.rempel@pengutronix.de>, linux-ext4@vger.kernel.org, "Vincent
 Mailhol" <mailhol@kernel.org>, linux-can@vger.kernel.org, tytso@mit.edu, "Marc
 Kleine-Budde" <mkl@pengutronix.de>, "Oliver Hartkopp" <socketcan@hartkopp.net>
In-Reply-To: <20260825095422.3166067-9-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-9-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:27 +0000
Message-Id: <20260826095428.26C941F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on reuse->num_socks.
> Writers publish socks[] updates via release before incrementing
> or decrementing the count; readers acquire the count before
> accessing socks[], ensuring they observe a consistent view.
>=20
> The detach path gains proper ordering between the socks[] write and
> the decrement, which was previously unordered.
>=20
> No functional change intended.
>=20
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D8

