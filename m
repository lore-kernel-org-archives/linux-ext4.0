Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F5142467E;
	Wed, 26 Aug 2026 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738068; cv=none; b=jROQ5Jslnvu3H3lndbQ2Ve0gafje/+LPKpmX1dYMsuSN6eKgqqY/+9KZBp0SrAxBFPb7lPyXxYLUzMblY5ofv/RZuLRd2MNmGgfmKfqCBOzObD/i5zCZg3i+FnM+MogLB7BXt+mT3CpaVbCLhPXB52QzhgMykqGHYYnDrCnYf3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738068; c=relaxed/simple;
	bh=bePLfeCOE2osAZj0RZrLVb/nV6UrobiJHjJV6vA8IIw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eUc0JawA7/UicBqQ6ttUduymPIkg47ckiXQBiHouS1q48Wfsdc+0hLkbFXCtVZU08fmdYG0Gd4UdBAqcdhomQgn9gT2JuX9yEAf195mSlBUVflRsKLmMz/q1btgU38vbfa51UID2IDbJIF08h1xRtU8+wosDsOI/vkNzq16uqds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpwZWNxa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpwZWNxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EAA1F000E9;
	Wed, 26 Aug 2026 09:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738067;
	bh=bePLfeCOE2osAZj0RZrLVb/nV6UrobiJHjJV6vA8IIw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CpwZWNxaTvllcLub8chomc3YiEO7z4VzmgsMxhIRsaY/iPliVBvT/zadUAAFcuojf
	 SUcGmpJ/YmT2UYGlSlmfvcVHKq4lgBNDCHsMF3624BcJgyLMWY7vXIUbfRPM8CMwGV
	 fZzShaOMQyqnskIUkqEtlMhlK5NkXMuD8GbRr590tAoOUUZMSIcwimvoYDGlY6lw7O
	 8OCYKKPRxr45vlNG9auBQoTV23VjygRzyPNvO63KHHTSKUoRsN6ea0EA8uqd+5oWKD
	 LBuo5A6RyNhvMHisihFwuaUOGhkrTTw+nsPZ1K94e6GkQzZpvdEbWMUuN2fKKyxTru
	 nfjMtgIM/l4Ng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/11] fs: aio: Use acquire/release for ring->tail
 publication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Marc Kleine-Budde" <mkl@pengutronix.de>, "Oleksij Rempel" <o.rempel@pengutronix.de>, linux-can@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, "Vincent
 Mailhol" <mailhol@kernel.org>, "Oliver Hartkopp" <socketcan@hartkopp.net>
In-Reply-To: <20260825095422.3166067-4-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-4-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:26 +0000
Message-Id: <20260826095427.36EAA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb() + WRITE_ONCE(ring->tail) and READ_ONCE(ring->tail)
> + smp_rmb() barrier pair with smp_store_release()/smp_load_acquire()
> on `ring->tail`.
>=20
> This expresses the publish/subscribe pattern more clearly and allows
> architectures with native acquire/release instructions (e.g. arm64's
> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
>=20
> The release ensures event data written before updating ring->tail is
> visible to readers that observe the new tail value via acquire, which
> is exactly the ordering the barrier pair provided.
>=20
> No functional change intended.
>=20
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D3

