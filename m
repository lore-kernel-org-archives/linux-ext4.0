Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795803476;
	b=BAIAEFvzkZ8w3JZHklWrJYctb2Ar2GvGw19uSlbk8aY+18mAZNvaITCI9mVJYKir7OMy
	 e7NqNJvwNg6g5PLh/vNT/X6K8NfLlZQpBFWPgR27HnibXBjeRDyPQyhDEMA1nWC5WQwS3
	 CCgY/vV3R1bPhXALiliMxAqokG5K91TFD8lVykaLwRMWt2ihT1dnI/bRTT0D1LZCHFLwA
	 lwpud/c3aNULUVP3THizZDJH3s21/1hlglsjqweKKCRE4bOn9D8dmzQ1Bf5tm3sQ4E8nY
	 CZ7S6vIkKk6tlYm4vgbnIHqV1oAmRgac3NpK0Xk7Vvr/sG0kka7qpr5Dp7FVteDwnAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795803476;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C5JXZA0Hz0FUQ6Goga0I4PrybxbSM3yzalo/LE+dAJY=;
	b=siP/Qr5wqKLF9bmmCIFB1aNm20ZEqj92dYV/XVAYy+H5fIHZEn7sD84QP7tkyx4aJfXA
	 XmQyKyL2DvoXuTtNDkJRx55IVBtNTPRlKI7h45gH+8Y5UUcb3Z+aas33ZvJ6AQD8H9SAc
	 JkXdjoveS2K9aCfNtV4IrjsO4juCkPwTdV5BkdtNCzdwn2w/I4bGomsYDYURbzmVtrlPn
	 RAcNM+mMzZXf7ZcMkFlvCikCeKJdLO7thXtycvb/ULOwZe2k/JsM4FSiMhlw988TSBwBL
	 77nKdYqLz2ElN1Z7OKt+5A38ieXyall7D6+nFnpD6KWNddZpyPqhqERpy43TBwxZfEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XXsgGrCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29B8606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XXsgGrCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A95A1F00893;
	Fri, 27 Nov 2026 18:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795803476;
	bh=C5JXZA0Hz0FUQ6Goga0I4PrybxbSM3yzalo/LE+dAJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XXsgGrCl8aU5vMIbFuPbkm7AICbhEGUSfQIY3XbIjCmpmI7BZg4lMYSxL03ys2gW+
	 MlXqWnluLdyfHqkj98tHf+cioFrxyLj/dzpUyIB85ZW1qKoWTtqogxKs2cuFk7vJWJ
	 r0E2qcSlEIuaIpqf/LF1PrFthz0mgcu3N2CHBGj7nsUxHS3s0sIetcIKzasPF3bLU+
	 K7kOWlH0g8KIPRxUuJVG2Gs4KfU41xfL9k4MRGR4iQ2H9mTSJy6lopM+ONdFplG7Ox
	 tMRcjr3ZL3hy7Nmyzyp6WtvMzwwKt+RnZZR8nLF9pCaNvYtvqH2C5UBMwKqqt61Uhj
	 iR/4KLb7znYRQ==
Message-ID: <sashiko-outbox-238060@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/13] ext4: add tracking for unwritten
 to-be-converted ranges in non iomap buffered path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-7-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
 <20261127-ext4-endio-zero-bug-v2-7-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 18:17:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] ext4: unsubmitted unwritten blocks converted on partial-folio
  map error
- [Medium] ext4: unlocked extent status removal in
  ext4_io_end_clear_convert_pending()
--

commit 4137f0503e7bd7e81a4925f339faf96cecacac77
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: add tracking for unwritten to-be-converted ranges in non iomap buffer=
ed path

This commit passes EXT4_GET_BLOCKS_CONVERT_PENDING in
mpage_map_one_extent() when dioread_nolock is enabled, and clears the
convert-pending status in ext4_end_io_end() if unwritten extent I/O or
conversion fails.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4aafd0aaea699..2031b1dd70694 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2633,7 +2633,8 @@ static int mpage_map_one_extent(handle_t *handle, s=
truct mpage_da_data *mpd)
> =20
>  	dioread_nolock =3D ext4_should_dioread_nolock(inode);
>  	if (dioread_nolock)
> -		get_blocks_flags |=3D EXT4_GET_BLOCKS_UNWRIT_EXT;
> +		get_blocks_flags |=3D EXT4_GET_BLOCKS_UNWRIT_EXT |
> +				    EXT4_GET_BLOCKS_CONVERT_PENDING;
> =20
>  	err =3D ext4_map_blocks(handle, inode, map, get_blocks_flags);
>  	if (err < 0)

[Severity: High]
Can a multi-extent folio failure after the first extent is mapped leave
EXTENT_STATUS_CONVERT_PENDING set on an unlocked folio or convert
unsubmitted unwritten blocks to written?

