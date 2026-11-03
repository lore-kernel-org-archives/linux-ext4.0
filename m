Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715526;
	b=BINpZoxqeTDzw7UJXiZET/lQXxRQNKCEoBMYy+wHpbqB5+S9kk+CH5OOwV5hnuxxfXRD
	 RG9odwWDt4GH+BqLLArpKSInLc9wt/q4IEhSmbzuu3lnw4TTv2jyo/Z5QQpf6HSJhgVF8
	 99EUD0a/96po+u0o2EEYYpw5W1IHZsXVvnDi/bOV3IOJuMBRnW9QvhG4FqKJCfyyqQ0XK
	 Ea0r01htwPOzI9qIYZAeUzLs+z9n3UlAIydcqD8fSIXVyKtEWhYHADb99Ki7HI4XhQrcJ
	 UKvGx5reAUa+zvy2OMzqKlKiduVwl6QQyvfsjBLcII+wIVWnZAQp/AI222IA81rrJZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715526;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=X0yivtuZQPpYh5yrVeeEtqoPcgyt+SqygntLyJdlDtU=;
	b=HhHVdbaxvUPv2YkH3ji0hibxlokiIoy2pvTlMg27IdJNcw/lMS+q7Q8mr1wLtoMac3+o
	 RwijMkSrmu0elCS8smwcC0E1AolIX2Rm4TSb/C2ngAzhTjFg3JfGYilHevuGexgN42rjS
	 8Mmk1rcekrZUeJxczaBH6gGWoZ0Jhhjoj3L/BsDRPxbQnAVSbyB1fRYjpEpjGUFWlDwiX
	 IXXUI7hQIdW65RmoPB9u77V/1J33FFqVZRn6VSRplxkPZwfTUOS0FO0VLTnlrdfueCZrL
	 N6gd7Rjv74bBHlpKuapvTFlYyF+Pp//Csd+H0d+0XvPeFaezHvQmd+C+nv88F9kS8Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fza5rrQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12600606D801
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fza5rrQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AD61F000C1;
	Tue,  3 Nov 2026 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715525;
	bh=X0yivtuZQPpYh5yrVeeEtqoPcgyt+SqygntLyJdlDtU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fza5rrQLuM71rp996vHEkB+hBf49qFmTs8v1629w4Z4WvjfViLalT0KA44iR2dGJC
	 CBaOsip5YJrjvl47mvUXgDrEzKmL1ijQ4DduZY76UmFsgNUDtiwAWbOTcvtWWqQyMh
	 aurjdUZzHNwdc5Ouiji3E7VzZTTZsuJDFnHNo8/XAEWuG+5+7sTX4egNBFIY/oCc1P
	 bbfFpz3Zxwai/pgN4AGltK6tMu8wS6UU8NPAbqu6Woexutzqi/A3La4NSA8VFAkfWa
	 ouKdbd6vqzrRR0C3IrQSWv+o53srj8C+Btk4mGkHu7qZ2Kon6G1xAI7sTtbpUuWzB+
	 rGha/9CUPmuOA==
Message-ID: <sashiko-outbox-195435@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 11/12] ext4: add dirdata set/get helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-12-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-12-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:18:44 +0000
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
- [High] ext4: unchecked EXT4_DIRENT_HASH fallback read after ext4_dirdata_=
get()
--

commit b0e6360d0312737d9514b8c174a474f487aed85e
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: add dirdata set/get helpers

This commit introduces ext4_dirdata_get() and ext4_dirdata_set() to read and
write directory entry payload extensions such as LUFID and casefold hashes,
and wires them into directory lookup, insertion, and readdir paths.

> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 15816f2a5f472..12df2d2a09978 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -302,8 +302,19 @@ static int ext4_readdir(struct file *file, struct di=
r_context *ctx)
>  					u32 minor_hash;
> =20
>  					if (IS_CASEFOLDED(inode)) {
> -						hash =3D EXT4_DIRENT_HASH(de);
> -						minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> +						if (ext4_has_feature_dirdata(sb) &&
> +						    (de->file_type &
> +						     EXT4_DIRENT_CFHASH)) {
> +							struct dx_hash_info hi =3D {};
> +							ext4_dirdata_get(de, inode,
> +								sb->s_blocksize,
> +								NULL, &hi);
> +							hash =3D hi.hash;
> +							minor_hash =3D hi.minor_hash;
> +						} else {
> +							hash =3D EXT4_DIRENT_HASH(de);
> +							minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> +						}
>  					} else {
>  						hash =3D 0;
>  						minor_hash =3D 0;
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 81e0ef1c88337..801fa6555ea96 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1359,14 +1359,20 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
>  			pos +=3D de_len;
>  		}
> =20
> -		if (ext4_hash_in_dirent(dir)) {
> -			hinfo->hash =3D EXT4_DIRENT_HASH(de);
> -			hinfo->minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> -		} else {
> -			err =3D ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
> -			if (err) {
> -				ret =3D err;
> -				goto out;
> +		if (!(ext4_dirdata_get(de, dir, inline_size, NULL, hinfo) &
> +							EXT4_DIRENT_CFHASH)) {
> +			if (ext4_hash_in_dirent(dir)) {
> +				/* Un-migrated entry: hash at legacy fixed
> +				 * offset. */
> +				hinfo->hash =3D EXT4_DIRENT_HASH(de);
> +				hinfo->minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> +			} else {
> +				err =3D ext4fs_dirhash(dir, de->name,
> +						     de->name_len, hinfo);
> +				if (err) {
> +					ret =3D err;
> +					goto out;
> +				}
>  			}
>  		}
>  		if ((hinfo->hash < start_hash) ||
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index bd0f4760f1e31..8f1a6c000373e 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1178,22 +1178,34 @@ static int htree_dirblock_to_tree(struct file *di=
r_file,
>  			/* silently ignore the rest of the block */
>  			break;
>  		}
> -		if (ext4_hash_in_dirent(dir)) {
> -			if (de->name_len && de->inode) {
> -				hinfo->hash =3D EXT4_DIRENT_HASH(de);
> -				hinfo->minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> -			} else {
> -				hinfo->hash =3D 0;
> -				hinfo->minor_hash =3D 0;
> -			}
> +		if (de->name_len && de->inode) {
> +			/* check for saved hash first, or generate it from name */
> +			if (!(ext4_dirdata_get(de, dir, dir->i_sb->s_blocksize,
> +					       NULL, hinfo) &
> +			      EXT4_DIRENT_CFHASH)) {
> +				if (ext4_hash_in_dirent(dir)) {
> +					/* Un-migrated entry: hash is at the
> +					 * legacy fixed offset, not in a CFHASH
> +					 * extension.  Read it directly rather
> +					 * than hashing the encrypted name. */
> +					hinfo->hash =3D EXT4_DIRENT_HASH(de);
> +					hinfo->minor_hash =3D
> +						EXT4_DIRENT_MINOR_HASH(de);

[ ... ]

> +unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de, struct inode=
 *dir,
> +			       int buf_size,
> +			       struct ext4_dirent_fid *dfid,
> +			       struct dx_hash_info *hinfo)
> +{
> +	unsigned char ret =3D 0;
> +	unsigned int data_offset =3D de->name_len + 1;
> +	unsigned int rec_len =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
> +
> +	/* data_offset is relative to de->name, which itself starts
> +	 * EXT4_BASE_DIR_LEN bytes into the entry -- rec_len is relative to
> +	 * the start of the entry, so add the header size before comparing,
> +	 * or this lets reads run EXT4_BASE_DIR_LEN bytes past the entry. */
> +	if (EXT4_BASE_DIR_LEN + data_offset > rec_len)
> +		return ret;
> +
> +	/* compatibility: hash stored inline after filename (no dirdata) */
> +	if (hinfo && !ext4_has_feature_dirdata(dir->i_sb) &&
> +	    ext4_hash_in_dirent(dir)) {
> +		if (ext4_dirent_rec_len(de->name_len, dir) > rec_len)
> +			return ret;
> +		hinfo->hash =3D EXT4_DIRENT_HASH(de);
> +		hinfo->minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> +		ret |=3D EXT4_DIRENT_CFHASH;
> +		return ret;
> +	}

[ ... ]

> @@ -1396,13 +1606,21 @@ static int dx_make_map(struct inode *dir, struct =
buffer_head *bh,
>  					 ((char *)de) - base))
>  			return -EFSCORRUPTED;
>  		if (de->name_len && de->inode) {
> -			if (ext4_hash_in_dirent(dir))
> -				h.hash =3D EXT4_DIRENT_HASH(de);
> -			else {
> -				int err =3D ext4fs_dirhash(dir, de->name,
> -						     de->name_len, &h);
> -				if (err < 0)
> -					return err;
> +			if (!(ext4_dirdata_get(de, dir, dir->i_sb->s_blocksize,
> +					       NULL, &h) &
> +						EXT4_DIRENT_CFHASH)) {
> +				if (ext4_hash_in_dirent(dir)) {
> +					/* Un-migrated entry: hash at legacy
> +					 * fixed offset. */
> +					h.hash =3D EXT4_DIRENT_HASH(de);
> +					h.minor_hash =3D
> +						EXT4_DIRENT_MINOR_HASH(de);

[ ... ]

> @@ -1531,10 +1750,29 @@ static bool ext4_match(struct inode *parent,
>  		 * considering the calculated hash.
>  		 */
>  		if (sb_no_casefold_compat_fallback(parent->i_sb) &&
> -		    IS_ENCRYPTED(parent) && fname->cf_name.name &&
> -		    (fname->hinfo.hash !=3D EXT4_DIRENT_HASH(de) ||
> -		     fname->hinfo.minor_hash !=3D EXT4_DIRENT_MINOR_HASH(de)))
> -			return false;
> +		    IS_ENCRYPTED(parent) && fname->cf_name.name) {
> +			__u32 de_hash, de_minor_hash;
> +
> +			if (ext4_has_feature_dirdata(parent->i_sb) &&
> +			    (de->file_type & EXT4_DIRENT_CFHASH)) {
> +				/* Hash is in a CFHASH extension at a variable
> +				 * offset (past any LUFID bytes). Read it via
> +				 * ext4_dirdata_get() to get the correct offset. */
> +				struct dx_hash_info dirent_hinfo =3D {};
> +
> +				ext4_dirdata_get(de, parent,
> +						 buf_size,
> +						 NULL, &dirent_hinfo);
> +				de_hash =3D dirent_hinfo.hash;
> +				de_minor_hash =3D dirent_hinfo.minor_hash;
> +			} else {
> +				de_hash =3D EXT4_DIRENT_HASH(de);
> +				de_minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> +			}

[Severity: High]
As reported by Sashiko on v13 [1], can the fallback reads of
EXT4_DIRENT_HASH(de) and EXT4_DIRENT_MINOR_HASH(de) read 8 bytes past rec_l=
en
and out of bounds of dir_buf or bh->b_data?

In fs/ext4/namei.c:ext4_dirdata_get(), the legacy compatibility branch chec=
ks
that rec_len is large enough to hold the inline hash before reading it:

	if (hinfo && !ext4_has_feature_dirdata(dir->i_sb) &&
	    ext4_hash_in_dirent(dir)) {
		if (ext4_dirent_rec_len(de->name_len, dir) > rec_len)
			return ret;
		hinfo->hash =3D EXT4_DIRENT_HASH(de);
		hinfo->minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
		ret |=3D EXT4_DIRENT_CFHASH;
		return ret;
	}

When ext4_has_feature_dirdata(dir->i_sb) is enabled, ext4_dirdata_get() also
verifies that any EXT4_DIRENT_LUFID, EXT4_DIRENT_INO64, and
EXT4_DIRENT_CFHASH records fit within rec_len, returning without
EXT4_DIRENT_CFHASH set in the return mask if the flag is absent or if the
entry fails the bounds checks.

However, when ext4_dirdata_get() returns without EXT4_DIRENT_CFHASH set, the
callers in fs/ext4/inline.c:ext4_inlinedir_to_tree(),
fs/ext4/namei.c:htree_dirblock_to_tree(), and fs/ext4/namei.c:dx_make_map()
unconditionally fall back to reading EXT4_DIRENT_HASH(de) and
EXT4_DIRENT_MINOR_HASH(de) when ext4_hash_in_dirent(dir) is true, without
checking that ext4_dirent_rec_len(de->name_len, dir) <=3D rec_len. Similarl=
y,
the else branches in fs/ext4/dir.c:ext4_readdir() and
fs/ext4/namei.c:ext4_match() (when called from ext4_find_dest_de()) read
EXT4_DIRENT_HASH(de) and EXT4_DIRENT_MINOR_HASH(de) without checking rec_le=
n.

On a valid casefolded and encrypted inline directory in
ext4_inlinedir_to_tree(), the synthesized "." and ".." entries in fake have
fake.rec_len =3D ext4_dirent_rec_len(fake.name_len, NULL) =3D 12, which is
smaller than ext4_dirent_rec_len(fake.name_len, dir) =3D 20. ext4_dirdata_g=
et()
returns 0, and the fallback reads 8 bytes at offset 12..19 past fake.rec_le=
n.
Likewise, on a 1-block casefolded and encrypted directory in
htree_dirblock_to_tree(), the "." entry has rec_len =3D 12, so after
ext4_dirdata_get() returns 0, the fallback reads 8 bytes from the adjacent
".." entry header.

On a crafted or corrupted casefolded and encrypted directory image,
__ext4_check_dir_entry() sets fake =3D is_fake_dir_entry(de) (which is true=
 for
"." or ".." or when de->file_type =3D=3D EXT4_FT_DIR_CSUM) and validates rl=
en
against ext4_dirent_rec_len(1, NULL) (12 bytes) and
ext4_dir_entry_len(de, size, NULL) (12 bytes for name_len <=3D 4). This all=
ows
a 12-byte fake entry with de->inode !=3D 0 at offset =3D size - 12 at the e=
nd of
the kmalloc(inline_size) buffer dir_buf or block buffer bh->b_data. When
ext4_dirdata_get() rejects the entry and returns 0, the unchecked fallback =
in
ext4_inlinedir_to_tree(), htree_dirblock_to_tree(), dx_make_map(),
ext4_readdir(), and ext4_match() reads 8 bytes at (char *)de + 12, past the
end of dir_buf or bh->b_data.

Furthermore, on a dirdata-enabled filesystem where de->file_type &
EXT4_DIRENT_CFHASH is set, if the CFHASH extension fails the bounds check in
ext4_dirdata_get(), htree_dirblock_to_tree(), dx_make_map(), and
ext4_inlinedir_to_tree() still fall back to reading EXT4_DIRENT_HASH(de) at
the legacy fixed offset, misinterpreting LUFID or out-of-bounds bytes as the
casefold hash.

[1] https://lore.kernel.org/r/20261029122413.230409-11-ablagodarenko@thelus=
trecollective.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D11
