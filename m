Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125463F12C5
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783525377; cv=none; b=mNNYKKgNTfVA0n7iB9Sp4BggfVhhQzRE1cO2v0BkvKxYqqt8SOGPeuU9aTz3kmuWEsRVca1Zufk4GptgMsajZGrbk6rkWddCvZD0aBJXZelUUuQlQE9mUZ4vRGZ1SnwFdGoj7QQHbmyQTMrASkdkTa8Ol4DqIGtL9pYcvz0W7bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783525377; c=relaxed/simple;
	bh=DY5GW2q2uGqEgN9lC0IhzkOQSrAEyJas1t4ul7/stO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3ruchryo0ppUtVQF5aFINcDzVroea5OuuPqN2y58gHxEAtyMJcGxUWG+hkYqKOFnI92P2pnKrs+C+UrX0PIy06GlwtChXQnuXXDQy0NEOhzJCv4vgHqdxD2U0R3gQIy/qiSEO4L7yGE/Ya2ZJDxrUlg03hpu3qVBN0hPpjDFqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z5gFNlUZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uZxHjsXP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z5gFNlUZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uZxHjsXP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z5gFNlUZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uZxHjsXP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z5gFNlUZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uZxHjsXP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4401B75EC6;
	Wed,  8 Jul 2026 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783525374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NJLwUaAIVAcptqIka4KK8J+8JYL2SJ6cpLBYS6arEbo=;
	b=z5gFNlUZAXVCf+nLrI1PVgBTqsgh2c/ccc//K0pVHtleRsDDMzfKp0EZAiOyKaNGHQXaVn
	LqHTGRK+4qM/QdLtQEO/uB7Rxf6afNRfxxuTIkSZpPoHxtekfbpEN+qNfvYK/LK0fYb2+m
	xsA48YRzGh0UK6PFsi1Vz3UAIE5rFuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783525374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NJLwUaAIVAcptqIka4KK8J+8JYL2SJ6cpLBYS6arEbo=;
	b=uZxHjsXPwqOKHDlipdYdaKJru+VwXXmprNMAhFdXbDQgvMqw2kc96qkpnwGR1PLG5nSqJO
	ooKixU0eAVpYoSDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z5gFNlUZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uZxHjsXP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783525374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NJLwUaAIVAcptqIka4KK8J+8JYL2SJ6cpLBYS6arEbo=;
	b=z5gFNlUZAXVCf+nLrI1PVgBTqsgh2c/ccc//K0pVHtleRsDDMzfKp0EZAiOyKaNGHQXaVn
	LqHTGRK+4qM/QdLtQEO/uB7Rxf6afNRfxxuTIkSZpPoHxtekfbpEN+qNfvYK/LK0fYb2+m
	xsA48YRzGh0UK6PFsi1Vz3UAIE5rFuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783525374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NJLwUaAIVAcptqIka4KK8J+8JYL2SJ6cpLBYS6arEbo=;
	b=uZxHjsXPwqOKHDlipdYdaKJru+VwXXmprNMAhFdXbDQgvMqw2kc96qkpnwGR1PLG5nSqJO
	ooKixU0eAVpYoSDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39814779AE;
	Wed,  8 Jul 2026 15:42:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5l8GDv5vTmqcSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 08 Jul 2026 15:42:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C12E4A12D6; Wed, 08 Jul 2026 17:42:49 +0200 (CEST)
Date: Wed, 8 Jul 2026 17:42:49 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huaweicloud.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 6/6] ext4: protect WRITE_ZEROES written extents with
 orphan list
Message-ID: <j67fqc5rlwtu2pdfcn6ufv4jdoindgrvc5j7uyhyxalqcvo6gw@ihflfbhxduqo>
References: <20260707021338.1182268-1-yi.zhang@huawei.com>
 <20260707021338.1182268-7-yi.zhang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707021338.1182268-7-yi.zhang@huawei.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huaweicloud.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4401B75EC6
X-Spam-Score: -2.51

On Tue 07-07-26 10:13:38, Zhang Yi wrote:
> In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
> extents to written in one transaction while i_disksize is updated to
> cover them only in a later transaction. A crash in between leaves
> written extents beyond i_disksize on disk, which fsck will complain
> about this.
> 
> Add the inode to the orphan list in the same handle that does the
> conversion, and remove it once i_disksize has caught up. Fold
> ext4_convert_unwritten_extents() into the same handle so the orphan
> add and the conversion are atomic. Also add a check before conversion
> to ensure the conversion does not extend beyond the end of the file.
> 
> Reported-by: Jan Kara <jack@suse.cz>
> Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c083703bf704..8c7a98405a64 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4585,6 +4585,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	loff_t epos = 0, old_size = i_size_read(inode);
>  	unsigned int blkbits = inode->i_blkbits;
>  	bool alloc_zero = false;
> +	bool orphan = false;
>  
>  	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
>  	map.m_lblk = offset >> blkbits;
> @@ -4659,12 +4660,30 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  
>  		if (alloc_zero &&
>  		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
> +			WARN_ON_ONCE(map.m_lblk + map.m_len >
> +				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
> +
>  			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
>  						 map.m_len);
> -			if (likely(!ret))
> -				ret = ext4_convert_unwritten_extents(NULL,
> +			if (unlikely(ret))
> +				break;
> +
> +			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> +						    credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				break;
> +			}
> +
> +			ret = ext4_convert_unwritten_extents(handle,
>  					inode, (loff_t)map.m_lblk << blkbits,
>  					(loff_t)map.m_len << blkbits);
> +			if (!ret && new_size) {
> +				ret = ext4_orphan_add(handle, inode);
> +				orphan = true;
> +			}
> +			ret2 = ext4_journal_stop(handle);
> +			ret = ret ? ret : ret2;
>  			if (ret)
>  				break;
>  		}
> @@ -4687,12 +4706,17 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	if (epos > new_size)
>  		epos = new_size;
>  
> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> -	if (IS_ERR(handle))
> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
> +	if (IS_ERR(handle)) {
> +		if (orphan && inode->i_nlink)
> +			ext4_orphan_del(NULL, inode);
>  		return ret ? ret : PTR_ERR(handle);
> +	}
>  
>  	ext4_update_inode_size(inode, epos);
>  	ret2 = ext4_mark_inode_dirty(handle, inode);
> +	if (orphan && inode->i_nlink)
> +		ext4_orphan_del(handle, inode);
>  	ext4_update_inode_fsync_trans(handle, inode, 1);
>  	ret3 = ext4_journal_stop(handle);
>  	ret2 = ret3 ? ret3 : ret2;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
