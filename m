Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794340443;
	b=Mh/ifQko/Bxx1YC+ZW8aempnOP6f6lOrnHtudb6jTAbUv58udLRtgS0FzeJZ8TO2JA4A
	 UD0QVT2ALlOSaVBcZgUK8jmIweHH65TEMFSvwYgjtaNM4g2H5eVh2zBssjd5rh7RsAFF+
	 yr+rt9GipTetIEa+YxDDy0CUSI5V5qFVgKDlgbeOLClTXXQQGV8S+OCPQ7ol5OBQ5IX+O
	 z7Ch5MQAKECCgEEP5GIQfAFFNVbHp4ShV/zPzZpfrNGyATRxQS7K3sGbzAcW6Lyo6SuyO
	 bOsFBBplUc8XbcYAqWRtlVeE1PiglUnY/fooD8IojSL+vlhO7vWrcjqZy3eQF605e3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794340443;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=30VQJWJBqhD3B3TJipx0LMUDlyY0LBT69h7w7xVX8Hc=;
	b=YWfSvM+9TAu2oGpBF0rLeOGUC/Hw59X+AjKXP4K/LGBcKCVPOfcOdgUofrny75MJu9A3
	 H6fLMp17nbRC7z1e2Rm/JBSK1Gm5dcJYOZUiAAecFDI2wG3mdF3XEEnVUDrwRP6WaOoQD
	 LzxZ1COxafT1Ih6Csm64K0bmc6IZ4Fi4AHGXznq+Xkw07uIUqORrXDMTNswUkPI8Y0L+k
	 +NXbq2ZUNSj8tH5bzb80pp1cvqzYyx0jYj1V61m0en5ICzq8JPODLZmJphDmiRaOnF4u2
	 uC2LyQ2jU/oXlD+Mx65ZWhjI6n5kQJUv5OhEsU374Aofs2capE/3jM5rFvMj0ekHFdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hApm3iWe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6216E606A320
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hApm3iWe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D478F1F0089F;
	Tue, 10 Nov 2026 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794340443;
	bh=30VQJWJBqhD3B3TJipx0LMUDlyY0LBT69h7w7xVX8Hc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hApm3iWemrGG9YAqcQRXj8utHo0ybRvaN8u4lVFpWWWX0HhhFRE9jSsSP30zclFHQ
	 N6IfMPtOYHB8J09vN28vVi6QriLM25YVrOfvlpQ5dViBiLNjMFtgB8a6eAh2YQ5gEK
	 tMwyOxGKqi9z57Nhkr3nC/+hSU+JH0rhMvObCighgT5jSQZs8Tv0tlXI7gbv29FvkY
	 rr1niqRUyOhf1yiEo3lIaYHiECMBehInr326qmTsJwgwRfbYaShTYpUNMr2hI2PgJl
	 kjk7EqYh0x4ILVnVlSeOKbLyHLtGJojuV7BFTxpD1GSvTD6wNfOoKV2GCnSPVMMEvt
	 V7ZanKjhjrmBg==
Message-ID: <sashiko-outbox-207688@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 08/11] xfs: refuse writes to files racing with
 realtime inode flag changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-10-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-10-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:54:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Christoph Hellwig <hch@lst.de>
>=20
> Zoned writes need to reserve space before taking the iolock to avoid
> deadlocks with garbage collection.  But this means that the realtime inode
> flag which indicates if the file will be placed on the zoned realtime
> device or the main data device can be flipped after taking the reservation
> and before taking the write, or after deciding to go down the regular
> write path, both of which can't work.
>=20
> Re-sample the realtime flag just before the actual write, and refuse the
> write if the flag changed.  Do not retry the write using the now correct
> path, as switching the flag under a write is not a normal use case, and
> trying to flip between the zoned and regular path is an inherent life
> lock as it could be switched around again the next time this check is
> performed.
>=20
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D8

