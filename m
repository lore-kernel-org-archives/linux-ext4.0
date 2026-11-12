Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521518;
	b=wS6pO/jIf6faESw6sp1I98B/fvRbIraGiLljIbZ9TKqNYMixdoPzsquPm0hQGRH065SW
	 aM6GerSPW25pLyulFxaBacMzS4g/cWGY4q/Z769yXMliysFJOqiKdY83QL9cG0y1Vo5Ax
	 C6YDD+Zf0B1W//JZkcpleu9H4lzG9YofKJGnpFiVtCVN9zLDpRW3chyawBcCl+TF2vacD
	 SRI7eQGxbATlRJ+F8iDfi1xC7jRgiC+I36Jvc/vN5eZUU0MtT82vm72E9EYv99ZOalfpK
	 9ShJ8kq04zo4oPehv5BHaACPjSdqhr24pBzZi3ShZqEbFT+cR/fh9vDAoyebkOo26RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521518;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Lqmm82Oi0ke2Iig3YHFFoUN6yhbPLE5Oyyl5oL2MeQo=;
	b=zqH9INzkYnBCdiIBN2iGL4B31+QSZaz+2hWfXbVeWgO1YIa0mk0YNKliVWZGE1jIcWq+
	 amIOx20JpRwne/zS1tYCw2J2A2RF6hBMjBZXDjv65Xwnt4xXHPn+RhNwFeWTDA7/SXOor
	 Iw0Pgj6RgL9DVcCJMozU0YbVWL8zlaIu+dgD5ITGRbc2v5Yht4xEvcmAB+XP4E0TUzcjL
	 t4/5Dc7k0alplHLMw2pC/rkIHAsBOAp8Y3hsN02sHbeVnXJpxz37OM7OMunkfetnNVnsh
	 +31qfA3ICVSZP7gCzo920LvMrhLm39iBsCJTN0gnYWO/TcfquHeUrW56N8dVcllrEUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M2ohQZ6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32772606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M2ohQZ6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B051F000C4;
	Thu, 12 Nov 2026 22:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521517;
	bh=Lqmm82Oi0ke2Iig3YHFFoUN6yhbPLE5Oyyl5oL2MeQo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M2ohQZ6b9QgLDMRBRBlVXtP2FTqEDdjxwuOAu0bdCd2eoDM9mqHoDjTnhE0ZZxbYD
	 DafwHxnuVD0GNaXkO4BkRBHBlCaKIXKts/x8sh2K0sGKYzemzs3TsXhB4DkQ/WyQFe
	 gqmaVAcrhan/yYspqZEzOnXNvtAYkT8DjVfDdJZ+cb0xfc1fwI8IAfOtGgsPLqZYCS
	 Lf+ld7p+NlLbJbxDT46LYYcDZ32EvlpdxL3+ThG/xFf7SlJn1/qH07wvWoevGMkwnM
	 2NXuVCpvesP+ipX5HQkjixoA1BYzeBCi/b/vXYqUQLF+TTue+ASgcvcon1WbuNtGOP
	 UdrO2uPoVTxyA==
Message-ID: <sashiko-outbox-211892@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 10/14] xfs: refuse fallocate racing with realtime
 flag changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-11-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-11-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:11:57 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> On a zoned XFS, fallocate() can dereference a NULL pointer if the
> realtime flag of the file is set during the call.
>=20
> xfs_file_fallocate() reserves zoned space only for a zoned inode, and
> tests for that before it takes the iolock. FS_IOC_FSSETXATTR can change
> the realtime flag of a file with no blocks in that gap.
> xfs_falloc_force_zero() then sees a zoned inode and reads the
> reservation, which is NULL:
>=20
>     fallocate(FALLOC_FL_ZERO_RANGE)     FS_IOC_FSSETXATTR
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>                                         takes the iolock
>     sees that the inode is not zoned
>     waits for the iolock
>                                         sets the realtime flag
>                                         drops the iolock
>     xfs_falloc_force_zero()
>       sees that the inode is zoned
>       /* ac is NULL */
>=20
> The fix used here is to test again under the iolock, and to fail the
> call with -EINVAL if the answer has changed, as the write path does.
>=20
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D10

