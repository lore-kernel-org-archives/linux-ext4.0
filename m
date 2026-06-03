Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753193CCA11;
	Wed,  3 Jun 2026 11:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484943; cv=none; b=Yu8AgmcpKdv2XlXIGv58/jNPAXsyMwsEWCnuT+def0KpNTj/qbEEP7QCod7RNaY1kvvm3X4Z030U9icQc0SG7WLRVca+jAbWCQFLwpCs8R7COVSjuwoWLmoP/J9taOy4nqDohWN0LKqWwB7Z9s9y07Xde+M2L5VrNcxSdVxvPPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484943; c=relaxed/simple;
	bh=rFY77fZCBIc0VoAuD9WjxYdEfpmFV5Q0IuieG3fwkY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUQwcoMvpCtI2ZMRVtFeSPl2FRU145ygf7xFxuBr3ys9UIyQKr/8Qfxm9KpvjEujeU32TXwiFwmGy3JoPRJMIgt6x6qwvaJjghcEu6lRid/DfZGS+syQ2eL63Cq5VRp4bL2j+tnUaNJY4r5u3Vke+Vq+SlC54Z9IQkcWbnMGE48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MPZr7Stp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MPZr7Stp"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65357lLe103884;
	Wed, 3 Jun 2026 11:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HKktcI
	ZIJ33bByBHfYcdgTusH/lX96BFVSb9B1NPYbM=; b=MPZr7Stp1j6UPL6nKdtXuZ
	34bYjv/77jLDQTaLchjMdouA2ZxrAqqul+z/7mRh3LtiQol0Cz9wsGJqNlSaZRBo
	QHM7R6/IGQTwcz5l6BJFCAv1AbYrsa7svQWddWi7Egb00PPanZPt2/4olmCjEv1z
	Fy3d/LtazBvoBUxdNlLAbZhYi/BZq+1khgeYYb3F11NYGFs0p1fyp+TB7pk4R1nJ
	A2IQQy+WmLqsFuw1Q2Jy7/yFEXHBnzwATUkKyj/1PZ0wu1AVjguG1NPl+8scJ5kL
	hLPWvoIot7zWgZazXzVC9c1rYrjd05BOc7N5OrfziEVxV9GyMOAdQE1AYy+Oj46g
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efpaea1y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 11:08:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 653As7s2015366;
	Wed, 3 Jun 2026 11:08:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egb7k7v4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 11:08:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 653B8Feu47055116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jun 2026 11:08:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACAA02004F;
	Wed,  3 Jun 2026 11:08:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07C932004E;
	Wed,  3 Jun 2026 11:08:11 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.208.122])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  3 Jun 2026 11:08:10 +0000 (GMT)
Date: Wed, 3 Jun 2026 16:38:08 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 08/23] ext4: implement buffered write path using iomap
Message-ID: <aiALGM49qRS-8TAd@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-9-yi.zhang@huaweicloud.com>
 <ah6vwa_MytxBN-Z8@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <cc05c17d-163e-4251-b2c9-aa3a6f9555d7@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc05c17d-163e-4251-b2c9-aa3a6f9555d7@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Zt3d7d7G c=1 sm=1 tr=0 ts=6a200b22 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=P4J-yphnatDKpaeizhQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: i2BOwBOZoZ6ZOVKEAU9kOfuG1IgiWmqS
X-Proofpoint-ORIG-GUID: ACpkptQBULm1NCC67mk29psTKXDuecNr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEwNiBTYWx0ZWRfX2GmWdywZ1X74
 u3MvtXlMT0IXgGgmQHqPGkXbNc4kfSoBmRsjiguDWl68gBk9mVyegLfBEV0/voddG7P7KwYMluH
 3AuNobC1ReU6fRXsUCUzKvEYo4i11224gzKdjEw9bLiZAGsIWrlOjymGOuqksUDvKamChyiA4hx
 AMEMXyk9huvRyVWeQvJINXl3h0H6wj6EDeWwi16hl6ctuR6WUh4qf4P1JcfRgxNAvl+IYaRB1g2
 /wQQHRW+wxqusvJJpARivx//W7RhA73QJkTo22tPs+NA6q2lbSAdKItva6//A/nBavRWf7lIQf4
 1gj/HGNXhuu3oxZjGS259wI4Ipg+1DbtqPIPoAHm89n0R3oihnhafNH/X9GtmCR8OrDBHHDXvOC
 OoPDp5XbVMP852tqTspk7IlYWzLC7sFk6JXnokhIWVpAvtjONLUjEdL/ynkTN0Hk+AC8vmjYTgJ
 i7HNluTXr8gZSAU3UWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030106

