Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9E636A340;
	Tue, 18 Aug 2026 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787088008; cv=none; b=VTsi2m66ouewoTMeF3DARdUDw1x72cM3PQGtx0G7ionkU7pa1kjW70pqalzDKG8G0rUabLPHp3sA98Lm1r5pf3mEluF8wzrbA0if0XWHnfZfR+lHh/W/5Ul+DJbyQIyPmOxR/tGxGx/hlAVOgXmxZCR7COZzzNKhUsAdgN9lQxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787088008; c=relaxed/simple;
	bh=b7oEMYUXlq+mHFUiLsAJ1CRe1nlUA18m2Gr8L3M+3vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuZfDKmW82lMS/MHD3sT7Sgs0qnbXdGzDaN6+EkCFGiyRT5ynnDBwcZvrXIZR+ei5J6k/zcWhE0iPJbfJUCzn8yuKYaO+fJ9VVbggJhWwHmErhbMdocx1ifLvEILFfkqlSBSyxlHXwtzNp+/fReGaIyoMMZvop9gYyec6dO8tfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aeALswgK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NNE6VQWm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aEbkbUMC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VhY5hR6J; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aeALswgK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NNE6VQWm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aEbkbUMC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VhY5hR6J"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4DB0B8475F;
	Tue, 18 Aug 2026 21:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787087605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FZaoCOLPxZMMphF4PrSLiZW5UKGPnIa/2ZrS/1lqOHY=;
	b=aeALswgKA1B+n8pfrtpnF3MF2JX/2w9HakWfLxuEjvf5WSDmomhRxmkSc4rC+MFfChlk5U
	PVD38J8USmGrjeQEv4DdzYPL0LS+2FnhZOMH9l+T+lhKbK2om6ODH/FBwmRJoPvXVXQoIc
	zNAVngtGGzKoswkvll/wKJPfl+ZrMxg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787087605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FZaoCOLPxZMMphF4PrSLiZW5UKGPnIa/2ZrS/1lqOHY=;
	b=NNE6VQWmXBA4vGGHZGHErMd/fI4+pa8JJ5XM0cGgNPg1dltdrCeMFym3qA/WTSSOm0Y5Qm
	NF12N3dpwc5MnzCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aEbkbUMC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VhY5hR6J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787087601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FZaoCOLPxZMMphF4PrSLiZW5UKGPnIa/2ZrS/1lqOHY=;
	b=aEbkbUMC1L421+wcRHTSH2qbhy9jH9YKnmQFLxlWVXjy600GcofrT3QRuzEdZiFTiWdRAm
	pu4PC/5nwmRahgAf9CjG26WGe7qtZXUagxwUSeVXcdx8Oarztli1O3Vyd/Eh6FO5GYmCzp
	qnrwTEaCtKQxi35msBUCGu8RBzknTdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787087601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FZaoCOLPxZMMphF4PrSLiZW5UKGPnIa/2ZrS/1lqOHY=;
	b=VhY5hR6JW0Bum9McJiw2xn8MDb8f2tWzezPnoFXHtYH5c6uqutCIr+RdQvMzX8Sjutcp/r
	ij+R1cBCi+kvIADA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E29A22BA;
	Tue, 18 Aug 2026 21:13:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nHxXB/HKhGovfgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 18 Aug 2026 21:13:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B9359A13AD; Tue, 18 Aug 2026 23:13:16 +0200 (CEST)
Date: Tue, 18 Aug 2026 23:13:16 +0200
From: Jan Kara <jack@suse.cz>
To: guzebing <guzebing1612@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, bretznic@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: reject delalloc to nodelalloc before applying
 remount options
Message-ID: <4hnd5hokn2w4diixm65yzgyjgxgs6oafctqsa5fmrnv4fkhh75@ymcd6ixsapoh>
References: <20260814034855.1573759-1-guzebing1612@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814034855.1573759-1-guzebing1612@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4DB0B8475F
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Fri 14-08-26 11:48:55, guzebing wrote:
> Commit 97f5ec3b166d ("ext4: prevent delalloc to nodelalloc on
> remount") rejects switching a mounted filesystem from delalloc to
> nodelalloc.  However, it performs the check after ext4_apply_options()
> has already cleared EXT4_MOUNT_DELALLOC in the live superblock.  The
> failure path eventually restores the bit, but leaves a window where
> other CPUs can observe nodelalloc.
> 
> test_opt() reads s_mount_opt directly without a lock shared with
> remount.  If a concurrent truncate's __es_remove_extent() hits this
> window and observes nodelalloc, it sets count_reserved to false.
> Delayed extent status entries are then removed without calculating
> their cluster reservations, leaving reserved at zero.
> ext4_es_remove_extent() therefore calls ext4_da_release_space() with
> zero, leaving i_reserved_data_blocks and s_dirtyclusters_counter
> elevated.  When the inode is later evicted after unlink,
> ext4_destroy_inode() reports:
> 
>   i_reserved_data_blocks (...) not cleared!
> 
> CPU 0                             CPU 1
>                                   ksys_truncate()
>                                     ...
>                                     ext4_es_remove_extent()
> ext4_reconfigure()
>   ext4_check_opt_consistency()
>   __ext4_remount()
>     ext4_apply_options()
>       clear EXT4_MOUNT_DELALLOC
>                                       __es_remove_extent()
>                                         test_opt() sees !DELALLOC
>                                         count_reserved = false
>     reject delalloc -> nodelalloc
>     restore EXT4_MOUNT_DELALLOC
>                                         remove delayed ES
>                                     ext4_da_release_space(0)
> 
> Follow the pre-apply validation approach used by
> ext4_check_quota_consistency() and reject the transition in
> ext4_check_opt_consistency(), before ext4_apply_options() changes live
> state.  Use mask_s_mount_opt to determine whether delalloc/nodelalloc
> was specified and ctx_test_mount_opt() to check the final parsed value.
> 
> Fixes: 97f5ec3b166d ("ext4: prevent delalloc to nodelalloc on remount")
> Cc: stable@vger.kernel.org
> Signed-off-by: guzebing <guzebing1612@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
