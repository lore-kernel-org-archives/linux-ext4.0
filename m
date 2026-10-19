Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E384E0B8A;
	Mon, 19 Oct 2026 11:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792407758; cv=none; b=fUS44Qzw1edOL9xXaGMGP6AZwIJr2V415iA84N4aMn3XTk8XjohcsGS+qEt6CNq216Xx8gV4zorOA14f0od1MDz5mwvcyGikz0YeyfsSOilX5HeEFrrloPw/Wu+pIDgvuFD0vtlcBxnhVU9pi/zDldmRbufv7zqGOQz7tBNV5Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792407758; c=relaxed/simple;
	bh=GHQthElYodFukO8Wk4FyIQVeVUz/66AOdJQjwFPw9Rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TO3X21C4xcbqmPCt5xXLzwTwnJtapUr7VpxDo/+xGKTYtGHA3qC1MpPRCK7JqSJAGE1WiuwpM7IzaiRuJSBaByxP6wGgSLsm+pxwlVysC9VuBwd/dWZshXX45cgSih7kpRVNiOoZIBNERLUyhmIJx7skFfFlhTN0WPHH5eYVcjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oEgtmEoU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dZky7Hn6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ObkBXr+a; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SRZFtaS+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oEgtmEoU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dZky7Hn6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ObkBXr+a";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SRZFtaS+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 392AD21CC7;
	Mon, 19 Oct 2026 11:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792407754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=By1KvhKOe++xK8+cQtNPfkcJ4RuE0S7F5y5fKPhCy1Q=;
	b=oEgtmEoUxWmnkFfjWOGKbjUgw8UTSUpF4//h1vgUgNKfmLVXH4QLH3hJSP3ci0n/cv8m2v
	AdKLeTVFB9i/Xj76eOnxAHn+T1YtXTQ4yeCM+xMhm6I2sJeKyUZRki+3pQqm71B8/SSmtO
	1loXs8mBPAbzCQjS3pWxxjrdGF0jc1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792407754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=By1KvhKOe++xK8+cQtNPfkcJ4RuE0S7F5y5fKPhCy1Q=;
	b=dZky7Hn6PJWHZwPp92pFY/fiBjuzD4REA+tXAdgIW5M1qZ032u2Qk1L0T7RmQOtctSmQ2y
	HXCH7PCFKfBGXbCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792407753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=By1KvhKOe++xK8+cQtNPfkcJ4RuE0S7F5y5fKPhCy1Q=;
	b=ObkBXr+a9ioSeSfgUltkShj5WGp/pRb3txCDmczYjXXaPrE5TBzR4NHi8FRLEo+wG7Blmv
	xzqLivu+YBm7nhXoAfMEqsIzo/d3WbDd9ZTZzkFcpRw2AKftRZTY24p1bJItnfVTstUI2X
	Tr5mdEtnp8cUeuJR7bntc9B8/dmjMOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792407753;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=By1KvhKOe++xK8+cQtNPfkcJ4RuE0S7F5y5fKPhCy1Q=;
	b=SRZFtaS+t08DlqSVh/CHauw1Ny+qb3seSc21mIsutCuA98PAusY8pkJewAyTEO9i/ds6/X
	cbDV1GRxux7tsoDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11A3A134B3;
	Mon, 19 Oct 2026 11:02:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t5cTOsj41WrIDQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 11:02:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9A0CEA1413; Mon, 19 Oct 2026 13:02:32 +0200 (CEST)
Date: Mon, 19 Oct 2026 13:02:32 +0200
From: Jan Kara <jack@suse.cz>
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: record writeback error when discarding pages on
 failed delalloc
Message-ID: <nxmkmipb4fu6ig7rznmupixugfv2cbbusjd2hu6tttpabv5yko@2fx7k6oqdlen>
References: <20261016101605.4039217-1-guolingxing@tju.edu.cn>
 <20261016110311.71391-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016110311.71391-1-guolingxing@tju.edu.cn>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.vnet.ibm.com,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,tju.edu.cn:email]
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO

On Fri 16-10-26 11:03:11, guolingxing wrote:
> When mpage_map_and_submit_extent() gives up on a failed block mapping,
> it sets give_up_on_write so that mpage_release_unused_pages() discards
> the remaining dirty folios. However, the error is not recorded in the
> mapping's writeback error state.
> 
> If this happens during background writeback, a later fsync() may
> report success even though the dirty data was discarded and never
> written. Returning the error from ext4_writepages() is not sufficient
> to notify a later fsync(). In addition, ext4_do_writepages() may clear
> -ENOSPC when committing the journal and retrying, even after the
> affected dirty folios have been discarded.
> 
> Call mapping_set_error() when deciding to give up on the write,
> before the dirty folios are invalidated, so that fsync() can report
> the writeback failure through the mapping's error state.
> 
> The give_up_on_write flag also persists across writeback loop
> iterations. After a fatal -ENOSPC failure sets it, ext4_do_writepages()
> may commit the journal and retry without clearing the flag. If a
> subsequent iteration encounters a transient error and leaves dirty
> folios pending, mpage_release_unused_pages() invalidates them instead
> of preserving them for retry. Initialize give_up_on_write inside the
> loop so that only a fatal failure in the current iteration causes
> the remaining dirty folios to be discarded.
> 
> Fixes: c4a0c46ec92c ("ext4: invalidate pages if delalloc block allocation fails.")
> Fixes: cb530541182b ("ext4: fix up error handling for mpage_map_and_submit_extent()")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

I agree this is a bug but the kernel will complain very loudly to the log
(as this generally means filesystem corruption) so the practical impact of
this is very low. With that reservation feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes since v1:
> - Initialize give_up_on_write in each writeback iteration to prevent
>   a stale value from invalidating dirty folios after an ENOSPC retry.
> - Update the commit message and add the corresponding Fixes tag.
> 
>  fs/ext4/inode.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03..ae54212e0a7d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2505,6 +2505,12 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  				ext4_print_free_blocks(inode);
>  		invalidate_dirty_pages:
>  			*give_up_on_write = true;
> +			/*
> +			 * Record the error so that a subsequent fsync()
> +			 * / errseq check can observe the data loss that
> +			 * discarding these dirty pages implies.
> +			 */
> +			mapping_set_error(inode->i_mapping, err);
>  			return err;
>  		}
>  		progress = 1;
> @@ -2774,7 +2780,6 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
>  	int needed_blocks, rsv_blocks = 0, ret = 0;
>  	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
>  	struct blk_plug plug;
> -	bool give_up_on_write = false;
>  
>  	trace_ext4_writepages(inode, wbc);
>  
> @@ -2892,6 +2897,8 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
>  		goto unplug;
>  
>  	while (!mpd->scanned_until_end && wbc->nr_to_write > 0) {
> +		bool give_up_on_write = false;
> +
>  		/* For each extent of pages we use new io_end */
>  		mpd->io_submit.io_end = ext4_init_io_end(inode, GFP_KERNEL);
>  		if (!mpd->io_submit.io_end) {
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
