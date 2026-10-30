Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793335028;
	b=NDZOff6rL1rrFTUrJ7zQA5wclsB9SDJRd3CElRXDGIOgmJGKUnJ3Ma7IaJa7UHPbmHwV
	 C86Ao5tE83syKn8M3Qz0OERvIY9vYxGTYeDplFGtYBAb99B69Aanu9RfED4w37fKa4/FH
	 /s/g1f+pe27W4c9/sCjUPcXe8AkNaIDc4efBm+t2nktAGrLZIhmQD9IiioBNAa8s1osp+
	 l9EbJP/4s2lBspslTsFFTavwTr1YbEriyTtDmSqQZ3PVdyISMLmp67U8EIv2AnXB5Wpjg
	 iIBBsfX2ch7GW1/PxCXizeDT9G0S0jh3DYPYFEdu7yymh1P1gnxXPnqaVGXayKmjvxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793335028;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iO7ns9t2L1Jiz9LqzXeP6ZuT8yzFffSODfFWs7gB6eE=;
	b=fRTm0kHB9AgeweI+outYb1/51d0xJ1BckgfzrySXSW7IwffHDlAQSaXfQeqLU0SQoz1m
	 CuLFIuy6ccRL51NUKjKw/VRMJ1pOrmHfJBzDkz9PzcHUS2IehpM1icCJONR2oeV2UhZ+D
	 P4s357FJBM8S38O4pAbDTSs/NAvO5tmPblrGS6FFdHKjOfGfPj1/8DaOChgOGqqKinJ6Z
	 3+0bNb9NQnGmb6Q7YT6Orxo3f5V6yg3g34ZoSi4mEA9bW6K/9ARJHmNHvSsohZZn/LJ6b
	 PQ8z4npSBr6irxjrKzF/rYQsEg2gnSP8lebV7TuTLmNueY8Zt5qakOhSkpdw9QwcmEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QuhM4d9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1A5606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 04:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QuhM4d9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93951F000C1;
	Fri, 30 Oct 2026 04:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793335028;
	bh=iO7ns9t2L1Jiz9LqzXeP6ZuT8yzFffSODfFWs7gB6eE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QuhM4d9GlogtW5DscQlLCCmmBp613eiZfVzUuYbfTxEre2RnNw+4TjGpfogyNnmFk
	 siNng8aj6f0tW3HNJMrqQA16GIIUDOokNBuY49vjWrd8V2m08dK9Oe7KL9PANRilrS
	 U0AelcPBZWU/OvPZasp/YLuKnpk0CaRIdWERUDcI2OjifIz/6noR1XFzQIUODiuG0W
	 oGu8i9MhsDdcmRVGTQZEUH3YW3m8DRtzVH7gM6kLXZ/2Z/VlAoWRzPp+uTO5hjXh+e
	 DRA7vJbIKfG8eWiuI/3pEz9MeKuYoJaiVn9m6qUXv1Wc6i6DupSZqv+FCLnzTzn0oQ
	 aiWnigZ6cXAag==
Message-ID: <sashiko-outbox-190311@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: do not advance i_size on a buffered write that
 copied nothing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hengyu Liang" <hengyul@cs.unc.edu>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261030040520.4138904-1-hengyul@cs.unc.edu>
References: <20261030040520.4138904-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:37:07 +0000
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
- [High] ext4: broken inline data conversion in ext4_da_truncate_failed_wri=
te()
--

commit c64fed07a736168af76e10e5cf487bb520de68ee
Author: Hengyu Liang <hengyul@cs.unc.edu>

ext4: do not advance i_size on a buffered write that copied nothing

