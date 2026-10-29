Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793278156;
	b=UY+tWaJYknfXBdISXhSnTNEzSVo6VusRnHVZhtFz9mQbTg9eQKnXdU80RzZKvln++rB6
	 GlcxLJ3FPS5efwse3OsmvstAcfz1TBILCUwTB3HVzN1L3WxMMGnngz/nPXPjV7sDNqj5Y
	 y4vruo6GUEglhLdpe5s04xH6P9/YC5VLe2vmIpMKg4tP/LfN7ilb/6q0VETZ+Hy4EgJk9
	 AG4ziGlCwAM94kSiCm9+/cnUlhN2LEI5WzsN7yBWkPW6ukaE5NNafrpsOduHPrOJYcFKc
	 kODv1xDxW+iwyzF9l4I+2G92NFZMr9DfRME8D5vjr4yw0vW+GRu1jLlSHfgB7T4fLew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793278156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=j3ZJqmhXibZfJbplA76TRzMv4nc5Jt+6a7stGfzuJZo=;
	b=zp9kQZmk5sz8kMT3VIPG98+bBJI53dYJfXaIvXlhs0LJ4XL6zHxL0PcBl2e/DnndOE+V
	 E7LCnHo1ENn3G3y7jlMle/i6NfF9JTZ2zwakigV+oRepfpCmD/Drh3IvBTWETT6RDKtch
	 B5Ed2wBMdEfuhphqSFNbVLAUW2ID3PS8ylKML8zWB7Ff+mnKbxWTjl2ogPn8uJwwekUj2
	 nP5Z3Gf6kUjs8fsV9f260KFcEpxdd2MG0dwRIq+cIp1ZWOoTQ9Tu1L/WD0uh12m67iJi7
	 pJ81pNZyU7to+5XRdl3tzk+HjFpdy4KDtDgrpCM+048x5eHAQZvjFHBXxyX/gvpgdhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oo2QxnlZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A060606A327
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oo2QxnlZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9CA1F01825;
	Thu, 29 Oct 2026 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793278156;
	bh=j3ZJqmhXibZfJbplA76TRzMv4nc5Jt+6a7stGfzuJZo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oo2QxnlZiSI+m82/lN6haLcIvQ8UONZt2MEBfbNjdzxHqEWkEVFKICuE+LmLuwRBD
	 66TlVn1iU+JRRbeCDZd/RLWXJ2D8P4oLSuLALmTa4OJSpxSrz+Y1nucZW0V7Lix5h4
	 X7xqZeMbFfJFQvZ4iLMZYhfvs2C5H9rAhWGr4nFIR4TIdaS9/LZWHQ+pFulmrYJdqv
	 OAw6rBM4om0gZqt+EoAxmjeK9P5jo9oE3ze6lOldrcniL7XI+dAUimUIKK1XqNtXEW
	 91QSYqzQFlJEfI8lBQ8rqOITu1Osixs8qFpdm+1vwCSm5tYhgEDFXwA3sJ70dqeSAX
	 0q1OF6YPHAVWw==
Message-ID: <sashiko-outbox-189313@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 05/11] ext4: refactor dx_root to support variable
 dirent sizes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-6-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-6-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:49:15 +0000
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
- [High] ext4: dx_get_dx_info() steps over dot entry using ext4_dir_entry_l=
en()
- [High] ext4: dx_node_limit() change breaks existing encrypted casefold ht=
ree dirs
- [High] ext4: make_indexed_dir() corrupts directory state if dx_get_dx_inf=
o() fails
--

commit ac1861c16d9ece959b6431b7c2c9637e888e44a0
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: refactor dx_root to support variable dirent sizes

This commit replaces the monolithic struct dx_root definition with a separa=
te
struct dx_root_info and adds dx_get_dx_info() and ext4_dir_entry_len() so
that "." and ".." directory entries in the htree root block can have variab=
le
lengths when carrying dirdata.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 533340c5dbc0d..59cc01b91c418 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
[ ... ]
> @@ -539,6 +530,31 @@ ext4_next_entry(struct ext4_dir_entry_2 *p, unsigned=
 long blocksize)
