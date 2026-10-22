Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639061;
	b=YHNB+iCtL4hUuh7EQM3ETwp84m3GUq8qJ+ezcYM1Fred/6Juv/UKuZ3pSqmmU0aZtjvB
	 tMjwuBGzQgaZjf60atkYxlXKwOrfiYsXB6rMcDXupt4urBQ0EBeVDtZW7JYkARXEPNS6j
	 5YexY8qRMmKpBGkkci0SJObf4djWAzKPiDSUMqTV1xDDMR1JWfeUSZKmtWv8eTM95f/3b
	 5JFrpqIJo78g4U68vKGgwKnlOaDbMAstsFcz9jjNHCrLPUqJbbfk1Y/yeEgQyJOjPpyeG
	 rgsxCrerOGy7xw/WeutvborxFEJrTqHeDYIr4ttBuSxV/mPIeG0gicQK0c7c2pdthQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639061;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nva9j/yhrs6FXyFhW84qh+oZMFwSOelAXT0d6jZSGg0=;
	b=da7C8OROPC3GscUPRzTImTbYruVmi1fofFhDa7YsNNG3+2nlZdeUrG304na4SvuBqKJi
	 XHxNz8UD8LE8xR2AFP8qfVWW/iG85uzEbDfncJdQUf9ZV9TahDn9AWcQ85QOsSdTy29mu
	 pJYx61XCEtupyMnDEXysSOQ25k3XGkeiYXraKJZBaejPaxC7DQK9iLyGWkSPzSjm07UtM
	 f3Xb2CBhcS2QHa77l3ncTtlCQAdrHrSvpjSq542sxfI8jiE2fetSlFMLO/8AaIWpKbFiN
	 ycrsx9Y9PKRM4wA5RQjZAzn4DU9sA4Vs24yY45CJrNC8dKn7PZow4sVDuCMfeivpzWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahovEhNf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB2960A4AE0;
	Thu, 22 Oct 2026 03:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahovEhNf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40CF1F000C3;
	Thu, 22 Oct 2026 03:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639061;
	bh=Nva9j/yhrs6FXyFhW84qh+oZMFwSOelAXT0d6jZSGg0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ahovEhNfsWXRGIEd/BiUqpt2PkeONR+HBm/kMgnXNf4qV65c1bwqJt9eQkPKKQeBS
	 +3enyf+V7vj81VItH2uiLe6gFzdUZHWqg8P6O6lYatieHizK1/nh/yUVl/psgMumuo
	 3bZLYUu302lq2Bwwmio9fI1hhZ4g1u7pTY+ImFHJoQbfehxnuBj8u9cU+dvfTnGxiQ
	 7wev2z+vp7q0FdD3BIOqB89DOoxOrEOHkTm9HVyzQZDQazVyfvCN8wLyvHxdr07v/O
	 7B1FWSGpwY7DqhHbqGC/uZJtMJTn3Wnn6jtKdyrpjkf5dVN6TS6ryD7hoKgHZSyQNc
	 Xyao9CVLT7DTw==
Message-ID: <sashiko-outbox-180917@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 16/41] ecryptfs: hash daemons by kuid_hash()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <b6c3e5df169940a45831966c180f27889958e1a7.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <b6c3e5df169940a45831966c180f27889958e1a7.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:40 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The daemon hash uses from_kuid(&init_user_ns, euid), which puts all UUID
> and GUID users into one bucket. Lookups compare the kuid, so this only
> costs time; use kuid_hash().
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D16

