Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F13A38F94C;
	Sat, 10 Oct 2026 09:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791622884; cv=none; b=M9ULy7YFUootZ2cwA2eeafdLT2TYcrON8CwLCRbCdclntiEc4vbEwdB2YWfcYh2Dqmr4b5KpGFgK4d5XCm/1u7K+Z4t8oldx7GF+4x5NceI1m4wOa16lfilgw9/l3Lfjjimn0N/zSBP69rNL3fymWgnvk1XMygmlHgNQo1igTJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791622884; c=relaxed/simple;
	bh=O6l85+w1TSRGHbtvBp6FOHRdvpYZyGJRfYQERbvhTV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljTckPArUtQdhsb+8HScJaZigjr9JxXfnVWu1XfWK2XN6Fht4W5TBgCOqBjmQCyqoL02BteBnKpHc26eVVg4FmwR3k9BCLLzR5T2VBiO/YQA9Qro0TtcYsPxLz9/FzDqIeZ5Egee8NFX3sufRDSrOpuXwNcoXzUV5oNu3Uv7dU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QQJWsp0g; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QQJWsp0g"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69A46QhF1976254;
	Sat, 10 Oct 2026 09:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=/S0fRIvJI45/E1ds5T1XatICL/djyn
	P/ZrdqOPtcSZM=; b=QQJWsp0gZqWaWyQp5SJb98MJag8SaWnlLR/nUHru4wMlQO
	fSx7YZwUsFjW9dfwZVwNq7Qd9Fr4Z2WrSD51KllQcHd99IgoegbyknVj3PIsIc0J
	ARoJe5cRZ/x8HfMuReWuuCrjhTiu15+jPyb2lHZ6q4kKWu+KJyLMMZxHNw9YZlJy
	y3CrtdsIZw1ALhjkdDwEC5iEhneAy+fxkFmHGDkS1GsM8KZIWSddJnQxbRIYcMnF
	2lSu3Tzw7nPwrZevUQ27YUJfbm8iRQUao7o6R1kdKDA82iUXHVby1HWKKg0MrCSH
	Npt4dtsnMgd0X5Uu+WKOPcdqStmKz+RxHKis1+ew==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7e1vrq17-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 10 Oct 2026 09:00:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69A3Yn2C616100;
	Sat, 10 Oct 2026 09:00:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h7dk28qjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 10 Oct 2026 09:00:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69A90WXi48169286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 10 Oct 2026 09:00:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01F1F20040;
	Sat, 10 Oct 2026 09:00:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D925A2004B;
	Sat, 10 Oct 2026 09:00:27 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.27.132])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat, 10 Oct 2026 09:00:27 +0000 (GMT)
Date: Sat, 10 Oct 2026 14:30:25 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v7 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing
 unaligned EOF block
Message-ID: <asn-qfh9uWnabkJb@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-28-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009103033.2920530-28-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEwMDAzNCBTYWx0ZWRfXwTfUicuzOUWw
 IAl3reEHiVqvWMVU6U/QffAqlp2H7vWHlDV6DnkPm5EbfPcZs7NiNDPg5a7RfpSi7czJt5O/SMq
 LonHU/VUQWEwa7fiw4BAZL14LGluVE0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEwMDAzNCBTYWx0ZWRfX9j85V/sP/l6I
 FyvvPFFlCIRQ7QE2VdKvAsuzmFUPHYKaFg7aH5LkOFnZEiweCH1X9CTizdBci2q+5ieLx7acl1c
 NiFerdOeVwg8ZgDPpkPeBC3tghVlIR9B59jAFQs+uSx0JTziC0A6DwSEQQAQsJJWwX24ErSSCye
 OHySgkX8C5XGNOPK1zOLZX1zFTpn6+hY5k9Zh7mRwsNktWAfSZ7sOhvh9v6UmJ2xLTkGahXLh1w
 Bn+FmQjP20IbxAnpKqwublKO0CYmwje1rB54aauJ7iYLf5wifNRxyTrFbdVC3lznZdK0qOcht9T
 iTf08AFd+MzLcqUiSrpXFvXc2rYKEf137eXYXW8pysoyNFgUiSqbju0bSPfqy7+0lDAC09oLfHQ
 WEO/29avFt5UjYJvJbXSZpl8vA6AnLMgBPAdKDMZ0WBsknKGgZzI7oLcDHlOX548ers2frkJ/Ry
 2yU53HFsr39UOwaoPbg==
X-Authority-Analysis: v=2.4 cv=E6pYNqdl c=1 sm=1 tr=0 ts=6ac9feb3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=bgANVtWOW9sbm8Fv7u4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: x_lXwUpsiTfp6kobQW1Uh4NC2rrK6BsG
X-Proofpoint-GUID: g1CjOMplLlO1ys6Y4rwtoOrFkLUeNFEB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-10_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610100034