>   * Future: use high four bits of block for coalesce-on-delete flags
>   * Mask them off for now.
>   */
> +static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_b=
uf)
> +{
> +	unsigned int blocksize =3D dir->i_sb->s_blocksize;
> +	void *base =3D de_buf;
> +
> +	/* '.' and '..' never carry the casefold+fscrypt hash, so pass NULL
> +	 * for dir regardless of the directory's flags */
> +	if (ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
> +				   blocksize) < EXT4_BASE_DIR_LEN)
> +		return ERR_PTR(-EFSCORRUPTED);
> +	de_buf +=3D ext4_dir_entry_len(de_buf, blocksize, NULL);

[Severity: High]
Should dx_get_dx_info() advance past the "." entry using ext4_next_entry()
(or dot_de->rec_len) instead of ext4_dir_entry_len()?

Unlike "..", whose rec_len in an indexed root block is set to cover the rest
of the block, "." always stores the actual offset to ".." in dot_de->rec_le=
n.
Other callers locate ".." via dot_de->rec_len, such as make_indexed_dir():

	dot_de =3D (struct ext4_dir_entry_2 *)bh->b_data;
	...
	dotdot_de =3D ext4_next_entry(dot_de, blocksize);

and ext4_htree_fill_tree():

	de =3D (struct ext4_dir_entry_2 *) frames[0].bh->b_data;
	de =3D ext4_next_entry(de, dir->i_sb->s_blocksize);

If "." has slack space so that dot_de->rec_len is larger than
ext4_dir_entry_len(dot_de, blocksize, NULL) (for example, dot_de->rec_len is
24 while its minimum entry length is 12), make_indexed_dir() leaves dotdot_=
de
at offset 24 and preserves dot_de->rec_len:

	dotdot_de->rec_len =3D
		ext4_rec_len_to_disk(blocksize - le16_to_cpu(dot_de->rec_len),
				     blocksize);

	/* initialize hashing info */
	dx_info =3D dx_get_dx_info(dir, dot_de);

When dx_get_dx_info() then steps over "." by ext4_dir_entry_len() (12 bytes)
instead of dot_de->rec_len (24 bytes), won't it read the unzeroed slack byt=
es
after "." as the ".." entry and return a dx_info pointer that overlaps and
overwrites dotdot_de when dx_info and entries[] are initialized?

