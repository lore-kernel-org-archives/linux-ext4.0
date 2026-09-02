Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03C22F6565
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 02:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316957; cv=none; b=a6mL77ibY+Z2eIJeX+7cAicGQH9w0XO8AmBfGZ1GjLCJJgTT4QtF1PIDTXpWbXVKzFcmCB0PzqhAVwoxSpCfsnccOip/uM1fPdwYj3HOQkpYfxlgacYNPjdtnh5NttPJjlmc2GSynB48ehcJxDdF94oiejw1mGK7wO5IcMEXFwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316957; c=relaxed/simple;
	bh=3P7udymP3sFoGz9ClbmgLwm3+5Lyn0JJebcIMu/pyn0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LJeLaRhMVVko6ATXJQwVAbO+Fl1B0XgxhJqzK9bAehbQbBAg94t90O4AEU6u3Zvwb/cJ5+z5ULqTcDzZRa+tSG5SQ1Uks0o6AQjLas91YHoufoWbomgaQrDNhtyqAKOa1N2LUtCf3maE4Xb6ojxwgwygu2zkmlOsT7X1Hp2NM80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LszYaj2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LszYaj2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D6C1F00A3D;
	Wed,  2 Sep 2026 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316956;
	bh=zuNU4cJHEWDSenSHL+OV+N1mmlyyjIl6QVVwu0RQdYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LszYaj2zRLStnik3QHlxTp+ccuPmxWzVTsNZU+H6uIsa4smhrtZR8JTVxPumut4/f
	 fNxGkMIbx8sU/gPXfYErYK0x68fgDwDBRSbb7kSU4iAxW8zJ/QvspjY9lXJ+A4eya6
	 mlZkbmjgSe4vsNWEuFH4AnIxgjrZ0vI9VPM8bzkHF4Bjh9vvKIfTDmEtj4Ewo32RdG
	 lCPif7HyrwGU3n0LXw+jBw2t8BqwN/niodw0/txMEsKsRfoFNJpSSElesBbeEnhv3E
	 aQlWixw4Vi4zh+CLE0p7TJb1qScVtwYrPlksZHGXhSJeFKofxfl3glNtPxseKe3c2S
	 2PDb/Kejbm+Ng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/12] ext4: Fix out-of-bounds read in
 ext4_get_group_info()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260901024234.135119-8-ruanjinjie@huawei.com>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-8-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 02:42:35 +0000
Message-Id: <20260902024236.45D6C1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> A plain read of s_groups_count in ext4_get_group_info() allows CPU
> load-load reordering. On weak memory models, speculative prefetch of
> s_group_info prior to the boundary check could lead to an out-of-bounds
> read if a concurrent online resize expands the array and increments
> s_groups_count.
>=20
> The data race occurs between the ioctl configuration path (holding the
> resize lock via ext4_resize_begin) and the lockless metadata lookup path:
>=20
>    CPU 0 (Writer, Resize Lock)                CPU 1 (Reader, Lockless)
>    ---------------------------                ------------------------
>    ext4_ioctl()
>      [EXT4_IOC_GROUP_ADD]
>      ext4_ioctl_group_add()
>        ext4_resize_begin() // Takes lock
> [ ... ]
> Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> Cc: Zhang Yi <yi.zhang@huawei.com>
> Fixes: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
> Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%=
40huawei.com
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901024234.1351=
19-1-ruanjinjie@huawei.com?part=3D7

