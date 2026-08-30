Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460D1632
	for <linux-ext4@vger.kernel.org>; Sun, 30 Aug 2026 04:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064064; cv=none; b=QAczvbroQ5qdmUKP9yVlQ3bM1IZPTbY4xxsTsotCvkarAD3KME5U1RB8x3dLjz3Rk1DhJYUOO1cQkB8gSfgL0s3iDVxy71p99TbvF0sSaaman0DMOT2cf4ce6h8prjXRfgyuatClJa5XUMe4LZ1arb8dXRyiMHtFYU2dHx+lAkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064064; c=relaxed/simple;
	bh=Gzbzq6tyXqcy4LEGsv7WS8m14dNBsmsEs35Jl9spXfg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZQuiBgHnSpSSvh9cFhUBgU974bq/Krsq9+7w7RxcgowVzXtti55Zx7pu33vhVPsvXnn3HPQRwrE6Emj2mM/N2Pmm2qyyzbHLux+IeCSBD8ony0J+7YT43tnmaGny8gYXgFo8rapLnixen1zwPSGz37XGHAVf4i7LxrdI+EsJhV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lws2XMQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lws2XMQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E321F000E9;
	Sun, 30 Aug 2026 04:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788064062;
	bh=vjlPqVYlONIzWNPyqf84TYTvoeScVVaUPvnR6KgQVag=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lws2XMQlnDXcjWQDperBoppdSK+NR2dqP5EznGU383p5cDp04g5IqB3nSW3wHQOkH
	 Bi0+OXAm9HAZK4n1EJ8Itzx8FHdT0fjSw3O9Ianmq6DcYCYVPzG6FRIudo4GSZdzPn
	 wUjIQe5HcbEB764tdVkICj0Iq3AcORLuaCezJJtYT9UFa+AfrJwaocwATjC3DEXk8Q
	 gm1KEMUX6on+ng+umlUFAiz+g5avDX2B0E6+wrWQ6938QzLvNCHJB+BXTy0a3zp/Rm
	 4sB0cpkA3NE9BMYsoSyHVD1ZfJv/ANmFbnW0bqyEhSMK6FnHcmAm6PFtDBUo4b4/wY
	 G6WLnYY1Qy/Pg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 9/9] filemap: Remove FGP_NOFS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>, tytso@mit.edu, "Chuck
 Lever" <cel@kernel.org>, linux-ext4@vger.kernel.org
In-Reply-To: <20260830041901.2668-10-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-10-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 04:27:42 +0000
Message-Id: <20260830042742.84E321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Undeclared identifier 'FGP_NOFS' causes compilation failure in f2fs=
, and trivial removal introduces a filesystem reclaim deadlock.
--

commit 1683abf08ae4fef5fa05b44d804e2e0ac6771ec5
Author: Matthew Wilcox (Oracle) <willy@infradead.org>

filemap: Remove FGP_NOFS

This commit removes the FGP_NOFS flag and its associated __GFP_FS clearing
logic, stating that there are no more users of it.

> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 3974b063a0496..bff8b7264fb02 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
[ ... ]
> @@ -710,11 +709,10 @@ typedef unsigned int __bitwise fgf_t;
>  #define FGP_LOCK		((__force fgf_t)0x00000002)
>  #define FGP_CREAT		((__force fgf_t)0x00000004)
>  #define FGP_WRITE		((__force fgf_t)0x00000008)
> -#define FGP_NOFS		((__force fgf_t)0x00000010)

[Severity: Low]
Does this removal break the build for f2fs?

Looking at f2fs_write_begin() in fs/f2fs/data.c, it still relies on the
removed FGP_NOFS flag:

	folio =3D f2fs_filemap_get_folio(mapping, index,
				FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_NOFS,
				mapping_gfp_mask(mapping));

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6afec636881fb..e6580291f2185 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1994,8 +1994,6 @@ struct folio *__filemap_get_folio_mpol(struct addre=
ss_space *mapping,
> =20
>  		if ((fgp_flags & FGP_WRITE) && mapping_can_writeback(mapping))
>  			gfp |=3D __GFP_WRITE;
> -		if (fgp_flags & FGP_NOFS)
> -			gfp &=3D ~__GFP_FS;

[Severity: Low]
If the build failure is trivially fixed by simply deleting FGP_NOFS from
f2fs_write_begin() without adding a memalloc_nofs_save() wrapper, will this
introduce an ABBA deadlock during direct reclaim?

Because __filemap_get_folio_mpol() no longer clears __GFP_FS, this could
allow __GFP_FS to bleed into the allocator while f2fs calls this holding
internal filesystem locks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830041901.2668=
-1-willy@infradead.org?part=3D9
