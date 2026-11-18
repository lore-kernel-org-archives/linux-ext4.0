Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003364;
	b=WFWiFS8xha8wWcyuUR0nsC7PhnLcqhkYHhR+ysk2dFbStcdnNOHiVXYQQE66INBtGdGO
	 X2Uv5Qz7RzMYDJACx8fYrcPhyQCqVALijKCQ+CyW5DV8WMZJ/rhRWjHmMZTKpmkxIN4v4
	 sP29jAnGB8MlLg6zCBbKQuXgTDXzgzEJq3I2E/b6H+Btgys4oEXTAfREqkQjc3WYcAUJe
	 t4G7fCry6K8ASNKha0W1zaC/mWB19I3E8WsnpVYcFld8KsqJmlCKVBz1Li7DwBsSMF8Q7
	 5o38eRGKEtTpti9ey3r4tslGrySqxO67DdINucUMWkKpxW+WaMXCs1vhxrUlfE0J0xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003364;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=d/gqrN+T8f/X92LPtrI/NRhzp7WqXSe1x4eYWu588a8=;
	b=txbHRdSUIJQFf5HvQc9c94EBV60Bo4HwfHrp2gg9jyP8S1lMOIoK29Ot+5mhrBcnfKVk
	 K1P7w+BdhE8ptUHHzTtWeQdN2D05ax++Bm2CfiGwlozi/hLRzFvuvVVkkg+4BOqx/7M/z
	 +/MnHFJL2NegTPs56YbtjHe+YJsGs5lZT/9zOq660z2vlNf1Y4k83l+wKagA1I1iEhXpu
	 3HO1DOhEqyMBc2wUwaTjmBZe+72sIGuW/FWOBVCLeZdyXLWaZT9rE/+XbcH27qn6EzqgN
	 hTfvEUIoJ+3rQgUsiUd4aU64Qisp+w8T1H4R0YJcfEM3ouhIl/Aw8c2pxIed1kWP1Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Awu0qdCb;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8PvYtibk;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=YTzCAvja;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ghfpXtsR;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC4A606A32F;
	Wed, 18 Nov 2026 12:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAC4A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Awu0qdCb;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8PvYtibk;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=YTzCAvja;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ghfpXtsR
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D7B661F8CD;
	Wed, 18 Nov 2026 12:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795003361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d/gqrN+T8f/X92LPtrI/NRhzp7WqXSe1x4eYWu588a8=;
	b=Awu0qdCbJfUtrk6IjY1gulHMhK1xcyydaepV8v85dgYYhMmXk0q04itRySukxXCgL1EsZ7
	CNBNqsfMmMKLQZZTn08Mqq2ztbxTkkKcETqxGJRGOUFQO2DMrrlhDGlUYqWyFfbaAL7y0J
	b8grKHtSKoxIjDBPDvToLt3UQazemHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795003361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d/gqrN+T8f/X92LPtrI/NRhzp7WqXSe1x4eYWu588a8=;
	b=8PvYtibkVoHCNjqHAcp0h3cMQ9HbyolDO3HuCbbrSVL8iiEPNBbZcu/Rb7g5mwMh1jYA3T
	Uh9SrXYlhasWQmAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795003359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d/gqrN+T8f/X92LPtrI/NRhzp7WqXSe1x4eYWu588a8=;
	b=YTzCAvjaJ0U2kSsI6gutYXc9Z0odrKI0tin3WohBMFHqBH0E1KVnaI/Q3V403PJmdi5r7x
	4pOkNV9Eqm2/2yhWuGMRIDFqEis1A0RgVpEOtidVI1p3XF4MQLVG6V9fGt0aCa0tZrc6+j
	IT4UUfbRORfO43xl+UjdgsRfCyHY55c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795003359;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d/gqrN+T8f/X92LPtrI/NRhzp7WqXSe1x4eYWu588a8=;
	b=ghfpXtsR2c2N4OAgDYxN6eV15cc/h9ClfXQFJtrilhTD3fnOc1OrcQx2E4Uh0KWubg/rIN
	m1Dgw+L0CYMxEGDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AEED8134E9;
	Wed, 18 Nov 2026 12:02:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sg7LId+T/WpbIwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 12:02:39 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 3D3A525028; Wed, 18 Nov 2026 13:02:39 +0100 (CET)
Date: Wed, 18 Nov 2026 13:02:39 +0100
From: Jan Kara <jack@suse.cz>
To: Alan <3164729207@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, harshadshirwadkar@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: reserve inode write access before unlinking
 entry
Message-ID: <zkqch3frmclz7yjyllhcvehbpnfeofs3zt5ylg6ska7hdkf6th@gvd7pv5zrehv>
References: <tencent_D60E766CE07D3A1847B81DE9BC37B4466908@qq.com>
 <tencent_69B311F4356254E166A5EFDC981AA138D80A@qq.com>
 <otvuclstcoaysrnywzdttapxbxg7hq3p7lp3iexy7u5cuj6plx@waqfsi2dg2p4>
 <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com>
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
In-Reply-To: <tencent_58D8BEFB60308A7011D26F6F7E8C941C2A09@qq.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,inode_iloc.bh:url,qq.com:email,dir_iloc.bh:url,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Tue 17-11-26 11:39:38, Alan wrote:
> __ext4_unlink() removes the directory entry before decrementing the target
> inode's link count. It then dirties the parent inode. If the parent
> inode-table block cannot be read, parent inode dirtying fails after the
> entry has been removed, and unlink returns without dropping the target
> inode's link count. With errors=continue, this read error need not abort
> the journal transaction, so the directory update can be committed without
> the corresponding link-count update.
> 
> Reserve the inode locations and journal write access for the parent and
> target inodes before removing the directory entry. This makes inode-table
> read and access errors fail before the namespace is changed. Keep the
> existing namespace and link-count update order, and release the inode
> location references on every exit path. Fast-commit replay can skip the
> parent update when the directory entry does not match the target inode, so
> reserve only the target inode in that case.
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
> ---
>  fs/ext4/namei.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> v2:
> - Clarify that the committed inconsistency is reproduced by an inode-table
>   READ EIO before journal write access, not by an already-aborted journal.
> - Revalidate the unmodified and fixed paths on current Linux 7.4-rc3 mainline.

Ah, OK, now it makes more sense. Thanks! One nit below:

> @@ -3269,6 +3270,22 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
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
> +	if (!skip_remove_dentry) {
> +		retval = ext4_reserve_inode_write(handle, dir, &dir_iloc);
> +		if (retval)
> +			goto out_handle;
> +	}
> +	retval = ext4_reserve_inode_write(handle, inode, &inode_iloc);
> +	if (retval)
> +		goto out_handle;

Let's first grab inode_iloc and move grabbing of dir_iloc into the
	if (!skip_remove_dentry) {
branch below so that we don't test for it twice.

Otherwise the patch looks good.

								Honza

> +
>  	if (!skip_remove_dentry) {
>  		retval = ext4_delete_entry(handle, dir, de, bh);
>  		if (retval)
> @@ -3293,6 +3310,10 @@ int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
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
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
