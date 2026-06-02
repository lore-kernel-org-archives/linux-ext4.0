Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F22393DE3;
	Tue,  2 Jun 2026 05:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780379840; cv=none; b=K8k0saiCIitRaIKzkHbTXsLnNIJFq8tavxORST9r7IoGVSUkmWLZsUjXCuLQshU1+0dHQJqX11xr0tZa8y0HTb/yW8Yfoo5SPjFAjlkpr+Vrd1vczoPXqdbTZAEdBeK1J0UfNSATdKB5hvoQXHRvjv1PfmPr3BUacsZo54ukPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780379840; c=relaxed/simple;
	bh=R1F9cWxPfNnpoA3aaRRqBGN0Us/WqFNwWTF1skSY3xo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbktnipbvnC5TncU17yiST2OiK5HPBP8b/lMjjA8zN8IpiQP8qALruZ4ZpdjEDcgPLB+JF+Bw4bzlv3EyFizIB4NrIHODfGlotsNC7MOB8KVEOSXm4n5h4Uwfg9R4hg6b5T1I6/yIXt4OeuOAJ71KPg75tf/2IudxwDW1KmbNSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rZZ/bVbg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rZZ/bVbg"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Iwr0b2708324;
	Tue, 2 Jun 2026 05:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=l6T3g3
	Zvev9d2/9g8wxkb6KZE1IE5KAMVJnG+LJJv+A=; b=rZZ/bVbgi9j55kSgQdQ7wn
	6/c8bCFYK5dARD6YsRPQg3qjj8ROViuW6kDZNBP+xMSrxaQphdvF5g8YKNFb98LM
	8Mz5jM/X8TStGhl5C9b7BJFWEZgE24xKnnQiUFaOUWdtfbAyLabPr+XUnV0pGDuF
	rku3Cv10Aa6YtuufZXSbvFrzliuZ1qdHzBo+FIq/hphTXmcjFjmY7Y27Suc4tXVg
	V3klDZnMF9vurWsrfwcEJEyGrEQGBptUXka+CeROUNLecVxEwXZC0cYalw4dZXE1
	XiMI3W4rA3GifZTJRxixpZS+pVo6RMLojHig+tn3WSOQE/A5Cg3xZVJQQgUb8DuA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efnahm7rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 05:56:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6525s7cU011086;
	Tue, 2 Jun 2026 05:56:43 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egb7k1srs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 05:56:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6525ufPa51052926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jun 2026 05:56:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7890620040;
	Tue,  2 Jun 2026 05:56:41 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D883A2004B;
	Tue,  2 Jun 2026 05:56:33 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.23.47])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  2 Jun 2026 05:56:33 +0000 (GMT)
Date: Tue, 2 Jun 2026 11:26:29 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <ah5wjTu4-m4n-V6w@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <ahcUeq_IA_X988Ca@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <ahhEV3STaaVI4dTs@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <b22baeed-3a20-47a4-8e7c-22f61a6eb49b@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b22baeed-3a20-47a4-8e7c-22f61a6eb49b@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDA0OSBTYWx0ZWRfX3ht2dP0oC901
 IuF4Nbsk6dL/4waWCzwRQYpLNaseHX0WRmNHBKhVx4lOAxKF6Y8iZpSb/9cGXdz/kLypCA+t+JK
 EM9NG6OOBFQ9y5M74CCz2j4tnNYaw6bmQaUIvypQ+T5U1Srig4KuMpXY+i2mppvpDK9/dZ12ePs
 tgTx9/BWB0GmmJfWsD7Nm/jsIqEesbocIAWw/TffJTBlVyT1c3UA9oYY4AjNKSmdpe+OS95Mqnm
 LtolEVgjiSCt5RCjFfNhwr854lxPFrnoMF1f9Uiyjf9u0K69htUKGeBAdRxp0UICIckr03k256U
 U6bUvGJOxumvREQQCp+NEOq6bIZ8QFk5wnug4cCtVlpwcEyV299rhQxPnMhy4q42PQHHsAqwEkT
 bB+mMSLMCPS0TWuoZHm3LYzPGwblznyX8Y7znrrGPDEFyQn8A9FLXE4Q5RweolxPHiSoMXKLFfG
 zcnu+Dz1z7bXTMHIFXA==
X-Proofpoint-ORIG-GUID: rjq7GV0ZWwHU5_0y3CW-E6Kc1RYne8hL
X-Authority-Analysis: v=2.4 cv=cOzQdFeN c=1 sm=1 tr=0 ts=6a1e709c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=C4kjeHY-xESnIwBaInMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: yiN1m7oGKC0HuYiENLkRy88brdcudfUb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606020049

