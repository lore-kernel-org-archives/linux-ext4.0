Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523173;
	b=nG8V2IMyj+FS59L53c8mqYA4bPiNjOzjoOU13EJUUEjFcVeAylJ77wjFv+zW5eQndXRQ
	 nEjWKuk7mDvGT1QjTXY4zVTEkoTtp7rDOe8iOLKaJCej16eTYt9PnvK8veJjJKMVy4NcH
	 d6eSvbMTrLSx+kSR5+hfOiJMTWxhClraQ/T3WWb2GOmX1oJ4+2dfRVfoipK22/Sw02Gpo
	 w3mnBw77Rbs3V8lzl/xXLWm3CHQMAWUnjDvS3S4pGwtgwVtaHXlH0iwArOO45a5KisPx1
	 EQl6YxvsIYXuNvHSJbClM0RkS5rAZeii48k0ePA5t+gm4Esf2VkYK6Kd/4/vGlKVvaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523173;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=QNafYeLMTW+BV6Jpqu80+zNAj1n4bMAjW/izwo7G4ww=;
	b=aGHNWDr0k/951PEKJDmI2tp9MhwioXDFKR1hpv3XKQy/T64zpGdDP0THicM/Cm+Z3ONP
	 b+tiqRo1aQmUjGkUdNSBAnhqZ9bKq0+fl6RJXh4Fj2WZov7fXU8bZm4YJ28dukwJJ5XsA
	 bqYUamFLAiQhopfd89jHXXokdA2RijJr1XTBKVMzPEovq2z92umNeAWAyv0kZm7ZeJ+F9
	 zsmaIou/Z60bcS6fxAXVkF9AIzdvdcv+jiKaPiODj8LlLCMSvs7khOmByuv/qUX69X/VL
	 ImWUgZkPAuZwa93sqQoIV1pxig65HQbV+5UDmS4/D0ILHvkXyyiEiw+jIEk2xyxgDFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zPpABXFt;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/D2+KV67";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="tLUbx/GO";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rn7WMTH7;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580A0606A321
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 12:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 580A0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zPpABXFt;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/D2+KV67;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tLUbx/GO;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rn7WMTH7
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7F1B71F388;
	Tue, 24 Nov 2026 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795523171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QNafYeLMTW+BV6Jpqu80+zNAj1n4bMAjW/izwo7G4ww=;
	b=zPpABXFtvVayHhAynwrKHKJ/2voUQoaQNKqyloVl2HPM79MOqonTBLVAioALeowFHlC6Vm
	Og0AUx0YDVPtaIUEZNvVLH4MmOA3IM8zJDz5sBESjwr/Wc/pV4FHEwFrYe84HWHBRql0cj
	n8+EtkepZM9PFso+idfFHiodd6QsKfo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795523171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QNafYeLMTW+BV6Jpqu80+zNAj1n4bMAjW/izwo7G4ww=;
	b=/D2+KV67CyODTUoNB3Ae+/N2FxWZqJ95bNFgGFTCXFW5prCiuMt4DzdyHI1NttPyzAdcEW
	/+fAL6pIu+vFL0Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795523169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QNafYeLMTW+BV6Jpqu80+zNAj1n4bMAjW/izwo7G4ww=;
	b=tLUbx/GOidLJfoiMV+Hl4cTH35NZj7iYBYVlOnWQsm1gXqWvyTNS872VOM690Gn3UQidO4
	gX8Nb6k4uljv9f5Q21ON/o9OGjw36W3QXVbtC87uPDGArLsW/MI0Edl62zQcyAL7cfiGhW
	WZUlgQ0XjWxCyNx8C3yWUwfhlMfA1XA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795523169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QNafYeLMTW+BV6Jpqu80+zNAj1n4bMAjW/izwo7G4ww=;
	b=rn7WMTH7bAMxfMGlSlKv4Qq3RKjfb+JMYKOaVNX8VLPxc3VvnD36w6Fab+EM2KBTfl56WH
	8ovlnFXjBVSSFZBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 567701339F;
	Tue, 24 Nov 2026 12:26:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mgDSDGGCBWueAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 12:26:09 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id DEC8A27865; Tue, 24 Nov 2026 13:26:08 +0100 (CET)
