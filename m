Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795535611;
	b=XoLWVPQZpk2x0SJlyuti78idhwIpY74JHliwuhmZIprEMu5SujRGxerNJNIpMS97zq4+
	 63rZJ1gfQiFICVQ3TejAQDqzNgevYv9iGrbuIeKe+UzXr9A1d2GmQVpDAK2ub5rxm4/U+
	 b0V6tux5Ate1cUEOFE3dxynNPgKdKDWpU9mjtFfGuPrenYIzErwEoKc/eyWV2nG1Qv9Vr
	 rkJekadQ2npy3fVYRpVBoz6YR3dlFAn9v4JzYfTxCnfKsWHZ//Ey9ERikbHCtA0nf1Cx+
	 iAe5icH+A5ZKT6fpSeXa6JyVOn+rFZ8BZb4dST+JjrN5HWetsz7A8YqkLT8W8tMhAbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535611;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=lUyOpI4ZllHADObrpfElouVz31YbKj6UKHW0iS6ONz0=;
	b=X2tYG3I3QfwtClvnp/l/x3k54i5R2t4IRRBPquag3a2nrlsWlFe5K3JBECYsTYPTF+Cq
	 Haf6A6RH81KQFIzj38AtMTPCT0w6fzKgrCGwQeV7Mx7hq1sU1nUOxcXGGfX7/8BQNk7Lw
	 iDUce71BnBmqTcT0u4T2x2u030gmvTnbdEVcOBYHs0No1hZYRBIYlTyD2zDfiz7EHfSAl
	 lDLluqhMkeyXFw9q0L2QX9wxcPZw2KG+xztSI9M+Q6UW86oIwSF1NTIGK4hm0n8sj5Kwx
	 G1xUZd2n/7HIzycgGRHycfW/QjC2Mf49Dg+w5XLDViEZuGmIE8TGeu17L06JlaL82DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=If0WT6b1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="+oeAg/Fq";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="yiDg/mTp";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vsI4CcAK;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0043606A330;
	Tue, 24 Nov 2026 15:53:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0043606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=If0WT6b1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+oeAg/Fq;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yiDg/mTp;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vsI4CcAK
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B28931FA90;
	Tue, 24 Nov 2026 15:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795535607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lUyOpI4ZllHADObrpfElouVz31YbKj6UKHW0iS6ONz0=;
	b=If0WT6b1oNX0NsP8KXz5hz6w0OSeaw9JT644GXpYQPnGdADQ91TExi85nHg0ISPl7nU+2N
	ZVcK1R8Lho0S30c61RiduJcde4OSOU10IQeqWnqPmREm60rliRvK3SSKNewPcD2f3KTQug
	fCxn2YndinPp5MBbEXNnjJjqVkCB2V0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795535607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lUyOpI4ZllHADObrpfElouVz31YbKj6UKHW0iS6ONz0=;
	b=+oeAg/FqO3xs5p1Ei7p3mNU8GOy5FY7hkYBtNZSfuvMxBYbqTbUEK3IVXh4H4UwrpTjBRn
	MfdpvvR5kyIT/oDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795535606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lUyOpI4ZllHADObrpfElouVz31YbKj6UKHW0iS6ONz0=;
	b=yiDg/mTpoeRxI9KmKBzg8ax7YuuDuBdFThYc2xjfBHx2IK27wifmrA1ITt+9arXDIDNSeg
	GzX6e5MS12JLhCVOqI0hUR9w+f6p4MgYeo+YmTVHJ0ogsA9KCLO3B7yABEw2m0xFCVh2MB
	wXI9UYfiA+ThNfcbbHAMzjvaEBPdYus=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795535606;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lUyOpI4ZllHADObrpfElouVz31YbKj6UKHW0iS6ONz0=;
	b=vsI4CcAKPvBK1xOClFivut6AW0vsOHLUURooEVG6ffRR+bPZXrjlbQida2R6oYVmoN+JIK
	yLL7eT6at1S5fZAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8638813505;
	Tue, 24 Nov 2026 15:53:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A0S1GPayBWsUCAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 15:53:26 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 150C227A04; Tue, 24 Nov 2026 16:53:22 +0100 (CET)
Date: Tue, 24 Nov 2026 16:53:22 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, 
	Baokun Li <libaokun@linux.alibaba.com>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, guolingxing <guolingxing@tju.edu.cn>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
