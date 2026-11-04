Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793813830;
	b=YO+Fv0ZUSZWT/oEr9Mu6+dPz86cJJUeOs/RTPeZ1otWiBDZaqqN+vPAKsDPyjmx1bc3P
	 3DQHCkgpkwncEwDvPfFMUoAikTWXmzdhomPwB/OHImufUkXnfrI1QrtyCAUb6tlPUO7mM
	 cwiVpGP0nJqlLE/lGxtwLp/qMHP6BioaJfWXBwjBxKKT9VHYG4h6roDJlVKMTq9z+Ia7+
	 50KMu37xhYgmTFfvel946OmuQTG1kzDJZ/f5rMpFevGc0mlW5pB/XobSjSzzWKpSb1xRT
	 1ma/v5IsuhQ9c5eTRxnH4RN9HEEwfxpBhBhCXSpAjsjN7s9xWx79VY4lWCVCAATm52A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813830;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=j2LrEMhUN0qSGqiDRYF06jsyACnmwPOUcMnf7oZ+Qik=;
	b=X/xlCXCNfQtD8wUPcZqZMeBdr1nJlcLxIbWgJMA69XwLdaisfliZ1d1x5Eh0zlbaVVKK
	 eaBtAFXfu2JAP8y/Xj4IYqqlmm5A1zH2oH6xRLEa9gnblD4w3K1ChAd1plW+oxREycuC/
	 zB0A8Fe/l+sgNd6NjNKnneZKiYBqbnSwx65MHPyW81aW55QxOxHytgPShqxl3VxEqwvxl
	 aZCxirIWNFsahIaYmrxxCtL6XAAgSYKJGs2cAg1Vh1rRZnsxL72HsK4Hvgd4Ds7rgfMFM
	 4GP2rtjk/NCm7qk9yHNwTLrqf9c/hx094TT6OGzhLdAGucMtt9UsQJsWSE7eedeKo6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OKEnd3j1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=me1iPhyF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OKEnd3j1;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=me1iPhyF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED335606A328;
	Wed,  4 Nov 2026 17:37:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED335606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OKEnd3j1;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=me1iPhyF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OKEnd3j1;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=me1iPhyF
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A2E9021DFD;
	Wed,  4 Nov 2026 17:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793813827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2LrEMhUN0qSGqiDRYF06jsyACnmwPOUcMnf7oZ+Qik=;
	b=OKEnd3j1r0hOztImTIrV0bOxJy3A8jr6x0oBl2ZPkQhzsGZfRG+olgjCmOxgS1jOu4I2/X
	72Md7uROdd/JCOsp1x9T4ZwgSsblDqLZPF1/nPldXGiRbELYl9A7cjVgTzXyeOQm1DDLX9
	IGzOXuCtd0aeX+rM6J8VkXa86B7L9KQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793813827;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2LrEMhUN0qSGqiDRYF06jsyACnmwPOUcMnf7oZ+Qik=;
	b=me1iPhyFrrE8t83SaH4ITwiyhxdL3aL38LllkVxYyR7MaLyE9arZ5X8+b7yngwd1/JP6AE
	XqPUw/JG2s+hfsAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793813827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2LrEMhUN0qSGqiDRYF06jsyACnmwPOUcMnf7oZ+Qik=;
	b=OKEnd3j1r0hOztImTIrV0bOxJy3A8jr6x0oBl2ZPkQhzsGZfRG+olgjCmOxgS1jOu4I2/X
	72Md7uROdd/JCOsp1x9T4ZwgSsblDqLZPF1/nPldXGiRbELYl9A7cjVgTzXyeOQm1DDLX9
	IGzOXuCtd0aeX+rM6J8VkXa86B7L9KQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793813827;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2LrEMhUN0qSGqiDRYF06jsyACnmwPOUcMnf7oZ+Qik=;
	b=me1iPhyFrrE8t83SaH4ITwiyhxdL3aL38LllkVxYyR7MaLyE9arZ5X8+b7yngwd1/JP6AE
	XqPUw/JG2s+hfsAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76C38134A5;
	Wed,  4 Nov 2026 17:37:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +d5IFENt62rFMwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 17:37:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 04F84B459; Wed, 04 Nov 2026 18:37:02 +0100 (CET)
