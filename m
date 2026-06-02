Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADAA33C53D;
	Tue,  2 Jun 2026 07:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780383784; cv=none; b=nkstsfWysP1W3SfZ5NQSjYWsStAHJyKhJJBWxw++3ydf7wm7/fj0nquB37oCzaqy2JcAcwlAUUDQ2kcpXjI7jeDcdbVkt7852dkhe2AzQoH1JaiL7TcUwLnuQV5tINfkN//qejT/eDRlGccsyO+5f+J1Y9R2F3gDNFnimaimVkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780383784; c=relaxed/simple;
	bh=0UP4vNIvhwPioCve7F9Vgerm5H0RGB/akZiww01j7J4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ub0N47zZPmCIWxXlU5euQq7FVfYQm4cDeo1NusM2TRQbapCJ8Er9GTXq5FBsvBYQu3nW+CWqpgnqyowxbf4dzOV3RcnJ7Peiv/lFeul+hO3Yj7Ec0nuAtes1OJz7KoeaZDL1/iuC03+t+oJLp5SpY5vY68Q+S23ZQ6gbJiqbqOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eiLozlQb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eiLozlQb"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65271hRe2298475;
	Tue, 2 Jun 2026 07:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=5O28XWwUfeeKF697HRvxTG8ZiVm9Ok
	riUXAfhLrkcUY=; b=eiLozlQbrwYiI/bIvf60VDrgcwHFokMKTPEvDcNy/sdMYm
	4ia2ZK0E1cZQitOqwk8cyN8OfYprOtZ3yAw8mOEEXpJUQ2vdKjmqC+PBTk/6QQ/a
	wqSfEc9jqKnFiDj098QlBDT/E7tcQLwVkjOOZbIge4z/sfoagcXPgbYabZM3elKB
	ild8RuiC59skNHL8QT523i+qBoeMy9masnIGljnGWFVCWU6mQvDwAlVksKIF/aAg
	sBl1URGeHyzzbO6gfWepMugdrcpxGTGW91UPDOdLZEsf/McE+mLHnctxmtQQ1bja
	7NU2LlDyB8QhvEOvLL6t1JN3gBPG2MKELZ9Jro4Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efnahmfb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 07:02:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6526s8RW013816;
	Tue, 2 Jun 2026 07:02:17 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ega7qa7my-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 07:02:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65272Ghx50135338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jun 2026 07:02:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15EBF2004B;
	Tue,  2 Jun 2026 07:02:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF41E20043;
	Tue,  2 Jun 2026 07:02:11 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  2 Jun 2026 07:02:11 +0000 (GMT)
Date: Tue, 2 Jun 2026 12:32:09 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ritesh.list@gmail.com, hch@infradead.org,
        yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
        yukuai@fnnas.com
Subject: Re: [PATCH v4 08/23] ext4: implement buffered write path using iomap
Message-ID: <ah5_8cKrcmlH5iqD@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-9-yi.zhang@huaweicloud.com>
 <ahXUBgoivo5CFl39@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20260528154059.GA6054@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528154059.GA6054@frogsfrogsfrogs>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDA1OSBTYWx0ZWRfX1x6vRtH20Rqt
 gcjYnCE9RbHWxfvIARUakU239lcHlgkOKaqlUALb37YNEuFWeWPUxc0alkLlkxyjICEC4p1RFVw
 rOApNSnqNaMCMFLSFWUkk6l7x9OeQ0Lql5PbPoHFHyf7S6jlQo8td+WQN3sJnBJ+18AVmbnLclT
 o9EuDsq6NOwXNf4XSFpznJRXT82C44BdKvoQ13xzXWkRbY7XIdA6TAAG1Y/Spw7fDWTHijhePrk
 KRpNSeASf/pzsOd2zqCc4elTXOtTHHuQbAUs5iBncG69okrnZ/u8vwiY3Xgoa52P+SisrZJxBm0
 UrpUsGhbirZ8RKZIaHHlYJbUPS4E422Jvgf7MXAZUwoen0i68h3onm9ciWvxZ6K0HFkGmxJofvw
 EW8zshAYv6x/0m9j+SGyEIFAhuizlVrnwi70SJSbB5N3ujoobjMYAn8WBs37VW0m9xCGxZdDQEX
 g8XBLihxjYjz2VUYS/w==
