Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB36413D74;
	Wed, 27 May 2026 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779889323; cv=none; b=k77xFzUbkjPvPzw225v/srEC/AtgxlpCBCLmUhfIsGN0yDKyt6HOZriubOBUs3mJac0LJMFLzAdU7iZx9JLG31txGLwGtW04KFjA+d1FptF9R9evWs/TSgKZ2wHr1iNxKJgdfqpcVD8eHcjR94TaQ8LugRwHcZmSK7J09QgnKkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779889323; c=relaxed/simple;
	bh=oMx6J7AN8emCbUB+h32N6MvbicNYPfIeIi4TIRf7wF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M9Ow2Dq7gSORRc6j16viGzOXM2uSrCVJP8wE4uO5m4ECYQI9xRaO3Eo3ppzoG3xwCkryA8Ej7k9X9XUeo8dzoRN3yFr8uECxVI/yBv2bWiAgXwrGHStc7gSZRSaZMEvo1E2sWtqHPBzmXGuCbRuxcuUQ3TQ5bZ0xd1nN5Jg6xOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W1LTPcSi; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W1LTPcSi"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCsPmo347546;
	Wed, 27 May 2026 13:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=VwbnxywsCeQWw/XQ9PuNQlhqEtz3DQ
	kNqqH2MMFaqOI=; b=W1LTPcSimqT5/V1najG49BwBfeAnzJqOuFOLKXSWzRJM1R
	59HD5lqJq6iS3eb495yS+ngVHMdvZO72NZRNDlsKaArpEnAdm55efPQOwiWhgPDc
	ffYyuZSU372Vu2OzTCZ6+ssgJL2mg8ERIyYQguIWtvbj9RtzuN+AtRjJ8Z4rqs0A
	e04uGMFZk0pf3uVSJKdXXnEAhB6Jx1xi3PVJLtvcIBH6iTepVyvOcVA71JPOPRWK
	hAmMrmO/YuS3CpZQryiqFrfGi3kOPamcqPLIfFu/D4ZgTVWG5XXJ9T6AU+GyIgvX
	nHh+bhu+Szo9UI4DpVFznuINSgi6eKp3Vzfj1uew==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4nusnns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 13:41:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64RDd7iS002198;
	Wed, 27 May 2026 13:41:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4edjrbu7n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 13:41:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64RDfRu527263250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 May 2026 13:41:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EC9520043;
	Wed, 27 May 2026 13:41:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4364D20040;
	Wed, 27 May 2026 13:41:22 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.21.79])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 27 May 2026 13:41:21 +0000 (GMT)
Date: Wed, 27 May 2026 19:11:18 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 17/23] ext4: submit zeroed post-EOF data immediately
 in the iomap buffered I/O path
Message-ID: <ahb0fqVCige08_--@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-18-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-18-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDEzMyBTYWx0ZWRfX0k2KiTxCDq4P
 Ml4F4HgWmO7yOdMZztIeUc+rX8TC9QgHC6HEyM8+gRX23/d1SmsT3c4vwCSKkIxjAj6Rd2wclXU
 +/sgq0LYzmLlphmLmSiN1sh7OV+0QH3ap5its58k0Yf54OFhZOCaxBaE7/WpAerIVbOJpywJ2Yh
 ojRLvo599U9RtuSZnIivY3nPIwRmbknfqccSJLmAAlfhJJjerU2Y/saEIXsANJNwZHuRPldyVQi
 pcnQ/CRkM961JCzqWm4r+yUFTw/+Xz3cY7bekfk7JYVUqXxAQiUsCyodlu9FWBL6ri8qWJ/ow1c
 uTwWlgtrsLuxVCOCWo62YJo4O197a6k8lGVO3VCbLXT5328SSXkWTfsdxuK5VBTVjU20xejoVqd
 qVzkauBwQRf7eqsFX7cyh+wIh2wQa2BUP/EQ7yn2/19v5Y+bSMrwJxsUClb3t7ARaZs8xL6AJ1i
 6zP3rsw0zyTmXod1BOQ==