Date: Wed, 4 Nov 2026 18:37:02 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 9/9] fs: don't strand I_METADATA_WRITEBACK inodes
 outside the LRU
Message-ID: <xgy547oy47dzwxygezwnhea2am37yqyvf226jtwaw7nrgwujbo@q3fsxucfkipa>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-9-7d6c678a585d@kernel.org>
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
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-9-7d6c678a585d@kernel.org>
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
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Thu 29-10-26 14:28:24, Christian Brauner wrote:
> Since commit c474bc56b6d1 ("fs: Provide way for filesystem to wait for
> metadata writeback") ext2, ext4 without a journal, fat, udf and minix
> set I_METADATA_WRITEBACK on an inode whose metadata was copied into a
> buffer that might not have reached the disk yet. Only data integrity
> writeback, i.e. fsync() and friends, clears it again. The flusher and
> sync(2) leave it alone. So a clean, unused inode keeps the bit around.
> 
> inode_lru_isolate() treats every state bit other than I_REFERENCED as a
> reason not to reclaim the inode right now. It takes the inode off the
> LRU and relies on iput(), writeback completion or the removal of the
> last page from the page cache to put it back once the reason is gone.
> 
> But I_METADATA_WRITEBACK doesn't go away on its own. Using the inode
> again puts it back on the LRU with the bit still set and the next scan
> takes it off again. So neither memory pressure nor drop_caches can free
> these inodes. Only fsync() and friends or unmounting the filesystem get
> rid of them.
> 
> On ext4 without a journal this is especially bad because
> ext4_mark_iloc_dirty() sets the bit on every ext4_mark_inode_dirty().
> So even an atime update is enough. An unprivileged user creating or
> touching lots of files grows the inode cache without bound until the
> OOM killer comes along.
> 
> The inode can't just be thrown away though. An fsync() after the inode
> was read back in wouldn't know that its metadata still has to be
> written out. But writing it out on eviction is exactly what these
> filesystems already do for the metadata buffers they track in their
> mapping_metadata_bhs.
> 
> ext2, ext4, fat, udf and minix all call mmb_sync() from ->evict_inode()
> and that is what allowed commit 972b9dd4e418 ("fs: Ignore inode metadata
> buffers in inode_lru_isolate()") to take metadata buffers out of
> inode_lru_isolate().
> 
> So let the shrinker reclaim inodes with I_METADATA_WRITEBACK like any
> other clean inode and make evict() call sync_inode_metadata() for them
> unless they are being deleted. With the previous patches
> ->sync_inode_metadata() doesn't read anything from disk anymore. It
> writes and waits for whatever is still dirty or under writeback and
> usually the flusher has long taken care of that by the time an unused
> inode reaches the end of the LRU.

I don't think we want to call sync_inode_metadata() from evict. As you
explain above filesystems that use I_METADATA_WRITEBACK call mmb_sync()
from their ->evict callbacks when needed. If they want to flush something
else, they can do that from ->evict as well. So I don't see a need for the
below hunk in the generic code unless I miss something...

> diff --git a/fs/inode.c b/fs/inode.c
> index 1cb6293b237a..332108961df6 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -818,6 +818,14 @@ static void evict(struct inode *inode)
>  	inode_wait_for_writeback(inode);
>  	spin_unlock(&inode->i_lock);
>  
> +	/*
> +	 * fsync() can't find what I_METADATA_WRITEBACK tracks anymore once the
> +	 * inode is gone, so write it out unless the inode is being deleted.
> +	 */
> +	if (inode->i_nlink &&
> +	    (inode_state_read_once(inode) & I_METADATA_WRITEBACK))
> +		sync_inode_metadata(inode, 1);
> +
>  	if (op->evict_inode) {
>  		op->evict_inode(inode);
>  	} else {

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
