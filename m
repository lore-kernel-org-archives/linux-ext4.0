Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152968;
	b=NvYr4gBZOiDt1BuLKlBWTTZDfJrBJhuh6c8SKaSZ2nZ8IBF88TlewjumCXia1PEAHdCY
	 yurF+7o2+aT8PchFnGXyG9GQcoNs+AV3oWvMsMAg6xaG8yKl8U8hW91pVN5bMUIB87dIK
	 WqETO5p05LfHC/OKKw53eDBzNdMjxbE7szNaUI7wxTcS6OgsOn6hi3gm0qza51e6fdztn
	 JeZl2/Q7uedtM3aLuMLkebzixEd3g788AjpfYV461ujGMcfNZ0rLjuKLjta8+sTaBj9VV
	 /AC8KLauBP/6MrVwwVpAuwrMRd5imc8JM7yuYff7pfwqPxW2Ko86lASrcsi9CO+fgSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152968;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HGd4bMn/VElfBs1tOYs9s21q9RHJ0NzkbXZEu/09PUE=;
	b=i71GqN4OXoU2hpVZAxdw6zwLDX2/S7x0GLfaSmYmBwy+GdZ7n1/ZFYPiQOxDEjWX/8xf
	 LZPTTWZ8YOkx/P/Ii8oQQHOWzpdygjBXaRlBrX6Z9TtZ0yAwnP4/EQsEfsQfY6kmTSFeS
	 6rO44iD/Q79PqeXgDnoyebZIoY5XvSmVkkJuCyO4LmpVnTHJRfnyh5sjDwsPHtkjNP/a2
	 yd0EoSBRq7x/+4sgLpWZhKjVZ2plS5hN7jx4LHAx5G4RwYsZclTo0UePmgrXHBXpw5I2f
	 f/Nl5HLfHqgd1jmeU9M2EIgtbpUJRLuwB2g/T5CfRxYPJy4aRl7YNqs24CU5+gOkuMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XCrFJmzu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF65460A2601;
	Fri, 20 Nov 2026 05:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XCrFJmzu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5054F1F000C4;
	Fri, 20 Nov 2026 05:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152968;
	bh=HGd4bMn/VElfBs1tOYs9s21q9RHJ0NzkbXZEu/09PUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XCrFJmzuP1xVw5VBlIib/unw2wCAw8ZZtViDtSGL5MopUKkkgfKG7n3ijxl6rnOlW
	 EqQ7W6eit0/n3xiCDEMsyLx/3EZFvaEkog0xUp2HLPHEIArZXnVoDPl9RE+R2iuT5Q
	 5wviRdvFK0k9oXMzAZrVJ249lXcmInM9BeLUnU8VnoMjLVsWrmQJdyaGOyxIrVGURX
	 hlQkSjlnSe9yBRNl28Y06lS/UQaXweYIa13dSw7VyykSDoqF95IYum5pol0SXqT1gE
	 gwa40zQTr0eP7Kbm2xmhcMIEu9TTAfXy6TOEx7j6kO85RLPBGHtPVvZgvbsKRkUsUd
	 Hzsxo49/0s7ZA==
Message-ID: <sashiko-outbox-224495@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/12] docs: ioctl-number: update block entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-4-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-4-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:07 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Update the list of files where block ioctls are defined.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D3

