Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E322DCBE3
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783094512; cv=none; b=QrRHddautTfhYKOelr4vdElz9sNuOMa1aECVdafZJhw29cTtCQadF7iTm7HuBhFZ18xGtwYYERudarbW384kIc/ClQs4xSBFdIMGmWUK9sAisr8pweffA1MepFup1GEbkvgFtnB39ODJDb1azpi4R2rHcYBzJnqgA9iM0I+a9rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783094512; c=relaxed/simple;
	bh=lZAy+1mQCxgZ2WP1ip4NSSC1IOTLFmC7nds33a1iH58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+SzivYYvuyY1gKy+71s4WdtdorrBhMr2DRwpaYcObrKxtImNG6myD30EUhbkh25TEYeDjmz8BYi3KIxg51tKgWXbAMdvCSgvBDMYit8eDDSex0R5e6SLHNNDkF0AwHCIY8NU/nn61CQGIJ8umZTahq4S0tV15p5+ua0cAN3j10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nM1Rsf7g; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fbnhfHqZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=razEWf/E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z+qp3ZON; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nM1Rsf7g";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fbnhfHqZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="razEWf/E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z+qp3ZON"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6C64175920;
	Fri,  3 Jul 2026 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783094506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=opsaxi/9K05h56FYSgixmTtelpq2oldqVh6zedL5xD4=;
	b=nM1Rsf7gj/KtQO1kIlKkBNWsuieD4W4d+ny4A2zNTAVZpfEC9ze2Hsvb9hyEEY2lb1tL1f
	wBK4H7BKOqJOrOW1QqSMb2YzSm6oAJLvMKmpY04Qww1FaXqIiIQ17PvKv8g7CsAmYn6AJq
	uL8Z93KF9dQvROaYmVjWDVi+1u1/y88=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783094506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=opsaxi/9K05h56FYSgixmTtelpq2oldqVh6zedL5xD4=;
	b=fbnhfHqZ4UicnBy2fIILk/tLJcSUEiCKe+E3MtoibCrilAYDjNIj1arSUYffwOsX4sYut8
	o37cJbJpc5fsf2Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783094502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=opsaxi/9K05h56FYSgixmTtelpq2oldqVh6zedL5xD4=;
	b=razEWf/Eamn18paV7Ua2qK2n/780PSv/M+hZ5OUj7WvRswF0SzKN420B1Lv2tq8zZK87NG
	d0TmgancEg6HkeQgnr97nK8Mj4TLdofa09TlMIV9m4TSzMO8QdPQPHzckwLn6z4gL89oKe
	nfInzPkxNbC1Og81MJnwZv5Xa5EifhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783094502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=opsaxi/9K05h56FYSgixmTtelpq2oldqVh6zedL5xD4=;
	b=z+qp3ZONVjnQEC4nIpTjNm5e7e9BC0PzQlu7AafpBYDB+u0mUYf7jNOdzCU9OU+haBP4VG
	jWH5lMRBmXzLvADQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57771779AA;
	Fri,  3 Jul 2026 16:01:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rEJVFebcR2qVcwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 03 Jul 2026 16:01:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C8FBAA12D4; Fri, 03 Jul 2026 18:01:41 +0200 (CEST)
Date: Fri, 3 Jul 2026 18:01:41 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, Zhang Yi <yizhang089@gmail.com>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com, 
	chengzhihao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 2/6] ext4: clarify return semantics of ext4_load_tail_bh()
Message-ID: <qbrrym4b6tsstu5lqdlxvwp67tvkfp4xufre6v7llan7xgiw3k@qieeaqvt75ns>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-3-yizhang089@gmail.com>
 <qpxvjsdnq6jgigjnwzkxny6lms6gi6t4bq5l33rr2f6m6l4oum@5e6ayymrgcbd>
 <a54c9df2-63e6-41ad-b32f-54d2f0356d5c@gmail.com>
 <5xgyaw3ufsymz7tqoyrkwo64a2uup75hnuaudtrejozhb2qnox@owzep3gkgf2v>
 <89a20f31-39e5-4592-9bc5-d444b6c1c7f4@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89a20f31-39e5-4592-9bc5-d444b6c1c7f4@huaweicloud.com>
