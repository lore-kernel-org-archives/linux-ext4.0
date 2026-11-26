Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795697404;
	b=QlA3hHoXWcYa93B0W3KtcoKEd/MCWp7gsk4QOVwE4Um7GZ6UMeaztFRsNAemeb1XTAgZ
	 MUlt5LHwPiOoQE8jA8/2x/0TBLTYf9OXumK7kBqmtLc5E6lEdwCgncfGy3EOkDG8/pqpI
	 qzC0dCQieexuF19ufXSQZv0AND105/ORTi51wmqJRtFzELijr0/Vg7OKOcyABm8xL+fbG
	 Du87S8Tijw89EnNZzn+26G6EA1utVxfTrZIYAe+TRGWiAZ3MXFHA0rL1UE97LKlFYSLYH
	 IpqqSDbbFN4RuLD6DBZfkkDvrPELDNAHryoJUbzH+ZlDeldZfo5TLmQkxduG3N9lcAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795697404;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=R1LANeMjmRXusS2drmsO46ZS7YnVqG4P0cF156jZtBk=;
	b=AYzHfP/5F/FXhkZu4EJT4m2u9BS45J2jnTbvMGvwMRCc2fY4T/0Xb3nHyhAn8EtdvC3N
	 1/tL0HlrgI5S38HbjJ+G8pl1lNYdIHxPKEtRgG6eVVdjZBCfX07PAtpzNnghYmfMhHt9E
	 7RXCbTUjvxOe6rrHjDz6nfZOGCnk3lxoTvjfNrpaYq6enIdM1kDFhgnEh+T/IweV3uuie
	 Huo5AnL+4piNC3VgtRovIs2B2pi81ZYZhkNbSkH/EZmWO51tAugYThBoV15bWTo7JOdhh
	 lM+cgL9RYM/emB215W5i23jSDyay4u7aUrPdHDV51KpRfoYhOIDOFpbUPjwasIqyROg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDzciElK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD50606A326
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 12:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDzciElK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150A71F000D3;
	Thu, 26 Nov 2026 12:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795697404;
	bh=R1LANeMjmRXusS2drmsO46ZS7YnVqG4P0cF156jZtBk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iDzciElKkHY3xM4AbIoQ43MPNtiHbwycIUZGWlTrmi/Hjr0kmH3fnIFabxW5X7ECc
	 KTEVhqYZlL5VGHLIhw0Pb3WtWLwpTWHSfLF2mHNItiKxgscBCT7gVjDE08LLhz7G3T
	 gFusn8lzK6+LfEyxVyOfcAfrICO9AsAEVc0fYe52rFWUPuYOk9xYI6l2khK+I9As4w
	 NICabVtaSPSV9ViQoVSjp/3CzuIR0ef4ZRREaHRx3o47dsoGMuaR8kKqF5MlfFdIbg
	 BMnJzKUQ4Mq5TeqErnZpVL3hpnc8mOfk9LWTh+/JzEmp8cBDj5WYtgbuNVokEf8puc
	 qx+FglBYHLHFg==
Message-ID: <sashiko-outbox-235532@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 0/2] ext4: protect quota acquisition against
 filesystem freezing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Bin" <yebin@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261126123611.2517017-1-yebin@huaweicloud.com>
References: <20261126123611.2517017-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 12:50:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 2-patch series:

- Patch 1: no issues found.
- Patch 2 ("ext4: protect ext4_acquire_dquot against freezing"): 1
  potential issue (1 High)

A detailed review has been sent as a separate reply to patch 2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126123611.2517=
017-1-yebin@huaweicloud.com
