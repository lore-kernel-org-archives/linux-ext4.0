Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521287;
	b=PdU/Us5c3ggi4DymbXJRCF2JazpvECMDQ8ltVL8VVUhS4dt2fUZ482iB/QmhU6GZui15
	 C1jdWq555Xny2jOiLN+fqFTKM4Rp8S1GjBIbJNoDJnMbp89SWnS62sODdzzSk7FVZVrBX
	 GeBHl0CEW4Payq+grBc6kzlmskUwT1xu4fFEVqkm7wUR0EVKgCeKyqkLG96eIwb2a0Ej/
	 EEbT9q+vBMNoFcGPuDotVLLveDBMuqhICuSMu/UyRyqqOlH5FuE3u6msr7Q5TCAdsMQJY
	 bM+YYfb/c2ykQks9v5pvAaYVT2jvN1+H1qpehbVp8SQ+RlXsb5BZOaFl75Rbvzhsmgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521287;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BMf4rzWpy48dHYQnizqyGr6VIJB7YekNr2gCUN6ZGoo=;
	b=2Dis1m+bY8HALBsM5hVI/9FSQ6H6M6v0HtlxPFL0LN6oZB/5qoCMz32B4AF/bP21YbOn
	 xTKCZyb3IlFHa4oZqnFG1qOiateSX8xyNIkS6XtY+xkSbfvQ3iGxfHtsmcydgYJHTrEcn
	 3tFESKyxs+eqaNRgdjwek5SCOqTj67CI+9X8+hlQTzrQVTWYa7r1FiJwygk3dPoakold8
	 4q12kP6eFmWuLHX7BwWYMbWsahyIwd3OcngE/N5lP3308Dsd6vcXhP0Hv2vgT4YWp4xmc
	 rLLVsX356fvgVrWx3dkrLEyyqFwIRfMElU3Nfo624N3x5orYrPjjJJvkVzM0e0IuwMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oouIzFnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB589606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oouIzFnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C26A1F000C4;
	Thu, 12 Nov 2026 22:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521287;
	bh=BMf4rzWpy48dHYQnizqyGr6VIJB7YekNr2gCUN6ZGoo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oouIzFnN5A1v7pECTCIMCCy8qQSZ6r680FD/luGwUN1fFkvfDjI94UIRdYtN/6Brg
	 /wwc5pfQpCKZAkSfii2k3E20plmNsYV30SLMIzCC45MC7e6a6Qqk0+BWFrq7p7/oAw
	 QQwRHCyfgDTTEZ9kWW4ZxW6dm/IvZx65bGJ7MiwtBTckC2rYQI4y4KlVzcopoetyjb
	 eyqIg958vf95uRLr6Y8ZewLb32WP12Gz41/dJO8OMh4Bl/wCPsvhEB4VulPAG+a6Z4
	 60sE2Eo3qXLijGBFWOmDX1o/U+fRjXlgaNt74WNPZRRJGNLN9Fe0VSBWGkssnVMzMQ
	 GUOZXoMm7SeJA==
Message-ID: <sashiko-outbox-211888@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 12/14] xfs: restart faults racing with realtime flag
 changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-13-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-13-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:08:06 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> On a zoned XFS, a store through a shared mapping can dereference a NULL
> pointer if the realtime flag of the file is set as the write fault
> starts.
>=20
> xfs_write_fault() reserves zoned space only for a zoned inode. The
> reservation can wait for garbage collection, which takes the MMAPLOCK,
> so it comes ahead of that lock, and so does the test for a zoned inode.
> FS_IOC_FSSETXATTR can set the flag of a file with no blocks right after
> the test:
>=20
>     write fault                           FS_IOC_FSSETXATTR
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                           =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     xfs_write_fault()
>       sees that the inode is not zoned
>                                           sets the realtime flag
>       takes the MMAPLOCK
>     xfs_buffered_write_iomap_begin()
>       sees that the inode is zoned
>       /* ac is NULL */
>=20
> The fix used here is to test again under the MMAPLOCK, which keeps the
> ioctl out since "xfs: take the MMAPLOCK in xfs_fileattr_set()", and to
> start the fault over if the flag has changed.
>=20
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D12