X-Spam-Flag: NO
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,gmail.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Fri 03-07-26 11:39:03, Zhang Yi wrote:
> On 7/3/2026 12:43 AM, Jan Kara wrote:
> > On Thu 02-07-26 22:40:17, Zhang Yi wrote:
> >> On 7/2/2026 5:53 PM, Jan Kara wrote:
> >>> On Wed 01-07-26 22:20:05, yizhang089@gmail.com wrote:
> >>>> From: Zhang Yi <yi.zhang@huawei.com>
> >>>>
> >>>> ext4_load_tail_bh() returns NULL for both holes and clean unwritten
> >>>> buffers, but the conditions that lead to this are not obvious from the
> >>>> code alone. Document this behavior to clarify the return value, so that
> >>>> readers do not mistakenly assume that only holes result in a NULL
> >>>> return.
> >>>>
> >>>> Also update the inline comment following the ext4_get_block() call to
> >>>> reflect this: both holes and clean unwritten buffers fall through to the
> >>>> "nothing to do" path.
> >>>>
> >>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >>>> ---
> >>>>   fs/ext4/inode.c | 6 +++++-
> >>>>   1 file changed, 5 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >>>> index c2c2d6ac7f3d..0b31fa873743 100644
> >>>> --- a/fs/ext4/inode.c
> >>>> +++ b/fs/ext4/inode.c
> >>>> @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
> >>>>    * because it might have data in pagecache (eg, if called from ext4_zero_range,
> >>>>    * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
> >>>>    * racing writeback can come later and flush the stale pagecache to disk.
> >>>> + *
> >>>> + * Return the loaded bh if it actually needs zeroing - in written, dirty
> >>>> + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
> >>>> + * a clean unwritten block).
> >>>>    */
> >>>
> >>> Great that you're adding this comment because when I was reading previous
> >>> patch, I've spent like 10 minutes trying to figure that out :). But as far
> >>> as I'm reading the code, ext4_load_tail_bh() will return the unwritten bh
> >>> even if it is clean - map_bh() in _ext4_get_block() will set
> >>> buffer_mapped() even for unwritten extent. What am I missing? BTW, it also
> >>> seems to be ext4_load_tail_bh() could attempt to ext4_read_bh_lock() on
> >>> unwritten bh if things align wrongly...
> >>>
> >>> 								Honza
> >>
> >> Thank you for the review!
> >>
> >> Please note the ext4_update_bh_state(bh, map.m_flags) call in
> >> _ext4_get_block() — it restores the mapped flag back to unwritten. As a
> >> result, the !buffer_mapped(bh) check will evaluate to true for a clean
> >> unwritten block, the function will return NULL.
> > 
> > Argh, right. But ext4_ext_map_blocks() sets both BH_Unwritten and BH_Mapped
> > in the returned map->m_flags for unwritten extents. So I think my comment
> > still applies. 
> 
> Because ext4_get_block() is called with create = 0, this is purely a
> lookup operation. Therefore, in ext4_ext_map_blocks() ->
> ext4_ext_handle_unwritten_extents(), only EXT4_MAP_UNWRITTEN is set,
> and EXT4_MAP_MAPPED is not (please see the branch where
> if (flags & EXT4_GET_BLOCKS_CREATE) == 0)). So at this point, whether
> the lookup is served from the extent status cache or from the on-disk
> query, it works correctly now.

Aah, now I remember. Yes, we have a catch in the mapping code like that.
Thanks for reminding me again. Now back to my original question: So 
ext4_load_tail_bh() returns unwritten bh when it is dirty because someone
must have called ext4_get_block() on it with EXT4_GET_BLOCKS_CREATE and at
that point we set the BH_Mapped flag on it? Subtle... It would be worth to
write this explanation to that comment as well.

