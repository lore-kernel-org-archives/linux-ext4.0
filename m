Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D9D3DAAC3;
	Wed, 26 Aug 2026 09:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738066; cv=none; b=LVr4Twr6J1J0ljXtFa81kXWa5aLPrYUwK1/0FjpRVZ+tkPnN8l0cFfasuQf45qj1cyIFGPa1fQd+gifpFvRpdaEmFLptocsA1GjWO2vfxNYBE27DqhgeoNvHwTbdHR+6XhLKjXgtEPfJpDrOPSXf+X+XLw/IqxDtpZpOfFuCO34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738066; c=relaxed/simple;
	bh=WPxQsaFr52Anc7LsKLee45BRBtyQEkb1uDWYxSdpshs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WyCYaR+O43wfsFxO1vzkHaODeI0NWWM6LUyUQaOiF9qDhAQpl+qUANf9eF//D+z0PG15xBdXi+rLVgqw9ht5aaTuiZhGyC7fhPeIUB/tEJycKgPPGaNniATZ0/GZu39+KOAaFsLE/oAlxgGeAtPsbaw7PNP7xZeecIT9H4zkRr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHgaLcbI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHgaLcbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516661F00AC4;
	Wed, 26 Aug 2026 09:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738064;
	bh=WPxQsaFr52Anc7LsKLee45BRBtyQEkb1uDWYxSdpshs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fHgaLcbIPRHQU10cXVcmnzxRyvMjrchM9xZJBN6FAF5lcprUbKZ++PWZ+LjZ/+AIs
	 VdkeJ3u9ZPhvURq3sjWRtfsJfvsuKY9RGZkcaCw7DZvDOFsbr6w1cZOSzIIMGMyAeI
	 GAUgmeqMAzGsf8LcE6OBazGSORc8hHtO1Ks5gizB34szWFL/HacNi8AKp9GBfHnNC5
	 h/USzad1f2fj+sbnZViwel5+CNI6rNDi9tLBm/DY7ipfeUSpvMzcNr6dnYg0dGOrUa
	 A8Um+/Ncs+TrhIhWDCrApCkQ+65L52W28ZzaQZQeTBZAtpymmIQ+0fGgqh42jPhZQa
	 yzzEudnuMp5xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/11] fs: Use acquire/release for fdtable resize
 synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Oleksij Rempel" <o.rempel@pengutronix.de>, "Marc Kleine-Budde" <mkl@pengutronix.de>, tytso@mit.edu, "Vincent
 Mailhol" <mailhol@kernel.org>, linux-can@vger.kernel.org, linux-ext4@vger.kernel.org, "Oliver
 Hartkopp" <socketcan@hartkopp.net>
In-Reply-To: <20260825095422.3166067-5-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-5-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:23 +0000
Message-Id: <20260826095424.516661F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on `files->resize_in_progress`.
> The flag is the publish point for fdtable expansion: writers clear it
> via release after rcu_assign_pointer(), readers check it via acquire
> before rcu_dereference_sched(). Observing it clear guarantees the new
> fdt pointer is visible.
>=20
> This expresses the pattern more clearly and allows cheaper one-way
> barriers on weakly-ordered architectures (e.g. arm64 STLR/LDAR vs
> DMB ISHST/ISHLD).
>=20
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D4

