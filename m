Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793656057;
	b=hl5uUCGtVRf+ArQAPXr+XapIMt45L9/ZhF1/s9RM33UW5syjYXJ7uKNY3pfoSaGRcyoF
	 vvvgAzXdrKeYxud6X2orXDLTfxGxBw5nLG9YpTBDsG4iKQGKL/Lx12vOSfFxW/mE85XP2
	 LYxDbsycNXDoinygq/PO+PKXk1o2fERVW/o3EdGVonjIKeszCQncz+gv3PbmlLJNYHTuq
	 yo/4RwHM7K91NkAabmnextX6/duTPafS/IWiCvoD7FfXmjoE35VnEloGKLI9hsa9O9jKK
	 yVhIqYLepxZUtPjn5K6HGBZNp4VIoIjhJKlBeJppPCR0dHSzSYq/Xjo2XXKSduUtfYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793656057;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=R7aV3/vUecDLIJxFIrcOCk51PJ5tVgZ9XrFKXjl3YIs=;
	b=fVfE6X80KkYoTV6+QvJb7cZAQ/IrJQjvQ02rmxeM1qPoXVbWhL39ZUp0C6XsAguq2DdQ
	 604ob8vsJoPzvmUOungLV499fgTqSm2I/WC3YOTdJcg9xvYzsPT6heHNLvV5LHJD0Kh2w
	 nRQaRH2K/wX0Cu++1aeqyLBdlhDOh5V3JFT72uz38eGAIlLMm2ciNq15OxRCdGJ1kWdX2
	 TzyA/33CSjPoKf/TKBgd5YVIJFaMwuMfRf5hxGMjnWV40S1vI4xJRjF26UyrtwBoXBG3U
	 QdFYpg4GBS7lzmxph+G8auxGLVsryPR2vpzTqgE+atLj71U1zHY+jjWgGSQazv1dN+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ITXmaf6T;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vZ07kOiF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ITXmaf6T;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vZ07kOiF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088CC606A33D;
	Mon,  2 Nov 2026 21:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 088CC606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ITXmaf6T;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vZ07kOiF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ITXmaf6T;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vZ07kOiF
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 669C521F95;
	Mon,  2 Nov 2026 21:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7aV3/vUecDLIJxFIrcOCk51PJ5tVgZ9XrFKXjl3YIs=;
	b=ITXmaf6ThApCSiLH0uVJt+yo/cjrZA6FemijsNmgRW0vcI7bPSMcwcPwrgOSMlz9eAx/xk
	u8pbs5ke+L/hwRboPDtSLUcdkX4dvjZjXc3wQeq5UzZyQgDTmeKTOVV8gDPISDmqvXJph4
	1no8ia9nCyyHsHNNgqS13XQNxpDQJfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7aV3/vUecDLIJxFIrcOCk51PJ5tVgZ9XrFKXjl3YIs=;
	b=vZ07kOiFO74uT1tw69/0ex6eN8kN70rmoACdD7a3z5WMM9IMmL4Up/98+7CX8XOfNJMLiD
	8vAr3a5DfJ6BXgBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7aV3/vUecDLIJxFIrcOCk51PJ5tVgZ9XrFKXjl3YIs=;
	b=ITXmaf6ThApCSiLH0uVJt+yo/cjrZA6FemijsNmgRW0vcI7bPSMcwcPwrgOSMlz9eAx/xk
	u8pbs5ke+L/hwRboPDtSLUcdkX4dvjZjXc3wQeq5UzZyQgDTmeKTOVV8gDPISDmqvXJph4
	1no8ia9nCyyHsHNNgqS13XQNxpDQJfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7aV3/vUecDLIJxFIrcOCk51PJ5tVgZ9XrFKXjl3YIs=;
	b=vZ07kOiFO74uT1tw69/0ex6eN8kN70rmoACdD7a3z5WMM9IMmL4Up/98+7CX8XOfNJMLiD
	8vAr3a5DfJ6BXgBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F1E9134B3;
	Mon,  2 Nov 2026 21:47:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RjdTCfcE6WrFAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:47:35 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E49D7B179; Mon, 02 Nov 2026 22:47:34 +0100 (CET)
Date: Mon, 2 Nov 2026 22:47:34 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: report sub-block project quotas in statfs
Message-ID: <4zccyjkpmyoh7wnfm5np2pclaphavocrbp5252mtdwtky2ytyq@4uazaqpaxfog>
References: <20261101125847.54531-1-dennylin0707@gmail.com>
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
In-Reply-To: <20261101125847.54531-1-dennylin0707@gmail.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Sun 01-11-26 12:58:47, Hungyu Lin wrote:
> ext4_statfs_project() converts the selected space limit from bytes to
> filesystem blocks before checking whether it is nonzero. A nonzero quota
> smaller than one block therefore skips the project space adjustments.
> 
> For example, a valid 1 KiB hard limit on a 4 KiB-block filesystem leaves
> statvfs() and df reporting the underlying filesystem's space, even when
> unprivileged data allocation fails with EDQUOT.
> 
> Test the byte limit before converting it to filesystem blocks. The
> resulting zero block limit then clamps the project space statistics to
> zero. Keep the existing rounding and the rule that a zero byte limit
> means no quota.
> 
> Fixes: 689c958cbe6b ("ext4: add project quota support")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9cae52471dee..91c1a54730f6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -7001,11 +7001,11 @@ static int ext4_statfs_project(struct super_block *sb,
>  
>  	limit = min_not_zero(dquot->dq_dqb.dqb_bsoftlimit,
>  			     dquot->dq_dqb.dqb_bhardlimit);
> -	limit >>= sb->s_blocksize_bits;
>  
>  	if (limit) {
>  		uint64_t	remaining = 0;
>  
> +		limit >>= sb->s_blocksize_bits;
>  		curblock = (dquot->dq_dqb.dqb_curspace +
>  			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
>  		if (limit > curblock)
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
