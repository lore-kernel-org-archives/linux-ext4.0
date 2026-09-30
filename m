Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5FB489FC9
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 10:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790764639; cv=none; b=cXK8f7ERxOyczMd2eht0VY8n3v6yzDWpPvq3BRo3/vGJKkgkXs+YDUZqjlfW5VLMgPTnQjxfdnaAZJKgvWRRdnfD8GM2yhv0PY9zCHGZVYWI+JKbA/x5J5QOOdosMLE58vlDq6YML+yaUT/c5S5ifCVUw4T9QRL24EfxbonIZ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790764639; c=relaxed/simple;
	bh=JCZtISHdgmSthx2LQFweA7YSDAqYRAKoqXJv0f6Ybzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEij53vw+URhJ8Pt9LkvjU2wCdwHqAqHmCWyZI1PQ0+dIwrvfGgOtvFsrvUP8IvCGqHcs2juOtcTeTQ1SyjYw6FccUeMRPFMsklKqJDuxW4mKC4NX4YvtAP0E2DQX9fSjNbMWdcZH5DwKIwSMqxmdUk0Dyolrir8gEzDs0DlSwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mp+29/zP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mp+29/zP"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68U7adjB537577;
	Wed, 30 Sep 2026 10:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=8iOFvvAlATg+Gv6ie7muo5D3r1nnW1
	x4w6Nylh03h40=; b=mp+29/zPbPcWvnbx2YD2+tZf/VANauLxqx+ZEQZXfw5CWI
	mUCicnYkLVHrcpL+3vBFq2Hbm2TZUsJoXXefWrY1a0jjsvuoqVpfCBH9naDjW8pI
	qiH7lejrKh29eVEBDHXx/8buxLuVo+gk8R/iwFr3GLZrYl6YkXqcOIAMZB5Dr17x
	WbhuhK26imsX0UMG4WpReCmnNVou0HJ0TSG2U2S2pdtnZkC21HKt+YPEnpmwtf4P
	jYXSbsWrrdojmk4F04VM/SSx+RA2rK6Il7HhqzMZcyL8Gr+7ckGPocWcdwLzVklS
	WGDa5TVW8ohu7ik5kn4kOyAQY+RiQLDQru2ygtOg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qrcbpd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 10:37:04 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68U7lVv03126458;
	Wed, 30 Sep 2026 10:37:03 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h0g8e3p68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 10:37:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68UAb1A449938774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Sep 2026 10:37:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 837542004F;
	Wed, 30 Sep 2026 10:37:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 285872004B;
	Wed, 30 Sep 2026 10:36:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.112])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Sep 2026 10:36:58 +0000 (GMT)
Date: Wed, 30 Sep 2026 16:06:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yizhang089@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH v6 15/31] ext4: implement writeback path using iomap
Message-ID: <arzmSIdTjf-S2N10@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-16-yi.zhang@huaweicloud.com>
 <20260903133650.EDC101F00A3D@smtp.kernel.org>
 <bda020e4-2145-4c30-9330-ff8f9a6ff517@gmail.com>
 <arzNeYSTqq-Z4gXM@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <217106f8-bad8-4834-bc1a-30f3197bfc63@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <217106f8-bad8-4834-bc1a-30f3197bfc63@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0MiBTYWx0ZWRfX5ocRCLxdkxK4
 ag+CL4qNsuJTNW0KHj8h4rvKVTb70EdHDjX6ts76fTtB/gLkxdKcMrQ6aYNRzgekPidwEZo5ctP
 UdRXhG0RDLPDlbpBrUAMbaOXo+O10NeD+FESG9TMREvl0DMa6sSNP8qKHNgxHZgmgQOICBmZmzF
 JC9BPzs9ZpkygEL7Lr17LEZIZ7mwbp07Kk72APdWeC6j5RvCrNxuSkbzsMECzoa+G/JtKWGMUPp
 jIuwN2obRt7eiCOYYrlJTwbo/3XOU0u1gRgO5m6tumZc9eouYEfblP8SshARU9ts6RxaKiQv7ep
 +CvQRuRybjLsxfSAcM3n0QQJKl92aFmLZEB4BcPm8X/8BZml73nEc9lqvPq2PPeVxy4DEy1Ubhx
 pAhtMSUKdmjk7BNLz1Uw9SV21CUfBmqfKyMA/vgB8RcrKvDysaPSLLnKkih7si5OOdAzLK3oFby
 Ns4gnCBTBhiksBRpKJA==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6abce650 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=goy3cLK4Wlx_hzroHcIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: j7GV0yu6kWSxIfFWC2_XWM3gusF3QXPg
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0MiBTYWx0ZWRfXzv83o62QUE4F
 KEiG8r2olU9wHpQ1PFBGKFEYX6ln30nrw2nnz8jVEF7UNipCnRlQmN8+q6av/VEi3hfgaOwHoBX
 J80wqEEJC0dExtBeWCdavyWFWi7hW0g=
