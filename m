Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29F0442372
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 07:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543479; cv=none; b=jsWdvU4q0thAFWzzr8Xra9pg99icNEawwmddjlRXrlrUXiL/dBLkd5keTXKDdnQanUUSTzO/kI1EUwXgG0c1eBOZ0+pgEWqgXtIWaOTUeC8lxEJ77/pai5ACNUjvfsrdf4CpGeMVUsU3vp/6IMlpbKUO2Z9+Bn4zSD67hGEN0QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543479; c=relaxed/simple;
	bh=BCXmr4tF3oqESyXeBYvhIIA6QqE78ZFP1dApqQJ8LNA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ganIwdHUz0yD9FmIxiyYzuQTj3MvCZw1FWHZyYT96urgWUaomfYdNg/wypzXdsxBaAS9bkdqKOXL0CXeC/axtvRbMvH0ZizowhJ2rm4B43Qa0fzq69VEBDb1DXi/+CFcbKYGKO5O9EGK/MFTae7ZmX7RVawqcTtjYJnwH+OXGN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhgG3Tb/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhgG3Tb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316321F000FF;
	Wed, 16 Sep 2026 07:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789543460;
	bh=FNFs+BsHlkXUGL3kwQoBxRMXjNtpkJkMlJRh3vvW9C0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UhgG3Tb/2mjIBZlt3iTDBk3mYJ6U0nAWap2qCbXBbYeivTggFF652LKRGJA+uSS61
	 5P1QAv9Bw3y5cYRq5YaxyUZHgnw7rAAZmdyf+HvwNwaEyaxko1VL3juHZWLRPPYsSb
	 hLxhGpUTNlZsoRUlwNcZP4XTyYSrQG6kg4MDVCIIZPVRWOpFZbevdx7xlnP4AUKX9k
	 s98KXt6GvdONggTcFL6XJH1wWGhGtAzV/noLPe02UQ9AXBHX8YW8QIaxPDCd0FtTgs
	 CKqCsg47mOBmhZ9ZJSRaIrkJs0rzoXN7hQutCVQNjQehy7b962ka/FYFWrDJM/7jIB
	 ZxB3pM0leOSgg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: drop extra ea_inode ref in cached-block reuse
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matthias Goergens" <matthias.goergens@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260916071046.2182813-1-matthias.goergens@gmail.com>
References: <20260916071046.2182813-1-matthias.goergens@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 07:24:19 +0000
Message-Id: <20260916072420.316321F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] ext4: double decrement of EA inode refcount in cache hit path
- [Low] ext4: build failure due to undefined ext4_put_ea_inode()
--

commit 918f13e87ab50346ca215dbe65d8940b03723d64
Author: Matthias Goergens <matthias.goergens@gmail.com>

    ext4: drop extra ea_inode ref in cached-block reuse path

    ext4_xattr_block_set() takes a reference on the ea_inode via
    ext4_xattr_inode_lookup_create() before it builds the new xattr block.
    The new-block path drops that reference once
    ext4_xattr_inode_inc_ref_all() has counted every entry in the block.
    When a separately built block is discarded in favour of an identical
    cached block, the cached block already counts its entries and the
    lookup reference is left unbalanced.

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 6127e94ea4f5d..0da96678051e4 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2032,6 +2032,24 @@ ext4_xattr_block_set(handle_t *handle, struct inod=
e *inode,
>  			mb_cache_entry_touch(ea_block_cache, ce);
>  			mb_cache_entry_put(ea_block_cache, ce);
>  			ce =3D NULL;
> +			if (ea_inode && !(bs->bh && s->base =3D=3D bs->bh->b_data)) {
> +				/*
> +				 * The cached block already owns its EA inode
> +				 * references.  For an in-place update the lookup
> +				 * reference belongs to the old block and is
> +				 * dropped when that block is released.
> +				 */
> +				error =3D ext4_xattr_inode_dec_ref(handle,
> +								 ea_inode);

[Severity: Critical]
Does this code leave ea_inode set after successfully decrementing the
reference count?

If ea_inode isn't cleared here (and its in-memory reference via iput
isn't dropped), won't execution eventually fall through to the cleanup
label below where ext4_xattr_inode_dec_ref is unconditionally called a
second time for the non-NULL pointer?

> +				if (error) {
> +					EXT4_ERROR_INODE(inode,
> +							 "dec ref error=3D%d",
> +							 error);
> +					ext4_put_ea_inode(ea_inode);

[Severity: Low]
Does this break the build? ext4_put_ea_inode appears to be undefined.
Should this be iput?

> +					ea_inode =3D NULL;
> +					goto cleanup;
> +				}
> +			}

[ ... ]

>  	error =3D 0;
> =20
>  cleanup:
>  	if (ea_inode) {
>  		int error2;
> =20
>  		error2 =3D ext4_xattr_inode_dec_ref(handle, ea_inode);
>  		if (error2)
>  			ext4_warning_inode(ea_inode, "dec ref error=3D%d",
>  					   error2);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916071046.2182=
813-1-matthias.goergens@gmail.com?part=3D1