When blocksize < folio_size(folio), mpage_map_and_submit_extent() loops
across the extents within a single folio before submitting it:

fs/ext4/inode.c:mpage_process_folio() {
    ...
		if (lblk >=3D mpd->map.m_lblk + mpd->map.m_len) {
			mpd->map.m_len =3D 0;
			mpd->map.m_flags =3D 0;
			io_end_vec->size +=3D io_end_size;

			err =3D mpage_process_page_bufs(mpd, head, bh, lblk);
			if (err > 0)
				err =3D 0;
			if (!err && mpd->map.m_len && mpd->map.m_lblk > lblk) {
				io_end_vec =3D ext4_alloc_io_end_vec(io_end);
				if (IS_ERR(io_end_vec)) {
					err =3D PTR_ERR(io_end_vec);
					goto out;
				}
    ...
}

After the first unwritten extent in the folio is mapped with
EXT4_GET_BLOCKS_CONVERT_PENDING and EXT4_IO_END_UNWRITTEN is set on
io_end, mpage_process_folio() clears BH_Delay and BH_Unwritten on those
buffers and adds their length to io_end_vec->size before looking for the
next extent in the folio.

If ext4_alloc_io_end_vec() fails with -ENOMEM,
mpage_map_and_submit_extent() jumps to update_disksize without submitting
the folio, and mpage_release_unused_pages(mpd, false) unlocks the folio
without starting writeback or clearing the extent status cache.  Similarly,
if mapping the second extent in the folio hits a non-retryable error and
jumps to invalidate_dirty_pages, the folio is never submitted for I/O while
the first extent remains recorded in io_end_vec->size.

When ext4_do_writepages() then drops io_end, EXT4_IO_END_FAILED is not set,
so ext4_end_io_end() runs ext4_convert_unwritten_io_end_vec() on the
unsubmitted range, exposing stale on-disk data and marking it
EXTENT_STATUS_WRITTEN.

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 059827b961ec8..6753b35311b46 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -158,6 +158,24 @@ static void ext4_release_io_end(ext4_io_end_t *io_en=
d)
>  	kmem_cache_free(io_end_cachep, io_end);
>  }
> =20
> +/*
> + * The unwritten ranges of a failed io_end were marked convert pending in
> + * mpage_map_one_extent() before the IO was submitted but will not be
> + * converted, so drop the cached state.
> + */
> +static void ext4_io_end_clear_convert_pending(ext4_io_end_t *io_end)
> +{
> +	struct inode *inode =3D io_end->inode;
> +	u8 blkbits =3D inode->i_blkbits;
> +	struct ext4_io_end_vec *io_end_vec;
> +
> +	list_for_each_entry(io_end_vec, &io_end->list_vec, list)
> +		ext4_clear_convert_pending(inode,
> +				io_end_vec->offset >> blkbits,
> +				EXT4_MAX_BLOCKS(io_end_vec->size,
> +						io_end_vec->offset, blkbits));
> +}
> +
>  /*
>   * On successful IO, check a range of space and convert unwritten extent=
s to
>   * written. On IO failure, check if journal abort is needed. Note that
> @@ -195,6 +213,8 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
>  		if (ret < 0)
>  			mapping_set_error(inode->i_mapping, ret);
>  	}
> +	if (ret < 0 && io_end->flag & EXT4_IO_END_UNWRITTEN)
> +		ext4_io_end_clear_convert_pending(io_end);

[Severity: Medium]
Does ext4_io_end_clear_convert_pending() need to hold
EXT4_I(inode)->i_data_sem around ext4_clear_convert_pending()?

ext4_end_io_end() runs after the folio locks have been released and does
not hold i_data_sem.  Inside ext4_clear_convert_pending(), i_es_lock is
dropped between ext4_es_find_extent_range() and ext4_es_remove_extent():

CPU0                                    CPU1
ext4_end_io_end()
  ext4_io_end_clear_convert_pending()
    ext4_clear_convert_pending()
      ext4_es_find_extent_range()
        read_lock(&ei->i_es_lock)
        ...
        read_unlock(&ei->i_es_lock)
                                        down_write(&ei->i_data_sem)
                                        ext4_split_convert_extents()
                                          ...
                                          ext4_es_insert_extent(...,
                                            EXTENT_STATUS_WRITTEN, ...)
                                        up_write(&ei->i_data_sem)
      ext4_es_remove_extent()
        write_lock(&ei->i_es_lock)
        __es_remove_extent()  <-- removes updated extent status entry

Holding at least down_read(&EXT4_I(inode)->i_data_sem) across the cleanup
would serialize against concurrent writers holding i_data_sem in write
mode.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com?part=3D7
