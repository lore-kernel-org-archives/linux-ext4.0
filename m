Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099808;
	b=UvHPYywWKEBsyYchl+g0l+YxGQZ11lnHq2oPkKlmKz/NgUz36ZEsA+YYeTEMOKgL5Tr3
	 E6NqI5VXqP1vO8nw+glOVHr2k0mF3fEPs2PB8GbjgsOHjL1LEapJD0YNFvdx6BR157bpr
	 KBBQQE+qOy1vkT3aVJtNEgOLguIiQEE4UnpTZl5A4s6lbqw32rMFFdh0w9nYj0goz8U1p
	 DttsNCmywECzA3Qr2hy8T2ACNsYESAAFAhBAmUJ5PHlrw/ZfuMAnH6znojoxlZb7WGtiC
	 VExi2dYMl4PCrjJDnjMKTS9+NC8GC3VFo6uPB0dymqKodYd+W+CYY7r1GHqCD7T8zmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099808;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=rUaTDq1j7PMcQDhpTYDDwuc6cosPSO9DACa7N0JQdDk=;
	b=EDLyH6SWJ+EAmy1YAlO2MWN+w5waEfqAyKxUosBEEBylfMcYdMFluFtuz5ssIU2w+pdl
	 QYx+wQTf5KmOZc601KkJWY4JXOf2Gw3cQarLHHthdl5jwMw/z80qwQ+1q5T8iR4k+/SsS
	 EP8V/XObYP2+/lnYjDEvPtVRMg9PlnLidtsg99qM0dI5rD0q6nxS0FTk99CZSXwV1N+Xt
	 U6g5sajXsxMgkZtad8XL994fsIEQo3DYk833hdgXSAyytseBxHO2TKdpQd5SQdA6mAQde
	 DhD3TkBciqKMYBXLsXtIjRptowIIRfhCfabZNYXiDMdvlKjSnthE1rwKxQeorrbEr7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="yIt/dxkL";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6UfShbUy;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vN2gcDYM;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GXLohKnp;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080BE606B066;
	Thu, 19 Nov 2026 14:50:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 080BE606B066
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yIt/dxkL;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6UfShbUy;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vN2gcDYM;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=GXLohKnp
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F132B2213D;
	Thu, 19 Nov 2026 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795099806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rUaTDq1j7PMcQDhpTYDDwuc6cosPSO9DACa7N0JQdDk=;
	b=yIt/dxkLpZjyhLFaYYTrC5G3g729oJnMipED3BAiUgKw24GnLYyhOVoLiXdP8n1O8GlAKX
	cv1Br9eMYnYXy+LRnJ9NFLRpgLk50pGPB/g2h8EnZIrcM5OW05KeGczs6e7DnP60qGHSKq
	+nH7VbbIR1DACdcq5ucAAKKrVIt66ig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795099806;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rUaTDq1j7PMcQDhpTYDDwuc6cosPSO9DACa7N0JQdDk=;
	b=6UfShbUyKex1af/XRtTAfKvhar6RyUhey0mgIfw5rSOv19R3uqIEuQJNaXYESTYVrfV+zN
	/Y2vZrUj0sbeSpAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795099804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rUaTDq1j7PMcQDhpTYDDwuc6cosPSO9DACa7N0JQdDk=;
	b=vN2gcDYMMX2SE1tyGw4hOiYLQdqJ2FQ9iXF712XKYZlP5PKnGdBKxc/8hMN0wOSTU46jDO
	eKnwAwYvvFHHZ9FAknbetrBQWe8LQnIB3+uwfQVpwNsC0JTCpZj020PDanRseL/B7NQr6G
	28jn1EVH0PsrnUbHGTHdjoJmOzGFpRc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795099804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rUaTDq1j7PMcQDhpTYDDwuc6cosPSO9DACa7N0JQdDk=;
	b=GXLohKnp//3mADBwc6dY5Nsl7JMOhrWLUuub+7XTnySc/vpoxkVJdlvOLWDsjKqVD3vJX+
	KSHPT0gzKRYmeYBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBC701342D;
	Thu, 19 Nov 2026 14:50:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WlhYIpwM/2qtHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Nov 2026 14:50:04 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2D1D72524F; Thu, 19 Nov 2026 15:50:04 +0100 (CET)
Date: Thu, 19 Nov 2026 15:50:04 +0100
From: Jan Kara <jack@suse.cz>
To: Alan <3164729207@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, harshadshirwadkar@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] ext4: reserve inode write access before unlinking
 entry
