Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A43A3F4DCD;
	Fri, 29 May 2026 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780068809; cv=none; b=qPomsBDd6Yy2lCnm5WE9dm5MiPlcswWaY/goB7jU87zOxgULD/otF8Jot0mjwuaeMqU5ynzPYUdX5ZoZUhRKoaTLiIxa42zDWJT83wFWDkCIgmaSQw3Bc40IyEFUjU2C0a1p/jTBBkCumFYNjLOIjtkP2xiTwObSU+HXHQnUf3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780068809; c=relaxed/simple;
	bh=EHyMVDeTsUcPtHp1earH5jKUQQzrjpMNHxxlMPD5kHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tE/utKq5XwwjHV5yNF8en/OrKDR1yAYCMp25vMD6jjo2IAkq2KWvgvdoYdWyxPpDB6WTASBIl5QEfw4TTCJefBJBUoKuINtJgwXHY/XLtsnSgD0yanP3Ewkw11pPUORli1hk9uGDv36glYrYPO2GQ5Am+IX361Qe1gFnsqBuUts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s/HRfIQb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s/HRfIQb"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64TF46aE1684642;
	Fri, 29 May 2026 15:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=slFTOH3ij0YjQwnEDO0UEENBmXyNKq
	xZMQrHMVuKm/E=; b=s/HRfIQbp8VfKLIvnx0Erh7wKZzrfoXftxvnNQp/XmT2WD
	AZ40GgEqJIDk+9L80EBTiCpQ531wnmV/eGS7hhmW9aNifSL5obZYDqkNl2KT7xx1
	qvKG6ep9ZMnJWsTj0K/xzLdkLvg26qbt1xFGwr97QFxDu8vYK2PawuL7TtcymPSs
	V+BQK5vw34VKQsk27sq3kcvHBlP9A/NXVifomiOPbQQER0IRwLskK3Jk+oau47Fv
	lXuCtp3aVC5OP767EoKUpzFwyS1Kjt4O2c0QqMpjbsMkT3j1iWNfPGVlpK6klQF+
	X57j5jOzDtkNHivIRmiHikEpTq546ffb9BqgrHtw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ee884kqgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 15:32:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64TFO4tL003527;
	Fri, 29 May 2026 15:32:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4edjrbg015-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 15:32:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64TFWodl50397634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 May 2026 15:32:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7759F20040;
	Fri, 29 May 2026 15:32:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AAA5C2004B;
	Fri, 29 May 2026 15:32:45 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.222.122])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 29 May 2026 15:32:45 +0000 (GMT)
Date: Fri, 29 May 2026 21:02:42 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ritesh.list@gmail.com, djwong@kernel.org,
        hch@infradead.org, yi.zhang@huawei.com, yangerkun@huawei.com,
        yukuai@fnnas.com
Subject: Re: [PATCH v4 09/23] ext4: implement writeback path using iomap
Message-ID: <ahmxmrWzIWRR9PUm@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-10-yi.zhang@huaweicloud.com>
 <ahboWtDYXagrgTR4@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <458bda7a-c3c6-4cb3-9c05-0718cf2ef95f@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <458bda7a-c3c6-4cb3-9c05-0718cf2ef95f@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=fIYJG5ae c=1 sm=1 tr=0 ts=6a19b1a5 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=i0EeH86SAAAA:8
 a=GJt-zQSVNMDa1jerbvwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: i98vXFDU8kpfzv_qKViML5NhcpQ0BdLm
X-Proofpoint-GUID: AY1JyP07wb9PPDd-dxZIHjamb5CarCPl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDE1MSBTYWx0ZWRfX83UT33DWfTM1
 0fLTNy9X3+ElF/YOPyqgkzIF0RpL/RBm99VI9+qLB/Cb0K2M198FEXHxXZ9C/yBbiruQnutAo+4
 5j/4tQeoLSPnASzC0BKwpZIbpLozvD8jmLEiqYfo2Pi08dCrywt+SkuvJUAS/zV1Q6x3STxX0KD
 67yHpihGy3KcXYGQIvpwucJOY8fXeJZ61Dt/cjm0XyGeNJ2mBEWcgiyqhji9CtT7n5IPBR4JhLi
 26OaoMvrz65xzR16cRuB4Q8knuUVg/I7sciqMxsLQ/Qu2uNqArI8JzG021Oez6sduNk44bi1xdw
 Id6BXTMynKq5gCzEgbpe6CevokCZtdT7dD7ytgvMOeE3dTBBx3q7NQNMAo+TzkZm1UA/LFr7Z9H
 cYf60foJsZYUdz+lyfIOUsPnKYP99xBVX2NNHng0JsjAcarvoBOvxv4Fqp3uhNO8Xw+VkrolFx6
 e5Jz3btMSNZLBKU64aQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-29_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2605290151