X-Proofpoint-ORIG-GUID: gOEhUydlEU9SbKjnz-7XE06MZLAURsVt
X-Authority-Analysis: v=2.4 cv=cOzQdFeN c=1 sm=1 tr=0 ts=6a1e7ffb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=tHC8vgOVimyrgkhrAJkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: GEO_67ztir2c4Mn-z_fMtiRpLM0hZIEk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606020059

On Thu, May 28, 2026 at 08:40:59AM -0700, Darrick J. Wong wrote:
> On Tue, May 26, 2026 at 10:40:30PM +0530, Ojaswin Mujoo wrote:
> > On Mon, May 11, 2026 at 03:23:28PM +0800, Zhang Yi wrote:
> > > From: Zhang Yi <yi.zhang@huawei.com>
> > > 
> > > Introduce two new iomap_ops instances for ext4 buffered writes:
> > > 
> > >  - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
> > >    ext4_da_map_blocks() to map delalloc extents.
> > >  - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
> > >    ext4_iomap_get_blocks() to directly allocate blocks.
> > > 
> > > Also add ext4_iomap_valid() for the iomap infrastructure to check extent
> > > validity.
> > > 
> > > Key changes and considerations:
> > > 
> > >  - Unwritten extents for new blocks (dioread_nolock always on)
> > >    Since data=ordered mode is not used to prevent stale data exposure in
> > >    the non-delayed allocation path, new blocks are always allocated as
> > >    unwritten extents.
> > 
> > Okay makes sense.
> > 
> > > 
> > >  - Short write and write failure handling
> > >    a. Delalloc path: On short write or failure, the stale delalloc range
> > >       must be dropped and its space reservation released. Otherwise, a
> > >       clean folio may cover leftover delalloc extents, causing
> > >       inaccurate space reservation accounting.
> > 
> > Hmm, okay so in the usual buffer head path, seems like during a short
> > write we still zero the new buffers we couldn't write and keep it dirty
> > (folio_zero_new_buffers()). This way they are still written back and
> > the delalloc reservations are used up.
> > 
> > However in iomap we don't mark the range that we couldnt write as dirty
> > so we need to make sure we clear up the stale delalloc mappings. Is this
> > correct?
> 
> Yes, that's true of iomap's pagecache handling.

Thanks for confirming Darrick.

Regards,
Ojaswin

