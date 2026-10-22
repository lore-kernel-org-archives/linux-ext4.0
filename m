Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639084;
	b=yemVjP+OWqL+MAwWBuclYmckEllNmJIPSZNC1ZVzMH3/xA1JKCvOkoKSUL7K6bDQ/1Qz
	 uSLA5CtUzcPX2fGMi7KNyBSZsRWpv4jnzGKPwKPTkG0CLXP6aBklYpzIq4iaIaOFPiN9+
	 3wGN9zQ6l1g11r4C7E9ZU6MII+bvPApMeJKX9Q8mOWVdPXYTNq/XOeAmid5rr0nDiuecW
	 RVY32Rq5YfNsRyXyFC24KNFYkoWMm+UvHP5J9y5rbp0Q77tHe3Z+bDLh0UrM81BsyzY0v
	 HcQIl4P62qiubLEVg6+574Cr3lE9X+MWrDqUesAcrSGd8nB2uSccxp5t/wjU7jGiEYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639084;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wOs5T5f9BBIK/MSbZ7K1C+nJ51SR6kYlBUF85e01IQY=;
	b=3FAkj5IE0wgNWRlSXyiG4eikjFMV0pCSSI4hopmulmsmD+ZDzrafqjrUUwmLXV3FUD/z
	 /lJxrsuK1/AoEjeomXBIc6KV6qeW10DnLdtAxgutMTrrmXP55/ClWdHbA/y65e8DrwbDe
	 TyRzv1JfJnnZ98mgqxFYCd7i6Oa524w5fKqJqFISJD5aLXADN81R/gl+lle7wpH35qzdc
	 W/L9bmNMghyG3lqUizCWCfUKCRWOn3ytx/NbbwTVY6IXXW+xkTnm1O1TPhqspk4iOmj9y
	 SC/oAAz4V/Dz5uL+58veKUPczd5xgMWdSYOlUtSwzwaNhnASpzj6Q9yhNynv3wx9e/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AQ9c/ZaM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E3A60A261B;
	Thu, 22 Oct 2026 03:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQ9c/ZaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E051F000C6;
	Thu, 22 Oct 2026 03:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639083;
	bh=wOs5T5f9BBIK/MSbZ7K1C+nJ51SR6kYlBUF85e01IQY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AQ9c/ZaMOWfbcIRbAzCjZLfmG9ops9ZzIPurww2mGSTBDbUM3bwUKDCczMsPZzsvB
	 874YpWa+XZRb0+aiVuhWNRZ0MCs5+CvmExQWC2BHH/bzS/DfZBQRNZNiAwVabLykni
	 UwrN/zpgWGPSiem9HlE432m1HTTAVjMWKX5+mflXhP6ZBL+4MgPGxzSpFG0m0V28K8
	 6sW2UQdDElSrVkz2McYn5cn7lFLq2p1HQrlwwAYT2iiPppAtte7Et76XomXAZsdesn
	 zNnp2tVFnG0FqkHrUST9nqJH2TbXQI6nnMSz9vx3D3J/n30eAlYQRRkw8bEZmM2tre
	 4xvHR6rUcYUJA==
Message-ID: <sashiko-outbox-180935@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 34/41] ext4: store ACLs with UUID and GUID
 entries on uid_r filesystems
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <98758113db07083faeb158948b6b3362c2795231.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <98758113db07083faeb158948b6b3362c2795231.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:18:02 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ext4: under-reserved journal credits in ext4_set_acl() and new ino=
de ACLs
- [Medium] ext4: missing uid_r check in ext4_get_acl() and ext4_acl_to_disk=
()
--

commit 9cf145428ff7d92b62a997fd08d61060d4a516a9
Author: Jan Koester <jan.koester@tuxist.de>

ext4: store ACLs with UUID and GUID entries on uid_r filesystems

This commit adds the EXT4_ACL_VERSION_R on-disk format so ext4 can store
POSIX ACLs containing 16-byte UUID or GUID user and group entries on uid_r
filesystems. ACLs without UUID or GUID entries continue to use the legacy
EXT4_ACL_VERSION format.

> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 3bffe862f9549..27f8a1b503704 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c

[ ... ]

