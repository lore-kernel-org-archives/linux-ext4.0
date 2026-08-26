Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4861122423A;
	Wed, 26 Aug 2026 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787750494; cv=none; b=hgW0Mor0Ns2AllPZzNCKQziq7/Tkn10oTpACvY6eX2XdwfcA/2EJSI+PTeSNjFbamnn+QeSpdie8Y9cZJ+cdoXdkKY+RZLhfQ6ghlFyyj1S12G6hAVKhGXHP9D4vkHaAVT8xh4MaZ0xu4iHcmfsuhGdEZ9kvWhPB3E5NZSpWhxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787750494; c=relaxed/simple;
	bh=w9gjMzfzXESoZDc+O5MLNBX7rWTXEetHFla3VTul7oA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocod95fCLZji/hxrtbUkLfhN7E40fcKe4BzdV33GhUsYr4q4lZ9oHPCRmhQ/up+o+1lHJDOanHT9rzue83BLSS9IxycolS2xZeiKe+WWGnMEm7mvE4P5EwhMEKHZ3sK7RU9DBejx+IRywguI956+5qjRm3ab2x+S4TfMEqDtGkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j5L5G/Dm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=L/7hwvG4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J2QUpWCq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yNOnDIGh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j5L5G/Dm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="L/7hwvG4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J2QUpWCq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yNOnDIGh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7153A1F824;
	Wed, 26 Aug 2026 13:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787750444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NtOMcAkC/wFiCmb+t5R+SPLSf2pQDgdcS3a/21hM1rA=;
	b=j5L5G/DmhARQar/MO5dwxZVNiUBZHATRSUupUk/9AjgzovCSIwN2TrblMEd9uEZdz3hXQO
	K87geSXYoWwTfivlU9CO4ikRD3cf2pjPvpXIhIhHxajKyf4xmoeIwA658Ou5/4zDuqhgWD
	ENu++hkohnlhEJuisnDnAKYDq89MGzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787750444;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NtOMcAkC/wFiCmb+t5R+SPLSf2pQDgdcS3a/21hM1rA=;
	b=L/7hwvG4hA5KQZr0VhyyV3sDgomaWgPSaw8uXoF2v8g4VmaXq/gtPp4brIonaJFfDsq7xw
	aL4RPvW1clO4ccBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J2QUpWCq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yNOnDIGh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787750440; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NtOMcAkC/wFiCmb+t5R+SPLSf2pQDgdcS3a/21hM1rA=;
	b=J2QUpWCqmIasVjcoidhRXinY1NSAiX2qjHgRgK3VvJ+HsbYIYlrsmaufcXiDV80GllTejv
	wTy5IGrX6wgVoFSPACaaKnuG1jiYDyQQStTuFm6EtfikrpMMs8DfOj8SkmObSemEmxag0x
	/UhknyYYcWrH1E9z772fFPA1jRY3y3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787750440;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NtOMcAkC/wFiCmb+t5R+SPLSf2pQDgdcS3a/21hM1rA=;
	b=yNOnDIGhEOBQTGoq0oHTFIEYxki18FDg8E31x6oiWJkeaLtj0kxxd3OKI3NvAj7MzWtWoy
	hnpwfdZol/lI1cDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66B3613533;
	Wed, 26 Aug 2026 13:20:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id itsNGSjojmqxXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 13:20:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F369EA13A7; Wed, 26 Aug 2026 15:20:31 +0200 (CEST)
Date: Wed, 26 Aug 2026 15:20:31 +0200
From: Jan Kara <jack@suse.cz>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, jun.nie@linaro.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+4b03894b6ec5753ddf24@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: skip extra isize expansion while unmounting
Message-ID: <vwmniaakkojdwzcrk44itvpsipystvdbdgbolk63cmmh6qmjk4@fb3wrihl6y4l>
References: <20260824094512.2436628-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824094512.2436628-1-hemanth.selam@gmail.com>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[4b03894b6ec5753ddf24];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,linaro.org,vger.kernel.org,syzkaller.appspotmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 7153A1F824
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Mon 24-08-26 15:15:12, Hemanth Selam wrote:
> syzbot reports a WARN from ext4_xattr_inode_create() reached through the
> unmount path:
> 
>   EXT4-fs warning (device loop0): ext4_xattr_inode_create:1485: refuse to
>   create EA inode when umounting
>   WARNING: fs/ext4/xattr.c:1486 at ext4_xattr_inode_lookup_create
>    ext4_xattr_block_set
>    ext4_expand_extra_isize_ea
>    __ext4_expand_extra_isize
>    __ext4_mark_inode_dirty
>    ext4_dirty_inode
>    __mark_inode_dirty
>    sync_lazytime
>    iput
>    dentry_kill
>    shrink_dentry_list
>    shrink_dcache_for_umount
>    generic_shutdown_super
>    kill_block_super
>    ext4_kill_sb
> 
> shrink_dcache_for_umount() clears s_root before generic_shutdown_super()
> clears SB_ACTIVE, so during the dcache shrink the last iput() of a
> lazytime inode still redirties it and reaches the isize expansion.  The
> expansion can move xattrs out to a block, and creating the EA inode for
> them needs s_root, which ext4_xattr_inode_create() refuses without.
> 
> ext4_try_to_expand_extra_isize() already declines to expand when the
> superblock is not active, but that test does not cover this window.
> Decline while s_root is gone as well.  The expansion is best effort and
> __ext4_mark_inode_dirty() ignores its return value, so nothing else
> changes; the inode can be expanded on a later mount.
> 
> Running the syzbot reproducer for 60 seconds produced 3583 splats before
> this change and none after it, with the same number of mount cycles.
> 
> Reported-by: syzbot+4b03894b6ec5753ddf24@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4b03894b6ec5753ddf24
> Fixes: f31173c19901 ("ext4: refuse to create ea block when umounted")
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bd4b778df9eb..6e523a5c8230 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6598,8 +6598,14 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
>  	 * When !SB_ACTIVE, iput triggers write_inode_now() which acquires
>  	 * s_writepages_rwsem, causing a deadlock with the caller's active
>  	 * jbd2 handle (lock order: s_writepages_rwsem -> jbd2_handle).
> +	 *
> +	 * Skip it while unmounting as well.  shrink_dcache_for_umount()
> +	 * clears s_root before generic_shutdown_super() clears SB_ACTIVE, and
> +	 * the last iput() of a lazytime inode in that window redirties it and
> +	 * lands here.  Moving xattrs out to a block then needs a new EA inode,
> +	 * which ext4_xattr_inode_create() refuses without s_root.
>  	 */
> -	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE)))
> +	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE) || !inode->i_sb->s_root))
>  		return -EBUSY;
>  
>  	/*
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
