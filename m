Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794988576;
	b=DMtUtilZ7EogogHQMYl+gDGEz5QLEPDGgpcdXbKwY+8woHtEbZx6sN8IjQul8DQV5PqQ
	 +8N387vjr26qyE+Cb5t3wWiPKwNSlHmyGsLlxNW7r8djnLVe1KWFNE+IyObWPEKfdquoB
	 W3KhFp1UmthIxLz5P1MmwLyVwPHnx9lqQPuzoSJxKmi9gnChizH24C/+8KqBlyp7a+H6K
	 MejqSsuGjTWl2RJcCnoB98TlFmiGvdiAKKc7URnKmDDvIGjSTImpC9G/TzgYk3pFB+Vp8
	 dRDDx/3SabkFVD+LowG4K2f5lb1GZvWYY/4aL8orfmOjqchpadJg52kNTy0UiRxsKnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794988576;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=fIrLhrRb7HWwFrM50lSjxgBdeeHGu3eLMCmeEthkvMY=;
	b=R5UjYV4M/mOdMT+tpqLeEY/48IuForvSSVZAu9IA9fA288F8ghl+tcF17Ia/2rUUx3ah
	 e8DH+h6JRtohJbYKTH5xRtW+f/RhtJPh5yOV1jgNNcZOuTP3DomNc+zI1rDY/FWtc0l7i
	 BoyGul+rtePSuSgkUywqt4+TjGsBM/YtxhaXAuN8q9bAJVTJrcLGKILyIjHnXLb0ROy6V
	 hjga+zP9lvbKLsGkYPOml/Nc1SbdImQIxgJQnHYeHTqbOcIU8pOUxxI3pxdBAS5TuWSVN
	 U8Zc7BHej0DUxDWuH/K7c/PNiYcpoIMsPglT51qAP3fOYp/cObEy+iJ9gCJWoX95LPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=dIZN3nvC;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEB6606A325;
	Wed, 18 Nov 2026 07:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DEB6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=dIZN3nvC
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI2Ru1R031045;
	Wed, 18 Nov 2026 07:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=fIrLhrRb7HWwFrM50lSjxgBdeeHGu3
	eLMCmeEthkvMY=; b=dIZN3nvCgjgf7VrkO0BNStsscp2OXKqqCuqNfHFvceJxPL
	hTWL+NI5lBV5lVTy0FixUN0KFiH0W0rnl2+Ct80hOOg3S9oB2cYVoghcfM7SXaox
	xMRVlRXen1AvdsLSiebS2Hjqr1yDs2zMQDceyQErHneArl7KJz2C0xM5QdhRu6FR
	WZqkOQnDV+sauGpCMu0tKqMFry339bkJxyp9BwsNVQxUwr7UJSQYdouzgfXvzq0M
	ZEqzRfgmh4A2kfL3N/radDxnW2kAydLY8xJ+ua+9A07ta6ICnK0tgylZ4E2RHBuo
	3ZH7hPsSheUZtC3NpF1ISh2ZEGtPQAHTaSjWH/VQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j105n9eec-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 07:55:50 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI2YvLs274252;
	Wed, 18 Nov 2026 07:55:49 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j067nf16j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Nov 2026 07:55:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AI7tl5g44040500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Nov 2026 07:55:47 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CC6B2004E;
	Wed, 18 Nov 2026 07:55:47 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11C192004B;
	Wed, 18 Nov 2026 07:55:44 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Nov 2026 07:55:43 +0000 (GMT)
Date: Wed, 18 Nov 2026 13:25:41 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        guolingxing <guolingxing@tju.edu.cn>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
Message-ID: <av1Z_RLuH4vd0Wyi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAzMSBTYWx0ZWRfX8DWd+oFlGBqj
 L1X7/qJVHv0QMWwXg+VMkBrANiUA7ogT6Rt3pO7Tqv09NUylpZC26cMBeoeBrCT90jXxF60lwdO
 03rCGbCC3AXkXrWDD5F6/WPJDpyiAA3bN5C51b1fyWe8DwmBeV99gw6uOS+8+ufUpquwl+lxs9t
 e0/joEspnGB2RoJ3LAYfP6JzrPe+QUxYyAp9Lft3XWym/OifPVVAWtdhkcJmub9mKhvUSUhsfVU
 7bOvw7CSgQnb+nkQvouxocWH8anOx5L1XhqEPHDvOpOzhUrqSYReOVzk46ZV/RgXIyMqcfK2UBM
 oniGv+MxvPtbIZhciW7MMEm4AY6JjN1yUYSb4ZhwtJoIpqjU14IWR5srwASEQgI2n58F8HveRgw
 3yvJQ323U4RsD9MAbYS8WKOZHKxw+tvxJ3yvfjnmmRnUw7Nqo2BSB5a8UQxdadgZp/akFNGw3d+
 /VkSDIbRHn3D9tuSpig==
