Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A6C4248DB;
	Mon,  5 Oct 2026 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190885; cv=none; b=u96/EjDFS/prrCuQG4dqcxv33IJpK3pT55KH+SPfC0yuVhuKqSbvFsus3LlP/BanOdR2k0fkc1EVvmDqOHp5a3Bs1bmAD69vmw2q3kpKIb8ra2WhPcOREfcF/CKQWeWnN/cZyHUL7VuwZrhmw+TwvoVE+BGwR6mmF4FRC7Vt/p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190885; c=relaxed/simple;
	bh=OjfkQ5t9gq4A1MZQ34wLFmn63NFVsznplmhxK2HECo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1dJxOIaqnrzKekxCNhtbVyDe2SsEmoOtbWfggjVr9KXpXm6OwwYnwk3zN4k+nYhcq8dCc5OKMPBQ9IjhGn+uuR0tDTEADO+ewX3Rc/uevUtMr+FGftMONvJfQb+KCzI3/yfnJpRKGGw4YeChySoUtHOm54xjkWWhBjCeS1IX8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dWAS9sqI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dWAS9sqI"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69516hq23276412;
	Mon, 5 Oct 2026 08:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=/wYRHbfI/2gem1IeIHrnp1K88A+AM1
	xqgppGwdgPl7Q=; b=dWAS9sqIzJsM64o+Eloe8YSPCWzRER/eevfaYJHplSOQFW
	9Ho0ueJh0j1VqlhEYTErdrmFiGjjzFVV5F51Qfor7uddqmtJmov8A21B95ZJS9CW
	HKm8PlrO/cLou5BtOgRq1FbRU43J/nd56b5qhSo+17vWN9WbYnJem33FL9tDw8qw
	Jii3owJ1L0K8Zwxg8iUPwwiQrj86Ozf/dUnbfXjpA0NZ92Ue9zFpmxSBYIVda5de
	jOmUXAFfei8Memavrd40i9E4O6nOAglEKV7ePOjs03rvRW0+Q1wNkIFOw69tM7Ef
	SZaiZu3vh6zcoqHcy+zgVK2ncVT7gGGy+oyqANYA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2se598eu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 08:55:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6956D4wi2142304;
	Mon, 5 Oct 2026 08:55:30 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h3d1jmpge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Oct 2026 08:55:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6958tRtk44040462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Oct 2026 08:55:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1A082004F;
	Mon,  5 Oct 2026 08:55:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3478620040;
	Mon,  5 Oct 2026 08:55:24 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  5 Oct 2026 08:55:24 +0000 (GMT)
Date: Mon, 5 Oct 2026 14:25:21 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing
 unaligned EOF block
Message-ID: <asNl-SOu1im5mJhc@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-28-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-28-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDAzNCBTYWx0ZWRfX8dmOPVKE1BKU
 IengFcDvXkmA8bRjmFMNvEqp98oOyv4ziBoutwcWg0yTGfHzhxaLQN56tb926nNGoaKw3r3Xx2j
 doIV15x3ZKMEzEWbGc+DXhUeV7hmjmQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDAzNCBTYWx0ZWRfXxScJA0bf99kG
 HlwALChWOtb7wBBGy3h4hp1IWA1TPQbvj48nosgaC+oKa7lFKh1Z4SJT4wc1UqgrIsdpeCuqDEx
 PHtBA/YbgnC1nYyussNqgzgdGFg8VMuZBD9U+bl/get4xPBjjqscWPmtCBfI3rwi16eceyCX2rK
 j8WT9kVdC2pIoVNuBPXffeKd/IGL2eBvNhEK5IsNLzlKbXtdpYkJS4KJyV47cDpM3c92AFx94wa
 9wGqijoNi21foqi+D5OxCq4IOVe4kG3x9Qx/tQ2SNYa97ARCkarPYu4+qvkb4v1aGpfp5RPzA8E
 oa06e/RJ9rFUr/Y5ZcPVC1leOhu09sTLv/TF07+ZiQwgyf6qfbrjO3hPG5kW2Nxm8/N+Pvo+r5p
 /2u55m+7DJ7N09MJ7h4kcogECesJkS9bOsSgOsoaVsUT5ZS/nrHiBqg5NAqufzCicK1pb0mGpzE
 jguCBZLQ2HWtK8mHfwg==
