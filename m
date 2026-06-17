Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462053E8325
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 10:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693427; cv=none; b=MHBEPO1gSV5f4ZSONV/TS/mTt65N1rpuCczPExRvr8b/42EDJOR8hQI+wL1sHxDLzBw8m7ggrv3qXXKtlN7OEm4I5z4NC1fsR1+eC90Np8u33NlNFv+QcKvgCVBj1WVRhZInKSxe7ce8Mph5bjmltVh+CE/SKNU/Cox4CIicURM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693427; c=relaxed/simple;
	bh=g4GeKbQXrSquYYcVH0qBfaUzxK1Kg6mtlPR60FNyncM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bB8V8TekHfCM7c5vbt4rQ1SqMfl8yzL2RM3FtA7B6K6pMvL4C9M87oQ79IE7+C43l7MVIP345ATZgLwabvkuc1N98MFdX8phYG4zxx8Mx/P3KK4rzuTGNmXXp/LttUqcBGIK3RnspBc2pTrzif+tAAUKJvplBW9vhB6lBmubVxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tJa3uSS/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4oe2nMhV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DMPK4LcU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kzViMVrk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tJa3uSS/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4oe2nMhV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DMPK4LcU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kzViMVrk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E358075D13;
	Wed, 17 Jun 2026 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781693418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y+QPHC4mUC72X8JdPYCmhHeaprYa0rEkvdWDsIh/NEs=;
	b=tJa3uSS/TIYx62Hw5gm5OIPagPUwurY1ynJwHQyHLrrN5925O7ErZPE8iAnu0K0ONFxXgs
	U6dYu2Omcm/ZsXBEQknkIsO0xvaNSbGBEj9rEin3ttQveBtkcl0AjthtLE9QLVj1kU7RSL
	UQM3ZTEot0p3D+ZVRWhupBHRvbFHcpk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781693418;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y+QPHC4mUC72X8JdPYCmhHeaprYa0rEkvdWDsIh/NEs=;
	b=4oe2nMhVT7G0ZOrfE/dAxIRQ8xCnIOKMWOXbkL1BMBY5fNI19UjoSlOo50MqdYi47viaol
	Eiovn8oHMmtxaxAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781693417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y+QPHC4mUC72X8JdPYCmhHeaprYa0rEkvdWDsIh/NEs=;
	b=DMPK4LcUHOaAe5KNhxURVXJ4rIUvfMxRFlTFdRHcSPbTnodQ1P5Z9iZ6MJDNbTKJei7dJh
	9QQnRV/SMFSgVBbOlsB24dbConAcdMxBWfOOwvABBMCG2PbY5tsgBppQ2YJijrvKcFxLLL
	A1ydvBh/UNy7uYYUQxL7FFeESfjNmaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781693417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y+QPHC4mUC72X8JdPYCmhHeaprYa0rEkvdWDsIh/NEs=;
	b=kzViMVrk8IxCXLZFubmrcVGKMRnxxuSU5p46c5jnZUtEAUYMjLux098FRM3Wg+wU2F4xf4
	NJpUN5ndJkRsjTBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D5E29779A8;
	Wed, 17 Jun 2026 10:50:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Th8yNOl7MmqXPAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Jun 2026 10:50:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 75798A0EBA; Wed, 17 Jun 2026 12:50:17 +0200 (CEST)
Date: Wed, 17 Jun 2026 12:50:17 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com, 
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v4 14/23] ext4: implement partial block zero range path
 using iomap
Message-ID: <n3bxam2j3iwdo3u6od5esn4pjqrtgxbdzdyemzpufpor4u2lbh@itrun3kmz52e>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-15-yi.zhang@huaweicloud.com>
 <c2q54d6u724xctkzwm6x7sbmg5cpvcackfz3toc47qts6iaj77@ci2czn4fqjik>
 <16cccb83-cdad-4113-8182-e8ea9e3049a2@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16cccb83-cdad-4113-8182-e8ea9e3049a2@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com,redhat.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,huawei.com:email,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Wed 17-06-26 16:14:40, Zhang Yi wrote:
