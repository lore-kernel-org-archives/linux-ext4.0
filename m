Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795187122;
	b=VTPK8+TG0Oylws5Yev6G6+GB3shhNOgrhx4Hv9Y3FmSZGZmAJMzbdFJDS83Ib0IKH/K+
	 l62dBZ+H5ccyrq4jI42QaWGNJQgIh/T7bjS+3KbIAmyN1DDE5IaFPx3WCCtak7W9A0o0S
	 HIpNWwxeGDT+TRl+a9O/p9urMa7zeQ3qLuMtLF0rBXABhfeN3hFLA0KTVHLI0HF5N9shv
	 mUqHv3eT0RV74O4wuA8EkYlOxPXSXSruNC6n0J/CgzxeoaArDo4tCpiOyRFY5wQADrILD
	 Qhls5G20PUpiojqeqE4xlS79jWQ09lgCXPlI972qKWD5vUMWoP/e77iEg8xH46hiOxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795187122;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QiyzV/iuSq7hVzVS1rhzY1tUD+8i8/Bv81x/UFCPusE=;
	b=icGXcmWPC5j1lw4Iu1y+OTQvOVUPGcPtPDIfkR9odvZoSeeL9T+C8CFrDbcDah+kXjps
	 fvPKJFYBbUXVNBBhe0hoWMqXKln3HndAkckFWq0XHn8bVJysLwmId43RR4GiY2s12qxhw
	 kSwhe9264zNUBUzcLFbW0leGSxBiUqplrSZG3hHbZ7wyK/R4a4Cda6Cdp8Z/aipYMiFg5
	 bxlDQI1Yzt/qO3bUDrrw0OzKRdKHIXI627MY8HxlCg2BPOMrkajK7pBy3HgXB8497DrtS
	 dHU4DK/Nukp7DtfdvJsGq8pqpJSMYbHAyL/17dHdktpiqOAL4HqwLy0u4aO6uzsWlhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="NumW3/5W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38E2606A326
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NumW3/5W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452381F000C4;
	Fri, 20 Nov 2026 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795187122;
	bh=QiyzV/iuSq7hVzVS1rhzY1tUD+8i8/Bv81x/UFCPusE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NumW3/5WC4P7MujR8R5zHI8g32bOsKrTxkY004GMVL3Yx72NNXaSD6Na0hj5aT0Hj
	 Uqi7bFPUcxEZ4CoohjVqPnP9NQf9TxW/kLzFgSANCvpOLQtf2r/hxJuIwmM4NlVB7H
	 epbKh3Lvo7xo97d9pKfjUn6LhIcNs/1oX2CTdgLfmMHaJuBq4y7Emzra+IjHhye9FD
	 3V2G6ssBHikW2CrjcKf59oPALq6qabRdSlBdOctbp0xn2cBt/P6h9OQHucjc9FKBJI
	 s/+6wb8+0cP9378PUp69L5v+IGVnIWScYAdt1Fj3zNvCAsIo/z+LIokHPNj9KnqPbo
	 vGutpSMDXqjrg==
Message-ID: <sashiko-outbox-225425@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: fix wrong unit of ratelimit_interval_ms sysfs
 attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sang-Heon Jeon" <ekffu200098@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261120145923.1143594-1-ekffu200098@gmail.com>
References: <20261120145923.1143594-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:05:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The interval of ratelimit_state is in jiffies. But the
> ratelimit_interval_ms sysfs attributes are read and written without
> converting the interval, so the values are in milliseconds only if HZ
> is 1000.
>=20
> If HZ is 250, the default interval of 5 seconds is read as 1250, and
> writing 5000 sets the interval to 20 seconds.
>=20
> So use jiffies_to_msecs() and msecs_to_jiffies() when reading and
> writing. Also reject values which are too large for the interval.
>=20
> Fixes: efbed4dc5857 ("ext4: add ratelimiting to ext4 messages")
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120145923.1143=
594-1-ekffu200098@gmail.com?part=3D1