> @@ -14,22 +15,41 @@
>  /*
>   * Convert from filesystem to in-memory representation.
>   */
> +/* The id of an ACL_USER or ACL_GROUP entry of EXT4_ACL_VERSION_R */
> +static int ext4_acl_id_from_disk(const ext4_acl_entry_r *entry, u32 *typ=
e,
> +				 u32 *legacy, uuid_t *id)
> +{
> +	*type =3D le32_to_cpu(entry->e_type);
> +	if (*type > EXT4_ID_R_GUID)
> +		return -EINVAL;
> +	*legacy =3D get_unaligned_le32(entry->e_id);
> +	memcpy(id->b, entry->e_id, sizeof(id->b));
> +	return 0;
> +}
> +
>  static struct posix_acl *
>  ext4_acl_from_disk(const void *value, size_t size)
>  {
>  	const char *end =3D (char *)value + size;
>  	int n, count;
>  	struct posix_acl *acl;
> +	size_t entry_size =3D sizeof(ext4_acl_entry);
> +	bool r =3D false;
> =20
>  	if (!value)
>  		return NULL;
>  	if (size < sizeof(ext4_acl_header))
>  		 return ERR_PTR(-EINVAL);
> -	if (((ext4_acl_header *)value)->a_version !=3D
> -	    cpu_to_le32(EXT4_ACL_VERSION))
> +	if (((ext4_acl_header *)value)->a_version =3D=3D
> +	    cpu_to_le32(EXT4_ACL_VERSION_R)) {
> +		r =3D true;
> +		entry_size =3D sizeof(ext4_acl_entry_r);
> +	} else if (((ext4_acl_header *)value)->a_version !=3D
> +		   cpu_to_le32(EXT4_ACL_VERSION)) {
>  		return ERR_PTR(-EINVAL);
> +	}

[Severity: Medium]
Should ext4_get_acl() -> ext4_acl_from_disk() and ext4_acl_to_disk() verify
that uid_r is enabled on the filesystem before accepting or writing
EXT4_ACL_VERSION_R entries?

In fs/ext4/inode.c, both ext4_inode_get_id_r() and ext4_inode_set_id_r()
check ext4_has_feature_uid_r(inode->i_sb), whereas ext4_get_acl() in
fs/ext4/acl.c calls ext4_acl_from_disk() without checking
ext4_has_feature_uid_r(inode->i_sb) or SB_I_UID_R:

fs/ext4/acl.c:ext4_get_acl() {
	...
	if (retval > 0)
		acl =3D ext4_acl_from_disk(value, retval);
	...
}

In addition, the comment above ext4_acl_to_disk() notes that set_posix_acl()
rejects non-legacy IDs when SB_I_UID_R is not set, but two write paths in
fs/ext4/acl.c bypass set_posix_acl():

1. chmod() calls posix_acl_chmod() -> ext4_set_acl() -> __ext4_set_acl() ->
   ext4_acl_to_disk().
2. New inode creation calls __ext4_new_inode() -> ext4_init_acl() ->
   posix_acl_create() -> __ext4_set_acl() -> ext4_acl_to_disk():

fs/ext4/acl.c:ext4_init_acl() {
	...
	if (default_acl) {
		error =3D __ext4_set_acl(handle, inode, ACL_TYPE_DEFAULT,
				       default_acl, XATTR_CREATE);
		posix_acl_release(default_acl);
	}
	...
}

If a filesystem without EXT4_FEATURE_RO_COMPAT_UID_R (or a uid_r filesystem
mounted with -o nouid32, where __ext4_fill_super() leaves SB_I_UID_R unset)
has an existing EXT4_ACL_VERSION_R xattr on disk, wouldn't ext4_get_acl()
load those non-legacy entries and allow chmod() or file creation to write
new EXT4_ACL_VERSION_R xattrs onto the filesystem?

[ ... ]

> @@ -87,19 +119,38 @@ ext4_acl_from_disk(const void *value, size_t size)
>  /*
>   * Convert from in-memory to filesystem representation.
>   */
> +/* An ACL_USER or ACL_GROUP id into an entry of EXT4_ACL_VERSION_R */
> +static void ext4_acl_id_to_disk(ext4_acl_entry_r *entry, u32 type, u32 l=
egacy,
> +				const uuid_t *id)
> +{
> +	entry->e_type =3D cpu_to_le32(type);
> +	memset(entry->e_id, 0, sizeof(entry->e_id));
> +	if (type =3D=3D EXT4_ID_R_LEGACY)
> +		put_unaligned_le32(legacy, entry->e_id);
> +	else
> +		memcpy(entry->e_id, id->b, sizeof(entry->e_id));
> +}
> +
> +/*
> + * ACLs with UUID or GUID entries (only on uid_r filesystems, see
> + * set_posix_acl()) are written as EXT4_ACL_VERSION_R, others as before.
> + */
>  static void *
>  ext4_acl_to_disk(const struct posix_acl *acl, size_t *size)
>  {
>  	ext4_acl_header *ext_acl;
>  	char *e;
>  	size_t n;
> +	bool r =3D posix_acl_has_id_r(acl);
> +	size_t entry_size =3D r ? sizeof(ext4_acl_entry_r) : sizeof(ext4_acl_en=
try);
> =20
> -	*size =3D ext4_acl_size(acl->a_count);
> +	*size =3D ext4_acl_size_e(acl->a_count, entry_size);

[ ... ]

> diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
> index 0c5a79c3b5d48..48bc352ec77fe 100644
> --- a/fs/ext4/acl.h
> +++ b/fs/ext4/acl.h

[ ... ]

> @@ -46,12 +60,22 @@ static inline int ext4_acl_count(size_t size)
>  			return -1;
>  		return size / sizeof(ext4_acl_entry_short);
>  	} else {
> -		if (s % sizeof(ext4_acl_entry))
> +		if (s % entry)
>  			return -1;
> -		return s / sizeof(ext4_acl_entry) + 4;
> +		return s / entry + 4;
>  	}
>  }
> =20
> +static inline size_t ext4_acl_size(int count)
> +{
> +	return ext4_acl_size_e(count, sizeof(ext4_acl_entry));
> +}