On Fri, Oct 09, 2026 at 06:30:28PM +0800, Zhang Yi wrote:
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
> ---
>  fs/ext4/inode.c | 106 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 94 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9b6916609000c..3bdb5f3b119ab 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4847,6 +4847,89 @@ static int ext4_block_zero_range(struct inode *inode,
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
> +	 * If the zeroed range does not overlap the existing on-disk tail
> +	 * block, the zeroed data lies beyond the currently on-disk data
> +	 * and will be written back before i_disksize is advanced past it,
> +	 * so no stale data can be exposed.
> +	 *
> +	 * Checking i_disksize here (after folio_wait_writeback()) is
> +	 * necessary and safe. If a delalloc writeback of this folio was
> +	 * in-flight, it could be raced by a concurrent mmap write which
> +	 * corrupts the tail block beyond i_size but the i_disksize is not
> +	 * advanced. folio_wait_writeback() has waited for its completion
> +	 * and the ioend has advanced i_disksize accordingly. If writeback
> +	 * had not started, we don't need to mark any pending state because
> +	 * any future writeback will carry the pagecache content that now
> +	 * includes the zeroed data, so no stale data can appear on disk
> +	 * even without the pending tracking.
> +	 */

Hey Zhang,

So in continuation for our discussion at [1], thanks for the info and
yes I think the race mentioned there cannot happen. But I was still
trying to look at this path for my own understanding and there's another
sequence of events I'd like to discuss with you. Mostly the same from
last but what if the writeback moves after
ext4_iomap_makr_zero_pending():  

    Initial state: i_size = i_disksize = 2k

    1. pwrite(4k,6k)
      - ext4_block_zero_eof(2k,4k)
          set inode state DISK_SIZE_GROW_PENDING
      - i_size=6k, i_disksize=2k
    2. writeback(2k,4k)
      - submits a GROW_IO ioend for 0,4k
      - i_size=6k, i_disksize=2k (unchanged)
    3. pwrite(8k,10k) - part 1
      - ext4_block_zero_eof(6k,8k)
      - zeroes 6k,8k
      - ext4_iomap_mark_zero_pending(from=6k)
        - folio is unlocked and not under writeback yet
        - keeps DISK_SIZE_GROW_PENDING set
      - iomap_write_iter not called yet...
    4. mmap write at (6k,8k)
      - I dont see anything stopping this?
      - i_size is still 6k so this is eof write.
    5. writeback(4k,6k)
      - submits IO for 4k,8k
      - i_size=6k, i_disksize=2k (unchanged)
    6. ioend for 2. (2k,4k)
      - clears DISKSIZE_GROW_PENDING
      - GROW_IO so i_disksize updated
      - i_size=6k, i_disksize=6k
    7. ioend for 5. (4k,8k)
      - DISKSIZE_GROW_PENDING is cleared
      - i_disksize=6k,i_size=6k - no updates
      - 4k,8k converted written - data beyond EOF from 4.
    8. 3. continues
      - enter iomap_write_iter
      - pagecache_i_size_extended()
        - page_mkwrite(6k folio) and mark dirty
        - zero 6k,8k
      - i_size=10k, i_disksize=6k
    9. writeback(8k,10k)
      - DISKSIZE_GROW_PENDING cleared so just submit (8k,10k)
    10. ioend for 8.
      - DISKSIZE_GROW_PENDING cleared so no waiting
      - i_size=10k, i_disksize=10k - updated
      - if we crash now, 6k,8k non-zero data exposed

I looked at the code surrounding ext4_iomap_mkwrite() and
ext4_buffered_write_iter() and I don't think there's any sort of
serialization against this sequence right? Or am I missing something
again :) 

Regards,
ojaswin

[1] https://lore.kernel.org/linux-ext4/179153611724.860602.5266334742364847927.b4-ty@b4/T/#m72e1710d172cf7699b6f05e29a270e45951800b0
> +	if (from >= round_up(READ_ONCE(EXT4_I(inode)->i_disksize),
> +			     i_blocksize(inode)))
> +		goto out;
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
> +	 * has been discarded.
> +	 */
> +	if (likely(folio_test_dirty(folio) &&
> +		   !ext4_test_inode_state(inode,
> +					  EXT4_STATE_DISKSIZE_GROW_PENDING)))
> +		ext4_set_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING);
> +out:
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	return 0;
> +}
> +
>  /*
>   * Submit and wait for the pending zeroed EOF block range to complete
>   * if the given range [@offset, @end) fully covers it.  Must be called
> @@ -4923,21 +5006,20 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	 * truncating up or performing an append write, because there might be
>  	 * exposing stale on-disk data which may caused by concurrent post-EOF
>  	 * mmap write during folio writeback.
> -	 *
> -	 * TODO: In the iomap path, handle this by tracking the ordered range
> -	 * and updating i_disksize to i_size after the zeroed data has been
> -	 * written back.
>  	 */
> -	if (ext4_should_order_data(inode) &&
> -	    did_zero && zero_written && !IS_DAX(inode)) {
> -		handle_t *handle;
> +	if (did_zero && zero_written && !IS_DAX(inode)) {
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
