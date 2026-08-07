Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2BE446053
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 05:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786082393; cv=none; b=S/DBjbngWISJeS5crKxCIb1kcT+IWoIYzogqT+9qmm0ib+PtLCZ6fEeC5EVEw7dhourQ7JkE2ZC0i2sx95DFdHdqV0O3NDPxpWbf/WIbktc0fZsSiNtkKAMiXMnQELoXjAv7OTh9o/NxzaRHw4De4hLsxRi7/LTGuwB+5+NRbec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786082393; c=relaxed/simple;
	bh=YPal687ezt8eUMWrDBiJ/sS3qc6Z1Ca28jYsOTWoFtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYn/UEc1DwqJgB17TmX75cXDys8R61TniXcnTg1L5qYIJwb5vhHJUzGs91iWcLhN+GcZe/EyAr6JdFsWBuf2b4cnAg1ctCktBvf5J6VGnEMA/7HKjj8wYl+Qg3rNSz8ep+2gg8oJMK99ffoBV/RCDdPVXVXcDYFJxglP/ZZ6zDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CaCf65V6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CaCf65V6"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770HXuc2275985;
	Fri, 7 Aug 2026 05:59:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YaUDtU
	EA+XiS3IVgE+rOVZMV6cViY5I1JOXg1nESA5g=; b=CaCf65V68CJNS7w886Qiru
	tyeSJDGClYpaR3gydDDznG0AEl4tHUTAnQNdsd3AWnF7qVPFzdUjgj2UbfEsCW6L
	pzfFyoMOSm2E/862W62dzCazPuVsg9iot/spw6bo602H+ilno1S0N5q/7qZDdEEm
	7SAsbQ77qDembxjlZpl4+HaGXHVczIUnzQRqQxDK2IIHPcjvaQUWxDt+3I4hHJA/
	ELameKt+nEF+nA57da1/JHyAbx9bd8Uu3zplbAWM8xNHb4hoN/i1ZkKpNpYOl8A9
	PRY+nzRnayC7cWTmy/Olb51DEYgc3P5HNax+K928WszAiU0zJsRY9QiIM+ZAF5Rw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy01jgjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 05:59:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6775uUBs021684;
	Fri, 7 Aug 2026 05:59:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmhpe6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 05:59:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6775xPBr51315142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 05:59:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F47520043;
	Fri,  7 Aug 2026 05:59:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E06A20040;
	Fri,  7 Aug 2026 05:59:23 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.216.183])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  7 Aug 2026 05:59:23 +0000 (GMT)
Date: Fri, 7 Aug 2026 11:29:20 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 1/3] ext4: Teach ext4_meta_trans_blocks() about number of
 allocated extents
Message-ID: <anV0GDXzYdYki4jw@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-4-jack@suse.cz>
 <47ad8e97-ded5-43ed-90b6-227513a125c9@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47ad8e97-ded5-43ed-90b6-227513a125c9@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 32G4qAssbNKpXO9uUSs0lpM8KVxyiVBV
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA0MSBTYWx0ZWRfX4YX249jk90Tk
 aS/pB4cFHWYXO4iucXx2sR1CwUtuwWTem7gwTVfp2q7WGuchKjm3lBLWeJit7G5kuGVpxV0U4dl
 VXm+kFAETisnV9xE6uU2QPEool2zG4g=
X-Proofpoint-ORIG-GUID: LXja2i8JDRDvD_kYYNz8_8hMiqINiyOw
X-Authority-Analysis: v=2.4 cv=afNRWxot c=1 sm=1 tr=0 ts=6a757441 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=LrkB4WwW6sjp2s0-LYQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA0MSBTYWx0ZWRfX+2BA3KFDYI04
 hYyx+D+07WYGTTyOzCDgzLuUJp0czyGmYUwcHMjeGHhkwIQG9G6YBp4asjkSSQxEj6elFqncd8k
 X7xN36dBWfl+ynE2SjPYAhWJcuyt4ECmBqT1SjV9lzFCF/XUw5mf3YcdZk+zmDAE0sXeXqbPw9R
 0IObqdO+P8AdiSlyTc+RF6a17E6HAnFFv1W7YQcCxa76HewFdatNLN4WEUHyxPODqABIAmOPrgc
 +l/fYIx8zdGpQOczuz1r69RcWPkSCkCeJvkzF2JPJQONTTCmVcmhlmf9Bhm+iW9YHidgQ7TRwhb
 AI6LjUQGRIB3Nx7H+kMhSxzpyYKo45/4Y9qQWQDmwKIm2zsON+aEAo7p7N/Zm2S1d+HWa1M3H06
 VwXbsquJcSl6lNbCRxOEIG8GqUp+vReK1Dqs0oXI6+44RSsxs4axNBqnOi01LIEkS61+n1wKLW7
 0bp/8vacZaYIpOqRRsA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608070041

