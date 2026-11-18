Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794991416;
	b=JqvbEUHiJMYK7wTzmX+3BEE1TP8d46K3mxD4t9u/9EK8jw9g8rdWPlF9/4ZzFCOcWP7+
	 60E+2qsjQMGPL5TpKl69nHLtDhrUEMZNP+pUjfI90qYu0X8s5glfH1j3qDdFMEhg/ETIV
	 UtwUBsf0pPWvcSX7NZ9xBdZ5o68SrpbkHh1Wl303MQ9UFqjFu6bALNK4Z8vUmz/29dzmQ
	 JgC2fy7hAW4QxU0iVRqzhNqVOkqZOVnz1IYV8fsgq2Y/FnFyzpCnoUmfucU+iwwLmutpx
	 cAW+G1dTXJTSabmVJF6qUq7REAjLEgosHcyXcVvDvlYahTuU3PXHYJbzGb//0wP+2Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794991416;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SM7XyHEbLwfpJsEN6fFudhlfTqOWNwpzB6K5VmkY8zg=;
	b=AmB+s4J/UAlNwtBJ/gmZcAjMwYoYyZHWHP3FsaHFsVFV30Iydovg5+7b4XOefqXPi/u0
	 W4WB0zAmAwvpTAXzh8cM/cUcrnYIusbSVTSkjXnmUlDS8iaTloAS+pJLcxok9FF/73fZd
	 dlymjCcYnLmNVN1wrauHUS+vyMXIHISYfRQUMeGkPxiFjDGjXbLknezMun6Irl4ZzY3Xu
	 Jlbiw1bXpj/pLr7T4rTiWbHSNs32n6qLpwaTlwT19YU7q6M70XGBr/n96C9arufApImkX
	 CVnq3BaBm1NnUoyzOLICDH9/1l74e0SSQhcozGjeGcmPqKJg7AP8/fHowC99MCnLhAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a2QKL09C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C98606A31C
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2026 08:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a2QKL09C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330E31F000C5;
	Wed, 18 Nov 2026 08:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794991416;
	bh=SM7XyHEbLwfpJsEN6fFudhlfTqOWNwpzB6K5VmkY8zg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a2QKL09CVADCUHyhw5He8hofzv8KYuhjrhLC0dGzU+zVtaSN0I0yJuyyqVrQslGue
	 r1TFMTvC/HOHHCIkmWQ5vVuZw/h5tpzWbSOGEkxfZsPGgNbliU9tIEzkvKcf6gN6sY
	 qXyYdP5dSxf+auFhzSEDDKOysiQCNkQMUdXgeFw54CUuT1orSuundkGP3kTtTxMiWy
	 SJuZQFcu05zfpIxMCF5LrGhKv+0Hu47YbZQzOGFP05WPphB/jxUDcBh1hyeVERll7S
	 ewj16X4d5dTeKdqX2gJxQVbvKBHpzpkEorjw8Ohyme6lIOFVfqpdgLR+Ju80ES/FK5
	 72mwmcIxYifmA==
Message-ID: <sashiko-outbox-220480@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: keep ordered data and i_disksize consistent on
 size changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yichong Chen" <chenyichong@uniontech.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <D7EEAE1F0CDD3029+20261118075044.3511841-1-chenyichong@uniontech.com>
References: <D7EEAE1F0CDD3029+20261118075044.3511841-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 08:43:35 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] ext4: ext4_truncate_up() passes newsize to
  ext4_ordered_flush_to() defeating fast path
- [Medium] ext4: size-preserving ext4_truncate() callers advance
  i_disksize over delalloc
- [Medium] ext4: ext4_ordered_flush_to() skips delalloc inline
  conversion inodes
- [Medium] ext4: ext4_ordered_flush_to() skips in-flight unwritten
  writeback extents
--

commit 1960600589f6e33a9117e96bf09155f80a23934b
Author: Morduan Zang <zhangdandan@uniontech.com>