Date: Tue, 24 Nov 2026 13:26:08 +0100
From: Jan Kara <jack@suse.cz>
To: Muhammad Umer <mumer.mobi@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com
Subject: Re: [PATCH 1/2] ext4: scan all groups before trimming the goal in
 CR_BEST_AVAIL_LEN
Message-ID: <7opizb53lwqeklm35v7paupqxdho2hqxpytl5v76mj7frl3twi@4k6e3hbngnyg>
References: <20261122185630.2112-1-mumer.mobi@gmail.com>
 <20261122185630.2112-2-mumer.mobi@gmail.com>
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
In-Reply-To: <20261122185630.2112-2-mumer.mobi@gmail.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Sun 22-11-26 13:56:29, Muhammad Umer wrote:
> Since commit a3ce570a5d6a ("ext4: implement linear-like traversal across
> order xarrays"), ext4_mb_scan_groups_best_avail() walks every order from
> the goal order down to min_order over groups [start, ngroups) before it
> looks at [0, start). A group below start is only considered after the
> goal has been trimmed to min_order, so a 1024-cluster free extent in
> group 2 loses to a 256-cluster one in group 9.
> 
> The ordering is harmless for CR_POWER2_ALIGNED and CR_GOAL_LEN_FAST,
> where every order scanned satisfies the full goal. In CR_BEST_AVAIL_LEN
> a lower order means a smaller allocation, so search both ranges at each
> order before trimming further.
> 
> start is rarely 0: stream allocations start at s_mb_last_groups[], and
> the linear prescan moves it forward by s_mb_max_linear_groups.
> 
> Reproducer: 16 groups, groups 0-7 with only 1024-block free extents,
> groups 8-15 with only 256-block free extents. 32 MiB written with 64 KiB
> O_DIRECT writes to a file with a 64 MiB i_size (8 MiB normalized goal).
> Allocations made:
> 
>   start group, max_linear_groups   before               after
>   0, 0                             8 x 1024             8 x 1024
>   8, 0                             7 x 1024, 4 x 256    8 x 1024
>   0, 4                             6 x 1024, 2 x 512,   8 x 1024
>                                    4 x 256
> 
> Fixes: a3ce570a5d6a ("ext4: implement linear-like traversal across order xarrays")
> Signed-off-by: Muhammad Umer <mumer.mobi@gmail.com>

Good point! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/mballoc.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a15285224..37825743f 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1097,7 +1097,6 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
>  
>  	start = group;
>  	end = ext4_get_allocation_groups_count(ac);
> -wrap_around:
>  	for (i = order; i >= min_order; i--) {
>  		int frag_order;
>  		/*
> @@ -1120,15 +1119,20 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
>  		frag_order = mb_avg_fragment_size_order(ac->ac_sb,
>  							ac->ac_g_ex.fe_len);
>  
> +		/*
> +		 * A lower order means a smaller allocation, so search all
> +		 * groups at this order before trimming the goal further.
> +		 */
>  		ret = ext4_mb_scan_groups_avg_frag_order_range(ac, frag_order,
>  							       start, end);
>  		if (ret || ac->ac_status != AC_STATUS_CONTINUE)
>  			return ret;
> -	}
> -	if (start) {
> -		end = start;
> -		start = 0;
> -		goto wrap_around;
> +		if (start) {
> +			ret = ext4_mb_scan_groups_avg_frag_order_range(ac,
> +							frag_order, 0, start);
> +			if (ret || ac->ac_status != AC_STATUS_CONTINUE)
> +				return ret;
> +		}
>  	}
>  
>  	/* Reset goal length to original goal length before falling into CR_GOAL_LEN_SLOW */
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
