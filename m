Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8207F35677C
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 12:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613030; cv=none; b=u+lDQA7pHX3eIJLR8LBod2o68CfwcFKNrLwyZ64pOaoFxswja1d5FXWCJhS5c14Euiv/XL/XjpYpXqLkj8OpAWKuaIg1tjzK6pTOnXN/SyC15E3VfFN/AZGB2JSpgLtffLqTAZF7j2M9ctumyWzrJZl1zZtKuO2FELUU93DGpmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613030; c=relaxed/simple;
	bh=oSJMWStIdYyByGYmUzeEHRUI3M7wqQR7iqChNOlLF5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLPCmptCSH65lHdUoEs1wM76RZRLG1HgcJLjGfxmMcg9CCegIvufcdlIaYQhaog4nTtE+xrna+vgZTgyVSxJVAz6qWVymtD7bmTFVUROG6ZGb/OOK4zvMJmWEalH5cbexro/PHkbnLMuWGgEth8mUxUuFuFiyzfIo4dyjqKhyZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BbgIFMGs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N1E5Pz5f; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BbgIFMGs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N1E5Pz5f; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BbgIFMGs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N1E5Pz5f";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BbgIFMGs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N1E5Pz5f"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CE40676373;
	Tue, 16 Jun 2026 12:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781613027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTTd5wZ5qZO6Pr2Bu1v0oZCIuqq0yFa2z6h0I+KKnjg=;
	b=BbgIFMGsWWRmK2PWYpj1f2FUKsIUQarl3Huad+oXfr0+6cI0DXBBkwkvZqnGnJ+1alYyCY
	W5YX6I+2e+yNYmKpf9dakjJJ8/o3yZBikKL8ZfaglNXBO5DzerydQ1v6UQDjS9w/P8HTzO
	W8JSW9Yw7SyeuppXg9FFdX1Ck2lU7Js=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781613027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTTd5wZ5qZO6Pr2Bu1v0oZCIuqq0yFa2z6h0I+KKnjg=;
	b=N1E5Pz5fBoYg8YdgzPBKDqHHsRWipIb06fJZ1Z3oo7gdbPN4A/p2XgDVscqlRB1QxqEri7
	JPnGGwFG6E/vFfCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781613027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTTd5wZ5qZO6Pr2Bu1v0oZCIuqq0yFa2z6h0I+KKnjg=;
	b=BbgIFMGsWWRmK2PWYpj1f2FUKsIUQarl3Huad+oXfr0+6cI0DXBBkwkvZqnGnJ+1alYyCY
	W5YX6I+2e+yNYmKpf9dakjJJ8/o3yZBikKL8ZfaglNXBO5DzerydQ1v6UQDjS9w/P8HTzO
	W8JSW9Yw7SyeuppXg9FFdX1Ck2lU7Js=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781613027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTTd5wZ5qZO6Pr2Bu1v0oZCIuqq0yFa2z6h0I+KKnjg=;
	b=N1E5Pz5fBoYg8YdgzPBKDqHHsRWipIb06fJZ1Z3oo7gdbPN4A/p2XgDVscqlRB1QxqEri7
	JPnGGwFG6E/vFfCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C52FC779A8;
	Tue, 16 Jun 2026 12:30:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lZojMONBMWoocAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 12:30:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 79973A12D3; Tue, 16 Jun 2026 14:30:23 +0200 (CEST)
Date: Tue, 16 Jun 2026 14:30:23 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 16/23] ext4: disable online defrag when inode using
 iomap buffered I/O path
Message-ID: <nkcbgbe6usg735sf2crb23b7iwpdogzdf5du7vbuxnevdwopub@ldjegfrhz2zc>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-17-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-17-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 11-05-26 15:23:36, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Online defragmentation does not currently support inodes using the
> iomap buffered I/O path. The existing implementation relies on
> buffer_head for sub-folio block management and data=ordered mode for
> data consistency, both of which are incompatible with the iomap path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/move_extent.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 3329b7ad5dbd..f707a1096544 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -476,6 +476,17 @@ static int mext_check_validity(struct inode *orig_inode,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	/*
> +	 * TODO: support online defrag for inodes that using the buffered
> +	 * I/O iomap path.
> +	 */
> +	if (ext4_inode_buffered_iomap(orig_inode) ||
> +	    ext4_inode_buffered_iomap(donor_inode)) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Online defrag not supported for inode with iomap buffered IO path");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (donor_inode->i_mode & (S_ISUID|S_ISGID)) {
>  		ext4_debug("ext4 move extent: suid or sgid is set to donor file [ino:orig %llu, donor %llu]\n",
>  			   orig_inode->i_ino, donor_inode->i_ino);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
