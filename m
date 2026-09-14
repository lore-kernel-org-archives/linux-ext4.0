Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790BE38C421
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411659; cv=none; b=Ue54V2/W3P1gAmGk1NkbtbjZa1DPoJHfI4rcw2cBzzER288vWmPxCg1FMIfPBhhWDcZ6QkpeWluIM2sA53fWp5kb32ZwciG/71U/4WGOPLzn10JIRKXqeMB8xPsaaL4NvBGxzIw+xCvt0Q1T13cy3qvd6XUS8ex1EqXfuP52XPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411659; c=relaxed/simple;
	bh=5foOB0viW1Eoh4GR4pnGedM49yZUhcB9J3zZTql375U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRRCdZ9RAKyrOKwmrYLjA64k1MyGYK97CFRVTHQ3p7KoxrsNdkqd/AtMOrPJ8j79/Ew4m5eMADNVk4UlzvpFbEi/GNCQs/AGQFA4gKiFo1BhMlco/idShb2o2bAmzgOEv+Y4Xhz7/SgDgJ1FEi4bSTMat7VX+u6cCxtMr3PnlI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fcxNeEdc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ArxLSHNf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hpjJ5Rm3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pz7f7uX+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fcxNeEdc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ArxLSHNf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hpjJ5Rm3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pz7f7uX+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3265521A7B;
	Mon, 14 Sep 2026 18:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789411651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Hzc4uU/BZWWVGYaGAn9oSImTuO/O5hxbqLcTiPsVAw=;
	b=fcxNeEdcsYCnhcJ84Yk9ttlljq/85P/zZpPeeGMimcAW5DeydmPzBqPGoLG8YMcpj9Iaq5
	OqolzTi2zwAv9oglpllwi0gmqNMCUAfCJBzDcIpb0nHYdMZnkIYB+6fzCQ0tWD7OfYa0tY
	Qsz+1eliNgHAOhPUqo4rZs6s7BBZU8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789411651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Hzc4uU/BZWWVGYaGAn9oSImTuO/O5hxbqLcTiPsVAw=;
	b=ArxLSHNfw4RISUJz/dREVOzYOSPbcq8DOXdbbZIFr6N8wmahOCO6ScNGWvrFkimDG/2f24
	jCAyvHI7OCKiuqAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789411647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Hzc4uU/BZWWVGYaGAn9oSImTuO/O5hxbqLcTiPsVAw=;
	b=hpjJ5Rm3QMfnsKR+j7MSXLOdm7XfAUWkgUi5kAauF/sFyWY0zmef5zJOZnjU/T0TkXnFqm
	9zw96Myq+g5Wt8xz4MX3Lvcx/jvuQ5JHk2NzKWqXlXYnfTeGeCCK0etQRQvXoRBuyzy18L
	DmptXmebLuQfydJFH5GkWDGyg4N7unA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789411647;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5Hzc4uU/BZWWVGYaGAn9oSImTuO/O5hxbqLcTiPsVAw=;
	b=Pz7f7uX+H7cCBIkVhTo6vXtsC8YtsCkDXPYHsw22dEvGwscYa/TMB9J94hOEWtYY/TUFTv
	B76GyBte5QcUMFBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD1401368C;
	Mon, 14 Sep 2026 18:47:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eOlpNT5BqGqvPQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 14 Sep 2026 18:47:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5F8D1A12E4; Mon, 14 Sep 2026 20:47:22 +0200 (CEST)
Date: Mon, 14 Sep 2026 20:47:22 +0200
From: Jan Kara <jack@suse.cz>
To: shuo chen <1289151713@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH v2] ext4:Fix WARNING in ext4_journalled_invalidate_folio
Message-ID: <dou62oqosza2rxerkg2getanwttfwjfrv7pc6fdq6enmdayjon@65qzjs7yququ>
References: <tencent_D74F4B8A5FDC1BCFC23B8750428019635609@qq.com>
 <tencent_87F5A404ED65B0B1349C60E830C485716705@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_87F5A404ED65B0B1349C60E830C485716705@qq.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[qq.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,qq.com:email,berkeley.edu:email]
X-Spam-Flag: NO

On Tue 15-09-26 00:41:44, shuo chen wrote:
> Thanks to Jack's suggestion.
> Call the ext4_wait_for_tail_page_commit() helper before
> ext4_truncate_failed_write() from ext4_journalled_write_end(),
> which avoids invalidating the folio while it is being committed.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Closes:https://lore.kernel.org/linux-ext4/CA+0ovCgxFN3TLpdS_O_Z48sARuQ-WR-JLDCqQWEmd9ELtkzddA@mail.gmail.com/T/
> Signed-off-by: shuo chen <1289151713@qq.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..10a89bbb994a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -56,6 +56,7 @@ static void ext4_journalled_zero_new_buffers(handle_t *handle,
>  					    struct inode *inode,
>  					    struct folio *folio,
>  					    unsigned from, unsigned to);
> +static void ext4_wait_for_tail_page_commit(struct inode *inode);
>  
>  static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
>  			      struct ext4_inode_info *ei)
> @@ -1605,6 +1606,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  	if (!ret)
>  		ret = ret2;
>  	if (pos + len > inode->i_size && !verity) {
> +		ext4_wait_for_tail_page_commit(inode);
>  		ext4_truncate_failed_write(inode);
>  		/*
>  		 * If truncate failed early the inode might still be
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
