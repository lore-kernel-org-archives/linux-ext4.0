Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190483;
	b=l+RnB+4NLhEZhOefufps9O7945Fq7p+jFHnsPi9nQ7qgy14OaqKXdi2CRAJ/KSm+oIkg
	 YRAueROQVqZat2aDkgu+6r/xo2XlS0WOPyk7aXrEk//isnzdjBpRvaxKkjxWRTidSiBtn
	 3X1Mdpu8E9RSaT8lIESHHg5Sy7KYgKruQAazYfOJvD/nqoPI3QrLkAy8RXBd3al5gIak/
	 Gm9N0xl8jeI/H0jkC9tnIP3S9e/CweSkg0D1EhzYjsyZSL+lXnuRfcF+r1Wr7LYXZ7g2N
	 NMISEWI45ilNA9pW6YmtuYcKG0Gc9zjCq7NDz2YKXr10+DrCYF/qfDo07Yvox3tDlGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190483;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tXgUFlZlMFnbEoirFrj85Dx9dYlMBZI38z1NmtPpj0c=;
	b=EFkvlJoQXlN1GG0sBMTkWS9R55OERJq0eJxW2PMjnE9Bagphe/+6f0bWI/uft2K0AQDw
	 WmK4piLzzEKbdNRiTodTSuJs3lGwpCyD7z3y2kXvwXGx3Qe6aTnIlBomZNaEM8596bQBj
	 ZDY2M5x6afhPS4PrlpIw6VyrLD4KEESyWHkYeCQVoqLgL2UkJMpGGGMIR9HGC0BkyXXOZ
	 89EOuFs1hL9qNdtQ9JkKXjs/o/OVgn/K9gf+iHoOlkVpPRE1V3hLlSvVc7MKKc02lGK5D
	 I1tQEjRHMmKtGnNNQRaxDEuztoGy9p9XMNQRD5nQcZHzrHFcTEL9+ha4IGrfMXlfx8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G4OyYBD2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65FB606A320
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G4OyYBD2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D701F000C4;
	Fri, 20 Nov 2026 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190482;
	bh=tXgUFlZlMFnbEoirFrj85Dx9dYlMBZI38z1NmtPpj0c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G4OyYBD2jMh+xVu7nGq+EgaxoLtS/Pq9arUljjZsD9Ktk9CNJVaI/b2LfvJ6YWDjE
	 YxmhYtivQvJBkPHsDMSVDYMA+AF825N5IXmjD5mog3vCtbYqR2djqH7vYPssEuBWkg
	 ueVsgkCrA345zXgiUVBeLsatdtC1MY+Vi3rvcV2xleZzekcLbvDu3J3Ox1pmsGVmYQ
	 XgJlXO+OoYamJJMCanCrmQTbbYr7FAlMnb9yzpROJ0GOPFFtI6ghKVLWEzQjlafc9q
	 jkoT5s0KNxSHcz719WfTNhMFJbRc4L4q2jPjC6TQ56zBLbtR4C0Tt6NT/TfCxROy18
	 2BwLgTR37zVBQ==
Message-ID: <sashiko-outbox-225512@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/7] f2fs: use I_VERITY_BUILDING instead of private
 flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Cc: tytso@mit.edu
In-Reply-To: <20261120155032.187246-8-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-8-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 16:01:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Now that the VFS tracks an inode whose Merkle tree is under construction
> via I_VERITY_BUILDING and handles the concurrent-enable guard in the
> generic fs-verity enable path, drop the inode runtime flags that
> duplicated this state.
>=20
> Replace f2fs own helper f2fs_verity_in_progress() with
> fsverity_is_building(), and remove the and FI_VERITY_IN_PROGRESS flags.
> It's fine to remove IS_ENABLED() guard as fsverity_is_building() has
> stub.
>=20
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120155032.1872=
46-1-aalbersh@kernel.org?part=3D7

