Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8284367B75;
	Tue, 19 May 2026 16:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779209626; cv=none; b=C9rCmkqiB/gcnsIxNOYBK/h4cQ9m+YhR+keWTIuYEdhPDbExoXQWdxRc+klOUKjKtankZhh3zB3+sC5X4opKYiU0dRSMWS+5T9FPA+0wDCqdzP2wYdEFbp7VIZDPq9us17u3JdrOUqx9uVnw7v0DPYfU1uo/K+BTmcQN2MWOWIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779209626; c=relaxed/simple;
	bh=8cbOC0g6eBfu1gPgh/6E45FV9qWyVek2QqW8iIYbz68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RG6uZZdpbl7jO0hJB2rut3Y6nbkqGLAGoADatlWnK2vKobQG5SR6SjGlhFsgkIClt5+p2Rrb6I7PfPx61ROB1Wp9O5jnvsPVykdhIhwDu/Xk9GvQ8UEilSWSat72zH7Osb9bYbZaKlqKtgpolSQj9MQjSvQUcPRt+tHt0BXPz9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MCvjusZz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MCvjusZz"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J9HEGh3681418;
	Tue, 19 May 2026 16:53:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=OjtboeZy+ZPNFFOy6nwhJv9tsCWNf/
	b0mGKCqtei5zQ=; b=MCvjusZz5Bl+IQ861MvONBmgyaTb5WIM2X25Qg2Z37btsx
	G9pv7gCV8Mrfz9vNnQP5a5JU/mQQK/QCmFJK6X7SxHf1/IgT24TCkjAXrEF6LxDy
	2eDs5jHnTBs0/nRU5fS4AB/vv3qMPqa2c7LILvFoFknO7yDPSFtFb3uu5dNvqN7h
	rCrf3KN8eMt1ucmvcYuhw202d6ghCiap6LGsGs/zxJnk/zJGKZwZDHFBN+rr0cAH
	Vrj8BeHFHAwBoBpgRTDSU/FcS5LnPSVY2tALfl+sMahodPRyVMPmf1bRAKzonaLM
	8wEGYb46BS76Q07TEaOINRBxowtAy5PpLwp784nA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9xx6q5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 16:53:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64JGdBxc016580;
	Tue, 19 May 2026 16:53:12 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75ky3amk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 16:53:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64JGrBJ251184056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 16:53:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 286342004B;
	Tue, 19 May 2026 16:53:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80D0720043;
	Tue, 19 May 2026 16:53:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.216.228])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 16:53:06 +0000 (GMT)
Date: Tue, 19 May 2026 22:23:03 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 04/23] ext4: add iomap address space operations for
 buffered I/O
Message-ID: <agyVb1U0US8PVgqo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-5-yi.zhang@huaweicloud.com>
 <agwtJq5-B2E-t7zT@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <236657df-71f2-446d-b44b-39865219a850@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <236657df-71f2-446d-b44b-39865219a850@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDE2NiBTYWx0ZWRfXwNHT0AbVBdRE
 26+628SmqFhPGbD88FzTiPWaOfT2tWGf0r/cN9QcANehCe/aemLUzoOBeSHHnMkF2hagxr3I4BO
 5iN/403VJ/9osR+10anUjFt1dhyS2FNHar06iuR14lgugLELV3Ou9Tu6SghE3zgsVM6o6q5O0Fe
 nmLKpfPH4CyW3bK0PpLlguDkNlA+dbAWkrWRkd98fGhcpz3m+PjbD2CMXI47Zt2eaWiz+xGsCEq
 Sikmn+35iIueO/jCjeHXcfrhccgbZd/NO/ehtnpXNR0D8iqiV8hP4YVHbCuIKe9+8uUk6XnyrnF
 t7wVdyoM5hWqbirxvD/QH9Ljq040H5akhKLHpxiX9wbVFWLcKsDwU4t1Z2hf2Qw3Oy+EDuNB6Fp
 VuRJm3QgydmEvXIDSFk6eIuQO3VXm/5huUIQABGMvGub920WpJOcPVJORcx9w0a0YY5kEf36PBf
 5gz4+zvjTPjI67V5QFA==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0c957a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=vNxArqMt9eI__92vSwUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: WVS_YNpiRaGFDYD_7_Pi54mLCpvaKPJc
X-Proofpoint-GUID: 4klakqO-RGCItwgJC0VH2dGPKYbrMuZQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_04,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190166