On Fri, May 29, 2026 at 10:12:12PM +0800, Zhang Yi wrote:
> Hi, Ojaswin!
> 
> On 5/27/2026 8:49 PM, Ojaswin Mujoo wrote:
> > On Mon, May 11, 2026 at 03:23:29PM +0800, Zhang Yi wrote:
> > > From: Zhang Yi <yi.zhang@huawei.com>
> > > 
> > > Add the iomap writeback path for ext4 buffered I/O. This introduces:
> > > 
> > >   - ext4_iomap_writepages(): the main writeback entry point.
> > >   - ext4_writeback_ops: a new iomap_writeback_ops instance to handle
> > >     block mapping and I/O submission.
> > >   - A new end I/O worker for converting unwritten extents, updating file
> > >     size, and handling DATA_ERR_ABORT after I/O completion.
> > > 
> > > Core implementation details:
> > > 
> > >   - ->writeback_range() callback
> > >     Calls ext4_iomap_map_writeback_range() to query the longest range of
> > >     existing mapped extents. For performance, when a block range is not
> > >     yet allocated, it allocates based on the writeback length and delalloc
> > >     extent length, rather than allocating for a single folio at a time.
> > >     The folio is then added to an iomap_ioend instance.
> > > 
> > >   - ->writeback_submit() callback
> > >     Registers ext4_iomap_end_bio() as the end bio callback. This callback
> > >     schedules a worker to handle:
> > >     - Unwritten extent conversion.
> > >     - i_disksize update after data is written back.
> > >     - Journal abort on writeback I/O failure.
> > 
> > Hi Zhang, the changes look good. I have a few comments below:
> > > 
> > > Key changes and considerations:
> > > 
> > > - Append write and unwritten extents
> > >    Since data=ordered mode is not used to prevent stale data exposure
> > >    during append writebacks, new blocks are always allocated as unwritten
> > >    extents (i.e. always enable dioread_nolock), and i_disksize update is
> > >    postponed until I/O completion.
> > 
> > Makes sense.
> > 
> > >    Additionally, the deadlock that the
> > >    reserve handle was expected to resolve does not occur anymore.
> > 
> > I guess this is since we don't use ordered data so we can't block on
> > starting a txn in end io.
> 
> Yep.
> 
> > 
> > >    Therefore, the end I/O worker can start a normal journal handle
> > >    instead of a reserve handle when converting unwritten extents.
> > > 
> > > - Lock ordering
> > >    The ->writeback_range() callback runs under the folio lock, requiring
> > >    the journal handle to be started under that same lock. This reverses
> > >    the order compared to the buffer_head writeback path. The lock ordering
> > >    documentation in super.c has been updated accordingly.
> > > 
> > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > ---
> > >   fs/ext4/ext4.h        |   4 +
> > >   fs/ext4/inode.c       | 208 +++++++++++++++++++++++++++++++++++++++++-
> > >   fs/ext4/page-io.c     | 126 +++++++++++++++++++++++++
> > >   fs/ext4/super.c       |   7 +-
> > >   fs/iomap/ioend.c      |   3 +-
> > >   include/linux/iomap.h |   1 +
> > >   6 files changed, 346 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index 4832e7f7db82..078feda47e36 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -1173,6 +1173,8 @@ struct ext4_inode_info {
> > >   	 */
> > >   	struct list_head i_rsv_conversion_list;
> > >   	struct work_struct i_rsv_conversion_work;
> > > +	struct list_head i_iomap_ioend_list;
> > > +	struct work_struct i_iomap_ioend_work;
> > >   	/*
> > >   	 * Transactions that contain inode's metadata needed to complete
> > > @@ -3870,6 +3872,8 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *page,
> > >   		size_t len);
> > >   extern struct ext4_io_end_vec *ext4_alloc_io_end_vec(ext4_io_end_t *io_end);
> > >   extern struct ext4_io_end_vec *ext4_last_io_end_vec(ext4_io_end_t *io_end);
> > > +extern void ext4_iomap_end_io(struct work_struct *work);
> > > +extern void ext4_iomap_end_bio(struct bio *bio);
> > >   /* mmp.c */
> > >   extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 1ae7d3f4a1c8..a80195bd6f20 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -44,6 +44,7 @@
> > >   #include <linux/iversion.h>
> > >   #include "ext4_jbd2.h"
> > > +#include "ext4_extents.h"
> > >   #include "xattr.h"
> > >   #include "acl.h"
> > >   #include "truncate.h"
> > > @@ -4120,10 +4121,215 @@ static void ext4_iomap_readahead(struct readahead_control *rac)
> > >   	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
> > >   }
> > > +static int ext4_iomap_map_one_extent(struct inode *inode,
> > > +				     struct ext4_map_blocks *map)
> > > +{
> > > +	struct extent_status es;
> > > +	handle_t *handle = NULL;
> > > +	int credits, map_flags;
> > > +	int retval;
> > > +
> > > +	credits = ext4_chunk_trans_blocks(inode, map->m_len);
> > > +	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, credits);
> > > +	if (IS_ERR(handle))
> > > +		return PTR_ERR(handle);
> > > +
> > > +	map->m_flags = 0;
> > > +	/*
> > > +	 * It is necessary to look up extent and map blocks under i_data_sem
> > > +	 * in write mode, otherwise, the delalloc extent may become stale
> > > +	 * during concurrent truncate operations.
> > > +	 */
> > > +	ext4_fc_track_inode(handle, inode);
> > > +	down_write(&EXT4_I(inode)->i_data_sem);
> > > +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
> > > +		retval = es.es_len - (map->m_lblk - es.es_lblk);
> > > +		map->m_len = min_t(unsigned int, retval, map->m_len);
> > > +
> > > +		if (ext4_es_is_delayed(&es)) {
> > 
> > I understand that it is okay for us to rely on extent status ==
> > delayed here because we never reclaim delayed es entries and hence we
> > are sure to not skip any delayed block allocations here.
> 
> Yeah, right.
> 
> > 
> > > +			map->m_flags |= EXT4_MAP_DELAYED;
> > > +			trace_ext4_da_write_pages_extent(inode, map);
> > > +			/*
> > > +			 * Call ext4_map_create_blocks() to allocate any
> > > +			 * delayed allocation blocks. It is possible that
> > > +			 * we're going to need more metadata blocks, however
> > > +			 * we must not fail because we're in writeback and
> > > +			 * there is nothing we can do so it might result in
> > > +			 * data loss. So use reserved blocks to allocate
> > > +			 * metadata if possible.
> > > +			 */
> > > +			map_flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
> > > +				    EXT4_GET_BLOCKS_METADATA_NOFAIL |
> > > +				    EXT4_EX_NOCACHE;
> > > +
> > > +			retval = ext4_map_create_blocks(handle, inode, map,
> > > +							map_flags);
> > > +			if (retval > 0)
> > > +				ext4_fc_track_range(handle, inode, map->m_lblk,
> > > +						map->m_lblk + map->m_len - 1);
> > > +			goto out;
> > > +		} else if (unlikely(ext4_es_is_hole(&es)))
> > 
> > Now that you've fixed the partial invalidate in iomap (patch 12/23)
> > can we still hit this hole case?
> 
> Theoretically, no hole should be encountered; this is just defensive
> programming.
> 
> > 
> > > +			goto out;
> > > +
> > > +		/* Found written or unwritten extent. */
> > > +		map->m_pblk = ext4_es_pblock(&es) + map->m_lblk - es.es_lblk;
> > > +		map->m_flags = ext4_es_is_written(&es) ?
> > > +			       EXT4_MAP_MAPPED : EXT4_MAP_UNWRITTEN;
> > > +		goto out;
> > > +	}
> > > +
> > > +	retval = ext4_map_query_blocks(handle, inode, map, EXT4_EX_NOCACHE);
> > > +out:
> > > +	up_write(&EXT4_I(inode)->i_data_sem);
> > > +	ext4_journal_stop(handle);
> > > +	return retval < 0 ? retval : 0;
> > > +}
> > > +
> > > +static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
> > > +					  loff_t offset, unsigned int dirty_len)
> > > +{
> > > +	struct inode *inode = wpc->inode;
> > > +	struct super_block *sb = inode->i_sb;
> > > +	struct journal_s *journal = EXT4_SB(sb)->s_journal;
> > > +	struct ext4_map_blocks map;
> > > +	unsigned int blkbits = inode->i_blkbits;
> > > +	unsigned int index = offset >> blkbits;
> > > +	unsigned int blk_end, blk_len;
> > > +	int ret;
> > > +
> > > +	ret = ext4_emergency_state(sb);
> > > +	if (unlikely(ret))
> > > +		return ret;
> > > +
> > > +	/* Check validity of the cached writeback mapping. */
> > > +	if (offset >= wpc->iomap.offset &&
> > > +	    offset < wpc->iomap.offset + wpc->iomap.length &&
> > > +	    ext4_iomap_valid(inode, &wpc->iomap))
> > > +		return 0;
> > > +
> > > +	blk_len = dirty_len >> blkbits;
> > > +	blk_end = min_t(unsigned int, (wpc->wbc->range_end >> blkbits),
> > > +				      (UINT_MAX - 1));
> > 
> > This is an interesting idea. I'm just a bit worried when we have
> > range_end == LLONG_MAX (bg flush) and we will always be trying to allocate
> > MAX_WRITEPAGES, incase of a slightly fragmented FS, we might keep
> > falling into slower mballoc criterias and might waste a lot of time
> > scanning the groups.
> 
> Actually, MAX_WRITEPAGES is not allocated every time; the allocated
> length also depends on the length of data that has already been delayed
> for writing, and the smaller value is taken. If the user has indeed

Hmm so we take the blk_end based on range_end (which is LLONG_MAX for bg
flusher) and then our blk_len will be set accordingly and would become a
large number as well. Then we will set map.m_len based on this blk_len
and MAX_WRITEPAGES. Am I missing something that clamps our m_len?

> performed delalloc writes on data of up to MAX_WRITEPAGES in length,
> then regardless of how fragmented the file system is, I will need to
> allocate blocks of that length. Reducing the number of calls is always
> beneficial.
> 
> > 
> > > +	if (blk_end > index + blk_len)
> > > +		blk_len = blk_end - index + 1;
> > > +
> > > +retry:
> > > +	map.m_lblk = index;
> > > +	map.m_len = min_t(unsigned int, MAX_WRITEPAGES_EXTENT_LEN, blk_len);
> > > +	ret = ext4_map_blocks(NULL, inode, &map,
> > > +			      EXT4_GET_BLOCKS_IO_SUBMIT | EXT4_EX_NOCACHE);
> > 
> > Do we really need the IO_SUBMIT flag here now that we are:
> > 1. Not using ordered data
> > 2. We anyways don't use it in ext4_iomap_map_one_extent().
> > 
> > I think we can drop it.
> 
> We can't drop it, because IO_SUBMIT is also used to avoid the check of
> ext4_check_map_extents_env() in ext4_map_blocks() under the writeback
> path.

Yes, noted :) 