X-Proofpoint-GUID: PSL9u9x0g5x_gVoogPnx-DnCaI43zVop
X-Authority-Analysis: v=2.4 cv=UNRIjyfy c=1 sm=1 tr=0 ts=6ac36603 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=i0EeH86SAAAA:8
 a=b-wJPGFqMEFMSlIollwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ORHW-RVSYKvdwpjGOxGKceHEu-mThKaq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_01,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050034

On Thu, Sep 03, 2026 at 08:35:39PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In the iomap buffered I/O path, data=ordered mode is not used, so the
> zeroed EOF block has no implicit ordering with later i_disksize updates.
> Without the pending state being set, i_disksize can be advanced past the
> zeroed block before writeback completes, exposing stale data after a
> crash.
> 
> Previous patches added the consumer side of the
> disksize-grow-pending mechanism: the state bit, clear and wait helpers,
> and ioend tagging. Now add ext4_iomap_mark_disksize_pending() and call
> it from ext4_block_zero_eof() after zeroing the tail of the block that
> straddles i_disksize.
> 
> The helper locks the folio, waits for any in-flight writeback on it to
> complete, then sets EXT4_STATE_DISKSIZE_GROW_PENDING only if the folio
> is still dirty. Waiting for writeback prevents folio_test_dirty() from
> returning false mid-writeback, which would cause us to skip the pending
> state while zeroed data is still in flight. The dirty check then avoids
> setting the bit when the data has already been written back.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Hey Zhang, so I've been looking at the last few patches
(DISKSIZE_GROW_PENDING) handling as a whole, and I have a race that I
think might hit. (This is assuming we will revert 3/31 patch here as its
buggy). Imagine the following set of operations:

    Initial state: i_size = i_disksize = 2k
    pwrite(4k,6k)
    pwrite(8k,10k)

    The following order might cause an issue:

    1. pwrite(4k,6k)
       - ext4_block_zero_eof(2k,4k)
         set inode state DISK_SIZE_GROW_PENDING
       - i_size=6k, i_disksize=2k
    2. writeback(2k,4k)
       - submits a GROW_IO ioend for 0,4k
       - i_size=6k, i_disksize=2k (unchanged)
    3. writeback(4k,6k)
       - Imainge here a parallel mmap has written beyond 6k so we have
         data past EOF
       - submits IO for 4k,8k
       - i_size=6k, i_disksize=2k (unchanged)
    4. IO for 3. completes (disk has data past 6kb now)
       - completion not called yet.
    5. pwrite(8k,10k)
       - ext4_block_zero_eof(6k,8k)
         DISK_SIZE_GROW_PENDING already set
       - i_size=10k, i_disksize=2k (updated)
    6. endio handler for 2.
       - Sees GROW_IO ioend, clears DISK_SIZE_GROW_PENDING
       - i_size=10k i_disksize=10k (updated)
    7. writeback (8k, 10k) for 5.
       - submits IO for 8k,12k
       - i_size=10k i_disksize=10k (unchanged)
    8. endio handler for 7.
       - Sees DISK_SIZE_GROW_PENDING cleared.
       - converts 8k,12k written.
       - i_size=10k i_disksize=10k (unchanged)
    9. end handler for 3.
       - Sees DISK_SIZE_GROW_PENDING cleared.
       - converts 4k,8k to written. This exposes 6k to 8k data
         which is zeroed in folio but not on disk yet.
       - i_size=10k i_disksize=10k (unchanged)
    10. **crash**
    11. We now have i_disksize of 10k with 6k to 8k written data that was
        supposed to be zeroed but is not

In this case, ideally 6. should not clear the DISKSIZE_GROW_PENDING
state and update the i_disksize. That should happen once the zero doen
in 5. is complete. I think, just having an inode state might not be
enough to handle such cases, we either might need an atomic counter or a
linked list of ranges.

But I'd first like to to hear your opinion on it to see if the race is
possible or did I miss something in the logic.

Regards,
ojaswin

