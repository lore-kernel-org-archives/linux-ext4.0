Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6370F4A5C30;
	Wed,  7 Oct 2026 12:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377505; cv=none; b=gf2cfWvMCp361JvUiNhny9hZhyehjk8BIgE8tyGMg42SslU2ylB7dLO0Iu1Oqc1+Eb/jnT3qwngUEgEWGZv+Tw2bG5KKhf8aPkTh9qCzFD1E8aNPDE5sohiDxZaaYTvuDnj50mkIbBPkIFzt8xdcyvdPKphbmojx7NMUtygW5bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377505; c=relaxed/simple;
	bh=q3lSLRJs+E52nTVedTXEt+2A0lsIwNzJPeN8b+lUDTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iANbB/SHEKObgxpVi/sPrz5hETJ5u40acn1FfKPuBbLtVKPJkvaShcY7hU3RXMNNv/TsSO3Or3sc4sKX6NqjsdyhIgCus7R8ku/q+tp4j8NMhASdodt4NgIRZIPMOpJGXrQ3ROKoWhRuv09X+rFY1P9cfsq53rL/AULh92jaUlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bX7t546R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=l+6wS696; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FL8XE92M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OQFqw/g6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bX7t546R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="l+6wS696";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FL8XE92M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OQFqw/g6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E001321BDC;
	Wed,  7 Oct 2026 12:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791377493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1xDxqZSMFD+YczUQdJtNul/b6irsruiZxlmJvGzZuI=;
	b=bX7t546RDCNU8h9sT+3g6pMGKtt4GYDGw7FMU6vjxs7SAQFirBIrat1Eval1EWqy81bx09
	UhUQQIs1Hl51ftXAPTMv1rIUevaQrXmrdzYpxklFiKF9tbfUv5grpDnwW7DrBpLu1a2aZh
	/A7kcXSG02llXWXeqCrpY3pvviXEiTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791377493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1xDxqZSMFD+YczUQdJtNul/b6irsruiZxlmJvGzZuI=;
	b=l+6wS696P/If8n02xyLKIbMZWUSfsf0b73X9BSt4+FxUx32YipoNUt9GK+3IZscVippuz6
	m26bebmCtKId9hDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FL8XE92M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="OQFqw/g6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791377492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1xDxqZSMFD+YczUQdJtNul/b6irsruiZxlmJvGzZuI=;
	b=FL8XE92MY8zzeT9DMKt9JM+IK0xPcgKIfE7Yve1j2TzZeWosnIpDycsVl+FetnRc1ZUIAE
	pd6Va59DCdsG2Sxju/53zlZq5C6+/VY5PIQb66J5GCTIKoxeRywD5jJhl3QK0bh2Q2qLYc
	uUvGbZp6YVeDtCCqcvqnK1zyM0qvi7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791377492;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1xDxqZSMFD+YczUQdJtNul/b6irsruiZxlmJvGzZuI=;
	b=OQFqw/g6eEaKCcdT96AOSxNH/+3XFEq3Z/r26Gr/RLMMrPIPkn4gLZZ89TzB3at3yy7OMO
	JUCsBNyd1nAwBoCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB0A013354;
	Wed,  7 Oct 2026 12:51:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qY54IVRAxmr3YQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 07 Oct 2026 12:51:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EF254A13FE; Wed, 07 Oct 2026 14:51:31 +0200 (CEST)
Date: Wed, 7 Oct 2026 14:51:31 +0200
From: Jan Kara <jack@suse.cz>
To: daejun7.park@samsung.com
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
	Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: don't cache unzeroed blocks as written after a
 failed zeroout
Message-ID: <acwwxbc3qzyiwc6djmzemig2eutiia4zsi4kjeyd3tquhcmrpn@kuntjv2owek7>
References: <20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
 <20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E001321BDC
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,suse.cz,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,linux.beauty];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samsung.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Wed 07-10-26 09:41:20, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> ext4_ext_convert_to_initialized() may zero out the blocks before and
> after the range being written and convert them to written together with
> it, instead of splitting them off the unwritten extent. If
> ext4_ext_zeroout() fails for one side, it falls back to splitting the
> extent, so the blocks on that side stay unwritten in the extent tree.
> But zero_ex1 or zero_ex2 keeps its length, and ext4_zeroout_es() still
> inserts those blocks into the extent status tree as written.
> 
> Until that entry goes away, a read of those blocks returns whatever was
> on the disk before the extent was allocated. A write to them is mapped
> from the cache and goes in place without converting the extent, so its
> data would read back as zeroes once the entry is dropped. To reproduce
> on 4 KiB blocks with -o nodelalloc: fallocate 32 KiB, map the last seven
> blocks of that extent to dm-error, write the first block, restore the
> mapping and read the second block. It returns the old disk contents
> instead of zeroes.
> 
> Clear the length of an extent that could not be zeroed out, so that
> ext4_zeroout_es() skips it, as the comment at the out label intends.
> 
> Fixes: 308c57ccf431 ("ext4: if zeroout fails fall back to splitting the extent node")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 836396ea79..d65e30f3c1 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3755,8 +3755,10 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
>  				ext4_ext_pblock(ex) + split_map.m_lblk +
>  				split_map.m_len - ee_block);
>  			err = ext4_ext_zeroout(inode, &zero_ex1);
> -			if (err)
> +			if (err) {
> +				zero_ex1.ee_len = 0;
>  				goto fallback;
> +			}
>  			split_map.m_len = *allocated;
>  		}
>  		if (split_map.m_lblk - ee_block + split_map.m_len <
> @@ -3769,8 +3771,10 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
>  				ext4_ext_store_pblock(&zero_ex2,
>  						      ext4_ext_pblock(ex));
>  				err = ext4_ext_zeroout(inode, &zero_ex2);
> -				if (err)
> +				if (err) {
> +					zero_ex2.ee_len = 0;
>  					goto fallback;
> +				}
>  			}
>  
>  			split_map.m_len += split_map.m_lblk - ee_block;
> 
> -- 
> 2.43.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
