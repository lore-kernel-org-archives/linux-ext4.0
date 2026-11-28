Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795857822;
	b=CYRh66a1yUvR1z9lWBAa8iSHWCB9bo/IsSfwz4hwb3FE21yo+quV8Wj9nKet73f+ZfN0
	 rgGZ0MkAbDg/cdAyjWA/HkKZhSxFafdmIDo8xWErySji74qgRlxXBILRIHavmNqcOGAYv
	 eeGAtQkpnxDzU24JnE19W1JVbndUf62UQCq2Wq4uyxBxaEM5sXEZvIPR9j4gNbmH67Y2a
	 iKIHIlnOcmsgWxiYO/nvpKeYcqYMsi4Laqy5rYH3EAV0V7DyBDjFl7BAmTIuTY3IsPVYW
	 FUJH99C4UN4TgaUnc2fUGvxVfycaxI0/JoRHdY8pA+5XV66+FW50qlN8kDIl2VV5lgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795857822;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=QfFAJSb9KHovdQTjtAZlgaFczNrJxXt9/Ds4dYIvWIs=;
	b=TqSkMo5KwDzIYrjJFU/arL/ulrSdWLD9gdqrPSOPcJyFoCV4OkfhEBj09KAgjWwvAt6j
	 SRL1n0CmsiyVnGCnPf8YiteCqUoY96ROGv8zoU+b606QiobwuYQUK1vdX7cF5Gn+kU185
	 2cDwfr5XH5De5owHzZXlt9SV3vT/8bnEoBU+odYKaxD/XqAZrbti9OFYF5gYDLtS+lsuS
	 bLSG+GQjImT/l9998Ul6puQlWIBgyPDdTcJcYsU8VlnKaG1Ann9/NrsV/AX+bz1To4jac
	 duBCQkzZbarxiYf/UQiIWhF7yXGmJDuok5nO0nWuk8XZBXb2WQrcvZPEGas5p4mi3nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=DzDPh4FC;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B99F606A31C;
	Sat, 28 Nov 2026 09:23:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B99F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=DzDPh4FC
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AS8o1Q91249147;
	Sat, 28 Nov 2026 09:22:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QfFAJSb9KHovdQTjtAZlgaFczNrJxX
	t9/Ds4dYIvWIs=; b=DzDPh4FCer/RNorPiXRhS38WFRSspY907Qc1oZ7gXnV0mN
	kywAtLaR5LgbTb5hutzOkS7VhMpNfkIe6CeMsZuYoSoJ+V4i6hC4I5KaYpoWTflq
	s55xiYvom+G2lrMpco3TSZGJd6ByBb6Yh4csTWuo0u9bbSc+ZNT/3WChLo24KfxH
	x7a2JZUn6hMFmharglGzQmReOEJZ0mxWiS8LdIjzsQSGZ6Oo8PT5GcGkf4zIwPPq
	CClDdX3rL1uN6nvyLWbJBN3FOMuinR9tyJxAqb0LbKpnKf4M/0y7O3tiaXVo4UnY
	okI3txcK+M0tmASgTsZ2jQE4UfCbD+q6uIq4XYww==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j7pp5gt7u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 28 Nov 2026 09:22:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AS4JSHw3732228;
	Sat, 28 Nov 2026 09:22:54 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j7cwnamhe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Nov 2026 09:22:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AS9Mqkh52036056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Nov 2026 09:22:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D5B020043;
	Sat, 28 Nov 2026 09:22:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E89B720040;
	Sat, 28 Nov 2026 09:22:46 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.18.156])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sat, 28 Nov 2026 09:22:46 +0000 (GMT)
Date: Sat, 28 Nov 2026 14:52:42 +0530
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
Message-ID: <awqdYlGwS7SHDiII@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <20261117-jf-ext4-enospc-reply-zhangyi-v9-b19eeb966ad0@linux.dev>
 <10712329-a587-496d-babf-620ebfd0e60e@huaweicloud.com>
 <20261118-jf-ext4-enospc-reply-zhangyi-v13-3886a3248c32@linux.dev>
 <9be1cb3e-4417-4609-bc0d-67dcfa24aa10@huaweicloud.com>
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
In-Reply-To: <9be1cb3e-4417-4609-bc0d-67dcfa24aa10@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: jBetJd4UeE40_1Te569oWyO6bACd9vrL
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI4MDAzNiBTYWx0ZWRfX9BVopblcMFZR
 XdscJlgJoDjQ8ASEXVQxFFVIKgd7J5M4H0ihHypCFLRjBtHHuqiY15j1lr260OCr0y/BrZdetvW
 MbJhNuPmj9q75kCX1HOfdVhK2SICu5Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI4MDAzNiBTYWx0ZWRfX4iLaTWZW9Yf2
 I8h4bXPLRGYvO0FDPuxjsqFTdt5xkPbKiVElkfYwE/1aezmI1Z9JVb9034Y8HgbFrhk+T0LqMqj
 EBBvrOXMWKjk6U/09UVBxqsPxarI3rHGSLYzInqcrzCj5Wh9FjMYyEiamlHdVX+l2b5z3cg00qE
 4UVyrLH2TXQ2yca5OImfkuVRb7SHuTKpaU/8GG2R5+jx8UqnfErFc7PoP9Jg1A3D6XvZ68ApzBX
 S+kJw97ZGCGf0NvRa5+g6YVrnQhSIeaX3bTNjOgT6RJKSEES3cbRK8O6aSgnO1w1RefxReTkm30
 TOtDrq+KnEd3I+b82J1/e1H7h7BEf84zC3nfLvO2MYN755FTc8QJ2+pEQmvGmu65AEqeDyEir+L
 43NhX1H+qHAgqVR8sE2I9lkz18P+tl1T43JuWFDsYLRvcQ7ANU66i6Xc33oNtzwj6KRxng+6pwt
 MCxQAiiBH3RL0QW9uxw==
