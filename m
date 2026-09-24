Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7B347FB17;
	Thu, 24 Sep 2026 13:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790256187; cv=none; b=o6z5+TxYSSitjTLRPMXxqe1innxJ/5b+mufvJvrhBlC1+ZvYVFaJQ1kdHOkX0cZwzKZSxn2fwoao5FA6wCL3sFg6sxLF5VjVFZ0XGaFj50uvSZBNpWFss3tRd60r2h2yB3y0Sxwa85cSPmqJwP92hfyhjKBRyGbe0Z/MJs6RIBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790256187; c=relaxed/simple;
	bh=QOH4xBl/CkYL2rclp5PVIoSCYiuxsQInpcawsiffP8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwZzrvzC0+Q/lPLCn1MD2sG6jfkzh6sB/2E8qXD34mDw8yxpVXcxZ+yC6l4B6XNZbo4j+Gr7EdXs3YTRPilYBfGEk6SAa4hMBtT4OE/uXFQsE+9qatEeBSV/tT2cjyiKe0+FU1qMYDO53HDj614PiGWjQ3jIBfx3IGN1pK2HV88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ep339rKL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ep339rKL"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OC6BfS2183157;
	Thu, 24 Sep 2026 13:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Zb5TauC0/1EmZZ5+gHx+JlMdrwywUA
	qna/NOKIkopo0=; b=ep339rKLtGttWLzyIjTde1Xn151NfClCRjbtMX5jUMSTwe
	9aQbdEllJ6seeudBEH/fD/6cGXrzJO2zI/MgueE5DgArWt14qqncrfr+M4CO8fof
	3Qv8noHUD3BpQTX931zeoUD9vZBtyDjVYHjkTg+fOPZVjcxTKWxLx3NLBfwiHC8l
	gAfTbGiuB4GJx7IKLzJHkR7vUd3FvWq4nufRes19psl2fuEXvCOM6OWivYA2lYIS
	2uXOYsXTeR5J85klIHR371qnBdkq1WYN3R+yBV4Q3CpdCKVNoqQkRzfeuuh9Le9M
	prWmZEVY+HXPhso7bbJ3wrLDJzojTauJEOf/0FGQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgsh9d1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 13:22:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68OCHXPm2061440;
	Thu, 24 Sep 2026 13:22:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb8jx18t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 13:22:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ODMArl43450786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 13:22:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CFE220043;
	Thu, 24 Sep 2026 13:22:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 629CA20040;
	Thu, 24 Sep 2026 13:22:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.215])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 24 Sep 2026 13:22:06 +0000 (GMT)
Date: Thu, 24 Sep 2026 18:52:03 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 05/31] ext4: recheck extent status tree before block
 allocation
Message-ID: <arUj-7QI2U12y1i-@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-6-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=V/XoQuni c=1 sm=1 tr=0 ts=6ab52405 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8 a=lrqsI6jtUP4MPYQepmEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: f7eDj3y-0gQI_LJNo4BSzLK_mYSDq_qf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA1NCBTYWx0ZWRfXzTPVi+Yhq4H5
 y3wEJboMGV4gJVZZpR7Hll/7oz2noBJeEvu4afm/lugah0qd4lK8L7TY4gkoSPMStKdVYIcM7kl
 KSIwjcfH/T3EDtgOHpx+QBDNNT3cmZ15GHHEF44hgFCKe3HRw3Viy+5lUYJbpTF7NXa1NxSexkt
 3oH4bNmLd62ZJcre+9s1CsezRjmqnxLNAH2wU6yckbAszDGL66QHzKSJP+WNjYLcxLu7t6dhw9X
 oy4yaJXHnSl3I2jPIkBweTccXSmbWurtMLa2o/t6zy4ySaKu+g14HtmYW6iHhVF4olFsKcWMQlD
 D6OpDlFY2yBJxdyiyWwJmudVmXxJTAI6cZfHa2zWW8S4GRSLA/zD0kjiJEosv7rRvHsTZCW5aAf
 62imDpyCBK2pyQFl1FXvG7Y25ndkRQ4Fk1jlr9QgWT5ayWwJql5quSPlgbVpwKuQoL19rRPp+f2
 BJqNEVY4kdkAnlupjUg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA1NCBTYWx0ZWRfXzKrw+O33+7rZ
 5p4h3U3AQpyt/ybngYJqwaSW8gikQUVLelTBToWMbeqPYNJQCh/vYZVMCR5Q9Uez8ujaY1E4TyG
 Mm12BCW7n3Kl0ZochvMhlsQhjb6Kgfc=
X-Proofpoint-GUID: z8ZTS9vpD2r7ZfSulbtVvTqzHQDd0aOJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240054

On Thu, Sep 03, 2026 at 08:35:17PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> After acquiring i_data_sem in write mode, recheck that the mapping
> found via the extent status tree or disk query has not changed. A
> racing truncate may have trimmed the extent between the earlier lookup
> and the write lock acquisition, since writeback does not hold i_rwsem
> or the folio locks covering the full extent. This could cause
> ext4_map_create_blocks() to allocate blocks beyond the truncated range,
> potentially leading to quota leaks in the upcomming iomap buffered
> writeback path since the iomap writeback infrastructure caches extents
> beyond the folio range.
> 
> Therefore, if we find a valid extent and the sequence number has
> changed, retry the entire lookup to obtain the correct trimmed mapping.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 84991fe99071..b71b1d2588ae 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -734,6 +734,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	else
>  		ext4_check_map_extents_env(inode);
>  
> +create_retry:
>  	/* Lookup extent status tree firstly */
>  	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>  		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
> @@ -784,6 +785,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	down_read(&EXT4_I(inode)->i_data_sem);
>  	retval = ext4_map_query_blocks(handle, inode, map, flags);
>  	up_read((&EXT4_I(inode)->i_data_sem));
> +	if (retval < 0)
> +		return retval;

Hey Zhang, I think there's a slight change in behavior that we return if
the query fails now. Earlier we would have still tried the create_blocks
call and, in case of transient errors like ENOMEM, might have suceeded.
I don't think it's that big of a deal though. 

Rest looks fine and I agree with your reply to Sashiko, I think we
can tweak those things if we ever encounter a livelock.

Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Also, if you don't mind can you add

Link: https://lore.kernel.org/linux-ext4/b0781809-4759-4e12-be17-71555b764f48@gmail.com/

(or the call trace) to the next version as it explains the issue pretty well.
Looking at these things later takes some time to recall everything and
such traces help a lot.

Regards,
ojaswin

>  
>  found:
>  	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
> @@ -820,6 +823,19 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	 * with create == 1 flag.
>  	 */
>  	down_write(&EXT4_I(inode)->i_data_sem);
> +
> +	/*
> +	 * Check the validity of the mapping found via the extent status
> +	 * tree or the disk query. A racing truncate may have changed the
> +	 * extent, since writeback does not hold i_rwsem or the folio locks
> +	 * covering the full extent.
> +	 */
> +	if (map->m_seq != READ_ONCE(EXT4_I(inode)->i_es_seq)) {
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		map->m_flags = 0;
> +		map->m_len = orig_mlen;
> +		goto create_retry;
> +	}
>  	retval = ext4_map_create_blocks(handle, inode, map, flags);
>  	up_write((&EXT4_I(inode)->i_data_sem));
>  
> -- 
> 2.52.0
> 
