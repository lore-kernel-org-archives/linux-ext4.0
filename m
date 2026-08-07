Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBB6326927
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 04:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786076066; cv=none; b=cEM4VtEn/IvcEuS90niPAkjX41X9nzeYuN9dgwWTMh12KraS6dWkumLsC6XOjcls1CFf9l7QTnIrykF3LWLdept/yhISB2P0jZ1fbRDyIpgtPMC0l9nq0t6uftq6dCdyVaOZ1BwomqtqxSB4jL/1D1KMN/dNsyF1MJGe8RmOuSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786076066; c=relaxed/simple;
	bh=2ZlH8LMcQR5K4M5Xyjbcqx1Nis5doqI6qntSPsb3ZSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oqRS0JB9rs0dv7IX/k03/T63ej77owYUXsjrm2VaFzYkeyI6RoDy99pPrz5jZykhTta4YB5OgkR1/X53UJXTISie4sI1IdG287XKHW9Q8E1z+/VMFxk54FLHBPdbcvD0iFo729q4OnWq4bRt82CDyO9MvGmgdgQoD7IEhViJJZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GxjzD2oa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GxjzD2oa"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770IXRf017225;
	Fri, 7 Aug 2026 04:14:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5d+1V6
	wxtY09ot/4fT2Pe3DgbX/M/EZk+CKHZADKccA=; b=GxjzD2oavtwH8RdlnPmkDl
	PgJnDTIZ4H1tLHPqPr4HRIeJFwUbtm4HyS7Gy/BDUxhoG8P3QrErrYmndkaOjqLg
	UMusq8Sma2md8iH3p0ecOu97roZN+9b5nTfYzTM+rwcTFyRbGdJSaUz9juUhfeBz
	dSRjZTlbDYE7GDjV/30BQeBDUlvVprVRICKf3PuiuOnB+/6XQNcJLIIOMa9ZETN1
	rELlKGLEVK5xgEtxwjqEv/iC3lh4rx9OT7UciZYrrsT59r5EQaLRaDOpQCsojwKc
	G0J2n2Fj4H48lccBTxHlYUNUS2kTfyu/opb7uDq3z0XNPf7zlUTu4yU11iPiOx/w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fvy00a34y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 04:14:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6774BLht015327;
	Fri, 7 Aug 2026 04:14:11 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4ke7xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 04:14:11 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6774EA2Q20578968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Aug 2026 04:14:11 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D4C6758059;
	Fri,  7 Aug 2026 04:14:10 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B01358058;
	Fri,  7 Aug 2026 04:14:09 +0000 (GMT)
Received: from [9.61.246.200] (unknown [9.61.246.200])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Aug 2026 04:14:08 +0000 (GMT)
Message-ID: <025d6299-08a2-42db-b317-b2152f14ff1d@linux.ibm.com>
Date: Fri, 7 Aug 2026 09:44:07 +0530
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Avoid entering writeback paths during fastcommit
 replay
Content-Language: en-GB
To: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <20260804104112.93202-2-jack@suse.cz>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <20260804104112.93202-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDAyNCBTYWx0ZWRfX2DHbX5Xyoc8s
 KtDieF7gzn8YUDasm2e5UqPngf/d3wTzrFgmfjLgoAXlxwvmOGmYUPyvRNI0Ia1Nafdz3uYDFYA
 DHwk+TrFW5j7koLts9zFOoadOVWwaTo=
X-Authority-Analysis: v=2.4 cv=VPTtWdPX c=1 sm=1 tr=0 ts=6a755b94 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=T2R7FQVLJHf8dZfcdzUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: UqvNVkYLCuT1cusTwNiadiFauyeFrK6h
X-Proofpoint-GUID: UqvNVkYLCuT1cusTwNiadiFauyeFrK6h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDAyNCBTYWx0ZWRfXyXduKbunRNFl
 KHyv1b5AC9QfKTXarSNeSJ/S2G/vLVA4yDxRptn5qQmGK59YKDkabrOJ1dzgFS/qPpOyKJNHM41
 I/BacZZBJ965lg9x6HMJ+473k3rANG72erHBRz5J0Qq61ERvMeOKvZtgFPRh3rah7wGf5o+1QhS
 sy+loyTOYwbSYNoDhhsQiuxmd9spwhTJn2gRnqGaILpWAIkXlExfq8MtZ+Z0nbR8WkuAXZ6vXSy
 CRE111WfR89ioiqXkyIrdyd4YPVNJvCr3lyiBJTToPGqd8KqrC7kezxUJKo50D+P7Qdut11yWvO
 mfGnfLFsCGjS11fdR8/wzo3JjgqN15jB8X8UesQh3/AWcUBpoO/YXnLzkb8QZqycFtla7rpAS81
 fhQ0nReXteWY52pHAIlZY3Lf+AlUHyHQ9s7xmXT8TiPPnFQjsqhZ34o3wYPpbfvPX5TxlKuv9Al
 IQsKBg9g37AJ/QJWjPg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070024


On 04/08/26 4:11 pm, Jan Kara wrote:
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


Tested this patch and its fixes the reported issue. Hence,

Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>


Regards,

Venkat.


>   fs/ext4/inode.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
>
> Christian, please add this fixup to my sync fixing series. Thanks!
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7a1f961cd11c..12ff84ab5741 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6408,9 +6408,10 @@ int ext4_chunk_trans_blocks(struct inode *inode, int nrblocks)
>   int ext4_mark_iloc_dirty(handle_t *handle,
>   			 struct inode *inode, struct ext4_iloc *iloc)
>   {
> +	struct super_block *sb = inode->i_sb;
>   	int err = 0;
>   
> -	err = ext4_emergency_state(inode->i_sb);
> +	err = ext4_emergency_state(sb);
>   	if (unlikely(err)) {
>   		put_bh(iloc->bh);
>   		return err;
> @@ -6425,9 +6426,13 @@ int ext4_mark_iloc_dirty(handle_t *handle,
>   	put_bh(iloc->bh);
>   	/*
>   	 * Mark that there's metadata writeout pending for the inode so that it
> -	 * gets properly flushed on fsync(2) and similar.
> +	 * gets properly flushed on fsync(2) and similar. We don't bother for
> +	 * fastcommit replay as that flushes the whole bdev afterwards anyway.
> +	 * It is faster this way and we avoid entering fs writeback paths which
> +	 * aren't fully initialized yet.
>   	 */
> -	if (!EXT4_SB(inode->i_sb)->s_journal) {
> +	if (!ext4_handle_valid(handle) &&
> +	    !(EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY)) {
>   		/*
>   		 * Inode didn't need to go through dirtying, make sure it is
>   		 * attached to wb so that writeback can handle it.
