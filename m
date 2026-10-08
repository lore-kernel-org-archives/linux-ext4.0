Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE5648B385;
	Thu,  8 Oct 2026 09:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791450965; cv=none; b=d2U7o4SJxZ/aBz7WM1xjEuoGpH/96Fs2WFCYtk6croN5XiOFDbUlz9nUNw3MvGsTaeUj9c8DjVKw84nyraI0TRF3yyIH3tvEzcz6tPm7NmNPwUB/IkucMQEze93+jus/HXbt01wHOi0voO9qxTXeBWiBlVnHiKIhq8DhFbWmuoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791450965; c=relaxed/simple;
	bh=UIsXSiFKaGk53icWMjrx4UkB9SqFaMiLzgXEk2BmWlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTolKYTHUyCztKwnpnuEPZwh2d1UBQYYrDLJThYdtfWZGzEQQNM1aqd+5ilsyzP4h8O0BC62q23pKZA2WdvMK0Y1kCZYd0tuUef/XoqmZp0J0v7nSQnBYKuHGXT8nMvKwoflajqklX/G/fI78eSyfC9xbWGxDHCpoCyAGw1ONhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=L0EJb0Id; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="L0EJb0Id"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987ZuAR3705750;
	Thu, 8 Oct 2026 09:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=f1Gk1X0duFy/6YMGt1StUfEoeu+Y+C
	K5cAfKnih5i0s=; b=L0EJb0IdLUCHCQ7ZWUvkg9zB0j8Gr3iKv/UBZ853+axbjw
	M2SM71jw2+dQJ1d4I0bHl9iYDJ5Qh2wMhZVdBf8BV0W8yRQh8663gSvxXQYmUlwd
	5zEuhYIJYexgSEAQdr0EHgcsF5u37kcn7pmm6UkPwpaVe5Oh1OmqCBzdpAzzn3OM
	+3fWii8TuFA42pQE0ganHe91Wa/XX8Y6uE8Rpa4RQj6+F2LCDjfCi0rKgqAFpsV5
	2b+cqvRIVTHa2RTKhfx63EGyzBoGDy2WQUiIDY7PJMdHKP9Kdia77G46dv5XIY5e
	Kjef201PBPtkPzTMSK2thk5m5YHzjWTVQjBsLbIg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xk1actw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 09:15:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6987IZlQ1873310;
	Thu, 8 Oct 2026 09:15:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5f3twftc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 09:15:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6989FFWb28181198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 09:15:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 399C920043;
	Thu,  8 Oct 2026 09:15:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1461520040;
	Thu,  8 Oct 2026 09:15:10 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.26.191])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  8 Oct 2026 09:15:09 +0000 (GMT)
Date: Thu, 8 Oct 2026 14:45:07 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ritesh.list@gmail.com, djwong@kernel.org,
        hch@infradead.org, yi.zhang@huawei.com, chengzhihao1@huawei.com,
        yangerkun@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 22/31] ext4: submit and wait for pending disksize-grow
 I/O on writeback
