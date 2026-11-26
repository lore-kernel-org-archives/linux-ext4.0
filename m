Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795725806;
	b=zaqrmbshjUkFEE3CFKzFyh3BtP6Ix2f387wm2dHHAxw6R5nxMpg0zgg1ocZnUvMke89o
	 6FzJHYiRf3DuX4wGV5MATHhRphqokeRlLjmNxTitKmTFX7EvdRLy7s+Rnn3fYdVJ5fczG
	 tS+vYJNiNEfXrncRMOJlq8U5r0WqZyIWkJeZKpSMeL3dEpznzkfVNE6W52jTzvOJOgOr9
	 8mENUg38MF7W5sNbtdVXOJtjLLFQybZr+QPnZhVpotqFpJUVdXozofnBOP+79KPeyFxq9
	 xGuOtuEAzEMtH4/qgR19viOrqU8QNcR1MFlBntpEl9xgSHaCTAfYFCpxmFGRMjq5AKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795725806;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4/aFF4NCNdDMiO4SBVMAjUl8GfVRChOJbTvo6aRCj1w=;
	b=kbf7UifL7/8lOv4w4IWCCLliAaxg04K95E8mT7qvBRK5kbTWdFGl6fFt46DDo7f9cP5M
	 IbCliEXEJAAEkZrlgSPr+56kaCW7baRa2+rKqzmHj90gEXPMKtbTiUN9d5qZIh1KwGuGp
	 lXE7oY7+c3zW7Xf5T1SdhQvNKEMFHgjDb2VSnYBN8lY6JzIdZrXqXRbfHfPV0zNxi5biw
	 l98Poq3K7hN/XLafJeRlmgdaC6eRLdgQlTSOeIIK+2/CXbngu21AfNiCgT+zl5qdtL4n2
	 2pEp+o9OTwodTlI4CBwuPmlu1nw18yQpQo2tQdHRZ/zYl6rvJFxfjU5dPHS0NaRAB8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GyQuBsLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A70606A69E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 20:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GyQuBsLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D691F00893;
	Thu, 26 Nov 2026 20:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795725806;
	bh=4/aFF4NCNdDMiO4SBVMAjUl8GfVRChOJbTvo6aRCj1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GyQuBsLzSaqagcW3N1nUzeWCqgL3gTbef1mDsGLc7gHQYChj+RzTuCBNZSOIWab0D
	 dhVmaXW0XZclM2jIP1WiShlKGcvEB8R50x471V8HaZss/F7j4dH5RF0cJTyRbEeFll
	 WiXzMS95P3Ho4GTxPtcwulxfv+4QjpMNs8gEB1eYSttgm56R7PIe+8VeE2hj0PAiBb
	 GjeXoXyZGkyskZt4gxtpEUXovfbS9Ftj0iHUiWUR91vas5iZvkz5rw0l99cSTIXPQV
	 tRIjHIjDpYAqJVQEMh7tSOx7C1DXzvs7QYiDHmClJtM09zsyI0N/39XEW2J9568HJc
	 lVi2TFuL95icw==
Message-ID: <sashiko-outbox-236164@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] ext4: convert regular file inline data through the
 page cache
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGV0ciBWYW7Em2s=?= <petr.vanek@e2b.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261126201258.1553196-3-petr.vanek@e2b.dev>
References: <20261126201258.1553196-1-petr.vanek@e2b.dev>
 <20261126201258.1553196-3-petr.vanek@e2b.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 20:43:25 +0000
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
- [High] ext4: NULL jinode dereference in ext4_convert_inline_data_reg()
- [High] ext4: stale inode checksum after rollback in
  ext4_convert_inline_data_reg()
- [Medium] ext4: unhandled -EAGAIN and credit shortfall in
  ext4_convert_inline_data_reg()
- [Medium] ext4: race with delalloc conversion in
  ext4_convert_inline_data_reg()
--

commit cdcc63e61166aa17d9c625ad732f9377e4d25d2b
Author: Petr Van=C4=9Bk <petr.vanek@e2b.dev>

ext4: convert regular file inline data through the page cache

