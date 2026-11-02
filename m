Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793656006;
	b=Ia2HHSc/PELppBhFZ9qBMCF7bvhDmrwDjikBz0CGYgG7q5sn9ZmwnCE2ToYdt99LCPRw
	 +si/vV4+ChbVMfOhdckmEeu5b/knLVclv1O8Gv6FKANLzk/03BwQcM8IqjWcTMsLVn4dr
	 3/JRvN0VZJtGOF9CQMyCQL+vsUP+26EBQYpK4SHWJzo1CZcpwH7hTnIW20AXtr4sgYyGM
	 UtKsPk/Wncoj3/eFc3CvUF4P/LD+dgMOfaFJXW5PdjKog1r5P3uhN9gupxfG5peN8y+An
	 Mpdm6nnO0AGtOrfE0vk94A8N/KylmG1GHj3TLgeoMSLl8NbJPoKXui339Bm0bxgq6IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793656006;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=p7exoBfxP0Nugr9Dzupr6d5oKptJza7evlqrd8guaX4=;
	b=hZl2ZvVuGziZ0eOu8JZkT03/931ad4q8CL3N8VALJ0c9IvQc3mcZKG/PIMklAdn6us3/
	 +XzPTIXaMfaCfGq9vtvek8mgVoOvl98w7CtQaevNih1j0g9dg20SJnMMZB3QvDRy8hqyn
	 jVEdUm9JqchQ0EruvIjfeqFdtqoS+Gxn6XNRifK8xjAIQpHwujB5Ezj4aXTYqo40TuzZF
	 wYC35Cst8/zF1MYwjhpMyQrCKfbUu26bcFTGZXhYx2ORrsMoSlouL9oy7DVES9k6dFr3S
	 bTuoR0y+o0ZlN32rktQ3agtInAMKmx49zBU3LonaY4RTXrzGb5MKEEoTVDvIt04lW+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=AEgrXPcr;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cCE01kI0;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=AEgrXPcr;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cCE01kI0;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F689606D806;
	Mon,  2 Nov 2026 21:46:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F689606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=AEgrXPcr;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cCE01kI0;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=AEgrXPcr;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cCE01kI0
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 266BC1FB29;
	Mon,  2 Nov 2026 21:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p7exoBfxP0Nugr9Dzupr6d5oKptJza7evlqrd8guaX4=;
	b=AEgrXPcrAv7qpd8TjeKqOunQowyGBC2qzLsCDOTYVdE6QMUIY84YYWPeu2jtfJCcy6+lcQ
	Afwker6qchqSfNFe1U785Nt6us1DEPnNoQ9XGABkkg8FJDXJjjzCeQGw4FPJqx2LkghYwD
	T61JGG2aGQYXBdeA1kqhrC3BT4nRqsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p7exoBfxP0Nugr9Dzupr6d5oKptJza7evlqrd8guaX4=;
	b=cCE01kI0WK+NAsGCVR7oGGjR2HUvP9dGbSt1FqggPr9YCnVJr4+O++qM0CrGxN3215/+r+
	SP/Nv4r+dN7yX3DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p7exoBfxP0Nugr9Dzupr6d5oKptJza7evlqrd8guaX4=;
	b=AEgrXPcrAv7qpd8TjeKqOunQowyGBC2qzLsCDOTYVdE6QMUIY84YYWPeu2jtfJCcy6+lcQ
	Afwker6qchqSfNFe1U785Nt6us1DEPnNoQ9XGABkkg8FJDXJjjzCeQGw4FPJqx2LkghYwD
	T61JGG2aGQYXBdeA1kqhrC3BT4nRqsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p7exoBfxP0Nugr9Dzupr6d5oKptJza7evlqrd8guaX4=;
	b=cCE01kI0WK+NAsGCVR7oGGjR2HUvP9dGbSt1FqggPr9YCnVJr4+O++qM0CrGxN3215/+r+
	SP/Nv4r+dN7yX3DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04EA3134B3;
	Mon,  2 Nov 2026 21:46:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0OJUNsME6Wp5AQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:46:44 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 91385B169; Mon, 02 Nov 2026 22:46:39 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:39 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 3/4] ext4: add inode to orphan list before extent
 conversion
Message-ID: <mu4r3ufyvy4z4hjnx4zvgwyrbg7ovdpmpxisfz466f245np6tx@h5blsrs7othd>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
 <20261030021338.1768292-4-yi.zhang@huaweicloud.com>
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
In-Reply-To: <20261030021338.1768292-4-yi.zhang@huaweicloud.com>
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
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,huawei.com:email,suse.cz:email]
X-Spam-Score: -11.30

