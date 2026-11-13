Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794570134;
	b=gvVBps1mliGAZSL+XYkjsfX2ogbeYpxaLmwVSnwMHlCfjT3s5aMQeWSb/SmDP6LSPi0v
	 mRsNMyTRZasIArXlZY7S7eja/eVyY9st4EuJBXnmIcb4304HQmcqQDbzrYC5ow3t9fzCV
	 BkVtMKmfm57f9eToZQUqlQHng4Uczs/+Rr9w9RWag+lggYaKE20hh/cTD76vI6KL3BYqx
	 zhdmIkDxVifDFUQ8EqkOeaUgZkayglhHhHfWLj6hCdDOOUlKNXiNA+W/0Tq6FU8oWynlA
	 4KKrdbE47Fn3UkGyRk6e1ijxN/B1BRWVU3rjkp6zqrQiWBVDC4LZkm6jx1pkI9vSiZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794570134;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=HiASKsoge9ZhLc7H5LmDHN9gRxWAuyb+NGrypM6Aj/I=;
	b=hQO3rYz5c2CGxeCFtz23cw5u4gokzc1NI0HpZ3lRd5e5idDzuhGrnMikF5LVKFU1iBK1
	 tgixy1YbqF3LZLM5ZoVCYr34nrFQkJP9MslUyDHep1i+n7sixWLfCTokpcH+Gss/xZD/D
	 YliAsud9abYowTw3f9/xEHqohbURrvT44u/s4YPqKEU88xHaFOtCG5TwPzGEAlP4WrPIK
	 RcXKoVrCDkLT5byLqs5W47clIIrL0zW4qynwxRHtEsf1984ORzQoU4JHNk1KviGs/I2KN
	 +x42dnWVbjWzLLm/PFZuWOS/X50JSi4as/BoffcjxrLQrUnN+AZmrgwOLD0f4VRqggw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RP8fGMpZ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nPZzRs9h;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IwDxhzoW;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/LmgDMgC";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653BF606A323;
	Fri, 13 Nov 2026 11:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 653BF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=RP8fGMpZ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nPZzRs9h;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IwDxhzoW;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/LmgDMgC
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A40961F8CD;
	Fri, 13 Nov 2026 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794570130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HiASKsoge9ZhLc7H5LmDHN9gRxWAuyb+NGrypM6Aj/I=;
	b=RP8fGMpZkm+arKoFGBgnP8Buvvw8SWmK1AbaD3opg7AxYL6Mwus+8zoWAfPA50gYwXc1mG
	jYPRgYa0arQekIy+lRK49U37AfiMPYdAe8G9j8alGDn3qgQ/B+l3fwQmiJfqdydllvEkOw
	WIQpn7V7CLdwUkK3XXDk6UincNVXtw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794570130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HiASKsoge9ZhLc7H5LmDHN9gRxWAuyb+NGrypM6Aj/I=;
	b=nPZzRs9h/NS5EpOgkskveJcxRoIXcm30oUO9TPFZVcfnp6DZECFKDjePzc8z14lAzpKJkd
	hCvxqDmUpy+E8eDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794570129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HiASKsoge9ZhLc7H5LmDHN9gRxWAuyb+NGrypM6Aj/I=;
	b=IwDxhzoWxRJTSj6WNyRw7L/absr/2DjNaeIXEKhPMBFqL82r5wTPQg+Y8RI/zKWchdEkQG
	aQTt32tjC6xMwTyeVhb/uiEQTjkmXSahFEQwXSTOhyP2Fxd0URqEqD8wylyHoZnXGig7SW
	I0xJSAeBY1vBcGQ6awAmPiMfnT3z4gQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794570129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HiASKsoge9ZhLc7H5LmDHN9gRxWAuyb+NGrypM6Aj/I=;
	b=/LmgDMgCstk4eWHyS69iyg0YzWC0qIV+XtEftzB2cuwwjZkrEft7IT33EUzP4ELkrCc8uP
	DNAXD/yogOvyO0Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 826CE1344A;
	Fri, 13 Nov 2026 11:42:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /9UMGpH39mqMTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 11:42:09 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2EB8622CAE; Fri, 13 Nov 2026 12:42:05 +0100 (CET)
