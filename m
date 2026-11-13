Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794570053;
	b=1zcFIhmspYX7JzjKEnu2dnkSTim8gwa2MkI/ACjwrYvRvlHT+yu9aaGtM6cS5xWl3g2r
	 W5rrrRO/Q+US3wTv/wser7jaRv/HA4+U5SSLOEtndwaEo7LKB8iQUcrPKAa3POdPdJkTI
	 HB4gCAOBT/glyCzH2LTP8F19zwvuCWJNwDv7CAyl2aKLRey+a98Dsp15fv4QFmMKbzfA0
	 bsrZzleYKMuHzqanPWp6UC2JEnL1YhVQRz/FKKsh1xwxkFAbcHrpjgRBkljkZ0bZ/EiPb
	 t90EsJGvccxt6axorpPJauMHWxZ0ZcpW1QVClBnHroumL70xPjPM79HpaY6JLDNxCkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794570053;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=L6hDt1h9TgqUUSdOdXw5QV/pkLOjfDy4sOnODHls+Y0=;
	b=l6im/KWxO8kCjqZJ18TOhk0vQEHlcOvkkwGA/yh6lQSTR55gmyD2N9LFVLKqj2JfCWZZ
	 Ml8TrIArMi+NRIhmBXcbEChVTK2FEpNUznwe4Zry5ebOa1MaqTxruDlOwAr/kI05awt/L
	 JJnDdD174OsesFXzgkRbwkQN6Soq44XnSMzk+2P5aGUb/EO2L5dE9blPaYHeMq2T70cSX
	 RT90LJjUh/Tw8G9JhDt64NgW4a/TU+tkI1I1AKgIRjviE7wzRdxK1JjF8KEmEmVhoSmwI
	 V68VwfYzylsOo4o5FWQ/sUrSsuDGZCeibKmTn4SPC/SVNxLIRUcmmJ7vsc+tezN7hAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OfLq0FoK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mRyMC2K+;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OfLq0FoK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mRyMC2K+;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED0E606A321;
	Fri, 13 Nov 2026 11:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4ED0E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OfLq0FoK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mRyMC2K+;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OfLq0FoK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mRyMC2K+
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44A201F7C9;
	Fri, 13 Nov 2026 11:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794570051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L6hDt1h9TgqUUSdOdXw5QV/pkLOjfDy4sOnODHls+Y0=;
	b=OfLq0FoKK/ghkxeOBNoiFBUBZDn7gEC9kuTGaWfTL/m1d50WJBy1QtNrUds5hscbID+EVj
	7BT8BetD/sLctzAFMDOhz9pOH+d1ppMro4VOw8AfBeW5LltNgnQodzotxAvG0YhNN2XOmd
	0GS6L5eGRts/RrojTegPSj8m5Vob/KI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794570051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L6hDt1h9TgqUUSdOdXw5QV/pkLOjfDy4sOnODHls+Y0=;
	b=mRyMC2K+837h1YlP6Kn9dMOP1NSJoALj1DVfKUlCIq2GLOM5RDj/PXYYcvMA5rCFzgmwdI
	hsC6FLMyhI7HY4Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794570051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L6hDt1h9TgqUUSdOdXw5QV/pkLOjfDy4sOnODHls+Y0=;
	b=OfLq0FoKK/ghkxeOBNoiFBUBZDn7gEC9kuTGaWfTL/m1d50WJBy1QtNrUds5hscbID+EVj
	7BT8BetD/sLctzAFMDOhz9pOH+d1ppMro4VOw8AfBeW5LltNgnQodzotxAvG0YhNN2XOmd
	0GS6L5eGRts/RrojTegPSj8m5Vob/KI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794570051;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L6hDt1h9TgqUUSdOdXw5QV/pkLOjfDy4sOnODHls+Y0=;
	b=mRyMC2K+837h1YlP6Kn9dMOP1NSJoALj1DVfKUlCIq2GLOM5RDj/PXYYcvMA5rCFzgmwdI
	hsC6FLMyhI7HY4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1AD0C134F4;
	Fri, 13 Nov 2026 11:40:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1lS2MEL39mqfTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 11:40:51 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 76ECE22CAC; Fri, 13 Nov 2026 12:40:42 +0100 (CET)
