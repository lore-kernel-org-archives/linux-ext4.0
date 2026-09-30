Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04BF52123F;
	Wed, 30 Sep 2026 17:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789713; cv=none; b=i1S1fKKii1uAcOLWLJB9BZvH5mPOaIXOtEbA9bkEH+SZpjHDBjFSWTw3g0rchoef6IUlHcVaxBMvIEWwhxRjho1X7nqKr1be0WBiONytU3OOXQStv2lerKuxM6vJKwGBx2veh/dnepQOHB9JBN4bpqOhrAfEcdgy5bj1hmmzer8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789713; c=relaxed/simple;
	bh=16sQc8An7ndpiHw3dVyQt5lF9lOeatT0/Vj6hH11dR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGotYXPrjflO9t3yZpzMbmWV7Y3qvzGM5L/6/YwZWDx1U9dVqLflhNAcycFDhjjcCxJs4ZSVqbA0MPf1X/MgeHu9Y6tfccFu6wjfs1WIkwqa3UV3QkH5sHBjR/59CtRsaBe/TrVlgDb1gpBe0ITsQg3n1gnMLa5gpTPXYeA0hYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DsaHkNVA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QHdqSX/3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OrPZM/Rn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9SmtVJw3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DsaHkNVA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QHdqSX/3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OrPZM/Rn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9SmtVJw3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 464CD21BF5;
	Wed, 30 Sep 2026 17:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790789705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uuTxKw22Zck+5WC25ZqUnaFztqHPYWW795D3wfeM7is=;
	b=DsaHkNVAeskAw0sHIC+ulll1jy83ZulrOXAN2EodCqKaiI8cMzzOFwcnCGs2MqIpRIcN3K
	ORSKTbYtltYKnsADTH9ITwRKzK1AD/ztJRsJY5HDLxFxun1ZkE3qvybbBPY1WKlen6S9t5
	gZlDxKKvm6lrIGqvos7ZP5h1GQX44XI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790789705;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uuTxKw22Zck+5WC25ZqUnaFztqHPYWW795D3wfeM7is=;
	b=QHdqSX/3EQqJ2WTZPaHIARjmRrPk4G/xE5ef1p2/6Ndh9tuQdelrU8wSUu9tN+jDfA4P2i
	QQUiiTIGxjVbx4Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="OrPZM/Rn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9SmtVJw3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790789701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uuTxKw22Zck+5WC25ZqUnaFztqHPYWW795D3wfeM7is=;
	b=OrPZM/Rn+zTrF266iL9sBXj9a25b+2mInq7OBxTiy6Q7a6yQREK0x0rf7Th8o/ovEJhrlA
	52LjTQ6POaq8zF0m6BDPCOm4o+9Xu8VWUMOsjzmTYcK3o//odn29WdPbYDxR4M8LL+MCYU
	mx5H/DijRJhZ1iXk7zYyCJwiTDRRX34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790789701;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uuTxKw22Zck+5WC25ZqUnaFztqHPYWW795D3wfeM7is=;
	b=9SmtVJw3kT+19qLB+hXGSZ4EEQgwyFzfvDImx9HXkzfQdUZ0xRZPdO6v1qIyEDJ+XusmOY
	bvNU1a4fDEXYb2Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E03A13AF5;
	Wed, 30 Sep 2026 17:35:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3lR0OkRIvWqOQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 30 Sep 2026 17:35:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9B39DA13AD; Wed, 30 Sep 2026 19:34:45 +0200 (CEST)
Date: Wed, 30 Sep 2026 19:34:45 +0200
From: Jan Kara <jack@suse.cz>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ext4: remove unused locked_ei parameter from
 __es_shrink()
Message-ID: <alyagfu73mpjvxqhjttnujjaklsd37ja4xtj56xjuxousrexhc@vdp37slj424b>
References: <20260930-fix-ext4-es-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com>
 <20260930-fix-ext4-es-scan-nr-scanned-v3-2-9aef0be87d21@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-fix-ext4-es-scan-nr-scanned-v3-2-9aef0be87d21@gmail.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 464CD21BF5
X-Rspamd-Action: no action
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
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Wed 30-09-26 15:11:38, Qiliang Yuan wrote:
> __es_shrink()'s locked_ei parameter exists to let a caller pass in an
> inode it already holds i_es_lock on, so the shrinker walk can skip
> that inode instead of deadlocking on write_trylock(), and fall back
> to reclaiming from it directly if nothing else could be freed. Its
> only caller, ext4_es_scan(), always passes NULL.
> 
> Drop the parameter along with the two code paths that exist solely to
> support it: the ei == locked_ei skip check, and the trailing
> es_reclaim_extents(locked_ei, ...) fallback, neither of which can ever
> run while locked_ei is always NULL.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents_status.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index d88af807d36e7..efbccb29d5fd1 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -183,8 +183,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  			      int *reserved, struct extent_status *res,
>  			      struct extent_status *prealloc);
>  static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
> -static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> -		       struct ext4_inode_info *locked_ei);
> +static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan);
>  static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
>  			    ext4_lblk_t len,
>  			    struct pending_reservation **prealloc);
> @@ -1669,8 +1668,7 @@ void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  	ext4_da_release_space(inode, reserved);
>  }
>  
> -static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> -		       struct ext4_inode_info *locked_ei)
> +static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan)
>  {
>  	struct ext4_inode_info *ei;
>  	struct ext4_es_stats *es_stats;
> @@ -1706,7 +1704,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  			continue;
>  		}
>  
> -		if (ei == locked_ei || !write_trylock(&ei->i_es_lock)) {
> +		if (!write_trylock(&ei->i_es_lock)) {
>  			nr_skipped++;
>  			continue;
>  		}
> @@ -1734,9 +1732,6 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  		goto retry;
>  	}
>  
> -	if (locked_ei && nr_shrunk == 0)
> -		nr_shrunk = es_reclaim_extents(locked_ei, &nr_to_scan);
> -
>  out:
>  	scan_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
>  	if (likely(es_stats->es_stats_scan_time))
> @@ -1779,7 +1774,7 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
>  	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
>  	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
>  
> -	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
> +	nr_shrunk = __es_shrink(sbi, nr_to_scan);
>  
>  	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
>  	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
> 
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
