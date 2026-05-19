Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97802F4A18;
	Tue, 19 May 2026 06:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779170818; cv=none; b=OLApDjKRnJB7aBCCLXP6XpyJbnjw8o/6PsBikyTe+IML5IVZmuQW/DGzTe60mQUYNDEmN/pNULg6rZL0VmV9/i8qM1fiM+rTYluR4IpLQ1fUa/Zp1W2dgvqx4+NQw+6PLsjHqBNEEiWy+c2eSVaQ//Hb0AWwrBcMtnpYd+V8oe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779170818; c=relaxed/simple;
	bh=WujDTHZ6VOC+uEuOftqUZ9/hyvUA26mEunuODmgURGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2tn+KugCmSUgB+6AUzTuo85L3kovgEBwgSVpL5HMHX9rZR6f8pYLkq8admCo3T81ZLP1t93qR43YXFzYXCvPpuCcIBkUNy6pP3NybUbBM1p5+UBhJE7N/46ll92kPJmvXFTJqmjSas96rlHCKs+kIVssWV03awmdIUZk2IkMCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ctp0vHQ0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ctp0vHQ0"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J3NVC31522114;
	Tue, 19 May 2026 06:06:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=jwlJ26EuyZ0ANyZRA/m0JbqZABTTZv
	DTrmNqAVZlaQM=; b=Ctp0vHQ0n4V4hHQlIxo2T7FwKhBTCI1La3dcYeiRbM1bp0
	uEncoMeHeyYwncrtI+bLqyjsuNwHmjuRPCFbgt5Ny4mnA5Xsigh6/yk9hAGbLjrx
	I48eUge27o6rNRJAWF0JBigP713th1Tv4NN7b9jnpA/qBJtp4ZaA5WepOTfu7RnI
	7UryNjBwR4yzbWQOBhh0CtAXrss0N1cRTCgg1BgLptfRs+b6+c7t0XgHTGS9rVec
	isF4DgtcKMD0blHnAyZdQnixWlGdbNygg1NYWc9IEVcPsg4aFVryAy9uS1LZRyOc
	uHXrGWR+tLfvU0vv/5tB6nT87uNR7ssFBp+PlUwA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9xugdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 06:06:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J5s6gP020457;
	Tue, 19 May 2026 06:06:17 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739vsccw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 06:06:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64J66FqR31326534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 06:06:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CBC02004B;
	Tue, 19 May 2026 06:06:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C18D320040;
	Tue, 19 May 2026 06:06:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 06:06:06 +0000 (GMT)
Date: Tue, 19 May 2026 11:35:52 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 02/23] ext4: factor out ext4_truncate_[up|down]()
Message-ID: <agv9wMSnis6snAEB@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-3-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDA1NyBTYWx0ZWRfX+K58mrFum6fs
 ZBcp/sJb1NUSVAV1Pjnm4fzq4V9yWT91MHRjwk/wy72N+Etuc+IKoLPx2f+o9u0Niz90Bf3qH7u
 OzlkrVTuKwvzcFsnh2yFCVKBTN/XnbINLr3Wgi4DCFqEN8auIXaFHELqw7JyYopHQbugzBbQ0b/
 cjVmAVh6wKThIuIl2K1/76a/jL5ujwvNn5bGfnGckWzM8lOzJllfugE101AiqdlyWQjx1q1XD0l
 T54wwBbcZRou0gT3tzLwBJHwLJxvehwam2rCjxtUPMR3ivg9nMzd7B8iGOkwTThrs3dm5V008Me
 vwAxGmA8jJ0Axr+cV4Lc3+Hm3+8+0Zs1KavjrwI+6Mzlo3XMGGScXTIg80HcjZuMoyY90JsDXSE
 BmZDhyMqDvZ4o/Pb/uFEt+G4weYEdxaj1HYawC+OKSxVwAl8XFOD5YVG3NvZBJiQTneI56OXk31
 ZKZ4RDYV3dWtzGAtiQw==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0bfdda cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=rP1TTDdk-FEn1c5iRHgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 4Yzmnf790dx10jH8lcIgxRV6hJy7BjFT
