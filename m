Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714288;
	b=I+5kwFwKm7HJ2mQSnPjtmYg+OrU9pFEUobyN3O/8IMITmEMSkfFCCozQH7wQEWXQVcNh
	 C9cV29thbda7sLU1VfMKVU8r2eG8fb50WzMZG1saz6osWMfvP4M1zq072nSXThZ4elo+s
	 WYHGpbh0+/uDNkr6PI9YTl7zgRKvEfps+vTy09p7YIgVYYJU4Xyk1xKR4FwKQUXUqmyc7
	 fII2cDfEZZ7fI6l5EHtIhaF0nspc8j6U1f8Uq807BwL5djUDKOc6PSNv60mYpu86b+RiI
	 G5NwDeQFMyHF+qp0IBgrjwXBtQ/yxPcRmv0vK2N6mpcgq6PtNcbfb6xJj73HEmOT9aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714288;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ls5O2DT7dFmXSZwNv357xq6uFTSprLSYEt4JDtPCaCw=;
	b=ely95fj/y/NBv1sctjFXJDGf0OkETMz7M0mhw04KtdB+QpC5oP0t5Z6wLuAh2z40XbVW
	 FW/OcqwbmowdwZQB4tfFLIXggvaf7615cOCCRJbTD6DobUxUBEeSzbcSV+KFlsrYFnsAr
	 jvUUlAKDnIL/nytLHDzClUbLw1W5DEQD6gIptQQ7hC7EmIoZKuJD8bcCYZbk4uV1dO3k3
	 T59DhNoxvC6J/YRjFM704dpZs5uQXZvGHvaGgSTWMWENfaQNonQTuqPR9l2Tt/An7lKKh
	 KCQ8KO92AbG146llu/D4l9tI+8jEhnYRX+eMNb+0aK1dY8vss8a0wz88bFTW7ZFv1Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oPdmh4QV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B87606A324
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oPdmh4QV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3752F1F000C1;
	Tue,  3 Nov 2026 13:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714287;
	bh=ls5O2DT7dFmXSZwNv357xq6uFTSprLSYEt4JDtPCaCw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oPdmh4QVGia6OfFzfL7VzQczGQ5vcrKay9dD8itXviBJs5iRucYTb4XX1CB8FRTtu
	 p2NQdnz9wnaArb6l9mYcZmyVKQWW9DmA3zPmw54L2kBDnGZdkJ0omcS2CEKPjhDnrq
	 6pAvyQwga8gf3QzZ+mHidGslxou3jPWI9jlyzt52QEfLvs9TwgVJU8E1swGKv/KnYG
	 RDkSFMX3qEfXbmYRkpGWR0mrG+16Ite6neGN76GF/r5wwtW/QJm7oh4SDQWklzghLs
	 08+pmTqkgqgEMxURUi9ipbLe9SsLiBELlY0ZHj/fhJXj57WJxZz033rkskl1mdRW5a
	 wQQMDLE91wQ1Q==
Message-ID: <sashiko-outbox-195407@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 04/12] ext4: add ext4_dir_entry_is_tail()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-5-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-5-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:58:06 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] ext4: unrelated error message changes in ext4_dx_csum_verify() and =
_set()
--

commit b38526265cad346b429002b55eb969cb4c97bc1c
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: add ext4_dir_entry_is_tail()

This commit adds the ext4_dir_entry_is_tail() helper and replaces the
open-coded check in get_dirent_tail() with a call to it.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index dc8035707feb6..6e934e2732fe9 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -478,7 +474,8 @@ static int ext4_dx_csum_verify(struct inode *inode,
>  		return 0;
>  	}
>  	if (count > limit) {
> -		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
> +		EXT4_ERROR_INODE(inode, "dir seems corrupt (%i > %i)? "
> +				 "Run e2fsck -D.", count, limit);
>  		return 0;
>  	}
>  	t =3D (struct dx_tail *)(((struct dx_entry *)c) + limit);
> @@ -511,7 +508,8 @@ static void ext4_dx_csum_set(struct inode *inode, str=
uct ext4_dir_entry_2 *diren
>  		return;
>  	}
>  	if (count > limit) {
> -		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
> +		EXT4_ERROR_INODE(inode, "dir seems corrupt (%i > %i)? "
> +				 " Run e2fsck -D.", count, limit);
>  		return;
>  	}

[Severity: Low]
This isn't a bug, but were these error message updates in
ext4_dx_csum_verify() and ext4_dx_csum_set() meant to be folded into
commit 70f1e1d58c97 ("ext4: validate count against limit in
ext4_dx_csum_verify/_set") instead of included in this patch without mention
in the commit message?

Also, the continuation line in ext4_dx_csum_set() has an extra leading space
compared to ext4_dx_csum_verify(), resulting in two spaces before
"Run e2fsck -D.".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D4