ext4: keep ordered data and i_disksize consistent on size changes

This commit avoids advancing i_disksize during size-preserving ftruncate()
calls and flushes delayed allocation data via ext4_ordered_flush_to()
before updating i_size and i_disksize on size-changing truncates in
data=3Dordered mode.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 10cd85d4c721b..01d5001e607fd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> @@ -5545,6 +5545,11 @@ int ext4_truncate(struct inode *inode)
>  	return err;
>  }
> =20
> +int ext4_truncate(struct inode *inode)
> +{
> +	return __ext4_truncate(inode, true);
> +}
> +
>  static inline u64 ext4_inode_peek_iversion(const struct inode *inode)
>  {
>  	if (unlikely(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))

[Severity: Medium]
Can size-preserving callers of ext4_truncate() still advance i_disksize
over uncommitted delalloc data?

When a file already has buffered delalloc data below inode->i_size and a
later extending write fails or copies short, ext4_truncate_failed_write()
calls ext4_truncate(inode) to trim blocks past inode->i_size without
changing i_size.  Because ext4_truncate() passes update_disksize =3D true a=
nd
__ext4_truncate() removes the orphan entry at out_stop when inode->i_nlink
is non-zero, this commits i_disksize =3D inode->i_size to the journal while
the earlier delalloc blocks remain unallocated, leaving zero-filled holes
after a crash.

Similarly, ext4_begin_enable_verity() and the error cleanup path in
ext4_end_enable_verity() call ext4_truncate(inode) without changing i_size
before filemap_write_and_wait() runs; on a live inode, orphan recovery in
ext4_process_orphan() only truncates blocks past i_disksize and does not
protect delalloc data below an advanced i_disksize.

> @@ -6907,6 +6912,48 @@ static inline void ext4_set_inode_size(struct inod=
e *inode, loff_t newsize)
>  	up_write(&EXT4_I(inode)->i_data_sem);
>  }
> =20
> +/*
> + * Write back delalloc data before covering it with a new on-disk size.
> + *
> + * DIO and fallocate can advance i_disksize over older delalloc extents,=
 so
> + * include the first delayed extent in the surviving range when choosing=
 the
> + * start.  The inode and invalidate locks held by ext4_setattr() prevent=
 new
> + * delalloc extents; concurrent writeback can only remove them and make =
the
> + * flush more conservative.
> + *
> + * Read i_disksize under i_data_sem to serialize with writeback and avoi=
d a
> + * torn read on 32-bit systems.  Drop the lock before waiting because
> + * writeback needs it to advance i_disksize.
> + *
> + * Inline data is committed with the inode and needs no separate flush.
> + * Must be called without a journal handle and before i_size is lowered.
> + */
> +static int ext4_ordered_flush_to(struct inode *inode, loff_t newsize)
> +{
> +	struct extent_status es;
> +	ext4_lblk_t end_lblk;
> +	loff_t start;
> +
> +	if (!ext4_should_order_data(inode) || ext4_has_inline_data(inode) ||
> +	    newsize <=3D 0)
> +		return 0;

[Severity: Medium]
Does checking ext4_has_inline_data(inode) here skip flushing folio 0 when
an inline inode has a pending delalloc conversion to extents?

When a buffered write exceeds inline capacity,
ext4_da_convert_inline_data_to_extent() copies the inline data into dirty
delalloc folio 0 (with BH_Delay set) and clears EXT4_STATE_MAY_INLINE_DATA,
while leaving EXT4_INODE_INLINE_DATA and i_inline_off set until writeback.
If the file is then truncated to a non-zero size <=3D i_inline_size,
ext4_setattr() skips ext4_convert_inline_data() and ext4_ordered_flush_to()
returns 0 without writing folio 0.  In addition to committing the new
i_disksize over stale on-disk inline data on a crash, shrinking to
0 < newsize < i_inline_size reaches ext4_inline_data_truncate(), which
removes the delayed extent from the extent status tree and releases the
delalloc reservation while folio 0 still has BH_Delay set, triggering a
WARN_ON(1) in ext4_da_update_reserve_space() and reservation underflow
during later writeback.

Checking ext4_has_inline_data(inode) &&
ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) would ensure
inodes with a pending delalloc conversion are flushed.

