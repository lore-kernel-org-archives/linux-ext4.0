Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246605;
	b=nmBxzI3YwcZzyaI5reFA/rZ4EdGTbakQydA++98ke93iSvZWctgkiru9l3y+KKU1+WPf
	 4qe4AIqC0CNH0BRCaoGD2C5LitXv3w+AOu/ST7ZLCmLebPWsIT0GcWsdmAG+uSZFGhvnL
	 zpHgWCipYHjDiao+IJBjAzYHh24ke/9j7LgvoL9vqQAGiNJOmLFe1RfQ/2j3HQPG74hVs
	 CX74CtdZxXzGI/W1wzDV3kc9bPV79fdWJNAh4TuikecgRXA9pYH71xaToCtwdAMZDkVFy
	 oyFsnFP4qtUMkDfmtfWvG2438i76sQdu8O3tJUBLPLPMS96ZJan89sgTMdnQ7uegw3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246605;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7WaOL/yz3CUaaPdrXv7rE8ULiFEEqzeuuoXeAynER3c=;
	b=xnj0BTywmWgvSjcS+fTdPtM722BTK3XwEaIppQOTmhGa8hNBPyR/gBx21xGC5kZt/GGs
	 2ttrFzsRy/OTtvteD/b8O+HY2JhAEop2kv1OUP1zp6Ud+99JqzWWhcJfM0CCijS3FjFac
	 TdK1L5qRTwTcwnsxrG3AjmUfVxqYt42Rl+xSYg6fWpZtDjCLxIqWKLWl1dcCzImAKtPt0
	 9SRZbJFJtsztHjq9djfJog1geBbrvM9bSTVDevgSFNFHVN2qfobVL3bZdBcXkuKKLPzQ4
	 34dYOE8ejT1tHgBJ/peiSDrZhp1ei5e5eh6aA5CPEz021/ioyb4+vS6g+6YGS7nMDQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iyml4BiK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A24F606A31C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iyml4BiK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4591F0089F;
	Mon,  9 Nov 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794246604;
	bh=7WaOL/yz3CUaaPdrXv7rE8ULiFEEqzeuuoXeAynER3c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Iyml4BiKh3ocVY+oarQTrnWLI9CxfZHPMZLEg0VyVsvsxyvMI0WGOq82RNJ5oDt9e
	 R7yzxQc+COmWGenE1xhbzTPDE4QBOZm+X+B8fUIHidROmaBQdxS292hme6OCDIR8U/
	 f1hLoPq630tBSQl/+Cb3wtoVpV3GtJbHHeAShUDnXm9NFe4svhvSi8qLWAs7yh8QWW
	 fwcFN0BeLDdBZ8aXSKOgTzTz78Q/+kms4qsmx9sE5BV5giFDPv3pOQf3A2xs/pmY21
	 D512fS4NKvrokOzgFiYIfJ6T0bxwY7kFaR2IfyV0/tpw3ohn+8OJnAbE/FHqWjFCxv
	 5pcov/qoImmzA==
Message-ID: <sashiko-outbox-205344@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 08/14] fs: set I_METADATA_WRITEBACK in
 mmb_mark_buffer_dirty()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-8-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-8-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 17:50:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] ext4: crash in fastcommit replay when mmb_mark_buffer_dirty()
  sets writeback
- [Medium] fs/buffer: early return in mmb_mark_buffer_dirty() skips
  I_METADATA_WRITEBACK
- [Medium] fs/buffer: mmb_mark_buffer_dirty() sets b_mmb before adding
  bh to mmb->list
--

commit f5c565458ebd0a39fc1e91b886caf335fa191c4d
Author: Christian Brauner <brauner@kernel.org>

fs: set I_METADATA_WRITEBACK in mmb_mark_buffer_dirty()

This commit attaches the inode to a writeback structure and sets
I_METADATA_WRITEBACK in mmb_mark_buffer_dirty() so that fsync() and
inode eviction write out dirty metadata buffers tracked on the mapping.