Message-ID: <asdfG0W0iy0QytRn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-23-yi.zhang@huaweicloud.com>
 <asNnFY8N3NJwucWe@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <08dfc1dc-adc6-41ed-aaa5-7af7836f71c7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08dfc1dc-adc6-41ed-aaa5-7af7836f71c7@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=YtCa1IYX c=1 sm=1 tr=0 ts=6ac75f26 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=i0EeH86SAAAA:8
 a=ha-7zDi_GHLojtdCRTUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzNiBTYWx0ZWRfX1jhngSDcNfi4
 m/QLic9ZiG0QQXmlNs9z9+MjVgyvJiAyN62YZLhE1Bzb9/u93lmYxKOzl6VCign19OC0JQj0LGF
 R5zrn0xANezzZZheZKDwBgb69kHg/76jnOfxM9vEokTjDP8fWvxt1Fbrwy5E193T05OFN9vrSFq
 dwh2tg5YHfRbJU4fx0+X/nOaGg90Su1UUrMSRJz4wmKltyOIZqzk0HRchJC+Kn2wrrk0XMuGoQp
 jXeRPzRSbA/TLKUPY/1vWw/L3iVxDjSLlToLUSILmJh2KDP9xQ7I2Z2BZN/iWEtt0sxB1Ajz9G7
 +rBgW6TcmQ+TRIC3lgZu7YYmpXj4tf/1tT7F7PqMFCJYk3hlRWb0kJwrpcJLedHE4D4INtqsn1B
 /8O2yX+r01bc3cToR00GLnNQ5L/14rrzk8NLzU2Di7PIfTyP24ZoNhfYd9IwkZnJH/H0xwuNBUs
 zshWnkm2oWo9vbpW8vw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzNiBTYWx0ZWRfX9a6IX1XKebig
 UGxpK3KZl4nHRbsfpIOOVwzu9BOHy54JuG80L9E67v1VedbGBWaliu0AHGxEClchNacwn4jaq9C
 5pKh05rjx3r2l9KyfizsrVXCOGep0JM=
X-Proofpoint-GUID: 9RP3FXm09ATNzMK8b7rwIPFn2RULEeRi
X-Proofpoint-ORIG-GUID: -c3DxVb4v-s6dvgxZF_pp3nJx7Gpjd5Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080036

