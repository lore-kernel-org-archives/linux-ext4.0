Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFC941A92A;
	Fri, 14 Aug 2026 07:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786693313; cv=none; b=VB9mkKBu7R5w7LMi/tv/5oiKNKebaWts9+AmsdqptP51NxVqXFfqnAPy5JcR7ZuYaPwT0iO9VupIaKndTBXGKBuKDh1H1EvrHdZ7NcELOQ66jTjZDS4GP5VGx26wRnzqXLKl/eLfuKSumgRabHGjV3Etlu6QcRJ2Pms0qx87Jvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786693313; c=relaxed/simple;
	bh=BEm9CbgOGfIjGNnkBwsXGcP2HUceqHK7a7NA8iH1iXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfFu+nfPJ0FloqLtsBNDuYVdxsWzSw8ER21GNWwYWMOrtKNwKrF/d9X5Z7UvR4Um5PBgl3Yzfr/zzMaV9e1Bk240HQvDpzecTs4HnGtkDgD1UKNRFnshWdWTyi5g6Xna6ixIR6xlQfecMU2okI3FYYuPIWDuZIoVC4dXbcwE7XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MEfiK1H1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MEfiK1H1"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67E4WBdw156102;
	Fri, 14 Aug 2026 07:41:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=6+Rcz7kKVVLDRn5aZQPQImSGRHyyJ3
	MpcEf6UVAEeog=; b=MEfiK1H1q7QTTunwDi1Gm3+4H1a/EesxTBwyV19pkWlNvt
	RmjvdDHeonU7XZcLiaU/Cck5YxVpoeYc2A360O/V577pCgYqDcZaxKNaLfwivQvE
	g8kkftpngTVT89ucX0joJftN5nJLZMsf7VpIT8bwvIK0wBLGE1bHgV1+qSTyrc45
	Pttm5vje1MCCwDBrcCUUedKDuxUWSHY1iTvTqqIMEDICDT+xkEVAJXNpb5VLtIBQ
	EZQlXMw8xzCl95bVKCVbzI/vD3vQtba6CQUZ3qNuRVsJasPMKkxSOXmAK8duOVl6
	3k8p7qyg9fgC4grwKqo/rhi1zdl/MkbErYdwkLRg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvma3u2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 07:41:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67E7QO2W002764;
	Fri, 14 Aug 2026 07:41:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqejvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 07:41:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67E7f9wM46465454
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 07:41:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B521320043;
	Fri, 14 Aug 2026 07:41:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2505F20040;
	Fri, 14 Aug 2026 07:41:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.225])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 14 Aug 2026 07:41:05 +0000 (GMT)
Date: Fri, 14 Aug 2026 13:11:03 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: guzebing <guzebing1612@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ritesh.list@gmail.com, yi.zhang@huawei.com, bretznic@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: reject delalloc to nodelalloc before applying
 remount options
Message-ID: <an7Gj2vWVpbP584g@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260814034855.1573759-1-guzebing1612@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814034855.1573759-1-guzebing1612@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA1OCBTYWx0ZWRfXyBcr2IGWXajq
 +E1u/DRPGuiNG/4Nb+yx2CXdr5hjVAt8TZkUObQRofay8mf60SZS/yQYVBe0G3CD/TA0W+LA0ls
 zwXQNbP9rlTQfv1DqRVztzSGHHykkcMHsUua7FZCKt5u8jnziCgFBtq1ulrx1urZxu6Yar952M8
 2eqFxnwpqSKZjWKP2fVEldnR5BJJAKwe1Uc2jRENg8xO+EVM79AsBvqRHBzj7/rbTlz1B/4j4RQ
 BdsecT6YANI4qttVtygEsOs/saheA3UqOnALh34FQvQBR21TcRGo1WwW+0PN9/wdl5Aq478ptTV
 nIVWDWRHdZ5DBMp9T1eNP+JQQlTSNU3kbJUpKSGJSY0CRPn49YPREn3B6loRNufc+xI4MN337yM
 4lgIccloyhgbkxiwVmRh7bsxYJy2ZtiDMi0TTmLWk8fMctRQ255gcoSYSip+y9DJoc4dk92C26p
 3HjVWahkR8PBlPvtjgQ==
X-Proofpoint-ORIG-GUID: mBzFtr89K-orXqMWlC23rFFKnWJV_Ue1
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA1OCBTYWx0ZWRfX8cu5MqYbA1eL
 u36+Kf7ilaBU+jCFM4nJK2v0UOustgWP46bt9j7zPEPfyoazqgt25Q4UM8dTkKQXZDmCdliPfzw
 2PaqsMAj2cgrbMyhCxkPHfpps+zMIeY=
X-Authority-Analysis: v=2.4 cv=IfK3n2qa c=1 sm=1 tr=0 ts=6a7ec698 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=FLgiNcECAJhIYfXtno0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 9TVrCjLsWNHyEiUh_xLXYaXhwQzrXHwB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_02,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140058

