Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00259499F17;
	Tue,  8 Sep 2026 11:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788866110; cv=none; b=POvU/ODgkGiq0MC7h+kTQwjhfTylsyVRmvv3AHzcxV+X5GoMHwJITzyzkJ/iypUi8TbznAe8gKxnHYj6xwJoRJRUvGOF8kdS4yy/8r1p2LmnSN/9WZDB0Jk7Pgkb7ZzOxYmLWzm7H0N+79MPNkX0bS/NX7Vj61j+qufb8YUa4NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788866110; c=relaxed/simple;
	bh=IGTpl6Bj7hI2+KdbjSXSVadIVYQqUNPOlJC/RZIJmn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCZ4FaE3RS8qKBkHzDDI/kr5S1smd37HkyKLpZtUOXpSGSjOHp/p8Jaj7B5+3wPLyvRO98f48RCjkHomAWWUu5I97zQGGD9UOvu88kboSduBgH8qFLR5cykZo5jy64j6S+iEG/IEm1HBMGoWv1LodkNQ8dy1COtuSPngRmgpqRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cePWa2co; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6kmsrmj4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y8nFEExK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2E+GpvCo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cePWa2co";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6kmsrmj4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y8nFEExK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2E+GpvCo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 50F4E1F789;
	Tue,  8 Sep 2026 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788866098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FlqvEth0Tiy4IX91fO/GBtvGwogbF8NDYd+W3vqHoCc=;
	b=cePWa2coW2O2BM0R3PGhN95P9pM9XC7G6RPTZ93mk8mENP/qeFIsUjWebNbv7tQO19DT4I
	oBkv/usWgLGePXWI9xemOTEH7YgBcXXbXuic3lDNAtwhSez2Ez/R1p0Uw0EWvV/3X4qCLN
	e5AIi35GG7nEDLmmO72zv9/XvNocl38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788866098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FlqvEth0Tiy4IX91fO/GBtvGwogbF8NDYd+W3vqHoCc=;
	b=6kmsrmj4DXOhsFuXYFWNqidtTFG1oQUFVd6IrWhwTdLGr0QtXSXMOCU3Jv43/Mm4Vh96rJ
	V92SDnyO93oSgDDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y8nFEExK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2E+GpvCo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788866094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FlqvEth0Tiy4IX91fO/GBtvGwogbF8NDYd+W3vqHoCc=;
	b=Y8nFEExK/UsTcaBxuJ9nsE1CCTTrmaljrbpbL1bNVE3iTC5+Ldt6Ni4wiSBkLBNzTt5x51
	ZAMnRefnwwm9EtQHBrKlvSm1JsPyvWCfVemPho+yZqmphDl0ScjfZ9Wx9xUpAUvrDLQrdF
	lqs6MFg4JJeixr0zYyjRo/IjPU+aklI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788866094;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FlqvEth0Tiy4IX91fO/GBtvGwogbF8NDYd+W3vqHoCc=;
	b=2E+GpvCo6wefuhy/t/uzTiDZJkPfIQh2nyMVltFMy6+zul2RtQm9i38fUPCLYOT6OklGf4
	JbnelrwPlPRR0gDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25D5A1364A;
	Tue,  8 Sep 2026 11:14:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LrE1CS7un2qqRQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 08 Sep 2026 11:14:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AEB5FA12E2; Tue, 08 Sep 2026 13:14:49 +0200 (CEST)
Date: Tue, 8 Sep 2026 13:14:49 +0200
From: Jan Kara <jack@suse.cz>
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: linux-ext4@vger.kernel.org, Jonas Zhou <jonaszhou@zhaoxin.com>, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-kernel@vger.kernel.org, louisqi@zhaoxin.com, 
	jianhuizzzzz@gmail.com
