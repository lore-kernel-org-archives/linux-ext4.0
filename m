Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793278202;
	b=vrWY4l9ByovoaV309r2NyBS4fCQoX67XxJLCT7RLhxr7+X/DyConx+LGEjEufsYKERJQ
	 BjZFccEslFJ7YpOkNHmY0h2gGazvumqf8TVqfeOv7RPRdMRSMAZ5EoBdvU+SyFWac302f
	 zLrjgvD3VZilh6ooaJ7lTW8PIh1/8aTx9v4EOcSgXI21mll1bEMOY4l8EaqnECFl394ht
	 qoyWUq8xGfo58WxEtNqPiKm+SiWDA125Is24OB0LH5xnQBrQeyeswrU4Bcn0lj8yPGtKu
	 Jq8sNqu6H1ZitqnQG9oaE7MbkyQJ5n9t3ps32fOkBpC2df06HS7dSAxC5K0i4C/4avg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793278202;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K40ha6Nrxq0ukvgmRg3DvXL41ma09XwzWlSq3EHfw+Y=;
	b=UOjSFK1Uco+iF7vKNPrmSXjV1xI1YhqyaMEThoKiJsnJAqFk6itWVQKEViDeSOhBU7XW
	 MSPFWE5+pxc2qERoXaDGmYby/u8rsswdJ/dpGM6CX3ZNgg/iXfPQcQm6IQ+9jxuZhVkNl
	 uy0Nd4OFjvoYbnpbV+S7pwZwhdXPSToKwx7h2fEks8bOOlPOmu8onNMfBWO28p8izzOd8
	 MBOmyxqX81q6EUQWn5HhGgniCaqfsI8Uw7SyGPX3Sr47cUnSqun/lRnI8Z5J0IizUP9Xe
	 r5taI7WjRdnNhnCCaET6Z42baIIpGMnBI/bJUs1uChnG+Uny/YLaz2igo3NjWjWoBDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=byEdUl5o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE43606A31D
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=byEdUl5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AF31F01825;
	Thu, 29 Oct 2026 12:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793278202;
	bh=K40ha6Nrxq0ukvgmRg3DvXL41ma09XwzWlSq3EHfw+Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=byEdUl5owMqKfsY9CQxnt/EDsS+LaOPZOch2t+YGxQ1+QylP1Sa02/zideYgQGYcT
	 hIGIbDkYMXWjdLqLWFub7qgm63Xr8Z5lFOIWajFxmZiojG6AmRAzj6+JISIDTOpPUA
	 vG2oP4yseDI6v7KHiYqEFzwdaQQ4aSNf6cHKUPvWaavDDyTiDmvdiPkEaKT/fQNSwl
	 RZnEMXj9lPbDoA3i0jX9vDEgphO3TLiluyhyGG78PMEt3w8y4Gcd4+c3vpMdR1bSy9
	 maChh45mFS+P6ofKDHpugrenuixRcwHCmzm21+Z7tcm7vFUpOc1R7ox3qI7yC1z97G
	 gZwbjpyQ8nEyw==
Message-ID: <sashiko-outbox-189315@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 07/11] ext4: rename ext4_dir_rec_len() and clarify
 dirdata usage
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-8-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-8-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:50:01 +0000
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
- [Critical] ext4: mutable ext4_dir_entry_len() causes OOB write in ext4_in=
sert_dentry()
--

commit da71cae2acaae8de2bca9ec5b4ce285d12415d14
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: rename ext4_dir_rec_len() and clarify dirdata usage

This commit renames ext4_dir_rec_len() to ext4_dirent_rec_len(), widens its
name_len parameter from __u8 to unsigned int, and updates several callers to
use ext4_dir_entry_len() or pass an explicit dirdata length to
ext4_find_dest_de().

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
> +	else if (unlikely(next_offset > size - ext4_dirent_rec_len(1,
>  						  has_csum ? NULL : dir) &&
>  			  next_offset !=3D size))
>  		error_msg =3D "directory entry too close to block end";

