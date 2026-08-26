Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424413DC4C9;
	Wed, 26 Aug 2026 09:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738063; cv=none; b=atvvLpP1lS2qqSQ2YhgeJcmz2+QToHc2PynKBUK9jzNGB8AnquxeOu5fajfMT1PgmKCJi2LSd9Qitf1+F5u882cJOOZ+72jTRv67BWwwb6LRlPJaEIXeCe3qfmS0ep7q6bx31zuz0L2P2Baf8IXZY8KwMzQeXSU6AFwI7mgIH8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738063; c=relaxed/simple;
	bh=UQzBMv3q82AFLKRCXPIOpGJQWYOUVgLwlm6B1ED0HiI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pr/zZltKgJabq+DVid5dQQXZTjBUbWX5QMuAZfAC6bEFY8qAu9U8RnRixa2cQ6c7e529XECDf+qQf8d8+QEuFJUbak7nKS9XWPzAm9C0mBtVe7oPRL0fZKw/9Q/JQDJe4gow8N3PXeTvU39Y9xCMMH0lCun+NnL4Nj8DUTD3FG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgfBZ5bi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgfBZ5bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E0A1F00A3E;
	Wed, 26 Aug 2026 09:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738061;
	bh=QOOtJHMtwKmvmDtZxIbec3OJeXZIoxmLk+U6qJm61bM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UgfBZ5biRtHaAxKRgtItQkfwrMuFzlaDboeJTDkkUF0Dhx6dODGXK+y6B8U7LEcCa
	 NRvEzuKUW0KL10T0cs8v0p5jR3PPE6uQqLcKg0yB1CGCp5JsMwpICTpkK5gZcrVQWY
	 6BG0KGvjYE15b3tmLWBB8o8CC15Eg5RkWAk9Cx5dWC42hwLFj65slehFVI6D2lT6On
	 b4JkqfRWvWQ+cOm3Ks3ptx9vJOo0dnZ0JkKNFiatJ1vfokB3sSXCTccqeUFnxrG9af
	 HCL0rOI69kA+vd6lFgepcfht1Y7UNvVegBBUzhsWXDbVpqN5uXH69pkGK165tUW9nV
	 T6XrVIrr961Dw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/11] user_namespace: Use acquire/release for
 nr_extents synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Marc Kleine-Budde" <mkl@pengutronix.de>, linux-can@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, "Oliver
 Hartkopp" <socketcan@hartkopp.net>, "Vincent Mailhol" <mailhol@kernel.org>, "Oleksij
 Rempel" <o.rempel@pengutronix.de>
In-Reply-To: <20260825095422.3166067-2-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-2-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:21 +0000
Message-Id: <20260826095421.73E0A1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch missed replacing `READ_ONCE()` and `smp_rmb()` with `s=
mp_load_acquire()` in `copy_mnt_idmap()` within `fs/mnt_idmapping.c`.
--

--- Patch [1]: [PATCH 01/11] user_namespace: Use acquire/release for nr_ext=
ents synchronization ---
commit 1bcd6fdf3ca65990e2c5f3f0896df9c586813872
Author: Jinjie Ruan <ruanjinjie@huawei.com>

user_namespace: Use acquire/release for nr_extents synchronization

This commit replaces smp_wmb() and smp_rmb() with smp_store_release() and
smp_load_acquire() for nr_extents in user namespaces. This aims to improve
performance on architectures with native acquire/release instructions.

> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 0bed462e9b2a2..576b667a88136 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c

[ ... ]

> @@ -1098,8 +1100,8 @@ static ssize_t map_write(struct file *file, const c=
har __user *buf,
>  		map->forward =3D new_map.forward;
>  		map->reverse =3D new_map.reverse;
>  	}
> -	smp_wmb();
> -	map->nr_extents =3D new_map.nr_extents;
> +	/* Pairs with smp_load_acquire() in map_id_range_{up,down}() and m_star=
t(). */
> +	smp_store_release(&map->nr_extents, new_map.nr_extents);

[Severity: Medium]
Does this code miss updating copy_mnt_idmap() in fs/mnt_idmapping.c?

Since map_write() now uses smp_store_release() to update nr_extents, should
the reader in copy_mnt_idmap() also be migrated to use smp_load_acquire()?

Currently it still uses the old barrier pattern and contains a stale commen=
t:

fs/mnt_idmapping.c:copy_mnt_idmap() {
    ...
	u32 nr_extents =3D READ_ONCE(map_from->nr_extents);
	/* Pairs with smp_wmb() when writing the idmapping. */
	smp_rmb();
    ...
}

While the release-store correctly pairs with the existing smp_rmb() under t=
he
Linux Kernel Memory Model, leaving the old barrier in place defeats the sta=
ted
goal of avoiding the cost of full one-way barriers on architectures like ar=
m64
for this specific code path.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D1
