Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369A3ADBAC
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 12:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785845347; cv=none; b=mTp2BNPjZe1N16ujv1zHcfGSzZ5YviFNnZq3P1awnYxT2Q1Wl/Ce34+CHirYzlJi0qMImnXmQrr4yrUQ3zJIk1ynq3DOnnlR5WS/fj6LvstEuBZjwYVVPBbsPhQWz8TegIAq8fdpVCynnZ6DfuIplqZ0qHL+RicC0fGaywGSZpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785845347; c=relaxed/simple;
	bh=FmdWB1iEbmmEpaesbLc6EpfGSj5JN+caCvhn8CT32f8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3GTI4cWrAUQyxEydifgIeevzYe8cXo+A8tnhqw9X6LqCgs786zTk9fo6PgYvsAhpFRP8cMZgZC61W5g6h+hjmHT4wSGQ9yECh177e49MYFdxE8luK2y2hSnhx0O/879dEdJOOHFIe6PhLUxFJkDhGthV0DBQCh8qQUlw8Ej5Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H6aLvsYh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H6aLvsYh"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6748HYOQ295950;
	Tue, 4 Aug 2026 12:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=EglvQOBMhRMkaOX+zsi1db4NxfVvQs
	s2OWG25WSTBNU=; b=H6aLvsYh9KiUnOoMnosTNG8nB4yN0UkzBykktEghZitOlP
	Wnl3ZbJ8JSjwPCXCgxUvTKKxOZ7GzY8nQ/zlevadFIyKprBPi6bLCfVKa2PgnGdD
	1I/aWgVaPqiHaDZurFzq4H0A2VALewonWEWRfBP/+p8nkScW2YDaZnRIBgI4bzBM
	fQzXaS7I+7xoj50w43NJwBc7Gdyxj8SSn4AHFdhV/xFU5CxmAGgWaKqkjC7zwgTe
	hdKGGfWPKQd5UP3+aCbZdvQs3EThbTF/mm261LBjVjQ2acRO2w/wACsj8ONfgSVn
	8uu0BpbTLYZ5Tkx0vPL2MNqu+kwHmYYzJuayDxtg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8a3wpu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 12:08:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 674BuF1O007737;
	Tue, 4 Aug 2026 12:08:58 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw1x51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 12:08:58 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 674C8uGf36372806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Aug 2026 12:08:56 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 337F320040;
	Tue,  4 Aug 2026 12:08:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D94F12004F;
	Tue,  4 Aug 2026 12:08:54 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  4 Aug 2026 12:08:54 +0000 (GMT)
Date: Tue, 4 Aug 2026 17:38:52 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, linux-ext4@vger.kernel.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH] ext4: Avoid entering writeback paths during fastcommit
 replay
Message-ID: <anHWVHUNcSkGhLJR@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260804104112.93202-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804104112.93202-2-jack@suse.cz>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=E6P9Y6dl c=1 sm=1 tr=0 ts=6a71d65b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=Z661uf9ziyZit4zbmyIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: c8k81W2tx0WpnDH2YOtDhGFo0R_FHHvq
X-Proofpoint-GUID: c8k81W2tx0WpnDH2YOtDhGFo0R_FHHvq
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA5NCBTYWx0ZWRfX5PZBhinyVlaL
 M4ibfPrnbM8vj+xLxul2a+1ZNga8MYqmMEXDt4SLXIBwsnkzdBI/yqWOfVArPI71URCWZjtJ1nk
 q1eQnKYSSBqdfMMalLPR16xiU6dHmpw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA5NCBTYWx0ZWRfX/JSQ64+17RcF
 poFW2jZ3iTXUIAVD+PZS0374/3Ve77jZVQRk8Xq4KeawecpSka3nlYqu1zvKUwyLYwI7EO1ElXk
 KWpDvwSRR5udzEQZBV429wrb4DwXmAXVlzgK1ati/WiwxC2Slf58bbh2yPNWwXgqjk5Qsv9KYnz
 wPRUbvhZx9yxSbAmBiS+zqSNaNhUp67BIvFwyI9wCk1inBvGMbBe+asOBzgXZCU+Gdo1dicpPYw
 9hw+wUbCYgIOjzhfkVo5ptxCSc2oPMuQ9tPuQq3NL9GrRslgKwCOE4RzC4FaAxjt+L+gL9CLVi6
 GrFX0VfrRJyTji8lQYrp2X6BY6ICg8xRE1f8aknmbwRtH2e0RtinXBraqrsg550kLI+HiZtsemi
 0Y7Wi2Hd3BnXkpGalMu0GLyH0Efcc7IKy621Ltypxlh3mlxk0lS970Cw1F70zIbcdq/oM/bHNqo
 pxaVprCjoWhzvs6XB8Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_02,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040094

On Tue, Aug 04, 2026 at 12:41:13PM +0200, Jan Kara wrote:
> Fastcommit replay effectively happens in nojournal mode. This results in
> ext4_mark_iloc_dirty() setting I_METADATA_WRITEBACK flag and as a result
> we end up entering filesystem writeback functions. However during
> fastcommit replay s_writepages_rwsem isn't initialized yet and hence we
> crash.
> 
> Fix the problem by avoiding setting I_METADATA_WRITEBACK during
> fastcommit replay. Journal replay flushes the whole block device after
> replay anyway so all metadata is properly persisted and replay is faster
> this way as a bonus.
> 
> Fixes: c26339e1df33 ("ext4: Fix data integrity writeout issues in nojournal mode")
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Hey Jan, yes makese sense and it is fixing the issue for me. Feel free
to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin


>  fs/ext4/inode.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Christian, please add this fixup to my sync fixing series. Thanks!
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7a1f961cd11c..12ff84ab5741 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6408,9 +6408,10 @@ int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
>  int ext4_mark_iloc_dirty(handle_t *handle,
>  			 struct inode *inode, struct ext4_iloc *iloc)
>  {
> +	struct super_block *sb = inode->i_sb;
>  	int err = 0;
>  
> -	err = ext4_emergency_state(inode->i_sb);
> +	err = ext4_emergency_state(sb);
>  	if (unlikely(err)) {
>  		put_bh(iloc->bh);
>  		return err;
> @@ -6425,9 +6426,13 @@ int ext4_mark_iloc_dirty(handle_t *handle,
>  	put_bh(iloc->bh);
>  	/*
>  	 * Mark that there's metadata writeout pending for the inode so that it
> -	 * gets properly flushed on fsync(2) and similar.
> +	 * gets properly flushed on fsync(2) and similar. We don't bother for
> +	 * fastcommit replay as that flushes the whole bdev afterwards anyway.
> +	 * It is faster this way and we avoid entering fs writeback paths which
> +	 * aren't fully initialized yet.
>  	 */
> -	if (!EXT4_SB(inode->i_sb)->s_journal) {
> +	if (!ext4_handle_valid(handle) &&
> +	    !(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY)) {
>  		/*
>  		 * Inode didn't need to go through dirtying, make sure it is
>  		 * attached to wb so that writeback can handle it.
> -- 
> 2.51.0
> 
