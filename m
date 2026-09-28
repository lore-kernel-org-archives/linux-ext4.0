Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2495140926C;
	Mon, 28 Sep 2026 10:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790590851; cv=none; b=Q8yVV5MPzmRplC26N+r7BKzFG/rGBGjhEAMulGuZF+EBOr0E9bGQuv+/x7yOvh8DDulxf2t2ZngFIehfMZXQsYiDTk4M+hExPAjpGTzTqJd4LoLOjzzFTQ4+UQllKzWwr/tS4FcaocwIkn4uTaKlQKjedxniDLkvTsnrovSXRIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790590851; c=relaxed/simple;
	bh=Yi2ldhXj2zmHK8UgM+DF+OqJLA8sZCii+W/CVyBFxE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YD/f0PfeC5byK8Ia0QGVcioKp8nSPzNRr6CMiAlb7YAa6739NbQu92mHBaCDRu0rjVk9wlKbyf/1TAHpX4YIc+jIvjmvxZ7cDmgxI5E+aEFICUKCj/R3sbrZql51uK4o2m/++8IxVt5p4iU6b3tWhQmgVtPhGqjnkMlkCeCKIYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B2rtiYie; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B2rtiYie"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9Zl3j577538;
	Mon, 28 Sep 2026 10:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=bG2rFCLcIEP9Op6TfbYnLLa2KS56lC
	MzlG08uXjUzZk=; b=B2rtiYieNC0Vfr3kFQ0gexz9rFTv9p023pnfbYUrHRMbGp
	RpDaFAa2g9gqUbv6KqbvHrRxZXN7uvTX/g7sLLSwh6siVk8Z9BIxvQODo8fmXPN3
	gPd5wu684E7EACyMabeYPYyhC/L7Y8kNcG5Ir5wK1sUDq7C0oWX4AAeSDVQCNvI0
	pd5nqyflCODEj06oaO3g79AueZkR7kZ8Kb/ueI2bx2Tsvz7gjxEnO6ntFzvALT8O
	aCHjkhd4NviHB37mIiRR6xmLDn+Ciq3vrx4KJU5U58Np3Pe3uvExHcSIhXX5SATz
	wPgQ0Xtxn2ddWA97H/GLmmWwSO9JUXS1a3jPDU2g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx3fk0mae-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 10:20:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9Hc234087076;
	Mon, 28 Sep 2026 10:20:01 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxrrw4ueu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 10:20:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SAJxDv48628072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 10:19:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 795AE2004E;
	Mon, 28 Sep 2026 10:19:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C4E6120043;
	Mon, 28 Sep 2026 10:19:53 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 28 Sep 2026 10:19:53 +0000 (GMT)
Date: Mon, 28 Sep 2026 15:49:50 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 07/31] ext4: allow ext4_map_blocks() to start its own
 transaction handle
Message-ID: <aro_RkJFBFOnRlAd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-8-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-8-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: fzhzKIO0yxQVMaqCCRP72reNIG5R74Fb
X-Proofpoint-GUID: xwB_VIr2ioAc6L9ggwZwJi6l0QHuDpHm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0MCBTYWx0ZWRfX9K3FALQejMdn
 +SYquqw6M5fu3zinA2a3J3rk1DXbyuVdmMGmt0EcMCao+vZLoLQ+f2s2iWf7Ba47CHycbaQS2zN
 Wt/VH/KdiIW1OWb7ZJoQbU3EXHvS82c=
