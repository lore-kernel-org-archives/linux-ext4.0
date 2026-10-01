Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54373C76AD
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2026 07:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840980; cv=none; b=naNEIAnh8mkuRnWu3sYjMgBdTPIeNG81MNEjNbm1cu0vLsJievug4PqyX/B5V8TPdSEXyxffmMIYqiNbnyqCVDhv0962bdFeRC4/HLRueHcTemy73CTuvyMTwpCHUtsJIa3Uk26E2KmBMKfsANOKXeYwj44bioaH8PutaIP5nlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840980; c=relaxed/simple;
	bh=HV2nzX+bl+Bw8DzFMyNhj7oxqand2Z0RRt4/2EYV5DI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uNHutUAzjpUlIlRpPz/fOB5syDgzjI95rvCTK7yWK3rCfyNM4Se0rbhyGFmCMGo2M/awok2/dfKN51bLouB9h2epvXdOGPtGQXMSWBWqe6uqO/eBpa6T3SV2afnIhAB+g3l4FOu7Ac8p4w5WpDUf4daAzsl39VJBu9uJTppsk2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqyQhc7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqyQhc7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514951F000FF;
	Thu,  1 Oct 2026 07:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790840979;
	bh=HV2nzX+bl+Bw8DzFMyNhj7oxqand2Z0RRt4/2EYV5DI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FqyQhc7fjJBbI62b1U0CES4GPAbFb9+A01ksuVp10cU55HJfiKQC84SyoOJBlg3to
	 yAV2PDxx/E4iym/o5BQIFvK7Np8uwOzidOVc+aZQrWQLqh5lIbfp094FKR7x/NMjzP
	 KAnRhMqPVcPxAzqbGvOcM0Dws47XjtSvogX3JreS+h+vcoBd6e7CBj4NVA7qSm+Np7
	 UyS5FsKHolQSCU4uOhydjt7x2KxpkoPgR75qeCUnII95YeR10JadfAjBToht87dy+v
	 FJw5RJ78bKzGIQbVCjc2+j4/SNsVratMJi3OqYXBRKrgi8ms4LwEj5aJL+WIiiIgos
	 CLaaeTAyxZQuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] ext4: remove unused locked_ei parameter from
 __es_shrink()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261001-fix-ext4-es-scan-nr-scanned-v4-2-b13703714ce2@gmail.com>
References: <20261001-fix-ext4-es-scan-nr-scanned-v4-0-b13703714ce2@gmail.com>
 <20261001-fix-ext4-es-scan-nr-scanned-v4-2-b13703714ce2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 07:49:38 +0000
Message-Id: <20261001074939.514951F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> __es_shrink()'s locked_ei parameter exists to let a caller pass in an
> inode it already holds i_es_lock on, so the shrinker walk can skip
> that inode instead of deadlocking on write_trylock(), and fall back
> to reclaiming from it directly if nothing else could be freed. Its
> only caller, ext4_es_scan(), always passes NULL.
>=20
> Drop the parameter along with the two code paths that exist solely to
> support it: the ei =3D=3D locked_ei skip check, and the trailing
> es_reclaim_extents(locked_ei, ...) fallback, neither of which can ever
> run while locked_ei is always NULL.
>=20
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-ext4-e=
s-scan-nr-scanned-v4-0-b13703714ce2@gmail.com?part=3D2