On Thu, Oct 08, 2026 at 04:53:24PM +0800, Zhang Yi wrote:
> On 10/5/2026 5:00 PM, Ojaswin Mujoo wrote:
> > On Thu, Sep 03, 2026 at 08:35:34PM +0800, Zhang Yi wrote:
> > > From: Zhang Yi <yi.zhang@huawei.com>
> > > 
> > > When the current writeback pass begins beyond the disksize-grow-pending
> > > zeroed EOF block, the ioend worker would otherwise have to wait for the
> > > pending EOF block to complete before it can advance i_disksize.
> > > Otherwise the old EOF block could be exposed as stale data once
> > > i_disksize advances past it.
> > > 
> > > Therefore, introduce the ioend mechanism for the pending range, tag
> > > ioends that cover the pending zeroed EOF block which straddles
> > > i_disksize with EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO in
> > > ext4_iomap_writeback_submit(), and clear the bit and wake up all waiters
> > > in ext4_iomap_end_bio() when such an ioend completes.
> > > 
> > > Clearing EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO does not depend on whether
> > > the disksize grow I/O succeeds. That is, even if the I/O fails, we still
> > > allow subsequent writes in the range to update i_disksize. This is
> > > consistent with the previous behavior, and we rely on data_err=abort to
> > > prevent metadata updates when data write failures occur.
> > > 
> > > In order to avoid the ioend that passes the pending range waiting for a
> > > long time, proactively submit the pending range first in
> > > ext4_iomap_writepages() so it completes in parallel with the rest of the
> > > writeback.
> > > 
> > > Note that the handling of discarding the zeroed EOF folio will be
> > > processed later, otherwise the bit will be set forever.
> > > EXT4_STATE_DISKSIZE_GROW_PENDING will be set after everthing is done.
> > > 
> > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > ---
> > >   fs/ext4/ext4.h    |  6 ++++++
> > >   fs/ext4/inode.c   | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
> > >   fs/ext4/page-io.c | 40 +++++++++++++++++++++++++++++++++++
> > >   3 files changed, 98 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index 1c3d736fb700..089dbd39c5c2 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -3986,6 +3986,12 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
> > >   			     __u64 len, __u64 *moved_len);
> > >   /* page-io.c */
> > > +/*
> > > + * The I/O range covers the zeroed EOF block that straddles i_disksize
> > > + * and will advance it upon completion.
> > > + */
> > > +#define EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO	1UL
> > > +
> > >   extern int __init ext4_init_pageio(void);
> > >   extern void ext4_exit_pageio(void);
> > >   extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 05dd4ee805fb..4239be5a769f 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -4366,7 +4366,10 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
> > >   				       int error)
> > >   {
> > >   	struct iomap_ioend *ioend = wpc->wb_ctx;
> > > -	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
> > > +	struct inode *inode = ioend->io_inode;
> > > +	struct ext4_inode_info *ei = EXT4_I(inode);
> > > +	unsigned int blocksize = i_blocksize(inode);
> > > +	loff_t pstart, plen;
> > >   	/*
> > >   	 * After I/O completion, a worker needs to be scheduled when:
> > > @@ -4379,6 +4382,21 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
> > >   	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
> > >   		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> > > +	/*
> > > +	 * Mark the I/O as DISKSIZE_GROW_IO by setting io_private to
> > > +	 * EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO if it covers the pending range.
> > > +	 * Such I/O will allow or trigger i_disksize advancement in the
> > > +	 * ioend worker.
> > > +	 */
> > > +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
> > > +	if (plen &&
> > > +	    round_down(ioend->io_offset, blocksize) <= pstart &&
> > > +	    round_up(ioend->io_offset + ioend->io_size, blocksize) >=
> > > +			pstart + plen) {
> > > +		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> > > +		ioend->io_private = (void *)EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO;
> > > +	}
> > > +
> > >   	/*
> > >   	 * ext4_iomap_end_bio() always defers endio processing, disable
> > >   	 * generic BIO in task to avoid double deferral since we will use
> > > @@ -4398,6 +4416,33 @@ static const struct iomap_writeback_ops ext4_writeback_ops = {
> > >   	.writeback_submit = ext4_iomap_writeback_submit,
> > >   };
> > > +/*
> > > + * If the current writeback range begins after the pending zeroed EOF
> > > + * block range which straddles i_disksize, issue a separate writeback to
> > > + * flush it first, so as to avoid prolonged waiting.
> > > + */
> > > +static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
> > > +					    struct writeback_control *wbc)
> > > +{
> > > +	struct address_space *mapping = inode->i_mapping;
> > > +	loff_t pstart, plen, range_start;
> > > +
> > > +	if (wbc->range_cyclic)
> > > +		range_start = (loff_t)mapping->writeback_index << PAGE_SHIFT;
> > > +	else
> > > +		range_start = wbc->range_start;
> > > +
> > > +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
> > > +	if (!plen || range_start < pstart + plen)
> > > +		return;
> > Hi Zhang,
> > 
> > Maybe we can check here if pstart lies withing the same folio as the
> > writeback range, then we don't need an explicit flush as we will anyways
> > flush out the whole folio. We can check against the
> > mapping_min_folio_nrbytes perhaps.
> > 
> 
> Hi Ojaswin,
> 
> Thank you for the suggestion. IIUC, do you mean to change it somewhat
> like the following:
> 
>       if (!plen ||
>           round_down(range_start, mapping_min_folio_nrbytes(mapping)) <
>                      pstart + plen)
>               return;

Hi Zhang, yep exactly, it's a small optimization for bs < ps on machines
like powerpc or arm16/64 which have larger page sizes. 

Regards,
ojaswin
> 
> The benefit is that it covers the case of blocksize < PAGE_SIZE, where
> the pending range occupies only part of the folio and range_start lands
> in the middle or later part of that same folio. It does not help when
> the pending range happens to be in a large folio, though, because
> mapping_min_folio_nrbytes() is only a lower bound on the folio size.
> That said, the pending range is the old EOF of the file and it is
> unaligned, so that folio can more likely to be a single page than a
> large one.
> 
> Or do you want it to be very precise, able to know exactly the size of
> the folio containing the pending range and its positional relationship
> with the writeback range? If the latter, that would require an exact
> folio lookup, which seems a bit expensive and perhaps over-optimization
> to me.
> 
> Thanks,
> Yi.
> 