On Wed, Jun 03, 2026 at 10:56:34AM +0800, Zhang Yi wrote:
> On 6/2/2026 6:26 PM, Ojaswin Mujoo wrote:
> > On Mon, May 11, 2026 at 03:23:28PM +0800, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> Introduce two new iomap_ops instances for ext4 buffered writes:
> >>
> >>  - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
> >>    ext4_da_map_blocks() to map delalloc extents.
> >>  - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
> >>    ext4_iomap_get_blocks() to directly allocate blocks.
> >>
> >> Also add ext4_iomap_valid() for the iomap infrastructure to check extent
> >> validity.
> >>
> >> Key changes and considerations:
> >>
> >>  - Unwritten extents for new blocks (dioread_nolock always on)
> >>    Since data=ordered mode is not used to prevent stale data exposure in
> >>    the non-delayed allocation path, new blocks are always allocated as
> >>    unwritten extents.
> >>
> >>  - Short write and write failure handling
> >>    a. Delalloc path: On short write or failure, the stale delalloc range
> >>       must be dropped and its space reservation released. Otherwise, a
> >>       clean folio may cover leftover delalloc extents, causing
> >>       inaccurate space reservation accounting.
> >>    b. Non-delalloc path: No cleanup of allocated blocks is needed on
> >>       short write.
> >>
> >>  - Lock ordering reversal
> >>    The folio lock and transaction start ordering is reversed compared to
> >>    the buffer_head buffered write path. To handle this, the journal
> >>    handle must be stopped in iomap_begin() callbacks. The lock ordering
> >>    documentation in super.c has been updated accordingly.
> >>
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > 
> > I went through this again and after our discussion the changes looks
> > okay. Just a small quesiton below but otherwise feel free to add:
> > 
> > Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
> Thank you a lot for your careful review!
> 
> > 
> >> ---
> >>  fs/ext4/ext4.h  |   4 ++
> >>  fs/ext4/file.c  |  20 +++++-
> >>  fs/ext4/inode.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++-
> >>  fs/ext4/super.c |  10 ++-
> >>  4 files changed, 192 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> >> index 1e27d73d7427..4832e7f7db82 100644
> >> --- a/fs/ext4/ext4.h
> >> +++ b/fs/ext4/ext4.h
> >> @@ -3057,6 +3057,7 @@ int ext4_walk_page_buffers(handle_t *handle,
> >>  int do_journal_get_write_access(handle_t *handle, struct inode *inode,
> >>  				struct buffer_head *bh);
> >>  void ext4_set_inode_mapping_order(struct inode *inode);
> >> +int ext4_nonda_switch(struct super_block *sb);
> >>  #define FALL_BACK_TO_NONDELALLOC 1
> >>  #define CONVERT_INLINE_DATA	 2
> > 
> > <snip>
> > 
> >> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> >> +	return 0;
> >> +}
> >> +
> >> +static int ext4_iomap_buffered_write_begin(struct inode *inode,
> >> +		loff_t offset, loff_t length, unsigned int flags,
> >> +		struct iomap *iomap, struct iomap *srcmap)
> >> +{
> >> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
> >> +						  iomap, srcmap, false);
> >> +}
> >> +
> >> +static int ext4_iomap_buffered_da_write_begin(struct inode *inode,
> >> +		loff_t offset, loff_t length, unsigned int flags,
> >> +		struct iomap *iomap, struct iomap *srcmap)
> >> +{
> >> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
> >> +						  iomap, srcmap, true);
> >> +}
> >> +
> >> +/*
> >> + * On write failure, drop the stale delayed allocation range and release
> >> + * its reserved space for both start and end blocks. Otherwise, we may
> >> + * leave a range of delayed extents covered by a clean folio, which can
> >> + * result in inaccurate space reservation accounting.
> >> + */
> >> +static void ext4_iomap_punch_delalloc(struct inode *inode, loff_t offset,
> >> +				     loff_t length, struct iomap *iomap)
> >> +{
> >> +	down_write(&EXT4_I(inode)->i_data_sem);
> >> +	ext4_es_remove_extent(inode, offset >> inode->i_blkbits,
> >> +			DIV_ROUND_UP_ULL(length, EXT4_BLOCK_SIZE(inode->i_sb)));
> >> +	up_write(&EXT4_I(inode)->i_data_sem);
> >> +}
> >> +
> >> +static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
> >> +					    loff_t length, ssize_t written,
> >> +					    unsigned int flags,
> >> +					    struct iomap *iomap)
> >> +{
> >> +	loff_t start_byte, end_byte;
> >> +
> >> +	/* If we didn't reserve the blocks, we're not allowed to punch them. */
> >> +	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
> > 
> > Will we ever get IOMAP_F_NEW here? I think the da_write_begin() call
> > either creates a new IOMAP_DELALLOC extent or finds older ones which
> > won't have EXT4_MAP_NEW set
> > 
> 
> Oops. This is a bug！ In ext4_da_map_blocks(), when allocating a new
> delalloc extent, the EXT4_MAP_NEW flag should be set. If this flag is
> not set, then when a short write occurs, we cannot distinguish whether
> an extent is a pre-existing delalloc extent or a newly allocated one.
> This prevents the subsequent truncate operation from being executed,
> leaving the newly allocated delalloc extent behind. I will fix this in
> next iteration.

Yes thats true I misread the condition and missed that we will always
exit early here :/

Regards,
ojaswin

> 
> Thanks,
> Yi.
> 
