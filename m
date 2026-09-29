Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC3837BE89;
	Tue, 29 Sep 2026 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691661; cv=none; b=Niy1tauBxwoy6vioamUlzbv87uU6yQj5vMSbLP+yFUPXcNGVf7TEnPXrxrkpnisZpJ+PuxdG4SscAhJojFYRb5vDeb2NY4yKuVdKPbojsNjoMVloVviwO0qhGMxZPhb6Ovq1a+Ki0ZU6fHsYw0k9d4ENJ5p1pcTKGeqGG54R1NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691661; c=relaxed/simple;
	bh=wV2rJP3tmyR8AVMwZybWCJZqOs3IE7/E7fPuqHUjNuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qKk/o3I6l9734Nyd4e0g3b8ancVDsmwn+LIf1olzGgIaGZu5nBsz4HTltfeTB4mxaT2S+sU2mByDnr59pY0TJVJ1iWDUTCyoxVYPjJgpJzuvQYkD6o8JIczvDGejofuMa1deS2vp1tY/7wdR50rIwEZlv8nU7L+oYl+OnYasiks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QDZdqDmD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QDZdqDmD"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TB5XdR2187954;
	Tue, 29 Sep 2026 14:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UWe4Iv
	L58Nyoym73IxG6DEUy+2kq2bmo4lewD4NL3Qo=; b=QDZdqDmDeYuofb4ximbp/g
	NyqsvVYUzBPrOm2msSlQ9uzWQ78U34G1p952I4IzRmjLK83LedMf8Ogg/YYhnnFw
	X12bMuCA8DomYHQ6Xu7KeqW1Hu/9FoIncYXbpMP3BNkNBKLeTfdSHzPtiTfILOls
	ybDHFJyR8qQL0ZrqOuIkFR5GbazCawBgJqapdrb7bzPofoCHMmKx0x+h5qmJ7zqR
	3ElQ6oU5nJm3hrigfmoo914Fab3jdgJC8tzauREsiOmErf3svBAczqsrOscRib/l
	oxpN37SitbVu6vhGYBmxXxvIAq+66UXdYtrf0HiFTlIMCnKNcH5cqVgdn49Ua7sg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qr7eyt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 14:20:15 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68TAlkHP1657634;
	Tue, 29 Sep 2026 14:20:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxrcpt8bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 14:20:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68TEKDm142992086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 14:20:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE99620043;
	Tue, 29 Sep 2026 14:20:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5374520040;
	Tue, 29 Sep 2026 14:20:07 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.132])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 29 Sep 2026 14:20:06 +0000 (GMT)
Date: Tue, 29 Sep 2026 19:50:04 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 13/31] ext4: do not use data=ordered mode for inodes
 using buffered iomap path
Message-ID: <arvJFOk8hu5PvGhO@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-14-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903123543.2302999-14-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1NiBTYWx0ZWRfX2lE0boJJy3sO
 WuoMBHZCX9mN5E2jlNHOz1rS0xLGRkThA1LLjHHKwc7RCUyxrw9Yl4us0Pk92EwVq1a9N2q4Fr/
 zpLKOZ3CQQ748xc4o1ANT9/pyoWlNsyFf0/RzZNhd0QWgX0qKaFpUTtOz9guLGjqvJaVM7ck00v
 2v7PTHT+lS15XHmCf06WTkwj0RmjlIpM9pmEQ+pAL3YJj5aznkv1wqcWXXJTlg7ouygJ3nVEO9Q
 R/puDzPe0Ymbbk+MKjJhRzE1OD/u+iho1X62dmHTFtl25F4tDGEdhPzcCiulKu3sOY8jickcmFN
 lcvkbSRS1rT8i8DaxUI4j1wvjMLPg+0yrJHBV405SkxiupSWRZTt2FqcMVmEdqExAY0eQ8U7xM2
 ZE51IBYI8KqjhX76MegDCzFcnEuYZvQECKGoJIKAjiLiARlqjvr/bbKQK7dybny6TnXpQo1BuX4
 lvVxnLHlJFnfWHwnwKg==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6abbc920 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=LVheyv-4mJqS4r2D2jMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: iYGx4Li2BerXV7s7MGNf0ZzP3odoSff0
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1NiBTYWx0ZWRfXyLbnJBo3uWlv
 i4cbBIfP6KbfENrTP0fg+y3fwIfG+YTd6EriUFWJ1cAsIa6bdhSGjRz7IUNFac6xnA+oiDIVbMs
 yc1lhKBas0gmfbCZujWjd6VbvXyLAsI=
X-Proofpoint-GUID: r2k0AuLzt4-AOAX5-rCSx6tbjoa7vvQk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609290056

