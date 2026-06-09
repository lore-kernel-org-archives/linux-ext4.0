Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029222D876F
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 10:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781001786; cv=none; b=aKd6EEuuDUJ8AOSemhS4X1Uvuv3udzNuTRMaywA5W0frK0XtDIJXnSOx5qM+mTMQ1WE4JmnbXtrY+GBJZGWb4JjYOoSEkBFf1VrUCgY/PRw+imSFKB+UtADJ6jCTR3o79QYgrLE+Nxnb/ksyFA9IndgwfT0H+4XK8P7hotYSu/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781001786; c=relaxed/simple;
	bh=xuFubuJgWQjl+bQV1/2dSBSdPp5kUnXmazg7KGS5XGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bm2uZijRS5gFUMJVUEMQUcXOfWza05ozp10q0aRbVBSkfsNN25R5IQdRQ2PmMEdwRRkRFoWvRAzTUU2kFV64pNw87s8rAR4VMKyz7na75z0sY5U5t8YhjpKN07/H3eJJAPmdR1sfPmMIm1AbN9m624sfBdSSIpqPz7pUv7nWjK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X+2/xWdF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=U9j+Q0Ig; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=X+2/xWdF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=U9j+Q0Ig; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X+2/xWdF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="U9j+Q0Ig";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="X+2/xWdF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="U9j+Q0Ig"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E3FE6A90E;
	Tue,  9 Jun 2026 10:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781001783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HYWUqJLwg+0yktanudLjFWpNWQIQJ3gAT5/7/FRvD/c=;
	b=X+2/xWdF90S6cnl43ZNsXpv90xVMspFhBTxQCGuDNNzW0WsCf0nvVXwNpVHW0zkgv5++pZ
	yNYBvpQUPyhbn4pNT1v9FHzUDp3FTHu2Xo9I4IbMw0ZdP7QTOHrBZfoRfRo/wdCAxiPAmN
	YoPYvvpSvwdYqKwwdSXETDueFFwZ3SM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781001783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HYWUqJLwg+0yktanudLjFWpNWQIQJ3gAT5/7/FRvD/c=;
	b=U9j+Q0IgJQRj6xm+v0NO5bOHZwvh0KRmPk0tozAVP8gK5sLQIG++Yk0hEFVj+JCRj5l2UH
	f0LV7v9jFCdglVBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781001783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HYWUqJLwg+0yktanudLjFWpNWQIQJ3gAT5/7/FRvD/c=;
	b=X+2/xWdF90S6cnl43ZNsXpv90xVMspFhBTxQCGuDNNzW0WsCf0nvVXwNpVHW0zkgv5++pZ
	yNYBvpQUPyhbn4pNT1v9FHzUDp3FTHu2Xo9I4IbMw0ZdP7QTOHrBZfoRfRo/wdCAxiPAmN
	YoPYvvpSvwdYqKwwdSXETDueFFwZ3SM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781001783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HYWUqJLwg+0yktanudLjFWpNWQIQJ3gAT5/7/FRvD/c=;
	b=U9j+Q0IgJQRj6xm+v0NO5bOHZwvh0KRmPk0tozAVP8gK5sLQIG++Yk0hEFVj+JCRj5l2UH
	f0LV7v9jFCdglVBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04208779A7;
	Tue,  9 Jun 2026 10:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HuLoADfuJ2q4bAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 10:43:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9FD01A0A90; Tue, 09 Jun 2026 12:43:02 +0200 (CEST)
Date: Tue, 9 Jun 2026 12:43:02 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] ext4: reject mount if clusters/inodes per group are not
 8-aligned
Message-ID: <e74aavsmygtvpup36cgrm5qrmhxlh2dii6yksf5qpxwdwmpcoy@dwtehykdb34e>
References: <20260608061112.392391-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608061112.392391-1-libaokun@linux.alibaba.com>
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
	URIBL_BLOCKED(0.00)[alibaba.com:email,sashiko.dev:url,suse.com:email,suse.cz:email,msgid.link:url,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,sashiko.dev:url,msgid.link:url,suse.cz:email,alibaba.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 08-06-26 14:11:12, Baokun Li wrote:
> The block and inode bitmap checksums are computed over a whole number of
> bytes: ext4_inode_bitmap_csum_*() use EXT4_INODES_PER_GROUP(sb) >> 3 and
> ext4_block_bitmap_csum_*() use EXT4_CLUSTERS_PER_GROUP(sb) / 8 as the
> length passed to ext4_chksum().
> 
> If s_inodes_per_group or s_clusters_per_group is not a multiple of 8, the
> trailing fractional bits are excluded from the checksum.  Those bits are
> then unprotected, and any incremental csum update path that assumes a
> byte-aligned bitmap can compute a checksum inconsistent with the full
> recalculation, corrupting the on-disk bitmap checksum.
> 
> Reject such filesystems at mount time by adding the missing " & 7"
> alignment checks alongside the existing range validation.
> 
> Suggested-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260508121539.4174601-1-libaokun%40linux.alibaba.com?part=10
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6a77db4d3124..3daf4cdcf07e 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4472,8 +4472,9 @@ static int ext4_handle_clustersize(struct super_block *sb)
>  		sbi->s_cluster_bits = 0;
>  	}
>  	sbi->s_clusters_per_group = le32_to_cpu(es->s_clusters_per_group);
> -	if (sbi->s_clusters_per_group > sb->s_blocksize * 8) {
> -		ext4_msg(sb, KERN_ERR, "#clusters per group too big: %lu",
> +	if (sbi->s_clusters_per_group > sb->s_blocksize * 8 ||
> +	    sbi->s_clusters_per_group & 7) {
> +		ext4_msg(sb, KERN_ERR, "invalid #clusters per group: %lu",
>  			 sbi->s_clusters_per_group);
>  		return -EINVAL;
>  	}
> @@ -5304,7 +5305,8 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
>  		return -EINVAL;
>  	}
>  	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
> -	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
> +	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
> +	    sbi->s_inodes_per_group & 7) {
>  		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
>  			 sbi->s_inodes_per_group);
>  		return -EINVAL;
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
