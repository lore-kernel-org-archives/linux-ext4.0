Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793278238;
	b=ex6leo1zhP27IbCQPxAXk0R5cmf1TEPR3SsfuZwSshgqBZSm19uFjk5M32gs6IXtr/kW
	 Ch8SQB3ZyvCCQE5gPXiv5jI7lPKnFGEh+1WH/w9LS7JEEzmx5d6jsKZXoFUgep/tj2oWn
	 X068sWBWNr3nRCAYEDRhuwZcuVWqhjn0PtcroxSdBTxhgT1gkbr3KkS6q2OmEFQHW65hx
	 BnHFGvmNmjmcj8aOHlailgGVN2Bt4qM3bQriJ79OaISbab47PA4GdT4q3MKxjBPwrgbOh
	 tbBMDQ93/YUPOmgksDH1DvXTkhpbyEo92RRqZ/Ro0tr7zpSGpFbxfDBjrqoj0QFOa8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793278238;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aWJse5ez6Y220+aPcGHkPBAcF933JdbaeooPvoOO2Yk=;
	b=alSqqQEz/y2LCFPFHkJtCNns5Fb1KT1a5LdVKNm/1Uwzdr3MPeh645niYnfY3kiSXECK
	 KagBk2S8V98eE7ZEnGaFuUeTZQjsMZhsdABE4BUOx7/Tzb0jTpWW6fTWL1pYFWT6bktGO
	 qsYddcLTAbiiO6RctfiFBQZKaPa8iurwONK/ScM0nL47JHUTu5sv/X9HsOptrn0y/Id2W
	 Uy6Hsokb5M/8XsL7CK2R9cbMPSrGi3EcdaEdIQBjBcvHwk6E+LpQw1osupxiOO1xrdmuZ
	 cB9ChZ77WWbgArQwJ/YOVdaThPT5DUrIulEjHrtrIFBXJVBmtMB7LISHqwKFLI1EutA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nDylAIUH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A3E606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nDylAIUH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71981F01825;
	Thu, 29 Oct 2026 12:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793278237;
	bh=aWJse5ez6Y220+aPcGHkPBAcF933JdbaeooPvoOO2Yk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nDylAIUHE6kkFLpuvIN225SAw8PlTE22Kk1bKaOcx/PUOgxbjF6WV6qi23XdALp4p
	 V3jGjtVn95W6sFrKdJ7lLxjFT2d37SQbKrwm1bzf7B5Ib1vvE2Lf7pkdYFM8t/aBCW
	 lBUT0NipbrzjcEyoC3kvJaTA0XYFnWveU/wFooZJfalJJi9Ak5JAgTfGBzOtE4VyFi
	 S4V1Vq0+cb8/I14pcP5iSuYqxfTWeySqPNsbwhyKGlADTOPMdxmwzAg0iaxbv9swdK
	 eioWIoNPa/h1cxhuvikqxv16aJlmW5iV67WCYDpOFmw/iyqCL2yQuKu0js1+9TEwnJ
	 uJtA6LAURco4w==
Message-ID: <sashiko-outbox-189317@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 06/11] ext4: add ext4_dir_entry_len()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-7-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-7-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:50:37 +0000
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
- [High] ext4: missing hash size in ext4_dir_rec_len() when dirdata is enab=
led
- [High] ext4: inconsistent dot_de offset in make_indexed_dir() and dx_get_=
dx_info()
- [High] ext4: insufficient space check in dx_get_dx_info() and dx_root_lim=
it()
--

commit cde4b627ee0c8478f3506f3aca76ba7f76852f15
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: add ext4_dir_entry_len()