On Fri, Aug 14, 2026 at 11:48:55AM +0800, guzebing wrote:
> Commit 97f5ec3b166d ("ext4: prevent delalloc to nodelalloc on
> remount") rejects switching a mounted filesystem from delalloc to
> nodelalloc.  However, it performs the check after ext4_apply_options()
> has already cleared EXT4_MOUNT_DELALLOC in the live superblock.  The
> failure path eventually restores the bit, but leaves a window where
> other CPUs can observe nodelalloc.
> 
> test_opt() reads s_mount_opt directly without a lock shared with
> remount.  If a concurrent truncate's __es_remove_extent() hits this
> window and observes nodelalloc, it sets count_reserved to false.
> Delayed extent status entries are then removed without calculating
> their cluster reservations, leaving reserved at zero.
> ext4_es_remove_extent() therefore calls ext4_da_release_space() with
> zero, leaving i_reserved_data_blocks and s_dirtyclusters_counter
> elevated.  When the inode is later evicted after unlink,
> ext4_destroy_inode() reports:
> 
>   i_reserved_data_blocks (...) not cleared!
> 
> CPU 0                             CPU 1
>                                   ksys_truncate()
>                                     ...
>                                     ext4_es_remove_extent()
> ext4_reconfigure()
>   ext4_check_opt_consistency()
>   __ext4_remount()
>     ext4_apply_options()
>       clear EXT4_MOUNT_DELALLOC
>                                       __es_remove_extent()
>                                         test_opt() sees !DELALLOC
>                                         count_reserved = false
>     reject delalloc -> nodelalloc
>     restore EXT4_MOUNT_DELALLOC
>                                         remove delayed ES
>                                     ext4_da_release_space(0)
> 

Hi guzebing,

This looks like a valid issue. I think the unrelated issues sashiko has
pointed is also valid and we can probably move back more of these checks
from __ext4_remount to ext4_check_opt_consistency, but that can be done
in separate patches.

Feel free to add:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

> Follow the pre-apply validation approach used by
> ext4_check_quota_consistency() and reject the transition in
> ext4_check_opt_consistency(), before ext4_apply_options() changes live
> state.  Use mask_s_mount_opt to determine whether delalloc/nodelalloc
> was specified and ctx_test_mount_opt() to check the final parsed value.
> 
> Fixes: 97f5ec3b166d ("ext4: prevent delalloc to nodelalloc on remount")
> Cc: stable@vger.kernel.org
> Signed-off-by: guzebing <guzebing1612@gmail.com>
> ---
> 
> This issue was first observed in a production environment.  It can now
> be reproduced with a shell script.
> 
>   1. Create a 768 MiB ext4 filesystem and mount it with delalloc.
>   2. Start 16 workers.  Each worker repeatedly runs:
> 
>        xfs_io -f -c 'pwrite -q 0 32m' file-N
>        truncate -s 262144 file-N
> 
>   3. In parallel, repeatedly run "mount -o remount,nodelalloc".  Every
>      remount is expected to fail.
>   4. Continuously sample the live mount options with findmnt and record
>      any transient nodelalloc state.
>   5. After 300 seconds, stop the workers and unmount the filesystem,
>      then inspect dmesg for "i_reserved_data_blocks (...) not cleared!".
> 
> On an affected kernel, 7 transient nodelalloc samples and 9 reservation
> warnings were observed during 101 rejected remounts.
> 
> With this fix, no transient nodelalloc state or reservation warning was
> observed.

Can you please add an xfstests for this. The test can stress this path and
then use the _check_dmesg_for helper to detect if there were any
i_reserved_data_blocks related warnings.

Regards,
ojaswin

> 
>  fs/ext4/super.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 245f67d10ded3..9e1ea94664775 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2816,6 +2816,14 @@ static int ext4_check_opt_consistency(struct fs_context *fc,
>  	}
>  
>  	if (is_remount) {
> +		if (test_opt(sb, DELALLOC) &&
> +		    (ctx->mask_s_mount_opt & EXT4_MOUNT_DELALLOC) &&
> +		    !ctx_test_mount_opt(ctx, EXT4_MOUNT_DELALLOC)) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "can't disable delalloc during remount");
> +			return -EINVAL;
> +		}
> +
>  		if (!sbi->s_journal &&
>  		    ctx_test_mount_opt(ctx, EXT4_MOUNT_DATA_ERR_ABORT)) {
>  			ext4_msg(NULL, KERN_WARNING,
> @@ -6660,13 +6668,6 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
>  		goto restore_opts;
>  	}
>  
> -	if ((old_opts.s_mount_opt & EXT4_MOUNT_DELALLOC) &&
> -	    !test_opt(sb, DELALLOC)) {
> -		ext4_msg(sb, KERN_ERR, "can't disable delalloc during remount");
> -		err = -EINVAL;
> -		goto restore_opts;
> -	}
> -
>  	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
>  		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
>  
