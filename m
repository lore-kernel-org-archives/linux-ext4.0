Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792423669;
	b=c2prB9UEHQRBw3wqqKSUc8Ha7MTtZwKjChMqjIRlaJNbrGfn3oh/0PK7rm/DocubK+ev
	 QJtjb8AF6piCkvaU7EfbYiJyge8duvb9yqmIWF/fYk26Rfs+bAeXcsAhPNriy7V36vuek
	 73LApm5z7+NUuc0dwqfNQLa4xWP5qNDvecCDQNYcGTr/Wve6p4KQ+gRWbaSHgw3sreoTH
	 7noeW6jhIevYzoc5AK4blFPMg55ZPQILSgqFSsZ/FVKRbPkpiwFY6mFYiAK2LTsU+r7ap
	 cFdN/oGwoZy1iZqKnRF1oFHayI9K5PB0hh0xMRKJZj8/M6jYYVDDAogpRF4FKQh1Tyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792423669;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9MoAa9KU8/pnKkjAY6L5b5PfuNTwjiOST2AFEBI4+JE=;
	b=u5j9KB8KVHQJvbm5URObD+6L7amX7ScLjXyBuOCPUXJLwDO/glfHf5vSas/80rc76AeZ
	 SSf94efLEpmK69iQc5GlNlLPvbDjSN57n8/cmIhs42QlLxKL6iMdLIpO+o8e7uLEmYafs
	 YfDEJEUamUg7Itt2mEkJ7rBpRIL5bfBnBFekEGVokxXhQk1Q6DurTb5At455qxU5QGVCj
	 LDsSWG7e87Nx5ldYPXKv3XZqQhAw7AlhJqxL99TlYtKaogwf5omJBJbTPXyyLlQB/ZrYC
	 HM/JhX78MLYKC4pyTBXkoYhyrHu6xoJHupNgIvG1bwk7pNVddJX2kYldEWG7CD2XtaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PETE1V9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2FA60B507B
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 15:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PETE1V9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D841F000C4;
	Mon, 19 Oct 2026 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792423667;
	bh=9MoAa9KU8/pnKkjAY6L5b5PfuNTwjiOST2AFEBI4+JE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PETE1V9DNPJr2rtoaCmPbS/Vg7uOEG55CxwPbdyGMXBBZFfIvp0BPFRvd1XdQuBBh
	 v32xaUfQuZ6Oda/Licved9rRC6D5kWLnYocZzwdUo9ZldwfhgxUsv5SOXvl3QDoBgU
	 2R3arCKwdC2owokjsv8aOH5v/gyjip/UeocVJx5KRy27gyvj4IuHp8W0euSfZIp45J
	 VVX0jxx4ZelGsGyKTh17YTETfiUAGkUGVCui9FnWCEHKI5to005Z1i2KT0nEhSvCMc
	 aYaXcPbbbLO1zR9x6Tgfwa6E3GL+9mh3VSRnY8lEXOourxzpN6tYrxPBHZehi6X+ID
	 OldvPzCRwQDOQ==
Message-ID: <sashiko-outbox-177730@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] ext4: reduce max cluster size to
 match documented 256MB limit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261019135441.1420968-511-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-511-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 15:27:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Baokun Li <libaokun@linux.alibaba.com>
>=20
> [ Upstream commit afa3caf2fbc417f755f36e271c4b3c2d45ccda9d ]
>=20
> The mke2fs man page documents:
>=20
>   Valid cluster-size values are from 2048 to 256M bytes per cluster.
>=20
> but EXT4_MAX_CLUSTER_LOG_SIZE was set to 30 (1GB), allowing crafted
> filesystem images to specify cluster sizes up to 1GB.
>=20
> On 32-bit systems with bigalloc enabled, the consistency check in
> ext4_handle_clustersize():
>=20
>   s_blocks_per_group =3D=3D s_clusters_per_group * (clustersize / blocksi=
ze)
> [ ... ]
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Link: https://patch.msgid.link/20260608111150.827117-3-libaokun@linux.ali=
baba.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-511-sashal@kernel.org?part=3D1

