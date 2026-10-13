Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3099F4D8D93;
	Tue, 13 Oct 2026 12:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895666; cv=none; b=UZTqDu9P/1HD/5Rn3j7dr3wOzglTNvuR03nV6TdIYYXDo/id0JvRNbJ0ZlusbYo5izS+/RRmi5mn08veDsjsfPujBwZwC7IUV/hrlV5R1PnWFCmaoDaTqIvafRWP5CFNYXTH6lIBEWRCz/C6lbdTFCTzOYkCcgJSVxnllFwUZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895666; c=relaxed/simple;
	bh=8CllIkWhHVgfO1bGEf3mK5YDZ7TH2GqvgtyATU0oq9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpUhl91rRtNbcuQRh9CDRA4WDkhxQZJD87QfYVAdJjSUFqgltEbtlpeloVZbblVcyEFJumtD+PzuVeIhz5bw6+VWvfeAK1nGC+udnfPFn5QFA+3icHBcMoY6eZZGj+ZxFxrEuyG3YkNDXpNqjWSHXDQVABgHr2aCDCISMKBKTT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZQehcYaC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H/AQrcYF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZQehcYaC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H/AQrcYF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZQehcYaC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H/AQrcYF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZQehcYaC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H/AQrcYF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 561EB21E1C;
	Tue, 13 Oct 2026 12:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791895663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K9A3HLQ1YpUoEldxY7Q0RhsLuJG7jCunBt00AddwxcU=;
	b=ZQehcYaClAroKBYbpCpACaMg2irDrAwBZoVZ3xUXkn2DExV3KPpkIA/h+buGUq7kvkcxzu
	IxQej/DBhjBTbl/cBGcTQj0G9rvZxrvO/TuidHoZrh/n46MaIQRytEp3rUjP/y6y4RSbzP
	0Xs7AcgqkxAG/zx8fSe9zD54imMJQfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791895663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K9A3HLQ1YpUoEldxY7Q0RhsLuJG7jCunBt00AddwxcU=;
	b=H/AQrcYFu0yTbNdbcgFXZRnDGny9YzquOxA90hoPoQbfcXvkC/CPxMD473bAcBxGyyxPKg
	ihQmp4BpBNWwPYBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791895663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K9A3HLQ1YpUoEldxY7Q0RhsLuJG7jCunBt00AddwxcU=;
	b=ZQehcYaClAroKBYbpCpACaMg2irDrAwBZoVZ3xUXkn2DExV3KPpkIA/h+buGUq7kvkcxzu
	IxQej/DBhjBTbl/cBGcTQj0G9rvZxrvO/TuidHoZrh/n46MaIQRytEp3rUjP/y6y4RSbzP
	0Xs7AcgqkxAG/zx8fSe9zD54imMJQfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791895663;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K9A3HLQ1YpUoEldxY7Q0RhsLuJG7jCunBt00AddwxcU=;
	b=H/AQrcYFu0yTbNdbcgFXZRnDGny9YzquOxA90hoPoQbfcXvkC/CPxMD473bAcBxGyyxPKg
	ihQmp4BpBNWwPYBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DC4F13432;
	Tue, 13 Oct 2026 12:47:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MeZuAm8ozmpERQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 13 Oct 2026 12:47:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ABAAFA1407; Tue, 13 Oct 2026 14:47:38 +0200 (CEST)
Date: Tue, 13 Oct 2026 14:47:38 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Taotao Chen <chentaotao@didiglobal.com>, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: complete dropbehind writeback in task context
Message-ID: <cwlno6baljswazb7izeue7yh4qjwbs6ktfj3jgnhdh5zyfp72c@xpar52ae3uej>
References: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 
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
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,didiglobal.com,kernel.org,lst.de,kernel.dk,infradead.org,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,columbia.edu:email,suse.com:email]

On Mon 12-10-26 14:04:37, Tal Zussman wrote:
> ext4_end_bio() ends writeback directly from bio completion, which
> usually runs in interrupt context, unless the io_end has unwritten
> extents to convert and is completed from ext4's workqueue.
> folio_end_dropbehind() only invalidates the folios of an RWF_DONTCACHE
> write when it runs in task context, and silently skips them otherwise.
> So on ext4, dontcache writes that overwrite blocks that are already
> written, or that allocate blocks without unwritten extents, leave their
> folios in the page cache. Dropping them was best effort so far, as there
> was no way to get task context from bio completion.
> 
> Use the task-context bio completion infrastructure instead: set
> BIO_COMPLETE_IN_TASK on bios that carry dropbehind folios in
> io_submit_add_bh(), so that bio_endio() runs their completion from a
> worker. ext4's iomap buffered I/O path already gets this from iomap, so
> only the buffer_head based writeback is affected. Skip the flag when the
> io_end already has unwritten extents, as ext4 then defers the completion
> itself. A later extent can still make the io_end unwritten after an
> earlier bio was built. That bio's completion is then deferred twice,
> which is not optimal, but harmless.
> 
> This changes behavior only for bios that carry dropbehind folios: their
> completion now runs from a worker instead of in interrupt context.
> 
> On the unpatched kernel a dontcache overwrite of already-written blocks,
> or a dontcache write into a new file on a dioread_lock mount, leaves
> every folio in the page cache (16384/16384 for a 64M file). With the
> patch, none remain in the page cache. A dontcache write into a new file
> with unwritten extents already drops its folios on both kernels, as
> expected, and a plain write keeps them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

I guess this is OK as a short term fix but having two different offloading
mechanisms for IO completion is just asking for trouble and we should use 
BIO_COMPLETE_IN_TASK when unwritten extent conversion is needed as well.
But for this fix feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/page-io.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 734d856a6d47..e556598ce9e1 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -458,6 +458,16 @@ static void io_submit_add_bh(struct ext4_io_submit *io,
>  		io_submit_init_bio(io, inode, folio, bh);
>  	if (!bio_add_folio(io->io_bio, folio, bh->b_size, bh_offset(bh)))
>  		goto submit_and_retry;
> +
> +	/*
> +	 * Dropbehind folios can only be invalidated in task context. An
> +	 * io_end with unwritten extents is completed from ext4's workqueue
> +	 * anyway, so only ask the block layer to defer the others.
> +	 */
> +	if (folio_test_dropbehind(folio) &&
> +	    !(io->io_end->flag & EXT4_IO_END_UNWRITTEN))
> +		bio_set_flag(io->io_bio, BIO_COMPLETE_IN_TASK);
> +
>  	wbc_account_cgroup_owner(io->io_wbc, folio, bh->b_size);
>  	io->io_next_block++;
>  }
> 
> ---
> base-commit: 35aefefd7aba0801bab635b11943f932626be3b2
> change-id: 20260924-ext4-dontcache-complete-in-task-2340ed5f3114
> 
> Best regards,
> --  
> Tal Zussman <tz2294@columbia.edu>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
