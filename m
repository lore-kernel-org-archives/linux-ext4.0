Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B164252B1;
	Mon,  5 Oct 2026 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190887; cv=none; b=BTf8B6QEvP8ho+P7zO0BjPXYNz6nx3w15fVJ8KY44c2Iy8GRMeA8t/VN/IfF8t1erYdyT1SeazcNfCWJ/ptYH4PrlH5NDgCpWWtZK3SAOsva6Ln0DdAZ61jGDtRSbiTCnS2YWX8MmasugBCz2mEKKUMmrG8KaNNA/8UoPWy1o1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190887; c=relaxed/simple;
	bh=jTv7L1sdjoD4g497le7fWuI9CsVpOfSEO5HGPdPPbS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unnOr+lOAwZOBpHpx6Wc6bDC4+wwU+3G2mxoLmAgbDctai9U8aiq5lZ0Lxcldy9lwXsomR6STZUxpsj4/2VsLlF1gaw5OzpElYmQLBzvQR53vodNFhpVI/SpPMXyzSxypFZ4U+yHxsR+asLj2KaySiKYJI4wYsOXVi36gsrVmAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=g9l2VoyH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="g9l2VoyH"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69515UYo3274935;
	Mon, 5 Oct 2026 09:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=fMOdrzj/SxSrhb0zZ+wgDPqTk+3vzA
	WPwCWuuwKy8vA=; b=g9l2VoyHd8PoCSS7br49uE2SW/aW1zRzp5hpQ0D9xkAWlE
	lIO6QyhiV3r7KCepKhbH+kVfwhxcd+CqgbrHadzsMFLCCl64PlDH5epODKpDlekY
	ilEw5QBdtLPjPPahgwEHvbDHGyhW/s7EuZOnSvjCAvWibsh6MO5Mspq/dNnlU0mX
	VASHzuslkB0NUjr4uau51Rus1PpbfDsE3lXDOB0cE0zC5mAes/nxOzp4CC5bNzbw
	HpdoyYalaoxNu6U38fs5To0xq79jAFcarMS6PsoTfZU80jbH+QxYeWU4lkkt4KU9
	nIipAxryjy96rIUt94bJDiCMZ6Riae2UEnebhHew==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2se59903-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 09:00:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6956CcUP2203963;
	Mon, 5 Oct 2026 09:00:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h3dhgmmhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 09:00:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69590CId45482366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Oct 2026 09:00:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01FA82004F;
	Mon,  5 Oct 2026 09:00:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6679B2004B;
	Mon,  5 Oct 2026 09:00:08 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  5 Oct 2026 09:00:08 +0000 (GMT)
Date: Mon, 5 Oct 2026 14:30:05 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 22/31] ext4: submit and wait for pending disksize-grow
 I/O on writeback
Message-ID: <asNnFY8N3NJwucWe@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-23-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-23-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDAzNCBTYWx0ZWRfX1xmzBBI5DgFl
 DZT+FgCXadq7tR+qsZBSbzil7QKkBrJ84b+/qn20C9UmZjty2oeyMNO0ApRCK3YiJjz/TBrNlzd
 ++3jxjiWP13kRUhpCG3jGhZQXb2IiI8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDAzNCBTYWx0ZWRfX9cqnb42D/RWF
 B+x22D4lu/C2jXnyBGB7wmYXle1lhJ84Y/QZV/buTWumJ6c2dTsxGhPqSILpjDwyDICCAh/h+cc
 klGHN4WwVT0j1OrnxwCJpzg1WJ6PpBgfIhe3z7vepK+w1wA8ShwybwPud+XNuFvacr8FOP+xqJR
 92Re+fY6lrhexUpE7dTeYkancsG8eQphZesi+qJK4RUEDGINEY4Zw1DZ/5jPCfKClFJAsVcd9lt
 sBhoVaCDLBYvThHMiwGtLKdWOJvH4JUfZGcQOUbRh+sK3+UehXWAK1RPpJ8aAFJ8nmFJOOZpW8V
 fpm2XPvz888Vv9x+z5xGZJ+ydwMFAezNuK/8LURcAiqVfq/dY1Bg+Cu/VNzxRU4Za2jotw4/l/a
 IJBD2KE90lds00T+KWUxaF3LhhqaPmVTic18Ja91Fnfz8oVTKefH8Q2FyVnNR4D8F69V0zBS3vQ
 iLxdemnI0PeDSyUO8hQ==
X-Proofpoint-GUID: EiiYBX58JVjcceUi0gQz1KnmjganfhAf
X-Authority-Analysis: v=2.4 cv=UNRIjyfy c=1 sm=1 tr=0 ts=6ac3671f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=i0EeH86SAAAA:8
 a=4k-paB-1vigz8DWkU3QA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 49ktOmpScSg7P_Lqg81PeVhv8wbBm4ux
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_01,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050034

