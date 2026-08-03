Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080D8374E5C
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 09:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785750392; cv=none; b=TizAqt3CiQIOBhJukxcrtfUtSAOaEo52GbNRD2VkPdDGEWHVa7p/dL3UAOKSQ6FwCyRXndQZtOkaRlA45xaXw2/U41kzvZfGFf/GN4nuW8teQAUgtgcpdVSpWGpiewL6uD+LqZA6XG/CGDcVPcGS5rqcX9KgOeW0QVeIIi438ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785750392; c=relaxed/simple;
	bh=nds9fvhGt4uH4rN2FIEPyFOG2l8WjDjt5mhWIVGWLf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WorgZnUR/vVhNrWxKM8FfVi3jIRJiz0KZRnJD6OMbgzg3CoaiwGsFI646jX6LilV2CkZ3c2v+EULivE+uFsJ5E07f8pK27u7jq+TxAb1X7heHh7lcbznZOmMHVrzzoE7+9a4Uhc9enazt6rCyZqS8Cy8BYmoBI/wVGumy9NxPpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MAXFWv45; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YSO0viBb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v0KreYqg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AqiP9g+6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MAXFWv45";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YSO0viBb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v0KreYqg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AqiP9g+6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 044AD41EE;
	Mon,  3 Aug 2026 09:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785750385; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJKeJF1jb6lLdiF+6ljbdL9Jye3GABZBUXKqkAYvdFc=;
	b=MAXFWv45vqqvfOHNsxgccea5cIhSrdqIs6ONOPL+AQE7NfAoKtqWPTaHufD5f5DLZYquQU
	lCtPYBEw51Z9TVI/dVF5mcwc0ZUFdqFIjsEnu5NjoHHVDX3n12UYhprtviGOU6vkAt9C8x
	sx8K37FzzQzRQwisgAxt+Vf4ORXvEdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785750385;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJKeJF1jb6lLdiF+6ljbdL9Jye3GABZBUXKqkAYvdFc=;
	b=YSO0viBbeMAhXM9hOTn5qEg6I2iePk6xhDtOBlClEBfMsnp5Re+VQArD09q//FUW1rQ/nt
	AkUV0IyOLf6j4oAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v0KreYqg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AqiP9g+6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785750381; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJKeJF1jb6lLdiF+6ljbdL9Jye3GABZBUXKqkAYvdFc=;
	b=v0KreYqgJdv2FtxRXLfKqq7bzb23ORqAdvjMtRgodQpNvlzfGtdH47Vh5duls83nCseY6f
	hx+NL9X3Lr4Z3qYDjuwRFwrdDCIAwL7B8Eg5kRW+qwXfFeN2NIpKrvvSrkzbrYWJg7Lp38
	CCSjyC875X3hN0qWYDQvbqxM88Ep2tc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785750381;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJKeJF1jb6lLdiF+6ljbdL9Jye3GABZBUXKqkAYvdFc=;
	b=AqiP9g+6LZUGpgKTgvnPutrCsDSTe6fCjfvXNLKQb92YDPrV6s8mcZT7FsS4zBcKj0+Ltg
	++Zg5Xqh+mddwBBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED43A779C1;
	Mon,  3 Aug 2026 09:46:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NqrnOWxjcGonLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 09:46:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 69ABBA13A8; Mon, 03 Aug 2026 11:08:54 +0200 (CEST)
Date: Mon, 3 Aug 2026 11:08:54 +0200
From: Jan Kara <jack@suse.cz>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: stop retrying saturated xattr cache entries
Message-ID: <qrkmgvn7wszo75li5a46zpbsi7hw6evw36zx6es2vllapovuxy@vukdtamq3t7k>
References: <20260802065941.1726052-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802065941.1726052-1-matthias.goergens@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:dkim,appspotmail.com:email,syzkaller.appspot.com:url,suse.com:email];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[e68dbebd9617a9250e8d];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,suse.cz,dilger.ca,linux.alibaba.com,gmail.com,huawei.com,linux.ibm.com,syzkaller.appspotmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,syzkaller.appspot.com:url]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 044AD41EE
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Sun 02-08-26 14:59:41, Matthias Goergens wrote:
> ext4_xattr_block_set() retries when a cache entry selected for reuse
> has a saturated reference count after taking the buffer lock. The retry
> returns to the mbcache lookup without making that entry ineligible, so
> it can select the same unusable entry indefinitely. A task spinning
> there can hold the parent directory's i_rwsem and leave concurrent
> rmdir callers blocked.
> 
> Normally a reusable entry has a reference count below
> EXT4_XATTR_REFCOUNT_MAX because the count and MBE_REUSABLE_B are
> updated under the same buffer lock. A corrupted filesystem can violate
> that invariant. The syzbot reproducer reports allocator and xattr
> corruption before triggering this retry loop.
> 
> Check the untrusted on-disk count before incrementing it, avoiding
> overflow, and clear MBE_REUSABLE_B when it is already saturated. The
> next lookup then skips the entry that was just proven unusable. This
> mirrors the normal transition at EXT4_XATTR_REFCOUNT_MAX; the release
> path marks the entry reusable again on the exact 1024-to-1023
> transition.
> 
> Using the same QEMU harness and guest parameters, current unpatched
> Linux hung in 6 of 8 420-second trials with the do_rmdir signature;
> representative NMI backtraces caught the owner spinning in
> ext4_xattr_block_set(). The patched kernel completed 28 of 28 trials
> without a hung-task report; the final twelve trials exercised the
> reviewed overflow-safe form of the change. syzbot's patch testing also
> completed without reproducing the hang.
> 
> Reported-and-tested-by: syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e68dbebd9617a9250e8d
> Fixes: 65f8b80053a1 ("ext4: fix race when reusing xattr blocks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e228..3c1bb547b2f54 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2075,12 +2075,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  				 * stable so we can check the additional
>  				 * reference fits.
>  				 */
> -				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
> -				if (ref > EXT4_XATTR_REFCOUNT_MAX) {
> +				ref = le32_to_cpu(BHDR(new_bh)->h_refcount);
> +				if (ref >= EXT4_XATTR_REFCOUNT_MAX) {
>  					/*
>  					 * Undo everything and check mbcache
>  					 * again.
>  					 */
> +					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
>  					unlock_buffer(new_bh);
>  					dquot_free_block(inode,
>  							 EXT4_C2B(EXT4_SB(sb),
> @@ -2091,6 +2092,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  					new_bh = NULL;
>  					goto inserted;
>  				}
> +				ref++;
>  				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
>  				if (ref == EXT4_XATTR_REFCOUNT_MAX)
>  					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