On Fri, Aug 07, 2026 at 10:59:17AM +0800, Zhang Yi wrote:
> On 8/5/2026 11:35 PM, Jan Kara wrote:
> > So far ext4_meta_trans_blocks() expects that each extent counted in
> > @pextents will be allocated in the transaction we estimate credits for.
> > This is correct for the use in ext4_chunk_trans_blocks() and
> > ext4_chunk_trans_extent() however the use in atomic write path
> > (ext4_convert_unwritten_extents_atomic() and ext4_iomap_alloc() for
> > IOMAP_ATOMIC) unnecessarily overestimates the number of necessary
> > credits as neither of them allocates any data. Add argument to
> > ext4_meta_trans_blocks() for number of extents that are going to be
> > allocated in the transaction.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Hi Jan,
> 
> I have some questions below.
> 
> > ---
> >  fs/ext4/ext4.h    |  2 +-
> >  fs/ext4/extents.c |  2 +-
> >  fs/ext4/inode.c   | 32 +++++++++++++++++---------------
> >  3 files changed, 19 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index b37c136ea3ab..6e0cc9b845ae 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -3184,7 +3184,7 @@ extern int ext4_normal_submit_inode_data_buffers(struct jbd2_inode *jinode);
> >  extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
> >  extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
> >  extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
> > -				  int pextents);
> > +				  int pextents, int alloc_extents);
> >  extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
> >  extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
> >  				    loff_t length, bool *did_zero);
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 91c97af64b31..44ab246a3176 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4976,7 +4976,7 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
> >  		 * it can tell if the extent in the cache is a split extent.
> >  		 * But for now let's assume pextents as 2 always.
> >  		 */
> > -		credits = ext4_meta_trans_blocks(inode, max_blocks, 2);
> > +		credits = ext4_meta_trans_blocks(inode, max_blocks, 2, 0);
> >  	}
> >  
> >  	if (credits) {
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index ce99807c5f5b..f324a54f1dae 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3693,9 +3693,11 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
> >  		if (ret < 0)
> >  			return ret;
> >  		if (map->m_len < orig_mlen) {
> > +			int bpg = EXT4_BLOCKS_PER_GROUP(inode->i_sb);
> > +
> >  			map->m_len = orig_mlen;
> > -			dio_credits = ext4_meta_trans_blocks(inode, orig_mlen,
> > -							     map->m_len);
> > +			dio_credits = ext4_meta_trans_blocks(inode, map->m_len,
> > +							     map->m_len, 0);
> 
> This pertains to the mixed map case, where holes may exist in between.
> My understanding is that we cannot assume all blocks are already
> allocated. Is this right?

Hi Yi,

With atomic writes, we can only allow multi block writes when bigalloc
is set. So the common cases are that the whole bigalloc cluster is
present or whole is missing.

If we do see map->m_len < orig_mlen that means the bigalloc cluster
range we queried has some allocation. This can only happen if someone
punched through the cluster because punch-hole can still happen at block
granularity.

Regardless, if we do see a mixed map here, it means the cluster is
allocated already, just a few blocks are punched in it, hence we won't
need to do any allocation.

Regards,
ojaswin

> 
> >  		} else {
> >  			dio_credits = ext4_chunk_trans_blocks(inode,
> >  							      map->m_len);
> > @@ -6307,17 +6309,17 @@ static int ext4_index_trans_blocks(struct inode *inode, int lblocks,
> >  }
> >  
> >  /*
> > - * Account for index blocks, block groups bitmaps and block group
> > - * descriptor blocks if modify datablocks and index blocks
> > - * worse case, the indexs blocks spread over different block groups
> > - *
> > - * If datablocks are discontiguous, they are possible to spread over
> > - * different block groups too. If they are contiguous, with flexbg,
> > - * they could still across block group boundary.
> > - *
> > - * Also account for superblock, inode, quota and xattr blocks
> > + * Calculate number of credits needed in a transaction to:
> > + *   * Allocate data blocks from @alloc_extents different groups - note that
> > + *     with flexbg a single physical extent can span multiple groups but
> > + *     single mballoc request only returns extent within one group.
> > + *   * Allocate metatadata (extent tree blocks, indirect blocks) to store
> > + *     pointers to @pextents data extents having @lblocks in total.
> > + *   * Modify extent tree / indirect block tree, inode, superblock, quota
> > + *     tracking, xattr blocks
> >   */
> > -int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
> > +int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents,
> > +			   int alloc_extents)
> 
> From what I can see, alloc_extents currently can only be 0 or equal to
> pextents — 0 means a pure conversion, and equal to pextents means a new
> allocation. pextents is supposed to cover the total count of
> alloc_extents. Should we add some sanity checks to guard against invalid
> inputs, like alloc_extents > pextents?
> 
> Thanks,
> Yi.
> 
> >  {
> >  	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
> >  	int gdpblocks;
> > @@ -6334,7 +6336,7 @@ int ext4_meta_trans_blocks(struct inode *inode, int lblocks, int pextents)
> >  	 * Now let's see how many group bitmaps and group descriptors need
> >  	 * to account
> >  	 */
> > -	groups = idxblocks + pextents;
> > +	groups = idxblocks + alloc_extents;
> >  	gdpblocks = groups;
> >  	if (groups > ngroups)
> >  		groups = ngroups;
> > @@ -6360,7 +6362,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
> >  {
> >  	int ret;
> >  
> > -	ret = ext4_meta_trans_blocks(inode, nrblocks, 1);
> > +	ret = ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
> >  	/* Account for data blocks for journalled mode */
> >  	if (ext4_should_journal_data(inode))
> >  		ret += nrblocks;
> > @@ -6378,7 +6380,7 @@ int ext4_chunk_trans_extent(struct inode *inode, int nrblocks)
> >   */
> >  int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
> >  {
> > -	return ext4_meta_trans_blocks(inode, nrblocks, 1);
> > +	return ext4_meta_trans_blocks(inode, nrblocks, 1, 1);
> >  }
> >  
> >  /*
> 