[ ... ]

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2d6d3be4ef7df..839274c4d7fcd 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2649,11 +2649,16 @@ struct ext4_dirent_hash {
>   * casefolded and encrypted need to store the hash as well, so we add ro=
om for
>   * ext4_extended_dir_entry_2. For all entries related to '.' or '..' you=
 should
>   * pass NULL for dir, as those entries do not use the extra fields.
> + *
> + * For directories with the dirdata feature, extra data may follow the f=
ilename.
> + * Use ext4_dir_entry_len() to compute the length of a directory entry
> + * including any dirdata, or ext4_dirent_rec_len() directly when the tot=
al
> + * name_len (including dirdata length) is already known.
>   */
> -static inline unsigned int ext4_dir_rec_len(__u8 name_len,
> +static inline unsigned int ext4_dirent_rec_len(unsigned int name_len,
>  						const struct inode *dir)
>  {
> -	int rec_len =3D (name_len + 8 + EXT4_DIR_ROUND);
> +	unsigned int rec_len =3D (name_len + 8 + EXT4_DIR_ROUND);
> =20
>  	/*
>  	 * Without dirdata, the casefold+fscrypt hash lives at a fixed position

[ ... ]

> @@ -4266,7 +4272,7 @@ static inline unsigned int ext4_dir_entry_len(struc=
t ext4_dir_entry_2 *de,
>  	unsigned int rec_len =3D ext4_rec_len_from_disk(de->rec_len, blocksize);
>  	unsigned int dirdata =3D ext4_dirent_get_data_len(de, rec_len);
> =20
> -	return ext4_dir_rec_len(de->name_len + dirdata, dir);
> +	return ext4_dirent_rec_len(de->name_len + dirdata, dir);
>  }

[ ... ]

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index b3acab0689c93..e54608950fb34 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -1902,7 +1902,7 @@ dx_move_dirents(struct inode *dir, char *from, char=
 *to,
>  	while (count--) {
>  		struct ext4_dir_entry_2 *de =3D (struct ext4_dir_entry_2 *)
>  						(from + (map->offs<<2));
> -		rec_len =3D ext4_dir_rec_len(de->name_len, dir);
> +		rec_len =3D ext4_dir_entry_len(de, blocksize, dir);
> =20
>  		memcpy (to, de, rec_len);
>  		((struct ext4_dir_entry_2 *) to)->rec_len =3D
> @@ -1935,7 +1935,7 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(str=
uct inode *dir, char *base,
>  	while ((char*)de < base + blocksize) {
>  		next =3D ext4_next_entry(de, blocksize);
>  		if (de->inode && de->name_len) {
> -			rec_len =3D ext4_dir_rec_len(de->name_len, dir);
> +			rec_len =3D ext4_dir_entry_len(de, blocksize, dir);
>  			if (de > to)
>  				memmove(to, de, rec_len);
>  			to->rec_len =3D ext4_rec_len_to_disk(rec_len, blocksize);

[ ... ]

> @@ -2126,7 +2127,7 @@ void ext4_insert_dentry(struct inode *dir,
> =20
>  	int nlen, rlen;
> =20
> -	nlen =3D ext4_dir_rec_len(de->name_len, dir);
> +	nlen =3D ext4_dir_entry_len(de, buf_size, dir);
>  	rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
>  	if (de->inode) {
>  		struct ext4_dir_entry_2 *de1 =3D

[Severity: Critical]
Can switching to ext4_dir_entry_len() here and widening ext4_dirent_rec_len=
()
cause an out-of-bounds write past bh->b_data or trigger the BUG_ON() in
ext4_rec_len_to_disk() when splitting a directory block via
do_split() -> add_dirent_to_buf() -> ext4_insert_dentry()?

In fs/ext4/ext4.h, ext4_dir_entry_len() computes the entry length using the
entry's current de->rec_len via ext4_dirent_get_data_len():

fs/ext4/ext4.h:ext4_dirent_get_data_len() {
    ...
			{
				u8 ddh_len =3D READ_ONCE(ddh->ddh_length);

				if (ddh_len =3D=3D 0 || ddh_len > rec_len - offset)
					return 0;
				dlen +=3D ddh_len + (dlen =3D=3D 0);
    ...
}

Because ext4_dirent_get_data_len() returns 0 whenever ddh_len exceeds
rec_len - offset (and does not check ext4_has_feature_dirdata()),
__ext4_check_dir_entry() in fs/ext4/dir.c will not reject an entry whose
on-disk rec_len is smaller than its dirdata length.

During a directory leaf split in fs/ext4/namei.c:do_split():

fs/ext4/namei.c:do_split() {
    ...
	de2 =3D dx_move_dirents(dir, data1, data2, map + split, count - split,
			      blocksize);
	de =3D dx_pack_dirents(dir, data1, blocksize);
	de->rec_len =3D ext4_rec_len_to_disk(data1 + (blocksize - csum_size) -
					   (char *) de,
					   blocksize);
	de2->rec_len =3D ext4_rec_len_to_disk(data2 + (blocksize - csum_size) -
					    (char *) de2,
					    blocksize);
    ...
}

If the final entry de in the target split half has a small rec_len (for
example, rec_len =3D 12, name_len =3D 1, file_type =3D 0x11) with a larger
ddh_length byte stored at offset 10 (still inside the 12-byte entry),
ext4_dirent_get_data_len(de, 12) returns 0 during __ext4_check_dir_entry(),
dx_move_dirents(), and dx_pack_dirents(), copying all 12 bytes.

Then do_split() expands de->rec_len to cover the remainder of the block and
passes de to add_dirent_to_buf(), which skips ext4_find_dest_de() when de is
non-NULL and calls ext4_insert_dentry() directly:

fs/ext4/namei.c:ext4_insert_dentry() {
	int nlen, rlen;

	nlen =3D ext4_dir_entry_len(de, buf_size, dir);
	rlen =3D ext4_rec_len_from_disk(de->rec_len, buf_size);
	if (de->inode) {
		struct ext4_dir_entry_2 *de1 =3D
			(struct ext4_dir_entry_2 *)((char *)de + nlen);
		de1->rec_len =3D ext4_rec_len_to_disk(rlen - nlen, buf_size);
		de->rec_len =3D ext4_rec_len_to_disk(nlen, buf_size);
		de =3D de1;
	}
    ...
	memcpy(de->name, fname_name(fname), fname_len(fname));
}

When ext4_insert_dentry() recomputes nlen =3D ext4_dir_entry_len(de, buf_si=
ze,
dir) with the expanded de->rec_len, ddh_len <=3D rec_len - offset can now
succeed, growing nlen up to rlen (or rlen + 8 if ext4_hash_in_dirent(dir) &&
!ext4_has_feature_dirdata(dir->i_sb)). In addition, because
ext4_dirent_rec_len() now takes unsigned int name_len, an entry with multip=
le
valid dirdata fields can be up to 1284 bytes, which on 1024-byte or 2048-by=
te
block filesystems can also leave rlen - nlen in do_split() smaller than the
new entry being inserted.

Since ext4_insert_dentry() does not check that rlen - nlen is large enough =
to
hold the new entry, wouldn't nlen > rlen underflow rlen - nlen and hit BUG_=
ON
in ext4_rec_len_to_disk(), or nlen <=3D rlen advance de1 to the end of the
block buffer so that memcpy(de->name, ...) writes past the end of bh->b_dat=
a?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D7
