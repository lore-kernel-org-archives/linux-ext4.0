Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F6B30C15A
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 16:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010598; cv=none; b=tpfhHKxWm4gpUvfeHtECRqF4uNidnCTr84WBOh0WA+RQBGpBLNpT0ewtfFuHDUHOptIHipF2x1FQxCh8d16pcGZJ/HnuuCr+tS6xvT7CS6TfDHdtyBRyA/Tk65R/YL3gYro4V83Xj5brhXSTLYkmAAFEe8SxvDtuxzyzyZxdxho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010598; c=relaxed/simple;
	bh=JYaeIpzqxeQ6N1LpNnHE2w9sFxJC2Ppx6Tk7l7dK8Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EerqyKei28eeWCrQdmSP6vpYElX2+8WP4YFDeLHU+wRP0Q2drwsGWHmM3NaWqM+Sru+eNXEoI8YudgPCYrRLH+DT/egG17OlwnIY1cPhwr1H6Eic1soeR8kUytxqUW//YMpH9D1EeADnhw2AzTg47k99rpvBMADyVYQ0qKtFysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UbJR0vaf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yXkDxaqz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UbJR0vaf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yXkDxaqz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UbJR0vaf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yXkDxaqz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UbJR0vaf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yXkDxaqz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59BDF727B3;
	Thu,  2 Jul 2026 16:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783010595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVrUtnbzAuo01Kl88y8qu+dkR8XfaDM0W0MTSxnBlIk=;
	b=UbJR0vafkTSmueUnb1eah/rTxaNq+rfXmW7YtSititW8MAvobNxX3cLV1yN+P68zrsLq5H
	xSmaNeA9Egyvwha5eFwTObAgSOVs0oNhrFif1u6slFK9FGsIMqOK74LJuCgPpRzt+9e5A7
	IlXIS1RE5ItmtFUkX9Y8qobBh5GEA78=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783010595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVrUtnbzAuo01Kl88y8qu+dkR8XfaDM0W0MTSxnBlIk=;
	b=yXkDxaqz4gs+u2z/9t/b6cZjFlb+/Dk5lu2mokDFUaGMAhVFePquW+iF0IJLmgmxiC0t/P
	r3WcOaU26cnjW2AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783010595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVrUtnbzAuo01Kl88y8qu+dkR8XfaDM0W0MTSxnBlIk=;
	b=UbJR0vafkTSmueUnb1eah/rTxaNq+rfXmW7YtSititW8MAvobNxX3cLV1yN+P68zrsLq5H
	xSmaNeA9Egyvwha5eFwTObAgSOVs0oNhrFif1u6slFK9FGsIMqOK74LJuCgPpRzt+9e5A7
	IlXIS1RE5ItmtFUkX9Y8qobBh5GEA78=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783010595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sVrUtnbzAuo01Kl88y8qu+dkR8XfaDM0W0MTSxnBlIk=;
	b=yXkDxaqz4gs+u2z/9t/b6cZjFlb+/Dk5lu2mokDFUaGMAhVFePquW+iF0IJLmgmxiC0t/P
	r3WcOaU26cnjW2AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4761E779AA;
	Thu,  2 Jul 2026 16:43:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DNn9ECOVRmpVNwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 16:43:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C37B1A0AE1; Thu, 02 Jul 2026 18:43:14 +0200 (CEST)
Date: Thu, 2 Jul 2026 18:43:14 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, yi.zhang@huawei.com, yi.zhang@huaweicloud.com, 
	chengzhihao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 2/6] ext4: clarify return semantics of ext4_load_tail_bh()
Message-ID: <5xgyaw3ufsymz7tqoyrkwo64a2uup75hnuaudtrejozhb2qnox@owzep3gkgf2v>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-3-yizhang089@gmail.com>
 <qpxvjsdnq6jgigjnwzkxny6lms6gi6t4bq5l33rr2f6m6l4oum@5e6ayymrgcbd>
 <a54c9df2-63e6-41ad-b32f-54d2f0356d5c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a54c9df2-63e6-41ad-b32f-54d2f0356d5c@gmail.com>
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
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 02-07-26 22:40:17, Zhang Yi wrote:
> On 7/2/2026 5:53 PM, Jan Kara wrote:
> > On Wed 01-07-26 22:20:05, yizhang089@gmail.com wrote:
> > > From: Zhang Yi <yi.zhang@huawei.com>
> > > 
> > > ext4_load_tail_bh() returns NULL for both holes and clean unwritten
> > > buffers, but the conditions that lead to this are not obvious from the
> > > code alone. Document this behavior to clarify the return value, so that
> > > readers do not mistakenly assume that only holes result in a NULL
> > > return.
> > > 
> > > Also update the inline comment following the ext4_get_block() call to
> > > reflect this: both holes and clean unwritten buffers fall through to the
> > > "nothing to do" path.
> > > 
> > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > ---
> > >   fs/ext4/inode.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index c2c2d6ac7f3d..0b31fa873743 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
> > >    * because it might have data in pagecache (eg, if called from ext4_zero_range,
> > >    * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
> > >    * racing writeback can come later and flush the stale pagecache to disk.
> > > + *
> > > + * Return the loaded bh if it actually needs zeroing - in written, dirty
> > > + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
> > > + * a clean unwritten block).
> > >    */
> > 
> > Great that you're adding this comment because when I was reading previous
> > patch, I've spent like 10 minutes trying to figure that out :). But as far
> > as I'm reading the code, ext4_load_tail_bh() will return the unwritten bh
> > even if it is clean - map_bh() in _ext4_get_block() will set
> > buffer_mapped() even for unwritten extent. What am I missing? BTW, it also
> > seems to be ext4_load_tail_bh() could attempt to ext4_read_bh_lock() on
> > unwritten bh if things align wrongly...
> > 
> > 								Honza
> 
> Thank you for the review!
> 
> Please note the ext4_update_bh_state(bh, map.m_flags) call in
> _ext4_get_block() — it restores the mapped flag back to unwritten. As a
> result, the !buffer_mapped(bh) check will evaluate to true for a clean
> unwritten block, the function will return NULL.

Argh, right. But ext4_ext_map_blocks() sets both BH_Unwritten and BH_Mapped
in the returned map->m_flags for unwritten extents. So I think my comment
still applies. Plus there's a very strange inconsistency between this and
the lookup in extent status tree in ext4_map_blocks() where (as you
indicate) we only set BH_Unwritten but *not* BH_Mapped. AFAICT there's
something buggy in here :) Note that when we don't set BH_Mapped flag e.g.
from ext4_get_block_unwritten() (which gets used when delalloc is disabled),
then writes to unwritten extent will get lost because
ext4_bio_write_folio() will just treat them as holes...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
