Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715653;
	b=ukNMwNA+hOHRs0FYvZs+8lrwcRyguxGysVG0X5sMuz3uIv6kKjDqOZ2p5qmOpG1BqNgR
	 fqkbotaApOA3dxGoTkBhW08imbSPRLQW8C967HK1vSSlMLKSH8J92MkvXSGitDlYQldDg
	 ikBtv2qu2n3Snpj2GBQIJ1cwOwp8Bq5V1trsV/FiHjLXbrOuNvaEvB4Hl26gs7h3/yuhg
	 eLbJP2ToR6ffh8cb9uHeptMEMdWOTo0tw+9P9R5Fm45sB37mE0WI50mHj7KiqdS1qtraQ
	 J+0ds+aOI+zzjHUOiB6MkjKmENq8HoyU34P8J+v5cKl1q7KeY5I4K0uvFQmbmq0LWmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715653;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ct71trRWekLr34CMmY5GHvEvWZMhkJsm5q5aNLfLXtc=;
	b=W7oxYC/4pyexViU6kLWBuoR2morQ5TabYXXzmYxJCttuvWDU4RKGnC1itRnjVXVvGpN6
	 CfoJn33+B8lHhIHMDMTCHjuOSLTob5YanvUEuET7fygsWay5aZKAvNnDBev71kxVpWEUk
	 U6DDSjkkFHmB8x9FSMqTQcF2171opgArOlBCAgrc9S4/AS49Iw81LwDxdWiDBsGSXNqEf
	 icJhUHwUYFds7GiRx4LDyLliYWYb3Uzsi+zryWkgYHHX+dbgFDEfbOmFx0Dfgr+cR6Pbu
	 E1WhlAipoiUSuVX10UsDImRpdio97eeIEJSrB5jUEmler6Mir3zFX2lYDZe4E4HFjMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N2IQsOQe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51941606D835
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N2IQsOQe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018821F0093A;
	Tue,  3 Nov 2026 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715653;
	bh=ct71trRWekLr34CMmY5GHvEvWZMhkJsm5q5aNLfLXtc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N2IQsOQezJv+j01lnoZMDX9d2FqbIL0BVhS2WW55IHBPlPZyQMEWpq76T3eN5Zi1g
	 //Z1lLu+yc/6SeoL/FuOE2ePrbm5B5qIWPGW/nnsrYD8HL8LILVn4Z4lnf1F7akMft
	 zT7sN9+db9KqS1YnLwyPL//638QSeuJPtEvrXRdxwlpJPvFSIrklhMg2Wd7m1qDKL7
	 tKlUG8/2iU1UHOg1emtXIOF+f5CGpC3QjscvWnJgdLcZci53RHI9rg6/AXGkEJdDr+
	 iszix8TeGCu2nd1LeNoTG9duaFH5t4c7xvDGLb/jlH7Am1KWFe2nDAKkuRtwH8BnVb
	 ltC3ApIhEoHwQ==
Message-ID: <sashiko-outbox-195439@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 08/12] ext4: rename ext4_dir_rec_len() and clarify
 dirdata usage
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-9-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-9-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:20:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] ext4: unsigned len underflow in make_indexed_dir() when dot_de=
 has dirdata
- [High] ext4: __ext4_check_dir_entry() misses out-of-bounds dirdata before=
 rec_len grows
- [High] ext4: add_dirent_to_buf() error return after do_split() leaves bh =
undirtied
--

commit 06e0b22cf991d67d7b351c0723ad5474e253ef41
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: rename ext4_dir_rec_len() and clarify dirdata usage

This commit renames ext4_dir_rec_len() to ext4_dirent_rec_len(), updates
directory entry length calculations to use ext4_dir_entry_len() so dirdata
is accounted for, and adds a room check in add_dirent_to_buf() for split
blocks.

> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 8d7b81e6948e7..38911ae2bcfc0 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -89,16 +89,15 @@ int __ext4_check_dir_entry(const char *function, unsi=
gned int line,
>  	bool fake =3D is_fake_dir_entry(de);
>  	bool has_csum =3D ext4_has_feature_metadata_csum(dir->i_sb);
> =20
> -	if (unlikely(rlen < ext4_dir_rec_len(1, fake ? NULL : dir)))
> +	if (unlikely(rlen < ext4_dirent_rec_len(1, fake ? NULL : dir)))
>  		error_msg =3D "rec_len is smaller than minimal";
>  	else if (unlikely(rlen % 4 !=3D 0))
>  		error_msg =3D "rec_len % 4 !=3D 0";
> -	else if (unlikely(rlen < ext4_dir_rec_len(de->name_len,
> -							fake ? NULL : dir)))
> -		error_msg =3D "rec_len is too small for name_len";
>  	else if (unlikely(next_offset > size))
>  		error_msg =3D "directory entry overrun";
> -	else if (unlikely(next_offset > size - ext4_dir_rec_len(1,
> +	else if (unlikely(rlen < ext4_dir_entry_len(de, size, fake ? NULL : dir=
)))
> +		error_msg =3D "rec_len is too small for name_len";

[Severity: High]
As reported by Sashiko on v13 [1], can __ext4_check_dir_entry() ever reject
an entry whose on-disk rec_len is too small for its dirdata here, or does a
later rec_len expansion cause stale buffer bytes to be annexed into the
entry?

In ext4_dir_entry_len(), ext4_dirent_get_data_len(de, rec_len) validates
each dirdata header against the entry's current rec_len and returns 0 when
offset >=3D rec_len, offset + sizeof(*ddh) > rec_len, or ddh_len > rec_len -
offset:

fs/ext4/ext4.h:ext4_dirent_get_data_len() {
    ...
	if (offset >=3D rec_len)
		return 0;
    ...
		if (extra_data_flags & 1) {
			if (offset + sizeof(*ddh) > rec_len)
				return 0;
			{
				u8 ddh_len =3D READ_ONCE(ddh->ddh_length);

				if (ddh_len =3D=3D 0 || ddh_len > rec_len - offset)
					return 0;
				dlen +=3D ddh_len + (dlen =3D=3D 0);
				offset +=3D ddh_len;
    ...
}

Because rlen % 4 !=3D 0 is already checked earlier in
__ext4_check_dir_entry(), any non-zero dirdata returned by
ext4_dirent_get_data_len() satisfies 8 + de->name_len + dirdata =3D=3D offs=
et
<=3D rlen, so ext4_dirent_rec_len(de->name_len + dirdata, NULL) <=3D rlen.
When a corrupted entry has dirdata flags set with ddh_length exceeding its
current rec_len, ext4_dirent_get_data_len() returns 0 and
__ext4_check_dir_entry() accepts the entry.

Later, during do_split(), dx_move_dirents() and dx_pack_dirents() compute
rec_len =3D ext4_dir_entry_len(de, blocksize, dir) while de->rec_len still
has its smaller pre-split value, copying only those bytes before do_split()
expands the last entry's rec_len to the end of the half-block. Once
de->rec_len grows (either in do_split() or after
ext4_generic_delete_entry()), subsequent calls to ext4_dir_entry_len() in
add_dirent_to_buf() and ext4_insert_dentry() see the larger rec_len, so the
previously out-of-bounds ddh_length now satisfies ddh_len <=3D rec_len -
offset and annexes uncopied or stale buffer bytes into the directory entry.

[ ... ]

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 9953583ad6c3f..0c91e4da00fbc 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -2122,10 +2122,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t=
 *handle, struct inode *dir,
>  int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
>  		      void *buf, int buf_size,
>  		      struct ext4_filename *fname,
> -		      struct ext4_dir_entry_2 **dest_de)
> +		      struct ext4_dir_entry_2 **dest_de,
> +		      int dlen)
>  {
>  	struct ext4_dir_entry_2 *de;
> -	unsigned short reclen =3D ext4_dir_rec_len(fname_len(fname), dir);
> +	unsigned short reclen =3D ext4_dirent_rec_len(fname_len(fname) + dlen, =
dir);
>  	int nlen, rlen;
>  	unsigned int offset =3D 0;
>  	char *top;
> @@ -2138,7 +2139,7 @@ int ext4_find_dest_de(struct inode *dir, struct buf=
fer_head *bh,
>  			return -EFSCORRUPTED;
>  		if (ext4_match(dir, fname, de))
>  			return -EEXIST;
> -		nlen =3D ext4_dir_rec_len(de->name_len, dir);
> +		nlen =3D ext4_dir_entry_len(de, buf_size, dir);
>  		rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
>  		if ((de->inode ? rlen - nlen : rlen) >=3D reclen)
>  			break;

[Severity: Critical]
Can changing nlen to ext4_dir_entry_len() in ext4_find_dest_de() allow
unsigned len in make_indexed_dir() to underflow and overflow data2 in
memcpy(data2, de, len)?

In __ext4_add_entry() -> add_dirent_to_buf() -> ext4_find_dest_de() on
block 0 of an unindexed directory (where buf_size =3D blocksize - csum_size=
),
the loop runs while (char *)de <=3D buf + buf_size - reclen. Because nlen n=
ow
includes dirdata via ext4_dir_entry_len(), the '.' entry (dot_de) on a
corrupted or crafted image can have rlen > buf_size - reclen while its
dirdata makes rlen - nlen < reclen. In that case, ext4_find_dest_de()
checks dot_de, advances de to dotdot_de at an offset past top, exits the
loop without running ext4_check_dir_entry() on dotdot_de, and returns
-ENOSPC.

__ext4_add_entry() then calls make_indexed_dir(), which validates dotdot_de
through ext4_check_dx_root() and dx_get_dx_info(). However, both check the
end of dotdot_de against blocksize rather than blocksize - csum_size:

fs/ext4/namei.c:ext4_check_dx_root() {
    ...
	de =3D ext4_next_entry(dotdot_de, blocksize);
	if ((char *)de >=3D (((char *)dot_de) + blocksize)) {
		error_msg =3D "invalid rec_len for '..'";
		goto corrupted;
	}
    ...
}

When metadata_csum is enabled (csum_size =3D 12) and dotdot_de ends between
blocksize - csum_size + 1 and blocksize - 1, make_indexed_dir() computes:

fs/ext4/namei.c:make_indexed_dir() {
    ...
	/* The 0th block becomes the root, move the dirents out */
	len =3D ((char *)dot_de) + (blocksize - csum_size) - (char *)de;
    ...
	memcpy(data2, de, len);
}

Since (char *)de > (char *)dot_de + (blocksize - csum_size), unsigned len
underflows and is passed to memcpy(data2, de, len) and memset(de, 0, len).

[ ... ]

> @@ -2206,9 +2207,27 @@ static int add_dirent_to_buf(handle_t *handle, str=
uct ext4_filename *fname,
> =20
>  	if (!de) {
>  		err =3D ext4_find_dest_de(dir, bh, bh->b_data,
> -					blocksize - csum_size, fname, &de);
> +					blocksize - csum_size, fname, &de, 0);
>  		if (err)
>  			return err;
> +	} else {
> +		/*
> +		 * do_split() hands over the last entry of a half.  Its length
> +		 * comes from on-disk dirdata, so check that the new entry fits
> +		 * before anything is written.
> +		 */
> +		unsigned int nlen =3D de->inode ?
> +			ext4_dir_entry_len(de, blocksize, dir) : 0;
> +		unsigned int rlen =3D ext4_rec_len_from_disk(de->rec_len,
> +							   blocksize);
> +
> +		if (nlen > rlen ||
> +		    rlen - nlen < ext4_dirent_rec_len(fname_len(fname), dir)) {
> +			EXT4_ERROR_INODE(dir,
> +				"no room for new entry in split block %llu",
> +				(unsigned long long)bh->b_blocknr);
> +			return -EFSCORRUPTED;
> +		}
>  	}

[Severity: High]
When this check in add_dirent_to_buf() returns -EFSCORRUPTED for a de
returned by do_split(), does it leave bh modified with a zeroed checksum
tail and without calling ext4_handle_dirty_dirblock()?

Before returning de to make_indexed_dir() or ext4_dx_add_entry(),
do_split() has already obtained write access to *bh, bh2, and frame->bh,
modified *bh and bh2 in-place via dx_move_dirents() and dx_pack_dirents(),
zeroed det_checksum in both blocks via ext4_initialize_dirent_tail(), and
dirtied bh2 and frame->bh:

fs/ext4/namei.c:do_split() {
    ...
	if (csum_size) {
		ext4_initialize_dirent_tail(*bh, blocksize);
		ext4_initialize_dirent_tail(bh2, blocksize);
	}
    ...
	if (hinfo->hash >=3D hash2) {
		swap(*bh, bh2);
		de =3D de2;
	}
	dx_insert_block(frame, hash2 + continued, newblock);
	err =3D ext4_handle_dirty_dirblock(handle, dir, bh2);
	if (err)
		goto journal_error;
	err =3D ext4_handle_dirty_dx_node(handle, dir, frame->bh);
	if (err)
		goto journal_error;
    ...
}

do_split() relies on add_dirent_to_buf() to checksum and dirty *bh via
ext4_handle_dirty_dirblock(handle, dir, bh). If add_dirent_to_buf() returns
-EFSCORRUPTED early here, bh2 and frame->bh are committed in the journal
with the post-split state (for instance in make_indexed_dir() or when
mounted with errors=3Dcontinue), while bh is never passed to
ext4_handle_dirty_dirblock().

[1] https://lore.kernel.org/r/20261029122413.230409-8-ablagodarenko@thelust=
recollective.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D8