Date: Fri, 13 Nov 2026 12:42:05 +0100
From: Jan Kara <jack@suse.cz>
To: Chandradhar Kumar <chandradhar.2003@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: wait for tail page commit in
 ext4_truncate_failed_write()
Message-ID: <k5kh7sx5jxixvcwlqeenkliru4eo7mqyotozloogo6nlj4hsg2@kqgqerfg2fhd>
References: <20261112124835.114888-1-chandradhar.2003@gmail.com>
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
In-Reply-To: <20261112124835.114888-1-chandradhar.2003@gmail.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[f111db4cb2acd44eb2f4];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,syzbot.org:url,appspotmail.com:email,suse.com:email]
X-Spam-Score: -11.30

On Thu 12-11-26 18:18:32, Chandradhar Kumar wrote:
> When a buffered write fails partially (e.g., due to a user page fault)
> on an ext4 filesystem mounted in data=journal mode with blocksize <
> PAGE_SIZE, ext4_journalled_write_end() invokes ext4_truncate_failed_write()
> to discard newly allocated blocks beyond inode->i_size.
> 
> If the updated inode->i_size straddles a folio whose buffers are currently
> being committed to the journal, truncate_inode_pages() attempts to
> partially invalidate that folio via ext4_journalled_invalidate_folio().
> Because JBD2 cannot unmap buffers belonging to a committing transaction
> on a partial folio, journal_unmap_buffer() returns -EBUSY, triggering
> the WARN_ON() in ext4_journalled_invalidate_folio().
> 
> Unlike the standard truncate path in ext4_truncate_down(),
> ext4_truncate_failed_write() does not wait for the committing
> transaction on the tail page to finish before truncating the page cache.
> Export ext4_wait_for_tail_page_commit() and call it in
> ext4_truncate_failed_write() when data=journal is enabled before
> acquiring filemap_invalidate_lock() and calling truncate_inode_pages().
> 
> Fixes: 53e872681fed ("ext4: fix deadlock in journal_unmap_buffer()")
> Reported-by: syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
> Closes: https://syzbot.org/bug?extid=f111db4cb2acd44eb2f4
> Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>

Thanks but the fix was already posted here:
https://lore.kernel.org/all/20261112115906.17915-1-diasyzhangqing@gmail.com

								Honza

> ---
>  fs/ext4/ext4.h     | 1 +
>  fs/ext4/inode.c    | 2 +-
>  fs/ext4/truncate.h | 3 +++
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bf0325ecbec7..cc714d7b292c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3215,6 +3215,7 @@ int ext4_get_fc_inode_loc(struct super_block *sb, unsigned long ino,
>  extern int ext4_inode_attach_jinode(struct inode *inode);
>  extern int ext4_can_truncate(struct inode *inode);
>  extern int ext4_truncate(struct inode *);
> +extern void ext4_wait_for_tail_page_commit(struct inode *inode);
>  extern int ext4_break_layouts(struct inode *);
>  extern int ext4_truncate_page_cache_block_range(struct inode *inode,
>  						loff_t start, loff_t end);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e3129353d4ed..366345981438 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6819,7 +6819,7 @@ int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
>   * buffers that are attached to a folio straddling i_size and are undergoing
>   * commit. In that case we have to wait for commit to finish and try again.
>   */
> -static void ext4_wait_for_tail_page_commit(struct inode *inode)
> +void ext4_wait_for_tail_page_commit(struct inode *inode)
>  {
>  	unsigned offset;
>  	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
> diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
> index ce84aa2786c7..19ed4673284c 100644
> --- a/fs/ext4/truncate.h
> +++ b/fs/ext4/truncate.h
> @@ -17,6 +17,9 @@ static inline void ext4_truncate_failed_write(struct inode *inode)
>  	 * We don't need to call ext4_break_layouts() because the blocks we
>  	 * are truncating were never visible to userspace.
>  	 */
> +	if (ext4_should_journal_data(inode))
> +		ext4_wait_for_tail_page_commit(inode);
> +
>  	filemap_invalidate_lock(mapping);
>  	truncate_inode_pages(mapping, inode->i_size);
>  	ext4_truncate(inode);
> -- 
> 2.56.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
