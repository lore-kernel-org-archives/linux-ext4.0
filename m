Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DEA30E838
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 10:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693822; cv=none; b=IHRtZ0wjpJ3Hw9egVD2KcmH227U1VrR2p+RU7NdcKg0uEV9G3CKTBbM1P+hOrr/dxnQFyqvIL3impW/e7jSlgfYu3B9+Zs44z9LjS6jL7HK2TJ1ujDSWlci5/Y1j9I/WQPcIapj7lCAmt7l+u57VlmT637Zdelh6u5HWU2hA+XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693822; c=relaxed/simple;
	bh=AgXfTxRZp5SbLOlNKlUE4Yek2MI0HsDJWKzS6PMiap0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXhqeHScjXIJVo0xbeKeS5I9VirbqnC40h2HYu6MVXj56mAuRqlihAykztmQm0X7u3zKpnDPx500Lth3ZpshzgXc6o1wI59BTaCYB/WSMxZwxs4VtIkJQoKyhjx0fys6mRuL9m0KdKow+1GbYLXXLPjeoAyjOJXKdUozOhUNPMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HR3hcS66; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HR3hcS66"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781693820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AzN1lnaE+nfuZ1o7+Sss2Yj7fYHb4+awBZ3lZc9UDnI=;
	b=HR3hcS66mdNPwkBKwuvQMo90O4QB1ZIh91I1DJ2sZc/KcSI/hmRRoQfK81AKenIpVLMDUV
	gigZerz1JGjdUxggJDM89+UshZ7mFDn7kkcJSSpQb/I2chI408Kboml8u34eKiMPn7KqMz
	uZa0T8vhdWTOOK3o6qqMAKo7Lj19WZc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-il43_cpPPSOgnRsnYQNOFg-1; Wed,
 17 Jun 2026 06:56:56 -0400
X-MC-Unique: il43_cpPPSOgnRsnYQNOFg-1
X-Mimecast-MFC-AGG-ID: il43_cpPPSOgnRsnYQNOFg_1781693814
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 627F81955F17;
	Wed, 17 Jun 2026 10:56:53 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.36])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F19A180058C;
	Wed, 17 Jun 2026 10:56:49 +0000 (UTC)
Date: Wed, 17 Jun 2026 06:56:47 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org,
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com,
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 14/23] ext4: implement partial block zero range path
 using iomap
Message-ID: <ajJ9b91fTbM6qApg@bfoster>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Jun 17, 2026 at 04:14:40PM +0800, Zhang Yi wrote:
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
> 
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
> 
> If I understand correctly, the current approach is a compromise, and
> Brian is still working on this. Perhaps ext4 and XFS could work together
> on improvements in the future?
> 

I think that about covers it!

I do agree wrt to the iomap_iter thing in that it doesn't seem like the
most elegant thing. I considered that a bit of a roadblock when first
hacking on the batch stuff, but IIRC somebody pointed out that there was
precedent already so I didn't think too hard about it after that. Indeed
if you poke around, other filesystems use a similar pattern to access
iter->private for whatever private context is carried around.

FWIW, one of the longer term thoughts for the dirty folio stuff was to
eventually lift it out of the callback and just have iomap do it for the
fs. That would eliminate this particular pattern and probably clean
things up a bit, but there were also some other caveats with that that
aren't top of mind atm (IIRC, things like dealing with map trimming,
etc., but I haven't had a chance to think about it in a while).

Also note that this isn't necessarily a hard requirement. It's an
optional optimization. iomap will flush and retry in the dirty
pagecache+unwritten extent case if the fs hasn't otherwised provided
folios to make sure it zeroes properly, it's just that performance of
that may or may not be acceptable for your use case.

Brian

> > 
> >> +	ret = iomap_zero_range(inode, from, length, did_zero,
> >> +			       &ext4_iomap_zero_ops, &ext4_iomap_write_ops,
> >> +			       NULL);
> >> +	if (ret)
> >> +		return ret;
> >> +
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
> 
> Thanks,
> Yi.
> 
> > 
> >> +	if (did_zero && zero_written)
> >> +		*zero_written = *did_zero;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  /*
> >>   * Zeros out a mapping of length 'length' starting from file offset
> >>   * 'from'.  The range to be zero'd must be contained with in one block.
> > 
> > 								Honza
> 