> On 6/16/2026 8:28 PM, Jan Kara wrote:
> > On Mon 11-05-26 15:23:34, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
> >> ext4_iomap_block_zero_range() to implement block zeroing via the iomap
> >> infrastructure for ext4.
> >>
> >> ext4_iomap_block_zero_range() calls iomap_zero_range() with
> >> ext4_iomap_zero_begin() as the callback. The callback locates and zeros
> >> out either a mapped partial block or a dirty, unwritten partial block.
> >>
> >> Important constraints:
> >>
> >> Zeroing out under an active journal handle can cause deadlock, because
> >> the order of acquiring the folio lock and starting a handle is
> >> inconsistent with the iomap writeback path.
> >>
> >> Therefore, ext4_iomap_block_zero_range():
> >> - Must NOT be called under an active handle.
> >> - Cannot rely on data=ordered mode to ensure zeroed data persistence
> >>   before updating i_disksize (for the cases of post-EOF append write,
> >>   post-EOF fallocate, and truncate up). In subsequent patches, we will
> >>   address this by synchronizing commit I/O but doesn't waiting for
> >>   completion, and updating i_disksize to i_size only after the zeroed
> >>   data has been written back.
> >>
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >> ---
> >>  fs/ext4/inode.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 92 insertions(+)
> >>
> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> index c6fe42d012fc..e0dae2501292 100644
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> >> @@ -4101,6 +4101,51 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
> >>  	return 0;
> >>  }
> >>  
> >> +static int ext4_iomap_zero_begin(struct inode *inode,
> >> +		loff_t offset, loff_t length, unsigned int flags,
> >> +		struct iomap *iomap, struct iomap *srcmap)
> >> +{
> >> +	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
> > 
> > This looks like a layering violation to me. I don't think you can safely
> > assume the iomap you're passed is a part of iomap_iter...
> > 
> >> +	struct ext4_map_blocks map;
> >> +	u8 blkbits = inode->i_blkbits;
> >> +	unsigned int iomap_flags = 0;
> >> +	int ret;
> >> +
> >> +	ret = ext4_emergency_state(inode->i_sb);
> >> +	if (unlikely(ret))
> >> +		return ret;
> >> +
> >> +	if (WARN_ON_ONCE(!(flags & IOMAP_ZERO)))
> >> +		return -EINVAL;
> >> +
> >> +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	/*
> >> +	 * Look up dirty folios for unwritten mappings within EOF. Providing
> >> +	 * this bypasses the flush iomap uses to trigger extent conversion
> >> +	 * when unwritten mappings have dirty pagecache in need of zeroing.
> >> +	 */
> >> +	if (map.m_flags & EXT4_MAP_UNWRITTEN) {
> >> +		loff_t start = ((loff_t)map.m_lblk) << blkbits;
> >> +		loff_t end = ((loff_t)map.m_lblk + map.m_len) << blkbits;
> >> +
> >> +		iomap_fill_dirty_folios(iter, &start, end, &iomap_flags);
> >> +		if ((start >> blkbits) < map.m_lblk + map.m_len)
> >> +			map.m_len = (start >> blkbits) - map.m_lblk;
> >> +	}
> > 
> > ... and you need access to iter only for this which seems to be really a
> > hack that's trying to outsmart the iomap code. I have to admit I don't
> > fully understand what you are trying to achieve here. Are you trying to
> > avoid flushing of the range that will be zeroed out?
> 
> This logic is copied from the XFS and iomap infrastructure. Its primary
> purpose is to optimize the zeroing operations on dirty written extents.
> It was introduced by Brian in [1].

Ah, I see. I still find it hacky but apparently it is an established hack
in iomap :). Fair.

> The history as I understand it: originally, the iomap infrastructure
> could not zero dirty unwritten extents during zero range processing,
> which led to stale data exposure. XFS had to flush dirty ranges itself
> before zeroing — a workaround that was not generic.
> 
> In c5c810b94cf ("iomap: fix handling of dirty folios over unwritten
> extents"), Brian added an unconditional flush in the iomap
> infrastructure, ensuring that by the time zeroing runs the extent has
> already been converted to written so the zero can proceed correctly.
> However, this flush was too heavy and introduced noticeable performance
> overhead.
> 
> This was then optimized in 7d9b474ee4cc3 ("iomap: make zero range flush
> conditional on unwritten mappings"), which restricts flushing to only
> dirty pagecache over unwritten or hole mappings.
> 
> Brian later proposed a different approach: rather than relying on flush
> to convert the extent type, find dirty folios ahead of the zero range
> and zero the dirty unwritten extents directly. In [1] he added this
> lookup logic. The filesystem now supplies a folio batch (a collection of
> dirty folios) via the iomap begin callback, and zero range iterates over
> these dirty folios to perform zeroing. Clean regions not covered by the
> batch are simply skipped. This entirely eliminates the need to flush.
> 
> [1] https://lore.kernel.org/linux-xfs/20251003134642.604736-1-bfoster@redhat.com/

Thanks for the summary! So I was confused because somehow I thought this is
about fallocate(FALLOC_FL_ZERO_RANGE) and so I was wondering why we just
cannot evict the page cache and be done with that. Only after reading
everything again I've realized this is about zeroing partial blocks on hole
punch etc. And we may need to really handle multiple folios because XFS
also uses this mechanism to implement FALLOC_FL_ZERO_RANGE for zoned
storage. Ugh. OK, anyway for now this looks like your patch is following
how things are expected to be done so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> >> +	/*
> >> +	 * TODO: The iomap does not distinguish between different types of
> >> +	 * zeroing and always sets zero_written if a zeroing operation is
> >> +	 * performed, which may result in unnecessary order operations.
> >> +	 */
> > 
> > Is this still true after your fix to did_zero handling?
> 
> Yeah. Currently, iomap_zero_range() can only report whether a zeroing
> operation has occurred through did_zero parameter, but it cannot
> distinguish whether the zeroed range is a written extent that already
> exists on disk. That is, even if the zeroing is performed on a delalloc
> extent, did_zero will still return true.

So maybe write in the comment explicitely, that this may result in
unnecessary flushing of folios if zeroing happened in
delayed-not-yet-allocated blocks?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