On Tue, May 19, 2026 at 08:35:51PM +0800, Zhang Yi wrote:
> On 5/19/2026 5:28 PM, Ojaswin Mujoo wrote:
> > On Mon, May 11, 2026 at 03:23:24PM +0800, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> Introduce initial support for iomap in the buffered I/O path for regular
> >> files on ext4.
> >>
> >>   - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
> >>     inode uses iomap instead of buffer_head for buffered I/O
> >>   - Add helper ext4_inode_buffered_iomap() to check the flag
> >>   - Add new address space operations ext4_iomap_aops with callbacks that
> >>     will use generic iomap implementations
> >>   - Add ext4_iomap_aops to ext4_set_aops() when the flag is set
> >>
> >> The following callbacks(read_folio(), readahead(), writepages()) are
> >> provided as placeholders and will be implemented in later patches.
> >>
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >> Reviewed-by: Jan Kara <jack@suse.cz>
> > 
> > Hi Zhang, looks good to me. Just a questions below:
> 
> Hi, Ojaswin! Thank you for the review of this series.
> 
> >> ---
> >>  fs/ext4/ext4.h  |  7 +++++++
> >>  fs/ext4/inode.c | 32 ++++++++++++++++++++++++++++++++
> >>  2 files changed, 39 insertions(+)
> >>
> >> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> >> index 94283a991e5c..1e27d73d7427 100644
> >> --- a/fs/ext4/ext4.h
> >> +++ b/fs/ext4/ext4.h
> >> @@ -1972,6 +1972,7 @@ enum {
> >>  	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
> >>  	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
> >>  	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
> >> +	EXT4_STATE_BUFFERED_IOMAP,	/* Inode use iomap for buffered IO */
> >>  };
> >>  
> >>  #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> >> @@ -2040,6 +2041,12 @@ static inline bool ext4_inode_orphan_tracked(struct inode *inode)
> >>  		!list_empty(&EXT4_I(inode)->i_orphan);
> >>  }
> >>  
> >> +/* Whether the inode pass through the iomap infrastructure for buffered I/O */
> >> +static inline bool ext4_inode_buffered_iomap(struct inode *inode)
> >> +{
> >> +	return ext4_test_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
> >> +}
> >> +
> >>  /*
> >>   * Codes for operating systems
> >>   */
> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> index b1ef706987c3..178ac2be37b7 100644
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> >> @@ -3908,6 +3908,22 @@ const struct iomap_ops ext4_iomap_report_ops = {
> >>  	.iomap_begin = ext4_iomap_begin_report,
> >>  };
> >>  
> >> +static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +static void ext4_iomap_readahead(struct readahead_control *rac)
> >> +{
> >> +
> >> +}
> >> +
> >> +static int ext4_iomap_writepages(struct address_space *mapping,
> >> +				 struct writeback_control *wbc)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >>  /*
> >>   * For data=journal mode, folio should be marked dirty only when it was
> >>   * writeably mapped. When that happens, it was already attached to the
> >> @@ -3994,6 +4010,20 @@ static const struct address_space_operations ext4_da_aops = {
> >>  	.swap_activate		= ext4_iomap_swap_activate,
> >>  };
> >>  
> >> +static const struct address_space_operations ext4_iomap_aops = {
> >> +	.read_folio		= ext4_iomap_read_folio,
> >> +	.readahead		= ext4_iomap_readahead,
> >> +	.writepages		= ext4_iomap_writepages,
> >> +	.dirty_folio		= iomap_dirty_folio,
> >> +	.bmap			= ext4_bmap,
> >> +	.invalidate_folio	= iomap_invalidate_folio,
> >> +	.release_folio		= iomap_release_folio,
> >> +	.migrate_folio		= filemap_migrate_folio,
> >> +	.is_partially_uptodate  = iomap_is_partially_uptodate,
> >> +	.error_remove_folio	= generic_error_remove_folio,
> >> +	.swap_activate		= ext4_iomap_swap_activate,
> >> +};
> > 
> > So one question, for ->release_folio() we are using
> > iomap_release_folio() instead of ext4_release_folio() here which doesnt
> > make the jbd2_journal_try_to_free_bufferes() call. IIUC this function
> > seems to be trying to clean up already checkpointed buffers.
> > 
> > I wanted to check if ->release_folio() can be called for folios with
> > ext4 metadata buffers? (from my limited understanding of
> > shrink_folio_list() -> filemap_release_folio() it seems we can) And if
> > it can be called, is it okay to skip the
> > jbd2_journal_try_to_free_buffers call?
> 
> Here, in ->release_folio(), folio->mapping points to inode->i_data (the
> file's pagecache), not the block device's pagecache. ext4 metadata
> resides in the block device's pagecache, which is at a different layer
> than this release_folio callback. So we don't need to call
> jbd2_journal_try_to_free_buffers() in the iomap path here.

Hi Yi,

Thanks for clarify and yes, thats what I was missing! So this
->release_folio() is only for data folios. So I guess the
jbd2_journal_try_to_free_buffers() is mostly to handle data=journal
case?

Regardless, with that clarification feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> 
> Thanks,
> Yi.
> 
> > 
> > Regards,
> > ojaswin
> > 
> >> +
> >>  static const struct address_space_operations ext4_dax_aops = {
> >>  	.writepages		= ext4_dax_writepages,
> >>  	.dirty_folio		= noop_dirty_folio,
> >> @@ -4015,6 +4045,8 @@ void ext4_set_aops(struct inode *inode)
> >>  	}
> >>  	if (IS_DAX(inode))
> >>  		inode->i_mapping->a_ops = &ext4_dax_aops;
> >> +	else if (ext4_inode_buffered_iomap(inode))
> >> +		inode->i_mapping->a_ops = &ext4_iomap_aops;
> >>  	else if (test_opt(inode->i_sb, DELALLOC))
> >>  		inode->i_mapping->a_ops = &ext4_da_aops;
> >>  	else
> >> -- 
> >> 2.52.0
> >>
> 