This commit converts a regular file's inline data to an extent block through
folio 0 in the page cache rather than journalling the data block as metadat=
a.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index acdc65ce47960..537857c3b4b29 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1999,6 +1999,121 @@ int ext4_inline_data_truncate(struct inode *inode=
, int *has_inline)
>  	return err;
>  }
> =20
> +/*
> + * Move a regular file's inline data to block 0 through the page cache, =
as a
> + * buffered write does, so the data reaches the disk by writeback.  It m=
ust not
> + * be journalled as a metadata block: checkpointing that copy later would
> + * overwrite whatever the file has written to the block since.
> + */
> +static int ext4_convert_inline_data_reg(struct inode *inode)
> +{
> +	struct address_space *mapping =3D inode->i_mapping;
> +	int ret, ret2, needed_blocks, no_expand, retries =3D 0;
> +	unsigned int inline_size, len;
> +	struct buffer_head *bh;
> +	struct ext4_iloc iloc;
> +	struct folio *folio;
> +	handle_t *handle;
> +	void *buf;
> +
> +	needed_blocks =3D ext4_chunk_trans_extent(inode, 1);
> +
> +	ret =3D ext4_get_inode_loc(inode, &iloc);
> +	if (ret)
> +		return ret;

[Severity: High]
Can this trigger a NULL pointer dereference on EXT4_I(inode)->jinode when
mapping block 0 in data=3Dordered mode?

EXT4_I(inode)->jinode is attached lazily in ext4_file_open() or explicitly =
by
callers that do not require an open writable file descriptor.  When path-ba=
sed
truncate(2) grows a non-empty inline file whose in-core inode has not been
opened for writing, ext4_setattr() calls ext4_convert_inline_data() before
ext4_truncate_up() attaches jinode.  ext4_block_write_begin() then calls
ext4_get_block() -> ext4_map_blocks() -> ext4_jbd2_inode_add_write(), which
passes a NULL jinode to jbd2_journal_file_inode().

Calling ext4_inode_attach_jinode(inode) in ext4_convert_inline_data_reg()
before starting the conversion avoids this.

> +
> +retry:
> +	buf =3D NULL;
> +	handle =3D ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
> +	if (IS_ERR(handle)) {
> +		ret =3D PTR_ERR(handle);
> +		goto out_brelse;
> +	}
> +
> +	folio =3D __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +				    mapping_gfp_mask(mapping));
> +	if (IS_ERR(folio)) {
> +		ret =3D PTR_ERR(folio);
> +		goto out_stop;
> +	}
> +
> +	ext4_write_lock_xattr(inode, &no_expand);
> +	ret =3D 0;
> +	if (!ext4_has_inline_data(inode))
> +		goto out_unlock;

[Severity: Medium]
Can a concurrent delayed-allocation write convert the file between the
EXT4_STATE_MAY_INLINE_DATA check in ext4_convert_inline_data() and acquiring
the folio lock and xattr_sem here?

CPU0 (ext4_page_mkwrite)          CPU1 (buffered write)
ext4_convert_inline_data()
  test MAY_INLINE_DATA (set)
                                  ext4_da_write_inline_data_begin()
                                    ...
                                    ext4_da_convert_inline_data_to_extent()
                                      folio_lock(folio 0)
                                      down_read(xattr_sem)
                                      ext4_block_write_begin(...,
                                        ext4_da_get_block_prep)
                                        -> sets BH_Mapped | BH_Delay
                                      clear MAY_INLINE_DATA
                                      up_read(xattr_sem)
                                      folio_unlock(folio 0)
  ext4_convert_inline_data_reg()
    folio_lock(folio 0)
    ext4_write_lock_xattr()
    ext4_has_inline_data() (still true)
    ext4_destroy_inline_data_nolock()
    ext4_block_write_begin(...,
      ext4_get_block)
      !buffer_mapped(bh) is false <-- skips ext4_get_block()

Because ext4_da_get_block_prep() sets BH_Mapped along with BH_Delay while
leaving EXT4_INODE_INLINE_DATA set until writeback, ext4_block_write_begin()
sees buffer_mapped(bh) =3D=3D true and skips ext4_get_block().  The inline =
data is
destroyed on disk without allocating a block or filing the inode into the
transaction's ordered-data list, and if an error occurs earlier and rolls b=
ack
via ext4_restore_inline_data(), re-setting EXT4_STATE_MAY_INLINE_DATA on the
dirty inode hits BUG_ON(ext4_test_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA)) in ext4_do_writepages().

