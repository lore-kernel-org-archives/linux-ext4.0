Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794249406;
	b=i/Hya1KQmrqrRWbsmE/KFPRxBecYVOe5iukMINp4wy2o2s45oMBEbVCWmN6/tGLbWVAD
	 lEFZbWhMWN7Xt3taYvYqBA6HgDizqUwPskoJ32lI4Ag3WUHamlPy900EVo7dpPD3ljMMk
	 JLyKBDXnRi3dua6Cmd/AUnAOc4KAKagK6gJ5JiSuyoFyk1fd26nFYi9/pQkjR2rjg8+Tn
	 b/YT9GSRsnsuCV4vmFEaUq/Jgd5bIrJ7Lmk44y6OFksSoqDQ2LqsAKPi/ldQFNmbMJ0BJ
	 V7Jc6HFvg+sAAbOnzAh2glvgWnVxFPOOGXGEyzK+bg3FfORUgYQN1iVxPgrCSA+0wwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794249406;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+FugmqOuHfMm55/hhVDOspEg6KmglH5dPW/iir3zkXQ=;
	b=U4KnTVKzGLXrWNODGeD9bZSLjyjj63Eslw0tEkPHa2eIOmsTlZFN7yawZaDCKmWGRYCP
	 +mw0hklYDP5hJmp0GuYn7csPb6J4Zxx6xdTW5J9IRvv2o2oQRrNCv23D0hSTkzhAXtWAb
	 Stc8ZGiCeZlNaMpujVcY2jWuqu7iiZ+fRcM2nxvzuvkUUqd1GpPCWU3T05uKEt/qwEoy1
	 /1Wfmd408gPRurEemvNmt+96ZCTgQdGxVw420WkEoJPgiNuA5VoWTe2O8xFurHq7kVK/o
	 EYzF9cZ1blg/M/KJyqQjQGvu8K/hYdGRwtBFICyjeJu8IT//7rSdyMgSDuMLwDtWn1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QD9RQ6qD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB06606A31C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 18:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QD9RQ6qD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993C91F0089F;
	Mon,  9 Nov 2026 18:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794249405;
	bh=+FugmqOuHfMm55/hhVDOspEg6KmglH5dPW/iir3zkXQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QD9RQ6qDUjTiL06DJsJq2plBIrcenytMx0zGBjl7Rcx5EI8yes3YGL2s0DHFGTDgZ
	 p4ok0LyFMIvihfhtinBOyOlJr7hbkBsTsSM9osZP6YWT4ydWQcNFh29epB+AFM2mQs
	 pvdbZyximlZ99DL2Vib1JUfXjuiDFMxenh5kU5TE1dn2eJwtgjgN/CVwtkMDk0TIlS
	 UNXTDea3PmFq1qG9Tz8HweKPD0xxFOtcUm2gkXSpP2BOV8vUDLI9A94sGKTinjtpjU
	 ZSoAB9oHzmajulL42EfIXjtgbyPA9/LSyprUT0/16Wut/tQmlevmPO5e6o6ngBnlZo
	 ULZzlBfPZYGGg==
Message-ID: <sashiko-outbox-205427@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 10/14] ext2: drop mmb_sync() from
 ext2_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-10-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-10-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 18:36:45 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ext2: unsynced metadata buffers in ext2_evict_inode() on
  mmb_sync() race
--

commit 87b835e8b247e4798e3fb46ec519ae23df154b20
Author: Christian Brauner <brauner@kernel.org>

ext2: drop mmb_sync() from ext2_evict_inode()

This commit removes the mmb_sync() call from ext2_evict_inode(), relying on
evict() to write out metadata buffers tracked via I_METADATA_WRITEBACK.

> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 9261b666d043a..4c38a3a8ea4d7 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -91,8 +91,6 @@ void ext2_evict_inode(struct inode * inode)
>  		if (inode->i_blocks)
>  			ext2_truncate_blocks(inode, 0);
>  		ext2_xattr_delete_inode(inode);
> -	} else {
> -		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
>  	}
>  	mmb_invalidate(&EXT2_I(inode)->i_metadata_bhs);
>  	clear_inode(inode);

[Severity: Medium]
Can ext2_evict_inode() invalidate dirty metadata buffers on i_metadata_bhs
without writing them out if mmb_mark_buffer_dirty() races with mmb_sync()?

In __ext2_truncate_blocks(), ext2_free_branches() modifies
partial->bh->b_data and calls mark_inode_dirty(inode) before calling
mmb_mark_buffer_dirty().  If a concurrent writeback clears I_DIRTY and
I_METADATA_WRITEBACK in __writeback_single_inode() and enters mmb_sync(),
mmb_sync() temporarily sets bh->b_mmb to NULL in __remove_assoc_queue() and
restores bh->b_mmb =3D mmb if the buffer was dirtied again:

CPU0                                  CPU1
__ext2_truncate_blocks()
  ext2_free_branches()
    mark_inode_dirty(inode)
                                      __writeback_single_inode()
                                        inode_state_clear(...,
                                          I_METADATA_WRITEBACK)
                                        ext2_sync_inode_metadata()
                                          mmb_sync()
                                            spin_lock(&mmb->lock)
                                            __remove_assoc_queue()
                                              bh->b_mmb =3D NULL
  mmb_mark_buffer_dirty()
    mark_buffer_dirty(bh)
    if (!bh->b_mmb) // true
                                            if (buffer_dirty(bh)) {
                                              list_add(..., &mmb->list)
                                              bh->b_mmb =3D mmb
                                            }
                                            spin_unlock(&mmb->lock)
      spin_lock(&mmb->lock)
      if (cmpxchg(&bh->b_mmb,
                  NULL, mmb) !=3D NULL) {
        spin_unlock(&mmb->lock)
        return;  <-- skips setting I_METADATA_WRITEBACK
      }

Because mmb_sync() only waits on in-flight I/O in its second loop without
submitting new I/O for the re-dirtied buffer, and mmb_mark_buffer_dirty()
returns early without setting I_METADATA_WRITEBACK, the dirty buffer remains
on i_metadata_bhs with I_METADATA_WRITEBACK clear on the inode.

With mmb_sync() removed from ext2_evict_inode(), evict() skips
sync_inode_metadata() and ext2_evict_inode() detaches the dirty buffer via
mmb_invalidate().  If the inode is later re-read from disk and fsync()ed
before background block device writeback flushes the buffer, fsync() will no
longer see the buffer on i_metadata_bhs and can return before the indirect
block is persisted to disk.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D10