On Thu, Sep 03, 2026 at 08:35:25PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The data=ordered mode introduces two fundamental conflicts with the
> iomap buffered write path, leading to potential deadlocks.
> 
> 1) Lock ordering conflict
>    In the iomap writeback path, each folio is processed sequentially:
>    the folio lock is acquired first, followed by starting a transaction
>    to create block mappings.
> 
>    In data=ordered mode, writeback triggered by the journal commit
>    process may attempt to acquire a folio lock that is already held by
>    iomap background writeback process. Meanwhile, iomap, under that same
>    folio lock, may start a new transaction to map other blocks on this
>    folio and wait for the currently committing transaction to finish,
>    resulting in a deadlock.
> 
>    Trans N commit                    background writeback(via iomap)
> 
>    journal_submit_data_buffers()
>     ext4_journal_submit_inode_data_buffers()
>      iomap_writepages()
>                                      iomap_writepages()
>                                      folio_lock()
>       folio_lock()  -- wait
>                                       iomap_writeback_folio()
>                                        iomap_writeback_range()
>                                         ext4_journal_start()
>                                          start new transaction
>                                           -- wait for trans N commit,
> 					     DEADLOCK
>                                          ext4_map_blocks()
> 
>    Currently, in the buffer_head writeback path, this is handled by
>    starting the transaction before taking any folio locks for writeback.
> 
> 2) Partial folio submission not supported
>    When block size < folio size, a folio may contain both mapped and
>    unmapped blocks. In data=ordered mode, a deadlock can occur if the
>    journal waits (pure JI_WAIT_DATA) for such a folio to be written back
>    while background writeback has already started on it (with the
>    writeback flag set). The problem is that mapping the remaining
>    delalloc blocks can deadlock because the writeback flag is not
>    cleared until the entire folio is processed and committed.
> 
>    T0: Assume we have a folio contains four blocks, from front to back,
>        they are A, B, C, D. The block B and C are holes, and the last
>        block D is written in delalloc mode (the block is not allocated
>        yet).
>    T1: The background writeback process starts to write back data, set
>        writeback flag on the folio, allocates block D, and adds it to
>        transaction N's order list of jbd2 in pure JI_WAIT_DATA mode.
>    T2: This folio completes the writeback and clears the writeback flag.
>    T3: Before transaction N commit, we buffered write block A to C.
>    T4: Transaction N commit and folio writeback are running
>        concurrently.
> 
>    Trans N commit                   background writeback(via iomap)
> 
>                                     iomap_writeback_folio()
>                                      folio_start_writeback()
>                                       -- set writeback flag
>    jbd2_journal_finish_inode_data_buffers()
>     __filemap_fdatawait_range()
>      -- wait writeback flag to clear
>                                       iomap_writeback_range()
>                                        ext4_journal_start()
>                                         start new transaction
>                                          -- wait for trans N commit,
>                                             DEADLOCK
>                                        ext4_map_block() (B, C)
> 
>    Currently, in the buffer_head writeback path, this is handled by:
> 
>    1. Partial folio submission — already-allocated buffers can be
>       submitted first. The writeback flag is cleared after I/O
>       completes, preventing block allocation while the writeback flag is
>       set.
>    2. Allocation order — the transaction is started first, then blocks
>       are allocated, the writeback flag is set, and finally the
>       allocated buffers submission begins.
> 
> To support data=ordered mode, the iomap core would need two invasive
> changes:
>  - Acquire the transaction handle before locking any folio for
>    writeback.
>  - Support partial folio submission.
> 
> Both changes are complicated and risk performance regressions.
> Therefore, we must avoid using data=ordered mode when converting to the
> iomap path.
> 
> Currently, data=ordered mode is used in three scenarios:
>  - Append write
>  - Post-EOF partial block truncate-up followed by append write
>  - Online defragmentation
> 
> We can address the first two without data=ordered mode:
>  - For append write: always allocate unwritten blocks (i.e. always
>    enable dioread_nolock), preserving the behavior of current
>    extent-type inodes.
>  - For post-EOF truncate-up + append write: postpone updating i_disksize
>    until after the zeroed partial block has been written back.
> 
> Online defragmentation does not yet support iomap; this can be resolved
> separately in the future.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks for adding the extra information in the commit.

Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  fs/ext4/ext4_jbd2.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 2fbf48b3dfe2..be54e93bde0b 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -379,7 +379,12 @@ static inline int ext4_should_journal_data(struct inode *inode)
>  
>  static inline int ext4_should_order_data(struct inode *inode)
>  {
> -	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE;
> +	/*
> +	 * inodes using the iomap buffered I/O path do not use the
> +	 * data=ordered mode.
> +	 */
> +	return !ext4_inode_buffered_iomap(inode) &&
> +		(ext4_inode_journal_mode(inode) & EXT4_INODE_ORDERED_DATA_MODE);
>  }
>  
>  static inline int ext4_should_writeback_data(struct inode *inode)
> -- 
> 2.52.0
> 
