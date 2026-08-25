Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1BF3B1EEF;
	Wed, 26 Aug 2026 07:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730618; cv=none; b=f/hZ4tkrdjj4kqzlCbAcHTgrE1O9hYnlRdCfJ4hKC2pX8tF8CjHKlaJGwt+G0xmwiipY9eKknDuM6PJh46VmPVKrkmViyzEOPcdRaG3DotQV/XAjrRR3NGULZQiiWtoJKDjeVYCu7y1yLR4+y+hRZywVKn6N1rIl6I4UO/jl4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730618; c=relaxed/simple;
	bh=7h2L4egdDWdAMqdlKhcgfY4pVZ0CDUS0y7nxA4+NtmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pr312sH38oNRoiXdCNW93FmJ0enICZtSlBGnV8t5/HCR64PQr8mtGxKmjXUoCQoDGbrorzlzLWeic2x2BCkvgdXHaL/QdtwLrKyO3oTaa68eKnX36qSjjoK0UBsUJGuIGK99F6kKCtNge8RrGuoTY8zojA5xIS/YWVsWbLExd0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MZb2sOHe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xZ4T8rSX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y25FlbtO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3FXqC90P; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MZb2sOHe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xZ4T8rSX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y25FlbtO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3FXqC90P"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B178872A9;
	Wed, 26 Aug 2026 07:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3peOszEgiOBNQTl4RFLKmIOzqzJKxkrZgK6sjxYDMQ=;
	b=MZb2sOHeNqLvlBN61O+RsxtIdLQvBOHL4XdTyE9PYxiuDBbc9z93ksN9kxEXHuPN7vjsR7
	te6Opua0qia3jsWrJOrXIt62Tq81GAD45LM+SkenVI7ySjI9e+sGZVgJPRM5tK1nV89h7M
	BURS9q6urHXuKQSJRwsDP4M8dlsIFWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730610;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3peOszEgiOBNQTl4RFLKmIOzqzJKxkrZgK6sjxYDMQ=;
	b=xZ4T8rSXQMtrSx56YqTBSklnlmhFm2NnVIEhXUIV9EpjmQBnwqEVh8jvl8DEG0fK3snsOM
	Xof8M7nR5I9oyqDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3peOszEgiOBNQTl4RFLKmIOzqzJKxkrZgK6sjxYDMQ=;
	b=Y25FlbtOLmTh/I0oSI84Iseua650Q6nlMtuwIokdCCeO168jD9cCn0gPSuYyyF6xsr0nAV
	VWOeuJyH97TR0GJfrkJSA7eKxiDHjlVJS/Sg7zuVmxvUxlLpLURi8L7Cm72zmbCfgQ4raz
	tGaLMoOozHYch/dKTDaKi0J8vav61zw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730606;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G3peOszEgiOBNQTl4RFLKmIOzqzJKxkrZgK6sjxYDMQ=;
	b=3FXqC90PmIpv6dYG+5Hxs4T65run37DK8MAwGS8PuUnDvRkaTyt5ve5eveuBCnwE9cEyHi
	BrhTZMntwZFxiYDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1B1F136A4;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zl4BO6OajmolDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 312E3A13CF; Tue, 25 Aug 2026 19:48:19 +0200 (CEST)
Date: Tue, 25 Aug 2026 19:48:19 +0200
From: Jan Kara <jack@suse.cz>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: Re: [PATCH] ext4: validate extent root during fast commit replay
Message-ID: <uqicacvdkyud4ztsvt2ermjg2knmm5etrbie4wdocljyd2wnc2@ol3zmd6c7h2q>
References: <20260821100559.3612643-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260821100559.3612643-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Spam-Score: -2.30
X-Spam-Level: 
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
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[cyber.gouv.fr:email,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Fri 21-08-26 10:06:00, Jérémy Jean wrote:
> During fast commit replay, ext4_iget() skips normal extent-tree
> validation. Replay helpers then call ext4_find_extent() and
> ext4_ext_insert_extent() on the unchecked inline root.
> 
> A corrupted root can advertise more entries than fit in
> EXT4_I(inode)->i_data. In particular, eh_entries == 4 and eh_max == 5
> make replay insert a fifth extent past i_data and overwrite adjacent
> inode fields.
> 
> Validate extent-formatted inode roots in ext4_find_extent() during fast
> commit replay, before traversal or insertion can trust the header.

Hum, I wonder why we don't check extent tree root during fastcommit replay.
From a quick look I don't see the reason. Harhad, Ted, any idea?

								Honza

> 
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Assisted-by: Codex:gpt-5
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  fs/ext4/extents.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 15972410d460..b95eafb0d5ca 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -905,6 +905,13 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
>  		ret = -EFSCORRUPTED;
>  		goto err;
>  	}
> +	/* ext4_iget() skips extent validation during fast commit replay. */
> +	if (unlikely((EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY) &&
> +		     ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
> +		ret = ext4_ext_check(inode, eh, depth, 0);
> +		if (ret)
> +			goto err;
> +	}
>  
>  	if (path) {
>  		ext4_ext_drop_refs(path);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
