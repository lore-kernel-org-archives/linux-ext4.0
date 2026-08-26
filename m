Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2467423E9C;
	Wed, 26 Aug 2026 09:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738065; cv=none; b=b3gGfkfR+xlZbCpyblKqcNNp4KFwNJHYCghmtaxVUCKOXTGW2erJinMGerGfDZfTYC+Ien/ZkTCxsw84qGkXBEFK6FSSpCIEyoNEqEl8PRZi/PVwXDjt0R1coUXRUCMHr3p8kBKrWpAbwO6c3ufajPgitM3r1gHu2JefLEublwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738065; c=relaxed/simple;
	bh=KTGasc1rFomyebAJZfSHeJpUXCMs0PdR0287Sn3SFRg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EPiJnINSnq8du0E0OOVnwxpcDK5ywHe3X3g9w4kzc3VQJcKOf/daO0Ss5+iu9cQQFFD6q94+q/xvxWG2Fn2WkOyv8YqfOqzKCqr9ilQ3GlbwafdNCVQSCasU7P/8T9S7svHMm+zSMBfTc3n2QBRQWejE/K+8kPqKUO40SX1dgeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7OwBdfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7OwBdfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668EE1F00A3A;
	Wed, 26 Aug 2026 09:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738063;
	bh=KTGasc1rFomyebAJZfSHeJpUXCMs0PdR0287Sn3SFRg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S7OwBdfRX9LGrOGxVFXpWdP3hKoUvYNk74s0KzAaXWLGNHqeqh/wQKV3t19grvsIm
	 w0NEtQ7rANMROboD/OnhMe6mEloROpbpIlWdYutW8V3MBjsX1Vp0D0ql2S7vH9Cm6K
	 04f6sm70wZ5s773q346iKLFuD9OtCrUC6hW1y2OHYsjLv6eFyUF4/3TIDJHaRuCqt7
	 3XOTRCcFKlhrf2fs//2uVFB2R1/EdSz2YFg5wthluAPdo8dx0MxbZSH0WaJzAa4FzH
	 21g/mNTiFxuch/lTndbw4rDdO4yECL2Ext9f3qZptyXpPuQ3QLhKq29w2sACxOc35K
	 aWOychjC1zOQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/11] pidfs: Use test_bit_acquire() for attr flag tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, "Oliver Hartkopp" <socketcan@hartkopp.net>, "Marc
 Kleine-Budde" <mkl@pengutronix.de>, "Vincent Mailhol" <mailhol@kernel.org>, linux-can@vger.kernel.org, tytso@mit.edu, "Oleksij
 Rempel" <o.rempel@pengutronix.de>
In-Reply-To: <20260825095422.3166067-6-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-6-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:23 +0000
Message-Id: <20260826095423.668EE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace test_bit() + smp_rmb() with test_bit_acquire() for
> PIDFS_ATTR_BIT_EXIT and PIDFS_ATTR_BIT_COREDUMP tests in pidfd_info().
>=20
> The acquire semantics ensure that if the flag is observed set, the
> associated attr fields written before smp_wmb() + set_bit() are
> also visible.
>=20
> Writers keep smp_wmb() + set_bit() since no release bitop exists.
>=20
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D5