> +
> +	end_lblk =3D (newsize - 1) >> inode->i_blkbits;
> +	ext4_es_find_extent_range(inode, ext4_es_is_delayed, 0, end_lblk, &es);
> +
> +	down_read(&EXT4_I(inode)->i_data_sem);
> +	start =3D EXT4_I(inode)->i_disksize;
> +	up_read(&EXT4_I(inode)->i_data_sem);
> +
> +	if (es.es_len && es.es_lblk <=3D end_lblk)
> +		start =3D min(start, EXT4_LBLK_TO_B(inode, es.es_lblk));
> +	if (newsize <=3D start)
> +		return 0;
> +
> +	return filemap_write_and_wait_range(inode->i_mapping, start,
> +					    newsize - 1);
> +}
> +

[Severity: Medium]
Can ext4_ordered_flush_to() skip waiting on in-flight writeback if
asynchronous writeback has already mapped the delalloc blocks as unwritten?

With dioread_nolock enabled (the default), mpage_map_and_submit_extent()
maps delayed blocks as unwritten (replacing EXTENT_STATUS_DELAYED with
EXTENT_STATUS_UNWRITTEN) and advances EXT4_I(inode)->i_disksize before the
BIO completes and before ext4_end_io_rsv_work() converts the unwritten
extent to written:

fs/ext4/inode.c:mpage_map_and_submit_extent() {
    ...
		down_write(&EXT4_I(inode)->i_data_sem);
		if (disksize > EXT4_I(inode)->i_disksize)
			EXT4_I(inode)->i_disksize =3D disksize;
		up_write(&EXT4_I(inode)->i_data_sem);
    ...
}

Because unwritten extents use a reserved handle on io_end rather than
jbd2_journal_file_inode(), they do not block transaction commit.  If
background writeback (or filemap_flush() in ext4_convert_inline_data()) has
already mapped the delalloc range as unwritten and raised i_disksize,
ext4_es_find_extent_range() finds no delayed extent and start is >=3D the
in-flight range, so ext4_ordered_flush_to() skips
filemap_write_and_wait_range().  If the truncate transaction commits and
the system crashes before unwritten conversion finishes, the file recovers
with the new i_disksize over unwritten extents that read back as zeros.

>  static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t =
newsize)
>  {
>  	ext4_lblk_t old_lblk, new_lblk;
> @@ -6926,6 +6973,10 @@ static int ext4_truncate_up(struct inode *inode, l=
off_t oldsize, loff_t newsize)
>  			return ret;
>  	}
> =20
> +	ret =3D ext4_ordered_flush_to(inode, newsize);
> +	if (ret)
> +		return ret;
> +
>  	handle =3D ext4_journal_start(inode, EXT4_HT_INODE, 3);
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);

[Severity: Medium]
Should ext4_truncate_up() pass oldsize instead of newsize to
ext4_ordered_flush_to()?

In ext4_truncate_up(), newsize is always greater than oldsize and
i_disksize is at most oldsize, so start <=3D i_disksize <=3D oldsize < news=
ize
always holds.  The fast-path check (newsize <=3D start) in
ext4_ordered_flush_to() is therefore never taken on an extending truncate,
and when oldsize is not block-aligned, filemap_write_and_wait_range()
synchronously writes and waits on the tail block just dirtied by
ext4_block_zero_eof() even when the file had no delalloc extents.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/D7EEAE1F0CDD3029+20=
261118075044.3511841-1-chenyichong@uniontech.com?part=3D1
