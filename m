Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306546;
	b=OzxhEoUFpFjxmXS1u9oIKhLhaLmvH+2tqTALPIa4yvL8MZBpLTu9IL9Ix40B6xXBFh2m
	 vp4f4rKtYvajlHhTynUue38E/CotI9cMRcSzZVK0kw3fZN8vve81xfpwumP2Ort9yODgO
	 ABrKmvHk+QwScNb3l5QSIsVChnx4O/b3q096lZ4hiof+maTrLOGCAzSkjPa86aBJWubcd
	 ssY/FoN6nzBj7sPF/nMqqahFsvewIu3PzpsYNLz4TiVtkHpgoZgSCUlaf3sO5akqVRXcD
	 pCdl5BCEJjMZ4QWdtKDdxPDbLevBd6JA7zzvBd1e8bmS7UEL+tI16uu0415c7ieeKyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306546;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=M9wXh7kTJGut5c727jPvD7xuLdEoT/C7ND5H4pG/KXE=;
	b=vvPme1p1mk+sgWgWMxbRlEFhmVGUIhReL3afvCCu/tLO9uHzEyTyME6ciI/5A7AOTqwP
	 XUpZswP980xeNhfDLS6zgHq67uHDHnKikw83TFYXlOoqhnYMczLPAHOxB/wZoY/3c30Fn
	 AU+ST7jgKpV68ZaxCm2u94miAwOIhkrJ1GkIgiUiz63t2GyLsRc8Bd0aXLwEzA8v2FHa3
	 Qqe8Ass9x8MPAJyMzbFv2F0kzsFU7htIOe45IZ8V8gDE+pqtaF9SbSAxEGY9YuIEI3rO+
	 dBid3km5+W7l2Oa0shVkOZawKTQoTVxNOrfArHlIsSW+pd7QB8LRwnOkBKExDOiII/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=R41LFb6q;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=u49FY4xv;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=R41LFb6q;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=u49FY4xv;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F09C606A31C;
	Tue, 10 Nov 2026 10:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F09C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=R41LFb6q;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=u49FY4xv;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=R41LFb6q;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=u49FY4xv
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 517671F7BF;
	Tue, 10 Nov 2026 10:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M9wXh7kTJGut5c727jPvD7xuLdEoT/C7ND5H4pG/KXE=;
	b=R41LFb6qRHVP1JwDsvzgRAEf2ejLQ3ytilT1SFVwtWTvgusRJI9Af/0ws3S+Sb8MmZWjNf
	qOewT2D7e6dTjxkDYkZMuo30QnY0v0Bo17367DJqoi34PVMfzw4AM+GA991QkIO7Es7svZ
	OyEPiLnGnioE7fr9QPKeKKeDrSAYDzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306544;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M9wXh7kTJGut5c727jPvD7xuLdEoT/C7ND5H4pG/KXE=;
	b=u49FY4xvwWDr2XEmdO09/S2/aYwVpt0IKoz3/lS2YR+ImIv1WpoNc5JX/+a8HGro6USUPL
	Cmpdy70xkbTV4fCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M9wXh7kTJGut5c727jPvD7xuLdEoT/C7ND5H4pG/KXE=;
	b=R41LFb6qRHVP1JwDsvzgRAEf2ejLQ3ytilT1SFVwtWTvgusRJI9Af/0ws3S+Sb8MmZWjNf
	qOewT2D7e6dTjxkDYkZMuo30QnY0v0Bo17367DJqoi34PVMfzw4AM+GA991QkIO7Es7svZ
	OyEPiLnGnioE7fr9QPKeKKeDrSAYDzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306544;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M9wXh7kTJGut5c727jPvD7xuLdEoT/C7ND5H4pG/KXE=;
	b=u49FY4xvwWDr2XEmdO09/S2/aYwVpt0IKoz3/lS2YR+ImIv1WpoNc5JX/+a8HGro6USUPL
	Cmpdy70xkbTV4fCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2AA471339F;
	Tue, 10 Nov 2026 10:29:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LaBKAvDx8mrqKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 10:29:04 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C46D722477; Tue, 10 Nov 2026 11:28:59 +0100 (CET)
Date: Tue, 10 Nov 2026 11:28:59 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RFC v3 12/14] minix: drop mmb_sync() from
 minix_evict_inode()
Message-ID: <utthkp6mtxnps5xoaoaxfkmdakfr2ltzji3uzlx4vx4oy6axdv@c4cm5uq7c32v>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-12-91ac6c024018@kernel.org>
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
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-12-91ac6c024018@kernel.org>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 09-11-26 17:51:27, Christian Brauner wrote:
> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> minix_evict_inode() to sync.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/minix/inode.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/minix/inode.c b/fs/minix/inode.c
> index 756bef4dc832..9fb938ec5868 100644
> --- a/fs/minix/inode.c
> +++ b/fs/minix/inode.c
> @@ -50,8 +50,6 @@ static void minix_evict_inode(struct inode *inode)
>  	if (!inode->i_nlink) {
>  		inode->i_size = 0;
>  		minix_truncate(inode);
> -	} else {
> -		mmb_sync(&minix_i(inode)->i_metadata_bhs);
>  	}
>  	mmb_invalidate(&minix_i(inode)->i_metadata_bhs);
>  	clear_inode(inode);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
