Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EE93314C2;
	Fri, 31 Jul 2026 12:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499657; cv=none; b=qUG0QSGaUUFWt0OYKj3x/2LCIWVCZc9b8xQjI2Mcnrmyleld3u8u7kcClw3AAX9dPyACyzufmHPIDPs+whzO57cwq1TGEHhmIvMNiD5Fwgt6Smq18RT2AL8HlfrhnrRvOVyycM/7jpGkbiLHcQQqiT6URyYHpaDNUCkRTyk0bgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499657; c=relaxed/simple;
	bh=K+/FjAZ2MgUyDheH6dlzUjWTX2T/yGXuR+X2JmozGUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DnzOKNbNL3UnJpR2Oucuz80G3ipYXgBcsX0YgkPEIIoqyZJV2A8yE0qipJp9wIFIr7r5kjSerb4ub1ukQpOQOxgKdULa07CpyskRMVFXIRim+Lr8eSpcsAE0jABS+1XvITHw25CIlAX7+bjKuTZ3BBK6KvetioEFHi1BN54GdNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LnaumRwF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LnaumRwF"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VBm3UG1673725;
	Fri, 31 Jul 2026 12:06:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=uSK2lTv85a+TmXKOZhBLw6yyeP2Bmg
	ax2Nic6Ibhkho=; b=LnaumRwFX88Bzbi38lcP72OwULwUIkjZLvs3hpoY3GAN11
	LZyXX+S05rOhRO4O802e451BTi5B90ZrmwM4Yh2sV3zuLVQIe+amOcz58pbtYD3a
	M6Xb262JaJZRxegFT/hMlvc2O4iSlQXk7QjqPwg5K2yER2HtYj3BTI/p5/xRPIm8
	jxc9yUFTAqVxkTmJoiBZjgvicAzfZWIp+aNlX4rbN9AuCatkFRwjcEOm51nYsXY2
	PrsYqkEuu3OuirmlnPJobvwVwagAwDjPVoCnYt5t2JL7Ap8y95TejZlxd15O+e/C
	AIGeW/bTxns6nfNlp8/vp9DXuwOlyoDx1nAFd8pg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0p3u8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 12:06:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VBuN2D018721;
	Fri, 31 Jul 2026 12:06:56 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5yfh2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 12:06:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VC6sV535062088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 12:06:55 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C63FE2004B;
	Fri, 31 Jul 2026 12:06:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68A0920043;
	Fri, 31 Jul 2026 12:06:51 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.209.143])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 Jul 2026 12:06:51 +0000 (GMT)
Date: Fri, 31 Jul 2026 17:36:48 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com,
        yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 2/2] ext4: protect WRITE_ZEROES written extents with
 orphan list
Message-ID: <amyP2KXXgLUC0_aC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
 <20260729085918.3336221-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729085918.3336221-3-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA5MCBTYWx0ZWRfXzv3RYgLNKl2J
 ac1j0TPB4434mrUjHHBD7R/+i+7bDRjfucJB3BGKT8KhToTEWN01pL3v+7pkseDas291b4LZn6L
 4S1tXAtyqJ6hpRjybw3RLdA7w+dpz9Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA5MCBTYWx0ZWRfX5cOAvRjLnR/Q
 V0D63+NZZ8qNaB586hRyt4IoihO4Sc6iV5FpBazyqqWPmnPmEx5MmkjkNePJkV0XJksBOT9+lDK
 e4E+dZkWixToyKth8LTdL+oJGa/8vthoPNAgH40vi1nf3oVVIWHfKj7+oq/Ltw80GbGuchfuCwc
 1EZ98FCt5CGI85FXxAH2EIMinU5Uq36Fmqx1MJdOdAgYw7D3hPZLkHVVjOY7sxK2FOReidpHZw7
 gllveQdOtJV1po81kGmuu1KbVvOJ8NroLjqg/aOf/665/aJ/CpPBRzlgvHv72T4nROoHzUPkpS4
 AgWX+SWhiqwbi34AhuOyHvKLSuZstJ+irxymns9QQzRADobz+YFYpPjzVlFO2u7Cwv0L9CnDWqJ
 3QJdmbcx5Pd3W0qpEqrVJpkCnO/NOFYD3qvIbanlsnBsZPXyhPeiXXOoUcK+ctVgiYRcmJbaC7A
 e8IN+XiJWZAvj1vDgOA==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6c8fe1 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8 a=ZwBjl90vFf3K6bS7ZlIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: vkVOJJGGotHY3WSZHcWqo_ejhEbvjUMk
X-Proofpoint-ORIG-GUID: LseUXJEJczfbWpo4eOekYwq2HvhVKKhO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310090

