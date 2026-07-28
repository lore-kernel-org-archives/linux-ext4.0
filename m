Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12B9459ACE
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785250275; cv=none; b=r83JzrKr4sMIBkdbqVSY9ZFeG46gZfRcndCDVFTEUQpPq2bRK3wj2zwlAU11Qg1l8Ov/s0RhMr8YiUBkr+8b+nwW7VtB5Xl65VDyjwL6rPE0XSN5yRzSVreEXPkJshN03fVPwQ3Wne2e82irUBN6jcRZTlOs9LWXBeT92jUX60c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785250275; c=relaxed/simple;
	bh=lpYsBobLhKs8aRa+jvR4DcXdiZ5F52oSK1sV/hu2S1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GthPZOCcE4sMAURJt0KECxi6j56QWStaMuCGXvN2giUWIZEfQ8gP+frfu/9Eav0sXlXwWlThruoMvGM1mCB6ndCGGmIBQwjwcCWOav/bwExbfGE5jtxtKbSIIwvqB/Gfx+Y31xi0fFMxMdt5RbOvG0DFokMfQNH1oyp4Q532CBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zRfQ2VXL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=orgDVNBj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=psQlPEHg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7Y5/V5Uh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zRfQ2VXL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="orgDVNBj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="psQlPEHg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7Y5/V5Uh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 67B967C33E;
	Tue, 28 Jul 2026 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785250267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TDcwm0OTg7/qttntEh2xFKLH/4JGhB5nFbDSQNf4k78=;
	b=zRfQ2VXLEiQWz2DUxLGyJ0hH58GHnphLFlKmRDtAkyFm4Eup7gTYp6w6E3b+gCrdGprFKn
	pMIGehxE39TI920Loesdq6tsFaONWQp5oFonRqrMdSZ8honLH56zO3ka4p0gShONBbzUC+
	fTFEstfExK4p9oKqsl05qDZM9G+d7XM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785250267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TDcwm0OTg7/qttntEh2xFKLH/4JGhB5nFbDSQNf4k78=;
	b=orgDVNBje1mVQDaxVVdS1+j4kdRGV+97HIoQ3gHM3DLVr86yBv3VdNPq3b6HJujIU/yVIY
	fiRrhceojrLQ5sAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785250263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TDcwm0OTg7/qttntEh2xFKLH/4JGhB5nFbDSQNf4k78=;
	b=psQlPEHgwEDS2F1TWEbGHL0IyJHTh54TA0rs6ee5sxvkVuCPb+xBLu0pqJ9JqgNscjnqcn
	+ytomCJTEP1tiEeWCM8q5ee5ALlKsPmbCVVopYOGfg83yueRvG1B5ILFVJZPtqkQixO4RO
	8juLd2PHBGOgZdWrySFgFHoP/GGmxbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785250263;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TDcwm0OTg7/qttntEh2xFKLH/4JGhB5nFbDSQNf4k78=;
	b=7Y5/V5Uh8HvW3+0ZSY9gfeq5MSBug847ugbBYIJ5ETM+r64XaCeawBPBP16u7iJKZmgMxC
	pfSF+rJabRqMwUDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CBF4779B1;
	Tue, 28 Jul 2026 14:51:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MDyfFtfBaGqrKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 14:51:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F37DCA10B6; Tue, 28 Jul 2026 16:50:54 +0200 (CEST)
Date: Tue, 28 Jul 2026 16:50:54 +0200
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Reduce object size of ext4_msg uses
Message-ID: <j6bufcgvsvzjhyebsac5szej6akdjkbsedelqdb4bm7uebl26c@b64qs7zp4uhp>
References: <7fbad87ae7e108571cafffa8fa0715ce4d2c5261.camel@perches.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fbad87ae7e108571cafffa8fa0715ce4d2c5261.camel@perches.com>
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
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]