Message-ID: <osarljpnd2viffbi3lrgqccyjxjo6ktez73sizcstqjiaw3cbc@e5jnepamtbkl>
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
 <10712329-a587-496d-babf-620ebfd0e60e@huaweicloud.com>
 <20261118-jf-ext4-enospc-reply-zhangyi-v13-3886a3248c32@linux.dev>
 <9be1cb3e-4417-4609-bc0d-67dcfa24aa10@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9be1cb3e-4417-4609-bc0d-67dcfa24aa10@huaweicloud.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,linux.ibm.com,mit.edu,suse.cz,linux.alibaba.com,dilger.ca,gmail.com,tju.edu.cn,toxicpanda.com,kernel.org,vger.kernel.org,lists.linux.dev];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Tue 24-11-26 12:49:19, Zhang Yi wrote:
> On 11/18/2026 10:06 PM, Jose Fernandez (Anthropic) wrote:
> > On Wed, Nov 18, 2026 Zhang Yi wrote:
> >> Could you provide a reproducer? My guess is that high concurrency causes
> >> the blocks freed by my current process to be taken by I/O issued by
> >> other processes
> > 
> > That fits our runs. I'll send you the script off-list.
> > 
> > - Jose
> 
> 
> Thank you for the reproducer. After debugging, I confirmed the cause. On
> each failed endio conversion, the retry commits the journal, but the
> blocks released by the commit are soon claimed again by the
> background fallocate loop, so after 3 retries the DIO finally returns
> ENOSPC.
> 
> Although Ojaswin's v2 does track the exact ranges when submitting I/Os,
> we cannot convert the whole extent after zeroing until all in-flight I/Os
> overlapping this extent have finished, which is too expensive to me. So I
> think we may still need the split to succeed.
> 
> Note that we do reserve space for exactly this case. At mount time we
> set aside s_resv_clusters (2% of the clusters, capped at 4096 clusters),
> and EXT4_GET_BLOCKS_METADATA_NOFAIL is allowed to use it. The problem is
> that this reservation is not effective today. s_freeclusters_counter is
> incremented when blocks are freed, but for journaled frees the blocks
> only return to the buddy allocator after the freeing transaction
> commits. Most allocation paths already run inside a transaction, so we
> cannot force a commit from there, and even between retries the released
> space can be taken again, as the reproducer shows. So ordinary
> allocations can currently consume the reserved pool, and endio extent
> splits can be fooled into thinking space is available. This hurts both
> endio extent conversion and delalloc writeback.
> 
> My idea is to make this a real reservation of currently allocatable
> clusters rather than just a counter check. We can subtract
> sbi->s_mb_free_pending from free_clusters in ext4_has_free_clusters().
> Then a successful check no longer counts clusters that cannot be
> allocated yet, ordinary allocations can no longer eat into the reserved
> pool, and the endio split can fall back on the reserve without having to
> force a commit first. Delalloc reservations benefit as well, since
> writeback is less likely to run into ENOSPC.
> 
> The downside is that ENOSPC may be returned earlier, e.g. by buffered
> writes under the same heavy concurrency. I think that is acceptable
> since the retry is best effort anyway, and ext4_should_retry_alloc()
> still forces a commit when there are pending frees, so it can cover most
> scenarios. Even if it does fail, it is better to fail early than to fail
> after the data has already been written. This is also consistent with
> the behavior of allocating blocks directly when writing in old
> dioread_lock mode.
> 
> With the reproducer, this takes the DIO ENOSPC rate from ~11% to 0, and
> failed conversion attempts from ~1500-2200 per run to ~0.3 per run.
> fallocate ENOSPC did not increase noticeably (2.0% before vs 2.2% after).
> However, the probability of returning ENOSPC for pure append writes
> increases by about 10%.
> 
> Does this approach sounds OK?

Yes, it sounds good to me. I was also puzzled why the reserved clusters are
not effective so thanks for explaining that :)

								Honza