X-Authority-Analysis: v=2.4 cv=HN9WhYtv c=1 sm=1 tr=0 ts=6afd5a06 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=A4sCbYSIXBiezKmDcDQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: bdVgqKSR3onn_wMrRMvpllZSTDb5knVs
X-Proofpoint-ORIG-GUID: 4Z8Vwec6-YHpXD97sXroZ7E-EOKBaOn_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAzMSBTYWx0ZWRfXxX3ra5vEHjGP
 112JCFNL4rZ18ExSzaqn8IGyQbauGIjU2If+v4mxcSYSFy1ooIEeZCu81K59b1625mbGcLMKdW3
 KxbD/hb+Z32qFkaOa2IT5+57AhP4mtY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180031

On Tue, Nov 17, 2026 at 07:37:10PM +0800, Zhang Yi wrote:
> On 11/16/2026 10:27 AM, Jose Fernandez (Anthropic) wrote:
> > Ojaswin's cover letter [1] explains how, since commit ea96cb5c4ae3
> > ("ext4: don't split extent before submitting I/O"), the split of an
> > unwritten extent at I/O completion can get ENOSPC. [1] stops the zeroout
> > from hitting other writes in flight, and [2] reports the failed
> > conversion to fsync(). Neither gives the split its block, so data is
> > still lost.
> > 
> > LLM agents working with me found that it happens with default options
> > on a filesystem that is not full, and ran the tests. write() and fsync()
> > return success, and after the pages are evicted part of the file reads
> > back as zeros.
> > 
> > Under a load built to run the allocator dry (QEMU without KVM), 42 of
> > 72 files lost data at ea96cb5c4ae3, none of 72 at its parent and none
> > of 48 on v6.18.63. On mainline at 23c62304dde2 32 of 72 did. With [1]
> > rebased on it 42 of 72 still did, now as failed conversions in dmesg.
> > With [1] and [2] fsync() failed with ENOSPC on 47 of 72, and the other
> > 25 read back intact.
> > 
> 
> Hi Jose!
> 
> I'm sorry for causing this regression. The cause of this problem is that
> the transaction freeing the file's space has not yet been committed and
> thus cannot be returned to the mb allocator, so the extent cannot be
> split at endio time to allocate space for metadata. This is easily
> reproduced in scenarios with frequent file creation and deletion, even
> though there is still plenty of free space on disk.
> 
> I think the solution should be based on Ojaswin's counting approach in
> [1] or the PENDING_CONVERSION solution we discussed, and then, after
> extent splitting fails, try to flush the journal and retry. My idea is
> roughly as follows:
> 
> 1. For the iomap buffered I/O path and the DIO path, this is relatively
>    simple. We just need to add journal flush and retry logic in
>    ext4_iomap_finish_ioend() and ext4_dio_write_end_io().
> 
> 2. For the traditional bh buffered I/O path, we cannot flush the journal
>    in ext4_convert_unwritten_io_end_vec(), because this may lead to an
>    ABBA deadlock with data=ordered mode. The journal process needs to
>    wait for ordered folio writeback, but this folio may contain some
>    ranges that need to be converted, and if we flush the journal after
>    the conversion fails, it will form a mutual dependency with journal
>    flushing. Therefore, we have to fall back to splitting before issuing
>    I/O, and when splitting fails, flush the journal and retry via
>    jbd2_journal_force_commit_nested() in ext4_do_writepages().
> 
> 3. Split the workqueues used at the end of iomap and bh writeback to
>    avoid deadlocks. Because the filesystem may simultaneously have
>    different inodes going through the bh path and the iomap path, if the
>    iomap completion worker is flushing the journal, it may need to wait
>    for the folio of another inode going through the bh path to finish
>    conversion, and that conversion worker still needs to be handled on
>    the same wq, thus causing a deadlock.
> 
> The current bh buffered I/O handling flow cannot be unified with the
> other two, which is indeed not ideal. However, once data=ordered mode is
> sunset in the future, we should be able to unify them. What do you all
> think of this solution? Any better ideas?
> 
> Thanks,
> Yi.

