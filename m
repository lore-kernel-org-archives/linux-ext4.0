Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716077;
	b=dGjdGGf8wje22cy9hkamRXFELoSTtxMST2C+OpbOkmMBFsMM9rSDRVJR6EyPGel4AOJP
	 eymnSitnTQkWaZRNpsPHVi0PMT2DDhfBw8LZqjoBaLDzg700PWaLGeby6GaGjOmXVCRuH
	 RK2xmehH+jIW9uWBQSHjNlaQuoXXNuoyHENhcIKy/zZkEIv6ZZvQ6bO68bLxulAEZLjcO
	 juGqW0QiLZ19YxALC1gDF8xzQWAc6Uo9i991NdFovuInRUAvJoVdccNFHXgn/uO5QCbyN
	 5y6quUaQiIzkewA0pbnu/4shQYoHsIPS0eZL1hEr8Iot/rXm6nlKvNm0bcjVASmmnzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716077;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FeDnU8KB6+CZXJ+wIJ3uVM8oZocvmy4351okabHBgoM=;
	b=Ha9J786IYvtr/sLjTEWCXhC6jcMJLv4GK+u0tP68B2tr0dTWnqX6pmidy0seHPMdrAwa
	 yzW3GTJBU6gt3GDhse0SdXMY4DXq57cDVM+zhHkmnNCbWGdKXdr6mGHiEVc2ssQnjftHS
	 3CBviwKK5yqc8c0zdtFr9WcqGh6Uu/yTVj3/r42vmXoSEd/cOePY0vingjDZ93NcD6Gqt
	 tJxfh3xm8dh3I3oukjFcL4Nj9Da9KkYGJzEHo/tgGsaKUkMuZMPr9n0ka/iLzWQ7mbYPR
	 lQD50KidfU9FhP38M1HDCYcAkKsnYuNLACR8yFWwtu/MXoULjireKPHjmAPiR/vfaNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kpwAbnCj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5189F606A329
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kpwAbnCj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0797A1F000C1;
	Tue,  3 Nov 2026 14:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793716077;
	bh=FeDnU8KB6+CZXJ+wIJ3uVM8oZocvmy4351okabHBgoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kpwAbnCjzPq+rCtca94YtoYK9MnGmV/co3Gxp5AYm/x29hJBOqW1IT607tyw3vlna
	 gzqQtqIMnYN5wSgPBlIQga/eJ9Jh9kYCPBi9Sr0AfvAjWnN2fijXAnhZeoP9Tzavg6
	 0YcS0ytz14hUUfuRue4iZ+BEQftk41KpDTzTggEa9LXQqfYfNDfiETcS3N2RMPMaa8
	 Rk3OxTvtc/oX2APPBu+6ySJYuzERQeaeN5l250WKX+rZIrcI6raieFIvnmZv8uC+Rh
	 Kv9mhDAE8HI04bexOLPu6S3sh/grXtuqdcEeES7RThqXFEbnvuQH+SHcjPYCw7nuj+
	 xltpuL/jF8Rxw==
Message-ID: <sashiko-outbox-195446@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 09/12] ext4: dirdata feature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-10-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-10-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:27:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] ext4: integer underflow and buffer overflow in make_indexed_di=
r()
- [High] ext4: inconsistent dx_root_info offset in make_indexed_dir()
- [Medium] ext4: malformed dirdata ignored in ext4_dirent_get_data_len()
- [Medium] ext4: silent corruption ignore in ext4_inlinedir_to_tree()
- [Low] ext4: dead dirdata allocation and copy in ext4_htree_store_dirent()
--

commit fdb43b700545f38bf31e5431287beaf2f0e358b1
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: dirdata feature

This commit enables the EXT4_FEATURE_INCOMPAT_DIRDATA feature flag and
updates directory entry sizing, insertion, and htree handling to account
for variable-length dirdata records stored after the filename.

> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 38911ae2bcfc0..15816f2a5f472 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -483,27 +483,43 @@ void ext4_htree_free_dir_info(struct dir_private_in=
fo *p)
>   * The decrypted filename is passed in via ent_name.  parameter.
>   */
>  int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
> -			     __u32 minor_hash,
> +			     __u32 minor_hash, int buf_size,
>  			    struct ext4_dir_entry_2 *dirent,
>  			    struct fscrypt_str *ent_name)
>  {
>  	struct rb_node **p, *parent =3D NULL;
>  	struct fname *fname, *new_fn;
>  	struct dir_private_info *info;
> +	int extra_data =3D 0;
> =20
>  	info =3D dir_file->private_data;
>  	p =3D &info->root.rb_node;
> =20
>  	/* Create and allocate the fname structure */
> -	new_fn =3D kzalloc_flex(*new_fn, name, ent_name->len + 1);
> +	if (dirent->file_type & ~EXT4_FT_MASK) {
> +		unsigned int rec_len =3D
> +			ext4_rec_len_from_disk(dirent->rec_len, buf_size);
> +		extra_data =3D ext4_dirent_get_data_len(dirent, rec_len);
> +	}
> +
> +	/* exta_data contains +1 byte for NULL */
> +	new_fn =3D kzalloc_flex(*new_fn, name, ent_name->len +
> +			      (extra_data ? extra_data : 1));
>  	if (!new_fn)
>  		return -ENOMEM;
>  	new_fn->hash =3D hash;
>  	new_fn->minor_hash =3D minor_hash;
>  	new_fn->inode =3D le32_to_cpu(dirent->inode);
> -	new_fn->name_len =3D ent_name->len;
>  	new_fn->file_type =3D dirent->file_type;
> +	new_fn->name_len =3D ent_name->len;
>  	memcpy(new_fn->name, ent_name->name, ent_name->len);
> +	if (extra_data)
> +		/* Dirdata bytes lie past the __counted_by(name_len) bound but
> +		 * within the kzalloc_flex allocation; use unsafe_memcpy to
> +		 * avoid a FORTIFY_SOURCE false positive. */
> +		unsafe_memcpy(new_fn->name + ent_name->len,
> +			      dirent->name + dirent->name_len, extra_data,
> +			      /* within kzalloc_flex allocation */);

[Severity: Low]
Is there any consumer of the extra_data bytes copied into new_fn->name?

In fs/ext4/dir.c, struct fname is defined privately with:

	__u8		name_len;
	__u8		file_type;
	char		name[] __counted_by(name_len);

and its only reader is call_filldir(), which only passes fname->name and
fname->name_len to dir_emit():

	while (fname) {
		if (!dir_emit(ctx, fname->name,
				fname->name_len,
				fname->inode,
				get_dtype(sb, fname->file_type))) {
			info->extra_fname =3D fname;
			return 1;
		}
		fname =3D fname->next;
	}

In addition, kzalloc_flex() internally runs __set_flex_counter() to store
ent_name->len + extra_data into __u8 new_fn->name_len (which truncates if
the sum exceeds 255) before new_fn->name_len =3D ent_name->len overwrites i=
t.

Since nothing reads the trailing dirdata bytes from struct fname, can the
extra_data allocation, unsafe_memcpy(), and the buf_size parameter to
ext4_htree_store_dirent() be dropped?

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index e42e5bcc2f28f..4a7b36e1910ee 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2369,6 +2369,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(casefold,		CASEFOLD)
>  					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
>  					 EXT4_FEATURE_INCOMPAT_EA_INODE| \
>  					 EXT4_FEATURE_INCOMPAT_MMP | \
> +					 EXT4_FEATURE_INCOMPAT_DIRDATA | \
>  					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
>  					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
>  					 EXT4_FEATURE_INCOMPAT_CASEFOLD | \

[ ... ]

> @@ -4278,6 +4307,42 @@ static inline unsigned int ext4_dir_entry_len(stru=
ct ext4_dir_entry_2 *de,
>  		   ext4_dirent_rec_len(de->name_len, dir));
>  }

