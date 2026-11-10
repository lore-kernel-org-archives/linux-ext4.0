Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794341343;
	b=xHm8YfTGBg5x3i0qKCe0b29XJ58Oh4ArKqB4g4t2eW50NQV7xNXnIa70AV/E7WiILzEa
	 efNZWSR41352EhG6WXWfY5SogzOVSNF1CSisE+9qfXQy9FCSdoXsJEvzm3+mG5vxhW93Q
	 gnVq/L/r8vK76/AILiwchiSUKASVNFkushj52k+ByRs8O+M/CncsoS5Rr6mJ7EtVqJ4w5
	 qd2OPGQb43l/BrnwV3JQV2KtRyMioiP0y2yLlTU4TpnCw/YBZ4Ad9kyl2Gi9Ff7dIpPpy
	 VUHj6Bq4FX+jUzgQ23R6/boAKKh147MFDFldK0O9VurDYQpbuNpCF3kSJ7sispClVkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794341343;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=huWqX2BT2xM8Mv6olXHEFZsOn1MKTbmy6vBpkBC9U+0=;
	b=efT5KdTNfqF1+458AsoXTEBkpZ6OUQVZqSIicyTnLqsl7OkObVMGP/I+2n1+Rd+obtkD
	 VQrSSUKr2jU1vGNJcbjziOZe/lygJmqtDvvpDoy4PfnoAfYEw6Gi1FWMVXN8v30SM9InI
	 tnu0LDC9wn9ammcYXiqDBc2gOQBU4I4SDfs8uX7llrCZTikN1WMHJrJ9y7L6QObZpNSOH
	 v2aBciwVRfnOl+/3/B/DLlwnPE/d7x3MzZfg0p+y9GX2tr6NSkT9jCKM0tkWbsmRLv8jo
	 4OR1qE1/lBxJytniV4Sthv+Kfsk2xYaLZ36LavZ1K9GKG9afNWY/5pK/4V9UOKD6btA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="M/sisilG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B88606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M/sisilG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2811F0089F;
	Tue, 10 Nov 2026 20:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794341342;
	bh=huWqX2BT2xM8Mv6olXHEFZsOn1MKTbmy6vBpkBC9U+0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M/sisilGYt/32oGcO9niCqLHe2pSy6XgDw4tNK7wrGyfyft27Sqs8EDT/YLNUbAoV
	 BfznPw9E0wC1jEEZuoVE6qxePXX+ZXT//iF/eYi4jIQnO/RsvBB0DLjFm129KXBQ7x
	 UDUd8dCmldEhH0q7ie2cN9sue/m5fqu0tu5MWsm+R9e7Z17TOBFPxwGgTtLnfzDv1v
	 LtRe81JDdX+G6WvEj2UcF2BHzhmq++vKprVuY5DpmhQC0eXP2HmNklwRaYnuW40YMI
	 6Sn2JfQMUwyn8z7Lz5mF8MkrW7Nzg6waPJggT5DvXwGswqIdyueZw46dWcRGGWFPku
	 89DDnWib5QvFw==
Message-ID: <sashiko-outbox-207704@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 10/11] xfs: refuse fallocate racing with realtime
 flag changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-12-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-12-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:09:02 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D10

