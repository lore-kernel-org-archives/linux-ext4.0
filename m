Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6104F3D890D;
	Wed, 26 Aug 2026 09:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738062; cv=none; b=PTfm2+qZZiYkVyPn3BWy4KOgeJ5Zw+ApISSXxQdWjj2TSueXrR5xo1c5lkixOEZnJxEqcRxtm2dqSc2Qg9Bt4pO4ujT+g4pkvAX0OP1hkOYv8UYTLRUQKjPnFuWSXF6Ou5QaKuUGrat1JReU5y8elEDF1mJmYkiLk8rEovZ06Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738062; c=relaxed/simple;
	bh=bdjGZgYMHQxRItVtl5IqxxLWmvDTokFPHdGRmx+8TSI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fA8BntiPNpHWEbb2AZhNB1EgKhIuK5X4aAbvPlZWvS3pBOBpgeQFZOxgLBP7Fw2U8lwWx0EbKIdTsb03AZAUmqmnE3hEyTUS63LzBB0my68aD3+MHiA37Jvi64pSzQ5ryKNDt0Yi/EIo4Kyd7M3omY5pOSrkpfCqjgKUjomux2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBTuGtRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBTuGtRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864461F00A3A;
	Wed, 26 Aug 2026 09:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738060;
	bh=bdjGZgYMHQxRItVtl5IqxxLWmvDTokFPHdGRmx+8TSI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SBTuGtRAwnbJQdAi8gAAiv5FbJ9xURYFv8i2X41rrju8lk2iTLY9u5hKUXE7ANKwg
	 Jx/pBGqWevO1jJlsHfX8rjVBB6eYOSGUWOWSRGKtJ3yZioKH9uR8BbEAyKW4xF7eNk
	 NsxOXtbF35vtWhyLh/I5mzxAfb5tais31fbMt6FNohrXuTb46WcSYSHvJCW/cHbovH
	 AJLrYeCiratC2kp0i/CUvds6U+3PtJ/J90YHpMCS9VLSAvBcBVpUnAZGk3dTwYjMiz
	 dvLze3gGG9Lau0EhRtWMdsgEo2hN8ttbFO1jVdMWIVrgACl1pw2FQJGMEkABp4mGQt
	 EG5SO4PBJmRLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/11] lib/vsprintf: Use acquire/release for ptr_key
 publication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Oleksij Rempel" <o.rempel@pengutronix.de>, linux-can@vger.kernel.org, "Vincent
 Mailhol" <mailhol@kernel.org>, tytso@mit.edu, "Marc Kleine-Budde" <mkl@pengutronix.de>, "Oliver
 Hartkopp" <socketcan@hartkopp.net>, linux-ext4@vger.kernel.org
In-Reply-To: <20260825095422.3166067-3-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-3-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:20 +0000
Message-Id: <20260826095420.864461F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb() + WRITE_ONCE() and READ_ONCE() + smp_rmb() barrier
> pair with smp_store_release()/smp_load_acquire() on filled_random_ptr_key.
>=20
> This expresses the publish/subscribe pattern more clearly and allows
> architectures with native acquire/release instructions (e.g. arm64's
> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
>=20
> No functional change intended.
>=20
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D2