On Fri 24-07-26 18:23:36, Joe Perches wrote:
> Reduce the object size of ext4 ~2KB (~.5%) by combining the KERN_<LEVEL>
> and format uses of ext4_msg.
> 
> Separate them in __ext4_msg using printk_get_level and printk_skip_level
> and emitting the appropriate level.
> 
> x86 object sizes before and after:
> 
> defconfig size before:
> $ size -t fs/ext4/built-in.a | tail -1
>  579013	 121634	    316	 700963	  ab223	(TOTALS)
> 
> defconfig size after:
> $ size -t fs/ext4/built-in.a | tail -1
>  577196	 121650	    316	 699162	  aab1a	(TOTALS)
> 
> defconfig size before with CONFIG_EXPERT=y and CONFIG_PRINTK=n:
> $ size -t fs/ext4/built-in.a | tail -1
>  537999	 121432	    316	 659747	  a1123	(TOTALS)
> 
> defconfig size after with CONFIG_EXPERT=y and CONFIG_PRINTK=n:
> $ size -t fs/ext4/built-in.a | tail -1
>  536837	 121424	    316	 658577	  a0c91	(TOTALS)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h  | 12 ++++++------
>  fs/ext4/super.c | 14 +++++++++-----
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..981918f32067 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3309,8 +3309,8 @@ void __ext4_warning(struct super_block *, const char *, unsigned int,
>  extern __printf(4, 5)
>  void __ext4_warning_inode(const struct inode *inode, const char *function,
>  			  unsigned int line, const char *fmt, ...);
> -extern __printf(3, 4)
> -void __ext4_msg(struct super_block *, const char *, const char *, ...);
> +extern __printf(2, 3)
> +void __ext4_msg(struct super_block *, const char *fmt, ...);
>  extern void __dump_mmp_msg(struct super_block *, struct mmp_struct *mmp,
>  			   const char *, unsigned int, const char *);
>  extern __printf(7, 8)
> @@ -3354,8 +3354,8 @@ void __ext4_grp_locked_error(const char *, unsigned int,
>  	__ext4_warning(sb, __func__, __LINE__, fmt, ##__VA_ARGS__)
>  #define ext4_warning_inode(inode, fmt, ...)				\
>  	__ext4_warning_inode(inode, __func__, __LINE__, fmt, ##__VA_ARGS__)
> -#define ext4_msg(sb, level, fmt, ...)				\
> -	__ext4_msg(sb, level, fmt, ##__VA_ARGS__)
> +#define ext4_msg(sb, level, fmt, ...)					\
> +	__ext4_msg(sb, level fmt, ##__VA_ARGS__)
>  #define dump_mmp_msg(sb, mmp, msg)					\
>  	__dump_mmp_msg(sb, mmp, __func__, __LINE__, msg)
>  #define ext4_grp_locked_error(sb, grp, ino, block, fmt, ...)		\
> @@ -3401,8 +3401,8 @@ do {									\
>  } while (0)
>  #define ext4_msg(sb, level, fmt, ...)					\
>  do {									\
> -	no_printk(fmt, ##__VA_ARGS__);					\
> -	__ext4_msg(sb, "", " ");					\
> +	no_printk(level fmt, ##__VA_ARGS__);				\
> +	__ext4_msg(sb, "" " ");						\
>  } while (0)
>  #define dump_mmp_msg(sb, mmp, msg)					\
>  	__dump_mmp_msg(sb, mmp, "", 0, "")
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 245f67d10ded..72d6f6353a27 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -981,11 +981,11 @@ void __ext4_std_error(struct super_block *sb, const char *function,
>  	ext4_handle_error(sb, false, -errno, 0, 0, function, line);
>  }
>  
> -void __ext4_msg(struct super_block *sb,
> -		const char *prefix, const char *fmt, ...)
> +void __ext4_msg(struct super_block *sb, const char *fmt, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> +	int level;
>  
>  	if (sb) {
>  		atomic_inc(&EXT4_SB(sb)->s_msg_count);
> @@ -995,12 +995,16 @@ void __ext4_msg(struct super_block *sb,
>  	}
>  
>  	va_start(args, fmt);
> -	vaf.fmt = fmt;
> +
> +	level = printk_get_level(fmt);
> +	vaf.fmt = printk_skip_level(fmt);
>  	vaf.va = &args;
>  	if (sb)
> -		printk("%sEXT4-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
> +		printk("%c%cEXT4-fs (%s): %pV\n",
> +		       KERN_SOH_ASCII, level, sb->s_id, &vaf);
>  	else
> -		printk("%sEXT4-fs: %pV\n", prefix, &vaf);
> +		printk("%c%cEXT4-fs: %pV\n",
> +		       KERN_SOH_ASCII, level, &vaf);
>  	va_end(args);
>  }
>  
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
