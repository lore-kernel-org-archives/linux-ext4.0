Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639050;
	b=VeQaX017VZpE7T450um4o9pVVdRa1jOGi9IgjHeiWSHGgHU8JRbTFEDuunc+kCDdJFnr
	 5NGpKcGPNGkJ4Vs32rjIDDYSnSgA9xjtI+vnAVGkKGLxfy0dtTDwxvYyY/CoGj9Nb8c0V
	 3GHnw7yXi/cilRRhjyPVHX5YFi8rT/boeOBEWGyhlBRVyJInqlC6L1fmhNeZoYajd1ZZO
	 FY82UAGh/cXozMUNWJrEl0OpLsjj9hboMXFhxQKEEX8Ss4x+zskxHd+myldKAJ3qtxQIa
	 EVMhaXp8OZjAAX4YklDxKlQBW9iiDj4SFfyM7hpVFiPcQbl969Ctj10jx4jxW09r3lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639050;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eH2jLfWicMmvDBYEDOSmDOGtMY+TS1LzuxKd1LGPhHA=;
	b=vjWMhrAoVzVCJ/kJvHKzdALgOTIX2uqS4PedP5a/IKA49bIG/UD1OdRe4S4Ta4VTN1Oc
	 7a62m6wmzHtPM1wC3NdcZuC0m+Aa8DwXwaVZxJNgQyla+FRFEXxrDDJsuj39r6kAb0mzV
	 BObwKRTeGG7eUr51zETpoiO/9WvXep1apu3HaIXshXGYsAYVNzDYGCnse5YmUbt9r0sil
	 ZqphUWEQd8qA6GDZnUdQHaO4XCzhnGqH2eqxSwfyEWFB+RHDiqxIXp4uCA4jHFiRiSsxH
	 ID4ePWgFZwZ6DwWrcQpk6RL9gyZ31zpNZqZcfpEtt1HAzERT0XQ9h0x9tc3HOp52vQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GIONzmLU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40856606A32E;
	Thu, 22 Oct 2026 03:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GIONzmLU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28F31F000C5;
	Thu, 22 Oct 2026 03:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639050;
	bh=eH2jLfWicMmvDBYEDOSmDOGtMY+TS1LzuxKd1LGPhHA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GIONzmLUms9o42RqBSjzfO/f26o4fsneC/ZE7AJMSThxXPYmvC5Zv3mvPt/h0ijDc
	 9N0RQCe6xDFc3F+rJu1rYMBtQgUokSsUFPSlvG60LvwsNRsOpe8Qen0/dZh/kZ83QL
	 WwTEGtXePb8OUUeWqqig3Wen1xVnlR8ZRVBMxKJhq35DiNNyJDPY1Sxq9JvrLqVyDD
	 EZhGegi0sTrA5GA++TN5m0u/HbaRqg+zegnVFRSZ7OmyiWNO8g4RXLM8G90tDuT4gK
	 LphqwUMMuOK0TdP8o1QGd8e2yf4N9IdJLwkc0QL36pUv4bwcSR1Z4UAm0cAnSDzmqt
	 JIiAZ/zEpTkcw==
Message-ID: <sashiko-outbox-180907@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 06/41] netlink: keep classic sender ids in
 skb->cb
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <6cce823256f7f88ad17a2d16aa4020b1bb228dba.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <6cce823256f7f88ad17a2d16aa4020b1bb228dba.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> netlink_skb_parms has to fit into skb->cb, and netlink skbs are cloned
> together with it for broadcasts, so there is neither room for kuid_t
> and kgid_t holding UUIDs nor a single owner for an allocation.
>=20
> Store the sender ids as classic kernel ids: a UUID or GUID becomes -1,
> which reaches the receiver of SCM_CREDENTIALS as the overflow id. The
> kernel's own permission checks on netlink messages use the socket's
> file credentials, not these.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D6

