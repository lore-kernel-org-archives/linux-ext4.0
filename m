Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D71348C51;
	Tue, 19 May 2026 13:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197566; cv=none; b=XbJcWHyBhQYs74WjfMCvhcag4/JyCMjd0iQzD3AQa5eS6oSuVy+Gnhltypx3BOaVMZKvguw6LpYpE4gJ9uw9dFFtp+VjAw5ZB6Y06HDXqapPuS7mXWgZdLYSXB+vMpEoFPTZCZSj9rKOyT2oA57WCclgbvW6CL4d1jTC2L8Jlo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197566; c=relaxed/simple;
	bh=3cHr0P6r/gqCCb5AbTJUZUBpyzx5kPfo72UmQqAirFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkBy4UrbDIl65xo97qZYJvD/Gdn8dHhQXgIxQCdlMzivtSZdhoM5EssX372K+UVd0jZ1db0N9UIUjdZ4AjyZPNHLNFf/z2iC42FGvOPZvd3zAk+fq0KnXy6afnx1qRj1iG33CeUz9YI1ItPT7CtM+G69E7VNpN5HiOPB5jv8e3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sFTz1ZOb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sFTz1ZOb"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64JA6xIa3601206;
	Tue, 19 May 2026 13:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=6ux/FtjeLBoDEjXNNqPlSxxpDzWNLn
	za1A0LYRLAAVA=; b=sFTz1ZObss8usg+sfCsZBYIPBodkGPrqZn8v6pmAEorD7A
	rwDO0m1OhdW2kK/nJqfYa1BSeX/+VBJI8RFakcZzp+iEYpj28ZFZngjtXPENAnUE
	az9s/vCeoMLF/pSyolybiffOY9cmp9McOSE/vC39yYHA8mHXq6zElLc3sbzAj/y1
	C4jKAQFthnVt1edSR9g/IsOgVy/K7/BGGjyXNEi+OrO0P3mf97X5Y3wRhQ+H0vl3
	+tsxXwDbQJxzcq5Yr2d8oVh9+vJGO8GS076VIVumz+qEJt8MMJ/1pnJljPsX2B+F
	wbnM0l3jhn0+9yUW+wdSJLjKXYjnl9+7+tt8rtuQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mn623-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 13:32:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64JDO6Q2029597;
	Tue, 19 May 2026 13:32:09 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75ky2h7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 13:32:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64JDW86138011328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 13:32:08 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CAF22004E;
	Tue, 19 May 2026 13:32:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77BD520043;
	Tue, 19 May 2026 13:32:03 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.216.235])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 13:32:03 +0000 (GMT)
Date: Tue, 19 May 2026 19:01:07 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 07/23] ext4: do not use data=ordered mode for inodes
 using buffered iomap path
Message-ID: <agxmG0MhIywySPaA@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-8-yi.zhang@huaweicloud.com>
 <agw-Wt4c4Fwevezk@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agw-Wt4c4Fwevezk@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: I_O2iLR4W2vc0i9XCPKo7WAHdTSHbwDt
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0c665b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=i0EeH86SAAAA:8
 a=1nahD9MOO5dbbhZlnKQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: YvcdTUOwVt4JyEB4q2YRxMKLkjxBePu1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEzMCBTYWx0ZWRfX9oHelhHLLmhZ
 nwHjRJoqkap61XW3NlD9ITSS+INZD8qabtg2TLTYreGtrMbDFoLlE/jG7aZ2farSwMF8J86NosE
 MmkcaWqc4u4tk3h1809zOSGh02qIewA1CjDKEG1WjVSTa8WIOSPC70Lzri4cuuu4tnbJKgeEynW
 JQvEx4D6+ndKhrQoBU6joeLSwC8TpPRfNzoAm+IKEQPef936XFC64gm8lMnlFXQGppdg2j6L63z
 C1HzsXHa68mgHAho8QMB8iNgFCpaFwBMlNqMl0bL4+zZx3nHFPOUUGftzy9jb5Y49gpdtavYrOC
 O0OSPqznk6bw5Tq7bFN/emUlYRGtZRQLLciA5OGzQb9HO4Ke9U9oXjEd/baCU22dQ9s7Nm34yVu
 cYbpWiL4kQRl3KEh+ACHRbA5AdVL+UJLJKZS+0hDBABUo8gKQbkDpSsKthLrQE6nuU6cCT/x2c2
 sa4Eeaqx2UGZa1rgyKw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190130

