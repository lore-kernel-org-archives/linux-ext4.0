Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC056379C34
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2026 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787242367; cv=none; b=LbyTZZ+GNPnDTpJ9tPUmwNQeRrWFambTapY5S88c0jFYGJv+mKWNbuCTk2uQ2C6lbUfrS3Xck7F66qucqOjCouJclp1UqilMRn9lxgqoxJg67hZ3gvgLMdPrL/pS1wnRWmPn5ub3Fl5VInM8EzzXofCt1I4T97zIVSwVh3qnzmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787242367; c=relaxed/simple;
	bh=vIzGJk+07GZdI25qHiEydly1c6EJDo3F9rRjxKmTW5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cFysfCCr5L1Un9yxuxczMwVjVGOrkao5BoOvWxXOhqG90Z+04mOJOzPSKImiVLkvHmMqrrdgu6EiWY8fm93yZk3GJGSgQR6Vid75VFtxuHK8Sl4tAHKUAdaJ5HDXpjmpCtL4f9RvJEhBeBpdzTvVu5h/66THhYFcbW9QlfhK4EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PHsm6FEV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PHsm6FEV"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67KEVVRZ2691176;
	Thu, 20 Aug 2026 16:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=67kn4e
	N1KQ+g/uymFUN5Vg05PQWujI0jt8JCduPpGLQ=; b=PHsm6FEVntjY72/tZ/eO5l
	1xiOHJtja8F4pNKOuNKTSbBWNknGO1srjnGPfLgYktui0yLX0YV86Ljka8fvpx0P
	xavqxgomE9Y8hBJakmiti6+06vCqQelMs9YTPBTKX2fDJYos3xpAJT+fjmkyZITS
	J8/mCM9V/SdeCqJym3+zXC81x6oFERo5kc37EMuPaaUBZQcB8/RK0cG1ildvnjQv
	nlIcJg2OSGdYZAn8wDeJy4Jcx1455TtCaMReN8nzTTHSGZuRyCFZL/mSsOpQJ+4R
	kZ94qdrUpdU5mqLvwXb9Olf+tZqwBGEcJxv9Mt0CpN8RcjtblfJwVgaJrwRrSMOQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu1kfef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 16:12:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67KGBhpI012795;
	Thu, 20 Aug 2026 16:12:36 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g32twfjus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Aug 2026 16:12:36 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67KGCaAi6488624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Aug 2026 16:12:36 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AA5C58059;
	Thu, 20 Aug 2026 16:12:36 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94EF058057;
	Thu, 20 Aug 2026 16:12:34 +0000 (GMT)
Received: from [9.61.245.245] (unknown [9.61.245.245])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Aug 2026 16:12:34 +0000 (GMT)
Message-ID: <6dc4a129-7097-4711-a453-6d172ef5adca@linux.ibm.com>
Date: Thu, 20 Aug 2026 21:42:33 +0530
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] ext4: Avoid entering writeback paths during
 fastcommit replay
Content-Language: en-GB
To: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <20260820112532.757055-2-jack@suse.cz>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <20260820112532.757055-2-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=LsCiDHdc c=1 sm=1 tr=0 ts=6a872776 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=T2R7FQVLJHf8dZfcdzUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: D6c_qbvZ71MBF6RbtwWGDDIKvgquQv77
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDEyMSBTYWx0ZWRfXwpzP+jC3UrLc
 SEA7N/UWsWsk4lSxQH1l2OuDR5fqCoCQgKvEWgbSURJdCX1A+qqymGe5uGT6MdKeYbBtp8ers0a
 cM31fKFU2mcZduCgXiNxO2H0+ywOcts=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDEyMSBTYWx0ZWRfX8gG4+y3kTn8w
 0OWc3SMQ1hEvZZFYqOtmj4fVx85WmwaT7nRqwPiX3f6KSFtJGyohOoYqsTqQ2rJlNgxw9+U+msy
 tKuJcJ99EQ/1xnUjoPE79h1mPkHNSYRNsmFEib5sTRhxs9kpIgZa+Ndr5aBb8yBAFrq6gH4KdEY
 WgfMRT6T3BAGr89tmM4hT/XAUpQic84HOZl9JbPQ+GcxdiRYRt1el5oabaucIt41/WR16dnZD6D
 BQATABnBz7PQnguhCqbT2/oYAqGKEf33P45FLnLZNffHM674ptNn2fhoIhQNdbHoxoRaHcTDF1r
 AOEugJ50j6TuZ5G3eaTHi8XFgmGrdkyJsaUiIO6fWOaCrCwzQIavY6dNgxbz5rEJWKJEKy7u5cU
 is7dzOr1+LY01M9+tkKv/9Z2AcEez3DFzx+uvatfuNMpm2RX7y37OyyFNQ4QCtnOFZSWm7YQM10
 TjENECEXrcE1EsOX95g==
X-Proofpoint-ORIG-GUID: D6c_qbvZ71MBF6RbtwWGDDIKvgquQv77
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200121


On 20/08/26 4:55 pm, Jan Kara wrote:

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

Please add below tag, while applying this patch.


Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

Regards,

Venkat.

>   fs/ext4/inode.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
>
> Hi Ted,
>
> this has fallen through the cracks in VFS tree, now it applies cleanly to
> Linus' tree so can you perhaps pick it up and push to Linus during the second
> half of the merge window? Thanks!
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
