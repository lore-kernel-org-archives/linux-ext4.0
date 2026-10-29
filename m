Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793277887;
	b=tcjF50TY59Pw4yZ1uExCpD8+XWmS6Et8OzXSsDwO20ZpMCwG8SOFU0ma6NYsfE7Doqfo
	 iXWqGkOQRGzBoE/JiNujI9BfliYONuxmqvOrwLKuwCFvC8QNsyt8W17FnS9R36cLaVos3
	 gC/wJ/tosjLBlVTYwbh+VGqVtmC9Dfo2BXooHWR01b4WdC3cf/+1mQTvpbln/FuMcoYS3
	 HUchzf6Wfx4VzdClnUDIwYTzwV0isAzKUwON1NKr1dg5hQUuH6wloJlhZOJTu8l4C/hUl
	 zV5d2k1IOGEO442Wzp9RC8MTlpyPo/Ik9srckMtuCMxp3GQSTvAqfvdds/3vkQpmRyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793277887;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oDwxNlxpK/FfyxGt6crEls2Z8E7Dwf+0rMiqv18h9w0=;
	b=Cbib1lImMEfmXwK7gGgZ96Blw083UVCkMYNNLrarzSIQgfOh9cWwk4CN/Vky2Gv6fzhK
	 LL3FjV5fqZifzadPDlJkA2QYZzATFcN8CnOow50oRYQmWry/NxHMIJMPosPIIxZHaAbKP
	 x+Ge5XHDGS/10aAcRaUXnRBrCxHmQC11jZA3RLGrcS73eHNVJsxUhqgLIPMsqW3TEtPD6
	 k4NCI86lYcFSGQUK28JygSPn9w0eOpraG0EFO1zuqXxbrmSIVC74Jh1v+u/uEX7RwbRTC
	 cWdMI3/MKER+4E8vaGxI3cTa9A0V7ChzezfUWJFj2pFAMPeJblMNAzGQqWqUbAaXD4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mMITwinf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190D6606A324
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mMITwinf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845131F031E1;
	Thu, 29 Oct 2026 12:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793277886;
	bh=oDwxNlxpK/FfyxGt6crEls2Z8E7Dwf+0rMiqv18h9w0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mMITwinfYEPE7T20I2gsPScL2SGG5zy32ZjnQcMKU1hXsgTHhPJF3RC5fi0ofJPi0
	 d07OFGQb8+3DQFBLEZKceH4zJLGZKspmOsQmI3uJFXGWikiW78GK8Kf+fHK2wAT/Hw
	 oDI/Y90PrlgPARVpLSPIsSkmZXbrpLJpaOh+16JpeG7asl1jkpihWiUYdqhhYOrKzO
	 F1zwynu9cKEPllNaTyAW/Ix3uZIT10F86WnU2raZjWknO4qB+4mVOuaQgG3KWrskr3
	 hwMj/gp9QHJ5zIBXw5xFh+DLLwr4ImCmCwP5D7U+tB3ryZey5morIYOT8K120Mw0NR
	 H8V17ZHEFV5RA==
Message-ID: <sashiko-outbox-189303@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 10/11] ext4: add dirdata set/get helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-11-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-11-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:44:46 +0000
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
- [High] ext4: out-of-bounds read in EXT4_DIRENT_HASH() fallback paths
- [High] ext4: LUFID and CFHASH corruption in ext4_setent() on whiteout rol=
lback
--

commit 539752e69c673cf26e5b8cfb8fcd2a83e0a00a76
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: add dirdata set/get helpers

This commit adds ext4_dirdata_get() and ext4_dirdata_set() helpers to read =
and
write directory entry extension payloads, and wires them into directory loo=
kup,
readdir, htree indexing, insertion, and rename paths for LUFID and
casefold+encryption hashes.

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

[ ... ]

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index d3dda1d65d067..700a0282278b0 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1364,14 +1364,20 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
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

[ ... ]

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 433bee757ea4c..5a118320eef9b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1142,22 +1142,34 @@ static int htree_dirblock_to_tree(struct file *di=
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
> +				} else {

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
> +		hinfo->hash =3D EXT4_DIRENT_HASH(de);
> +		hinfo->minor_hash =3D EXT4_DIRENT_MINOR_HASH(de);
> +		ret |=3D EXT4_DIRENT_CFHASH;
> +		return ret;
> +	}