Hey Zhang, thanks for the poc, it looks largely okay. I agree that this
seems to be the right way forward although its unfortunate to have to
revert back the unwrit to unwrit split. Hopefully we can move completely
switch to iomap soon enough. 

On the extent status cache for zeroout approach, i'm currently fixing a
few bs < ps bugs I'm seeing in it and would clean it up and post it as
v2. My idea is to keep the first patch disabling zeroout and rest of
them implementing the es changes and renabling it. We can just backport
the first patch. Along with your poc fixes here also backported to 7.0
i believe we should be good to go.

Regards,
ojaswin

> 
> 
> The specific POC fix code is as follows. I tested it with the reproducer
> and the issue no longer reproduces.
> 
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8069521442a7..441356999594 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1761,6 +1761,7 @@ struct ext4_sb_info {
> 
>  	/* workqueue for reserved extent conversions (buffered io) */
>  	struct workqueue_struct *rsv_conversion_wq;
> +	struct workqueue_struct *iomap_conversion_wq;
> 
>  	/* timer for periodic error stats printing */
>  	struct timer_list s_err_report;
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91857b46ce24..82fcb71330dc 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3423,10 +3423,29 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
>  		if (err)
>  			/* ZEROOUT failed, just return original error */
>  			goto out_unlock;
> +	} else if (flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE) {
> +		/*
> +		 * The caller wants to split the extent before submitting
> +		 * the I/O, but the split failed.  Zeroout the whole extent
> +		 * and mark it initialized as the last resort, the upcoming
> +		 * I/O will overwrite the map range.
> +		 */
> +		if (!is_unwrit) {
> +			/* Shouldn't happen. Just exit */
> +			err = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		lblk = ee_block;
> +		len = ee_len;
> +		pblk = ext4_ext_pblock(ex);
> +		err = ext4_issue_zeroout(inode, lblk, pblk, len);
> +		if (err)
> +			/* ZEROOUT failed, just return original error */
> +			goto out_unlock;
>  	} else {
>  		/*
> -		 * We no longer perform unwritten to unwritten splits in IO paths.
> -		 * Hence this should not happen.
> +		 * This should not happen.
>  		 */
>  		WARN_ON_ONCE(true);
>  		err = -EINVAL;
> @@ -4073,6 +4092,36 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
>  	trace_ext4_ext_handle_unwritten_extents(inode, map, flags,
>  						*allocated, newblock);
> 
> +	/* get_block() before submitting IO, split the extent */
> +	if (flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE) {
> +		int depth;
> +
> +		path = ext4_split_convert_extents(handle, inode, map, path,
> +						  flags, allocated);
> +		if (IS_ERR(path))
> +			return path;
> +
> +		/*
> +		 * shouldn't get a 0 allocated when splitting an extent unless
> +		 * m_len is 0 (bug) or extent has been corrupted
> +		 */
> +		if (unlikely(*allocated == 0)) {
> +			EXT4_ERROR_INODE(inode,
> +					 "unexpected allocated == 0, m_len = %u",
> +					 map->m_len);
> +			err = -EFSCORRUPTED;
> +			goto errout;
> +		}
> +		/* Don't mark unwritten if the extent has been zeroed out. */
> +		path = ext4_find_extent(inode, map->m_lblk, path, flags);
> +		if (IS_ERR(path))
> +			return path;
> +		depth = ext_depth(inode);
> +		if (ext4_ext_is_unwritten(path[depth].p_ext))
> +			map->m_flags |= EXT4_MAP_UNWRITTEN;
> +		goto split_out;
> +	}
> +
>  	/* IO end_io complete, convert the filled extent to written */
>  	if (flags & EXT4_GET_BLOCKS_CONVERT) {
>  		path = ext4_convert_unwritten_extents_endio(handle, inode,
> @@ -4126,7 +4175,7 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
>  		err = -EFSCORRUPTED;
>  		goto errout;
>  	}
> -
> +split_out:
>  	map->m_flags |= EXT4_MAP_NEW;
>  map_out:
>  	map->m_flags |= EXT4_MAP_MAPPED;
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 52b1fb99484d..96049dc54963 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -450,14 +450,30 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
>  	loff_t pos = iocb->ki_pos;
>  	struct inode *inode = file_inode(iocb->ki_filp);
> 
> +	if (!error && size && (flags & IOMAP_DIO_UNWRITTEN)) {
> +		int retries = 0;
> 
> -	if (!error && size && (flags & IOMAP_DIO_UNWRITTEN) &&
> -			(iocb->ki_flags & IOCB_ATOMIC))
> -		error = ext4_convert_unwritten_extents_atomic(NULL, inode, pos,
> -							      size);
> -	else if (!error && size && flags & IOMAP_DIO_UNWRITTEN)
> -		error = ext4_convert_unwritten_extents(NULL, inode, pos, size,
> -						       NULL, 0);
> +retry_convert:
> +		if (iocb->ki_flags & IOCB_ATOMIC)
> +			error = ext4_convert_unwritten_extents_atomic(NULL,
> +					inode, pos, size);
> +		else
> +			error = ext4_convert_unwritten_extents(NULL, inode,
> +					pos, size, NULL, 0);
> +
> +		/*
> +		 * The conversion may have failed to allocate metadata for
> +		 * splitting the extent.  Blocks freed by other operations
> +		 * (e.g. an unlink) may still be waiting for a journal
> +		 * commit, so commit and retry the conversion.
> +		 */
> +		if (error == -ENOSPC && EXT4_SB(inode->i_sb)->s_journal &&
> +		    ext4_count_free_clusters(inode->i_sb) &&
> +		    ++retries <= 3) {
> +			if (ext4_force_commit(inode->i_sb) == 0)
> +				goto retry_convert;
> +		}
> +	}
> 
>  	/*
>  	 * If this dio covered an unwritten extent, we would have incremented
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 13449e4ebb6a..03d296f54b6d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -991,7 +991,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  			goto out;
>  		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
>  		    (flags & EXT4_GET_BLOCKS_UNWRIT_EXT) &&
> -		    !(flags & EXT4_GET_BLOCKS_CONVERT)) {
> +		    !(flags & (EXT4_GET_BLOCKS_CONVERT |
> +			       EXT4_GET_BLOCKS_SPLIT_NOMERGE))) {
>  			/* Contains EXT4_GET_BLOCKS_CREATE - mark mapped. */
>  			ret = check_block_validity(inode, map);
>  			if (!ret)
> @@ -2600,8 +2601,17 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
>  			   EXT4_EX_NOCACHE;
> 
>  	dioread_nolock = ext4_should_dioread_nolock(inode);
> -	if (dioread_nolock)
> -		get_blocks_flags |= EXT4_GET_BLOCKS_UNWRIT_EXT;
> +	if (dioread_nolock) {
> +		get_blocks_flags |= EXT4_GET_BLOCKS_SPLIT_NOMERGE |
> +				    EXT4_GET_BLOCKS_UNWRIT_EXT;
> +		/*
> +		 * The io_end is accounted in i_conv_pending_ios only after
> +		 * the first unwritten extent has been mapped, so tell the
> +		 * zeroout fallback whether our own count is already included.
> +		 */
> +		if (!(mpd->io_submit.io_end->flag & EXT4_IO_END_UNWRITTEN))
> +			get_blocks_flags |= EXT4_GET_BLOCKS_NO_CONV_ACC;
> +	}
> 
>  	err = ext4_map_blocks(handle, inode, map, get_blocks_flags);
>  	if (err < 0)
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index e99816017a18..ceeb15ae9b40 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -649,7 +649,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  	unsigned long io_mode = (unsigned long)ioend->io_private;
>  	bool is_disksize_grow = (io_mode == EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO);
>  	handle_t *handle;
> -	int credits;
> +	int credits, retries = 0;
>  	int ret, err;
> 
>  	/*
> @@ -684,6 +684,7 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  	/* Wait for disksize-pending zeroed data to be written out. */
>  	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);
> 
> +retry:
>  	/*
>  	 * We may need to convert one extent, update the i_disksize and
>  	 * dirty the inode.
> @@ -702,6 +703,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  						    is_disksize_grow);
>  		if (ret)
>  			goto out_journal;
> +
> +		is_disksize_grow = false;
>  	}
> 
>  	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
> @@ -714,6 +717,12 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  		ret = err;
>  out_err:
>  	if (ret < 0 && !ext4_emergency_state(sb)) {
> +		if (ret == -ENOSPC && EXT4_SB(sb)->s_journal &&
> +		    ext4_count_free_clusters(sb) && ++retries <= 3) {
> +			if (ext4_force_commit(sb) == 0)
> +				goto retry;
> +		}
> +
>  		ext4_msg(sb, KERN_EMERG,
>  			 "failed to convert unwritten extents to written extents or update inode size -- potential data loss! (inode %llu, error %d)",
>  			 inode->i_ino, ret);
> @@ -768,7 +777,7 @@ void ext4_iomap_end_bio(struct bio *bio)
> 
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	if (list_empty(&ei->i_rsv_conversion_list))
> -		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
> +		queue_work(EXT4_SB(ioend->io_inode->i_sb)->iomap_conversion_wq,
>  			   &ei->i_rsv_conversion_work);
>  	list_add_tail(&ioend->io_list, &ei->i_rsv_conversion_list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3c53bf27da45..9012fce8dd9a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1326,6 +1326,7 @@ static void ext4_put_super(struct super_block *sb)
>  	flush_delayed_work(&sbi->s_ea_inode_work);
>  	ext4_quotas_off(sb, EXT4_MAXQUOTAS);
> 
> +	destroy_workqueue(sbi->iomap_conversion_wq);
>  	destroy_workqueue(sbi->rsv_conversion_wq);
>  	ext4_release_orphan_info(sb);
> 
> @@ -5668,6 +5669,24 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  		goto failed_mount4;
>  	}
> 
> +	/*
> +	 * Buffered iomap conversions may have to force a journal commit and
> +	 * retry, so they cannot share the single-threaded rsv_conversion_wq
> +	 * with the buffer_head path.  That commit may wait for the writeback
> +	 * of a buffer_head io_end which is completed on rsv_conversion_wq.
> +	 * Allow some concurrency here as a retry can block on the commit.
> +	 */
> +	EXT4_SB(sb)->iomap_conversion_wq =
> +		alloc_workqueue("ext4-iomap-conversion",
> +				WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
> +	if (!EXT4_SB(sb)->iomap_conversion_wq) {
> +		printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
> +		err = -ENOMEM;
> +		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
> +		EXT4_SB(sb)->rsv_conversion_wq = NULL;
> +		goto failed_mount4;
> +	}
> +
>  	/*
>  	 * The jbd2_journal_load will have done any necessary log recovery,
>  	 * so we can safely mount the rest of the filesystem now.
> @@ -5842,6 +5861,8 @@ failed_mount8: __maybe_unused
>  	sb->s_root = NULL;
>  failed_mount4:
>  	ext4_msg(sb, KERN_ERR, "mount failed");
> +	if (EXT4_SB(sb)->iomap_conversion_wq)
> +		destroy_workqueue(EXT4_SB(sb)->iomap_conversion_wq);
>  	if (EXT4_SB(sb)->rsv_conversion_wq)
>  		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
>  failed_mount_wq:
> @@ -6543,6 +6564,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
>  		return ret;
> 
>  	trace_ext4_sync_fs(sb, wait);
> +	flush_workqueue(sbi->iomap_conversion_wq);
>  	flush_workqueue(sbi->rsv_conversion_wq);
>  	flush_delayed_work(&sbi->s_ea_inode_work);
>  	/*
> 
> 
> 
> > Nothing our agents have tried fixes it fully. I'm reporting this so you
> > are aware of the regression since v7.0. A reproducer is available to the
> > maintainers off-list.
> > 
> > [1] https://lore.kernel.org/linux-ext4/20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com/
> > [2] https://lore.kernel.org/linux-ext4/20261101102145.647496-1-guolingxing@tju.edu.cn/
> > 
> > #regzbot introduced: ea96cb5c4ae3
> > 
> > 
> 