> 
> --D
> 
> > Regards,
> > Ojaswin
> > 
> > >    b. Non-delalloc path: No cleanup of allocated blocks is needed on
> > >       short write.
> > > 
> > >  - Lock ordering reversal
> > >    The folio lock and transaction start ordering is reversed compared to
> > >    the buffer_head buffered write path. To handle this, the journal
> > >    handle must be stopped in iomap_begin() callbacks. The lock ordering
> > >    documentation in super.c has been updated accordingly.
> > > 
> > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > ---
> > >  fs/ext4/ext4.h  |   4 ++
> > >  fs/ext4/file.c  |  20 +++++-
> > >  fs/ext4/inode.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++-
> > >  fs/ext4/super.c |  10 ++-
> > >  4 files changed, 192 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index 1e27d73d7427..4832e7f7db82 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -3057,6 +3057,7 @@ int ext4_walk_page_buffers(handle_t *handle,
> > >  int do_journal_get_write_access(handle_t *handle, struct inode *inode,
> > >  				struct buffer_head *bh);
> > >  void ext4_set_inode_mapping_order(struct inode *inode);
> > > +int ext4_nonda_switch(struct super_block *sb);
> > >  #define FALL_BACK_TO_NONDELALLOC 1
> > >  #define CONVERT_INLINE_DATA	 2
> > >  
> > > @@ -3926,6 +3927,9 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
> > >  
> > >  extern const struct iomap_ops ext4_iomap_ops;
> > >  extern const struct iomap_ops ext4_iomap_report_ops;
> > > +extern const struct iomap_ops ext4_iomap_buffered_write_ops;
> > > +extern const struct iomap_ops ext4_iomap_buffered_da_write_ops;
> > > +extern const struct iomap_write_ops ext4_iomap_write_ops;
> > >  
> > >  static inline int ext4_buffer_uptodate(struct buffer_head *bh)
> > >  {
> > > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > > index eb1a323962b1..7f9bfbbc4a4e 100644
> > > --- a/fs/ext4/file.c
> > > +++ b/fs/ext4/file.c
> > > @@ -299,6 +299,21 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
> > >  	return count;
> > >  }
> > >  
> > > +static ssize_t ext4_iomap_buffered_write(struct kiocb *iocb,
> > > +					 struct iov_iter *from)
> > > +{
> > > +	struct inode *inode = file_inode(iocb->ki_filp);
> > > +	const struct iomap_ops *iomap_ops;
> > > +
> > > +	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
> > > +		iomap_ops = &ext4_iomap_buffered_da_write_ops;
> > > +	else
> > > +		iomap_ops = &ext4_iomap_buffered_write_ops;
> > > +
> > > +	return iomap_file_buffered_write(iocb, from, iomap_ops,
> > > +					 &ext4_iomap_write_ops, NULL);
> > > +}
> > > +
> > >  static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
> > >  					struct iov_iter *from)
> > >  {
> > > @@ -313,7 +328,10 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
> > >  	if (ret <= 0)
> > >  		goto out;
> > >  
> > > -	ret = generic_perform_write(iocb, from);
> > > +	if (ext4_inode_buffered_iomap(inode))
> > > +		ret = ext4_iomap_buffered_write(iocb, from);
> > > +	else
> > > +		ret = generic_perform_write(iocb, from);
> > >  
> > >  out:
> > >  	inode_unlock(inode);
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 39577a6b65b9..1ae7d3f4a1c8 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -3097,7 +3097,7 @@ static int ext4_dax_writepages(struct address_space *mapping,
> > >  	return ret;
> > >  }
> > >  
> > > -static int ext4_nonda_switch(struct super_block *sb)
> > > +int ext4_nonda_switch(struct super_block *sb)
> > >  {
> > >  	s64 free_clusters, dirty_clusters;
> > >  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > > @@ -3467,6 +3467,15 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
> > >  	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
> > >  }
> > >  
> > > +static bool ext4_iomap_valid(struct inode *inode, const struct iomap *iomap)
> > > +{
> > > +	return iomap->validity_cookie == READ_ONCE(EXT4_I(inode)->i_es_seq);
> > > +}
> > > +
> > > +const struct iomap_write_ops ext4_iomap_write_ops = {
> > > +	.iomap_valid = ext4_iomap_valid,
> > > +};
> > > +
> > >  static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
> > >  			   struct ext4_map_blocks *map, loff_t offset,
> > >  			   loff_t length, unsigned int flags)
> > > @@ -3501,6 +3510,8 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
> > >  	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> > >  		iomap->flags |= IOMAP_F_MERGED;
> > >  
> > > +	iomap->validity_cookie = map->m_seq;
> > > +
> > >  	/*
> > >  	 * Flags passed to ext4_map_blocks() for direct I/O writes can result
> > >  	 * in m_flags having both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN bits
> > > @@ -3908,8 +3919,12 @@ const struct iomap_ops ext4_iomap_report_ops = {
> > >  	.iomap_begin = ext4_iomap_begin_report,
> > >  };
> > >  
> > > +/* Map blocks */
> > > +typedef int (ext4_get_blocks_t)(struct inode *, struct ext4_map_blocks *);
> > > +
> > >  static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
> > > -		loff_t length, struct ext4_map_blocks *map)
> > > +		loff_t length, ext4_get_blocks_t get_blocks,
> > > +		struct ext4_map_blocks *map)
> > >  {
> > >  	u8 blkbits = inode->i_blkbits;
> > >  
> > > @@ -3921,6 +3936,9 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
> > >  	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
> > >  			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
> > >  
> > > +	if (get_blocks)
> > > +		return get_blocks(inode, map);
> > > +
> > >  	return ext4_map_blocks(NULL, inode, map, 0);
> > >  }
> > >  
> > > @@ -3938,7 +3956,7 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
> > >  	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> > >  		return -ERANGE;
> > >  
> > > -	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
> > > +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
> > >  	if (ret < 0)
> > >  		return ret;
> > >  
> > > @@ -3946,6 +3964,147 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
> > >  	return 0;
> > >  }
> > >  
> > > +static int ext4_iomap_get_blocks(struct inode *inode,
> > > +				 struct ext4_map_blocks *map)
> > > +{
> > > +	loff_t i_size = i_size_read(inode);
> > > +	handle_t *handle;
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * Check if the blocks have already been allocated, this could
> > > +	 * avoid initiating a new journal transaction and return the
> > > +	 * mapping information directly.
> > > +	 */
> > > +	if ((map->m_lblk + map->m_len) <=
> > > +	    round_up(i_size, i_blocksize(inode)) >> inode->i_blkbits) {
> > > +		ret = ext4_map_blocks(NULL, inode, map, 0);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +		if (map->m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN |
> > > +				    EXT4_MAP_DELAYED))
> > > +			return 0;
> > > +	}
> > > +
> > > +	handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> > > +			ext4_chunk_trans_blocks(inode, map->m_len));
> > > +	if (IS_ERR(handle))
> > > +		return PTR_ERR(handle);
> > > +
> > > +	ret = ext4_map_blocks(handle, inode, map,
> > > +			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
> > > +	/*
> > > +	 * Stop handle here following the lock ordering of the folio lock
> > > +	 * and the transaction start.
> > > +	 */
> > > +	ext4_journal_stop(handle);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
> > > +		loff_t offset, loff_t length, unsigned int flags,
> > > +		struct iomap *iomap, struct iomap *srcmap, bool delalloc)
> > > +{
> > > +	int ret, retries = 0;
> > > +	struct ext4_map_blocks map;
> > > +	ext4_get_blocks_t *get_blocks;
> > > +
> > > +	ret = ext4_emergency_state(inode->i_sb);
> > > +	if (unlikely(ret))
> > > +		return ret;
> > > +
> > > +	/* Inline data and non-extent are not supported. */
> > > +	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> > > +		return -ERANGE;
> > > +	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> > > +		return -EINVAL;
> > > +	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
> > > +		return -EINVAL;
> > > +
> > > +	if (delalloc)
> > > +		get_blocks = ext4_da_map_blocks;
> > > +	else
> > > +		get_blocks = ext4_iomap_get_blocks;
> > > +retry:
> > > +	ret = ext4_iomap_map_blocks(inode, offset, length, get_blocks, &map);
> > > +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> > > +		goto retry;
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> > > +	return 0;
> > > +}
> > > +
> > > +static int ext4_iomap_buffered_write_begin(struct inode *inode,
> > > +		loff_t offset, loff_t length, unsigned int flags,
> > > +		struct iomap *iomap, struct iomap *srcmap)
> > > +{
> > > +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
> > > +						  iomap, srcmap, false);
> > > +}
> > > +
> > > +static int ext4_iomap_buffered_da_write_begin(struct inode *inode,
> > > +		loff_t offset, loff_t length, unsigned int flags,
> > > +		struct iomap *iomap, struct iomap *srcmap)
> > > +{
> > > +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
> > > +						  iomap, srcmap, true);
> > > +}
> > > +
> > > +/*
> > > + * On write failure, drop the stale delayed allocation range and release
> > > + * its reserved space for both start and end blocks. Otherwise, we may
> > > + * leave a range of delayed extents covered by a clean folio, which can
> > > + * result in inaccurate space reservation accounting.
> > > + */
> > > +static void ext4_iomap_punch_delalloc(struct inode *inode, loff_t offset,
> > > +				     loff_t length, struct iomap *iomap)
> > > +{
> > > +	down_write(&EXT4_I(inode)->i_data_sem);
> > > +	ext4_es_remove_extent(inode, offset >> inode->i_blkbits,
> > > +			DIV_ROUND_UP_ULL(length, EXT4_BLOCK_SIZE(inode->i_sb)));
> > > +	up_write(&EXT4_I(inode)->i_data_sem);
> > > +}
> > > +
> > > +static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
> > > +					    loff_t length, ssize_t written,
> > > +					    unsigned int flags,
> > > +					    struct iomap *iomap)
> > > +{
> > > +	loff_t start_byte, end_byte;
> > > +
> > > +	/* If we didn't reserve the blocks, we're not allowed to punch them. */
> > > +	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
> > > +		return 0;
> > > +
> > > +	/* Nothing to do if we've written the entire delalloc extent */
> > > +	start_byte = iomap_last_written_block(inode, offset, written);
> > > +	end_byte = round_up(offset + length, i_blocksize(inode));
> > > +	if (start_byte >= end_byte)
> > > +		return 0;
> > > +
> > > +	filemap_invalidate_lock(inode->i_mapping);
> > > +	iomap_write_delalloc_release(inode, start_byte, end_byte, flags,
> > > +				     iomap, ext4_iomap_punch_delalloc);
> > > +	filemap_invalidate_unlock(inode->i_mapping);
> > > +	return 0;
> > > +}
> > > +
> > > +/*
> > > + * Since we always allocate unwritten extents, there is no need for
> > > + * iomap_end to clean up allocated blocks on a short write.
> > > + */
> > > +const struct iomap_ops ext4_iomap_buffered_write_ops = {
> > > +	.iomap_begin = ext4_iomap_buffered_write_begin,
> > > +};
> > > +
> > > +const struct iomap_ops ext4_iomap_buffered_da_write_ops = {
> > > +	.iomap_begin = ext4_iomap_buffered_da_write_begin,
> > > +	.iomap_end = ext4_iomap_buffered_da_write_end,
> > > +};
> > > +
> > >  const struct iomap_ops ext4_iomap_buffered_read_ops = {
> > >  	.iomap_begin = ext4_iomap_buffered_read_begin,
> > >  };
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index 6a77db4d3124..9bc294b769db 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -104,9 +104,13 @@ static const struct fs_parameter_spec ext4_param_specs[];
> > >   *   -> page lock -> i_data_sem (rw)
> > >   *
> > >   * buffered write path:
> > > - * sb_start_write -> i_mutex -> mmap_lock
> > > - * sb_start_write -> i_mutex -> transaction start -> page lock ->
> > > - *   i_data_sem (rw)
> > > + * sb_start_write -> i_rwsem (w) -> mmap_lock
> > > + * - buffer_head path:
> > > + *   sb_start_write -> i_rwsem (w) -> transaction start -> folio lock ->
> > > + *     i_data_sem (rw)
> > > + * - iomap path:
> > > + *   sb_start_write -> i_rwsem (w) -> transaction start -> i_data_sem (rw)
> > > + *   sb_start_write -> i_rwsem (w) -> folio lock (not under an active handle)
> > >   *
> > >   * truncate:
> > >   * sb_start_write -> i_mutex -> invalidate_lock (w) -> i_mmap_rwsem (w) ->
> > > -- 
> > > 2.52.0
> > > 
> > 
