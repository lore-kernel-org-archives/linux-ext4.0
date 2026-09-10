Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4542147013F
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 11:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039038; cv=none; b=EHV0nNqk9uy4kUo9wxglHftp3p6VPiGqtuhtE4e/nk5srSXl8zKypUheeorbamvhmNHzzcdwEYq+iJspO9m+lYomb0IcqnPrb5rPyqEcPmSIZru1Afrdvo5jtZbe+vdQURhfDcKFwjWshSBL5oU/uycQ28QhEAXtUxnlZQ+nf0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039038; c=relaxed/simple;
	bh=uqrZqtSJgfJfGhlNUVpkoUF/cVpaWagq4NIxeT3m0hE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNA3XycArJClzyYFfZV1O2ld2GJkgsIwvYrfEw1bxCC/kFgVhMzND1b2iMiLUNQVF5REklnIjAxhpqLYjUUjUK017i8+tI+rkNzX30NwQ8VnOPAr9u5dbp6w7N3/tqC/3rpddTnlhh3jLlXN04ZmLHONSuiE9+6t1jHJzFPRb1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SBfWh5WC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tcxUVX/R; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PZVs7tjH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sJZuN7gq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SBfWh5WC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tcxUVX/R";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PZVs7tjH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sJZuN7gq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CABB1FD91;
	Thu, 10 Sep 2026 11:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789039031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFRTMEjrc4D+747oC5JSw6/PzQXc6teRQQGLMU8oPi8=;
	b=SBfWh5WC0Gg0JqSBqy87+iMeASn//z1v47UuMc+ttTG2gitY+aifh02ed4jJlDJLR9t5i/
	vxrsYpZ+9/PVDfzVBd1VOBFpp+qjHb3ABzBMniczxE+pNzg1sKq2W9FVAddAFfm57+lV9M
	rz8z8cRXirvj1QRwCVmv2ptSs/4L6SU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789039031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFRTMEjrc4D+747oC5JSw6/PzQXc6teRQQGLMU8oPi8=;
	b=tcxUVX/RmgjCgxvLRyfUic4iTM+Ds3WIljZLoomUxcV3EuAA6yLl8+K5fQxwzdscEbSWeN
	zqgJfNhBuRaQJNDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PZVs7tjH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sJZuN7gq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789039027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFRTMEjrc4D+747oC5JSw6/PzQXc6teRQQGLMU8oPi8=;
	b=PZVs7tjH1N49KmY75SKGh99oVaiTJRmMw++PYp8gz3P7mxIooGGxPhwqqmYQ7lvpVPMZU6
	3rxdlY68CY+aZ1vLQszM3J2c8k7xgyGbndxRYEhZ9hcokPxdz59cmOMjkV8AmzBC6ZNsR+
	9oK3f/Y0mVbin9HhoVTPodMkvYLu5Ps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789039027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cFRTMEjrc4D+747oC5JSw6/PzQXc6teRQQGLMU8oPi8=;
	b=sJZuN7gqqfuAlY+LHSFzYGrGk/FA2AL6gM9UCae9wqQEQzpMZf4Q+UoeRx7Zlnz1DnX9ks
	dE2bHs+U6AUMfBDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E713E13180;
	Thu, 10 Sep 2026 11:17:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Izd1OLKRompvAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 10 Sep 2026 11:17:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6F520A12EA; Thu, 10 Sep 2026 13:17:02 +0200 (CEST)
Date: Thu, 10 Sep 2026 13:17:02 +0200
From: Jan Kara <jack@suse.cz>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: set awu_max_opt to awu_max
Message-ID: <zvwz4gq6a66oak2zeokvkeduiueeglymmsrnrq5m6gwydsxnif@mamkpcbtfzsr>
References: <20260910100829.2532894-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910100829.2532894-1-p.raghav@samsung.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 1CABB1FD91
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,dilger.ca,suse.cz];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email]
X-Spam-Flag: NO

On Thu 10-09-26 12:08:29, Pankaj Raghav wrote:
> commit 5d894321c49e ("fs: add atomic write unit max opt to statx")
> added atomic write max optimal to statx. As XFS can support large atomic
> writes through SW, max_opt exposes the value that will be HW accelerated
> atomics.
> 
> As ext4 does not support SW atomics, set awu_max_opt to awu_max.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Yes, I guess it's better to report it than not and let userspace guess. Feel
free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03..93056c971e74 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6304,7 +6304,8 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
>  			awu_max = sbi->s_awu_max;
>  		}
>  
> -		generic_fill_statx_atomic_writes(stat, awu_min, awu_max, 0);
> +		generic_fill_statx_atomic_writes(stat, awu_min, awu_max,
> +						 awu_max);
>  	}
>  
>  	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
> 
> base-commit: d5ba62a0b130441bcabca59c2fd2d59e65360234
> -- 
> 2.51.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
