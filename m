Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792027;
	b=Yvo+33OVqjiyvMK2lMoOZD1Q8jxM6UmDxFz6uS/O7oLNSJD/IiKevkNmdLo1yl8iGvhv
	 G7pIW/eU827n/rQvvAvbv8EQIi3c6jaqGB2iJo4iR3RVyb8Y31WA2aQfs2vmMWDQv6Fok
	 miLL0fkkd+xg2YrvjUpRyzCoExCpd4K0BL+puwGFUCQ0FXABQB/VUzNwk5eUUh3oTXCEj
	 Da0AiIB/WS1optzUNvgk7Uefe9eaUDB3suC7+Ih57vf/x5UK/5Vd0AOjQOzbyI19MZG97
	 tc0tSGTUHTtOnejkYSA1IvxtSqN4SLBNgAvqFDmc21eveZTN4PB/fD8gVkwPZJy0FCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792027;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=dTXX8z4+QohDFtefnUasluM1HjckHoXOnE6T5SSg51Y=;
	b=AAEs31AuCo6LqF4RrsK6GmgBS7SIwRu4GP9mJzSm0/v7TaJOtQ9IrCZXmUg7ry9wiYaf
	 u48h63v3f3pYsd5fClaM/x9h04X6vE0NslMwB9toyp+Oy+2f98ETuZN+rWmfXE52h/CNZ
	 znTnNTHqCyIDKsxMA5iHZx4kvhzRvfttCrkUvXhetrWfNX4+npnEzNNt+dmUfiFW8fNt3
	 4kCXUhjEuH4Ley0ipfcfbi6a/n9YZXU+UGseSbWa33VBDY0z8Qi+S0KnnXGFKpHwlnti1
	 miJdOO6PbwM6hWsQh8Rk2KySRdCNyp/3pGTI76Pbp56GLNNEZeMw7rD8cyKyZe8Kukw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nAAJH3Dy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6iBEJfb8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nAAJH3Dy;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6iBEJfb8;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58793606A31C;
	Fri, 27 Nov 2026 15:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58793606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nAAJH3Dy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6iBEJfb8;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nAAJH3Dy;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6iBEJfb8
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6240222953;
	Fri, 27 Nov 2026 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795792024; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTXX8z4+QohDFtefnUasluM1HjckHoXOnE6T5SSg51Y=;
	b=nAAJH3DyrTcvGKdxu80haCicejfN30Z3VjYw+24CNNnIyTgdPexIjc1Y6/yGCe6FfbaeQ2
	UZU000gGqklGM+tONJ1zETSf3oml0Wv6/b5EXBHjcxiyRMmldfxovLVO+SzZTu+Ztp2pw+
	9bx3EPhS/sx3iGZpw3oP7KAf2xgHKpw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795792024;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTXX8z4+QohDFtefnUasluM1HjckHoXOnE6T5SSg51Y=;
	b=6iBEJfb8PK36buTAYzLZX6v4RJ7TP9iHN4jcwbY0PcDpd6OJAs7Hm9dwS9Gbpch9BrrczW
	VdxCFkl/6e7MqcDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nAAJH3Dy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6iBEJfb8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795792024; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTXX8z4+QohDFtefnUasluM1HjckHoXOnE6T5SSg51Y=;
	b=nAAJH3DyrTcvGKdxu80haCicejfN30Z3VjYw+24CNNnIyTgdPexIjc1Y6/yGCe6FfbaeQ2
	UZU000gGqklGM+tONJ1zETSf3oml0Wv6/b5EXBHjcxiyRMmldfxovLVO+SzZTu+Ztp2pw+
	9bx3EPhS/sx3iGZpw3oP7KAf2xgHKpw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795792024;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTXX8z4+QohDFtefnUasluM1HjckHoXOnE6T5SSg51Y=;
	b=6iBEJfb8PK36buTAYzLZX6v4RJ7TP9iHN4jcwbY0PcDpd6OJAs7Hm9dwS9Gbpch9BrrczW
	VdxCFkl/6e7MqcDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36C1D13432;
	Fri, 27 Nov 2026 15:07:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4W0fBZicCWtHewAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 15:07:04 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id BB8D85106A; Fri, 27 Nov 2026 16:07:03 +0100 (CET)