[Severity: Medium]
With EXT4_FEATURE_INCOMPAT_DIRDATA now enabled in EXT4_FEATURE_INCOMPAT_SUP=
P,
what happens when a directory entry has dirdata flags set in de->file_type
(~EXT4_FT_MASK), but a dirdata header is truncated, zero-length, or exceeds
the entry's current rec_len?

In ext4_dirent_get_data_len():

	if (offset >=3D rec_len)
		return 0;
	...
	while (extra_data_flags) {
		if (extra_data_flags & 1) {
			if (offset + sizeof(*ddh) > rec_len)
				return 0;
			{
				u8 ddh_len =3D READ_ONCE(ddh->ddh_length);

				if (ddh_len =3D=3D 0 || ddh_len > rec_len - offset)
					return 0;

returning 0 on malformed dirdata causes ext4_dir_entry_len() to return the
bare filename record length, so __ext4_check_dir_entry() accepts the entry:

	else if (unlikely(rlen < ext4_dir_entry_len(de, size, fake ? NULL : dir)))
		error_msg =3D "rec_len is too small for name_len";

This seems to allow two forms of corruption on subsequent directory
modifications:

1. Because ext4_dirent_get_data_len() depends on the entry's current
rec_len, expanding rec_len later (for example, in make_indexed_dir(),
do_split(), or ext4_generic_delete_entry()) can cause a previously
out-of-bounds ddh_length byte in trailing space to become <=3D rec_len - of=
fset,
increasing ext4_dir_entry_len(de, ...) after the entry was already validate=
d.

2. If an entry has multiple dirdata flags set (such as EXT4_DIRENT_LUFID |
EXT4_DIRENT_CFHASH) where the first record is valid and the second has an
invalid ddh_length, ext4_dirent_get_data_len() returns 0 and drops the first
record's length as well. When ext4_insert_dentry_data(), dx_move_dirents(),
or dx_pack_dirents() then splits or compacts the entry using
ext4_dir_entry_len(), can it shrink de->rec_len to the bare filename length
and overwrite the valid first record while leaving the dirdata flags set in
de->file_type?

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index bdf6f45a3de48..81e0ef1c88337 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c

[ ... ]

> @@ -1337,14 +1339,24 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
>  			de =3D &fake;
>  			pos =3D EXT4_INLINE_DOTDOT_SIZE;
>  		} else {
> +			if (pos + EXT4_BASE_DIR_LEN > inline_size) {
> +				ret =3D count;
> +				goto out;
> +			}
>  			de =3D (struct ext4_dir_entry_2 *)(dir_buf + pos);
> -			pos +=3D ext4_rec_len_from_disk(de->rec_len, inline_size);
> +			de_len =3D ext4_rec_len_from_disk(de->rec_len, inline_size);
> +			if (de_len < EXT4_BASE_DIR_LEN ||
> +			    pos + de_len > (unsigned int)inline_size) {
> +				ret =3D count;
> +				goto out;
> +			}
>  			if (ext4_check_dir_entry(inode, dir_file, de,
>  					 iloc.bh, dir_buf,
>  					 inline_size, pos)) {
>  				ret =3D count;
>  				goto out;
>  			}
> +			pos +=3D de_len;
>  		}

[Severity: Medium]
Does checking de_len < EXT4_BASE_DIR_LEN and pos + de_len > inline_size
before ext4_check_dir_entry() suppress filesystem corruption reporting in
ext4_inlinedir_to_tree()?

In __ext4_check_dir_entry(), rlen < ext4_dirent_rec_len(1, ...),
rlen % 4 !=3D 0, and next_offset > size are already checked before calling
ext4_dir_entry_len(), and any failure logs the error via ext4_error_file()
and triggers the filesystem's error policy:

	if (unlikely(rlen < ext4_dirent_rec_len(1, fake ? NULL : dir)))
		error_msg =3D "rec_len is smaller than minimal";
	else if (unlikely(rlen % 4 !=3D 0))
		error_msg =3D "rec_len % 4 !=3D 0";
	else if (unlikely(next_offset > size))
		error_msg =3D "directory entry overrun";
	else if (unlikely(rlen < ext4_dir_entry_len(de, size, fake ? NULL : dir)))
		error_msg =3D "rec_len is too small for name_len";

Because ext4_rec_len_from_disk(de->rec_len, inline_size) maps rec_len =3D=
=3D 0
or 0xffff to inline_size (making pos + de_len > inline_size since pos >=3D =
4)
and shifts unaligned low bits by 16 (making de_len >=3D 65536 > inline_size=
),
jumping to out on de_len < EXT4_BASE_DIR_LEN or pos + de_len > inline_size
before calling ext4_check_dir_entry() causes corrupted inline directory
entries (such as rec_len =3D=3D 0, rec_len =3D=3D 4, unaligned rec_len, or =
entry
overruns) to silently return a partial entry count without calling
ext4_check_dir_entry().

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 0c91e4da00fbc..4f0465d498877 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -402,23 +402,33 @@ static struct dx_countlimit *get_dx_countlimit(stru=
ct inode *inode,
>  {
>  	struct ext4_dir_entry_2 *de;
>  	struct dx_root_info *root;
> -	int count_offset;
> +	int count_offset, dotdot_rec_len;
>  	int blocksize =3D EXT4_BLOCK_SIZE(inode->i_sb);
>  	unsigned int rlen =3D ext4_rec_len_from_disk(dirent->rec_len, blocksize=
);
> =20
> -	if (rlen =3D=3D blocksize)
> +	if (rlen =3D=3D blocksize) {
>  		count_offset =3D sizeof(struct dx_node);
> -	else if (rlen =3D=3D 12) {
> -		de =3D (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
> -		if (ext4_rec_len_from_disk(de->rec_len, blocksize) !=3D blocksize - 12)
> +	} else {
> +		if (rlen < EXT4_BASE_DIR_LEN ||
> +		    rlen + EXT4_BASE_DIR_LEN > blocksize)
>  			return NULL;
> -		root =3D (struct dx_root_info *)(((void *)de + 12));
> +		de =3D (struct ext4_dir_entry_2 *)(((char *)dirent) + rlen);
> +		if (ext4_rec_len_from_disk(de->rec_len, blocksize) !=3D
> +		    (unsigned int)(blocksize - rlen))
> +			return NULL;
> +		/* de->rec_len covers whole dx_root block, calculate actual length.
> +		 * This is the '..' entry, which never carries the casefold+fscrypt
> +		 * hash, so pass NULL for dir regardless of the directory's flags */
> +		dotdot_rec_len =3D ext4_dir_entry_len(de, blocksize, NULL);
> +		if (rlen + dotdot_rec_len + sizeof(struct dx_root_info) +
> +		    sizeof(struct dx_countlimit) > blocksize)
> +			return NULL;
> +		root =3D (struct dx_root_info *)(((char *)de + dotdot_rec_len));
>  		if (root->reserved_zero ||
>  		    root->info_length !=3D sizeof(struct dx_root_info))
>  			return NULL;
> -		count_offset =3D 32;
> -	} else
> -		return NULL;
> +		count_offset =3D root->info_length + rlen + dotdot_rec_len;
> +	}
> =20
>  	if (offset)
>  		*offset =3D count_offset;

[Severity: High]
Can make_indexed_dir() and get_dx_countlimit() disagree on the offset of
dx_root_info when converting a single-block directory to an htree-indexed
directory?

In __ext4_add_entry() -> make_indexed_dir(), dx_get_dx_info(dir, dot_de) is
first called before dotdot_de->rec_len is expanded:

	/* Find room for the hashing info before the directory is changed */
	dx_info =3D dx_get_dx_info(dir, dot_de);
	...
	memcpy(data2, de, len);
	memset(de, 0, len); /* wipe old data */
	...
	/* Initialize the root; the dot dirents already exist */
	dotdot_de->rec_len =3D
		ext4_rec_len_to_disk(blocksize - le16_to_cpu(dot_de->rec_len),
				     blocksize);
	...
	entries =3D (void *)dx_info + dx_info->info_length;
	dx_set_block(entries, 1);
	dx_set_count(entries, 1);
	dx_set_limit(entries, dx_root_limit(dir, dot_de));

If dotdot_de initially has rec_len =3D=3D 12, a dirdata flag set in
dotdot_de->file_type, and a byte at offset 11 of dotdot_de (ddh_length) > 1,
then during the first dx_get_dx_info(dir, dot_de) call,
ext4_dirent_get_data_len(dotdot_de, 12) sees ddh_len > 12 - 11 and returns =
0.
Thus dotdot_rec_len is 12 and dx_info is placed immediately after dotdot_de
(at offset 24), while memset(de, 0, len) only wipes from offset 24 onwards,
leaving byte 11 of dotdot_de untouched.

Once dotdot_de->rec_len is expanded to blocksize - le16_to_cpu(dot_de->rec_=
len),
calling dx_root_limit(dir, dot_de) -> dx_get_dx_info(dir, dot_de) and
ext4_handle_dirty_dx_node() -> get_dx_countlimit() evaluates
ext4_dir_entry_len(dotdot_de, blocksize, NULL) with the expanded rec_len.
Now ddh_len <=3D rec_len - 11 is satisfied, so ext4_dir_entry_len() returns=
 a
larger dotdot_rec_len and looks for dx_root_info and dx_countlimit at a
shifted offset instead of where make_indexed_dir() just wrote dx_info and
entries.

[ ... ]

> @@ -2467,7 +2490,8 @@ static int make_indexed_dir(handle_t *handle, struc=
t ext4_filename *fname,
>   */
>  static int __ext4_add_entry(handle_t *handle, struct inode *dir,
>  			  const struct qstr *d_name,
> -			  struct inode *inode)
> +			  struct inode *inode,
> +			  struct ext4_dentry_param *edp)

[Severity: Critical]
Can len underflow in make_indexed_dir() when metadata_csum is enabled and
dot_de / dotdot_de carry dirdata or large rec_len values?

In __ext4_add_entry(), when add_dirent_to_buf() -> ext4_find_dest_de()
searches block 0 of a 1-block directory with metadata_csum enabled
(csum_size =3D 12), top is set to:

	top =3D buf + buf_size - reclen;

where buf_size is blocksize - csum_size. If dot_de at offset 0 has a large
rec_len filled by dirdata (for example, blocksize =3D 1024, buf_size =3D 10=
12,
dot_de rec_len =3D 808 with dirdata nlen =3D 808) and a new entry has
reclen =3D 208 (so top =3D buf + 804), ext4_find_dest_de() checks dot_de on=
 the
first iteration, advances de to buf + 808 > top, and returns -ENOSPC without
ever validating dotdot_de at offset 808.

__ext4_add_entry() then calls make_indexed_dir(), where ext4_check_dx_root()
and dx_get_dx_info() check dotdot_de against blocksize without accounting f=
or
csum_size at the end of the block:

	de =3D ext4_next_entry(dotdot_de, blocksize);
	if ((char *)de >=3D (((char *)dot_de) + blocksize)) {
		error_msg =3D "invalid rec_len for '..'";
		goto corrupted;
	}

If dotdot_de ends in the checksum tail region between blocksize - csum_size
and blocksize (for example, offset 808 + rec_len 212 =3D 1020 > 1012), both
ext4_check_dx_root() and dx_get_dx_info() succeed, and make_indexed_dir()
computes an unsigned len:

	/* The 0th block becomes the root, move the dirents out */
	len =3D ((char *)dot_de) + (blocksize - csum_size) - (char *)de;
	...
	memcpy(data2, de, len);
	memset(de, 0, len); /* wipe old data */

Because (char *)de > (char *)dot_de + (blocksize - csum_size), unsigned len
underflows (e.g. 1012 - 1020 =3D 0xfffffff8) and overflows data2 (bh2->b_da=
ta)
in memcpy() and de (bh->b_data) in memset(). Even when (char *)de equals
(char *)dot_de + (blocksize - csum_size), len becomes 0, leaving bh2 with no
directory entries for do_split().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D9