On Sat, May 30, 2026 at 05:32:54PM +0800, Zhang Yi wrote:
> On 5/28/2026 9:34 PM, Ojaswin Mujoo wrote:
> > On Wed, May 27, 2026 at 09:28:28PM +0530, Ojaswin Mujoo wrote:
> >> On Mon, May 11, 2026 at 03:23:38PM +0800, Zhang Yi wrote:
> >>> From: Zhang Yi <yi.zhang@huawei.com>
> >>>
> >>> For append writes, wait for ordered I/O to complete before updating
> >>> i_disksize. This ensures that zeroed data is flushed to disk before the
> >>> metadata update, preventing stale data from being exposed during
> >>> unaligned post-EOF append writes.
> >>>
> >>> Suggested-by: Jan Kara <jack@suse.cz>
> >>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >>> ---
> >>>  fs/ext4/ext4.h    | 11 +++++++
> >>>  fs/ext4/inode.c   | 80 ++++++++++++++++++++++++++++++++++++++++++-----
> >>>  fs/ext4/page-io.c | 60 +++++++++++++++++++++++++++++++++++
> >>>  fs/ext4/super.c   | 23 ++++++++++----
> >>>  4 files changed, 161 insertions(+), 13 deletions(-)
> >>>
> [...]
> >>> @@ -4746,8 +4771,10 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
> >>>  					loff_t from, loff_t end)
> >>>  {
> >>>  	struct address_space *mapping = inode->i_mapping;
> >>> +	struct ext4_inode_info *ei = EXT4_I(inode);
> >>>  	struct folio *folio;
> >>>  	bool do_submit = false;
> >>> +	int ret;
> >>>  
> >>>  	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
> >>>  	if (IS_ERR(folio))
> >>> @@ -4757,14 +4784,50 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
> >>>  	folio_wait_writeback(folio);
> >>>  	WARN_ON_ONCE(folio_test_writeback(folio));
> >>>  
> >>> -	if (likely(folio_test_dirty(folio)))
> >>> +	/*
> >>> +	 * Mark the ordered range. It will be cleared upon I/O completion
> >>> +	 * in ext4_iomap_end_bio(). Any operation that extends i_disksize
> >>> +	 * (including append write end io past the zeroed boundary,
> >>> +	 * truncate up and append fallocate) must wait for this I/O to
> >>> +	 * complete before updating i_disksize.
> >>> +	 *
> >>> +	 * When multiple overlapping unaligned EOF writes are in flight, we
> >>> +	 * only need to track and wait for the first one. Subsequent writes
> >>> +	 * will zero the gap in memory and ensure that the zeroed data is
> >>> +	 * written out along with the valid data in the same block before
> >>> +	 * i_disksize is updated.
> >>> +	 */
> >>> +	if (likely(folio_test_dirty(folio) &&
> >>> +		   READ_ONCE(ei->i_ordered_len) == 0)) {
> >>> +		WRITE_ONCE(ei->i_ordered_lblk,
> >>> +			   from >> inode->i_blkbits);
> >>> +		/*
> >>> +		 * Pairs with smp_rmb() in ext4_iomap_writeback_submit()
> >>> +		 * and ext4_iomap_wb_ordered_wait(). Ensure the updated
> >>> +		 * i_ordered_lblk is visible when i_ordered_len becomes
> >>> +		 * non-zero.
> >>> +		 */
> >>> +		smp_store_release(&ei->i_ordered_len, 1);
> >>>  		do_submit = true;
> >>> +	}
> >>>  	folio_unlock(folio);
> >>>  	folio_put(folio);
> >>>  
> >>>  	/* Submit zeroed block. */
> >>> -	if (do_submit)
> >>> -		return filemap_fdatawrite_range(mapping, from, end - 1);
> >>> +	if (do_submit) {
> >>> +		ret = filemap_fdatawrite_range(mapping, from, end - 1);
> >>> +		if (ret) {
> >>> +			/*
> >>> +			 * Pairs with wait_event() in
> >>> +			 * ext4_iomap_wb_ordered_wait(). Ensure
> >>> +			 * i_ordered_len = 0 is visible before waking up
> >>> +			 * waiters.
> >>> +			 */
> >>> +			smp_store_release(&ei->i_ordered_len, 0);
> >>> +			wake_up_all(&ei->i_ordered_wq);
> >>> +			return ret;
> > 
> > Okay so even if the ordered IO fails we still let the i_disksize updates
> > go ahead? 
> 
> Yes when data_err=ignore, no when data_err=abort.
> 
> > I think this is a deviation from the current behavior where we
> > abort the journal. If this is acceptable we should atleast add a comment
> > on why its okay.
> > 
> 
> I think this behavior is consistent with the current data=ordered mode.
> In the data_err=ignore mode, if an I/O write fails, ext4_end_io_end()
> does not abort the journal, so i_disksize is still updated normally.
> Conversely, in the data_err=abort mode, the journal is aborted, and
> since i_disksize is not updated, it cannot be updated afterwards. Am I
> missing something?

So I was thinking about various scenarios where
filemap_fdatawrite_range() might return an ERROR and yes it seems like
we do end up aborting the journal for almost all paths and ENOMEM is
already taken care of. So I think it should be okay.
> 
> >>> +		}
> >>> +	}
> >>>  	return 0;
> >>>  }
> >>>  
> >>> @@ -4827,10 +4890,13 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
> >>>  		 * data=ordered mode. We submit zeroed range directly here.
> >>>  		 * Do not wait for I/O completion for performance.
> >>>  		 *
> >>> -		 * TODO: Any operation that extends i_disksize (including
> >>> -		 * append write end io past the zeroed boundary, truncate up,
> >>> -		 * and append fallocate) must wait for the relevant I/O to
> >>> -		 * complete before updating i_disksize.
> >>> +		 * The end_io handler ext4_iomap_wb_ordered_wait() will wait
> >>> +		 * for I/O completion before updating i_disksize if the write
> >>> +		 * extends beyond the zeroed boundary.
> >>> +		 *
> >>> +		 * TODO: Any other operation that extends i_disksize
> >>> +		 * (including truncate up and append fallocate) must wait for
> >>> +		 * the relevant I/O to complete before updating i_disksize.
> >>>  		 */
> >>>  		} else if (ext4_inode_buffered_iomap(inode)) {
> >>>  			err = ext4_iomap_submit_zero_block(inode, from, end);
> >>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> >>> index 3050c887329f..ad05ebb49bf6 100644
> >>> --- a/fs/ext4/page-io.c
> >>> +++ b/fs/ext4/page-io.c
> >>> @@ -613,6 +613,46 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
> >>>  	return 0;
> >>>  }
> >>>  
> >>> +/*
> >>> + * If the old disk size is not block size aligned and the current
> >>> + * writeback range is entirely beyond the old EOF block, we should
> >>> + * wait for the zeroed data written in ext4_block_zero_eof() to be
> >>> + * written out, otherwise, it may expose stale data in that block.
> >>> + */
> >>> +static void ext4_iomap_wb_ordered_wait(struct inode *inode,
> >>> +				       loff_t pos, loff_t end)
> >>> +{
> >>> +	struct ext4_inode_info *ei = EXT4_I(inode);
> >>> +	unsigned int blocksize = i_blocksize(inode);
> >>> +	loff_t disksize = READ_ONCE(ei->i_disksize);
> >>> +	ext4_lblk_t order_lblk, order_len;
> >>> +
> >>> +	/*
> >>> +	 * Waiting for ordered I/O is unnecessary when:
> >>> +	 * - The on-disk size is block-aligned (no stale data exists).
> >>> +	 * - The write start is within the block of the old EOF
> >>> +	 *   (overwriting, or appending to a block that already contains
> >>> +	 *   valid data).
> >>> +	 */
> >>> +	if (!(disksize & (blocksize - 1)) ||
> >>> +	    pos < round_up(disksize, blocksize))
> >>> +		return;
> > 
> > Okay these checks are pretty confusing. I was intially thinking that
> > i_disksize's block would always be equal to i_ordered_lblk but seems
> > like that is not true because ext4_block_zero_eof() uses from=i_size.
> 
> Yeah, this is the key point that I was a bit confused about as
> well.
> 
> > 
> > So we could have a sequence where
> > 
> > 1. truncate 4k (i_disksize = i_size = 4k)
> > 2. write 8k,10k (i_disksize = 4k i_size = 10k, i_ordered_len = 0 (old isisze  is block aligned)) 
> > 3. write 16k,18k (i_disksize = 4k i_size = 10k, i_ordered_len = 1, lblk=4)
>                                              18k                     lblk=2, (10k >> 12)
                                               ^^^ Yess correct, my bad.
> > 
> > Here we issue ordered IO even though it' probably not needed.  Now if
> > write 3 finishes first we see disksize as 4k so we don't wait for
> > ordered write. Which seems okay since we don't risk any stale data
> > exposure. However, this flow is pretty confuing.
> 
> Indeed!
> 
> > 
> > Can't we somehow avoid having to issue/set ordered len/lblk in case it
> > is not really needed, like only issue it if i_disksize (and not i_size) 
> > is unaligned. That can simplify some of our check and avoid extra IO
> > overhead.
> > 
> 
> I was also planning to explore optimizations on this point next.
> However, since the original logic in buffer_head already works this way,
> keeping the same logic in the iomap path will not introduce any
> additional side effects. To avoid unnecessary waiting, I simply added
> the disksize alignment check in ext4_iomap_wb_ordered_wait().
> 
> Therefore, I do not plan to implement this optimization in this series.
> I can open a separate series later to address this optimization — perhaps
> by checking i_disksize in ext4_block_zero_eof() before issuing or adding
> ordered I/O, and the buffer_head path might also benefit from optimization.
> Meanwhile, to avoid confusion, I can add a TODO comment in this patch.
> 
> What do you think?

Sure Zhang, such an optimization would make the code simpler but I'm
okay to do this in a different series.

Regards,
ojaswin

> 
> Cheers,
> Yi.
> 