Date: Fri, 27 Nov 2026 16:07:03 +0100
From: Jan Kara <jack@suse.cz>
To: Petr =?utf-8?B?VmFuxJtr?= <petr.vanek@e2b.dev>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Deepanshu Kartikey <kartikey406@gmail.com>, 
	stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/3] ext4: convert regular file inline data through the
 page cache
Message-ID: <awfevpp6kch4sczxhpublixkaf75sfarvzso4t6rzv4xgyly2n@m56pcc6zn7zo>
References: <20261126201258.1553196-1-petr.vanek@e2b.dev>
 <20261126201258.1553196-3-petr.vanek@e2b.dev>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261126201258.1553196-3-petr.vanek@e2b.dev>
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 6240222953

On Thu 26-11-26 21:12:54, Petr Vaněk wrote:
> ext4_convert_inline_data() moves a regular file's inline data to a new
> block by copying it into the block device's buffer for that block and
> journalling the buffer as metadata.  The file's own writes reach the
> same block through the page cache, and nothing invalidates the
> journalled copy.  When the journal checkpoints it, the stale buffer is
> written over whatever the file has put in the block since.  The page
> cache can also miss the data altogether: a folio read in after the
> conversion reads the block from disk before the checkpoint has written
> it.
> 
> Truncate, fallocate, page_mkwrite and fs-verity all convert inline
> files this way, and since commit ed9356a30e59 ("ext4: convert inline
> data to extents when truncate exceeds inline size") so does every
> truncate that grows an inline file.  An ordinary sequence now loses
> data:
> 
>   mkfs.ext4 -O inline_data /dev/vda
>   mount /dev/vda /mnt
>   xfs_io -f -c "pwrite -S 0x61 0 42" /mnt/f
>   sync; echo 3 > /proc/sys/vm/drop_caches
>   xfs_io -c "truncate 0" -c "truncate 77" -c "pwrite -S 0x62 0 77" /mnt/f
>   sync; echo 3 > /proc/sys/vm/drop_caches
>   od -c /mnt/f    # 77 zero bytes instead of 77 'b'
> 
> Growing the file without shrinking it first leaves the old inline bytes
> on disk but loses whatever was written after the truncate, and
> fallocate or an mmap write on a small inline file loses the new data
> the same way.

Nasty, thanks for analyzing this. How did you find the problem? I.e., is it
some syscall fuzzing, AI analysis, or real users hitting this?

> Convert regular files the way a buffered write does in
> ext4_convert_inline_data_to_extent(): copy the inline data into
> folio 0, drop the inline data, map block 0 with ext4_get_block() and
> dirty the folio.  The data then reaches the disk by writeback, and only
> metadata goes through the journal.  The new helper differs from the
> buffered-write one in three ways:
> 
>  - It always maps a written extent, never an unwritten one, so that in
>    data=ordered mode the commit that drops the inline copy waits for
>    the data.
>  - An empty file needs no block; only the inline data is dropped.
>  - If mapping the block fails, it restores the inline data instead of
>    truncating the file: truncation takes invalidate_lock, which
>    ext4_page_mkwrite() already holds shared.
> 
> Directories keep the old path, since their blocks are metadata.

I have two comments regarding the solution:

1) We converted data using journalled data write to avoid loss of already
written data in case of crash before newly allocated block gets written
out. I personally never liked this much and agree this is asking for big
trouble (as your report shows) so I'm all for getting rid of this case. But
still we should explain the implications in the changelog - if we actually
don't use delayed allocation (which is what you did) and use data=ordered
mode, the data loss after a crash should not happen so I think we are fine.

2) Why did you implement new conversion function and didn't just use
ext4_convert_inline_data_to_extent()? I don't really want *another* inline
data conversion method so if there's some reason why
ext4_convert_inline_data_to_extent() cannot be used, let's discuss how to
make possible to use it...

								Honza

