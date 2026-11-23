Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795421554;
	b=K83D1WpDRsPf4B1rfhERc56kUfuNEYX2eVFYFtm2wcEWRULLnVHeP9xqXqi8g/fdO5eV
	 2qE0RNPkhNXvM0BXhpVJeW2OsM2WNnjCAaKwxkLeXN6bL4L5jhH4j0uNBJA+p8lt76/Jp
	 kBwIaIYCNwi1niXpugpZ5pcj88RE+CDgNu0sUhsQ3puGkNzDJXvK2CbhAhmKtiZb7RVcx
	 ez5wWmY7+bF2rOmoU+c6CEegcy/Gsg8Hbd77SxTBH+fPNUl5a+pVWjkry7Cozz3hYzj4C
	 BRoUWdewkZ12qvn1YnGFpuKG64X1ysxz0NjkNgoZv13BHYc4PRTdgRfgBtsCQyaJZfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795421554;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CIV1VlEfyJ2W0iFPWezU7UVj9WVVI0twh45FgtlJDw8=;
	b=TUPfW0zWv9Zn7jje79oqiIVeM4jrHHslR5X6g8lUNOoGM1kDre5afQNNjsXZRGmUQNKZ
	 hw71ErzKXscQwgVrYhWbVsmHqRyMa+QdYjBk8TWdJ2zmb+RlJ3gcNwTJ3V8sXQov6JbO4
	 3lx7FkK5ExXJjsagiJF+/tJRgKEI9iayLNbvA8d9lWhR5dUa30CC/zmnVMDwC3n2s6haF
	 zsa012KpkJLh9iwfHLh4JXx2EkGNbuHdx0xn6jiImDoifRjugFl/z00qsUBNTaNW8NgW3
	 +O08s/DkAGBuOBLz8BmjI2JErHSXdMZNL9RMfV+3Eqz40APEjpL4Tr4qMX3pbF8dNVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N654KMQT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A823606A31E
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 08:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N654KMQT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B841F000C0;
	Mon, 23 Nov 2026 08:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795421553;
	bh=CIV1VlEfyJ2W0iFPWezU7UVj9WVVI0twh45FgtlJDw8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N654KMQT3fMoJVIyRX8VfsurUgPdG1ak5LUOlB4CdJBJ1eH4OViTVEaCO3Nzhkj3E
	 j45QIOEo6oC55qp7MbZzbWSx85UpPrWiW1MQyOR3m5jgGlme6OSCbgYJe2Z+5ADfBL
	 YiaZ3QLh8J96/6LektKHqrhXKuFNkvhanrSBehjb+sgR8ei/dLMwSxVRErYdJUbpk0
	 0+dGZCqU4U0430+PgRPHcXsr0ZXrBxVtVhyGsKMEAKJ3ZnH9K++PbTgeMkRvX8qwKb
	 fzmaD7ovyWmKVTohIKGBVHlqdtXeoRtzq1P1yRtpI/T7InCri1YI9njCTRPXc6jdnd
	 yw7B20wZ6mDbw==
Message-ID: <sashiko-outbox-228890@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: avoid inline data conversion race when
 !EXT4_STATE_MAY_INLINE_DATA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arbab Haider" <arbabhaider649@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261123074825.63294-2-arbabhaider649@gmail.com>
References: <20261123074825.63294-2-arbabhaider649@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 08:12:33 +0000
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
- [High] ext4: spurious -EIO in ext4_convert_inline_data() after
  truncate to zero
--

commit 9ccbfe6796f4c788a0b995f876e6cdb2091e3037
Author: Arbab Haider <arbabhaider649@gmail.com>

ext4: avoid inline data conversion race when !EXT4_STATE_MAY_INLINE_DATA

This commit replaces filemap_flush() with filemap_write_and_wait() in
ext4_convert_inline_data() when EXT4_STATE_MAY_INLINE_DATA is cleared,
returns -EIO if inline data remains after writeback, and rechecks
EXT4_STATE_MAY_INLINE_DATA after acquiring xattr_sem.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 2e14ee9b4241b..1faf277a22908 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1997,6 +1997,7 @@ int ext4_convert_inline_data(struct inode *inode)
>  	handle_t *handle;
>  	struct ext4_iloc iloc;
> =20
> +retry:
>  	if (!ext4_has_inline_data(inode)) {
>  		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
>  		return 0;
> @@ -2004,14 +2005,21 @@ int ext4_convert_inline_data(struct inode *inode)
>  		/*
>  		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
>  		 * cleared. This means we are in the middle of moving of
> -		 * inline data to delay allocated block. Just force writeout
> -		 * here to finish conversion.
> +		 * inline data to delay allocated block. Force synchronous
> +		 * writeout here to finish conversion.
>  		 */
> -		error =3D filemap_flush(inode->i_mapping);
> +		error =3D filemap_write_and_wait(inode->i_mapping);
>  		if (error)
>  			return error;
>  		if (!ext4_has_inline_data(inode))
>  			return 0;
> +		/*
> +		 * Writeback did not clear inline data (e.g. filesystem is in
> +		 * emergency state). Do not proceed to
> +		 * ext4_convert_inline_data_nolock(), which would read stale
> +		 * on-disk inline data or race with writeback.
> +		 */
> +		return -EIO;
>  	}

[Severity: High]
Can ext4_convert_inline_data() fail with a spurious -EIO after an
inline-data inode is truncated to 0 before writeback runs?

When a delayed-allocation write exceeds inline capacity,
ext4_da_convert_inline_data_to_extent() copies the data into folio 0,
marks it dirty, and clears EXT4_STATE_MAY_INLINE_DATA while leaving
EXT4_INODE_INLINE_DATA set until ext4_do_writepages() destroys the inline
data.  If the file is truncated to 0 before writeback runs,
truncate_pagecache() drops dirty folio 0 and ext4_inline_data_truncate()
removes the delayed extent, but leaves EXT4_INODE_INLINE_DATA set and
EXT4_STATE_MAY_INLINE_DATA cleared.

Because inode->i_mapping no longer has dirty pages,
filemap_write_and_wait() returns 0 without calling ext4_destroy_inline_data=
(),
so ext4_has_inline_data(inode) remains true.  Later calls to
ext4_convert_inline_data() (such as fallocate(), an extending truncate, or
ext4_page_mkwrite()) then fail with -EIO, or raise SIGBUS on shared mmap
write faults.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123074825.6329=
4-2-arbabhaider649@gmail.com?part=3D1