This commit updates ext4_dir_rec_len() to skip adding sizeof(struct
ext4_dir_entry_hash) when the dirdata feature is enabled, masks the filetype
in get_dtype(), and updates dx_root_limit() and its callers to compute the
root htree limit via dx_get_dx_info().

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index edb95cbc4439e..2d6d3be4ef7df 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2655,7 +2655,15 @@ static inline unsigned int ext4_dir_rec_len(__u8 n=
ame_len,
>  {
>  	int rec_len =3D (name_len + 8 + EXT4_DIR_ROUND);
> =20
> -	if (dir && ext4_hash_in_dirent(dir))
> +	/*
> +	 * Without dirdata, the casefold+fscrypt hash lives at a fixed position
> +	 * after the filename and must be reserved explicitly.  With dirdata the
> +	 * hash is stored as a CFHASH extension and is already counted in the
> +	 * name_len argument (via ext4_dirent_get_data_len), so adding it again
> +	 * would double-count.
> +	 */
> +	if (dir && ext4_hash_in_dirent(dir) &&
> +	    !ext4_has_feature_dirdata(dir->i_sb))
>  		rec_len +=3D sizeof(struct ext4_dir_entry_hash);
>  	return (rec_len & ~EXT4_DIR_ROUND);
>  }

[Severity: High]
Can skipping sizeof(struct ext4_dir_entry_hash) whenever
ext4_has_feature_dirdata(dir->i_sb) is set cause out-of-bounds reads and
directory entry corruption on encrypted casefolded directories?

At this commit, callers such as ext4_find_dest_de(), ext4_insert_dentry(),
dx_move_dirents(), dx_pack_dirents(), and __ext4_check_dir_entry() still pa=
ss
de->name_len or fname_len(fname) directly to ext4_dir_rec_len() without
including ext4_dirent_get_data_len(). Even after later patches in the series
("ext4: rename ext4_dir_rec_len() and clarify dirdata usage", "ext4: dirdata
feature", and "ext4: add dirdata set/get helpers") convert some callers to
ext4_dir_entry_len(), several paths remain broken through the end of the
series:

1. In fs/ext4/namei.c:ext4_search_dir(), the bounds check before ext4_match=
()
still calls ext4_dir_rec_len() (renamed to ext4_dirent_rec_len()) directly =
on
de->name_len:

    if (de->name + de->name_len <=3D dlimit &&
        (!ext4_hash_in_dirent(dir) ||
         (char *)de + ext4_dir_rec_len(de->name_len, dir) <=3D dlimit) &&
        ext4_match(dir, fname, de)) {

When dirdata and casefold+fscrypt are enabled on dir, ext4_dir_rec_len()
omits the 8-byte hash size. If an entry at the end of search_buf does not
have EXT4_DIRENT_CFHASH set in de->file_type, this bounds check passes when
only de->name_len fits before dlimit, and ext4_match() then falls back to
EXT4_DIRENT_HASH(de) and EXT4_DIRENT_MINOR_HASH(de), reading 8 bytes past
dlimit.

2. In fs/ext4/ext4.h:ext4_dir_entry_len():

    static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *=
de,
                                                  unsigned int blocksize,
                                                  const struct inode *dir)
    {
            unsigned int rec_len =3D ext4_rec_len_from_disk(de->rec_len, bl=
ocksize);
            unsigned int dirdata =3D ext4_dirent_get_data_len(de, rec_len);

            return ext4_dir_rec_len(de->name_len + dirdata, dir);
    }

If an entry in a casefolded+encrypted directory on a dirdata filesystem does
not have EXT4_DIRENT_CFHASH set in de->file_type (either a legacy un-migrat=
ed
entry or a corrupted on-disk entry), ext4_dirent_get_data_len() returns 0 a=
nd
ext4_dir_rec_len() also skips adding sizeof(struct ext4_dir_entry_hash).
Consequently, __ext4_check_dir_entry() accepts a trailing entry whose rec_l=
en
only covers de->name_len, and the !EXT4_DIRENT_CFHASH fallback paths in
ext4_readdir(), htree_dirblock_to_tree(), dx_make_map(), and
ext4_inlinedir_to_tree() read EXT4_DIRENT_HASH(de) and
EXT4_DIRENT_MINOR_HASH(de) 8 bytes past the end of the block buffer or
inline directory slab buffer. For un-migrated entries, ext4_dir_entry_len()
also under-reports the entry length by 8 bytes, causing ext4_find_dest_de(),
ext4_insert_dentry(), dx_move_dirents(), and dx_pack_dirents() to overwrite
the legacy hash.

3. Callers passing literal 0 or 1 to compute minimum dirent size
(__ext4_check_dir_entry(), ext4_readdir(), and htree_dirblock_to_tree()) get
8 or 12 bytes instead of 16 or 20 bytes when dirdata is enabled on a
casefolded+encrypted directory.

4. Conversely, if !ext4_has_feature_dirdata(dir->i_sb) and
ext4_hash_in_dirent(dir) is true, an on-disk entry with EXT4_DIRENT_CFHASH
set in de->file_type has its extension counted by ext4_dirent_get_data_len()
and sizeof(struct ext4_dir_entry_hash) added a second time by
ext4_dir_rec_len().

Should the hash size inclusion depend on whether the hash is already accoun=
ted
for by EXT4_DIRENT_CFHASH (and whether the caller actually queried dirdata),
rather than solely on !ext4_has_feature_dirdata(dir->i_sb)?

[ ... ]

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 59cc01b91c418..b3acab0689c93 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -596,11 +596,17 @@ static inline void dx_set_limit(struct dx_entry *en=
tries, unsigned value)
>  	((struct dx_countlimit *) entries)->limit =3D cpu_to_le16(value);
>  }
> =20
> -static inline unsigned dx_root_limit(struct inode *dir, unsigned infosiz=
e)
> +static inline unsigned dx_root_limit(struct inode *dir,
> +	struct ext4_dir_entry_2 *dot_de)
>  {
> -	unsigned int entry_space =3D dir->i_sb->s_blocksize -
> -			ext4_dir_rec_len(1, NULL) -
> -			ext4_dir_rec_len(2, NULL) - infosize;
> +	struct dx_root_info *info;
> +	unsigned int entry_space;
> +
> +	info =3D dx_get_dx_info(dir, dot_de);
> +	if (IS_ERR(info))
> +		return 0;
> +	entry_space =3D dir->i_sb->s_blocksize - ((char *)info - (char *)dot_de=
) -
> +		info->info_length;
> =20
>  	if (ext4_has_feature_metadata_csum(dir->i_sb))
>  		entry_space -=3D sizeof(struct dx_tail);
> @@ -885,10 +891,13 @@ dx_probe(struct ext4_filename *fname, struct inode =
*dir,
> =20
>  	entries =3D (struct dx_entry *)(((char *)info) + info->info_length);
> =20
> -	if (dx_get_limit(entries) !=3D dx_root_limit(dir, info->info_length)) {
> +	if (dx_get_limit(entries) !=3D
> +	    dx_root_limit(dir, (struct ext4_dir_entry_2 *)frame->bh->b_data)) {
>  		ext4_warning_inode(dir, "dx entry: limit %u !=3D root limit %u",
>  				   dx_get_limit(entries),
> -				   dx_root_limit(dir, info->info_length));
> +				   dx_root_limit(dir,
> +				   (struct ext4_dir_entry_2 *)frame->bh->b_data
> +				   ));
>  		goto fail;
>  	}
> =20
> @@ -2336,10 +2345,10 @@ static int make_indexed_dir(handle_t *handle, str=
uct ext4_filename *fname,
>  		dx_info->hash_version =3D
>  				EXT4_SB(dir->i_sb)->s_def_hash_version;
> =20
> -	entries =3D (void *)dx_info + sizeof(*dx_info);
> +	entries =3D (void *)dx_info + dx_info->info_length;
>  	dx_set_block(entries, 1);
>  	dx_set_count(entries, 1);
> -	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
> +	dx_set_limit(entries, dx_root_limit(dir, dot_de));

[Severity: High]
What happens in make_indexed_dir() when dot_de->rec_len does not equal
ext4_dir_entry_len(dot_de, blocksize, NULL)?

In fs/ext4/namei.c:make_indexed_dir(), dotdot_de is located using
dot_de->rec_len via ext4_next_entry(dot_de, blocksize), and left in place
while setting its new rec_len:

    dotdot_de =3D ext4_next_entry(dot_de, blocksize);
    if (!ext4_check_dx_root(dir, dot_de, dotdot_de, &de)) {
            brelse(bh);
            return -EFSCORRUPTED;
    }
    ...
    dotdot_de->rec_len =3D
            ext4_rec_len_to_disk(blocksize - le16_to_cpu(dot_de->rec_len),
                                 blocksize);

    /* initialize hashing info */
    dx_info =3D dx_get_dx_info(dir, dot_de);

However, dx_get_dx_info() (which is now also called by dx_root_limit()) ste=
ps
over dot_de using ext4_dir_entry_len(de_buf, blocksize, NULL) instead of
dot_de->rec_len:

    de_buf +=3D ext4_dir_entry_len(de_buf, blocksize, NULL);

If dot_de->rec_len has padding (e.g. 16 or 24 bytes when '.' has no dirdata)
or is 8 bytes, ext4_check_dx_root() still succeeds because it does not veri=
fy
that dot_de->rec_len matches ext4_dir_entry_len(dot_de, blocksize, NULL).
dx_get_dx_info() then interprets bytes at dot_de + ext4_dir_entry_len(dot_d=
e)
(inside dot_de's unzeroed slack space or misaligned with dotdot_de) as the
'..' entry, placing dx_info and entries[] at an offset that overwrites
dotdot_de and disagrees with get_dx_countlimit() (which steps over dot_de
using dirent->rec_len in ext4_dx_csum_set()).

In addition, does dx_get_dx_info() or make_indexed_dir() ensure enough space
remains in the root block for struct dx_tail and the second dx_entry created
by do_split()?

In dx_get_dx_info(), the bounds check only requires sizeof(struct
dx_root_info) + sizeof(struct dx_entry) (16 bytes) to remain in the block:

    if (de_buf < base || (char *)de_buf - (char *)base +
                          sizeof(struct dx_root_info) +
                          sizeof(struct dx_entry) > blocksize)
            return ERR_PTR(-EFSCORRUPTED);

When '.' and '..' carry large dirdata extensions (particularly once the next
commit widens ext4_dirent_rec_len()'s length parameter) such that only 16 to
23 bytes remain in the block after '..', dx_get_dx_info() succeeds, but:

1. In dx_root_limit(), subtracting sizeof(struct dx_tail) (8 bytes) when
metadata_csum is enabled leaves entry_space < sizeof(struct dx_entry), so
dx_root_limit() returns 0 (or if info->info_length is corrupted and large on
disk, subtracting info->info_length and sizeof(struct dx_tail) can underflow
unsigned int entry_space).

2. make_indexed_dir() does not check that dx_root_limit(dir, dot_de) >=3D 2.
When (char *)dx_info - (char *)dot_de =3D=3D blocksize - 16, entries[0] is
written with count =3D 1 and limit =3D 0 (triggering EXT4_ERROR_INODE() in
ext4_handle_dirty_dx_node() -> ext4_dx_csum_set()), and then do_split() ->
dx_insert_block() writes entries[1] at bh->b_data + blocksize, 8 bytes past
the end of the buffer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D6