> ---
>  fs/ext4/inode.c | 85 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 73 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8e8859c8f5b0..4cb0ea82f58c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4838,6 +4838,68 @@ static int ext4_block_zero_range(struct inode *inode,
>  					zero_written);
>  }
>  
> +/*
> + * Inodes using the iomap buffered I/O path do not use data=ordered mode.
> + * Therefore, we mark the inode as disksize-grow-pending after zeroing the
> + * EOF block. The zeroed block will be submitted before any subsequent
> + * data.
> + *
> + * In the I/O completion path, ext4_iomap_wb_disksize_pending_wait() will
> + * wait for I/O completion before advancing i_disksize if the write
> + * extends beyond the zeroed boundary.
> + *
> + * When zeroed I/O is in progress, operations that extend i_disksize are
> + * handled as follows:
> + *
> + *  - Truncate up, append fallocate and zero_range:
> + *    Defer the update. The file size will be updated to i_size by the
> + *    end_io handler once the ongoing pending I/O completes.
> + *
> + *  - Insert range and collapse range operations:
> + *    Wait synchronously for the relevant I/O to complete before updating
> + *    i_disksize.
> + */
> +static int ext4_iomap_mark_disksize_pending(struct inode *inode, loff_t from)
> +{
> +	struct folio *folio;
> +
> +	folio = filemap_lock_folio(inode->i_mapping, from >> PAGE_SHIFT);
> +	if (IS_ERR(folio))
> +		/* Already in writeback and cleared? */
> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
> +
> +	/*
> +	 * Ensure that in-flight writeback, possibly started after
> +	 * iomap_zero_range() unlocked the folio, has completed. Without
> +	 * this wait folio_test_dirty() below may miss the zeroed data
> +	 * (writeback clears PG_dirty), causing us to skip the
> +	 * disksize-grow-pending tracking and potentially expose stale
> +	 * on-disk data.
> +	 */
> +	folio_wait_writeback(folio);
> +	WARN_ON_ONCE(folio_test_writeback(folio));
> +
> +	/*
> +	 * Mark the inode as disksize-grow-pending. The zeroed block will
> +	 * be written out by the generic writepages cycle or any other
> +	 * syncing operation.
> +	 *
> +	 * Multiple overlapping unaligned EOF writes should not happen,
> +	 * because we only mark the pending state after zeroing the on-disk
> +	 * EOF block, and i_disksize can only be updated after the previous
> +	 * zeroed pending block has been written back or the dirty folio
> +	 * has been discared.
> +	 */
> +	if (likely(folio_test_dirty(folio) &&
> +		   !ext4_test_inode_state(inode,
> +					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
> +		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
> +
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	return 0;
> +}
> +
>  /*
>   * Submit and wait for the pending zeroed EOF block range to complete
>   * if the given range [@offset, @end) fully covers it.  Must be called
> @@ -4926,22 +4988,21 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	 * concurrent writeback that updates i_disksize. And if such a race
>  	 * occurs, it means the previous unaligned EOF block has already been
>  	 * zeroed (if needed) and persisted to disk.
> -	 *
> -	 * TODO: In the iomap path, handle this by tracking the ordered range
> -	 * and updating i_disksize to i_size after the zeroed data has been
> -	 * written back.
>  	 */
> -	if (ext4_should_order_data(inode) &&
> -	    did_zero && zero_written && !IS_DAX(inode) &&
> +	if (did_zero && zero_written && !IS_DAX(inode) &&
>  	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {
> -		handle_t *handle;
> +		if (ext4_should_order_data(inode)) {
> +			handle_t *handle;
>  
> -		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> -		if (IS_ERR(handle))
> -			return PTR_ERR(handle);
> +			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> +			if (IS_ERR(handle))
> +				return PTR_ERR(handle);
>  
> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
> -		ext4_journal_stop(handle);
> +			err = ext4_jbd2_inode_add_write(handle, inode, from,
> +							length);
> +			ext4_journal_stop(handle);
> +		} else if (ext4_inode_buffered_iomap(inode))
> +			err = ext4_iomap_mark_disksize_pending(inode, from);
>  		if (err)
>  			return err;
>  	}
> -- 
> 2.52.0
> 