> +
> +	/* dx root info is after dotdot entry */
> +	if (de_buf < base || (char *)de_buf - (char *)base +
> +	    EXT4_BASE_DIR_LEN > blocksize)
> +		return ERR_PTR(-EFSCORRUPTED);
> +	de_buf +=3D ext4_dir_entry_len(de_buf, blocksize, NULL);
> +
> +	if (de_buf < base || (char *)de_buf - (char *)base +
> +			      sizeof(struct dx_root_info) +
> +			      sizeof(struct dx_entry) > blocksize)
> +		return ERR_PTR(-EFSCORRUPTED);
> +
> +	return (struct dx_root_info *)de_buf;
> +}
> =20
>  static inline ext4_lblk_t dx_get_block(struct dx_entry *entry)
>  {
> @@ -593,8 +609,10 @@ static inline unsigned dx_root_limit(struct inode *d=
ir, unsigned infosize)
> =20
>  static inline unsigned dx_node_limit(struct inode *dir)
>  {
> +	/* dx_node fake_dirent is always 8 bytes =E2=80=94 it never carries a c=
asefold
> +	 * hash, so pass NULL to suppress the hash-size term. */
>  	unsigned int entry_space =3D dir->i_sb->s_blocksize -
> -			ext4_dir_rec_len(0, dir);
> +			ext4_dir_rec_len(0, NULL);

[Severity: High]
Won't changing ext4_dir_rec_len(0, dir) to ext4_dir_rec_len(0, NULL) in
dx_node_limit() break existing multi-level encrypted and casefolded htree
directories?

In fs/ext4/ext4.h:

	static inline unsigned int ext4_dir_rec_len(__u8 name_len,
							const struct inode *dir)
	{
		int rec_len =3D (name_len + 8 + EXT4_DIR_ROUND);

		if (dir && ext4_hash_in_dirent(dir))
			rec_len +=3D sizeof(struct ext4_dir_entry_hash);
		return (rec_len & ~EXT4_DIR_ROUND);
	}

For directories where ext4_hash_in_dirent(dir) is true, ext4_dir_rec_len(0,
dir) returns 16, whereas ext4_dir_rec_len(0, NULL) returns 8. Passing NULL
increases dx_node_limit(dir) by 1 entry (for example, from 509 to 510 on 4KB
blocks with metadata_csum enabled).

Existing multi-level encrypted + casefolded directories created since commit
471fbbea7ff7 ("ext4: handle casefolding with encryption") have the smaller
limit recorded on disk in each internal dx_node block. When dx_probe() reads
an internal node, it enforces an exact match:

	entries =3D ((struct dx_node *) frame->bh->b_data)->entries;

	if (dx_get_limit(entries) !=3D dx_node_limit(dir)) {
		ext4_warning_inode(dir,
			"dx entry: limit %u !=3D node limit %u",
			dx_get_limit(entries), dx_node_limit(dir));
		goto fail;
	}

Won't dx_probe() reject all existing multi-level encrypted + casefolded
directories as corrupt with ERR_BAD_DX_DIR, causing __ext4_add_entry() to
trigger EXT4_ERROR_INODE() when metadata_csum is enabled?

[ ... ]
> @@ -2286,24 +2317,32 @@ static int make_indexed_dir(handle_t *handle, str=
uct ext4_filename *fname,
>  		ext4_initialize_dirent_tail(bh2, blocksize);
> =20
>  	/* Initialize the root; the dot dirents already exist */
> -	de =3D (struct ext4_dir_entry_2 *) (&root->dotdot);
> -	de->rec_len =3D ext4_rec_len_to_disk(
> -			blocksize - ext4_dir_rec_len(2, NULL), blocksize);
> -	memset (&root->info, 0, sizeof(root->info));
> -	root->info.info_length =3D sizeof(root->info);
> +	dotdot_de->rec_len =3D
> +		ext4_rec_len_to_disk(blocksize - le16_to_cpu(dot_de->rec_len),
> +				     blocksize);
> +
> +	/* initialize hashing info */
> +	dx_info =3D dx_get_dx_info(dir, dot_de);
> +	if (IS_ERR(dx_info)) {
> +		brelse(bh2);
> +		brelse(bh);
> +		return PTR_ERR(dx_info);
> +	}

[Severity: High]
If dx_get_dx_info() fails here in make_indexed_dir(), is it safe to return
early after the directory block and inode have already been modified?

By the time dx_get_dx_info() is called, make_indexed_dir() has already
appended bh2 (extending dir->i_size and marking the inode dirty in the
running handle), set EXT4_INODE_INDEX on dir, wiped the original entries in
block 0 (bh) with memset(de, 0, len), and updated dotdot_de->rec_len to span
the rest of block 0:

	bh2 =3D ext4_append(handle, dir, &block);
	if (IS_ERR(bh2)) {
		brelse(bh);
		return PTR_ERR(bh2);
	}
	ext4_set_inode_flag(dir, EXT4_INODE_INDEX);
	data2 =3D bh2->b_data;

	memcpy(data2, de, len);
	memset(de, 0, len); /* wipe old data */

Returning PTR_ERR(dx_info) at this point leaves dir with EXT4_INODE_INDEX s=
et
and an extended i_size, while block 0 has its entries wiped and no valid
dx_root_info initialized. Could dx_get_dx_info(dir, dot_de) be validated
before ext4_append() and memset() modify the directory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D5