Thanks,
Ojaswin

> 
> Cheers,
> Yi.
> 
> > 
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	/*
> > > +	 * The map is not a delalloc extent, it must either be a hole
> > > +	 * or an extent which have already been allocated.
> > > +	 */
> > > +	if (!(map.m_flags & EXT4_MAP_DELAYED))
> > > +		goto out;
> > > +
> > > +	/* Map one delalloc extent. */
> > > +	ret = ext4_iomap_map_one_extent(inode, &map);
> > > +	if (ret < 0) {
> > > +		if (ext4_emergency_state(sb))
> > > +			return ret;
> > > +
> > > +		/*
> > > +		 * Retry transient ENOSPC errors, if
> > > +		 * ext4_count_free_blocks() is non-zero, a commit
> > > +		 * should free up blocks.
> > > +		 */
> > > +		if (ret == -ENOSPC && journal && ext4_count_free_clusters(sb)) {
> > > +			jbd2_journal_force_commit_nested(journal);
> > > +			goto retry;
> > > +		}
> > > +
> > > +		ext4_msg(sb, KERN_CRIT,
> > > +			 "Delayed block allocation failed for inode %llu at logical offset %llu with max blocks %u with error %d",
> > > +			 inode->i_ino, (unsigned long long)map.m_lblk,
> > > +			 (unsigned int)map.m_len, -ret);
> > > +		ext4_msg(sb, KERN_CRIT,
> > > +			 "This should not happen!! Data will be lost\n");
> > > +		if (ret == -ENOSPC)
> > > +			ext4_print_free_blocks(inode);
> > > +		return ret;
> > > +	}
> > > +out:
> > > +	ext4_set_iomap(inode, &wpc->iomap, &map, offset, dirty_len, 0);
> > > +	return 0;
> > > +}
> > > +
> > 
> > <snip>
> > > 
> 