> The specific POC V2 fix code is as follows (based on Ojaswin's v1
> series, and in addition to changing the free_cluster accounting, it also
> fixes the fsync_tid issue mentioned earlier).
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 778fe8788f06..d4e0bb90a402 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -625,12 +625,14 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
>  				  s64 nclusters, unsigned int flags)
>  {
>  	s64 free_clusters, dirty_clusters, rsv, resv_clusters;
> +	int pending_clusters;
>  	struct percpu_counter *fcc = &sbi->s_freeclusters_counter;
>  	struct percpu_counter *dcc = &sbi->s_dirtyclusters_counter;
> 
>  	free_clusters  = percpu_counter_read_positive(fcc);
>  	dirty_clusters = percpu_counter_read_positive(dcc);
>  	resv_clusters = atomic64_read(&sbi->s_resv_clusters);
> +	pending_clusters = atomic_read(&sbi->s_mb_free_pending);
> 
>  	/*
>  	 * r_blocks_count should always be multiple of the cluster ratio so
> @@ -639,13 +641,23 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
>  	rsv = (ext4_r_blocks_count(sbi->s_es) >> sbi->s_cluster_bits) +
>  	      resv_clusters;
> 
> +	/*
> +	 * Clusters in s_mb_free_pending are already counted in
> +	 * s_freeclusters_counter when freed, but they can't be allocated
> +	 * until the transaction that freed them commits, so don't count
> +	 * them as available.
> +	 */
> +	free_clusters -= pending_clusters;
>  	if (free_clusters - (nclusters + rsv + dirty_clusters) <
>  					EXT4_FREECLUSTERS_WATERMARK) {
> -		free_clusters  = percpu_counter_sum_positive(fcc);
> +		free_clusters  = percpu_counter_sum_positive(fcc) -
> +				 pending_clusters;
>  		dirty_clusters = percpu_counter_sum_positive(dcc);
>  	}
> -	/* Check whether we have space after accounting for current
> -	 * dirty clusters & root reserved clusters.
> +
> +	/*
> +	 * Check whether we have space after accounting for current
> +	 * dirty clusters, pending frees & root reserved clusters.
>  	 */
>  	if (free_clusters >= (rsv + nclusters + dirty_clusters))
>  		return 1;
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8069521442a7..441356999594 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1761,6 +1761,7 @@ struct ext4_sb_info {
> 
>  	/* workqueue for reserved extent conversions (buffered io) */
>  	struct workqueue_struct *rsv_conversion_wq;
> +	struct workqueue_struct *iomap_conversion_wq;
> 
>  	/* timer for periodic error stats printing */
>  	struct timer_list s_err_report;
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91857b46ce24..f9502d78f86b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3423,10 +3423,29 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
>  		if (err)
>  			/* ZEROOUT failed, just return original error */
>  			goto out_unlock;
> +	} else if (flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE) {
> +		/*
> +		 * The caller wants to split the extent before submitting
> +		 * the I/O, but the split failed.  Zeroout the whole extent
> +		 * and mark it initialized as the last resort, the upcoming
> +		 * I/O will overwrite the map range.
> +		 */
> +		if (!is_unwrit) {
> +			/* Shouldn't happen. Just exit */
> +			err = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		lblk = ee_block;
> +		len = ee_len;
> +		pblk = ext4_ext_pblock(ex);
> +		err = ext4_issue_zeroout(inode, lblk, pblk, len);
> +		if (err)
> +			/* ZEROOUT failed, just return original error */
> +			goto out_unlock;
>  	} else {
>  		/*
> -		 * We no longer perform unwritten to unwritten splits in IO paths.
> -		 * Hence this should not happen.
> +		 * This should not happen.
>  		 */
>  		WARN_ON_ONCE(true);
>  		err = -EINVAL;
> @@ -4073,6 +4092,38 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
>  	trace_ext4_ext_handle_unwritten_extents(inode, map, flags,
>  						*allocated, newblock);
> 
> +	/* get_block() before submitting IO, split the extent */
> +	if (flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE) {
> +		int depth;
> +
> +		path = ext4_split_convert_extents(handle, inode, map, path,
> +						  flags, allocated);
> +		if (IS_ERR(path))
> +			return path;
> +
> +		/*
> +		 * shouldn't get a 0 allocated when splitting an extent unless
> +		 * m_len is 0 (bug) or extent has been corrupted
> +		 */
> +		if (unlikely(*allocated == 0)) {
> +			EXT4_ERROR_INODE(inode,
> +					 "unexpected allocated == 0, m_len = %u",
> +					 map->m_len);
> +			err = -EFSCORRUPTED;
> +			goto errout;
> +		}
> +		/* Don't mark unwritten if the extent has been zeroed out. */
> +		path = ext4_find_extent(inode, map->m_lblk, path, flags);
> +		if (IS_ERR(path))
> +			return path;
> +		depth = ext_depth(inode);
> +		if (ext4_ext_is_unwritten(path[depth].p_ext))
> +			map->m_flags |= EXT4_MAP_UNWRITTEN;
> +		else
> +			ext4_update_inode_fsync_trans(handle, inode, 1);
> +		goto split_out;
> +	}
> +
>  	/* IO end_io complete, convert the filled extent to written */
>  	if (flags & EXT4_GET_BLOCKS_CONVERT) {
>  		path = ext4_convert_unwritten_extents_endio(handle, inode,
> @@ -4126,7 +4177,7 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
>  		err = -EFSCORRUPTED;
>  		goto errout;
>  	}
> -
> +split_out:
>  	map->m_flags |= EXT4_MAP_NEW;
>  map_out:
>  	map->m_flags |= EXT4_MAP_MAPPED;
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 52b1fb99484d..96049dc54963 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -450,14 +450,30 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
>  	loff_t pos = iocb->ki_pos;
>  	struct inode *inode = file_inode(iocb->ki_filp);
> 
> +	if (!error && size && (flags & IOMAP_DIO_UNWRITTEN)) {
> +		int retries = 0;
> 
> -	if (!error && size && (flags & IOMAP_DIO_UNWRITTEN) &&
> -			(iocb->ki_flags & IOCB_ATOMIC))
> -		error = ext4_convert_unwritten_extents_atomic(NULL, inode, pos,
> -							      size);
> -	else if (!error && size && flags & IOMAP_DIO_UNWRITTEN)
> -		error = ext4_convert_unwritten_extents(NULL, inode, pos, size,
> -						       NULL, 0);
> +retry_convert:
> +		if (iocb->ki_flags & IOCB_ATOMIC)
> +			error = ext4_convert_unwritten_extents_atomic(NULL,
> +					inode, pos, size);
> +		else
> +			error = ext4_convert_unwritten_extents(NULL, inode,
> +					pos, size, NULL, 0);
> +
> +		/*
> +		 * The conversion may have failed to allocate metadata for
> +		 * splitting the extent.  Blocks freed by other operations
> +		 * (e.g. an unlink) may still be waiting for a journal
> +		 * commit, so commit and retry the conversion.
> +		 */
> +		if (error == -ENOSPC && EXT4_SB(inode->i_sb)->s_journal &&
> +		    ext4_count_free_clusters(inode->i_sb) &&
> +		    ++retries <= 3) {
> +			if (ext4_force_commit(inode->i_sb) == 0)
> +				goto retry_convert;
> +		}
> +	}
> 
>  	/*
>  	 * If this dio covered an unwritten extent, we would have incremented
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 13449e4ebb6a..03d296f54b6d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -991,7 +991,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  			goto out;
>  		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
>  		    (flags & EXT4_GET_BLOCKS_UNWRIT_EXT) &&
> -		    !(flags & EXT4_GET_BLOCKS_CONVERT)) {
> +		    !(flags & (EXT4_GET_BLOCKS_CONVERT |
> +			       EXT4_GET_BLOCKS_SPLIT_NOMERGE))) {
>  			/* Contains EXT4_GET_BLOCKS_CREATE - mark mapped. */
>  			ret = check_block_validity(inode, map);
>  			if (!ret)
> @@ -2600,8 +2601,17 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
>  			   EXT4_EX_NOCACHE;
> 
>  	dioread_nolock = ext4_should_dioread_nolock(inode);
> -	if (dioread_nolock)
> -		get_blocks_flags |= EXT4_GET_BLOCKS_UNWRIT_EXT;
> +	if (dioread_nolock) {
> +		get_blocks_flags |= EXT4_GET_BLOCKS_SPLIT_NOMERGE |
> +				    EXT4_GET_BLOCKS_UNWRIT_EXT;
> +		/*
> +		 * The io_end is accounted in i_conv_pending_ios only after
> +		 * the first unwritten extent has been mapped, so tell the
> +		 * zeroout fallback whether our own count is already included.
> +		 */
> +		if (!(mpd->io_submit.io_end->flag & EXT4_IO_END_UNWRITTEN))
> +			get_blocks_flags |= EXT4_GET_BLOCKS_NO_CONV_ACC;
> +	}
> 
>  	err = ext4_map_blocks(handle, inode, map, get_blocks_flags);
>  	if (err < 0)
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index e99816017a18..35826bd19b51 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -649,7 +649,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  	unsigned long io_mode = (unsigned long)ioend->io_private;
>  	bool is_disksize_grow = (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO);
>  	handle_t *handle;
> -	int credits;
> +	int credits, retries = 0;
>  	int ret, err;
> 
>  	/*
> @@ -684,6 +684,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  	/* Wait for disksize-pending zeroed data to be written out. */
>  	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);
> 
> +retry:
> +	ret = 0;
>  	/*
>  	 * We may need to convert one extent, update the i_disksize and
>  	 * dirty the inode.
> @@ -702,6 +704,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  						    is_disksize_grow);
>  		if (ret)
>  			goto out_journal;
> +
> +		is_disksize_grow = false;
>  	}
> 
>  	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
> @@ -714,6 +718,12 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  		ret = err;
>  out_err:
>  	if (ret < 0 && !ext4_emergency_state(sb)) {
> +		if (ret == -ENOSPC && EXT4_SB(sb)->s_journal &&
> +		    ext4_count_free_clusters(sb) && ++retries <= 3) {
> +			if (ext4_force_commit(sb) == 0)
> +				goto retry;
> +		}
> +
>  		ext4_msg(sb, KERN_EMERG,
>  			 "failed to convert unwritten extents to written extents or update inode size -- potential data loss! (inode %llu, error %d)",
>  			 inode->i_ino, ret);
> @@ -768,7 +778,7 @@ void ext4_iomap_end_bio(struct bio *bio)
> 
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	if (list_empty(&ei->i_rsv_conversion_list))
> -		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
> +		queue_work(EXT4_SB(ioend->io_inode->i_sb)->iomap_conversion_wq,
>  			   &ei->i_rsv_conversion_work);
>  	list_add_tail(&ioend->io_list, &ei->i_rsv_conversion_list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3c53bf27da45..859b9c65fc0b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1326,6 +1326,7 @@ static void ext4_put_super(struct super_block *sb)
>  	flush_delayed_work(&sbi->s_ea_inode_work);
>  	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
> 
> +	destroy_workqueue(sbi->iomap_conversion_wq);
>  	destroy_workqueue(sbi->rsv_conversion_wq);
>  	ext4_release_orphan_info(sb);
> 
> @@ -5668,6 +5669,23 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  		goto failed_mount4;
>  	}
> 
> +	/*
> +	 * Buffered iomap conversions may have to force a journal commit and
> +	 * retry.  That commit can wait for the writeback/endio of a
> +	 * buffer_head io_end which is completed on rsv_conversion_wq, so the
> +	 * iomap conversions must not share that single-threaded workqueue.
> +	 */
> +	EXT4_SB(sb)->iomap_conversion_wq =
> +		alloc_workqueue("ext4-iomap-conversion",
> +				WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
> +	if (!EXT4_SB(sb)->iomap_conversion_wq) {
> +		ext4_msg(sb, KERN_ERR, "failed to create workqueue");
> +		err = -ENOMEM;
> +		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
> +		EXT4_SB(sb)->rsv_conversion_wq = NULL;
> +		goto failed_mount4;
> +	}
> +
>  	/*
>  	 * The jbd2_journal_load will have done any necessary log recovery,
>  	 * so we can safely mount the rest of the filesystem now.
> @@ -5842,6 +5860,8 @@ failed_mount8: __maybe_unused
>  	sb->s_root = NULL;
>  failed_mount4:
>  	ext4_msg(sb, KERN_ERR, "mount failed");
> +	if (EXT4_SB(sb)->iomap_conversion_wq)
> +		destroy_workqueue(EXT4_SB(sb)->iomap_conversion_wq);
>  	if (EXT4_SB(sb)->rsv_conversion_wq)
>  		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
>  failed_mount_wq:
> @@ -6543,6 +6563,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
>  		return ret;
> 
>  	trace_ext4_sync_fs(sb, wait);
> +	flush_workqueue(sbi->iomap_conversion_wq);
>  	flush_workqueue(sbi->rsv_conversion_wq);
>  	flush_delayed_work(&sbi->s_ea_inode_work);
>  	/*
> 
> 
> 
> 
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
