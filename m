Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795152964;
	b=iur2+o7vNjAeougXiBkPakiylHrDs3lf1jOlWQwCjIdLjeVRQCOiUtWv9w+mYjcD+tEc
	 MClrOr045/gdCm8TdaX7zOHCPRxH6NXs4UxqlFnGKFY0YNPeHPtJ2oW/6qwAw6VvGbqRB
	 OutPfhkGGazQb0UcAW3Mw51FxSP5deaKzieKIWSojDRZG2f8L5/EmD7txIW0vfH6Kqkl3
	 BO3cX7dNpSx+92kV3JyD+/K3FeRCyOhXPzjkxaT3C0pE9wRbZPnpYSABmjI358Tp5ZCLk
	 B/Hlo9f+Qs6z/M+OHHRYex9Ra91gH/T+WAo6SLlt7e5v5DMV6wuXg8TXR44OiNX5jYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795152964;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3XH/xjB7vfdlhqB6PzHuvJtW06NVxgUusEM9Sc2luZI=;
	b=f2HZ2W971LrGGNfi9HdXdK2fb+8ym/Qzi6+B+BCR5TBW7g8whz9e7wQqjKpdRKnX4iio
	 85Gr1tJU2x/+C0XEf9jlOJ64N1iRO8oqU9MpNbGslr6gP/nZ90ju5humsP4Hbdb9Vyxka
	 A1TZHZornVVtoDgjzx5Q9ABXBcFs2tYf3+xDVmrZopG+wFgP8hlsm+vLHdXnPZseg15ER
	 S/8Evr+D/FSTU8cfc8apNjSlfL9tXz5wtcs7bPUfsGkCbHexO+5N/LxHiFyRf8EKpUmhZ
	 T8HyW3/V6oDme3T6RGz2KPvDyCGL/NzrH88HMw8Y56vcK2aq/nQG8DAZbmXSzjVY37g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hdKrVvn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8787606A320;
	Fri, 20 Nov 2026 05:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hdKrVvn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB64B1F000C6;
	Fri, 20 Nov 2026 05:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795152964;
	bh=3XH/xjB7vfdlhqB6PzHuvJtW06NVxgUusEM9Sc2luZI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hdKrVvn9nGeYjmI768GNAHXoy6QAyv+JM11RCdBSFjQwa4ZndJf6jDgKR1M+mAsxo
	 aNK7zneUhT8BKRhJJwFJmSiDQO603o31GPlc7zABDl6dRrdUesiNAUL+OMiFx9qkHc
	 VCSOmfQLSf3N6i64CW2JKNBwylaB5zYFQwQgx5dJpDT4fD1N9uz+batOndIux0M0bl
	 gGYNR0WKJt4pC3whsYS0wiHYFPkECOY3SDe8OW4Rr+B5+m807KOaxSooTutvbIDpmM
	 ahNXuNe5cTso+GQnu2lZ+TeYu23OIPDRtIgg2ZZz6XBzE/6wRo9Mlmu1EItX9SpbPR
	 KJxPyQLmo80WA==
Message-ID: <sashiko-outbox-224493@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/12] docs: ioctl-number: update MM entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, virtualization@lists.linux.dev, linux-ext4@vger.kernel.org, tytso@mit.edu, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20261119053514.255348-2-rdunlap@infradead.org>
References: <20261119053514.255348-1-rdunlap@infradead.org>
 <20261119053514.255348-2-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 05:36:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add ioctl number entries for test_hmm_uapi and gup_test.
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119053514.2553=
48-1-rdunlap@infradead.org?part=3D1