> 
> Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate exceeds inline size")
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Vaněk <petr.vanek@e2b.dev>
> ---
>  fs/ext4/inline.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index acdc65ce4796..537857c3b4b2 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1999,6 +1999,121 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>  	return err;
>  }
>  
> +/*
> + * Move a regular file's inline data to block 0 through the page cache, as a
> + * buffered write does, so the data reaches the disk by writeback.  It must not
> + * be journalled as a metadata block: checkpointing that copy later would
> + * overwrite whatever the file has written to the block since.
> + */
> +static int ext4_convert_inline_data_reg(struct inode *inode)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	int ret, ret2, needed_blocks, no_expand, retries = 0;
> +	unsigned int inline_size, len;
> +	struct buffer_head *bh;
> +	struct ext4_iloc iloc;
> +	struct folio *folio;
> +	handle_t *handle;
> +	void *buf;
> +
> +	needed_blocks = ext4_chunk_trans_extent(inode, 1);
> +
> +	ret = ext4_get_inode_loc(inode, &iloc);
> +	if (ret)
> +		return ret;
> +
> +retry:
> +	buf = NULL;
> +	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		goto out_brelse;
> +	}
> +
> +	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
> +				    mapping_gfp_mask(mapping));
> +	if (IS_ERR(folio)) {
> +		ret = PTR_ERR(folio);
> +		goto out_stop;
> +	}
> +
> +	ext4_write_lock_xattr(inode, &no_expand);
> +	ret = 0;
> +	if (!ext4_has_inline_data(inode))
> +		goto out_unlock;
> +
> +	inline_size = ext4_get_inline_size(inode);
> +	len = min_t(loff_t, inline_size, i_size_read(inode));
> +	if (len > i_blocksize(inode)) {
> +		EXT4_ERROR_INODE(inode, "inline data size %u exceeds block size",
> +				 len);
> +		ret = -EFSCORRUPTED;
> +		goto out_unlock;
> +	}
> +
> +	ext4_fc_track_inode(handle, inode);
> +	if (!len) {
> +		ret = ext4_destroy_inline_data_nolock(handle, inode);
> +		goto out_unlock;
> +	}
> +
> +	buf = kmalloc(inline_size, GFP_NOFS);
> +	if (!buf) {
> +		ret = -ENOMEM;
> +		goto out_unlock;
> +	}
> +	ret = ext4_read_inline_data(inode, buf, inline_size, &iloc);
> +	if (ret < 0)
> +		goto out_unlock;
> +
> +	if (!folio_test_uptodate(folio)) {
> +		ret = ext4_read_inline_folio(inode, folio);
> +		if (ret < 0)
> +			goto out_unlock;
> +	}
> +
> +	ret = ext4_destroy_inline_data_nolock(handle, inode);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/*
> +	 * A written extent, not an unwritten one: in data=ordered mode the
> +	 * commit that drops the inline copy then waits for the data.
> +	 */
> +	ret = ext4_block_write_begin(handle, folio, 0, len, ext4_get_block);
> +	if (ret) {
> +		ext4_restore_inline_data(handle, inode, &iloc, buf, inline_size);
> +		goto out_unlock;
> +	}
> +
> +	bh = folio_buffers(folio);
> +	clear_buffer_new(bh);
> +	if (ext4_should_journal_data(inode)) {
> +		ret = do_journal_get_write_access(handle, inode, bh);
> +		if (!ret) {
> +			folio_mark_dirty(folio);
> +			ret = ext4_handle_dirty_metadata(handle, NULL, bh);
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
> +	ret2 = ext4_journal_stop(handle);
> +	if (!ret)
> +		ret = ret2;
> +	kfree(buf);
> +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> +		goto retry;
> +out_brelse:
> +	brelse(iloc.bh);
> +	return ret;
> +}
> +
>  int ext4_convert_inline_data(struct inode *inode)
>  {
>  	int error, needed_blocks, no_expand;
> @@ -2022,6 +2137,9 @@ int ext4_convert_inline_data(struct inode *inode)
>  			return 0;
>  	}
>  
> +	if (S_ISREG(inode->i_mode))
> +		return ext4_convert_inline_data_reg(inode);
> +
>  	needed_blocks = ext4_chunk_trans_extent(inode, 1);
>  
>  	iloc.bh = NULL;
> -- 
> 2.56.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