> diff --git a/fs/buffer.c b/fs/buffer.c
> index 5d3852b726d6b..f951559e7d32c 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -621,12 +621,15 @@ void write_boundary_block(struct block_device *bdev,
>   * @bh: The buffer to mark dirty.
>   * @mmb: The list of buffers to add the buffer to.
>   *
> - * Mark the buffer dirty and add it to the list if it is not already on
> - * a list.
> + * Mark the buffer dirty, add it to the list if it is not already on a l=
ist
> + * and set I_METADATA_WRITEBACK on the inode so that fsync() and eviction
> + * write it out.
>   */
>  void mmb_mark_buffer_dirty(struct buffer_head *bh,
>  			   struct mapping_metadata_bhs *mmb)
>  {
> +	struct inode *inode =3D mmb->mapping->host;
> +
>  	mark_buffer_dirty(bh);
>  	if (!bh->b_mmb) {
>  		spin_lock(&mmb->lock);
> @@ -641,6 +644,15 @@ void mmb_mark_buffer_dirty(struct buffer_head *bh,

[Severity: Medium]
Can a concurrent mmb_mark_buffer_dirty() set I_METADATA_WRITEBACK before
bh is linked onto mmb->list?

CPU0                                    CPU1
mmb_mark_buffer_dirty(bh, mmb)
  spin_lock(&mmb->lock)
  cmpxchg(&bh->b_mmb, NULL, mmb)
                                        mmb_mark_buffer_dirty(bh, mmb)
                                          if (!bh->b_mmb) // false
                                          inode_state_set(...,
                                            I_METADATA_WRITEBACK)
                                        fsync()
                                          __writeback_single_inode()
                                            inode_state_clear(...,
                                              I_METADATA_WRITEBACK)
                                            mmb_sync(mmb)
                                              if (!mmb_has_buffers(mmb))
                                                return 0;  <-- skips bh
  list_move_tail(..., &mmb->list)
  spin_unlock(&mmb->lock)

Because cmpxchg() sets bh->b_mmb before list_move_tail() adds bh to
mmb->list, CPU1 sees bh->b_mmb !=3D NULL without taking mmb->lock, sets
I_METADATA_WRITEBACK, and returns while mmb->list is still empty.  An
intervening fsync() can then clear I_METADATA_WRITEBACK and return early
from mmb_sync() when its lockless mmb_has_buffers() check sees an empty
list, leaving bh unsynced.

[Severity: Medium]
Can the early return on cmpxchg(&bh->b_mmb, NULL, mmb) !=3D NULL skip
setting I_METADATA_WRITEBACK when racing with mmb_sync()?

CPU0                                    CPU1
__writeback_single_inode()
  inode_state_clear(...,
    I_METADATA_WRITEBACK)
  mmb_sync(mmb)
    spin_lock(&mmb->lock)
    __remove_assoc_queue(mmb, bh)
      bh->b_mmb =3D NULL
                                        mmb_mark_buffer_dirty(bh, mmb)
                                          mark_buffer_dirty(bh)
                                          if (!bh->b_mmb) // true
    smp_mb()
    if (buffer_dirty(bh))
      list_add(..., &mmb->list)
      bh->b_mmb =3D mmb
    spin_unlock(&mmb->lock)
                                          spin_lock(&mmb->lock)
                                          cmpxchg(&bh->b_mmb, NULL, mmb)
                                            // returns mmb !=3D NULL
                                          spin_unlock(&mmb->lock)
                                          return;  <-- skips setting bit

__writeback_single_inode() clears I_METADATA_WRITEBACK before calling
sync_inode_metadata() -> mmb_sync().  In the second pass of mmb_sync(),
__remove_assoc_queue() transiently clears bh->b_mmb and then restores
bh->b_mmb =3D mmb after seeing BH_Dirty from CPU1.  CPU1 then fails the
cmpxchg() and returns early without setting I_METADATA_WRITEBACK, leaving
the redirtied buffer on mmb->list with I_METADATA_WRITEBACK clear on the
inode so a subsequent fsync() or evict() will not write it out.

>  		list_move_tail(&bh->b_assoc_buffers, &mmb->list);
>  		spin_unlock(&mmb->lock);
>  	}
> +	/*
> +	 * The inode itself may never have been dirtied, so attach it to a wb
> +	 * before setting the bit or writeback_single_inode() has nothing to
> +	 * lock when evict() syncs it.
> +	 */
> +	spin_lock(&inode->i_lock);
> +	inode_attach_wb(inode, NULL);
> +	inode_state_set(inode, I_METADATA_WRITEBACK);
> +	spin_unlock(&inode->i_lock);
>  }
>  EXPORT_SYMBOL(mmb_mark_buffer_dirty);

[Severity: High]
Does setting I_METADATA_WRITEBACK here cause a NULL pointer dereference
during ext4 fastcommit replay?

0ecd56573c1f ("ext4: Avoid entering writeback paths during fastcommit
replay") guarded ext4_mark_iloc_dirty() against EXT4_FC_REPLAY so it
would not set I_METADATA_WRITEBACK while SB_ACTIVE is still clear and
s_writepages_rwsem is not yet initialized.  However, fastcommit replay
paths such as ext4_fc_replay_create() and ext4_fc_replay_add_range()
dirty directory or extent blocks with handle =3D=3D NULL and a non-NULL
inode, which reaches mmb_mark_buffer_dirty():

fs/ext4/ext4_jbd2.c:__ext4_handle_dirty_metadata() {
    ...
	} else {
		if (inode) {
			if (!ext4_i_metadata_bhs(inode))
				ext4_inode_attach_mmb(inode);
			mmb_mark_buffer_dirty(bh, ext4_i_metadata_bhs(inode));
    ...
}

When replay finishes with the inode and calls iput(), iput_final() sees
!(sb->s_flags & SB_ACTIVE) and calls write_inode_now(inode, 1).  With
I_METADATA_WRITEBACK now set, __writeback_single_inode() runs
do_writepages() -> ext4_writepages() -> percpu_down_read() on the
uninitialized s_writepages_rwsem, crashing the kernel, and also calls
ext4_sync_inode_metadata(), which triggers
WARN_ON_ONCE(EXT4_SB(inode->i_sb)->s_journal) and returns -EFSCORRUPTED.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D8