Subject: Re: [PATCH v2] ext4: move journal state away from orphan list updates
Message-ID: <575wyoks3ldokhrg6v43rxwsegaecod4bgrpbii6jeczy7czbi@a3yq26u52orp>
References: <tf24u75hmpjhb2iqabyx6n3qur2kyda7vwz2eo5zcc2ek7utwp@m5sepatzqx2x>
 <a33183c1c24ea47a98afdd4756b49365593a2762.1788779199.git.jonaszhou@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a33183c1c24ea47a98afdd4756b49365593a2762.1788779199.git.jonaszhou@zhaoxin.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 50F4E1F789
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zhaoxin.com,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Mon 07-09-26 19:12:42, JonasZhou-oc wrote:
> From: Jonas Zhou <jonaszhou@zhaoxin.com>
> 
> In the tested x86-64 layout, s_journal and s_ext4_flags share a cache
> line with s_orphan_lock and s_orphan. Legacy orphan-list updates
> invalidate the same line used by unrelated journal and inode paths.
> 
> Exchange s_journal and s_ext4_flags with s_err_report_sec and
> s_li_request, which are used for error reporting and lazy-init
> management. This separates the common journal and flag readers from
> orphan-list writes without adding padding or shifting the intervening
> allocator fields. Preserve the comment describing s_orphan_lock.
> 
> Only these four member offsets change, and sizeof(struct ext4_sb_info)
> remains 2496 bytes with the tested x86-64 configuration. Compiled layout
> checks with quota disabled, lockdep, PREEMPT_RT and i386 also preserve
> the respective structure sizes and all other member offsets.
> 
> On a system with two Xeon Silver 4208 processors and a filesystem
> without orphan_file enabled, mean throughput improved by 13.52% for
> stress-ng dnotify and 31.70% for unlink.
> 
> This targets users of the legacy orphan list. The orphan_file feature
> avoids this lock in normal operation and remains the main scalability
> improvement. Tests with orphan_file enabled show no clear throughput
> change within the observed boot-to-boot variation.
> 
> Results from repeated tests comparing v7.3-rc1 and v2:
> 
>                        Mean throughput       Mean change
> Feature      Test          base         v2           (%)
> legacy       dnotify    19562.38   22206.66        +13.52
> legacy       unlink        38.82      51.13        +31.70
> legacy       fallocate    233.55     234.14         +0.25
> orphan_file  dnotify    27702.16   27582.55         -0.43
> orphan_file  unlink       116.93     116.52         -0.34
> orphan_file  fallocate    235.20     235.89         +0.29
> 
> Descriptive 95% t intervals from the four paired log ratios (df=3),
> expressed as percentage changes:
>   legacy:      dnotify [+4.83, +22.92], unlink [+22.53, +41.48],
>                fallocate [-1.40, +1.94]
>   orphan_file: dnotify [-5.44, +4.96], unlink [-2.76, +2.13],
>                fallocate [-0.82, +1.42]
> These are intervals for the paired geometric ratio, not the arithmetic
> mean ratio above. Four pairs do not establish performance equivalence.
> 
> For legacy dnotify, perf c2c shows remote HITM samples on the original
> journal/flags offsets, but none on their new cache line after the
> change. Local HITM samples and orphan-lock contention remain. The
> combined HITM sample density of the orphan and journal lines is lower
> than that of the original shared line.
> 
> Signed-off-by: Jonas Zhou <jonaszhou@zhaoxin.com>

Sorry, but we should keep things logically belonging together close. I'd
keep s_journal & s_ext4_flags in the read-mostly part of the sb and perhaps
move orphan-related things (s_orphan_lock, s_orphan, s_orphan_info) later.
Perhaps below s_journal_triggers definition. And add a comment there like:

	/* Orphan inode tracking */

								Honza

> ---
> Changes since v1:
> - Replace explicit cache-line alignment with a four-member exchange.
> - Keep the mutex comment and all other member offsets unchanged.
> - Retest this layout against v7.3-rc1, including orphan_file controls.
> 
> v1:
> https://lore.kernel.org/all/20260903021836.962624-1-jonaszhou-oc@zhaoxin.com/
> 
>  fs/ext4/ext4.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be61..16ef01078233 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1641,9 +1641,13 @@ struct ext4_sb_info {
>  	struct super_block *s_sb;
>  	struct buffer_head *s_mmp_bh;
>  
> +	/* timeout in seconds for s_err_report; 0 disables the timer. */
> +	unsigned long s_err_report_sec;
> +
> +	/* Lazy inode table initialization info */
> +	struct ext4_li_request *s_li_request;
> +
>  	/* Journaling */
> -	struct journal_s *s_journal;
> -	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
>  	struct mutex s_orphan_lock;	/* Protects on disk list changes */
>  	struct list_head s_orphan;	/* List of orphaned inodes in on disk
>  					   list */
> @@ -1747,11 +1751,10 @@ struct ext4_sb_info {
>  
>  	/* timer for periodic error stats printing */
>  	struct timer_list s_err_report;
> -	/* timeout in seconds for s_err_report; 0 disables the timer. */
> -	unsigned long s_err_report_sec;
> +	/* Keep journal state away from orphan list updates. */
> +	struct journal_s *s_journal;
> +	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
>  
> -	/* Lazy inode table initialization info */
> -	struct ext4_li_request *s_li_request;
>  	/* Wait multiplier for lazy initialization thread */
>  	unsigned int s_li_wait_mult;
>  
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.43.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
