Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682246;
	b=gVW4sLK3t7jTsPaBi4C18ZqxZ+yw4sNIRs/QEyo8vupH7FEqimz2JuShOKigsEYhtpRH
	 naBD6S74P0CgmE7+5VG9euDia1RHIKcU83DeYSTBbRQRmQjPXCQikJYspbUmES1/MBrXe
	 wuds+5Ofca8enCsO6EcDnVqh9YebXWARyloqZmdYiLuNKm7IJTtGY1Vh/iBwfXn6uqeqP
	 aql+MBGRnaCQSpxcGx7SZo5GQBuf4NYniX1q4FTW/istbK0ezvT5m8roc8wsMdusCwHZy
	 eKeKEqGR5WYNGAtj01/7Lfixs7EH0ATUAMpLxQci3choxOKLfTR4KCJAuFzlWkySCXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682246;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kGlYv24yAQVxL1b+BmzlslwfOhi3G/GiYhN6ir4IiaQ=;
	b=NOqzUcq8eF3eLbs6OjTHmFIicMHhtpY6IaQuC/e/SzCe+33woKa0Dy0dod0eRAVZilkX
	 psUAmPiGqYU9qO1cuQ0PPnC51XTdd6W9WkiMuNUmKU6dEzvywyCJ03tY3J9ajHrNEr3iY
	 bCr0HpKmfqVSR+wuwEPwHYv0v9h/isXmzt+6qA86iokvsNwrG9czO6Na006O3h2uHnLTh
	 IxHil2y+SDFs92TCSoYxvI7PYRyNbCG827Sd8qM8wu8b1uH+2BkMOTCizhem1Pz37hurg
	 +JV8pXILCkkBthlSl6tpnQGxy6biHiVhPGxMAp5YABYuJHAVLexgGtxZz7s8RdoGTmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nbtzOg+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C08606BE72
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nbtzOg+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C77B1F01825;
	Thu, 22 Oct 2026 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682245;
	bh=kGlYv24yAQVxL1b+BmzlslwfOhi3G/GiYhN6ir4IiaQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nbtzOg+L8SV+O+aG0o9/DnQF7jRsC0YAdIPbMYjWWgAVJZavTAE8HA9p1FHwVAGcp
	 V6wchQhDvABqBoJzjzBQapjx3PV6d9bzlbltHUiL+NKPo2ArX5Ec+xt/piDp6x3G33
	 VDGiMgwM41fZghkbkjl0Sh1KpSCfCLMDkwePsFhUcZBc8hgIRGFiiSb6xMqCDoOqvi
	 u8mwUjJd6oN7hvrU7TqKLHYMvCwu0jOrqhwWlZro3OU9qQuYhIkM0K87eOKwSvdhtY
	 vATUqTS3xxuQMLg7uToK+8lJWHeb3HQwQQGCdPrtuHb6q3APhzn1V9QK9rhVI7FCl0
	 dgHUHeFvjD/lQ==
Message-ID: <sashiko-outbox-181686@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/6] ext4: use atomic bitops for io_end flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261022151239.2981745-2-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
 <20261022151239.2981745-1-sunjunchao@bytedance.com>
 <20261022151239.2981745-2-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:17:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Before EXT4_IO_END_FAILED was added, the writeback thread set
> EXT4_IO_END_UNWRITTEN and final completion cleared it after the last
> io_end reference was dropped. Adding EXT4_IO_END_FAILED introduced a
> concurrent writer in failed-bio completion. Successful bio completions
> do not update the flags.
>=20
> An io_end can cover already-mapped folios submitted before a later
> unwritten extent is mapped. An earlier bio can fail while writeback
> first sets UNWRITTEN. The non-atomic updates can then lose a bit:
>=20
>   Bio completion                  Writeback thread
>   --------------                  ----------------
>   read flag =3D 0
>                                   attach reserved handle to io_end
>                                   flag |=3D UNWRITTEN
> [ ... ]
> Use atomic bit operations to fix the race.
>=20
> Fixes: e856f93e0fb2 ("ext4: do not convert the unwritten extents if data =
writeback fails")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022145241.2950=
379-1-sunjunchao@bytedance.com?part=3D6