X-Authority-Analysis: v=2.4 cv=UtJT8ewB c=1 sm=1 tr=0 ts=6a16f48b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=wxH9mAMQY-f9BlfH-WQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: L7qxiuQjoL-ozwtZZ1r51cuu13QJF762
X-Proofpoint-GUID: STTNdnwfcIWn6aM7ntWg00jkGcKQVlLR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605270133

On Mon, May 11, 2026 at 03:23:37PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In the generic buffered_head I/O path, we rely on the data=order mode to
> ensure that the zeroed EOF block data is written before updating
> i_disksize, thus preventing stale data from being exposed.
> 
> However, the iomap buffered I/O path cannot use this mechanism. Instead,
> we issue the I/O immediately after performing the zero operation
> (without synchronous waiting for performance). This can reduce the risk
> of exposing stale data, but it does not guarantee that the zero data
> will be flushed to disk before the metadata of i_disksize is updated.
> The subsequent patches will wait for this I/O to complete before
> updating i_disksize.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

I think we discussed that we may not need to do this [1] but I guess
you've decided to make the tradeoff of issuing the IO to avoid having to
wait for bg flush to complete the tail page zeroing 

However, I think one side effect might be many threads calling the
writeback mechanism to issue zero IOs which might not scale well. I
don't know if it'll be a huge problem though, I guess it's a sort of
thing we will have to deal with in case we see it in real world
workloads.

[1] https://lore.kernel.org/linux-ext4/yhy4cgc4fnk7tzfejuhy6m6ljo425ebpg6khss6vtvpidg6lyp@5xcyabxrl6zm/

> ---
>  fs/ext4/inode.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 55 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 239d387ffaf2..e013aeb03d7b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4742,6 +4742,32 @@ static int ext4_block_zero_range(struct inode *inode,
>  					zero_written);
>  }
>  
> +static int ext4_iomap_submit_zero_block(struct inode *inode,
> +					loff_t from, loff_t end)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	struct folio *folio;
> +	bool do_submit = false;
> +
> +	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
> +	if (IS_ERR(folio))
> +		/* Already writeback and clear? */
> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
> +
> +	folio_wait_writeback(folio);
> +	WARN_ON_ONCE(folio_test_writeback(folio));
> +
> +	if (likely(folio_test_dirty(folio)))
> +		do_submit = true;
> +	folio_unlock(folio);
> +	folio_put(folio);
> +
> +	/* Submit zeroed block. */
> +	if (do_submit)
> +		return filemap_fdatawrite_range(mapping, from, end - 1);
> +	return 0;
> +}
> +
>  /*
>   * Zero out a mapping from file offset 'from' up to the end of the block
>   * which corresponds to 'from' or to the given 'end' inside this block.
> @@ -4765,8 +4791,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>  		return 0;
>  
> -	if (length > blocksize - offset)
> +	if (length > blocksize - offset) {
>  		length = blocksize - offset;
> +		end = from + length;
> +	}
>  
>  	err = ext4_block_zero_range(inode, from, length,
>  				    &did_zero, &zero_written);
> @@ -4781,18 +4809,34 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	 * TODO: In the iomap path, handle this by updating i_disksize to
>  	 * i_size after the zeroed data has been written back.
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
> -		if (err)
> -			return err;
> +			err = ext4_jbd2_inode_add_write(handle, inode, from,
> +							length);
> +			ext4_journal_stop(handle);
> +			if (err)
> +				return err;
> +		/*
> +		 * inodes using the iomap buffered I/O path do not use the
> +		 * data=ordered mode. We submit zeroed range directly here.
> +		 * Do not wait for I/O completion for performance.
> +		 *
> +		 * TODO: Any operation that extends i_disksize (including
> +		 * append write end io past the zeroed boundary, truncate up,
> +		 * and append fallocate) must wait for the relevant I/O to
> +		 * complete before updating i_disksize.
> +		 */
> +		} else if (ext4_inode_buffered_iomap(inode)) {
> +			err = ext4_iomap_submit_zero_block(inode, from, end);
> +			if (err)
> +				return err;
> +		}
>  	}
>  
>  	return 0;
> -- 
> 2.52.0
> 