[Severity: High]
Can leaving ext4_acl_size() hardcoded to sizeof(ext4_acl_entry) cause
journal credit under-reservation in ext4_set_acl() and
ext4_xattr_credits_for_new_inode()?

When posix_acl_has_id_r(acl) is true, ext4_acl_to_disk() in fs/ext4/acl.c
serializes ACL_USER and ACL_GROUP entries using sizeof(ext4_acl_entry_r)
(24 bytes) and sets *size to ext4_acl_size_e(acl->a_count,
sizeof(ext4_acl_entry_r)).

However, ext4_set_acl() in fs/ext4/acl.c still computes acl_size using
ext4_acl_size(acl->a_count), which assumes 8-byte ext4_acl_entry elements:

fs/ext4/acl.c:ext4_set_acl() {
	...
	size_t acl_size =3D acl ? ext4_acl_size(acl->a_count) : 0;
	...
retry:
	error =3D ext4_xattr_set_credits(inode, acl_size, false /* is_create */,
				       &credits);
}

Similarly, when a new inode inherits a default ACL in __ext4_new_inode() ->
ext4_init_acl(), ext4_xattr_credits_for_new_inode() in fs/ext4/ialloc.c
computes acl_size using sizeof(ext4_acl_entry):

fs/ext4/ialloc.c:ext4_xattr_credits_for_new_inode() {
	...
	if (p) {
		int acl_size =3D p->a_count * sizeof(ext4_acl_entry);

		nblocks +=3D (S_ISDIR(mode) ? 2 : 1) *
			__ext4_xattr_set_credits(sb, NULL /* inode */,
						 NULL /* block_bh */, acl_size,
						 true /* is_create */);
		posix_acl_release(p);
	}
}

When the ea_inode feature is enabled on the filesystem,
__ext4_xattr_set_credits() in fs/ext4/xattr.c scales the credit count with
the number of blocks spanned by value_len:

fs/ext4/xattr.c:__ext4_xattr_set_credits() {
	...
	blocks =3D (value_len + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
	blocks +=3D 1;
	credits +=3D blocks * 2;
	credits +=3D blocks;
	...
}

Later, __ext4_set_acl() -> ext4_xattr_set_handle() recomputes the required
credits from the actual serialized value_len and checks that the running
handle has enough buffer credits:

fs/ext4/xattr.c:ext4_xattr_set_handle() {
	...
	credits =3D __ext4_xattr_set_credits(inode->i_sb, inode, bh,
					   value_len,
					   flags & XATTR_CREATE);
	brelse(bh);

	if (jbd2_handle_buffer_credits(handle) < credits) {
		error =3D -ENOSPC;
		goto cleanup;
	}
}

If an EXT4_ACL_VERSION_R ACL is large enough that its 24-byte entries cross
a block boundary not crossed by the 8-byte estimate, won't
ext4_xattr_set_handle() fail this check and return a spurious -ENOSPC (or
leave __ext4_new_inode() short of journal credits for subsequent operations
on the same handle)?

[ ... ]

>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D34
