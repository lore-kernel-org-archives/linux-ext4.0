Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787854;
	b=S+nUETozCThUXr0Hha33mfbP38vEDKcGaWccIcmGHmCtIGyc0Nst7CqnJuSyxRAMW/c9
	 6tg4nlO5gQuVm2dNY0HHom/2uEs/mjWvWgJhVhAf/AFIXs+J59D7qRAj6w3EVngq4Npcw
	 RqD0wHeo1/huE5pOlcwtKdN7fZA2etZrv7Do+8iYVG/02S9jtN4suuEHXa30qB4Q9YfLJ
	 mkb/G/NAr2J8VVHYnxUE50eTzJYcb/aFMgiNxhxbT938EAmsE4Eu7ge1NeBZwDPQ5X068
	 Orf184feIMaC0ABAv184AJE7NtPg0dUhZRz1ByJYDm0qRw41qO3EwWPahyfzDRAlw8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787854;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=a0ld13+dhe7e7otguQLcsC3DyOa2dMluo2WhzEh69lU=;
	b=RgblIltYq7LDq7R/hDdahyZ2Med+FXcObvLZHODMubM5ReYws/12rPFQa1nwiNXvIuLg
	 4cfJWh2I9vSPA3S0bkC7l4+Fk5dtWtsUToTZhx9zkB97uFbOwNfbT1y3emZbXFyd7/uBU
	 raz1R3QC0rNOiLOsKtIUFZ0jF51+ZXBE8OHDspspJFZH0c3sOgOqJ1MITPguA1zJTZVYQ
	 +ybefjZ0jeCAx5e4drrdo9Fgz8d7kk+RWPXJdG+sRoCDM87PS3pXwt5YQZlHkLGRfJ90s
	 HX2j02D6HQ2YcTup1Kob4Yx73x1OlawNNE6N26Y4f+Y1nFihHQ+gYgTwH0fkHU+Lf2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h2nm3UpV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B373606A326
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 10:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h2nm3UpV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB4A1F000C1;
	Wed,  4 Nov 2026 10:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793787854;
	bh=a0ld13+dhe7e7otguQLcsC3DyOa2dMluo2WhzEh69lU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h2nm3UpVVXRF8jDx62DgorwijIPefEAf9Vo9X3wdzrA6+E0iOHnuw34e/Ml0XUp7H
	 jwjXKN2V4jDVLbLLXYMT+QLHf9aliefPpPgqJaH8mDOYnPVqFndVqEcky1tEZ6z35A
	 ZjVwl//zGA8ENBqJDHj+EkQHMju19sLMvbHxYpzFNJIlPuQsbOeiC9KREah0m7/JI3
	 niWpUy3I87Qq1M69Vp5L0qalfvlPTq6CMCaSkgdPwodXBUfTNfGwMbZBuAPDei7Stz
	 aPeptnZGFsbKccb97pUZ2uR5ncmGLzQnHqD/dGGWg5gzqAg0se6QUMZ9nKx0WGzHAp
	 A0hKBPjzk7Ygg==
Message-ID: <sashiko-outbox-197087@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5] ext4: fix slab-use-after-free in do_split()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <tencent_4EAEF2024D7BB83D62E41306EED8D2112C08@qq.com>
References: <sashiko-outbox-197027@kernel.org>
 <tencent_4EAEF2024D7BB83D62E41306EED8D2112C08@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:24:13 +0000
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
- [Critical] ext4: late alias check in make_indexed_dir() after buffer modi=
fication
- [Critical] ext4: unchecked buffer aliasing in ext4_dx_add_entry() index s=
plit
- [Critical] ext4: late leaf-to-index alias check in ext4_dx_add_entry()
--

commit eea9bdf87e428c4c24ab845db976b1362da00cdf
Author: Shuai Liu <847807867@qq.com>

ext4: fix slab-use-after-free in do_split()