Message-ID: <4ijr75hshznd5svhzr6ubns2xjspvarg5py4ldss3vx5dclhuj@a74bc3rdkpfb>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
 <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com>
 <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com>
 <zkqch3frmclz7yjyllhcvehbpnfeofs3zt5ylg6ska7hdkf6th@gvd7pv5zrehv>
 <tencent_6D3188701BD3C36F588C221C4CD924FB7809@qq.com>
 <tencent_D2DD501AA53948B131F7FD6358E036A4E70A@qq.com>
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
In-Reply-To: <tencent_D2DD501AA53948B131F7FD6358E036A4E70A@qq.com>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[qq.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,qq.com:email,inode_iloc.bh:url,dir_iloc.bh:url,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Wed 18-11-26 23:02:41, Alan wrote:
> __ext4_unlink() removes the directory entry before decrementing the target
> inode's link count. It then dirties the parent inode. If the parent
> inode-table block cannot be read, parent inode dirtying fails after the
> entry has been removed, and unlink returns without dropping the target
> inode's link count. With errors=continue, this read error need not abort
> the journal transaction, so the directory update can be committed without
> the corresponding link-count update.
> 
> Reserve the target inode location and journal write access first. When the
> directory entry is being removed, reserve the parent inode in the existing
> branch before deleting the entry. This makes inode-table read and access
> errors fail before the namespace is changed. Keep the existing namespace
> and link-count update order, and release inode location references on every
> exit path. Fast-commit replay can skip the parent update when the directory
> entry does not match the target inode, so only the target inode is reserved
> in that case.
> 
> The original source-derived injection at the journal write-access boundary
> is not evidence for a committed inconsistency: an error after the journal
> has already aborted cannot establish a committed transaction. The relevant
> failure is an actual inode-table READ EIO before journal write access.
> 
> Tested on Linux 7.4-rc3 (torvalds/linux commit
> aebb7274476403040d582c61478df8f4a7bf9cd3) with QEMU blkdebug and
> errors=continue. On the unpatched kernel, the READ EIO leaves the directory
> entry removed with Links: 1 after normal unmount; the JBD2 trace shows no
> journal abort and records the transaction commit, and e2fsck -fn reports
> an unattached inode. With this patch, the same error is returned before the
> directory entry is removed; the file remains present with Links: 1 and
> e2fsck -fn passes. No-fault controls pass on both kernels. Also built
> fs/ext4/namei.o with W=1.
> 
> Fixes: 4209ae12b122 ("ext4: handle ext4_mark_inode_dirty errors")
> Link: https://lore.kernel.org/linux-ext4/tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Alan <3164729207@qq.com>

Looks ok to me now. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

While thinking about this a bit, I presume the motivation of this patch was
some fuzzer testing + LLM analysis, wasn't it? I think many more
ext4_mark_inode_dirty() calls have the same problem with not-so-good error
recovery when we hit ENOMEM or EIO in them and we definitely don't want to
complicate the code by explicit early bh lookups like you did here. I'll
talk to Ted how we might want to handle these cases in a more robust and
less painful way.

								Honza

> ---
>  fs/ext4/namei.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> v4:
> - Restore the omitted Signed-off-by trailer. No code changes from v3.
> 
> v3:
> - Follow Jan Kara's suggestion: reserve the target inode first and move
>   the parent-inode reservation into the existing !skip_remove_dentry
>   branch.
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 354fc2d22df1aa..27fe5e82d6e12b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3233,6 +3233,7 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
>  	int retval = -ENOENT;
>  	struct buffer_head *bh;
>  	struct ext4_dir_entry_2 *de = NULL;
> +	struct ext4_iloc dir_iloc, inode_iloc;
>  	handle_t *handle;
>  	int skip_remove_dentry = 0;
>  
> @@ -3269,7 +3270,21 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
>  	if (IS_DIRSYNC(dir))
>  		ext4_handle_sync(handle);
>  
> +	/*
> +	 * Read the inode-table blocks and get journal write access before
> +	 * removing the directory entry. Otherwise, a read error while updating
> +	 * either inode can leave the name removed but the link count unchanged.
> +	 */
> +	dir_iloc.bh = NULL;
> +	inode_iloc.bh = NULL;
> +	retval = ext4_reserve_inode_write(handle, inode, &inode_iloc);
> +	if (retval)
> +		goto out_handle;
> +
>  	if (!skip_remove_dentry) {
> +		retval = ext4_reserve_inode_write(handle, dir, &dir_iloc);
> +		if (retval)
> +			goto out_handle;
>  		retval = ext4_delete_entry(handle, dir, de, bh);
>  		if (retval)
>  			goto out_handle;
> @@ -3293,6 +3308,10 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
>  	if (dentry && !retval)
>  		ext4_fc_track_unlink(handle, dentry);
>  out_handle:
> +	if (dir_iloc.bh)
> +		brelse(dir_iloc.bh);
> +	if (inode_iloc.bh)
> +		brelse(inode_iloc.bh);
>  	ext4_journal_stop(handle);
>  out_bh:
>  	brelse(bh);
> 
> base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
