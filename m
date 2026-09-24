Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71174485CED;
	Thu, 24 Sep 2026 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790256362; cv=none; b=WFh9cyvOwcf1NyFK4t1/AgI7rHhPCIr7orGlGljm/y8nmo9K3LBLhfSN80uCTa1wTmDwPTGZs+COF5raGA0QwdC98cp8bwXLch/01C1BQAjzK6JdW74QeHG3gh8+KqAyT5RpfcA0hf08dAFRZgF4Ib3pwaBunv3VRhsgMfMv79U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790256362; c=relaxed/simple;
	bh=bp/B3opL2hGi5oaUFjJUb7ESUa4Mct9dNlhgGkfh8dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQZzhLgyBb2aADEEFuqAhCvNYWCXrdb33CnLlxgqF2E2V6fwcbJgNYMAEtfpJjeMAKGTVVC8YwN6gGXZB2VsJltZpMFP0N5S+JA3DSbhvAqCs4lQm2wqjHs+AlfQQoaLp124UxcZaAFGhxaVV0O7LjHbMZJTLz8xizPLNes8mWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y+4qE4ib; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y+4qE4ib"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OC6RLD2028674;
	Thu, 24 Sep 2026 13:25:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ytVG7+Irtt0IThunmCRQ4lrMkbdDUn
	iZXVt0a8PwRyA=; b=Y+4qE4ibCQg9wLqr6G2JqPDlZcZ8vROsyP6QRsCdLBg6QO
	WFCODnYzUBBWQJvZsz8PyYknPuvKd6zsMx8yP4Qn/0gz1qkwWjwBNFSwQJy/XetC
	HKz/BFoY/7Bq0QJI71jZVf3C1+WDXkFjtreaxQD/Atkkw3LruNxxY/v5eW2ep1a5
	NJOGDnhn+8KcP24jZGxuesK/w9i4wD4aVNDU9rFbGPxJykszPNAPIn59KCPx4em4
	srwxbGonRKue/JZVRKOnP5v5j22S5WkJNB0ajHpBbrexaOHGoKRrmLjKvAOdsaZV
	pqDWNVkfGA+LN4jAmYBelBhiRtmgKy535x/1Bo4w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1rptv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 13:25:06 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68OCHb0c2004095;
	Thu, 24 Sep 2026 13:25:06 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gvbu8ww83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 13:25:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ODP3om31719804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 13:25:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD6E42004B;
	Thu, 24 Sep 2026 13:25:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BCE520040;
	Thu, 24 Sep 2026 13:24:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.215])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 24 Sep 2026 13:24:59 +0000 (GMT)
Date: Thu, 24 Sep 2026 18:54:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 06/31] ext4: fix orig_mlen initialization in
 ext4_map_blocks()
Message-ID: <arUkqF13uVsnf-41@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-7-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-7-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: HVGIuphmOU1g8OyNzvGKWCyIQ_5seUzP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA1NCBTYWx0ZWRfX2cDTi36nzR3V
 9scPdGmRFX5x/aRls06hw64zrfkWJe96EmRUtUGOjZyA+2MKPbGKzfzMnbawgKfA9BlqkNCF0Mx
 Cjph4YMcxQ9SWc+UGF3qX/eAOhUurVPxXHNctd9ll0Pz2ikMz6tQZq/g93ydcuUClu4SCMiL106
 Hb6KfMKYHDtBAiB/afU8I/qMNOFFDN3auoi+KBee3riWxQjWkt7s2Zk4ZLqJwoeWtxuQJ9aAbWb
 my1Wruz9aj58g1U1DFiIpE1Bq1vHxMJylp+CIFE7TB2SI3pxasRWQZuv9VPluGPvqUBxVEZqiAy
 jJzIoVOnMGallfMUM63jFQw1aGnoIZ4xeXL+fmlF1adEZaqaK37PPFpESBRtRBzsr+00kbu7vAR
 IU4SiIxLCvq327nXraYQWEAcxs+hO95lnR3XMjQd+h1pA3CBixmctO1o429sg3gNua1YyliRsto
 +Pp3WCar3uVeWtAcBNQ==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab524b2 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=5t7rz7vW76R3pwELzq8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA1NCBTYWx0ZWRfXxGubl10IiHch
 twhqQsSzIEXuYDirsGsg6HAqXvPPmT4YJTBEFT8yzn88te94zt2RxXz+NdTh95nrsiUo87hu5AL
 aTFSQgs0BA7xwLTihjiVRoAFkNVoNnI=
X-Proofpoint-GUID: 34ceeIGn0c0XkC4OkV9pGj7VWydg6T5V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240054

On Thu, Sep 03, 2026 at 08:35:18PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Save orig_mlen after clamping map->m_len to INT_MAX. Otherwise, the
> unclamped value may be passed below, bypassing its overflow protection.
> 
> Fixes: 5bb12b1837c0 ("ext4: Add support for EXT4_GET_BLOCKS_QUERY_LEAF_BLOCKS")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Thanks for fixing this, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin
> ---
>  fs/ext4/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b71b1d2588ae..73af6d386985 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -703,7 +703,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	struct extent_status es;
>  	int retval;
>  	int ret = 0;
> -	unsigned int orig_mlen = map->m_len;
> +	unsigned int orig_mlen;
>  #ifdef ES_AGGRESSIVE_TEST
>  	struct ext4_map_blocks orig_map;
>  
> @@ -719,6 +719,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	 */
>  	if (unlikely(map->m_len > INT_MAX))
>  		map->m_len = INT_MAX;
> +	orig_mlen = map->m_len;
>  
>  	/* We can handle the block number less than EXT_MAX_BLOCKS */
>  	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
> -- 
> 2.52.0
> 
