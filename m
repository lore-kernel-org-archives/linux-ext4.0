Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794340005;
	b=qlslwytfyvaAo43Jm6uhYUE8w8xlxCt6h1YW2D8b2ahU3ybB8wweHoBkJBPNTHy/eC6D
	 9QFihdSmdkdASCA4QEyFEXIIiCuuhFr50yyHTSA2Ndo4pQQxPZRhUr3CQa+ipZ++z+IOZ
	 2rRcMDHyUExyUAhK4F0NDChdlG5Wa1RqVCg3oQYA6QNtbaOZtagE3oCFoFy8pf7Wa5BAi
	 D9klvwgP51K3sPlT+kRLW6O644dtV0d225ecIDuGDoOBAo9PFc/a/2Sk9WNnLskqQOSSl
	 /Afv2nFwGqLlq6cE3bMaAYTsMnkeL5TGo0dmvnx/o6kpE50VLcftCBG4KEbDaxTc04w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794340005;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Mbn6VLDfmWanKWXw1nbGQVtn5dysVqWEH2CodjfqdVw=;
	b=XuzD5uFlcS5XztDAOfhAAtxZq1O7uMFSSvw1XC9TBbE/pXAlqQlD1LZyRKKzPu+lMGTt
	 5Cu0Jha9ykgQ3r3/NUXgkOCpfIpiwjQvR8Gma8HbVNMfSfsbk3fGs3Uv24ouCRHauD6G+
	 GnqCBZX7JpmNftywtw6ewl5on/Kee03Y+xgRkrplKBz1GFiTCMYBNG9eQRCrKsJMVaRjb
	 ZQ8OOy2YQzp/68pWyy7+n1WRpyZXSzCwIZ1n7tkWbhBQ8qhggf1VwIMDByVOsqcP4YCtP
	 oTo7yCcrW8/kNljCgFej8sVpTo0CYCZtfgser6LwQK2tgSB9tmN/7Z04GUSjHQyf59w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTXKBr7M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0A606A326
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTXKBr7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F691F0089F;
	Tue, 10 Nov 2026 19:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794340004;
	bh=Mbn6VLDfmWanKWXw1nbGQVtn5dysVqWEH2CodjfqdVw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FTXKBr7MviAPk2Y5Al8nhKB9qCX2D/wP96mvjmekDnYWkUVZCKe4XvaNsQFMd2lbl
	 HfXKqttcFdaH7zho20fPhJ+qHYT6f2KVKMrlO21U82qhSIa+JvC0wsjJf+8M4TZ2ev
	 y7Cqkgnk+n8+Ib/Z8jU46D+jq9G1xzdoZWgh5VexMmjNiFo7ZEy1YKOL9Cc+MVBj/G
	 4mBFvIQbO/r7xbtHkwoL4z9rnB2nKfdpJ0Lsndc4HuE0/LngWi/Th148W7Ptuiqu5A
	 larZiGfwHq7HybMXaTPg7hKKLKgeuUYVlqepkN0ZMSlepxtRDw+70o9nr/aOSA7ERd
	 NwZdgw0R/OAgA==
Message-ID: <sashiko-outbox-207681@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] ext4: fix NULL pointer dereference in
 ext4_mb_load_buddy_gfp()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aleksandr Panfilenko" <lexpasss@inbox.lv>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110193711.3106773-2-lexpasss@inbox.lv>
References: <20261110193711.3106773-1-lexpasss@inbox.lv>
 <20261110193711.3106773-2-lexpasss@inbox.lv>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:46:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ext4: false NULL return premise for __filemap_get_folio() in
  mainline
--

commit 26a680b6bc63194bc1c7439d73f388c607684a53
Author: Aleksandr Panfilenko <lexpasss@inbox.lv>

ext4: fix NULL pointer dereference in ext4_mb_load_buddy_gfp()

This commit replaces IS_ERR() with IS_ERR_OR_NULL() on the fast-path
__filemap_get_folio() lookups and folio_put() guards in
ext4_mb_load_buddy_gfp().

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a15285224cdf6..11ca5a1481752 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1715,7 +1715,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4=
_group_t group,
> =20
>  	/* Avoid locking the folio in the fast path ... */
>  	folio =3D __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
> -	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(f=
olio)) {
> +	if (IS_ERR_OR_NULL(folio) || !folio_test_uptodate(folio) ||
> +	    folio_test_locked(folio)) {
>  		/*
>  		 * folio_test_locked is employed to detect ongoing folio
>  		 * migrations, since concurrent migrations can lead to
> @@ -1725,7 +1726,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4=
_group_t group,
>  		 * try to get the folio with lock in both cases to avoid
>  		 * concurrency.
>  		 */
> -		if (!IS_ERR(folio))
> +		if (!IS_ERR_OR_NULL(folio))
>  			folio_put(folio);
>  		folio =3D __filemap_get_folio(inode->i_mapping, pnum,
>  				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
> @@ -1774,8 +1775,9 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4=
_group_t group,
> =20
>  	/* we need another folio for the buddy */
>  	folio =3D __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
> -	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(f=
olio)) {
> -		if (!IS_ERR(folio))
> +	if (IS_ERR_OR_NULL(folio) || !folio_test_uptodate(folio) ||
> +	    folio_test_locked(folio)) {
> +		if (!IS_ERR_OR_NULL(folio))
>  			folio_put(folio);
>  		folio =3D __filemap_get_folio(inode->i_mapping, pnum,
>  				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);

[Severity: Medium]
Can __filemap_get_folio() return NULL in mainline, or is this a 6.1.y
backport bug?

In mainline, since 66dabbb65d67 ("mm: return an ERR_PTR from
__filemap_get_folio"), __filemap_get_folio() returns ERR_PTR(-ENOENT) on a
page-cache miss and never NULL:

mm/filemap.c:__filemap_get_folio_mpol() {
	...
	if (!folio)
		return ERR_PTR(-ENOENT);
	...
}

Commits 99b150d84e49 ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
and 5eea586b47f0 ("ext4: convert bd_buddy_page to bd_buddy_folio") were
written against that contract, so IS_ERR(folio) already handles cache
misses upstream.

In 6.1.y, which lacks 66dabbb65d67 ("mm: return an ERR_PTR from
__filemap_get_folio"), __filemap_get_folio() returns NULL on all failures,
including FGP_CREAT allocation failures.  In that tree, the FGP_CREAT
calls right below in ext4_mb_load_buddy_gfp() and in
ext4_mb_get_buddy_folio_lock() still only check IS_ERR(folio), so an
allocation failure under memory pressure will pass !IS_ERR(NULL) and
dereference folio->mapping.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110193711.3106=
773-1-lexpasss@inbox.lv?part=3D1