X-Authority-Analysis: v=2.4 cv=Ae8kjHXG c=1 sm=1 tr=0 ts=6b0a9d6f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=ELnzUkowr9p0SK5joR0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: U8_kFoqDw1xRyVY32ew19zPhRlWt6jVY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-28_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611280036

On Tue, Nov 24, 2026 at 12:49:19PM +0800, Zhang Yi wrote:
> On 11/18/2026 10:06 PM, Jose Fernandez (Anthropic) wrote:
> > On Wed, Nov 18, 2026 Zhang Yi wrote:
> >> Could you provide a reproducer? My guess is that high concurrency causes
> >> the blocks freed by my current process to be taken by I/O issued by
> >> other processes
> > 
> > That fits our runs. I'll send you the script off-list.
> > 
> > - Jose
> 
> 
> Thank you for the reproducer. After debugging, I confirmed the cause. On
> each failed endio conversion, the retry commits the journal, but the
> blocks released by the commit are soon claimed again by the
> background fallocate loop, so after 3 retries the DIO finally returns
> ENOSPC.
> 
> Although Ojaswin's v2 does track the exact ranges when submitting I/Os,
> we cannot convert the whole extent after zeroing until all in-flight I/Os
> overlapping this extent have finished, which is too expensive to me. So I
> think we may still need the split to succeed.

Hi Yi,

True, my work makes sure zeroout won't corrupt data but the set of fixes
you suggest here make sure we won't need to fall to zeroout that often,
atleast for ENOSPC.

> 
> Note that we do reserve space for exactly this case. At mount time we
> set aside s_resv_clusters (2% of the clusters, capped at 4096 clusters),
> and EXT4_GET_BLOCKS_METADATA_NOFAIL is allowed to use it. The problem is
> that this reservation is not effective today. s_freeclusters_counter is
> incremented when blocks are freed, but for journaled frees the blocks
> only return to the buddy allocator after the freeing transaction
> commits. Most allocation paths already run inside a transaction, so we
> cannot force a commit from there, and even between retries the released
> space can be taken again, as the reproducer shows. So ordinary
> allocations can currently consume the reserved pool, and endio extent
> splits can be fooled into thinking space is available. This hurts both
> endio extent conversion and delalloc writeback.
> 
> My idea is to make this a real reservation of currently allocatable
> clusters rather than just a counter check. We can subtract
> sbi->s_mb_free_pending from free_clusters in ext4_has_free_clusters().
> Then a successful check no longer counts clusters that cannot be
> allocated yet, ordinary allocations can no longer eat into the reserved
> pool, and the endio split can fall back on the reserve without having to
> force a commit first. Delalloc reservations benefit as well, since
> writeback is less likely to run into ENOSPC.
> 
> The downside is that ENOSPC may be returned earlier, e.g. by buffered
> writes under the same heavy concurrency. I think that is acceptable
> since the retry is best effort anyway, and ext4_should_retry_alloc()
> still forces a commit when there are pending frees, so it can cover most
> scenarios. Even if it does fail, it is better to fail early than to fail
> after the data has already been written. This is also consistent with
> the behavior of allocating blocks directly when writing in old
> dioread_lock mode.
> 
> With the reproducer, this takes the DIO ENOSPC rate from ~11% to 0, and
> failed conversion attempts from ~1500-2200 per run to ~0.3 per run.
> fallocate ENOSPC did not increase noticeably (2.0% before vs 2.2% after).
> However, the probability of returning ENOSPC for pure append writes
> increases by about 10%.
> 
> Does this approach sounds OK?

Yes this makes sense, its the right way to fix the accounting issue that
is leading us to hit zeroout fallback frequently.

I've skimmed through rest of the changes and they look good as well. We
can discuss more on the actual patch.

Thanks,
ojaswin