This patch adds checks in do_split() to verify that neither the leaf direct=
ory
block being split (*bh) nor the newly allocated block (bh2) aliases each ot=
her
or any htree index block in frames[0..frame]. If an alias is detected,
do_split() logs an error and returns -EFSCORRUPTED before modifying directo=
ry
entries.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 231a274b814ec..878ed25ca4a2b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1903,13 +1903,14 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(s=
truct inode *dir, char *base,
>   * Returns pointer to de in block into which the new entry will be inser=
ted.
>   */
>  static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode =
*dir,
> -			struct buffer_head **bh,struct dx_frame *frame,
> -			struct dx_hash_info *hinfo)
> +			struct buffer_head **bh, struct dx_frame *frames,
> +			struct dx_frame *frame, struct dx_hash_info *hinfo)
>  {
>  	unsigned blocksize =3D dir->i_sb->s_blocksize;
>  	unsigned continued;
>  	int count;
>  	struct buffer_head *bh2;
> +	struct dx_frame *f;
>  	ext4_lblk_t newblock;
>  	u32 hash2;
>  	struct dx_map_entry *map;
> @@ -1922,12 +1923,42 @@ static struct ext4_dir_entry_2 *do_split(handle_t=
 *handle, struct inode *dir,
>  	if (ext4_has_feature_metadata_csum(dir->i_sb))
>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
> =20
> +	for (f =3D frames; f <=3D frame; f++) {
> +		if (*bh =3D=3D f->bh) {
> +			ext4_error_inode_block(dir, (*bh)->b_blocknr,
> +					       EFSCORRUPTED,
> +					       "leaf block aliased with index block");
> +			brelse(*bh);
> +			*bh =3D NULL;
> +			return ERR_PTR(-EFSCORRUPTED);
> +		}
> +	}

[Severity: Critical]
Is checking for *bh =3D=3D f->bh inside do_split() too late when called from
ext4_dx_add_entry()?

In ext4_dx_add_entry(), after reading the leaf block bh, add_dirent_to_buf()
is called before do_split() is ever reached:

    bh =3D ext4_read_dirblock(dir, dx_get_block(frame->at), DIRENT_HTREE);
    if (IS_ERR(bh)) {
        err =3D PTR_ERR(bh);
        bh =3D NULL;
        goto cleanup;
    }
    ...
    err =3D add_dirent_to_buf(handle, fname, dir, inode, NULL, bh);
    if (err !=3D -ENOSPC)
        goto cleanup;

If bh aliases one of the index buffers in frames[0..frame].bh, dx_probe() h=
as
already marked that buffer verified, so __ext4_read_dirblock() returns it
without running leaf checksum verification. Because an htree root block has
root->dotdot->rec_len =3D=3D blocksize - 12 (and an internal dx_node has
node->fake.rec_len =3D=3D blocksize), on a filesystem without metadata_csum,
ext4_find_dest_de() finds space inside that fake dirent and returns 0 inste=
ad
of -ENOSPC.

ext4_insert_dentry() then writes the new directory entry directly over the
htree header (for example, overwriting root->info.indirect_levels at offset=
 30
of frames[0].bh->b_data with de1->name_len), and ext4_dx_add_entry() jumps =
to
cleanup without calling do_split(). In dx_release(), the loop:

    indirect_levels =3D info->indirect_levels;
    for (i =3D 0; i <=3D indirect_levels; i++) {
        if (frames[i].bh =3D=3D NULL)
            break;
        brelse(frames[i].bh);
        frames[i].bh =3D NULL;
    }

can then read past the end of the frames[EXT4_HTREE_LEVEL] stack array when
all frames are populated, or leak frame buffers if indirect_levels was
overwritten with a smaller value. Should the leaf-to-index alias check happ=
en
in ext4_dx_add_entry() right after ext4_read_dirblock()?

[ ... ]

> @@ -2325,7 +2356,7 @@ static int make_indexed_dir(handle_t *handle, struc=
t ext4_filename *fname,
>  	if (retval)
>  		goto out_frames;
> =20
> -	de =3D do_split(handle,dir, &bh2, frame, &fname->hinfo);
> +	de =3D do_split(handle, dir, &bh2, frames, frame, &fname->hinfo);
>  	if (IS_ERR(de)) {
>  		retval =3D PTR_ERR(de);
>  		goto out_frames;

[Severity: Critical]
In make_indexed_dir(), frame->bh is bh (logical block 0) and the buffer pas=
sed
to do_split() is bh2, which was allocated earlier in make_indexed_dir() via
ext4_append():

    bh2 =3D ext4_append(handle, dir, &block);
    if (IS_ERR(bh2)) {
        brelse(bh);
        return PTR_ERR(bh2);
    }
    ext4_set_inode_flag(dir, EXT4_INODE_INDEX);
    data2 =3D bh2->b_data;

    memcpy(data2, de, len);
    memset(de, 0, len); /* wipe old data */

If block 0 is marked free in a corrupted block bitmap and ext4_append()
returns bh2 =3D=3D bh, won't make_indexed_dir() perform an overlapping memc=
py()
over root->dot and root->dotdot, wipe the copied entries with memset(),
reinitialize bh->b_data as a dx_root header, and dirty both buffers in the
journal before do_split() ever checks *bh =3D=3D f->bh?

> @@ -2631,7 +2662,7 @@ static int ext4_dx_add_entry(handle_t *handle, stru=
ct ext4_filename *fname,
>  			goto journal_error;
>  		}
>  	}
> -	de =3D do_split(handle, dir, &bh, frame, &fname->hinfo);
> +	de =3D do_split(handle, dir, &bh, frames, frame, &fname->hinfo);
>  	if (IS_ERR(de)) {
>  		err =3D PTR_ERR(de);
>  		goto cleanup;

[Severity: Critical]
What happens if the index split right above this do_split() call in
ext4_dx_add_entry() receives an aliased buffer from ext4_append()?

When dx_get_count(entries) =3D=3D dx_get_limit(entries), ext4_dx_add_entry()
allocates a new index block:

    bh2 =3D ext4_append(handle, dir, &newblock);
    if (IS_ERR(bh2)) {
        err =3D PTR_ERR(bh2);
        goto cleanup;
    }
    node2 =3D (struct dx_node *)(bh2->b_data);
    entries2 =3D node2->entries;
    memset(&node2->fake, 0, sizeof(struct fake_dirent));

Nothing checks whether bh2 aliases frames[0..level].bh or the leaf block bh:

1. In the !add_level branch, if bh2 aliases (frame - 1)->bh, the memcpy() i=
nto
   entries2 overwrites (frame - 1)->entries, and the subsequent call to
   dx_insert_block((frame - 1), hash2, newblock) reads the corrupted count =
and
   can memmove() out of bounds past the end of (frame - 1)->bh->b_data.

2. In the add_level branch, if bh2 aliases frames[0].bh, the memcpy() from
   entries (offset 32) to entries2 (offset 8) is an overlapping copy within
   frames[0].bh->b_data that overwrites dxroot->info.indirect_levels at off=
set
   30, increments it, and jumps directly to journal_error / cleanup without
   reaching do_split(), causing dx_release(frames) to loop out of bounds pa=
st
   frames[EXT4_HTREE_LEVEL] or leak frame references.

3. In the !add_level branch when restart =3D=3D 0 and at - entries < icount=
1, if
   bh2 aliases the leaf block bh, bh->b_data is overwritten with a dx_node
   header and index entries, and bh2 is released without swapping into
   frame->bh, so do_split() then runs on the corrupted leaf buffer without
   detecting the alias.

Could the alias checks be performed when bh2 is allocated during the index
split as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_4EAEF2024D7=
BB83D62E41306EED8D2112C08@qq.com?part=3D1