On Wed, Jul 29, 2026 at 04:59:18PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
> extents to written in one transaction, while i_disksize is updated to
> cover them only in a later transaction. A crash in between leaves
> written extents beyond i_disksize on disk, which fsck will complain
> about.
> 
> To fix this, add the inode to the orphan list in the same handle that
> does the conversion, and remove it once i_disksize has caught up.
> Also add a sanity check to ensure conversion does not extend beyond EOF.
> 
> Since ext4_alloc_file_blocks() is called from the fallocate() path,
> partial allocation is safe. On partial conversion failure, advance
> i_disksize only up to the boundary of successfully converted blocks, so
> that orphan cleanup sees a consistent state. Document this behavior in
> the function comment.

Hi Yi,

Look good,

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Just a small question below:
> 
> Reported-by: Jan Kara <jack@suse.cz>
> Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/extents.c | 78 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 70 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 1ab1a6e2ed83..a3dde7ba0d23 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4571,6 +4571,22 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  	return err;
>  }
>  
> +/*
> + * Pre-allocate blocks for the range [@offset, @offset + @len). Allocated
> + * blocks are marked as unwritten by default. If EXT4_GET_BLOCKS_ZERO is
> + * set, the allocated blocks are zeroed on disk and their extents are
> + * converted to written state.
> + *
> + * When @new_size is nonzero, the caller intends to extend the file, and
> + * the file size should be updated to the end of the allocated blocks.
> + *
> + * Allocation may partially succeed due to some non-fatal issues. In that
> + * case, i_disksize (and i_size) is advanced up to the successfully
> + * processed portion of the range.
> + *
> + * Return 0 on success, or a negative error code on failure or partial
> + * failure.
> + */
>  static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  				  loff_t new_size, int flags)
>  {
> @@ -4585,6 +4601,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	loff_t epos = 0, old_size = i_size_read(inode);
>  	unsigned int blkbits = inode->i_blkbits;
>  	bool alloc_zero = false;
> +	bool orphan = false;
>  
>  	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
>  	map.m_lblk = offset >> blkbits;
> @@ -4659,19 +4676,49 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  
>  		if (alloc_zero &&
>  		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
> +			ext4_lblk_t converted;
> +
> +			WARN_ON_ONCE(map.m_lblk + map.m_len >
> +				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
> +
>  			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
>  						 map.m_len);
> -			if (likely(!ret))
> -				ret = ext4_convert_unwritten_extents(NULL,
> -					inode, (loff_t)map.m_lblk << blkbits,
> -					(loff_t)map.m_len << blkbits, NULL);
> -			if (ret)
> +			if (unlikely(ret))
>  				break;
> +
> +			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> +						    credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				break;
> +			}
> +
> +			ret = ext4_convert_unwritten_extents(handle,
> +					inode, (loff_t)map.m_lblk << blkbits,
> +					(loff_t)map.m_len << blkbits,
> +					&converted);
> +			if (ret)
> +				map.m_len = converted;
> +
> +			/*
> +			 * If blocks beyond i_disksize are converted, add
> +			 * the inode to the orphan list and advance the epos.
> +			 */
> +			if (new_size && converted) {
> +				ret2 = ext4_orphan_add(handle, inode);
> +				ret = ret ? ret : ret2;
> +				orphan = true;
> +			}
> +
> +			ret3 = ext4_journal_stop(handle);
> +			ret = ret ? ret : ret3;
>  		}
>  
>  		map.m_lblk += map.m_len;
>  		map.m_len = len_lblk = len_lblk - map.m_len;
>  		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
> +		if (ret)
> +			break;
>  	}
>  
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> @@ -4687,11 +4734,23 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	if (epos > new_size)
>  		epos = new_size;
>  
> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> -	if (IS_ERR(handle))
> -		return ret ? ret : PTR_ERR(handle);
> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
> +	if (IS_ERR(handle)) {
> +		/*
> +		 * The conversion has successfully completed. Not much to
> +		 * do with the error here so just cleanup the orphan list
> +		 * and hope for the best.
> +		 */
> +		if (orphan && inode->i_nlink)
> +			ext4_orphan_del(NULL, inode);
> +		ret2 = PTR_ERR(handle);
> +		goto out;
> +	}
>  
>  	ext4_update_inode_size(inode, epos);
> +	if (orphan && inode->i_nlink)
> +		ext4_orphan_del(handle, inode);
> +

So I believe the i_nlink check is incase the inode is already at i_nlink
= 0 before the fallocate() was called and hence mostly already on the
orphan list. We need to skip deletion from the list as inode eviction
will handle cleaning it up, right?


>  	ret2 = ext4_mark_inode_dirty(handle, inode);
>  	ext4_update_inode_fsync_trans(handle, inode, 1);
>  	ret3 = ext4_journal_stop(handle);
> @@ -4699,6 +4758,9 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  
>  	if (epos > old_size)
>  		pagecache_isize_extended(inode, old_size, epos);
> +out:
> +	if (ret2)
> +		ext4_std_error(inode->i_sb, ret2);
>  
>  	return ret ? ret : ret2;
>  }
> -- 
> 2.52.0
> 
