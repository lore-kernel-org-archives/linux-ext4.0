Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520433;
	b=vD3/A83xWyUXNXrNOoGOZ+L2LTw1eBuVvQ2163n0Yebh783udcOv7aA0huDz+zfOU0bf
	 zvDhkgDs9/332QBNm2UpacUaIp1tXER1fgkv+/IGcvP3ZYoFgr8IghCrm6xAPkH2sRRe5
	 9evXV0HXZZMpJayOGJiXBvgSSJWcozYO2QxiyrTWFnzkukuqHihyNhfFhXYyI5XrzhS6H
	 CJDdicEY/KW/hoEnU0dxWFjdYn58Ss0LYhNrfhwT3U6F3KMso4hFOPAPo5+oN8e+4OyVz
	 wSNYvVy+ORpZGpG1elvrmSM0a8J70/9RmSMURfGcPfHiSO/4Wj0/Yw1eVxABXE9aR6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520433;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jmT8sGfLa/kJa8o6J7xJPB3e+atNGEGfQ1jq1OYyxSo=;
	b=XLJyCuENVb6RuDFi8LiMRSOKcMxS37Sx2xTj39QG2qmCPf967hH5nxkBvtLA7QR6xP0g
	 +Hcm06iAP98odKh4Ux3DrE3rGUkcI13E9YwLPxZKaur58YHji0GwmYy6d0t8cr8lGEQNh
	 DyDTHCjwPVUeGwO67Aa0Vz0aMUREE8PYV1693mDkRIN6iw6wy8bXfMsrXfbD/NL8wnRqZ
	 qLjrS4a8HA+fEy3moVjdNd9DIPxybXC5+MgzFhnyUXEeHL50BZ5za4naAl9G7NXCTMilz
	 73t7i1lIi9cEPZ3QcOhqY6FUhfQuEbmiaS6+EW5vmTjHFKIZZR6qofYDfnJmZA0lqwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZDfWFt3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0B1606A333
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZDfWFt3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EE21F000CA;
	Thu, 12 Nov 2026 21:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794520433;
	bh=jmT8sGfLa/kJa8o6J7xJPB3e+atNGEGfQ1jq1OYyxSo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZDfWFt3HxsmB87NLh1OWktLzPpHLLyvIXlGMea96fsF+SbCbR+saO9Iq0J0yI3E1p
	 bt7WwFRcGaOroKysW3CkN6k8EG7nOfIvnPVgGme4wxGS4dz9Sm/pzYGrQYqeYho+Hw
	 J1x8EH0HICS8uDJlx3RGHt5Zhrpj+GyYRoBCRFt7bgjadXIFFGMNoeji0JyGvEc2jr
	 WHZINiVGgVfC0GfOJl6LyljmmoSRXgBAHF+kOsXluU+Sf1UxdG4Bengt5GR2r9nNHh
	 ljRn0Pdhrcj3JBLEATD8cLAYnmGxXp9BewSob9x/zL+Xu5APf7q/UQ8JDIdtoYEKjU
	 +RTx4cdT6+IEw==
Message-ID: <sashiko-outbox-211875@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 09/14] xfs: test for always COW after the dio write
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-10-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-10-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 21:53:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A direct write to a zoned file from vectors that are not block aligned
> can silently corrupt the file's data, if the realtime flag is cleared
> and set again while the write starts.
>=20
> Every bio of an always COW write has to cover whole blocks, so
> xfs_file_dio_write_aligned() passes IOMAP_DIO_FSBLOCK_ALIGNED for such
> an inode. But it tests for always COW before it takes the IOLOCK, and
> the realtime flag of a file with no blocks can change until then:
>=20
>     xfs_file_dio_write_zoned()            FS_IOC_FSSETXATTR
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D            =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     xfs_zoned_write_space_reserve()
>                                           clears the realtime flag
>     xfs_file_dio_write_aligned()
>       xfs_is_always_cow_inode() is false
>                                           sets the realtime flag
>       xfs_ilock_iocb_for_write()
>       xfs_file_write_checks()
>       iomap_dio_rw()
>         splits a bio inside a block
>=20
> The fix used here is to test for always COW once the IOLOCK is held.
>=20
> Before commit 8caec6c9fef7 ("xfs: support sub-block aligned vectors in
> always COW mode"), xfs_file_dio_write() made the same test with no lock
> held, to send such vectors down the unaligned path. So v6.15 to v6.18
> have the same race, and need a different version of this fix.
>=20
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D9

