Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639071;
	b=AemwaFGf4CG6w6AuHZMP74X1fCSxwdJYF+CHqxbMTLMuSoh4spwZhA+D1fCSyInWU3GR
	 RseMxRms12Rb06ChHW8stzruME133dHp+oBKrq11jZJY6NupT6uo9D26UzGT53SLqsGUm
	 nY4Gqg2V5Yvg+8RKHsqm5HyPhNguB4X3PvzDDbQcNmxRV7Xtd5kZISUTn801WQXjcZPBi
	 5Ekjha+agWlcyemjRxp1lu/KDBGvCSVbDC3SNe4J+wFbmZklpAqK5y6Yfcq00not7E+sH
	 WluEgIMjfeF7OlEj1zjLs6MeI3FAZn6bu+XS0BjULIAHZRhfbjnvLNdHFjK9Gz0XayA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639071;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zMmV539AIrKoXTHGuQ8G1bgElAnpiNqwldARqBOwKXI=;
	b=jczelnGZjgDHlaYmcHYBHG5I1lo+chftHl2AyYTQJ0JFOYpq1zUwMxk+M57k89dPBdXV
	 dK3YkE4PlYGR9DHk2J1p88TfK5IjGYDS8urfyQoc9ykf764AdKGwiG4xj+FoSXUXpzQHV
	 IT0ol14QkuZkrW3C7CHZq3Da2luWfiNU804sT8YkMnEH71MYeSEH7xltBaZ76vC3MIxr/
	 8HOOCvexn8tWbPAWiuBEZK1xbZ9fFovWOI1jrtCJpc42FcyIG2jtEJdzrC/GhOyvsXBrS
	 VJ+rEpKPn1X4g4nySrgoo/FJ69K3kq0sGdVTB/HHOMZvf49wFuZ+YAYOenl0e1YQMvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Iej/rFbf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D2D60A6F48;
	Thu, 22 Oct 2026 03:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iej/rFbf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8A41F000D0;
	Thu, 22 Oct 2026 03:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639071;
	bh=zMmV539AIrKoXTHGuQ8G1bgElAnpiNqwldARqBOwKXI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Iej/rFbf7Xs9lOtb8hyGgfETNINz7kMN6gC4vYfU9Rx1+1LWzq31C6HRArWMa/SPO
	 Kgm+O+kDSYV3DELGF2/hgrgL4xW3gsotjqMe+HLrOIbUV4J2TVq0OdQ8Txx+Ekfsbo
	 blceH5ML3mQI2X25Zv6ULJbDOu/2CFz7MauZLTEf2m4zWs/bzvEH2t2EtCyQ/u2G2U
	 pEpq+dFZNgriFc9vREIXeWNzYVwV33Y6AXUnftErPVVDUWJ1XIQgwNHH+mbFvUd/M7
	 TsUOBwvrbteix4lZn5S5bADmfm3sLyVtAIOytWP4+9/udvCN190vYlo3X7lwEiIq1q
	 Vqm0sN9r8Wjug==
Message-ID: <sashiko-outbox-180926@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 25/41] uidgid: parse and print ids in their text
 form
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, tytso@mit.edu
In-Reply-To: <1151adfbb3aeae57cb26df8723287857f8d0af57.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <1151adfbb3aeae57cb26df8723287857f8d0af57.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:50 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add helpers for interfaces that pass ids as text:
>=20
> - make_kuid_str()/make_kgid_str() parse what kuid_str() writes: a
>   decimal number, a UUID, or a GUID in braces,
> - kuid_str_munged()/kgid_str_munged() write an id as seen from a user
>   namespace, the overflow id if it has no mapping there,
> - kuid_str_signed()/kgid_str_signed() write a legacy id as a signed
>   number, for output that used "%d",
> - KUID_STR() and friends wrap them as expressions with a buffer of the
>   enclosing block, so that printf-like calls can replace
>   "%u", from_kuid(&init_user_ns, uid) by "%s", KUID_STR(uid) and print
>   legacy ids exactly as before.
>=20
> Assisted-by: Claude:claude-opus-5-5
>=20
> Signed-off-by: Jan Koester <jan.koester@tuxist.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D25

