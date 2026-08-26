Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B742D4248D2;
	Wed, 26 Aug 2026 09:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738066; cv=none; b=gBmAxHdv2b+bAoIkrnqpgxOTdkTz2dRvf3CDBV3WoEe+EjgmL19Y6Mg6AQP99QqqTdT/gv5EizQ1QIZOq7e1iziwMtf7Q0EFfscJjQX7XmEq45xt2Kl+xTkHN3S3kSf+suVnBtOfxc5o6VZhIxOERVT/l2CuVoL7asPrDCeBZGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738066; c=relaxed/simple;
	bh=zLhoRZhapgbXtlCmoMaHr/HSkRUO/EsjoT3slY3ARfo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H+LwZk2pnGuK4Mw1hVyp8+iUWrITW/eCUNytW3Q6GVdVqdrfEJ+98WMosORO3k3SK8HgYlWqTsUDrvO+CYqDmkVwZ1vp9Vt39Jt2CfUVvstcfJi2j3mHngbZiKz2EheN7mPkL6gDcHmB+iVg70+Tj2PsSanw7qbZ9C8b5xvMu5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOmwMOuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOmwMOuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DED91F000E9;
	Wed, 26 Aug 2026 09:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738065;
	bh=zLhoRZhapgbXtlCmoMaHr/HSkRUO/EsjoT3slY3ARfo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UOmwMOucxQlA+ihqFEHTWes2U2FzDLCytxOkWM+2ZWdiZirlQ2oHRifWMOmV+MqHc
	 T+BBvA+jvgorOoqUVNIAhTrRi1Ryfx7J5hoeV9O3FrlUATQigXEUTEhiE5WtqFaCno
	 LGQc41WY4Ys9VSfwY4Kmm3FWPesySGYjvLIHFxyeadrXcgzs7jW/yuyx+rhXBMq8y4
	 5g+NCOmo6CtM042JTA41unpkxiZ/RwgtKHggE/p6i5BZRY5fH22T7aj2mavMiC0pR5
	 WKKC5xu0LmP86ae1RzkQjJqlDFVPSfL72ZgrsnFofFwvw+OC57s7b8LTMZ377fpcg8
	 4hFwvBTTTthgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/11] net: sched: act_gact: use acquire/release for
 tcfg_ptype
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Vincent Mailhol" <mailhol@kernel.org>, tytso@mit.edu, linux-ext4@vger.kernel.org, "Oliver
 Hartkopp" <socketcan@hartkopp.net>, "Marc Kleine-Budde" <mkl@pengutronix.de>, linux-can@vger.kernel.org, "Oleksij
 Rempel" <o.rempel@pengutronix.de>
In-Reply-To: <20260825095422.3166067-10-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-10-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:24 +0000
Message-Id: <20260826095425.3DED91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on gact->tcfg_ptype.
> tcf_gact_init() publishes tcfg_ptype via release after writing
> tcfg_pval/tcfg_paction; tcf_gact_act() acquires it before
> dispatching to gact_net_rand()/gact_determ(), ensuring the probability
> parameters are visible.
>=20
> No functional change intended.
>=20
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D9

