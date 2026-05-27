Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5757E37F721;
	Wed, 27 May 2026 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897562; cv=none; b=qoiURu+5K+QMgmIhfrxPoJMgeBCS+c6JuN5/pEYKLDeXRh47fkzMvwgLd3nqNs6Tzp/G8pA+XYDBr3k4q8NmT0TO6xiTtcWgg0tjKaVLqWGQRrkD0RSKc8FXU8rYue/MtFOJZ/zMTahJsFL0d5HQPSyzZDLxdaJt+BMbXJPWxl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897562; c=relaxed/simple;
	bh=sGEAAONOOYG/n5y7A+DMd5Wivl7snvfdGvWl2dAbLvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhpaHMW3pB2msY++M3Wzao75grWLQzHBYQT9REM0GNUWQuJn8h0KtwpMuuzKFHQPwQUlBclEHsDw594q9xLKqtHPFpZoUiz31mu9vbmQ5Pqhq8MccJ2OxHPIuehRCnRke8oswhjG4Q1fumduicMbMdhCl6egg4TZQP3ec8Rx1DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SPtPuEIb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SPtPuEIb"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RChSSi272361;
	Wed, 27 May 2026 15:58:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ajIERAoKO62JxZshMaE5hmP1np8qgF
	g8uki8tLdsJsE=; b=SPtPuEIbAw6LM4ZtISCEKkpAP2IUNCMQvCI7P+Re+6e19k
	kHI1VacftHj5wI4Jl8dsMSQd6NzSt9iDYM5lG3Ty58NSevxaYcx/ZbSymsAg4Ntr
	vgooaN0CYdgBT1hpyL2cKE4zBIyd/Ww9SQ63J3fPTw5LErlWBtFI915EZwkF0VV1
	ALIBTtNFVrfO02ZcioTOPxGgf2uDxq4rYtRXReblWJWIHiFf6/Py0xvh1YpKnw8p
	n07mcj4R67v8NuJ2V9HO02g2j9fhkRUAOuMRx1G6QejAdVOUu8IANoKWQeaCBj6v
	v8B4a7UJa1coNI4ubqiKBskijh4wUQ57ML2bC9bQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4nq8y3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 15:58:40 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64RFs4VL018807;
	Wed, 27 May 2026 15:58:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4edjrb3rk8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 15:58:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64RFwcvX44433766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 May 2026 15:58:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDC452004E;
	Wed, 27 May 2026 15:58:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A9B32004B;
	Wed, 27 May 2026 15:58:33 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.219.144])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 27 May 2026 15:58:32 +0000 (GMT)
Date: Wed, 27 May 2026 21:28:28 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <ahcUeq_IA_X988Ca@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-19-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: glBMmRTM-nyrtk1iyh2Bi81yRPoGfhko
X-Proofpoint-ORIG-GUID: cBwojobT5Grg2pDAyFlJATiflYgi2aIB
X-Authority-Analysis: v=2.4 cv=QIJYgALL c=1 sm=1 tr=0 ts=6a1714b1 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=-s-xwTkS8hQoIKfHHekA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE1NiBTYWx0ZWRfX4MyVEt1ssPUV
 iUV+pAxR7+mP/LwEsCLbFPIqPiYAz/nAg6S+c9J5goEtIr3m4o42i05tueBaXUpYv9Q/pjrOZQu
 tg6g/2AWmpsBddoQxoOsDLk+UwRIpQr+K1lyAnvt4LUjcs9HrlhwpycpCesro9heCEhTHb50dGB
 s+uqMjHEU7g+nY+JJ6bW+BMUzib32VQ7Sp1/iIPuzcV0rA9chIoSz0l0Krd5UolVdw5UmuXIEda
 9WSkIw3Ph9qjF4rWj0pOwuFEeblyEcKagVZC+zXpMhQhyC3X8irmPX2m8H//OZo6JVC16C16KWH
 yWtSCaEoq+cDhLfukapr3CW+mZLjQKlop82+mTh8Vi2xK64aX/HQI+cj2l84sUnZ4wv4R7PfSIX
 oCzOUMS9ca+/vGHyepQc3gBrfJIS2LVnefnmiHfr/sx+hBgUQZxfw55yr93IB3nc5dWcV72w/MS
 7nFHFarFQp+qGdGT9Rw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605270156

