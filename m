Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5BF3F9F28;
	Fri, 31 Jul 2026 12:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499320; cv=none; b=JvoLeirM0VisEeMihfVGpPJCL0oXhUL99AHlASMhOXL1Mag36LuA2rff9NLrx0HzD1/30Xp1lBIToujskpNvDeqgAi05rKUblIq4rBq5P7Ggpx36XiFq31+YfZEMO8rHV4neID9/5xDyWas6mxsBDnBQnlk0y7bXM2/RT2DNLpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499320; c=relaxed/simple;
	bh=X4s4AdfktinrK2VsZ3idw7YbGNMMsYAPcpeAPatgtMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FhrzucrCFRZJtZjobEtZNMzlSFyXx3aNJdn6d9nH1pUvLgubbvfuXwA4Fkvr6A9gu8JgO2iibbmx/VfC7biCsptRFmrvNfdlthiTwjG6iRmpwsbDJxB/zBOZqfdnCTyapmqvH816K1k1iszXLKHlc+9yPcY8mMR+dlWNo9kVbHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n+dzQPWU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n+dzQPWU"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VBm05F1791118;
	Fri, 31 Jul 2026 12:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=A1y0LKrTk+/GD8BxskcyTpW2M0G0HO
	huJ6ZOXX+nDKQ=; b=n+dzQPWUkP4Fieodlw1NNtWcx9xnMXJYXn+PGFAHq9qPk9
	d7S7XsfkODhCON7kgI3CnM21SlBbcz7HAygX3cF+99DawtAKbnXhV83Y4ejsA6VH
	yNxWLTrF/+I/MCQhwHAvJaOBj+jES4bIvjYvX+YrTSAScusBlS4skQDb2tZrzJIy
	y4BHH6RY37nAoMkKPTohrBse9RViKvc1rUCsYRjXK6UzDsWzAnUNbvs6YkQZSMER
	VGoYqma6kOL06NwRMSYeZnleNPG9wmU3bGR5998ldqhwBBkC88gWmpwN4zNwSdRf
	CIxV/5S6n72SNW94nL4z8mgV2g7YQd95JtPPGyFw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwdbucb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 12:01:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VBudNf021883;
	Fri, 31 Jul 2026 12:01:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhqp5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 12:01:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VC1ICA35062206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 12:01:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD95420043;
	Fri, 31 Jul 2026 12:01:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 515F420040;
	Fri, 31 Jul 2026 12:01:14 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.209.143])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 Jul 2026 12:01:14 +0000 (GMT)
Date: Fri, 31 Jul 2026 17:31:11 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com,
        yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 1/2] ext4: export converted block count from
 ext4_convert_unwritten_extents()
Message-ID: <amyOh8UfI47lDr_n@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
 <20260729085918.3336221-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729085918.3336221-2-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: g8AA7Oz1BHdxR-DWd_4fDcsEvXHcMoqL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA5MCBTYWx0ZWRfX2m6tE+ZMBMCj
 Yz7zP1+bgaEMvdiM5a5QT7BFel4ROZ3eGXHs8xZQGd/otsbDXReqm8oDN3CdLzuxZJ2+RIaQ0VI
 rbicx4Arf1b22mgI7+9bUvssEJQp2rw=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a6c8e92 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=peRi4eHbvLtSymDYPC4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA5MCBTYWx0ZWRfX0IRIb+GsVchr
 zJVENoLkWA0VilSyLsSpsUE0cCn/wdUxOBwXg7mkYK0SBU+PpxJ1Z6AtlgbMBcpVoF9lUvY8H1n
 fFv/7H6JdUHVQZ5x7L1CYQu2t/rFozs26APTFvSnbPYdtRhU3jDjC2aIDi2Do989uKWOg5WbbMT
 8DwwX6r0M+x0dqMql52qczs0Exp2uj8OcwQdHPBJevYTkwSbB6qR9audYM+9WkAsWPVIg55gxso
 uKU+eeZaI6EcGGShPaHMeoIuhO4CeEcNXTy6HuBxSQsbAFfMx511Vg5XTJf7rNdS8t/RfMJDAaA
 d1AQKjNnD+atxPE9IEbq0o3rwj73ULBrUaCds8HKIEJiJ5CCQlb/wwSNZY8wqRB94bfpfOn6rYB
 AjnS60jh2y3My2z9BOP4ooQH31+7nHQOeeIoS+b8xniDqNlQ7MIIM9HBK9+ExY1guOU2DyvKTji
 pSkHK//Qo+UeIfQg5ng==
X-Proofpoint-GUID: h2uyUnjZxNDeUzP2gWg5fU5LqXC_RtQ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310090

