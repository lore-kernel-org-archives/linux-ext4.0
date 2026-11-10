Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306509;
	b=k/mcfZn5JoU5IPYGUjATxTwMxnSG10WMVkC6ohusNByU5kEPr8sjAcqP2zSV1WfdcKE/
	 D7WjSdXfB3S1yDgEaRF6ssA6Lx6P7hAUtnMe3GDLVfG1kxb3Yq2yEuvDxXXgQzCBDx4xD
	 ZYyZd/XZFG+Fi+YJvXyvB2jMQDErQAT2nZ6+nuqoPQkARQkj9MX/b2hOcCYEKH6kIrSG9
	 bW34Ii4ePv2tyg9YFP/rpEGe83MNspMrhZBqobgYu9K0JeV5AWqR7f+VDMWYRt+KNdYq+
	 cOP62UqDeAvZvctRscdK+sNZJk9yCC/PjoeMuZ3X1NcWhw2bBTRdzEdpxpWf4xkyMew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306509;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=NcwaoTA9rV1OfF6tYr5pK6o6JIWf+fvZ7n3QSlPvMX0=;
	b=JK96rWPajOx/U5PQAKTgHr8NAsYDx/3+XRAQMcEsXBEzHMOvrlUNVXeBypAuxma22AAs
	 IhNmBYRGhzBkqzboYFmEFZHnfOxencjTHihfOAw+0BUN8Y9xuP8DyBkzKcxkBPSBP0kQj
	 rAtNmhW/1wxaOUcWxsXWotgQH75Nu687XJWriWOIqCORmM/81iV0DfbuT60XRtM0vaZX8
	 dS1arQphKP7sHiv/0JYy5ogGn5cH2Zn0kUrgqXqSB50mwvSI3W1TpKEelrz6aSVYVslDi
	 Chv6B244GmNEvXzoYDgrnbqhXSmGCr14jYHtrPpoGamIy48xsoono7F6xGe42JDacmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vRH8xX9L;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oaZxYko4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vRH8xX9L;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oaZxYko4;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E59F606A339;
	Tue, 10 Nov 2026 10:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E59F606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vRH8xX9L;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oaZxYko4;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vRH8xX9L;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oaZxYko4
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 882FB21DBF;
	Tue, 10 Nov 2026 10:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcwaoTA9rV1OfF6tYr5pK6o6JIWf+fvZ7n3QSlPvMX0=;
	b=vRH8xX9LD/RS0a1enSZyyO3s6fVgfuYXAgR0qil4E4VvgwR1pC5428MIL93qtDQFKXCvZT
	VNqqvVBs060HbdGUbDIadXE/C+DCKdhRhTFnvKHbGsUHpoIIbYWBr8LQxRTOf2E9+IZx6g
	dWK02yR+vw8uP8uY/6i1zvKM+3gVtcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcwaoTA9rV1OfF6tYr5pK6o6JIWf+fvZ7n3QSlPvMX0=;
	b=oaZxYko4iKE2V0T+XjqRbc20JgOtiDJ/AzlNov3Q/SmadNK1fI2Pd13gZAkryPJT2KHq30
	wnv1b5hXuNhgOfCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcwaoTA9rV1OfF6tYr5pK6o6JIWf+fvZ7n3QSlPvMX0=;
	b=vRH8xX9LD/RS0a1enSZyyO3s6fVgfuYXAgR0qil4E4VvgwR1pC5428MIL93qtDQFKXCvZT
	VNqqvVBs060HbdGUbDIadXE/C+DCKdhRhTFnvKHbGsUHpoIIbYWBr8LQxRTOf2E9+IZx6g
	dWK02yR+vw8uP8uY/6i1zvKM+3gVtcE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NcwaoTA9rV1OfF6tYr5pK6o6JIWf+fvZ7n3QSlPvMX0=;
	b=oaZxYko4iKE2V0T+XjqRbc20JgOtiDJ/AzlNov3Q/SmadNK1fI2Pd13gZAkryPJT2KHq30
	wnv1b5hXuNhgOfCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C1671339F;
	Tue, 10 Nov 2026 10:28:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rVOSDMvx8mojKwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 10:28:27 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id F06AE22473; Tue, 10 Nov 2026 11:28:26 +0100 (CET)
Date: Tue, 10 Nov 2026 11:28:26 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RFC v3 10/14] ext2: drop mmb_sync() from
 ext2_evict_inode()
Message-ID: <ngzxtomgmdqmtowpsxdzm3znnblqcjqdvo63t6j3do2maov5vn@yoltr7iqvm4s>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-10-91ac6c024018@kernel.org>
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
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-10-91ac6c024018@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 09-11-26 17:51:25, Christian Brauner wrote:
> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> ext2_evict_inode() to sync.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/inode.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 9261b666d043..4c38a3a8ea4d 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -91,8 +91,6 @@ void ext2_evict_inode(struct inode * inode)
>  		if (inode->i_blocks)
>  			ext2_truncate_blocks(inode, 0);
>  		ext2_xattr_delete_inode(inode);
> -	} else {
> -		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
>  	}
>  	mmb_invalidate(&EXT2_I(inode)->i_metadata_bhs);
>  	clear_inode(inode);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
