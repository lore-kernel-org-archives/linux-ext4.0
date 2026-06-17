Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B353B8413
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 20:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781728201; cv=none; b=r8QSQ9+Y0+zzBGTEUS+YNh8EDtmuk05eTPHqGf2k+7IQyOY3dOb6nbq9aOoxvv8bDhj7FQ4FOFEdkAf+3GnVO01g4ngFIWDpySfwtyLUfM/wkY9yuM79Y5b/LbnOYh1ueIEabe9//1KGOKA77IKwbneiC5sF47G7gRakFL7eAW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781728201; c=relaxed/simple;
	bh=TB8hBHoh+gFXuOChfxCJAyBFtvE/F4zl0KgDfejnIOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y+IhPjTX9R3mPQCmQ1Y1dgoPVEw8KzdJBQyqa4EvKLlw/eHGn+a87XmMfhgYbYFINl+/j0U678kRzXFyX8fffa7LKVTEXAfQ6gJbDygU9FB0iq/AX2dTytzCREQN8fzoFvITdRTOb7BEn0i0jZS0dEM/IYVSRJp3HyionxXJVTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v3l1MP8z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GDUAroFn; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v3l1MP8z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GDUAroFn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v3l1MP8z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GDUAroFn";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v3l1MP8z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GDUAroFn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A0C4E6C4FA;
	Wed, 17 Jun 2026 20:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781728198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cVLwPYSMuJ2T35z7e3rwWjuIhNJU52n5SpsrcHUKHvU=;
	b=v3l1MP8zZOTEjz+u26QMeoSoCvJ7UOzOO2rBMmLySm5xrvP/Z35aVdg7MfpkOg7xXcpv3o
	+MPqreYEkJpY4QR0A9ilMp2NvPEEEmTE9IEo/nkjk4T8ZESskR1KaFYpewr7OiIzjo2/HP
	MiKJb8sxc309N+a7CpamjNea1F8ylT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781728198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cVLwPYSMuJ2T35z7e3rwWjuIhNJU52n5SpsrcHUKHvU=;
	b=GDUAroFn4YbFvmo0YyWtCNxmLMC8dgULFi9ylDPhgyoKIvU0CKSBw4KPFKIv5B3lCy+RBr
	xyeF4khnxZLzpMDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781728198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cVLwPYSMuJ2T35z7e3rwWjuIhNJU52n5SpsrcHUKHvU=;
	b=v3l1MP8zZOTEjz+u26QMeoSoCvJ7UOzOO2rBMmLySm5xrvP/Z35aVdg7MfpkOg7xXcpv3o
	+MPqreYEkJpY4QR0A9ilMp2NvPEEEmTE9IEo/nkjk4T8ZESskR1KaFYpewr7OiIzjo2/HP
	MiKJb8sxc309N+a7CpamjNea1F8ylT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781728198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cVLwPYSMuJ2T35z7e3rwWjuIhNJU52n5SpsrcHUKHvU=;
	b=GDUAroFn4YbFvmo0YyWtCNxmLMC8dgULFi9ylDPhgyoKIvU0CKSBw4KPFKIv5B3lCy+RBr
	xyeF4khnxZLzpMDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92280779A8;
	Wed, 17 Jun 2026 20:29:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vWymI8YDM2rBBQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Jun 2026 20:29:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 29AC3A0EC0; Wed, 17 Jun 2026 22:29:43 +0200 (CEST)
Date: Wed, 17 Jun 2026 22:29:43 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 06/23] ext4: pass out extent seq counter when mapping
 da blocks
Message-ID: <xt3zkmgktl7wpbwt4de76wh4q576fkmytw6udeojmj4goi6ul6@np4zgi2zinkg>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-7-yi.zhang@huaweicloud.com>
 <ghe4izo4od2b4fcgmiayopkaombyjjopao266sseuqim72t5sj@h2meez5lalsl>
 <58ee3009-8a0e-4657-a473-475ea998316e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58ee3009-8a0e-4657-a473-475ea998316e@gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,huaweicloud.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Tue 16-06-26 20:37:00, Zhang Yi wrote:
> On 6/16/2026 6:04 PM, Jan Kara wrote:
> > On Mon 11-05-26 15:23:26, Zhang Yi wrote:
> > > From: Zhang Yi <yi.zhang@huawei.com>
> > > 
> > > The iomap buffered write path does not hold any locks between querying
> > > inode extent mapping information and performing buffered writes. It
> > > relies on the sequence counter saved in the inode to detect stale
> > > mappings.
> > 
> > Now that I'm looking at it again, I've got a bit confused here. Buffered
> > write path is holding i_rwsem between mapping blocks and using them so
> > there shouldn't be races.  Perhaps you mean buffered *writeback* path? But
> > then ext4_da_map_blocks() should not ever get called in the writeback path
> > because it is allocating delayed blocks... So this change looks unnecessary
> > to me now. Am I missing something?
> > 
> > 								Honza
> > 
> 
> Hi Jan,
> 
> Thanks for coming back to this series. Sorry for the inaccurate
> description in the commit message. However, this change is still needed.
> 
> As mentioned in the comment before the ->iomap_valid() callback in
> iomap_write_begin(), consider the following scenario — a buffered write
> to a dirty unwritten extent, with this concurrent race:
> 
>   Buffer write (holds i_rwsem)    Writeback (no i_rwsem)
>   ext4_da_map_blocks()
>     // ext4_es_lookup_extent()
>     // finds UNWRITTEN extent
>   ext4_set_iomap()
>     // type = IOMAP_UNWRITTEN
>     // validity_cookie = m_seq
>                                   ext4_iomap_writepages()
>                                     // writeback for unwritten extent
>                                     // ext4_convert_unwritten_extents()
>                                     // extent tree: UNWRITTEN → WRITTEN
>                                     // advancing i_es_seq
>   __iomap_write_begin()
>     // ext4_iomap_valid(): cookie != i_es_seq
>     // iomap invalidated, re-maps
>     // gets type = IOMAP_MAPPED (WRITTEN)
>     // iomap_block_needs_zeroing(): FALSE
> 
> Without passing out m_seq, the stale IOMAP_UNWRITTEN type from the iomap
> would cause __iomap_write_begin()->iomap_block_needs_zeroing() to zero
> out blocks that have already been written, corrupting data on partial
> writes.

Ah, right, thanks for explanation. So please update the description to
explicitely mention that iomap doesn't hold folio lock between mapping the
extent and copying data and thus can race with writeback modifying the
extent type. Thanks!

								Honza

> 
> Thanks,
> Yi
> 
> > > 
> > > Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
> > > blocks") added the m_seq field to ext4_map_blocks to pass out extent
> > > sequence numbers, but it missed two callsites within
> > > ext4_da_map_blocks(). These callsites are on the delayed allocation
> > > path, which is also used in the iomap buffered write path. Pass out the
> > > sequence counter to ensure stale mappings can be detected.
> > > 
> > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > ---
> > >   fs/ext4/inode.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 6c4d9137b279..39577a6b65b9 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -1929,7 +1929,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
> > >   	ext4_check_map_extents_env(inode);
> > >   	/* Lookup extent status tree firstly */
> > > -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
> > > +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
> > >   		map->m_len = min_t(unsigned int, map->m_len,
> > >   				   es.es_len - (map->m_lblk - es.es_lblk));
> > > @@ -1982,7 +1982,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
> > >   	 * is held in write mode, before inserting a new da entry in
> > >   	 * the extent status tree.
> > >   	 */
> > > -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
> > > +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
> > >   		map->m_len = min_t(unsigned int, map->m_len,
> > >   				   es.es_len - (map->m_lblk - es.es_lblk));
> > > -- 
> > > 2.52.0
> > > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
