Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792962102;
	b=Nil88y0bEFU3W3k48jJp2cwi4G8jAf5ek0oI0ZcAbM3O6EZ5QxRNi8J3u/8gEQM2GwzJ
	 uix8ngO/Xkg1zIbgv9tjfnZu45kbgAUAb/esojziIFxJXkoU0TEec8+A5tMFIqvvcxSte
	 +FHt1niENFqNIL1yZybDe/6rvEnCO2aJYFi/WldRAA+WSvvI2vHqh6Oz07+4ln50HXReE
	 hxhPTf1Yk+yA2q2By3tjVuedUjg02zNGbW71zMgg25OUhJXcTl7wM7okJolmdUbHHq3GW
	 Mguoi9we33pOSZXZyrIRIAYIPK2P3l2Npy2UXcn35XEYEMHtS1+rHV4oIJZ+L43J2ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792962102;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=26QWbUjMqqNMT5y9AzRoqp/yIHBGycrOPqYJCVFzZJk=;
	b=3ffxga3/KhBNRF7aqmHyJ1udDsuZp+gYKkK63RS28Tg0t4zRgwty0goQBFtO8l811J8j
	 djGFPPWCXqBh8XCvnOVqPXmKXEEEllyUezL2ZE1249sqt6986y2cUYR+j1yHBCdCy1V1V
	 IKsO45VD1UvV94s/WX4GrmoSY4vqrnABinGoLqwvLQ/uIYyFqAxjiZUc8Wy+aD5f7Eexq
	 h7yUyxMl4rFNAo0Z4mpTpv9DYHLaw4bbpiG7uJy0TIo7iHmippRrYUXT/JYfRwxu1IRt1
	 3yK8Qep/4RDkqVTF0ubbxcUut6PvsxtcJaZ6aSmeWM/tQLsk44ikxre2xqnhgvytlNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hjhwl8+j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A08606A31A
	for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 21:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hjhwl8+j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E063D1F01828;
	Sun, 25 Oct 2026 21:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792962102;
	bh=26QWbUjMqqNMT5y9AzRoqp/yIHBGycrOPqYJCVFzZJk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hjhwl8+jZACelGIA1Wu8EPyaIZdepSOQGjqVjjaeYHFQlfJcrlb5+tBB7vKpjZ4Ab
	 5Pr6TskzE+xQQSTX0Uy1Ns+uwE3N8vpVQmiLoXB2FMdjYV279p29ne9qB4cXQ5aADJ
	 lhysfgAyQcexDbZQ9SyOVwBpqM+e5rsQgSQl/yFEeOvwT6hHhfFWW/l98o/qGkmN3c
	 4ZAMmtsvqlE1ey0phh9OsVhTkWB+xYsyq2R6RLfTT8ezS1L/QUfGNeBekpU73B18ya
	 n7ltdTTrV0XBLDPGNKxKvX0NHAu1mouJJlkHgkm2+Jr42fAXBK+5qp2+cvMI04We/u
	 nI2+osYfm72oA==
Message-ID: <sashiko-outbox-184445@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] fsverity: Set S_VERITY only after rollback is no longer
 possible
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261025204807.122875-1-ebiggers@kernel.org>
References: <20261025204807.122875-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 21:01:41 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Commit f77f281b6118 ("fsverity: use a hashtable to find the
> fsverity_info") changed the implementation of FS_IOC_ENABLE_VERITY to
> make concurrent reads start going through fsverity verification slightly
> earlier than they did before.
>=20
> Instead of it happening when enable_verity() calls fsverity_set_info(),
> it now happens when ->end_enable_verity() sets S_VERITY.
>=20
> However, ext4 and btrfs can roll back verity after they set S_VERITY,
> causing a use-after-free.
>=20
> Fix that by making ext4 and btrfs set S_VERITY only after rollback is no
> longer possible.  On failure, don't roll back S_VERITY, but do roll back
> the filesystem-specific verity flag.
>=20
> Also update enable_verity() to handle any future instances of this bug
> more safely by warning and *not* freeing the fsverity_info.
>=20
> Finally, tweak some comments.  Clarify one, and move information from
> another to its proper place in the comment for ->end_enable_verity().
>=20
> Fixes: f77f281b6118 ("fsverity: use a hashtable to find the fsverity_info=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025204807.1228=
75-1-ebiggers@kernel.org?part=3D1