[ ... ]

> @@ -1360,13 +1568,21 @@ static int dx_make_map(struct inode *dir, struct =
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
> +				} else {

[ ... ]

> @@ -1495,10 +1712,29 @@ static bool ext4_match(struct inode *parent,
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
> +			if (fname->hinfo.hash !=3D de_hash ||
> +			    fname->hinfo.minor_hash !=3D de_minor_hash)
> +				return false;
> +		}
>  		/*
>  		 * Treat comparison errors as not a match.  The
>  		 * only case where it happens is on a disk
> @@ -1529,11 +1765,18 @@ int ext4_search_dir(struct buffer_head *bh, char =
*search_buf, int buf_size,
>  	dlimit =3D search_buf + buf_size;
>  	while ((char *) de < dlimit - EXT4_BASE_DIR_LEN) {
>  		/* this code is executed quadratically often */
> -		/* do minimal checking `by hand' */
> +		/* Decode rec_len before ext4_match() so that ext4_dirdata_get()
> +		 * inside ext4_match() never uses an unvalidated rec_len as a
> +		 * read bound.  A crafted entry with rec_len > buf_size would
> +		 * let ext4_dirdata_get() read past the block buffer. */
> +		de_len =3D ext4_rec_len_from_disk(de->rec_len,
> +						dir->i_sb->s_blocksize);
> +		if (de_len <=3D 0 || (char *)de + de_len > dlimit)
> +			return -EFSCORRUPTED;
>  		if (de->name + de->name_len <=3D dlimit &&
>  		    (!ext4_hash_in_dirent(dir) ||
>  		     (char *)de + ext4_dirent_rec_len(de->name_len, dir) <=3D dlimit) =
&&
> -		    ext4_match(dir, fname, de)) {
> +		    ext4_match(dir, fname, de, buf_size)) {

[Severity: High]
Can the EXT4_DIRENT_HASH(de) and EXT4_DIRENT_MINOR_HASH(de) fallback paths
read 8 bytes past the end of bh->b_data or dir_buf?

In fs/ext4/ext4.h:ext4_dirent_rec_len(), when EXT4_FEATURE_INCOMPAT_DIRDATA
is enabled on a casefolded and encrypted directory, sizeof(struct
ext4_dir_entry_hash) is not added to rec_len:

	if (dir && ext4_hash_in_dirent(dir) &&
	    !ext4_has_feature_dirdata(dir->i_sb))
		rec_len +=3D sizeof(struct ext4_dir_entry_hash);
	return (rec_len & ~EXT4_DIR_ROUND);

Because of this, both __ext4_check_dir_entry() and the pre-check in
fs/ext4/namei.c:ext4_search_dir() accept a trailing entry without
EXT4_DIRENT_CFHASH (or with a malformed CFHASH header where
ext4_dirent_get_data_len() and ext4_dirdata_get() return 0) whose rec_len is
((de->name_len + 8 + EXT4_DIR_ROUND) & ~EXT4_DIR_ROUND) right at the end of
the buffer.

However, EXT4_DIRENT_HASHES(de) starts at offset ((8 + de->name_len +
EXT4_DIR_ROUND) & ~EXT4_DIR_ROUND) and reads 8 bytes from that offset. When
fs/ext4/dir.c:ext4_readdir(), fs/ext4/inline.c:ext4_inlinedir_to_tree(),
fs/ext4/namei.c:htree_dirblock_to_tree(), fs/ext4/namei.c:dx_make_map(), or
fs/ext4/namei.c:ext4_match() falls back to EXT4_DIRENT_HASH(de) and
EXT4_DIRENT_MINOR_HASH(de) without checking that those 8 bytes fit within
rec_len, doesn't that read 8 bytes past de + rec_len and past the end of
bh->b_data or the kmalloc(inline_size, GFP_NOFS) buffer dir_buf?

Similarly, in fs/ext4/namei.c:ext4_dirdata_get(), the non-dirdata
compatibility branch only checks:

	if (EXT4_BASE_DIR_LEN + data_offset > rec_len)
		return ret;

which verifies 8 + de->name_len + 1 <=3D rec_len before reading 8 bytes at
((8 + de->name_len + EXT4_DIR_ROUND) & ~EXT4_DIR_ROUND). And in
fs/ext4/inline.c:ext4_inlinedir_to_tree(), the synthesized "." and ".."
entries use an uninitialized stack variable fake with rec_len =3D=3D 12 and=
 no
EXT4_DIRENT_CFHASH bit, causing both ext4_dirdata_get() and the fallback to
read 8 bytes of uninitialized kernel stack from fake.name[4..11] and pass
them to ext4_htree_store_dirent().

Should all legacy EXT4_DIRENT_HASH(de) reads verify that
((EXT4_BASE_DIR_LEN + de->name_len + EXT4_DIR_ROUND) & ~EXT4_DIR_ROUND) +
sizeof(struct ext4_dir_entry_hash) <=3D rec_len first?

[ ... ]

> @@ -3746,6 +3974,43 @@ static int ext4_rename_dir_finish(handle_t *handle=
, struct ext4_renament *ent,
>  	return 0;
>  }
> =20
> +/*
> + * When LUFID is cleared from an entry that also carries CFHASH, the CFH=
ASH
> + * bytes are stranded: LUFID precedes CFHASH in the layout, so removing =
LUFID
> + * shifts the expected CFHASH offset.  Slide CFHASH into the vacated slo=
t so
> + * the parser finds it at the right position.  If the headers are malfor=
med,
> + * clear CFHASH instead of risking a corrupt read.
> + */
> +static void ext4_setent_compact_exts(struct ext4_renament *ent,
> +				     struct ext4_dirent_data_header *lddh,
> +				     unsigned int lufid_off,
> +				     unsigned int rec_len)
> +{
> +	struct ext4_dirent_data_header *cddh;
> +	unsigned int coff;
> +
> +	if (!(ent->de->file_type & EXT4_DIRENT_CFHASH))
> +		return;
> +	if (lufid_off + sizeof(*lddh) > rec_len ||
> +	    !lddh->ddh_length ||
> +	    lufid_off + lddh->ddh_length > rec_len) {
> +		ent->de->file_type &=3D ~EXT4_DIRENT_CFHASH;
> +		return;
> +	}
> +
> +	coff =3D lufid_off + lddh->ddh_length;
> +	cddh =3D (struct ext4_dirent_data_header *)((char *)ent->de + coff);
> +
> +	if (coff + sizeof(*cddh) > rec_len ||
> +	    !cddh->ddh_length ||
> +	    coff + cddh->ddh_length > rec_len) {
> +		ent->de->file_type &=3D ~EXT4_DIRENT_CFHASH;
> +		return;
> +	}
> +
> +	memmove(lddh, cddh, cddh->ddh_length);
> +}
> +
>  static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
>  		       unsigned ino, unsigned file_type,
>  		       const struct ext4_dirent_fid *src_fid)
> @@ -3786,13 +4051,25 @@ static int ext4_setent(handle_t *handle, struct e=
xt4_renament *ent,
>  				if (ddh_off + sizeof(*ddh) > rec_len ||
>  				    ddh->ddh_length !=3D copy_len ||
>  				    ddh_off + copy_len > rec_len) {
> -					/* Cannot copy: clear the flag so the
> -					 * slot does not advertise a stale LUFID
> -					 * from the old inode. */
> +					/* Cannot copy in-place (size mismatch).
> +					 * If CFHASH is also present, slide it
> +					 * into the LUFID slot so the parser
> +					 * finds it at the correct offset after
> +					 * the LUFID flag is cleared. */
> +					ext4_setent_compact_exts(ent, ddh,
> +							ddh_off, rec_len);
>  					ent->de->file_type &=3D ~EXT4_DIRENT_LUFID;
>  				} else {
>  					memcpy(ddh, src_fid, copy_len);
>  				}
> +			} else if (src_fid) {
> +				/* Destination has no LUFID slot; cannot
> +				 * propagate in-place.  Clear the flag from
> +				 * the on-disk entry directly =E2=80=94 clearing only
> +				 * the local file_type variable has no effect
> +				 * because the final assignment takes the high
> +				 * bits from ent->de->file_type, not file_type. */
> +				ent->de->file_type &=3D ~EXT4_DIRENT_LUFID;
>  			} else if (!src_fid) {
>  				/* Sync the LUFID flag with what file_type requests.
>  				 * For normal rename (source has no LUFID) and for
> @@ -3800,7 +4077,24 @@ static int ext4_setent(handle_t *handle, struct ex=
t4_renament *ent,
>  				 * so we clear the stale flag.  For ext4_resetent
>  				 * (error recovery), file_type is the original
>  				 * file_type with LUFID=3D1, so we restore the flag =E2=80=94
> -				 * the LUFID bytes are still on disk untouched. */
> +				 * the LUFID bytes are still on disk untouched.
> +				 * When clearing LUFID and CFHASH is present, slide
> +				 * CFHASH bytes into the LUFID slot first so the
> +				 * parser finds CFHASH at the expected offset. */
> +				if (!(file_type & EXT4_DIRENT_LUFID) &&
> +				    (ent->de->file_type & EXT4_DIRENT_LUFID)) {
> +					unsigned int loff =3D
> +						EXT4_BASE_DIR_LEN +
> +						ent->de->name_len + 1;
> +					unsigned int rlen =3D
> +						ext4_rec_len_from_disk(
> +							ent->de->rec_len,
> +							ent->dir->i_sb->s_blocksize);
> +					ext4_setent_compact_exts(ent,
> +						(struct ext4_dirent_data_header *)
> +						((char *)ent->de + loff),
> +						loff, rlen);
> +				}
>  				ent->de->file_type =3D
>  					(ent->de->file_type & ~EXT4_DIRENT_LUFID) |
>  					(file_type & EXT4_DIRENT_LUFID);

[Severity: High]
Does calling ext4_setent_compact_exts() here corrupt old.de when a
RENAME_WHITEOUT rename fails and rolls back via ext4_resetent()?

In fs/ext4/namei.c:ext4_rename(), when whiteout is non-NULL and old.de has
both EXT4_DIRENT_LUFID and EXT4_DIRENT_CFHASH set, ext4_rename() first
updates old.de to point to the whiteout inode before adding the new entry:

	if (whiteout) {
		retval =3D ext4_setent(handle, &old, whiteout->i_ino,
				     EXT4_FT_CHRDEV, NULL);
		if (retval)
			goto end_rename;
	}
	if (!new.de) {
		retval =3D ext4_add_entry(handle, new.dentry, old.inode,
					old_fid);

Inside that first ext4_setent() call, src_fid is NULL and file_type is
EXT4_FT_CHRDEV (which does not have EXT4_DIRENT_LUFID set), so
ext4_setent_compact_exts() memmoves the 9-byte CFHASH extension over the
on-disk LUFID slot at loff =3D EXT4_BASE_DIR_LEN + old.de->name_len + 1.

If ext4_add_entry() (or a subsequent step) fails, execution jumps to
end_rename:

end_rename:
	kfree(edp);
	ext4_lufid_snap_release(&old_snap);
	if (whiteout) {
		if (retval) {
			ext4_resetent(handle, &old,
				      old.inode->i_ino, old_file_type);

ext4_resetent() calls ext4_setent(handle, &old, old.inode->i_ino,
old_file_type, NULL). The comment in the !src_fid branch assumes the LUFID
bytes are still on disk untouched, and sets EXT4_DIRENT_LUFID back to 1 in
old.de->file_type. However, the LUFID slot was already overwritten with the
CFHASH bytes during the whiteout step, leaving old.de with both
EXT4_DIRENT_LUFID and EXT4_DIRENT_CFHASH set in file_type, the CFHASH sitti=
ng
in the LUFID slot, and stale bytes at the post-LUFID offset where
ext4_dirdata_get() will look for CFHASH.

Also, in ext4_setent_compact_exts(), should coff account for
EXT4_DIRENT_INO64 if that flag is set between EXT4_DIRENT_LUFID and
EXT4_DIRENT_CFHASH, matching the layout in ext4_dirdata_get()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D10
