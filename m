Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0044CCDD5
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 08:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788336072; cv=none; b=f6sZXfX5bBe/b4alaGyLc56azTisvcWB88Klumtt6FKOihjPQm6/ScEKc3uJYucoOXLWUh7MiLRQBBufmWNpr1U9kzdgrMox08c1dwXZYWawrGZLxSlqs3gXJQyPqJJcSBIz67Ydj/ZW/S78uJm/bF0mqOzhcPlKozNnIWcPZ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788336072; c=relaxed/simple;
	bh=oIwt+sZH7Qrk9T2zM1Mnnu+ve6A3/gB/hoKa1gMraSY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HPs6d6r2NgmtLVo2uWurz40fO0b8AbeltVd8DO+eioS8Dvb5lfPzTYR/lhS7QuKIAPA+VesZb1L40ek+YwxOXCvmhK1ljb2GBc8yJxGvwELVIkR92T41DOCiD1nbk3hOhHe9t6VueyLiSwJ/Wpb1eXzPdrfj2d6/WqeU1nr43NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNabSR6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNabSR6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8191F000E9;
	Wed,  2 Sep 2026 08:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788336071;
	bh=efnU98UKogw30u/pfhEi3t9PjABkjqgzl89tDFcxKaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WNabSR6F5TnGxBj0ikJSkWsLx1PN4ui+3AzWDaXrpCZrTQpgf8UBLof5bbKPnNPLx
	 xHCz9G3QZVsQo4o838ec7Acvv4GGP8ueAoSJ/DEEDzfHy6sfQVad4H8dqIrm1t1tcY
	 lfp80Yvp4c6bhWLdvuHZ8BF3rIvmeory/ZsurMHv1t0vXcZoS4ijy7ldqacnptJivg
	 l8RuQm6OrG1kXmnjf+kyUYOL+PiW1j+U36waEmNlA9rwXYJJtsW8gbA2xObDYHQ9X7
	 4+F0nNYMR9foh80BqtvqtN3Ts5D4u4CzLaAZ1606dIUYRCPkD1U4HflZZaoQ455R1n
	 F3aloFHZ1HceQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/8] ext4: Fix out-of-bounds read in
 ext4_get_group_info()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260902074805.398540-8-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-8-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 08:01:10 +0000
Message-Id: <20260902080111.4C8191F000E9@smtp.kernel.org>
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
> Fixes: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
> Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%=
40huawei.com
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902074805.3985=
40-1-ruanjinjie@huawei.com?part=3D7