X-Proofpoint-GUID: STIZ_QEZuaTiUC9x-wf4B888_0cbt6Y7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609300042

On Wed, Sep 30, 2026 at 05:26:40PM +0800, Zhang Yi wrote:
> On 9/30/2026 4:51 PM, Ojaswin Mujoo wrote:
> > On Sat, Sep 12, 2026 at 04:28:52PM +0800, Zhang Yi wrote:
> > > On 9/3/2026 9:36 PM, sashiko-bot@kernel.org wrote:
> > > > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > > > - [Critical] Journal Credits Exhaustion / Panic in `ext4_iomap_finish_ioend()` due to arbitrarily large merged ioends.
> > > > - [High] Infinite loop in `ext4_iomap_map_writeback_range` due to open-coded ENOSPC retry logic without limits.
> > > > --
> > > > 
> > > > commit e7cc5164579a940550c93afb2dfec1f186e079ed
> > > > Author: Zhang Yi <yi.zhang@huawei.com>
> > > > ext4: implement writeback path using iomap
> > > > 
> > > > This commit adds the iomap writeback path for ext4 buffered I/O, introducing
> > > > new writeback operations and end I/O handlers. It maps and allocates blocks
> > > > as unwritten extents during writeback to prevent stale data exposure.
> > > > 
> > > > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > > > index 1f18854b9cdd3..f7d7610197a1c 100644
> > > > > --- a/fs/ext4/inode.c
> > > > > +++ b/fs/ext4/inode.c
> > > > 
> > > > [ ... ]
> > > > 
> > > > > +static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
> > > > > +					  loff_t offset, unsigned int dirty_len)
> > > > > +{
> > > > 
> > > > [ ... ]
> > > > 
> > > > > +retry:
> > > > > +	map.m_lblk = index;
> > > > > +	map.m_len = min_t(unsigned int, MAX_WRITEPAGES_EXTENT_LEN, blk_len);
> > > > > +	ret = ext4_map_blocks(NULL, inode, &map,
> > > > > +			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
> > > > > +			      EXT4_GET_BLOCKS_METADATA_NOFAIL |
> > > > > +			      EXT4_GET_BLOCKS_IO_SUBMIT |
> > > > > +			      EXT4_EX_NOCACHE);
> > > > > +	if (ret < 0) {
> > > > > +		if (ext4_emergency_state(sb))
> > > > > +			return ret;
> > > > > +
> > > > > +		/*
> > > > > +		 * Retry transient ENOSPC errors, if
> > > > > +		 * ext4_count_free_blocks() is non-zero, a commit
> > > > > +		 * should free up blocks.
> > > > > +		 */
> > > > > +		if (ret == -ENOSPC && journal && ext4_count_free_clusters(sb)) {
> > > > > +			jbd2_journal_force_commit_nested(journal);
> > > > > +			goto retry;
> > > > > +		}
> > > > 
> > > > [Severity: High]
> > > > Could this open-coded retry loop result in an infinite hang under certain
> > > > conditions?
> > > > 
> > > > If a non-root user fills the disk up to the threshold of root-reserved
> > > > blocks, ext4_map_blocks() will return -ENOSPC because the block allocator
> > > > denies access to reserved blocks for non-root users.
> > > > 
> > > > However, ext4_count_free_clusters() returns the total free space including
> > > > those root-reserved blocks. Because the count evaluates as non-zero, the code
> > > > will force a journal commit and goto retry indefinitely, without any loop
> > > > limits.
> > > > 
> > > > Should this retry logic use a limit like ext4_should_retry_alloc(), or
> > > > specifically account for root-reserved blocks to prevent a soft lockup in
> > > > the writeback worker thread?
> > > > 
> > > 
> > > This logic is inherited from the existing buffer_head writeback path
> > > (the -ENOSPC handling in ext4_do_writepages()), which also retries after
> > > a forced commit without any limit, so it does not introduce a new class
> > > of problem.  That said, I agree that bounding the number of retries is
> > > better, and I will add a limit in the next version.
> > > 
> > > 
> > > > > diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> > > > > index 0236b6b9785a2..9b0e12b5463cf 100644
> > > > > --- a/fs/ext4/page-io.c
> > > > > +++ b/fs/ext4/page-io.c
> > > > 
> > > > [ ... ]
> > > > 
> > > > > +static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
> > > > > +{
> > > > 
> > > > [ ... ]
> > > > 
> > > > > +	/*
> > > > > +	 * We may need to convert one extent, update the i_disksize and
> > > > > +	 * dirty the inode.
> > > > > +	 */
> > > > > +	credits = ext4_chunk_trans_blocks(inode,
> > > > > +			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
> > > > > +	handle = ext4_journal_start(inode, EXT4_HT_EXT_CONVERT, credits);
> > > > > +	if (IS_ERR(handle)) {
> > > > > +		ret = PTR_ERR(handle);
> > > > > +		goto out_err;
> > > > > +	}
> > > > 
> > > > [ ... ]
> > > > 
> > > > > +void ext4_iomap_end_io(struct work_struct *work)
> > > > > +{
> > > > > +	struct ext4_inode_info *ei = container_of(work, struct ext4_inode_info,
> > > > > +						  i_rsv_conversion_work);
> > > > > +	struct iomap_ioend *ioend;
> > > > > +	struct list_head ioend_list;
> > > > > +	unsigned long flags;
> > > > > +
> > > > > +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> > > > > +	list_replace_init(&ei->i_rsv_conversion_list, &ioend_list);
> > > > > +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> > > > > +
> > > > > +	iomap_sort_ioends(&ioend_list);
> > > > > +	while (!list_empty(&ioend_list)) {
> > > > > +		ioend = list_entry(ioend_list.next, struct iomap_ioend, io_list);
> > > > > +		list_del_init(&ioend->io_list);
> > > > > +		iomap_ioend_try_merge(ioend, &ioend_list);
> > > > > +		ext4_iomap_finish_ioend(ioend);
> > > > > +	}
> > > > > +}
> > > > 
> > > > [Severity: Critical]
> > > > Is there a risk of exhausting journal credits and panicking JBD2 when ioends
> > > > are merged?
> > > > 
> > > > In ext4_iomap_end_io(), iomap_ioend_try_merge() merges contiguous completions
> > > > into an arbitrarily large ioend. When this merged ioend is later passed to
> > > > ext4_iomap_finish_ioend(), it requests credits using ext4_chunk_trans_blocks().
> > > > 
> > > > However, ext4_chunk_trans_blocks() internally hardcodes the extent count to 1,
> > > > allocating credits sufficient for modifying only a single extent on disk.
> > > > 
> > > > If a user writes a very large contiguous file (e.g., larger than 128MB), the
> > > > merged ioend will exceed the maximum size of a single unwritten extent in ext4
> > > > (which is 32,768 blocks). This will cause ext4_convert_unwritten_extents() to
> > > > loop over multiple extents using the same transaction handle.
> > > > 
> > > > Could this exhaust the single-extent credits provided by the transaction
> > > > handle, resulting in a JBD2 panic during writeback?
> > > > 
> > > 
> > > This is right.  ext4_convert_unwritten_extents() converts every extent
> > > covered by the ioend using a single transaction handle, but that handle
> > > was sized by ext4_chunk_trans_blocks() for one extent only, so a large
> > > enough merged ioend can run out of credits.  This is hard to hit in
> > > practice, since the end I/O worker normally runs promptly and not many
> > > completed ioends accumulate before the merge, but to be safe I will
> > > still fix it: call ext4_journal_ensure_credits() before each extent in
> > > the conversion loop, so that the transaction is extended, or restarted
> > > once it is full, as needed, and correct the estimation to
> > > ext4_meta_trans_blocks(inode, max_blocks, 1, 0) at the same time, as no
> > > data blocks are allocated there.
> > 
> > Yes I agree that it seems like a valid issue. I'm a bit unfamiliar
> > with the journal ensure credits logic but seems like it would be
> > stopping the running txn and starting a new transaction right?
> 
> Yes, the change is also very simple, please see:
> 
> https://github.com/zhangyi089/linux/commit/d8078ca0dd93bd92c0fa0904e1c76b112339f48d

Got it.

> 
> > 
> > If so, maybe lets move the idisksize update after the the conversion so
> > that its updated in the final transaction, once the conversion is
> > complete, which is a bit cleaner.
> > 
> 
> That won't work. Since the conversion may be split across different
> transactions, a single transaction can no longer provide the atomicity
> guarantee for both the conversion and the i_disksize update. If we do
> the conversion first and then lose power after some of the conversion
> transactions have committed, we would end up with written extents beyond
> EOF, which would make fsck complain.

Oh I didn't know that makes fsck complain. I was thinking that it'd be
better than having an i_disksize updated but half converted data inside.
But sure, its fine as it is then.

> 
> Thanks,
> Yi.
> 
