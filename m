Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C514E378838
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 11:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781003081; cv=none; b=oXXsu84KC0OL49d+Wy5V1sfBOWou5ovkQhosQaLeuA6IqZQGa4MGltawUBKK0iOR/eAXxdFNxK+cw902Ad1xp8h24GUzbQkXAFfBITNJM5wD/qUOKg1Sd+bH5bKENp59EbiRGNJOh6UGocxMRyHDBYXhdFVPnJE1wxjpytYYqnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781003081; c=relaxed/simple;
	bh=etkUgiTgvahr8VblWwOlhbCBVBQk/raso/UZ69pxstg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaNx/j1JQ8nRKnt9xchOzTEPNTtzQ9RYME58tQgQdIdMvFkCgCpuKVv0WPZC8c87X7l5LGSkZhDrqjREn62FKstdcddV/iPurZ2DSbvRXHOScQgssAAptPUG9WjNzKCNnHUhza906Q0IfeVLQHQN1gF5GQNK5vyZZa55aVR8BVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FmEssnns; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QtAGgGIg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FmEssnns; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QtAGgGIg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FmEssnns";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QtAGgGIg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FmEssnns";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QtAGgGIg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0E2F568029;
	Tue,  9 Jun 2026 11:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781003078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nTJ4i2+8lkkrLPf4NrMDCRIylkF9+Qrbf1eg0q8cUN4=;
	b=FmEssnnsdbkIzIq+JR2QsC+b836dUIqbnFuTQk1xGBRo+dwSbqox18JS7SDCF40MObqfWr
	0qt7kZPyRBZmlcKyIBgkY+EaRyB/71CL0d6Q98bMLUYS3BduSeTDLWnMKil3nyJI0Lmct7
	wALnRQk8IOefD92tir3x7JISJ3kmV8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781003078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nTJ4i2+8lkkrLPf4NrMDCRIylkF9+Qrbf1eg0q8cUN4=;
	b=QtAGgGIg2gZGsqkoEKFISkSe2BsmCOl8S2GxG1PjHpSFIAut5nnFS9t2Hrn7f+4aI7Wsn9
	VC5FDPfEpnAtbpCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781003078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nTJ4i2+8lkkrLPf4NrMDCRIylkF9+Qrbf1eg0q8cUN4=;
	b=FmEssnnsdbkIzIq+JR2QsC+b836dUIqbnFuTQk1xGBRo+dwSbqox18JS7SDCF40MObqfWr
	0qt7kZPyRBZmlcKyIBgkY+EaRyB/71CL0d6Q98bMLUYS3BduSeTDLWnMKil3nyJI0Lmct7
	wALnRQk8IOefD92tir3x7JISJ3kmV8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781003078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nTJ4i2+8lkkrLPf4NrMDCRIylkF9+Qrbf1eg0q8cUN4=;
	b=QtAGgGIg2gZGsqkoEKFISkSe2BsmCOl8S2GxG1PjHpSFIAut5nnFS9t2Hrn7f+4aI7Wsn9
	VC5FDPfEpnAtbpCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05034779A7;
	Tue,  9 Jun 2026 11:04:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oBU1AUbzJ2oFAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 11:04:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A27D6A0A90; Tue, 09 Jun 2026 13:04:37 +0200 (CEST)
Date: Tue, 9 Jun 2026 13:04:37 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 2/3] ext4: reduce max cluster size to match documented
 256MB limit
Message-ID: <ef3fjehtaztdof6p5eojjn5kpx5s4pihc7fqyglwcpvhrskq5y@is2zyakfliku>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-3-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608111150.827117-3-libaokun@linux.alibaba.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[alibaba.com:email,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.com:email];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,sashiko.dev:url,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 08-06-26 19:11:49, Baokun Li wrote:
> The mke2fs man page documents:
> 
>   Valid cluster-size values are from 2048 to 256M bytes per cluster.
> 
> but EXT4_MAX_CLUSTER_LOG_SIZE was set to 30 (1GB), allowing crafted
> filesystem images to specify cluster sizes up to 1GB.
> 
> On 32-bit systems with bigalloc enabled, the consistency check in
> ext4_handle_clustersize():
> 
>   s_blocks_per_group == s_clusters_per_group * (clustersize / blocksize)
> 
> can overflow when the cluster ratio is large enough. Since
> s_blocks_per_group is not range-checked in the bigalloc path, the
> wrapped product can pass the consistency check, leading to inconsistent
> group geometry and potential out-of-bounds block allocation.
> 
> Reduce EXT4_MAX_CLUSTER_LOG_SIZE to 28 to match the documented 256MB
> limit. With this cap, the maximum product is:
> 
>   (blocksize * 8) * (256M / blocksize) = 2^31
> 
> which fits safely in a 32-bit unsigned long for all block sizes.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

I guess I'll leave it up to Ted to decide whether 28 or 29 in the right
value. Both are fine with me if we are consistent with them :)

								Honza

> ---
>  fs/ext4/ext4.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..11e41a864db8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -334,7 +334,7 @@ struct ext4_io_submit {
>  #define	EXT4_MAX_BLOCK_SIZE		65536
>  #define EXT4_MIN_BLOCK_LOG_SIZE		10
>  #define EXT4_MAX_BLOCK_LOG_SIZE		16
> -#define EXT4_MAX_CLUSTER_LOG_SIZE	30
> +#define EXT4_MAX_CLUSTER_LOG_SIZE	28
>  #ifdef __KERNEL__
>  # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
>  #else
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
