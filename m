Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593287;
	b=DvEM6LjmDWslxYXpsTAR9GhUCjrCG1YaxiJljDtq+77Oj1YIdcfcIKWhibVdLDJITaYS
	 9AFiRaU4Zu9FlF2hcMsxMgeVAbuPGUMFc1KJ5Ubvnc3eYWDNC6WQgymLrzViluGqGX9h9
	 g7QjN4CRHUzxUTr+pAjIoVdHUgkl7rOdaW7b5iqxCifHeOpankOsRZ/eejjoqL+Ya7eD/
	 rRwz5O/iyOSkrGykYePP4Mh+srokHqVdXKeS9g8OefhGE4uXfvQqFpzVfd+fnzhrqu6Zo
	 5oU2SfVOxxPsB4AmeTlKZ0f9GJ7eP4Y0DTBF1FV7kgVRBXEHzV6oSb+IQIr6n3yW0yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593287;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=oCBjsoM9kIOE6pef1zqfe0EBrdEWeOCHl5vjMEL4QJY=;
	b=h+UL27ly4CcbC9Jx12kOJ2RCkHdN0MZFW3/0dmz7bQx8UgGdoNxPbma+mhcsjGcDWd9d
	 BasBMwZVNQ+IrzfMZojTAkP1vF21SpeOEOy8jWLOPDhAxkiJLR8lJFls9g97UzTlRMY9y
	 x9ubupopPGMR4dwRX7wRgvG6xnA4a/H9tpd5KbxJBgWL2S8jFDcQXwT4Br50XK7fw3xkP
	 RidXvXxnySX4cWw+K6f1reLGMDPuUQ2MM5eGNSOu9J7j4kNBPqE7PjiET8bRwt6SZaCdY
	 Vb6NtKrM+1R7WlNYpI5gv+BBPwSEsl1JPuiB2gj0mABYAN+TFgJafMa9HdD69+oQl6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FkJd6ztu;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DbOnccyV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FkJd6ztu;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DbOnccyV;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848ED606A31A;
	Wed, 21 Oct 2026 14:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 848ED606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FkJd6ztu;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DbOnccyV;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FkJd6ztu;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DbOnccyV
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B835722018;
	Wed, 21 Oct 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792593279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oCBjsoM9kIOE6pef1zqfe0EBrdEWeOCHl5vjMEL4QJY=;
	b=FkJd6ztuY4yP02LQgQfu36xCl8t+i0GfH2vx/sDtJ9qSZVGW/AJh6cDaKFAhykAPXh6JU9
	zevFB7JYRT6LAaRZD+qK/VEKIZskhrDmcNEyCUaq3mQo/gR6f6p1dvFVIGEUmsNDb2GqW4
	mjoBXBPt4BxJgYL8MJsnXPwhvAR9xes=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792593279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oCBjsoM9kIOE6pef1zqfe0EBrdEWeOCHl5vjMEL4QJY=;
	b=DbOnccyVeHbLZFo/oNazeJaUbZMCHUBjbCSLnjdJxfS8NeFb4XLDrMRPG1biSEnzIhB9R+
	xcKbXSIXS/S+tVBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792593279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oCBjsoM9kIOE6pef1zqfe0EBrdEWeOCHl5vjMEL4QJY=;
	b=FkJd6ztuY4yP02LQgQfu36xCl8t+i0GfH2vx/sDtJ9qSZVGW/AJh6cDaKFAhykAPXh6JU9
	zevFB7JYRT6LAaRZD+qK/VEKIZskhrDmcNEyCUaq3mQo/gR6f6p1dvFVIGEUmsNDb2GqW4
	mjoBXBPt4BxJgYL8MJsnXPwhvAR9xes=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792593279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oCBjsoM9kIOE6pef1zqfe0EBrdEWeOCHl5vjMEL4QJY=;
	b=DbOnccyVeHbLZFo/oNazeJaUbZMCHUBjbCSLnjdJxfS8NeFb4XLDrMRPG1biSEnzIhB9R+
	xcKbXSIXS/S+tVBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6703B13521;
	Wed, 21 Oct 2026 14:34:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YQSeEn/N2GoOWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 21 Oct 2026 14:34:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CCB5CA13D6; Wed, 21 Oct 2026 12:26:21 +0200 (CEST)
Date: Wed, 21 Oct 2026 12:26:21 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, enwlinux@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com, 
	chengzhihao1@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH] ext4: fix extent status cache clearing when truncating
 inline data
Message-ID: <ybunlyqq4f6meguylf56ebcxjewypnpjdrtkxhgwczjxvzazyy@5khsm6qqzi55>
References: <20261014021714.2382353-1-yi.zhang@huaweicloud.com>
 <sohkizuoexeuwreaxw463pyktxbrafyvtscklv5qyanhaehn4d@sx2bgp2s6e4u>
 <ab472a6d-0435-447e-82de-cf1ac2566797@huaweicloud.com>
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
In-Reply-To: <ab472a6d-0435-447e-82de-cf1ac2566797@huaweicloud.com>
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
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RLy4jt9zmnbk4oncb1qwahh5jo)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,huawei.com:email,appspotmail.com:email,suse.cz:email]
X-Spam-Score: -11.30

