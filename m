Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3945F3C3C11
	for <linux-ext4@vger.kernel.org>; Thu,  5 Mar 2026 15:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725318; cv=none; b=pblkbnwyXSdfA2UIIEjpVFPPzwbrU/02uHewoxXG7T6VR2ofj4ZqCGjG30EveuFabhgDKxvn6MTfOJ+cLEoCIhY2wD7SbntbITIT+3EWz/GxGQpZpIWrLQ+C2q+Is6jJlXoTyCfeBMRb3GXYFhwRGVsJJGltzVNUi5TFysgNp+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725318; c=relaxed/simple;
	bh=V4x1iTM9LwSTCDUHxnbz1KkO6RzwODIh2/sbZS340U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FB8Wd4g92Cexm/kvkihLnnqpj2BOUe2zgNbHnmZ9exmUHaoVQqGiWd3CCEw55aZ2snXkoeqA7gaymR+zLv6FuMgs0JSsZD0ZjB/SKF515/52/5LVILKpLKFBl2XNIEtUanbvZrCGmy6Sie/5LqltYJaLQlbqW4jmYPZmXkRf/+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RQg2dzKQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gwR5u1ah; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RQg2dzKQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gwR5u1ah; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RQg2dzKQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gwR5u1ah";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RQg2dzKQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gwR5u1ah"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 86DDB3E6C5;
	Thu,  5 Mar 2026 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772725315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lrzDyxKRVxtm06Q3viz4lf80R5PhuY3L7nadSex6cZk=;
	b=RQg2dzKQT8Qq35fCaXblDOHoYrsS4+zd7263qBOQuX14RM3Tg3BNQUXP7MGaiV724sxs1H
	iF9q+u55Azk5qokCuSvSBR9Z0RMplQtxNzJD6kDoqzBgiRgqFvlLW+b+YNDE8z8S5m9ZEL
	lzseh3n6YY7I2hN/51kIAuKa6At+vvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772725315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lrzDyxKRVxtm06Q3viz4lf80R5PhuY3L7nadSex6cZk=;
	b=gwR5u1ahgScQxB2s0KBdKQVvO7JZs2Lu59/BsAwaWhxdgdvcczXENHcDc0GaktgsGss9qa
	qmYQ5oxbOmLajNAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772725315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lrzDyxKRVxtm06Q3viz4lf80R5PhuY3L7nadSex6cZk=;
	b=RQg2dzKQT8Qq35fCaXblDOHoYrsS4+zd7263qBOQuX14RM3Tg3BNQUXP7MGaiV724sxs1H
	iF9q+u55Azk5qokCuSvSBR9Z0RMplQtxNzJD6kDoqzBgiRgqFvlLW+b+YNDE8z8S5m9ZEL
	lzseh3n6YY7I2hN/51kIAuKa6At+vvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772725315;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lrzDyxKRVxtm06Q3viz4lf80R5PhuY3L7nadSex6cZk=;
	b=gwR5u1ahgScQxB2s0KBdKQVvO7JZs2Lu59/BsAwaWhxdgdvcczXENHcDc0GaktgsGss9qa
	qmYQ5oxbOmLajNAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DDF13EA68;
	Thu,  5 Mar 2026 15:41:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2pO1HkOkqWkaQwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 15:41:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2564CA0A8D; Thu,  5 Mar 2026 16:41:55 +0100 (CET)
Date: Thu, 5 Mar 2026 16:41:55 +0100
From: Jan Kara <jack@suse.cz>
To: Edward Adam Davis <eadavis@qq.com>
Cc: jack@suse.cz, brauner@kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4] ext4: avoid infinite loops caused by residual data
Message-ID: <agn2b2tn4h3whokr262gca5s6eoautng2u2vt6535w7myuyk6x@6kgv6h7pco5g>
References: <uweckkartekmwpzpt2kt34bbjyn3a2a4tc3lw7qyyghkxhfl5l@st7yfcuu73f4>
 <tencent_3ADDAE194DCFFD8DC925858DC11278DDA907@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_3ADDAE194DCFFD8DC925858DC11278DDA907@qq.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[1659aaaaa8d9d11265d7];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[qq.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,qq.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,appspotmail.com:email]
X-Spam-Flag: NO

On Thu 05-03-26 22:12:03, Edward Adam Davis wrote:
> On the mkdir/mknod path, when mapping logical blocks to physical blocks,
> if inserting a new extent into the extent tree fails (in this example,
> because the file system disabled the huge file feature when marking the
> inode as dirty), ext4_ext_map_blocks() only calls ext4_free_blocks() to
> reclaim the physical block without deleting the corresponding data in
> the extent tree. This causes subsequent mkdir operations to reference
> the previously reclaimed physical block number again, even though this
> physical block is already being used by the xattr block. Therefore, a
> situation arises where both the directory and xattr are using the same
> buffer head block in memory simultaneously.
> 
> The above causes ext4_xattr_block_set() to enter an infinite loop about
> "inserted" and cannot release the inode lock, ultimately leading to the
> 143s blocking problem mentioned in [1].
> 
> By using ext4_ext_remove_space() to delete the inserted logical block
> and reclaim the physical block when inserting a new extent fails during
> extent block mapping, either delete both as described above, or retain
> the data completely (i.e., neither delete the physical block nor the
> data in the extent tree), residual extent data can be prevented from
> affecting subsequent logical block physical mappings. 
> 
> Besides the errors ENOSPC or EDQUOT, this means metadata is corrupted.
> We should strive to do as few modifications as possible to limit damage.
> So just skip freeing of allocated blocks.
> 
> [1]
> INFO: task syz.0.17:5995 blocked for more than 143 seconds.
> Call Trace:
>  inode_lock_nested include/linux/fs.h:1073 [inline]
>  __start_dirop fs/namei.c:2923 [inline]
>  start_dirop fs/namei.c:2934 [inline]
> 
> Reported-by: syzbot+512459401510e2a9a39f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1659aaaaa8d9d11265d7
> Tested-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
> Reported-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=512459401510e2a9a39f
> Tested-by: syzbot+1659aaaaa8d9d11265d7@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

...

> @@ -4457,20 +4457,19 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	path = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
>  	if (IS_ERR(path)) {
>  		err = PTR_ERR(path);
> -		if (allocated_clusters) {
> -			int fb_flags = 0;
> -
> +		/*
> +		 * Gracefully handle out of space conditions. If the filesystem
> +		 * is inconsistent, we'll just leak allocated blocks to avoid
> +		 * causing even more damage.
> +		 */
> +		if (allocated_clusters && (err == -EDQUOT || err == -ENOSPC)) {

This is fine now...

>  			/*
>  			 * free data blocks we just allocated.
>  			 * not a good idea to call discard here directly,
>  			 * but otherwise we'd need to call it every free().
>  			 */
>  			ext4_discard_preallocations(inode);
> -			if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> -				fb_flags = EXT4_FREE_BLOCKS_NO_QUOT_UPDATE;
> -			ext4_free_blocks(handle, inode, NULL, newblock,
> -					 EXT4_C2B(sbi, allocated_clusters),
> -					 fb_flags);
> +			ext4_ext_remove_space(inode, newex.ee_block, newex.ee_block);

But this won't work because in case of errors like ENOSPC there's no extent
inserted into the tree so ext4_ext_remove_space() won't do anything. Just
don't touch the freeing code and things will be fine...

								Honza

>  		}
>  		goto out;
>  	}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