On Fri 30-10-26 10:13:37, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_alloc_file_blocks() zeroes the blocks it has just allocated and
> converts their unwritten extents in a handle started with
> ext4_chunk_trans_blocks(), which reserves credits for a single extent.
> The range is allocated with ext4_map_blocks() first and converted
> afterwards, and only the unwritten extent conversion which runs on I/O
> completion can modify the extent tree of that range in between, since
> this path holds i_rwsem. If such a conversion converts part of the
> range first, it splits the extent, and converting the whole range then
> needs more credits than the handle has reserved.
> 
> Before commit 10660a0ca7ed ("ext4: rework handle credit accounting for
> unwritten extent conversion"), this race condition led to insufficient
> credits, which made the conversion fail with -ENOSPC in the middle of
> the range. After it, ext4_convert_unwritten_extents() can extend or
> restart the transaction. Restarting commits everything modified so
> far, so the extents converted by the first iterations reach the disk
> before this function adds the inode to the orphan list. A crash in
> between leaves written extents beyond i_disksize on disk with the
> inode not on the orphan list, which fsck complains about.
> 
> Add the inode to the orphan list before the conversion instead and keep
> it there until i_disksize has caught up. A restart then commits the
> orphan entry together with the extents converted so far, and the entry
> is only removed by the transaction which raises i_disksize and i_size.
> 
> Fixes: 10660a0ca7ed ("ext4: rework handle credit accounting for unwritten extent conversion")
> Fixes: f7237a775c8f ("ext4: protect WRITE_ZEROES written extents with orphan list")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 47 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ad0d80e33f609..9f80beeaa1f29 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4701,6 +4701,23 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  				break;
>  			}
>  
> +			/*
> +			 * Add the inode to the orphan list before the
> +			 * conversion, as it may restart the transaction and
> +			 * commit the extents converted so far.  Written
> +			 * extents must stay covered by the orphan list until
> +			 * i_disksize catches up.
> +			 */
> +			if (new_size) {
> +				ret2 = ext4_orphan_add(handle, inode);
> +				orphan = true;
> +				if (unlikely(ret2)) {
> +					ret = ret2;
> +					ext4_journal_stop(handle);
> +					break;
> +				}
> +			}
> +
>  			ret = ext4_convert_unwritten_extents(handle,
>  					inode, (loff_t)map.m_lblk << blkbits,
>  					(loff_t)map.m_len << blkbits,
> @@ -4708,23 +4725,21 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  			if (ret)
>  				map.m_len = converted;
>  
> -			/*
> -			 * If blocks beyond i_disksize are converted, add
> -			 * the inode to the orphan list and advance the epos.
> -			 */
> -			if (new_size && converted) {
> -				ret2 = ext4_orphan_add(handle, inode);
> -				ret = ret ? ret : ret2;
> -				orphan = true;
> -			}
> -
>  			ret3 = ext4_journal_stop(handle);
>  			ret = ret ? ret : ret3;
>  		}
>  
> +		/*
> +		 * The conversion may have failed without converting
> +		 * anything. Only move epos over the blocks that were
> +		 * actually converted, so that a failure updates
> +		 * i_disksize just far enough to cover them.
> +		 */
> +		if (map.m_len)
> +			epos = EXT4_LBLK_TO_B(inode, map.m_lblk + map.m_len);
> +
>  		map.m_lblk += map.m_len;
>  		map.m_len = len_lblk = len_lblk - map.m_len;
> -		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
>  		if (ret)
>  			break;
>  	}
> @@ -4732,12 +4747,13 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;
>  
> -	if (!epos || !new_size)
> +	if (!new_size || (!epos && !orphan))
>  		return ret;
>  
>  	/*
> -	 * Allocate blocks, update the file size to match the size of the
> -	 * already successfully allocated blocks.
> +	 * Update the file size to match the size of the already
> +	 * successfully allocated blocks, and release the orphan entry
> +	 * if we added one.
>  	 */
>  	if (epos > new_size)
>  		epos = new_size;
> @@ -4755,7 +4771,8 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  		goto out;
>  	}
>  
> -	ext4_update_inode_size(inode, epos);
> +	if (epos)
> +		ext4_update_inode_size(inode, epos);
>  	if (orphan && inode->i_nlink)
>  		ext4_orphan_del(handle, inode);
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