This commit prevents ext4_write_end(), ext4_journalled_write_end(), and
ext4_da_do_write_end() from advancing i_size when a buffered write copies
zero bytes. In the delayed allocation path, it also adds
ext4_da_truncate_failed_write() to drop page cache folios and delayed
extents prepared beyond i_size after a failed or short write.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6ede3644a738b..9c20876629bc1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -3349,6 +3352,24 @@ static int ext4_da_should_update_i_disksize(struct=
 folio *folio,
>  	return 1;
>  }
> =20
> +/*
> + * Delalloc counterpart of ext4_truncate_failed_write(): ->write_begin()=
 only
> + * reserved delayed blocks, so drop the page cache and the delayed exten=
ts
> + * beyond i_size and leave the blocks that are allocated there alone.
> + */
> +static void ext4_da_truncate_failed_write(struct inode *inode)
> +{
> +	struct address_space *mapping =3D inode->i_mapping;
> +	ext4_lblk_t lblk =3D EXT4_B_TO_LBLK(inode, inode->i_size);
> +
> +	filemap_invalidate_lock(mapping);
> +	truncate_inode_pages(mapping, inode->i_size);
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ext4_es_remove_extent(inode, lblk, EXT_MAX_BLOCKS - lblk);
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +	filemap_invalidate_unlock(mapping);
> +}
> +
>  static int ext4_da_do_write_end(struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned copied,
>  			struct folio *folio)
> @@ -3386,12 +3407,12 @@ static int ext4_da_do_write_end(struct address_sp=
ace *mapping,
>  	 * checked, we need to update i_disksize here as certain
>  	 * ext4_writepages() paths not allocating blocks and update i_disksize.
>  	 */
> -	if (new_i_size > inode->i_size) {
> +	if (copied && new_i_size > inode->i_size) {
>  		unsigned long end;
> =20
>  		i_size_write(inode, new_i_size);
>  		end =3D offset_in_folio(folio, new_i_size - 1);
> -		if (copied && ext4_da_should_update_i_disksize(folio, end)) {
> +		if (ext4_da_should_update_i_disksize(folio, end)) {
>  			ext4_update_i_disksize(inode, new_i_size);
>  			disksize_changed =3D true;
>  		}
> @@ -3400,9 +3421,13 @@ static int ext4_da_do_write_end(struct address_spa=
ce *mapping,
>  	folio_unlock(folio);
>  	folio_put(folio);
> =20
> -	if (pos > old_size)
> +	if (copied && pos > old_size)
>  		pagecache_isize_extended(inode, old_size, pos);
> =20
> +	/* Drop what ->write_begin() prepared beyond the resulting i_size. */
> +	if (pos + len > inode->i_size)
> +		ext4_da_truncate_failed_write(inode);

[Severity: High]
Can calling ext4_da_truncate_failed_write() when inode->i_size =3D=3D 0 lea=
ve an
inline-data inode in a half-converted state?

Suppose an inode has inline data initialized (EXT4_INODE_INLINE_DATA is set,
EXT4_INODE_EXTENTS is clear, EXT4_STATE_MAY_INLINE_DATA is set, and
i_inline_size =3D=3D 60) with inode->i_size =3D=3D 0 (for example, after tr=
uncating
an inline file to 0 or after a small write that failed with -EFAULT in
ext4_write_inline_data_end()).

If a user then issues a buffered write with pos + len exceeding
ext4_get_max_inline_size(inode) that copies 0 bytes, ext4_da_write_begin()
calls ext4_generic_write_inline_data() ->
ext4_da_convert_inline_data_to_extent():

fs/ext4/inline.c:ext4_da_convert_inline_data_to_extent() {
	...
	ret =3D ext4_block_write_begin(NULL, folio, 0, inline_size,
				     ext4_da_get_block_prep);
	...
	clear_buffer_new(folio_buffers(folio));
	folio_mark_dirty(folio);
	folio_mark_uptodate(folio);
	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
	...
}

This instantiates folio 0, reserves a delayed block at lblk 0, marks folio 0
dirty, and clears EXT4_STATE_MAY_INLINE_DATA while leaving
EXT4_INODE_INLINE_DATA set so that ext4_do_writepages() will later call
ext4_destroy_inline_data() during writeback.

When ext4_da_do_write_end() runs with copied =3D=3D 0, inode->i_size remain=
s 0
and ext4_da_truncate_failed_write() is called with lblk =3D=3D 0. That drops
dirty folio 0 and removes the delayed extent at lblk 0, leaving the inode
with EXT4_INODE_INLINE_DATA set, EXT4_INODE_EXTENTS clear,
EXT4_STATE_MAY_INLINE_DATA clear, and no dirty folio in the page cache:

1. If the 0-byte copy happened because the user buffer was not yet faulted =
in
   on a write at pos >=3D PAGE_SIZE, generic_perform_write() faults in the =
user
   page and retries ext4_da_write_begin(). Because EXT4_STATE_MAY_INLINE_DA=
TA
   is now clear, ext4_da_write_begin() skips recreating folio 0, so
   writeback will not convert the inline data unless another write touches
   folio 0.

2. If a subsequent write enters ext4_write_begin() (for example via
   ext4_nonda_switch()), it skips ext4_try_to_write_inline_data() because
   EXT4_STATE_MAY_INLINE_DATA is clear, and _ext4_get_block() fails with
   -ERANGE because ext4_has_inline_data(inode) is still true.

3. If a subsequent delalloc write writes N <=3D i_inline_size bytes at pos 0
   (creating dirty folio 0 with BH_Delay and a delayed extent at lblk 0
   while EXT4_INODE_INLINE_DATA is still set) and the file is then truncated
   to M (where 0 < M < N) before writeback, ext4_setattr() skips
   ext4_convert_inline_data() because M <=3D i_inline_size, and calls
   ext4_inline_data_truncate():

fs/ext4/inline.c:ext4_inline_data_truncate() {
	...
	if (i_size < inline_size) {
		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
	...
}

   This removes the delayed extent at lblk 0 from the extent status tree
   while folio 0 remains dirty with BH_Delay in the page cache. When
   writeback runs, ext4_map_blocks() finds no delayed extent in the extent
   status tree and returns 0 under EXT4_GET_BLOCKS_IO_SUBMIT, triggering
   WARN_ON_ONCE(!err) in mpage_map_one_extent() and discarding the dirty
   folio in mpage_map_and_submit_extent().

Should ext4_da_truncate_failed_write() restore EXT4_STATE_MAY_INLINE_DATA if
ext4_has_inline_data(inode) is still true when truncating back to 0 (or
avoid dropping folio 0 / lblk 0 when inline data conversion is pending)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030040520.4138=
904-1-hengyul@cs.unc.edu?part=3D1