Date: Fri, 13 Nov 2026 12:40:42 +0100
From: Jan Kara <jack@suse.cz>
To: diasyzhangqing@gmail.com
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Qing Zhang <diasyzhang@tencent.com>, syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: wait for tail page commit before truncating a
 failed write
Message-ID: <xvrgr5w6pjmzy3fcpodgkzwnfmxdkdiznqpegalku4cfc6gtyr@7vjow6r2tpwp>
References: <20261112115906.17915-1-diasyzhangqing@gmail.com>
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
In-Reply-To: <20261112115906.17915-1-diasyzhangqing@gmail.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,tencent.com:email,appspotmail.com:email,syzbot.appspot.com:url];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[f111db4cb2acd44eb2f4];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,tencent.com,syzkaller.appspotmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Thu 12-11-26 19:59:06, diasyzhangqing@gmail.com wrote:
> From: Qing Zhang <diasyzhang@tencent.com>
> 
> In data=journal mode, a failed extending write can leave buffers beyond
> i_size attached to the committing transaction. When blocksize < PAGE_SIZE,
> invalidating these buffers in the partial tail folio returns -EBUSY,
> triggering a warning in ext4_journalled_invalidate_folio() and leaving
> invalidation incomplete.
> 
> Call ext4_wait_for_tail_page_commit() before truncating the page cache
> in ext4_truncate_failed_write(), as is already done when shrinking a file
> via ext4_setattr(). The helper releases the folio lock before waiting
> for the commit to finish, then retries invalidation.
> 
> Fixes: 53e872681fed ("ext4: fix deadlock in journal_unmap_buffer()")
> Reported-by: syzbot+f111db4cb2acd44eb2f4@syzkaller.appspotmail.com
> Closes: https://syzbot.appspot.com/bug?extid=f111db4cb2acd44eb2f4
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> 
>  fs/ext4/ext4.h    | 1 +
>  fs/ext4/inode.c   | 2 +-
>  fs/ext4/truncate.h |  2 ++
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index f38fec3167fb..505ec38fa508 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3214,6 +3214,7 @@ int ext4_get_fc_inode_loc(struct super_block *sb, unsigned int ino,
>  extern int ext4_inode_attach_jinode(struct inode *inode);
>  extern int ext4_can_truncate(struct inode *inode);
>  extern int ext4_truncate(struct inode *);
> +extern void ext4_wait_for_tail_page_commit(struct inode *inode);
>  extern int ext4_break_layouts(struct inode *);
>  extern int ext4_truncate_page_cache_block_range(struct inode *inode,
>  						loff_t start, loff_t end);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 10cd85d4c721..f59c4a5b7561 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6845,7 +6845,7 @@ int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
>   * buffers that are attached to a folio straddling i_size and are undergoing
>   * commit. In that case we have to wait for commit to finish and try again.
>   */
> -static void ext4_wait_for_tail_page_commit(struct inode *inode)
> +void ext4_wait_for_tail_page_commit(struct inode *inode)
>  {
>  	unsigned offset;
>  	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
> diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
> index ce84aa2786c7..c10e4ab4242e 100644
> --- a/fs/ext4/truncate.h
> +++ b/fs/ext4/truncate.h
> @@ -17,6 +17,8 @@ static inline void ext4_truncate_failed_write(struct inode *inode)
>  	 * We don't need to call ext4_break_layouts() because the blocks we
>  	 * are truncating were never visible to userspace.
>  	 */
>  	filemap_invalidate_lock(mapping);
> +	if (ext4_should_journal_data(inode))
> +		ext4_wait_for_tail_page_commit(inode);
>  	truncate_inode_pages(mapping, inode->i_size);
>  	ext4_truncate(inode);
>  	filemap_invalidate_unlock(mapping);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