On Thu 15-10-26 10:18:22, Zhang Yi wrote:
> On 10/15/2026 12:27 AM, Jan Kara wrote:
> > On Wed 14-10-26 10:17:14, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> ext4_inline_data_truncate() clears the whole extent status tree of the
> >> inode when it truncates the inline data, with
> >>
> >> 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> >>
> >> It does that when the inode still carries inline data while the
> >> EXT4_STATE_MAY_INLINE_DATA state bit is already cleared, which is the
> >> case once an inline to extent conversion has been initiated, for
> >> example a delalloc buffered write larger than the inline space.
> >>
> >> The clear is meant to drop stale extent status entries of such an inode
> >> to prevent stale extents and stale reserved space after the conversion,
> >> but the range is too wide.  It also drops the entries of the blocks
> >> below the new end of file, that is the blocks that stay in the file.
> >>
> >> When writeback of these blocks starts later, the lookup of such a block
> >> misses the extent status tree, falls back to the extent tree and caches
> >> a hole entry for it.  Those blocks then have dirty, mapped and delayed
> >> buffers together with a hole extent status entry.  This is an
> >> unexpected inconsistency.
> >>
> >> This problem has been hidden so far because we allocate blocks and new
> >> extents for them during writeback.  But once [1] is merged during the
> >> iomap conversion, the writeback behavior will be normalized, and it will
> >> no longer allocate blocks for holes, thus exposing this problem.
> > 
> > Hum, I don't understand. So we have inode with inline data. We truncate it
> > (i.e. further reduce i_size). At this point we hold i_rwsem,
> > invalidate_lock, i_data_sem. So how can race with inline data
> > conversion?
> > 
> 
> Hi Jan,
> 
> It is not a race, the state is left behind by an ordinary delalloc
> buffered write that ran before the truncate started.  Please take a look
> at ext4_da_convert_inline_data_to_extent().
> 
> A buffered write into an inline file that does not fit the inline space
> goes there.  It copies the inline data into the page cache, creates
> delayed allocation mappings for it, marks the folio dirty and clears
> EXT4_STATE_MAY_INLINE_DATA.  The non-delalloc variant
> ext4_convert_inline_data_to_extent() destroys the inline data with
> ext4_destroy_inline_data_nolock() right there, but it can do that
> because it allocates the blocks in the same transaction.  The delalloc
> path deliberately keeps the inline data, it is the only copy of the data
> until the blocks are created.  It is destroyed later by
> ext4_do_writepages() during writeback, which calls
> ext4_destroy_inline_data() when the inode still has inline data and it
> is about to create the blocks, see the "we will soon create the block
> for the 1st page, so we'd better clear the inline data here" comment.
> 
> So until that writeback runs, the inode has inline data, the
> EXT4_STATE_MAY_INLINE_DATA bit cleared, and a dirty page whose blocks
> are mapped as delayed allocations in the extent status tree.  A truncate
> that comes later is fully serialized and still sees
> ext4_has_inline_data() true, which is why it enters
> ext4_inline_data_truncate().
> 
> Those delayed allocation entries below the new end of file are what the
> unconditional ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS) drops,
> even though their dirty buffers are still in the page cache.

Right. Makes sense and thanks for explanation! I forgot we have a separate
delalloc inline data conversion handling. The fix looks good. Feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Cheers,
> Yi.
> 
> > 
> >>
> >> Therefore, restrict the range to the blocks that are actually truncated
> >> away, and pass EXT_MAX_BLOCKS minus lblk as the length.
> >>
> >> [1] https://lore.kernel.org/linux-ext4/20261009103033.2920530-9-yi.zhang@huaweicloud.com/
> >>
> >> Reported-by: syzbot ci <syzbot+ci46f64f7b6a2a188e@syzkaller.appspotmail.com>
> >> Closes: https://lore.kernel.org/linux-ext4/6ac92a4c.70ed5d86.2ac85.0072.GAE@google.com/
> >> Fixes: 0add491df4e5 ("ext4: remove extent cache entries when truncating inline data")
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >> ---
> >>  fs/ext4/inline.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> >> index ceee69a66482b..b630e56815bb5 100644
> >> --- a/fs/ext4/inline.c
> >> +++ b/fs/ext4/inline.c
> >> @@ -1905,8 +1905,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
> >>  		 * the extent status cache must be cleared to avoid leaving
> >>  		 * behind stale delayed allocated extent entries
> >>  		 */
> >> -		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> >> -			ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> >> +		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
> >> +			ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, i_size);
> >> +
> >> +			ext4_es_remove_extent(inode, lblk,
> >> +					      EXT_MAX_BLOCKS - lblk);
> >> +		}
> >>  
> >>  		/* Clear the content in the xattr space. */
> >>  		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
> >> -- 
> >> 2.52.0
> >>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
