Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF5140801E;
	Wed, 14 Oct 2026 20:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792009714; cv=none; b=gqj43SyrMVZ/QTGN89RzQV7vX3lGjwQ/f9HLCT2M9Hi4nkebHpFoizDUZvBum5S+sqr795rD+rfgA5XBEP6z2dREK5nWMKbHKCpnCXd9U6DpyEOsasHoPhMD0Flr/K04kJ0L23qHokDEQfY0N0VikeHpktQcP2WGLWKuAbHO21k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792009714; c=relaxed/simple;
	bh=BX/t+hLJ2S8B/FDiF1rkwxacsGbGLaTfMTrOiqHgBOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nc7jxk9vNozUBjf4zhIr0iEn/XtC8WclJaj5u0bweCEYgJ0P1lZFlC0X0uiree628B3zfwcE2qY1YqDO0huDPS9+97AZYBi9mptP3cmQFyGka7z7qLVaLMm9faOlMPKfZk8xSN9HXfjdheaIwnj+z5r37msaPh7cwChdZCNUHdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bmvQFVZY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=poo+4aJ9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bjWw9OFs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=i8z1qfdc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bmvQFVZY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="poo+4aJ9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bjWw9OFs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="i8z1qfdc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2B6A51F7D2;
	Wed, 14 Oct 2026 20:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792009710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ObnF/RqTluVfm2tHrjFhRxAcjcIGzUcQAyoUyoJgM+g=;
	b=bmvQFVZYHWo1SG2pxXdnfDn9W3jQGzgQFhStHj/8xqrzimBARqr9rECS9xJLmcUgDc+4eg
	FRXzfDTkgvDK3AWC1ewD3YZLpWmTS7OnYcfOuY2512A20MEC0/TFlIE84kK13ZnVON2B1m
	S8CLm99EpyDAMfeISp2Nc649fIol2UI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792009710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ObnF/RqTluVfm2tHrjFhRxAcjcIGzUcQAyoUyoJgM+g=;
	b=poo+4aJ91LWLvPVIgiptl7AgCZpHRJ9kKWNiMDEbIPDurmJU+WksRmXkPVmzhq0IQRimfd
	iwwjanQYW07k/UBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792009709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ObnF/RqTluVfm2tHrjFhRxAcjcIGzUcQAyoUyoJgM+g=;
	b=bjWw9OFsPnbv9yNI1WwAYs0+d6UPWXdUMHw95wWAOO/EGh4f++GwwXCnj+XUZvps2aPjGC
	zgNTlOTKDl9GE+SmRWYN40IXNvWabBDfa6tbl3Kae2eVum0Ctx+GAUWraAUxYFo5zaSB8P
	zNZQlvcR5GnDRQwYV/4ivr0AJO/5mnI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792009709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ObnF/RqTluVfm2tHrjFhRxAcjcIGzUcQAyoUyoJgM+g=;
	b=i8z1qfdcKxO3suHluCNueaVnLofkXZYWMudRnpEUfb1ePqOZq1y0HAUeKtY0xyCxetnsQQ
	jEb0AnhhIbHmfpDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 780461373D;
	Wed, 14 Oct 2026 20:28:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VCXNB+zlz2pHCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 20:28:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 83376A140F; Wed, 14 Oct 2026 18:27:49 +0200 (CEST)
Date: Wed, 14 Oct 2026 18:27:49 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	enwlinux@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com, 
	chengzhihao1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH] ext4: fix extent status cache clearing when truncating
 inline data
Message-ID: <sohkizuoexeuwreaxw463pyktxbrafyvtscklv5qyanhaehn4d@sx2bgp2s6e4u>
References: <20261014021714.2382353-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014021714.2382353-1-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[appspotmail.com:email,huawei.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_TWELVE(0.00)[16];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO

On Wed 14-10-26 10:17:14, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_inline_data_truncate() clears the whole extent status tree of the
> inode when it truncates the inline data, with
> 
> 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> 
> It does that when the inode still carries inline data while the
> EXT4_STATE_MAY_INLINE_DATA state bit is already cleared, which is the
> case once an inline to extent conversion has been initiated, for
> example a delalloc buffered write larger than the inline space.
> 
> The clear is meant to drop stale extent status entries of such an inode
> to prevent stale extents and stale reserved space after the conversion,
> but the range is too wide.  It also drops the entries of the blocks
> below the new end of file, that is the blocks that stay in the file.
> 
> When writeback of these blocks starts later, the lookup of such a block
> misses the extent status tree, falls back to the extent tree and caches
> a hole entry for it.  Those blocks then have dirty, mapped and delayed
> buffers together with a hole extent status entry.  This is an
> unexpected inconsistency.
> 
> This problem has been hidden so far because we allocate blocks and new
> extents for them during writeback.  But once [1] is merged during the
> iomap conversion, the writeback behavior will be normalized, and it will
> no longer allocate blocks for holes, thus exposing this problem.

Hum, I don't understand. So we have inode with inline data. We truncate it
(i.e. further reduce i_size). At this point we hold i_rwsem,
invalidate_lock, i_data_sem. So how can race with inline data
conversion?

								Honza

> 
> Therefore, restrict the range to the blocks that are actually truncated
> away, and pass EXT_MAX_BLOCKS minus lblk as the length.
> 
> [1] https://lore.kernel.org/linux-ext4/20261009103033.2920530-9-yi.zhang@huaweicloud.com/
> 
> Reported-by: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>
> Closes: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com/
> Fixes: 0add491df4e5 ("ext4: remove extent cache entries when truncating inline data")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inline.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482b..b630e56815bb5 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1905,8 +1905,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
>  		 * the extent status cache must be cleared to avoid leaving
>  		 * behind stale delayed allocated extent entries
>  		 */
> -		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> -			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> +		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
> +			ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, i_size);
> +
> +			ext4_es_remove_extent(inode, lblk,
> +					      EXT_MAX_BLOCKS - lblk);
> +		}
>  
>  		/* Clear the content in the xattr space. */
>  		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