On Thu, Sep 03, 2026 at 08:35:34PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When the current writeback pass begins beyond the disksize-grow-pending
> zeroed EOF block, the ioend worker would otherwise have to wait for the
> pending EOF block to complete before it can advance i_disksize.
> Otherwise the old EOF block could be exposed as stale data once
> i_disksize advances past it.
> 
> Therefore, introduce the ioend mechanism for the pending range, tag
> ioends that cover the pending zeroed EOF block which straddles
> i_disksize with EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO in
> ext4_iomap_writeback_submit(), and clear the bit and wake up all waiters
> in ext4_iomap_end_bio() when such an ioend completes.
> 
> Clearing EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO does not depend on whether
> the disksize grow I/O succeeds. That is, even if the I/O fails, we still
> allow subsequent writes in the range to update i_disksize. This is
> consistent with the previous behavior, and we rely on data_err=abort to
> prevent metadata updates when data write failures occur.
> 
> In order to avoid the ioend that passes the pending range waiting for a
> long time, proactively submit the pending range first in
> ext4_iomap_writepages() so it completes in parallel with the rest of the
> writeback.
> 
> Note that the handling of discarding the zeroed EOF folio will be
> processed later, otherwise the bit will be set forever.
> EXT4_STATE_DISKSIZE_GROW_PENDING will be set after everthing is done.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/ext4.h    |  6 ++++++
>  fs/ext4/inode.c   | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/ext4/page-io.c | 40 +++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1c3d736fb700..089dbd39c5c2 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3986,6 +3986,12 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  			     __u64 len, __u64 *moved_len);
>  
>  /* page-io.c */
> +/*
> + * The I/O range covers the zeroed EOF block that straddles i_disksize
> + * and will advance it upon completion.
> + */
> +#define EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO	1UL
> +
>  extern int __init ext4_init_pageio(void);
>  extern void ext4_exit_pageio(void);
>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 05dd4ee805fb..4239be5a769f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4366,7 +4366,10 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>  				       int error)
>  {
>  	struct iomap_ioend *ioend = wpc->wb_ctx;
> -	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
> +	struct inode *inode = ioend->io_inode;
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	unsigned int blocksize = i_blocksize(inode);
> +	loff_t pstart, plen;
>  
>  	/*
>  	 * After I/O completion, a worker needs to be scheduled when:
> @@ -4379,6 +4382,21 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>  	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>  		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>  
> +	/*
> +	 * Mark the I/O as DISKSIZE_GROW_IO by setting io_private to
> +	 * EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO if it covers the pending range.
> +	 * Such I/O will allow or trigger i_disksize advancement in the
> +	 * ioend worker.
> +	 */
> +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
> +	if (plen &&
> +	    round_down(ioend->io_offset, blocksize) <= pstart &&
> +	    round_up(ioend->io_offset + ioend->io_size, blocksize) >=
> +			pstart + plen) {
> +		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> +		ioend->io_private = (void *)EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO;
> +	}
> +
>  	/*
>  	 * ext4_iomap_end_bio() always defers endio processing, disable
>  	 * generic BIO in task to avoid double deferral since we will use
> @@ -4398,6 +4416,33 @@ static const struct iomap_writeback_ops ext4_writeback_ops = {
>  	.writeback_submit = ext4_iomap_writeback_submit,
>  };
>  
> +/*
> + * If the current writeback range begins after the pending zeroed EOF
> + * block range which straddles i_disksize, issue a separate writeback to
> + * flush it first, so as to avoid prolonged waiting.
> + */
> +static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
> +					    struct writeback_control *wbc)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	loff_t pstart, plen, range_start;
> +
> +	if (wbc->range_cyclic)
> +		range_start = (loff_t)mapping->writeback_index << PAGE_SHIFT;
> +	else
> +		range_start = wbc->range_start;
> +
> +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
> +	if (!plen || range_start < pstart + plen)
> +		return;
Hi Zhang, 

Maybe we can check here if pstart lies withing the same folio as the
writeback range, then we don't need an explicit flush as we will anyways
flush out the whole folio. We can check against the
mapping_min_folio_nrbytes perhaps.

Regards,
ojaswin

> +
> +	/* Keep the caller's sync mode to avoid stalling the background flusher. */
> +	if (wbc->sync_mode == WB_SYNC_ALL)
> +		filemap_fdatawrite_range(mapping, pstart, pstart + plen - 1);
> +	else
> +		filemap_flush_range(mapping, pstart, pstart + plen - 1);
> +}
> +
>  static int ext4_iomap_writepages(struct address_space *mapping,
>  				 struct writeback_control *wbc)
>  {
> @@ -4415,6 +4460,12 @@ static int ext4_iomap_writepages(struct address_space *mapping,
>  	if (unlikely(ret))
>  		return ret;
>  
> +	/*
> +	 * Submit the pending zeroed EOF block range if the entire
> +	 * writeback range lies beyond it.
> +	 */
> +	ext4_iomap_wb_submit_zeroed_eof(inode, wbc);
> +
>  	alloc_ctx = ext4_writepages_down_read(sb);
>  	trace_ext4_writepages(inode, wbc);
>  	ret = iomap_writepages(&wpc);
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 9b0e12b5463c..697e12a54a49 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -549,6 +549,34 @@ void ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
>  	} while ((bh = bh->b_this_page) != head);
>  }
>  
<snip>