> +
> +	inline_size =3D ext4_get_inline_size(inode);
> +	len =3D min_t(loff_t, inline_size, i_size_read(inode));
> +	if (len > i_blocksize(inode)) {
> +		EXT4_ERROR_INODE(inode, "inline data size %u exceeds block size",
> +				 len);
> +		ret =3D -EFSCORRUPTED;
> +		goto out_unlock;
> +	}
> +
> +	ext4_fc_track_inode(handle, inode);
> +	if (!len) {
> +		ret =3D ext4_destroy_inline_data_nolock(handle, inode);
> +		goto out_unlock;
> +	}
> +
> +	buf =3D kmalloc(inline_size, GFP_NOFS);
> +	if (!buf) {
> +		ret =3D -ENOMEM;
> +		goto out_unlock;
> +	}
> +	ret =3D ext4_read_inline_data(inode, buf, inline_size, &iloc);
> +	if (ret < 0)
> +		goto out_unlock;
> +
> +	if (!folio_test_uptodate(folio)) {
> +		ret =3D ext4_read_inline_folio(inode, folio);
> +		if (ret < 0)
> +			goto out_unlock;
> +	}
> +
> +	ret =3D ext4_destroy_inline_data_nolock(handle, inode);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/*
> +	 * A written extent, not an unwritten one: in data=3Dordered mode the
> +	 * commit that drops the inline copy then waits for the data.
> +	 */
> +	ret =3D ext4_block_write_begin(handle, folio, 0, len, ext4_get_block);
> +	if (ret) {
> +		ext4_restore_inline_data(handle, inode, &iloc, buf, inline_size);
> +		goto out_unlock;
> +	}

[Severity: High]
Does rolling back via ext4_restore_inline_data() and jumping to out_unlock
leave the on-disk raw inode with an invalid metadata checksum?

Inside ext4_restore_inline_data(), ext4_create_inline_data() zeroes
raw_inode->i_block and the in-inode system.data xattr and calls
ext4_mark_iloc_dirty(), which computes the raw inode checksum over the zero=
ed
bytes.  ext4_write_inline_data() then copies buf back into raw_inode->i_blo=
ck
and the xattr value in iloc.bh without recomputing the checksum, and neither
ext4_restore_inline_data() nor the out_unlock path calls
ext4_mark_iloc_dirty() or ext4_mark_inode_dirty().  When block allocation
fails (for example with -ENOSPC or -EDQUOT) on a file with non-zero inline
data, the committed inode fails ext4_inode_csum_verify() with -EFSBADCRC on=
ce
re-read from disk.

> +
> +	bh =3D folio_buffers(folio);
> +	clear_buffer_new(bh);
> +	if (ext4_should_journal_data(inode)) {
> +		ret =3D do_journal_get_write_access(handle, inode, bh);
> +		if (!ret) {
> +			folio_mark_dirty(folio);
> +			ret =3D ext4_handle_dirty_metadata(handle, NULL, bh);
> +		}
> +	} else {
> +		block_commit_write(folio, 0, len);
> +	}
> +
> +out_unlock:
> +	ext4_write_unlock_xattr(inode, &no_expand);
> +	folio_unlock(folio);
> +	folio_put(folio);
> +out_stop:
> +	ret2 =3D ext4_journal_stop(handle);
> +	if (!ret)
> +		ret =3D ret2;
> +	kfree(buf);
> +	if (ret =3D=3D -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries=
))
> +		goto retry;

[Severity: Medium]
Can ext4_block_write_begin() return -EAGAIN here because needed_blocks is
computed before EXT4_INODE_EXTENTS is set?

When ext4_chunk_trans_extent(inode, 1) runs at the top of
ext4_convert_inline_data_reg(), EXT4_INODE_INLINE_DATA is still set and
EXT4_INODE_EXTENTS is clear, so ext4_index_trans_blocks() only reserves 5
index blocks (and ext4_destroy_inline_data_nolock() then consumes a credit =
on
iloc.bh and sets EXT4_INODE_EXTENTS).  When ext4_block_write_begin() calls
ext4_journal_ensure_extent_credits(), ext4_chunk_trans_blocks(inode, 1) now
requires 11 index blocks for an extent inode, forcing an in-place
ext4_journal_extend() on every non-empty conversion.

If the running transaction cannot be extended in place (for example when it=
 is
locked for commit), ext4_journal_ensure_extent_credits() returns -EAGAIN, a=
nd
because only -ENOSPC is retried here, -EAGAIN is returned to callers such as
ext4_page_mkwrite(), where vmf_fs_error(-EAGAIN) turns it into
VM_FAULT_SIGBUS.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126201258.1553=
196-1-petr.vanek@e2b.dev?part=3D2
