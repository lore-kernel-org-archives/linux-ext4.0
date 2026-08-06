Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EBB379C27
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786040149; cv=none; b=GygosdNkH4OfZHQUnqnuBcdwECbtnBL0V4PurjsNnvx2VEHsd88afEvIKsvhkWtdJBnWC9DCFktc0dMQ4HxerMaLjx2SSilX32/rwjQSRGc47/Pm6AovHfFa+HaSeaAg3BK/bnwg+jFfzEepmr98ez6dQ+k5bEVYm30+V8JXzWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786040149; c=relaxed/simple;
	bh=Fflp/qg3EPPRw5J+OLnnyiT6m2lZYhpNeqKuoa6CS7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6Fwz2PbJYCwNaK60SlnUFplPNFPhk+LpcWAKBUiVol0Z6YCleL8bsijPxGC8yro/UJgvmRTiaftP87vAjzvb6X2SXoUc7cZbBqkZWyj/NOHHPim9avowMSW38Vvp1HKwxwZFY6EkArXHiZjldChn+ebJet3s25CWcFB8bfrKuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EVMS8Pwj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EVMS8Pwj"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676HlrI81470711;
	Thu, 6 Aug 2026 18:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=DAthnIT8cMa0uiUaLo+PwxHtkdQhIa
	8vQYwXgcW/J/Y=; b=EVMS8PwjfzTOoMGCEdDZ+2GY1UQO/qEsppsPMCZQ6W/i3f
	bxqrtl2rLjX6LZIBkdkyDPOkm59dAm6Hp9JOGlBL1qm2gvF7ra+rHIPFdXtq9GzC
	USnI0V0q2Zkww6Dm4pavWbyH+cjoLxtUYbxb9+FmTrYfZchaf3dE1xOR/eG/mMjA
	AWj7qgWUUsrK0a3E/m4du0vmNVM5M7blnCxD4qHBDdnovZRfQb/F7GKSsGGIC9zE
	zhqGmMB50h/t1heCinvWeqpY5MEcoi1jFfxI7fkycvFEgpwhqIyrI4WXsLIyKc6u
	4t3kvnQS1O6XkYDjQefgjoVzfyPHT8NjsDAwa1WQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy01g3d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 18:09:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 676HuHIV011362;
	Thu, 6 Aug 2026 18:09:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4kccf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 18:09:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 676I9tgj52101592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 18:09:55 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62ED620043;
	Thu,  6 Aug 2026 18:09:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5566D20040;
	Thu,  6 Aug 2026 18:09:53 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.29.44])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  6 Aug 2026 18:09:53 +0000 (GMT)
Date: Thu, 6 Aug 2026 23:39:46 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 1/3] ext4: Teach ext4_meta_trans_blocks() about number of
 allocated extents
Message-ID: <anTNqZe3fY4Vblfn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-4-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805153605.166545-4-jack@suse.cz>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: EMCeJua5e-x6l_hP602x08k5u14a7Be-
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDEzOSBTYWx0ZWRfX6UOQm/XRMPam
 Jme0bpaGDtbWfCiPWNFRwFj5WHPJnqlmeQg8fc1pm6WLy4f7hDQWRwEdIPVzfxaTE5ixab0QSju
 f/h/KjKnqI7aQWWyrpWalOLdi57pMW0=
X-Proofpoint-ORIG-GUID: AtBFoUwsybnxM59_LxAZ2SXNkgOy7TMS
X-Authority-Analysis: v=2.4 cv=afNRWxot c=1 sm=1 tr=0 ts=6a74cdf7 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=3DTBKyg9X2n2mJOQheMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDEzOSBTYWx0ZWRfX76RgCr5c8PTl
 HGGElPi5cgVCXZCCVD3A5k1LkHeBmAPBfx2DZCaAKuEpWvxelWSs8Tp4+JGbREmyCd2OzTTQYwb
 8fNCh4UumdlnUuJv6Nf8FEBdbi599ZL3VHvB2OEfgS7z/vvGmkqJPVr+Xf5d52glSplNuqQ8QD7
 3BKGspPjuKJ/TrqTVTotvEPmf52EKoUCn08ZPYE1GuohBgzC/A3i/84u3e49iVsXYp2hAQzrxI2
 OZN7iE2oCij956B5hCf0ALY6c7bInhKa7JZ9KAd7dLmgh9PrEbNFyDm3cZ2J0Yt/M6xummyfQh+
 UyqO3xl8CNK5CEyonfAD7y966cAyZDp/worLdyLF9J9Wk3oec46M7vl5LZMulJ7mEMNXgtE51vH
 Ql9nhbYgC53DiMFT74yorueBzDZrHOHK8ZMWv/Ow1pSzwYSQcOTNbshoUpg/hBttB+FwvInkhC8
 kcZnnGfExAvrjtkCY/A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060139

