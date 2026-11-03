Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713175;
	b=bSll6CN/3rRQZnp6hhEAYdQwFHu1b+4VvKgI8gwzStkIxhfEABiqXvPwFBvK6ZompHkH
	 /3p4yjVDLOBl2Da/WhgYE/FW4Mv6FCUuig2F1KWJ/MRAhKDERK8N9+vftOs5UVx4l/8NT
	 RJADOORAzeuPvJafchgRw9Zs8w55+3tUUMNcQNA22/GugliKTDXoRY+jK4CLLknB9D9Ie
	 dYap3ZdgM2JqjOygAYFRc39mEOwSBCarTlZLC+l8gD8P4dLH5QiQ54kCoU65uPBXGjN/b
	 t1qvkFcKwV76RvxeY0PWoA4O/QZ9W+yFbZGGJB5q6KCtoJweBMzObZiARLz1Wbj1BvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713175;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=YYN64mFF02iexIYImELzbWTLcKiNjVDa5ezGCoK5Lto=;
	b=zmH1Wro/JTnJ4iV4fdOpqRYDi/eQ8ieSZU5t3jgXppnNPCPKQvk4OSAv5OdEj0Ot1ivP
	 rsguhwRGuc9ZaRYCei+mgg5b2x6HCD5a12sgGmt0/OJgaHIYyp6LTmJ1m9r+kOflRC0Wn
	 aoA6s51Xl1dpqjqbTD2v7yEFaRr1sbpScRD/FeoHOpXO4qK8jjEV3J7+I8o7b/OkOnDmT
	 1dCj70T59e6uvqyJyOhz+Xazi/ZfEGDQjnp0vf/tunhDFi5UpDeKhlRx3LXiJY3g6AmCP
	 bBFQ2uzmthmSol2USC2fQyrVWk7WIO/YoldRlA7SBHNijoRicPPErpYv1NI2jHOcYPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fnkbpiJZ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=A1ZPqUwb;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="pFp3w4/3";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WYZida7t;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75663606A324;
	Tue,  3 Nov 2026 13:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75663606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fnkbpiJZ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=A1ZPqUwb;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pFp3w4/3;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WYZida7t
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F54622129;
	Tue,  3 Nov 2026 13:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793713172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYN64mFF02iexIYImELzbWTLcKiNjVDa5ezGCoK5Lto=;
	b=fnkbpiJZEfGwZWfX7bK+UMsK70wobpUi0Ynz4X0t5xGEhMTWIVqPAMvfADgynid7w3S1Rh
	zRYueKycquIw8PxeP5E9bRcI687HYfp9jPVvP9Jd4dyW8SMrl0ocu7Eq6ys3Q+Y2FDj4wU
	qW/TPB9z9kGOUbG6K7P/JRAKQs5cVwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793713172;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYN64mFF02iexIYImELzbWTLcKiNjVDa5ezGCoK5Lto=;
	b=A1ZPqUwbwcQUwegNkUmeRMSIrXQDf5AWrLBpbEuWHNnMxHDJgGM1SatFgPQAktCdcVjWEw
	GxmHs19w3CHrVcBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pFp3w4/3";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WYZida7t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793713171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYN64mFF02iexIYImELzbWTLcKiNjVDa5ezGCoK5Lto=;
	b=pFp3w4/3K6d06NJ95RmC8BHkQH3JBdp+HlUwQVNtyf18IusmYcK4FCRpWouz4cglhXhOVb
	bHY7hjzIFsAsVneDH4eqa8JtaJSaLDGuBqrhN+cTKjloaQ3XqopC+nNLY/sCG9/lRQNoSa
	vxXUNUV9b7pSFRE6z03UYbUyyvFcHyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793713171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YYN64mFF02iexIYImELzbWTLcKiNjVDa5ezGCoK5Lto=;
	b=WYZida7tb3jCtY9kRg+XoTinFwjN0/WeDQqOSW1lpBjQFDlNFywA6Z8qB7gVr/vf6xoqrW
	dos2I5/77Jsu5YBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3976F134B8;
	Tue,  3 Nov 2026 13:39:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OR+zBBPk6WoOSwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Nov 2026 13:39:31 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id BBEB6B27F; Tue, 03 Nov 2026 14:39:30 +0100 (CET)
Date: Tue, 3 Nov 2026 14:39:30 +0100
From: Jan Kara <jack@suse.cz>
To: Jianping Liu <frankljpliu@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, frankjpliu@tencent.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix soft lockup while shrinking the extent status
 cache
Message-ID: <qzycxafc6ur4y4llrg7l6ckftinlspffm2gtwhyc3sl2o7lqyu@vqvkhtyjq6pj>
References: <20261028061628.1209508-1-frankljpliu@gmail.com>
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
In-Reply-To: <20261028061628.1209508-1-frankljpliu@gmail.com>
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,tencent.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 6F54622129

On Wed 28-10-26 14:16:28, Jianping Liu wrote:
> From: Jianping Liu <frankjpliu@tencent.com>
> 
> __es_shrink() walks sbi->s_es_list and reclaims extents from each
> inode. On a non-preemptible kernel that walk never gives up the CPU.
> 
> There is a soft lockup report on our company's machine. The machine
> with millions of active inodes, 256 CPUs, and heavy memory pressure,
> concurrent shrinkers run too long.
> 
> i_es_lock is dropped after es_reclaim_extents(), and s_es_lock is not
> taken again until the next inode. Once the shrink has run for one
> second, call cond_resched() so the CPU can be scheduled before the
> scan continues.
> 
> Signed-off-by: Jianping Liu <frankjpliu@tencent.com>
> ---
>  fs/ext4/extents_status.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 018b6146b9d8..c9c70db5eb71 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1679,6 +1679,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  	int nr_to_walk;
>  	int nr_shrunk = 0;
>  	int retried = 0, nr_skipped = 0;
> +	unsigned long end_jiffies = jiffies + HZ;
>  
>  	es_stats = &sbi->s_es_stats;
>  	start_time = ktime_get();
> @@ -1719,6 +1720,15 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  		nr_shrunk += es_reclaim_extents(ei, &nr_to_scan);
>  		write_unlock(&ei->i_es_lock);
>  
> +		/*
> +		 * Call cond_resched to avoid soft lockup if a kernel with
> +		 * preempt disabled.
> +		 */
> +		if (time_after(jiffies, end_jiffies)) {
> +			cond_resched();
> +			end_jiffies = jiffies + HZ;
> +		}
> +

No need for this strange timing logic. Just add to this place (after the
nr_to_scan check):

	cond_resched_tasks_rcu_qs()

as we should also report RCU quiescent period here. Also I believe there
are some fixes to __es_shrink() flying around to fix nr_to_scan handling
because normally nr_to_scan should never be so large to trigger softlockups
(but __es_shrink() wasn't always obeying passed nr_to_scan).

								Honza

>  		if (nr_to_scan <= 0)
>  			goto out;
>  		spin_lock(&sbi->s_es_lock);
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
