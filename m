Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639084;
	b=FZIEVwqUwYtAHRsKAtRSdJcbv6LX36xE+ac96DhbIP95Qfd7992w5iDdEaJi9YLKQsI/
	 MwSvb3RsumSdsQQ/bjJTddTJjJRO+4Z2Qj7k7+ge9gHnY/txxpf627J2G0wk5lzQbz2YG
	 v/3tTmX8PZewsHFJyklUs2FZm3RPIjX1gkHm8ao+RecI/XojEAORx/eFZoNC+feBLRASM
	 JGOCXg7pZDKiTY/dD+HcTsyXmMKi1D/7AhJT3zoj0McDpGqlO7x/Grpk+k+foR4vU3BKr
	 kVwrnLsUQ4bJkNcY1ngmTdYhJjpqcTtTbQtCX+h/gcKak40MEYwzGZ0pksAgcYEqtdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639084;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=V3tRdNbtv0bh9+G1E4paQBtcqd62eB7Ydr2gb37F8nE=;
	b=PgyFztp0bUHd2zhabLrjTNvgEmyRko3I0PKwXnC1WPUNUAZNu8D4EfQibdpHxMEQeZjU
	 z6QdluOu6qyTv9RPvYQ6D3Bj5O5kywW210bCJApYdLK5iYPBynrEQqE2lwg+LiGXeuiXr
	 ko7TkFXvIhxCEDaevesPUBY8zfq7TDLwQ+Bcf2LEvL3hmIiKxC7gAJKXLDxnlme8+B7MX
	 zJMfhW0z9MLwrquo94uD0PgYOZrjLnMy7OvPI1tcQLsmwqtzZJjCUc8yIkHjBHyjQnTq6
	 sU5BUgHzc9PHHej/bh2i2WK9WpS7LnSn/F7Oz/dKHr89XY13A8uvCt3d9cWiuIPoCwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nj76DYjk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A8F606A335;
	Thu, 22 Oct 2026 03:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nj76DYjk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268001F000C2;
	Thu, 22 Oct 2026 03:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639084;
	bh=V3tRdNbtv0bh9+G1E4paQBtcqd62eB7Ydr2gb37F8nE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nj76DYjkTC6bO8Ty5cehBhhkWlFCeKv4HYU1psz4A+1c6m7pSwqh4ml4Kygyl50uW
	 LlEiW3O214glvgV/67mrhF4B62U0truaCQgSQWdON1ATcWTTdDwnxQEXT22StPIDOf
	 VFfAPmA0e5UEsB773JA4ghytn9UJd/Ce9lGZB4vj/b6rw84lZy7bq6zQ2h2fj24IZb
	 KX/zmaEgQPODM7RKJCi+7PyO//+yWX4EbM2ZSfWJ2pJGsm7nKyOz7lfu6C7sePQM6T
	 FZxUB1SoVNxw3lkdha+DWVckHW+tsW/eTtpYLa+c3WzPEIHu25sEq0eXeWj/zbBAPF
	 RBD/bKJrT/hIw==
Message-ID: <sashiko-outbox-180936@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 35/41] Documentation: describe UUID and GUID user
 and group ids
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <d93b11e2c7d4e82e0076dddf812cc5137bc34771.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <d93b11e2c7d4e82e0076dddf812cc5137bc34771.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Describe __kernel_uid_r_t, the rules for UUID and GUID ids (overflow
> ids in classic interfaces, the initial user namespace only, filesystems
> with SB_I_UID_R), the *_r system calls, the extended interfaces (statx,
> socket credentials, siginfo, SysV IPC, keyctl, POSIX ACLs, procfs,
> audit) and the current limitations.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D35