On Wed, Aug 05, 2026 at 05:35:47PM +0200, Jan Kara wrote:
> So far ext4_meta_trans_blocks() expects that each extent counted in
> @pextents will be allocated in the transaction we estimate credits for.
> This is correct for the use in ext4_chunk_trans_blocks() and
> ext4_chunk_trans_extent() however the use in atomic write path
> (ext4_convert_unwritten_extents_atomic() and ext4_iomap_alloc() for
> IOMAP_ATOMIC) unnecessarily overestimates the number of necessary
> credits as neither of them allocates any data. Add argument to
> ext4_meta_trans_blocks() for number of extents that are going to be
> allocated in the transaction.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Hi Jan,

Looks mostly okay, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

just a couple comments below:

> ---
>  fs/ext4/ext4.h    |  2 +-
>  fs/ext4/extents.c |  2 +-
>  fs/ext4/inode.c   | 32 +++++++++++++++++---------------
>  3 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..6e0cc9b845ae 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3184,7 +3184,7 @@ extern int ext4_normal_submit_inode_data_buffers(struct jbd2_inode *jinode);
>  extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
>  extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
>  extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
> -				  int pextents);
> +				  int pextents, int alloc_extents);
>  extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
>  extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
>  				    loff_t length, bool *did_zero);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91c97af64b31..44ab246a3176 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4976,7 +4976,7 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
>  		 * it can tell if the extent in the cache is a split extent.
>  		 * But for now let's assume pextents as 2 always.
>  		 */
> -		credits = ext4_meta_trans_blocks(inode, max_blocks, 2);
> +		credits = ext4_meta_trans_blocks(inode, max_blocks, 2, 0);

Right, because we are not going to allocate anything but we might be
modifying upto 2 extent entries. By that logic shall we also change the
following:

  @@ -5046,7 +5046,7 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
   		/*
   		 * credits to insert 1 extent into extent tree
   		 */
  -		credits = ext4_chunk_trans_blocks(inode, max_blocks);
  +		credits = ext4_meta_trans_blocks(inode, max_blocks, max_blocks, 0);
   	}
   	while (ret >= 0 && ret < max_blocks) {
   		map.m_lblk += ret;

since we are not going to allocate anything.

>  	}
>  
>  	if (credits) {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..f324a54f1dae 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3693,9 +3693,11 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
>  		if (ret < 0)
>  			return ret;
>  		if (map->m_len < orig_mlen) {
> +			int bpg = EXT4_BLOCKS_PER_GROUP(inode->i_sb);
> +
>  			map->m_len = orig_mlen;
> -			dio_credits = ext4_meta_trans_blocks(inode, orig_mlen,
> -							     map->m_len);
> +			dio_credits = ext4_meta_trans_blocks(inode, map->m_len,
> +							     map->m_len, 0);

This makes sense because we always come here in the bigalloc case when
the cluster is already allocated. If we ever support atomic writes
without bigalloc, we'll have to remember to take care of this. Maybe we
can add a small one line comment here?

/* 
 * we have an encountered mixed mapping in an already allocated bigalloc
 * cluster hence credits for allocation are not needed
 */


>  		} else {
>  			dio_credits = ext4_chunk_trans_blocks(inode,
>  							      map->m_len);
> @@ -6307,17 +6309,17 @@ static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
>  }
>  
>  /*
> - * Account for index blocks, block groups bitmaps and block group
> - * descriptor blocks if modify datablocks and index blocks
> - * worse case, the indexs blocks spread over different block groups
> - *
> - * If datablocks are discontiguous, they are possible to spread over
> - * different block groups too. If they are contiguous, with flexbg,
> - * they could still across block group boundary.
> - *
> - * Also account for superblock, inode, quota and xattr blocks
> + * Calculate number of credits needed in a transaction to:
> + *   * Allocate data blocks from @alloc_extents different groups - note that
> + *     with flexbg a single physical extent can span multiple groups but
> + *     single mballoc request only returns extent within one group.
> + *   * Allocate metatadata (extent tree blocks, indirect blocks) to store
> + *     pointers to @pextents data extents having @lblocks in total.
> + *   * Modify extent tree / indirect block tree, inode, superblock, quota
> + *     tracking, xattr blocks
>   */
> -int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
> +int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents,
> +			   int alloc_extents)
>  {
>  	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
>  	int gdpblocks;
> @@ -6334,7 +6336,7 @@ int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
>  	 * Now let's see how many group bitmaps and group descriptors need
>  	 * to account
>  	 */
> -	groups = idxblocks + pextents;
> +	groups = idxblocks + alloc_extents;
>  	gdpblocks = groups;
>  	if (groups > ngroups)
>  		groups = ngroups;
> @@ -6360,7 +6362,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
>  {
>  	int ret;
>  
> -	ret = ext4_meta_trans_blocks(inode, nrblocks, 1);
> +	ret = ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
>  	/* Account for data blocks for journalled mode */
>  	if (ext4_should_journal_data(inode))
>  		ret += nrblocks;
> @@ -6378,7 +6380,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
>   */
>  int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
>  {
> -	return ext4_meta_trans_blocks(inode, nrblocks, 1);
> +	return ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
>  }
>  
>  /*
> -- 
> 2.51.0
> 