> 
> Best Regards,
> Yi.
> 
> ----
> 
> The specific POC V2 fix code is as follows (based on Ojaswin's v1
> series, and in addition to changing the free_cluster accounting, it also
> fixes the fsync_tid issue mentioned earlier).
> 
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 778fe8788f06..d4e0bb90a402 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -625,12 +625,14 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
>  				  s64 nclusters, unsigned int flags)
>  {
>  	s64 free_clusters, dirty_clusters, rsv, resv_clusters;
> +	int pending_clusters;
>  	struct percpu_counter *fcc = &sbi->s_freeclusters_counter;
>  	struct percpu_counter *dcc = &sbi->s_dirtyclusters_counter;
> 
>  	free_clusters  = percpu_counter_read_positive(fcc);
>  	dirty_clusters = percpu_counter_read_positive(dcc);
>  	resv_clusters = atomic64_read(&sbi->s_resv_clusters);
> +	pending_clusters = atomic_read(&sbi->s_mb_free_pending);
> 
>  	/*
>  	 * r_blocks_count should always be multiple of the cluster ratio so
> @@ -639,13 +641,23 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
>  	rsv = (ext4_r_blocks_count(sbi->s_es) >> sbi->s_cluster_bits) +
>  	      resv_clusters;
> 
> +	/*
> +	 * Clusters in s_mb_free_pending are already counted in
> +	 * s_freeclusters_counter when freed, but they can't be allocated
> +	 * until the transaction that freed them commits, so don't count
> +	 * them as available.
> +	 */
> +	free_clusters -= pending_clusters;
>  	if (free_clusters - (nclusters + rsv + dirty_clusters) <
>  					EXT4_FREECLUSTERS_WATERMARK) {
> -		free_clusters  = percpu_counter_sum_positive(fcc);
> +		free_clusters  = percpu_counter_sum_positive(fcc) -
> +				 pending_clusters;
>  		dirty_clusters = percpu_counter_sum_positive(dcc);
>  	}
> -	/* Check whether we have space after accounting for current
> -	 * dirty clusters & root reserved clusters.
> +
> +	/*
> +	 * Check whether we have space after accounting for current
> +	 * dirty clusters, pending frees & root reserved clusters.
>  	 */
>  	if (free_clusters >= (rsv + nclusters + dirty_clusters))
>  		return 1;
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
> index 91857b46ce24..f9502d78f86b 100644
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
> @@ -4073,6 +4092,38 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
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
> +		else
> +			ext4_update_inode_fsync_trans(handle, inode, 1);
> +		goto split_out;
> +	}
> +
>  	/* IO end_io complete, convert the filled extent to written */
>  	if (flags & EXT4_GET_BLOCKS_CONVERT) {
>  		path = ext4_convert_unwritten_extents_endio(handle, inode,
> @@ -4126,7 +4177,7 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
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
> index e99816017a18..35826bd19b51 100644
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
> @@ -684,6 +684,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  	/* Wait for disksize-pending zeroed data to be written out. */
>  	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);
> 
> +retry:
> +	ret = 0;
>  	/*
>  	 * We may need to convert one extent, update the i_disksize and
>  	 * dirty the inode.
> @@ -702,6 +704,8 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  						    is_disksize_grow);
>  		if (ret)
>  			goto out_journal;
> +
> +		is_disksize_grow = false;
>  	}
> 
>  	if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
> @@ -714,6 +718,12 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
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
> @@ -768,7 +778,7 @@ void ext4_iomap_end_bio(struct bio *bio)
> 
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	if (list_empty(&ei->i_rsv_conversion_list))
> -		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
> +		queue_work(EXT4_SB(ioend->io_inode->i_sb)->iomap_conversion_wq,
>  			   &ei->i_rsv_conversion_work);
>  	list_add_tail(&ioend->io_list, &ei->i_rsv_conversion_list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3c53bf27da45..859b9c65fc0b 100644
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
> @@ -5668,6 +5669,23 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  		goto failed_mount4;
>  	}
> 
> +	/*
> +	 * Buffered iomap conversions may have to force a journal commit and
> +	 * retry.  That commit can wait for the writeback/endio of a
> +	 * buffer_head io_end which is completed on rsv_conversion_wq, so the
> +	 * iomap conversions must not share that single-threaded workqueue.
> +	 */
> +	EXT4_SB(sb)->iomap_conversion_wq =
> +		alloc_workqueue("ext4-iomap-conversion",
> +				WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
> +	if (!EXT4_SB(sb)->iomap_conversion_wq) {
> +		ext4_msg(sb, KERN_ERR, "failed to create workqueue");
> +		err = -ENOMEM;
> +		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
> +		EXT4_SB(sb)->rsv_conversion_wq = NULL;
> +		goto failed_mount4;
> +	}
> +
>  	/*
>  	 * The jbd2_journal_load will have done any necessary log recovery,
>  	 * so we can safely mount the rest of the filesystem now.
> @@ -5842,6 +5860,8 @@ failed_mount8: __maybe_unused
>  	sb->s_root = NULL;
>  failed_mount4:
>  	ext4_msg(sb, KERN_ERR, "mount failed");
> +	if (EXT4_SB(sb)->iomap_conversion_wq)
> +		destroy_workqueue(EXT4_SB(sb)->iomap_conversion_wq);
>  	if (EXT4_SB(sb)->rsv_conversion_wq)
>  		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
>  failed_mount_wq:
> @@ -6543,6 +6563,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
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
> 
> 
> 
