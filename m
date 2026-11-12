Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521805;
	b=IcnKcPq7rKBLGIKEHDONS0PHXJIkM9HE47AJtXeNOlGZ9LJ6x+pgXkhuaKU7v0rM/DDT
	 MsfCqDHR0luzX+ANbq/QQMUTBKMp5/+smJaoKQvAVtiJR54oa3vbHB6D/s/+hRwv/+MQZ
	 m5q10nbtgnsxNi6PQswjae7zricwAVmyk621giNS0EOiIxueSqq87gjJycJwXK2gQ5ZZQ
	 Mf3lspn9tTeOin8BeAfXif+Q1CP9SWiG33ZKP6/Hai/dalh7GH0W362VQsOUfJpdw7sIT
	 WcUP101b7oK9436Ev6cCMEgDuEv784esuPwf/kVgzbzEzGkksEb2VGDaL6docYdaQ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521805;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XliIdf2cpXuJ8ThgYxuvS4J9xJrJ+aZM6TKlnc/C+9s=;
	b=HvUqynWqYyb+2+xKg4jom0omKRXJCb+nFqXG3Z6f2rROJdhaOLNlWQIJJPBwZ3OKJw/B
	 GfI91V9ZuBOdwjJplmbmeNB47BXp1DBePPrzviZ9+MXpX7HM5k97/gKEW1TDiPsu6Ys76
	 AhtcSp1Hu2aLXkrBKTBr5FGZ0ii3SenD/BF1vwgOCkrmk9bRfizihlKASgEQZKx7CIB6R
	 /v7GrvO44ScjI+BA2WRWTRyhlfFBVFQ3u9/rk/r8Uo0qDfOcm58UHJt3oKCX7SiQt8Rdv
	 MZEUn3hBb59xY2Ei5m+r0O4p0iiuZghc9IqN2/7VIOb7BBW2CTlk+bzZTeHmqGk2TOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hBegKXXH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE1F606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hBegKXXH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CDD1F000C4;
	Thu, 12 Nov 2026 22:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521805;
	bh=XliIdf2cpXuJ8ThgYxuvS4J9xJrJ+aZM6TKlnc/C+9s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hBegKXXHP05XJ2ebr6TKnqCP8MN2PYy6VZXVBFxrvsTTlsqaNCYdpTrQvXNxQHIfD
	 5VfYCXXLcvDSUaPEPcn/QdC957mpQ+2E/7CLJZk0pyjjyz8rh34FjjvNN8YOl6y+zH
	 PMxyMQLt7zR5LAmP0B8ro+wcm9H7LQFW8ynFh5QxWMaIVImQpv4vGEW7DC8VxbI5l5
	 qjtDicsiUk3+neYt8YOx0FArWDBQfRKwd4m14AHWBkAtmDwRRxZAkjVhXGth98Kk+j
	 2O4gh5NEgYPDzfQmRd2Ro78jVHeZyDJnOiBOQqS+89RXyKyGaV3uQoWZQQ4xerm91q
	 sbjVCo9pwXB8w==
Message-ID: <sashiko-outbox-211896@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 05/14] fs: validate atomic writes after O_APPEND and
 limits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-6-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-6-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:16:44 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> aligned.
>=20
> XFS and ext4 call generic_atomic_write_valid() on the range that the
> caller passed. But generic_write_checks() changes the range later:
> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> then fill only a part of a new block, and still map the whole block into
> the file:
>=20
>     block size 4096, i_size 512, O_APPEND
>     validated:        0 to 4095
>     written:          512 to 4607
>     new blocks:       0 to 8191
>     stale below EOF:  0 to 511
>=20
> The fix used here is to validate an atomic write in
> generic_write_checks(), after its range is final, and to refuse one that
> was cut. XFS no longer picks the path of an atomic write by the
> alignment of the range that the caller passed.
>=20
> Fixes: f096207d3276 ("xfs: Validate atomic writes")
> Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter=
")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D5

