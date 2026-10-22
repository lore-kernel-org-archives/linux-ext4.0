Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639045;
	b=s7uwTLvRgEmXolD9kJwH6qtnXCcotAV6qCkQMcTto/yETRKAruDFkiTXGAH8G3jRz5eF
	 5Ligy5UCzDe5ICIj+cqDGvUK1RRhJnlGjBvW8rEMNY7VADJO9xCfaqWWT9sQVZcZQ4PPp
	 waDvmpfeCtywcfff8xYV5R1BBKLqxz3iOYAteyJERh1L0S9GEA3P5OCVYcyO+rEm5zJmo
	 tf01Lq6s4mekm5bIC+67gAfrLmaDVCWwrXOvOMk6NUUFpHcLo9lYaYRevq37c2IGvWYyn
	 QrQwwQW8m5AAX0Btesbj3d6K+IlIWTIWgLQJIBvnD4jVz25hVsBMvSubhSqIOW7Pk+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639045;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bx6QWKD/euDZMtEpRXog2V0i+1UhpJag8Fg+fUT4ibM=;
	b=forHQKFBgDxmtbg4xaE4gvAginfAG/kkoe1nx6H4eUq7j/YWNzQgyBQSCYPaQyGMGS9H
	 ZuRAS6fazk28PVD+wccFkPs+wJkBBY3TdoIgfyrMx8Ee71g/RTZ6kdHzJvnr3BrKGNoaa
	 X6eX/suk06qYF33iLMHVq52RvV0p26/r/XdV6DKYP/fW1Pq/mBRyNr2vwxtOF2owNGfP6
	 s/U8FEFsAk/DB5H7PdEY100YisK697bYiirDLYDJd3Sy9VlmSPYkHnb2UZiM/2eRfqXKn
	 g6g4ZYWfPLEiFIj1tCUS7hgKSHJji6zfRckjS4Qjhfl/TJQ6Hemf3SDmebEFPQaa0Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4ywl8Mg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B550606A326;
	Thu, 22 Oct 2026 03:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V4ywl8Mg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB68E1F000C2;
	Thu, 22 Oct 2026 03:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639045;
	bh=bx6QWKD/euDZMtEpRXog2V0i+1UhpJag8Fg+fUT4ibM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V4ywl8Mg+wiP5ipROrQ8folI+kEWeg6B+xVxWQzHV65jEjhgyPAl60MiLs7KOJsZh
	 fIuqSUNKavq20EuIwPXo4uZjfVqv5atW21CfsFVEHXSKm+SF8OkuTY07V1osaK1Ugc
	 9CihL1Y1478d9ZOCFY6BbdzeBYL+rULyQEaAAOYTBaaD+mWnwv5u9eKCQpV2P5MUeq
	 ROrBztPzEcr+2gN6pqhhNEcuP/25zuQni6r/gP7uJPTuLlPx5yCNcRYj4USbBDloK/
	 SrSZri5/KmLfWpiRPAXepOzHRQK9yk+gHkrOSD+d/Xd44eAYoeiEjx12x7cAOBa8/f
	 KQAyZu8n0M7Kg==
Message-ID: <sashiko-outbox-180903@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 02/41] uapi: add <linux/uidgid_r.h> for 128 bit
 capable user and group ids
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <423713b22f1cfa384f3df8cddc91e81d35c52d8a.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <423713b22f1cfa384f3df8cddc91e81d35c52d8a.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> User and group ids are 32 bit numbers. Identities that come from
> elsewhere -- UUIDs handed out by a directory service, or the GUIDs of a
> Windows domain -- have to be squeezed into that range through mapping
> tables kept in userspace, and the kernel never sees who a process really
> is.
>=20
> Add a tagged id for a new family of system calls (named after the
> classic ones with an _r suffix): a classic 32 bit id, an RFC 9562
> version 4 UUID, or a Microsoft GUID in the byte order Windows stores it
> in. Type 0 is "no id", so a zero-initialized id is never root, and lets
> the set*id_r() calls express "unchanged" without a magic number.
>=20
> The struct has no 64 bit members and the same layout on all ABIs, so
> none of the new calls needs a compat entry point.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D2