On Wed, Jul 29, 2026 at 04:59:17PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_convert_unwritten_extents() currently returns only a success or a
> failure indication. A zero return means all requested blocks were
> converted, and a negative value means the conversion failed. However,
> some blocks may have already been converted when the function fails
> partway through, and callers have no way to learn how many were done.
> 
> The WRITE_ZEROES caller in ext4_alloc_file_blocks() needs this
> information to decide whether to add the inode to the orphan list before
> updating i_disksize to cover the already-converted written extents, so
> that a crash before i_disksize catches up can be recovered via orphan
> truncation.
> 
> Switch the function to pass out the number of converted blocks through
> the new output parameter @converted, which will be used by later
> patches.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good Zhang, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  fs/ext4/ext4.h    |  3 ++-
>  fs/ext4/extents.c | 53 ++++++++++++++++++++++++++++++-----------------
>  fs/ext4/file.c    |  3 ++-
>  3 files changed, 38 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 4e3b3165ee8f..f36d84ff0d5e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3901,7 +3901,8 @@ extern void ext4_ext_release(struct super_block *);
>  extern long ext4_fallocate(struct file *file, int mode, loff_t offset,
>  			  loff_t len);
>  extern int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
> -					  loff_t offset, ssize_t len);
> +					  loff_t offset, ssize_t len,
> +					  ext4_lblk_t *converted);
>  extern int ext4_convert_unwritten_extents_atomic(handle_t *handle,
>  			struct inode *inode, loff_t offset, ssize_t len);
>  extern int ext4_convert_unwritten_io_end_vec(handle_t *handle,
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d5f87a7f6c05..1ab1a6e2ed83 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4664,7 +4664,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  			if (likely(!ret))
>  				ret = ext4_convert_unwritten_extents(NULL,
>  					inode, (loff_t)map.m_lblk << blkbits,
> -					(loff_t)map.m_len << blkbits);
> +					(loff_t)map.m_len << blkbits, NULL);
>  			if (ret)
>  				break;
>  		}
> @@ -5051,21 +5051,26 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
>   * all unwritten extents within this range will be converted to
>   * written extents.
>   *
> - * This function is called from the direct IO end io call back
> - * function, to convert the fallocated extents after IO is completed.
> - * Returns 0 on success.
> + * This function is called from the direct/buffered I/O end io call back
> + * function and FALLOC_FL_WRITE_ZEROES, to convert the fallocated
> + * unwritten extents after data I/O is completed.
> + *
> + * Returns 0 on full success, or a negative error code on partial
> + * success or failure. The number of blocks converted is returned via
> + * @converted.
>   */
>  int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
> -				   loff_t offset, ssize_t len)
> +				   loff_t offset, ssize_t len,
> +				   ext4_lblk_t *converted)
>  {
> -	unsigned int max_blocks;
> +	ext4_lblk_t max_blocks, conv_blocks = 0;
>  	int ret = 0, ret2 = 0, ret3 = 0;
>  	struct ext4_map_blocks map;
>  	unsigned int blkbits = inode->i_blkbits;
>  	unsigned int credits = 0;
>  
>  	map.m_lblk = offset >> blkbits;
> -	max_blocks = EXT4_MAX_BLOCKS(len, offset, blkbits);
> +	map.m_len = max_blocks = EXT4_MAX_BLOCKS(len, offset, blkbits);
>  
>  	if (!handle) {
>  		/*
> @@ -5073,9 +5078,8 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
>  		 */
>  		credits = ext4_chunk_trans_blocks(inode, max_blocks);
>  	}
> -	while (ret >= 0 && ret < max_blocks) {
> -		map.m_lblk += ret;
> -		map.m_len = (max_blocks -= ret);
> +
> +	while (max_blocks) {
>  		if (credits) {
>  			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
>  						    credits);
> @@ -5092,23 +5096,34 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
>  		ret = ext4_map_blocks(handle, inode, &map,
>  				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
>  				      EXT4_EX_NOCACHE);
> -		if (ret <= 0)
> +		if (ret <= 0) {
>  			ext4_warning(inode->i_sb,
> -				     "inode #%llu: block %u: len %u: "
> -				     "ext4_ext_map_blocks returned %d",
> -				     inode->i_ino, map.m_lblk,
> -				     map.m_len, ret);
> +				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
> +				     inode->i_ino, map.m_lblk, map.m_len, ret);
> +			if (unlikely(ret == 0))
> +				ret = -EINVAL;
> +		} else {
> +			conv_blocks += map.m_len;
> +		}
> +
>  		ret2 = ext4_mark_inode_dirty(handle, inode);
>  		if (credits) {
>  			ret3 = ext4_journal_stop(handle);
>  			if (unlikely(ret3))
>  				ret2 = ret3;
>  		}
> -
> -		if (ret <= 0 || ret2)
> +		ret = ret < 0 ? ret : ret2;
> +		if (ret)
>  			break;
> +
> +		map.m_lblk += map.m_len;
> +		map.m_len = (max_blocks -= map.m_len);
>  	}
> -	return ret > 0 ? ret2 : ret;
> +	/* Converted some or all blocks successfully? */
> +	if (converted)
> +		*converted = conv_blocks;
> +
> +	return ret;
>  }
>  
>  int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
> @@ -5131,7 +5146,7 @@ int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
>  	list_for_each_entry(io_end_vec, &io_end->list_vec, list) {
>  		ret = ext4_convert_unwritten_extents(handle, io_end->inode,
>  						     io_end_vec->offset,
> -						     io_end_vec->size);
> +						     io_end_vec->size, NULL);
>  		if (ret)
>  			break;
>  	}
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 9a16071b719d..45e16799d0c2 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -436,7 +436,8 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
>  		error = ext4_convert_unwritten_extents_atomic(NULL, inode, pos,
>  							      size);
>  	else if (!error && size && flags & IOMAP_DIO_UNWRITTEN)
> -		error = ext4_convert_unwritten_extents(NULL, inode, pos, size);
> +		error = ext4_convert_unwritten_extents(NULL, inode, pos, size,
> +						       NULL);
>  	if (error)
>  		return error;
>  	/*
> -- 
> 2.52.0
> 