X-Proofpoint-GUID: 2HjABCTuy6CwgrT0LO0W9pzjJszewXRv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190057

On Mon, May 11, 2026 at 03:23:22PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Refactor ext4_setattr() by introducing two helper functions,
> ext4_truncate_up() and ext4_truncate_down(), to handle size changes. The
> current ATTR_SIZE processing consolidates checks for both shrinking and
> non-shrinking cases, leading to cluttered code. Separating the
> truncation paths improves readability.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>


Looks good to me Zhang:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>


> ---
>  fs/ext4/inode.c | 199 +++++++++++++++++++++++++++---------------------
>  1 file changed, 112 insertions(+), 87 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0751dc55e94f..35e958f89bd5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5855,6 +5855,112 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
>  	}
>  }
>  
> +/*
> + * Set i_size and i_disksize to 'newsize'.
> + *
> + * Both i_rwsem and i_data_sem are required here to avoid races between
> + * generic append writeback and concurrent truncate that also modify
> + * i_size and i_disksize.
> + */
> +static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
> +{
> +	WARN_ON_ONCE(S_ISREG(inode->i_mode) && !inode_is_locked(inode));
> +
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	i_size_write(inode, newsize);
> +	EXT4_I(inode)->i_disksize = newsize;
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +}
> +
> +static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
> +{
> +	ext4_lblk_t old_lblk, new_lblk;
> +	handle_t *handle;
> +	int ret;
> +
> +	if (!IS_ALIGNED(oldsize | newsize, i_blocksize(inode))) {
> +		ret = ext4_inode_attach_jinode(inode);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +	if (!IS_ALIGNED(oldsize, i_blocksize(inode))) {
> +		ret = ext4_block_zero_eof(inode, oldsize, LLONG_MAX);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	old_lblk = oldsize > 0 ? (oldsize - 1) >> inode->i_blkbits : 0;
> +	new_lblk = newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
> +	ext4_fc_track_range(handle, inode, old_lblk, new_lblk);
> +
> +	ext4_set_inode_size(inode, newsize);
> +
> +	ret = ext4_mark_inode_dirty(handle, inode);
> +	ext4_journal_stop(handle);
> +	if (ret)
> +		return ret;
> +	/*
> +	 * isize extend must be called outside an active handle due to
> +	 * the lock ordering of transaction start and folio lock in the
> +	 * iomap buffered I/O path (folio lock -> transaction start).
> +	 */
> +	pagecache_isize_extended(inode, oldsize, newsize);
> +	return 0;
> +}
> +
> +static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
> +			      loff_t newsize, int *orphan)
> +{
> +	ext4_lblk_t start_lblk;
> +	handle_t *handle;
> +	int ret;
> +
> +	/* Do not change i_size. */
> +	if (newsize == oldsize)
> +		goto truncate;
> +
> +	/* Shrink. */
> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	if (ext4_handle_valid(handle)) {
> +		ret = ext4_orphan_add(handle, inode);
> +		*orphan = 1;
> +		if (ret) {
> +			ext4_journal_stop(handle);
> +			return ret;
> +		}
> +	}
> +
> +	start_lblk = newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
> +	ext4_fc_track_range(handle, inode, start_lblk, EXT_MAX_BLOCKS - 1);
> +
> +	ext4_set_inode_size(inode, newsize);
> +
> +	ret = ext4_mark_inode_dirty(handle, inode);
> +	ext4_journal_stop(handle);
> +	if (ret)
> +		return ret;
> +
> +	if (ext4_should_journal_data(inode))
> +		ext4_wait_for_tail_page_commit(inode);
> +truncate:
> +	/*
> +	 * Truncate pagecache after we've waited for commit in data=journal
> +	 * mode to make pages freeable.  Call ext4_truncate() even if
> +	 * i_size didn't change to truncatea possible preallocated blocks.
> +	 */
> +	truncate_pagecache(inode, newsize);
> +	return ext4_truncate(inode);
> +}
> +
>  /*
>   * ext4_setattr()
>   *
> @@ -5951,7 +6057,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	}
>  
>  	if (attr->ia_valid & ATTR_SIZE) {
> -		handle_t *handle;
>  		loff_t oldsize = inode->i_size;
>  		int shrink = (attr->ia_size < inode->i_size);
>  
> @@ -6003,94 +6108,14 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  			goto err_out;
>  		}
>  
> -		if (attr->ia_size != inode->i_size) {
> -			/* attach jbd2 jinode for EOF folio tail zeroing */
> -			if (attr->ia_size & (inode->i_sb->s_blocksize - 1) ||
> -			    oldsize & (inode->i_sb->s_blocksize - 1)) {
> -				error = ext4_inode_attach_jinode(inode);
> -				if (error)
> -					goto out_mmap_sem;
> -			}
> -
> -			/*
> -			 * Update c/mtime and tail zero the EOF folio on
> -			 * truncate up. ext4_truncate() handles the shrink case
> -			 * below.
> -			 */
> -			if (!shrink) {
> -				inode_set_mtime_to_ts(inode,
> -						      inode_set_ctime_current(inode));
> -				if (oldsize & (inode->i_sb->s_blocksize - 1)) {
> -					error = ext4_block_zero_eof(inode,
> -							oldsize, LLONG_MAX);
> -					if (error)
> -						goto out_mmap_sem;
> -				}
> -			}
> -
> -			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
> -			if (IS_ERR(handle)) {
> -				error = PTR_ERR(handle);
> -				goto out_mmap_sem;
> -			}
> -			if (ext4_handle_valid(handle) && shrink) {
> -				error = ext4_orphan_add(handle, inode);
> -				orphan = 1;
> -				if (error)
> -					goto out_handle;
> -			}
> -
> -			if (shrink)
> -				ext4_fc_track_range(handle, inode,
> -					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
> -					inode->i_sb->s_blocksize_bits,
> -					EXT_MAX_BLOCKS - 1);
> -			else
> -				ext4_fc_track_range(
> -					handle, inode,
> -					(oldsize > 0 ? oldsize - 1 : oldsize) >>
> -					inode->i_sb->s_blocksize_bits,
> -					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
> -					inode->i_sb->s_blocksize_bits);
> -
> -			/*
> -			 * We have to update i_size under i_data_sem together
> -			 * with i_disksize to avoid races with writeback code
> -			 * updating disksize in mpage_map_and_submit_extent().
> -			 */
> -			down_write(&EXT4_I(inode)->i_data_sem);
> -			i_size_write(inode, attr->ia_size);
> -			EXT4_I(inode)->i_disksize = attr->ia_size;
> -			up_write(&EXT4_I(inode)->i_data_sem);
> -
> -			error = ext4_mark_inode_dirty(handle, inode);
> -out_handle:
> -			ext4_journal_stop(handle);
> -			if (error)
> -				goto out_mmap_sem;
> -			if (!shrink) {
> -				pagecache_isize_extended(inode, oldsize,
> -							 inode->i_size);
> -			} else if (ext4_should_journal_data(inode)) {
> -				ext4_wait_for_tail_page_commit(inode);
> -			}
> +		if (attr->ia_size > oldsize)
> +			error = ext4_truncate_up(inode, oldsize, attr->ia_size);
> +		else {
> +			/* Shrink or do not change i_size. */
> +			error = ext4_truncate_down(inode, oldsize,
> +						   attr->ia_size, &orphan);
>  		}
>  
> -		/*
> -		 * Truncate pagecache after we've waited for commit
> -		 * in data=journal mode to make pages freeable.
> -		 */
> -		truncate_pagecache(inode, inode->i_size);
> -		/*
> -		 * Call ext4_truncate() even if i_size didn't change to
> -		 * truncate possible preallocated blocks.
> -		 */
> -		if (attr->ia_size <= oldsize) {
> -			rc = ext4_truncate(inode);
> -			if (rc)
> -				error = rc;
> -		}
> -out_mmap_sem:
>  		filemap_invalidate_unlock(inode->i_mapping);
>  	}
>  
> -- 
> 2.52.0
> 
