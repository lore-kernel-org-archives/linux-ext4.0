Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3655A36895D
	for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780134183; cv=none; b=Nl2CQ+rmG6MTBpVWeXm413r572UVpeFecnvIr9VBDTB5kg87wpVGqV70S8l8qCAfCk6VaHcJJQMlPs4p2IfsOkzmgv0hoeRwTzbMEupr/AsNYEaX9Hiij1GLF6uv++8G/rnRUV51SYlujj9hsOrrwNRewR0Ipb02+R8c9udEg1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780134183; c=relaxed/simple;
	bh=cEt1P38e+KCiqlJ/RToN9vJlVfkmcpcurDKyviz76Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQo5YP3fWp6dsLcRJ9L60gh/258kNbH7+AKBwVHwyPfJE7is/Fthri2xV0SCxzdJ4lngkV/uvcMdA69QyFh80QkhnCjnlDedMr0upOwHnpMMI3P/Pr28tU81OsEAe39IGpN8pGvh9ViIhnmIE1RF4YCY1eERQcV1O/zupHsaD8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LGiN/AXj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=x8b9drY8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XnICWz8+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=670n/ks/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LGiN/AXj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="x8b9drY8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XnICWz8+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="670n/ks/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CE8066B683;
	Sat, 30 May 2026 09:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780134175; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiGwJEe+MN0wvI62b/pIJyzwkW0XfwSQ0Q3dTdbjfsk=;
	b=LGiN/AXjTRbrzkuutOqJFo7Nm/5WDgOQTG64TPrhfFE3CFYPtlIvEb8TIpAWdwuwr29Z1s
	3vQI4KPfmcbIxAIHmxQ6yI1je7NX5Rqaw87i7GsbNprCBIBdTa2cenKfQKw1b/HvtlhsuI
	+0H6VJy/F799WyaTpX0AUKhbN29jZaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780134175;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiGwJEe+MN0wvI62b/pIJyzwkW0XfwSQ0Q3dTdbjfsk=;
	b=x8b9drY89pHczvlLwrXNG8mnf2TeOcYESBCmpk+n22ibNhPlX5HIeSU7Lfz97FewRtZD4B
	Pi8U94yQH2tIu5Dg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780134174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiGwJEe+MN0wvI62b/pIJyzwkW0XfwSQ0Q3dTdbjfsk=;
	b=XnICWz8+c5a5GRwCUQZzRKnlifc8w+sr50cp4TiaY8TcjmW5DG+T4GSEjlyhwPYqcaWD1z
	KtnllovJq09UguRlPrU0xYqBqfAi+ANwE1ApzQq/XYumQ+n3HnTVoXuoGFDSshd5vUKNg0
	z9nPVRDADhk/5nt2LzWDbNVa0y7epmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780134174;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iiGwJEe+MN0wvI62b/pIJyzwkW0XfwSQ0Q3dTdbjfsk=;
	b=670n/ks/y2hMoU9iwSFMGZA1u1KDBrLbqhjpqezag3HR6jIO1akb5OW4wgpaYG4ixVpjNA
	Srm3+GvO+gBHuiAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB39F779A7;
	Sat, 30 May 2026 09:42:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CipLR6xGmrwTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 09:42:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4C687A0EBD; Sat, 30 May 2026 11:42:50 +0200 (CEST)
Date: Sat, 30 May 2026 11:42:50 +0200
From: Jan Kara <jack@suse.cz>
To: Bohdan Trach <bohdan.trach@huaweicloud.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, mchehab+huawei@kernel.org, bohdan.trach@huawei.com, 
	lilith.oberhauser@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ext4: avoid RWM atomic in
 EXT4_MB_GRP_TEST_AND_SET_READ
Message-ID: <pyqduuh32gzj6qe3iuuk6pf66ryhluzvombollirkklufsciv5@4djrwpotg7xf>
References: <20260527090329.2680170-1-bohdan.trach@huaweicloud.com>
 <20260527090329.2680170-2-bohdan.trach@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527090329.2680170-2-bohdan.trach@huaweicloud.com>
X-Spam-Flag: NO
X-Spam-Score: 1.20
X-Spam-Level: *
X-Spamd-Result: default: False [1.20 / 50.00];
	SEM_URIBL(3.50)[huaweicloud.com:email];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TAGGED_RCPT(0.00)[huawei];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,huaweicloud.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]

On Wed 27-05-26 11:03:26, Bohdan Trach wrote:
> EXT4_MB_GRP_TEST_AND_SET_READ uses test_and_set_bit function which
> issues an atomic write. This can cause high overhead due to cache
> contention when multiple threads iterate over groups in a tight loop,
> as is the case for ext4_mb_prefetch(). We have seen this to be a
> problem for Kunpeng 920b CPUs which uses a single ARM LSE instruction
> for this purpose.
> 
> Avoid this unconditional atomic write by testing the bit first without
> changing its value. This is OK for this use case as this bit is never
> unset.
> 
> This change significantly reduces costs of fallocate() operations which
> trigger linear group scans on large multicore machines where
> test_and_set_bit issues an atomic write operation unconditionally.
> 
> Signed-off-by: Bohdan Trach <bohdan.trach@huaweicloud.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 56b82d4a15d7..f8eacf1375f8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3551,7 +3551,13 @@ struct ext4_group_info {
>  #define EXT4_MB_GRP_CLEAR_TRIMMED(grp)	\
>  	(clear_bit(EXT4_GROUP_INFO_WAS_TRIMMED_BIT, &((grp)->bb_state)))
>  #define EXT4_MB_GRP_TEST_AND_SET_READ(grp)	\
> -	(test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &((grp)->bb_state)))
> +	(ext4_mb_grp_test_and_set_read((grp)))
> +
> +static inline int ext4_mb_grp_test_and_set_read(struct ext4_group_info *grp)
> +{
> +	return (test_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state) ||
> +		test_and_set_bit(EXT4_GROUP_INFO_BBITMAP_READ_BIT, &grp->bb_state));
> +}
>  
>  #define EXT4_MAX_CONTENTION		8
>  #define EXT4_CONTENTION_THRESHOLD	2
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