On Mon, May 11, 2026 at 03:23:38PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> For append writes, wait for ordered I/O to complete before updating
> i_disksize. This ensures that zeroed data is flushed to disk before the
> metadata update, preventing stale data from being exposed during
> unaligned post-EOF append writes.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/ext4.h    | 11 +++++++
>  fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
>  fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
>  fs/ext4/super.c   | 23 ++++++++++----
>  4 files changed, 161 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 078feda47e36..9ce2128eea3e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1195,6 +1195,15 @@ struct ext4_inode_info {
>  #ifdef CONFIG_FS_ENCRYPTION
>  	struct fscrypt_inode_info *i_crypt_info;
>  #endif
> +
> +	/*
> +	 * Track ordered zeroed data during post-EOF append writes, fallocate,
> +	 * and truncate-up operations. These parameters are used only in the
> +	 * iomap buffered I/O path.
> +	 */
> +	ext4_lblk_t i_ordered_lblk;
> +	ext4_lblk_t i_ordered_len;
> +	wait_queue_head_t i_ordered_wq;
>  };
>  
>  /*
> @@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  			     __u64 len, __u64 *moved_len);
>  
>  /* page-io.c */
> +#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
> +
>  extern int __init ext4_init_pageio(void);
>  extern void ext4_exit_pageio(void);
>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e013aeb03d7b..11fb369efeb1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>  {
>  	struct iomap_ioend *ioend = wpc->wb_ctx;
>  	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
> +	ext4_lblk_t start, end, order_lblk, order_len;
>  
>  	/*
>  	 * After I/O completion, a worker needs to be scheduled when:
> @@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>  	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>  		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>  
> +	/*
> +	 * Mark the I/O as ordered. Ordered I/O requires separate endio
> +	 * handling and must not be merged with regular I/O operations.
> +	 */
> +	order_len = READ_ONCE(ei->i_ordered_len);
> +	if (order_len) {
> +		/*
> +		 * Pair with smp_store_release() in ext4_block_zero_eof().
> +		 * Ensure we see the updated i_ordered_lblk that was written
> +		 * before the release store to i_ordered_len.
> +		 */
> +		smp_rmb();
> +		order_lblk = READ_ONCE(ei->i_ordered_lblk);
> +		start = ioend->io_offset >> ioend->io_inode->i_blkbits;
> +		end = EXT4_B_TO_LBLK(ioend->io_inode,
> +				     ioend->io_offset + ioend->io_size);
> +
> +		if (start <= order_lblk && end >= order_lblk + order_len) {

Hi Zhang,

I guess this check is enough cause ordered_lblk and ordered_len will
always be  contained in a single block.

> +			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> +			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
> +			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;

FWIU, we are wanting the ordered IO to not be merged and submitted asap
since we want to wake up the waiters. Is there any other reason?

Adding the boundary in ->writeback_submit() only affects
iomap_ioend_can_merge() which happens after we have woken up the waiters
and deferred the IO to the wq. We ideally want it affect
iomap_can_add_to_ioend() ie we need to add IOMAP_F_BOUNDARY in
->writeback_range().

Secondly, I don't think boundary is the right flag here. It ensures
that everything before the ordered iomap gets submitted and the ordered
iomap starts a new ioend. This can still keep getting merged with the
newer ioends untils we decide to submit the IO, which can delay waking
up the waiters. If we really want the "no merge" behavior, we'll have to
do something like [1] (Check the 2 NOMERGE flag patches).

> +		}
> +	}
> +
>  	return iomap_ioend_writeback_submit(wpc, error);
>  }
>  
> @@ -4746,8 +4771,10 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>  					loff_t from, loff_t end)
>  {
>  	struct address_space *mapping = inode->i_mapping;
> +	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct folio *folio;
>  	bool do_submit = false;
> +	int ret;
>  
>  	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
>  	if (IS_ERR(folio))
> @@ -4757,14 +4784,50 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>  	folio_wait_writeback(folio);
>  	WARN_ON_ONCE(folio_test_writeback(folio));
>  
> -	if (likely(folio_test_dirty(folio)))
> +	/*
> +	 * Mark the ordered range. It will be cleared upon I/O completion
> +	 * in ext4_iomap_end_bio(). Any operation that extends i_disksize
> +	 * (including append write end io past the zeroed boundary,
> +	 * truncate up and append fallocate) must wait for this I/O to
> +	 * complete before updating i_disksize.
> +	 *
> +	 * When multiple overlapping unaligned EOF writes are in flight, we
> +	 * only need to track and wait for the first one. Subsequent writes
> +	 * will zero the gap in memory and ensure that the zeroed data is
> +	 * written out along with the valid data in the same block before
> +	 * i_disksize is updated.
> +	 */
> +	if (likely(folio_test_dirty(folio) &&
> +		   READ_ONCE(ei->i_ordered_len) == 0)) {
> +		WRITE_ONCE(ei->i_ordered_lblk,
> +			   from >> inode->i_blkbits);
> +		/*
> +		 * Pairs with smp_rmb() in ext4_iomap_writeback_submit()
> +		 * and ext4_iomap_wb_ordered_wait(). Ensure the updated
> +		 * i_ordered_lblk is visible when i_ordered_len becomes
> +		 * non-zero.
> +		 */
> +		smp_store_release(&ei->i_ordered_len, 1);
>  		do_submit = true;
> +	}
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
>  	/* Submit zeroed block. */
> -	if (do_submit)
> -		return filemap_fdatawrite_range(mapping, from, end - 1);
> +	if (do_submit) {
> +		ret = filemap_fdatawrite_range(mapping, from, end - 1);
> +		if (ret) {
> +			/*
> +			 * Pairs with wait_event() in
> +			 * ext4_iomap_wb_ordered_wait(). Ensure
> +			 * i_ordered_len = 0 is visible before waking up
> +			 * waiters.
> +			 */
> +			smp_store_release(&ei->i_ordered_len, 0);
> +			wake_up_all(&ei->i_ordered_wq);
> +			return ret;
> +		}
> +	}
>  	return 0;
>  }
>  
> @@ -4827,10 +4890,13 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  		 * data=ordered mode. We submit zeroed range directly here.
>  		 * Do not wait for I/O completion for performance.
>  		 *
> -		 * TODO: Any operation that extends i_disksize (including
> -		 * append write end io past the zeroed boundary, truncate up,
> -		 * and append fallocate) must wait for the relevant I/O to
> -		 * complete before updating i_disksize.
> +		 * The end_io handler ext4_iomap_wb_ordered_wait() will wait
> +		 * for I/O completion before updating i_disksize if the write
> +		 * extends beyond the zeroed boundary.
> +		 *
> +		 * TODO: Any other operation that extends i_disksize
> +		 * (including truncate up and append fallocate) must wait for
> +		 * the relevant I/O to complete before updating i_disksize.
>  		 */
>  		} else if (ext4_inode_buffered_iomap(inode)) {
>  			err = ext4_iomap_submit_zero_block(inode, from, end);
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 3050c887329f..ad05ebb49bf6 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -613,6 +613,46 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
>  	return 0;
>  }
>  
> +/*
> + * If the old disk size is not block size aligned and the current
> + * writeback range is entirely beyond the old EOF block, we should
> + * wait for the zeroed data written in ext4_block_zero_eof() to be
> + * written out, otherwise, it may expose stale data in that block.
> + */
> +static void ext4_iomap_wb_ordered_wait(struct inode *inode,
> +				       loff_t pos, loff_t end)
> +{
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	unsigned int blocksize = i_blocksize(inode);
> +	loff_t disksize = READ_ONCE(ei->i_disksize);
> +	ext4_lblk_t order_lblk, order_len;
> +
> +	/*
> +	 * Waiting for ordered I/O is unnecessary when:
> +	 * - The on-disk size is block-aligned (no stale data exists).
> +	 * - The write start is within the block of the old EOF
> +	 *   (overwriting, or appending to a block that already contains
> +	 *   valid data).
> +	 */
> +	if (!(disksize & (blocksize - 1)) ||
> +	    pos < round_up(disksize, blocksize))
> +		return;
> +
> +	order_len = READ_ONCE(ei->i_ordered_len);
> +	if (!order_len)
> +		return;
> +
> +	/*
> +	 * Pair with smp_store_release() in ext4_iomap_end_bio() and
> +	 * ext4_block_zero_eof(). Ensure we see the updated i_ordered_lblk
> +	 * that was written before the release store to i_ordered_len.
> +	 */
> +	smp_rmb();
> +	order_lblk = READ_ONCE(ei->i_ordered_lblk);
> +	if ((pos >> inode->i_blkbits) >= order_lblk + order_len)
> +		wait_event(ei->i_ordered_wq, READ_ONCE(ei->i_ordered_len) == 0);
> +}
> +
>  static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
>  					 loff_t end)
>  {
> @@ -656,6 +696,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  		goto out;
>  	}
>  
> +	/* Wait ordered zero data to be written out. */
> +	ext4_iomap_wb_ordered_wait(inode, pos, pos + size);
> +
>  	/* We may need to convert one extent and dirty the inode. */
>  	credits = ext4_chunk_trans_blocks(inode,
>  			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
> @@ -717,8 +760,25 @@ void ext4_iomap_end_bio(struct bio *bio)
>  	struct inode *inode = ioend->io_inode;
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +	unsigned long io_mode = (unsigned long)ioend->io_private;
>  	unsigned long flags;
>  
> +	/*
> +	 * This is an ordered I/O, clear the ordered range set in
> +	 * ext4_block_zero_eof() and wake up all waiters that will update
> +	 * the inode i_disksize.
> +	 */
> +	if (io_mode == EXT4_IOMAP_IOEND_ORDER_IO) {
> +		/*
> +		 * Pairs with wait_event() in ext4_iomap_wb_ordered_wait().
> +		 * Ensure i_ordered_len = 0 is visible before waking up
> +		 * waiters.
> +		 */
> +		smp_store_release(&ei->i_ordered_len, 0);
> +		wake_up_all(&ei->i_ordered_wq);
> +		goto defer;
> +	}
> +
>  	/* Needs to convert unwritten extents or update the i_disksize. */
>  	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
>  	    ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize))
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 62bfe05a64bc..9c0a00e716f3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1444,6 +1444,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	ext4_fc_init_inode(&ei->vfs_inode);
>  	spin_lock_init(&ei->i_fc_lock);
>  	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
> +	ei->i_ordered_lblk = 0;
> +	ei->i_ordered_len = 0;
> +	init_waitqueue_head(&ei->i_ordered_wq);
>  	return &ei->vfs_inode;
>  }
>  
> @@ -1480,12 +1483,20 @@ static void ext4_destroy_inode(struct inode *inode)
>  		dump_stack();
>  	}
>  
> -	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS) &&
> -	    WARN_ON_ONCE(EXT4_I(inode)->i_reserved_data_blocks))
> -		ext4_msg(inode->i_sb, KERN_ERR,
> -			 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
> -			 inode->i_ino, EXT4_I(inode),
> -			 EXT4_I(inode)->i_reserved_data_blocks);
> +	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS)) {
> +		if (WARN_ON_ONCE(EXT4_I(inode)->i_reserved_data_blocks))
> +			ext4_msg(inode->i_sb, KERN_ERR,
> +				 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
> +				 inode->i_ino, EXT4_I(inode),
> +				 EXT4_I(inode)->i_reserved_data_blocks);
> +
> +		if (WARN_ON_ONCE(EXT4_I(inode)->i_ordered_len))
> +			ext4_msg(inode->i_sb, KERN_ERR,
> +				 "Inode %llu (%p): i_ordered_lblk (%u) and i_ordered_len (%u) not cleared!",
> +				 inode->i_ino, EXT4_I(inode),
> +				 EXT4_I(inode)->i_ordered_lblk,
> +				 EXT4_I(inode)->i_ordered_len);
> +	}
>  }
>  
>  static void ext4_shutdown(struct super_block *sb)
> -- 
> 2.52.0
> 
