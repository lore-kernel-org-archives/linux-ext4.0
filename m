Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199F7386557
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779722929; cv=none; b=OIMAV2PTtegQwtiip3kFF8qsIC2JPFGqifNKTfUfKVKxcUqeEfNy9gFmm3i0eo0GbgGPc5O9UTb7eEluo+YFZLesJb0AIpno9W9XtO773If3KLAEk+GK3IF5mZysqHJnGlYxtSsejRavdbM6jGSPCpye1+obwXPdYXumJRuus8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779722929; c=relaxed/simple;
	bh=9dtRhlJX0S0uYUyUfzvk/MVCvvKA0VrDpj5g+LQdARo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Chs+E6ZpWUv0x6mZQCKFoaV3QW0aLdFPR/1d+BYUjcPunyJabPk8Q/mZ6Ho7lcliz0MxB2G69ZgE3BPCA31pM9uS/ctFcIGw850xaaATQxtQhiCOz2rn46LJJOqnsiQ3HG0GaB7Xibc16a2yK5gDkGstHK1a6NExGvCqmm0onAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UPjRFjAG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HIHzyJw/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UPjRFjAG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HIHzyJw/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UPjRFjAG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HIHzyJw/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UPjRFjAG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HIHzyJw/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0173F6BDA7;
	Mon, 25 May 2026 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779722926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sKHqre2SXLU5Hb90e9ywW80wlv1NXWjls8Cne7vaqok=;
	b=UPjRFjAGbczgw6MHKqMd3BbsoPjBCCyaL3a2dH+fdPqAwpR6vh6oJN8G/sCm6RYy3F+/H4
	Q5z4SoziETsfiHeKhBIVn73i7cquxwb2WCVWQ8uCfC8HOPEvNiJ2vpZx01yCohx9Rp76Hw
	yqB4Qsx+zFArBcqIGhWmzuwGIO4vPpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779722926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sKHqre2SXLU5Hb90e9ywW80wlv1NXWjls8Cne7vaqok=;
	b=HIHzyJw/R/Nxq42DpqdtbKDASqTBeBPVNptgFZZOec6UU7ovkuA13bxOlKShHihZxeb0k7
	Xw4LPTGNWi9r/+Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UPjRFjAG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="HIHzyJw/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779722926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sKHqre2SXLU5Hb90e9ywW80wlv1NXWjls8Cne7vaqok=;
	b=UPjRFjAGbczgw6MHKqMd3BbsoPjBCCyaL3a2dH+fdPqAwpR6vh6oJN8G/sCm6RYy3F+/H4
	Q5z4SoziETsfiHeKhBIVn73i7cquxwb2WCVWQ8uCfC8HOPEvNiJ2vpZx01yCohx9Rp76Hw
	yqB4Qsx+zFArBcqIGhWmzuwGIO4vPpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779722926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sKHqre2SXLU5Hb90e9ywW80wlv1NXWjls8Cne7vaqok=;
	b=HIHzyJw/R/Nxq42DpqdtbKDASqTBeBPVNptgFZZOec6UU7ovkuA13bxOlKShHihZxeb0k7
	Xw4LPTGNWi9r/+Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E15EA59CF4;
	Mon, 25 May 2026 15:28:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xqKENq1qFGpNbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 15:28:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7EBCEA08D7; Mon, 25 May 2026 17:28:45 +0200 (CEST)
Date: Mon, 25 May 2026 17:28:45 +0200
From: Jan Kara <jack@suse.cz>
To: Bohdan Trach <bohdan.trach@huaweicloud.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, mchehab+huawei@kernel.org, lilith.oberhauser@huawei.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: avoid RWM atomic in
 EXT4_MB_GRP_TEST_AND_SET_READ
Message-ID: <wjkbwkkxz5ol3h5zo6npd7lrnzpvesox7cubor6t6gpx4hrdxa@utrefuc6apug>
References: <20260521125931.16474-1-bohdan.trach@huaweicloud.com>
 <20260521125931.16474-2-bohdan.trach@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521125931.16474-2-bohdan.trach@huaweicloud.com>
X-Spamd-Bar: +
X-Rspamd-Queue-Id: 0173F6BDA7
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: 1.29
X-Spamd-Result: default: False [1.29 / 50.00];
	SEM_URIBL(3.50)[huaweicloud.com:email];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAD_REP_POLICIES(0.10)[];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	R_DKIM_ALLOW(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[huawei];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org,vger.kernel.org];
	TO_DN_SOME(0.00)[]
X-Spam-Level: *
X-Spam-Flag: NO

On Thu 21-05-26 14:59:28, Bohdan Trach wrote:
> EXT4_MB_GRP_TEST_AND_SET_READ uses test_and_set_bit function which
> issues an atomic write. This can cause high overhead due to cache
> contention when multiple threads iterate over groups in a tight loop,
> as is the case for ext4_mb_prefetch(). We have seen this to be a
> problem for Kunpeng 920b CPUs which uses a single ARM LSE instruction
> for this purpose.
> 
> This change significantly reduces costs of fallocate() operations which
> trigger linear group scans on large multicore machines where
> test_and_set_bit issues an atomic write operation unconditionally.
> 
> Signed-off-by: Bohdan Trach <bohdan.trach@huaweicloud.com>
...
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 56b82d4a15d7..0713207811a6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3551,7 +3551,17 @@ struct ext4_group_info {
>  #define EXT4_MB_GRP_CLEAR_TRIMMED(grp)	\
>  	(clear_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
>  #define EXT4_MB_GRP_TEST_AND_SET_READ(grp)	\
> -	(test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &((grp)->bb_state)))
> +	(ext4_mb_grp_test_and_set_read((grp)))
> +
> +static inline int ext4_mb_grp_test_and_set_read(struct ext4_group_info *grp)
> +{
> +	int r = test_bit_acquire(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state);
> +
> +	if (!r)
> +		return test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state);
> +	else
> +		return r;
> +}

Good idea but do we really need the 'acquire' barrier here? I don't see
anything that would really need this so I think
EXT4_MB_GRP_TEST_AND_SET_READ() can be just:

test_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state) || \
  test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state)

or am I missing something?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