X-Authority-Analysis: v=2.4 cv=Vv62kO2n c=1 sm=1 tr=0 ts=6aba3f52 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=AugjVe7HrIh2vsyYFhQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0MCBTYWx0ZWRfX7Z9gjML5Wfqd
 lZ+uryqZ07Y1VA/1bQhjpySp6l0Ke9LGsa3sfBjD3bXlZ5GQZpC1nuBD2cX9/9zcT+asxG7O4aa
 lDt8+gyrU+PF9QdohN/aYVb5ohBjhpLj4yrR7frv6LS8iN1hG6lfEDVxDuJTii13cOt5PeflMtz
 ZWMN/YB0creDVU1hbPaIGIes/4VstnrXNdKjLvATMB3UPEUtShGr1hoTPBiSjqBhd51rCuHgOKF
 HcteSuqs48CI1v9X/jt1AgdxmRwpH5bHLGyfh5V/D5eHL/8JUSp6LVpsdrr/awv753E5VbUAyfZ
 Z/Aoz1nINaFwbC/oziQWLVwVvxDHCj+A3BeW77FliXqOVUyFD50Yw2jiSjyGTN23RbeMtaTFp1u
 FnUTVuo5mW7ZIbm2fvQ7zjDgbNWn3eLIhEBKeH0+lqyotckbXmtAZapqI1jHE3Dtoi2j2Y6MmL1
 B7I0ksX6QxlJtPIIvqw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280040

On Thu, Sep 03, 2026 at 08:35:19PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Make ext4_map_blocks() start its own transaction handle when the caller
> does not provide one. The handle is started after the lookup path
> confirms that allocation is actually needed, and is stopped at the
> unified out_handle exit path. This avoids unnecessarily starting a
> handle for pure mapping queries. This prepares for the buffered iomap
> writeback conversion, which improves performance for fragile overwrite
> cases.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good Zhang,

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  fs/ext4/inode.c | 36 +++++++++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 73af6d386985..c9dea4ca5caf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -703,6 +703,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	struct extent_status es;
>  	int retval;
>  	int ret = 0;
> +	bool internal_handle = false;
>  	unsigned int orig_mlen;
>  #ifdef ES_AGGRESSIVE_TEST
>  	struct ext4_map_blocks orig_map;
> @@ -787,13 +788,15 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	retval = ext4_map_query_blocks(handle, inode, map, flags);
>  	up_read((&EXT4_I(inode)->i_data_sem));
>  	if (retval < 0)
> -		return retval;
> +		goto out_handle;
>  
>  found:
>  	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
>  		ret = check_block_validity(inode, map);
> -		if (ret != 0)
> -			return ret;
> +		if (ret != 0) {
> +			retval = ret;
> +			goto out_handle;
> +		}
>  	}
>  
>  	/* If it is only a block(s) look up */
> @@ -813,8 +816,15 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		 * ext4_ext_map_blocks()
>  		 */
>  		if (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
> -			return retval;
> +			goto out_handle;
>  
> +	if (!handle) {
> +		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> +				ext4_chunk_trans_blocks(inode, orig_mlen));
> +		if (IS_ERR(handle))
> +			return PTR_ERR(handle);
> +		internal_handle = true;
> +	}
>  
>  	ext4_fc_track_inode(handle, inode);
>  	/*
> @@ -843,12 +853,14 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	if (retval < 0)
>  		ext_debug(inode, "failed with err %d\n", retval);
>  	if (retval <= 0)
> -		return retval;
> +		goto out_handle;
>  
>  	if (map->m_flags & EXT4_MAP_MAPPED) {
>  		ret = check_block_validity(inode, map);
> -		if (ret != 0)
> -			return ret;
> +		if (ret != 0) {
> +			retval = ret;
> +			goto out_handle;
> +		}
>  
>  		/*
>  		 * Inodes with freshly allocated blocks where contents will be
> @@ -869,12 +881,18 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  			else
>  				ret = ext4_jbd2_inode_add_write(handle, inode,
>  						start_byte, length);
> -			if (ret)
> -				return ret;
> +			if (ret) {
> +				retval = ret;
> +				goto out_handle;
> +			}
>  		}
>  	}
>  	ext4_fc_track_range(handle, inode, map->m_lblk, map->m_lblk +
>  			    map->m_len - 1);
> +
> +out_handle:
> +	if (internal_handle)
> +		ext4_journal_stop(handle);
>  	return retval;
>  }
>  
> -- 
> 2.52.0
> 