On Tue, May 19, 2026 at 04:11:30PM +0530, Ojaswin Mujoo wrote:
> On Mon, May 11, 2026 at 03:23:27PM +0800, Zhang Yi wrote:
> > From: Zhang Yi <yi.zhang@huawei.com>
> > 
> > The data=ordered mode introduces two fundamental conflicts with the
> > iomap buffered write path, leading to potential deadlocks.
> > 
> > 1) Lock ordering conflict
> >    In the iomap writeback path, each folio is processed sequentially:
> >    the folio lock is acquired first, followed by starting a transaction
> >    to create block mappings. In data=ordered mode, writeback triggered
> >    by the journal commit process may attempt to acquire a folio lock
> >    that is already held by iomap. Meanwhile, iomap, under that same
> >    folio lock, may start a new transaction and wait for the currently
> >    committing transaction to finish, resulting in a deadlock.
> 
> Right, makes sense.
> > 
> > 2) Partial folio submission not supported
> >    When block size is smaller than folio size, a folio may contain both
> >    mapped and unmapped blocks. In data=ordered mode, if the journal
> >    waits for such a folio to be written back while the regular writeback
> >    process has already started committing it (with the writeback flag
> >    set), mapping the remaining unmapped blocks can deadlock. This is
> >    because the writeback flag is cleared only after the entire folio is
> >    processed and committed.
> 
> Okay so IIUC, if we do end up using iomap with ordered data, there are 2
> codepaths with issues here:
> 
> txn_commit
>   ordered data writeback (say it goes via iomap)
> 	  folio_lock
> 		iomap_writeback_folio
> 			folio_start_writeback
> 			  iomap_writeback_range
> 				  ext4_map_block
> 					  txn_start
> 						  wait for tnx commit - DEADLOCK
> 
> Currently we avoid this by having ext4_normal_submit_inode_buffers()
> pass can_map = 0 so journal flush makese sure not to start any txn.
> 
> Then we have
> 
> txn_commit                          background writeback (via iomap)
> 
>                                     folio_lock()
>   ordered data writeback
> 	  folio_lock
> 			  
>                                 		iomap_writeback_folio
>                                 			folio_start_writeback
>                                 			  iomap_writeback_range
>                                 				  ext4_map_block
>                                 					  txn_start
> 																						  wait for txn commit - DEADLOCK

Sorry I forget to remove tabs

this is what I meant:

txn_commit
  ordered data writeback (say it goes via iomap)
    folio_lock
    iomap_writeback_folio
      folio_start_writeback
        iomap_writeback_range
          ext4_map_block
            txn_start
              wait for tnx commit - DEADLOCK

Currently we avoid this by having ext4_normal_submit_inode_buffers()
pass can_map = 0 so journal flush makese sure not to start any txn.

Then we have

txn_commit                          background writeback (via iomap)

                                    folio_lock()
  ordered data writeback
    folio_lock

                                    iomap_writeback_folio
                                      folio_start_writeback
                                        iomap_writeback_range
                                          ext4_map_block
                                            txn_start
                                              wait for txn commit - DEADLOCK


> 	  
> Currently, this is taken care because we try to start the txn before
> taking any folio locks/starting writeback, and hence we cannot deadlock.
> 
> If the above description makes sense, do you think it'd be good to add
> them to the commit message. The reason is that although these paths seem
> obvious when we look at them a lot, it took me a good bit of time to
> understand what deadlocks you are talking about here :p
> 
> Having the code traces like above makes it very clear.
> > 
> > To support data=ordered mode, the iomap core would need two invasive
> > changes:
> >  - Acquire the transaction handle before locking any folio for
> >    writeback.
> >  - Support partial folio submission.
> > 
> > Both changes are complicated and risk performance regressions.
> > Therefore, we must avoid using data=ordered mode when converting to the
> > iomap path.
> > 
> > Currently, data=ordered mode is used in three scenarios:
> >  - Append write
> >  - Post-EOF partial block truncate-up followed by append write
> >  - Online defragmentation
> > 
> > We can address the first two without data=ordered mode:
> >  - For append write: always allocate unwritten blocks (i.e. always
> >    enable dioread_nolock), preserving the behavior of current
> >    extent-type inodes.
> >  - For post-EOF truncate-up + append write: postpone updating i_disksize
> >    until after the zeroed partial block has been written back.
> 
> I'm still going through how we are addressing no data=ordered so will
> get back on this in some time.
> 
> Thanks,
> Ojaswin
> 
> > 
> > Online defragmentation does not yet support iomap; this can be resolved
> > separately in the future.
> > 
> > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > ---
> >  fs/ext4/ext4_jbd2.h | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> > index 63d17c5201b5..26999f173870 100644
> > --- a/fs/ext4/ext4_jbd2.h
> > +++ b/fs/ext4/ext4_jbd2.h
> > @@ -383,7 +383,12 @@ static inline int ext4_should_journal_data(struct inode *inode)
> >  
> >  static inline int ext4_should_order_data(struct inode *inode)
> >  {
> > -	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE;
> > +	/*
> > +	 * inodes using the iomap buffered I/O path do not use the
> > +	 * data=ordered mode.
> > +	 */
> > +	return !ext4_inode_buffered_iomap(inode) &&
> > +		(ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE);
> >  }
> >  
> >  static inline int ext4_should_writeback_data(struct inode *inode)
> > -- 
> > 2.52.0
> > 