> > Plus there's a very strange inconsistency between this and
> > the lookup in extent status tree in ext4_map_blocks() where (as you
> > indicate) we only set BH_Unwritten but *not* BH_Mapped. AFAICT there's
> > something buggy in here :) Note that when we don't set BH_Mapped flag e.g.
> > from ext4_get_block_unwritten() (which gets used when delalloc is disabled),
> > then writes to unwritten extent will get lost because
> > ext4_bio_write_folio() will just treat them as holes...
> 
> In fact, there is no real problem here. For the write path that gets an
> unwritten block, EXT4_GET_BLOCKS_UNWRIT_EXT and
> EXT4_GET_BLOCKS_CREATE are always passed together. This ensures that
> even if we find the unwritten extent in the extent status cache, we
> still call ext4_map_create_blocks() (due to EXT4_GET_BLOCKS_CREATE)
> and go through ext4_ext_handle_unwritten_extents(). Inside that
> function, because the flags contain EXT4_GET_BLOCKS_UNWRIT_EXT,
> EXT4_MAP_MAPPED is set. So for the write path, ext4_bio_write_folio()
> still writes back correctly.
> 
> That said, the semantic inconsistency between the lookup-only and
> allocation paths has been bothering me for a while. I had to be very
> careful about this when developing the buffered I/O iomap path, because
> this semantics also differs from the iomap infrastructure. In iomap, for
> an unwritten extent, IOMAP_UNWRITTEN and IOMAP_MAPPED are not set
> simultaneously; IOMAP_MAPPED always represents a written extent. The
> good news is that this conversion is not complicated.
> 
> I asked an agent to look into the historical reasons, and here is what
> he told me:
> 
>   When ext4 introduced fallocate + delalloc in 2008-2009, it followed
>   the XFS convention that "unwritten is not mapped." However, ext4's
>   writeback path (mpage_da_submit_io) depended on BH_MAPPED to issue
>   I/O, which meant that unwritten buffers would never be written out.
>   Commit bf068ee266f9 was the first fix - it converted unwritten to
>   mapped during the writepages stage. Commit 29fa89d08894 was the
>   second fix - it made unwritten carry mapped at the write-begin stage.
>   Commit 2a8964d63d50 was a revert patch - it cleared the unwritten
>   flag in the create = 1 path to avoid duplicate get_block() calls.
> 
>   Then the extent status cache was introduced in 2013. Commits
>   a25a4e1a5d5d (Zheng Liu, 2013-02) and d100eef2440f (2013) added the
>   ES-cache lookup path. In that path, ext4_es_is_unwritten returns
>   EXT4_MAP_UNWRITTEN without EXT4_MAP_MAPPED - this was not a new
>   design decision, but rather a continuation of the old 2009 convention
>   that "unwritten is not mapped." Zheng Liu's commit message did not
>   discuss whether MAPPED should be set at the same time; it only said
>   "ext4_map_blocks needs to use this flag to determine the extent
>   status." He was simply implementing the ES-cache lookup, and the
>   status semantics followed the old implementation.
> 
>   The comment in ext4_map_blocks() - which says "if blocks have been
>   preallocated ext4_ext_map_blocks() returns with buffer head unmapped"
>   - was inherited from Aneesh's 2009 code. It was not a new decision
>   made in 2013.
> 
> So my understanding is that this inconsistency in ext4_map_blocks() is
> a historical legacy problem. There are many places where handling these
> two flags is also semantically ambiguous. Some may treat those with the
> BH_mapped flag set as written, such as ext4_load_tail_bh(). Therefore,
> setting the mapped flag may cause many issues, and it can only be done
> by setting the unwritten flag when performing a query. If I am wrong
> about any of this, please correct me.
> 
> Going forward, I think we should revisit and clearly redefine the
> semantics of these two flags, and unify the behavior of ext4_get_block().
> Otherwise, carrying this historical baggage will only hinder future
> development. :-)

Yeah, frankly I think it would be good to cleanup. But as you say it is
currently working correctly.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
