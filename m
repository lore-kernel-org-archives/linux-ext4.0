Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED93839A803
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790250348; cv=none; b=XvAaRkl6rJ7mDEsDeXCL2VjAbneOBFrPfC8k1VOlkYw0xS72ntyQHFYK9Su88wnbj5dycM+RQUAz/ZOQa23fZTaoXPrelPw0Hg2WbxSEnXLmbMqYEkdJJ1vwycdZtZz7xi9dqXcRpy9FgDONAZi17ANzMWBq/w3TaihgpaxdOEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790250348; c=relaxed/simple;
	bh=6ywiEkuiIFRPaT+NtRv7ksLsMOq0cQrVyc/s6p8QVtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wgoj4LbJDVobiHJ2eHqUp4idBdEY6Wjrmpy+ClJqqf8MX2H+J8LZdqdLUerhVfFiwCMnmRvbu/nqhASbuDib1VGQozfazCSlkTL67fSqBMHzp2JDrx2G+IoXOK7x0zmvI/NAMiaC0aGsfadwNEDImAUhLcmQikvX1d5WpFPk6UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B4PEBvKK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B4PEBvKK"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5bRon1372003;
	Thu, 24 Sep 2026 11:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=AzKgE0N8n3xj5akakS/mWeSff00obU
	VgcYg+vLyEANM=; b=B4PEBvKKKXUk+7r0pOHvMKUffAGI87NryqH6UrSUUYBiif
	7F6DiIpVCjdZZJ08WP3NcJmiEegRj0uYxlc7GXaLBIFQs4tsI7DfcmHJnDQfx0jK
	OafviPKobsUFdRVR5BSTvtxSI2400EszYUanSuFnnhRJ834b7OgHGuhMPHO2jF3z
	KGPzqiiYW7Z3BPH8DLCsuCdQPrmTICf5OTtkKIkvkYBwVNppglUjebQY4Dr4Cu/Q
	LDqkZi7CEp32KNqwfU5frXNkkybjxPUiuY132PQ6XBOVnfhzlEL2EjzCXBI+XEni
	E1X6FyMCbMZ5zVHSBA5iUOAxPEvPeu/2ZuiPFuFw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskdvg0de-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:40:30 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68OAIvjN1554295;
	Thu, 24 Sep 2026 11:40:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb6qngea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 11:40:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68OBeSIV41353714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 11:40:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5122620040;
	Thu, 24 Sep 2026 11:40:28 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17A5320043;
	Thu, 24 Sep 2026 11:40:27 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.215])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 24 Sep 2026 11:40:26 +0000 (GMT)
Date: Thu, 24 Sep 2026 17:10:24 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: sashiko-reviews@lists.linux.dev, tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v6 03/31] ext4: skip ordered I/O wait when zeroing beyond
 i_disksize block
Message-ID: <arUMKKMgFG7TyelW@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-4-yi.zhang@huaweicloud.com>
 <20260903131452.4F8131F00ACA@smtp.kernel.org>
 <0ba6970a-6203-45db-8837-17bb54b2fb8b@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ba6970a-6203-45db-8837-17bb54b2fb8b@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YqtIUqWJNQBNIDR7fEoj1xX32r2m670R
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA0OCBTYWx0ZWRfXxB+7U7rbK1F2
 Jz1Y2hS5u5s+6kN7Uc/6L5GS+aAWLL6C32g0ZICftWTay5KUTu9oD6AHOq/Qqw0dqYbGX2erbvI
 fKSBAXmZRMQ5qlTTGSIEaOivajsU58M=
X-Authority-Analysis: v=2.4 cv=FLiOVOos c=1 sm=1 tr=0 ts=6ab50c2e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=i0EeH86SAAAA:8 a=Amy6MhtOBdPM7R2iCj4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: YqtIUqWJNQBNIDR7fEoj1xX32r2m670R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA0OCBTYWx0ZWRfX0qEZ6FmKYxOu
 ZeYwUbN73LdfXfkM8k3uNiA8dHdPvj0rVlVx4nm+aqGaU7bpvd100J9dDF+3aq1opn67iKQxWcE
 9v5B6aOdwSHdhuUJUTaFACq7XvQxUzhGU4zHMTBr0cam/SpHlwSLdDDvSon/OborwtAy0J8zuTJ
 3afV5Iex8ZkFsxRJzj4mnLTSZPrNlLmyPczliVsqV4B+9d1kZoj5wnIQpCvu9C0eqzx2O9U6gXh
 WJphKjDISChz2FjOYtIiLcR6+YCaIr6CrjuFHgCV/046KKbQ71w5oyrbD/MmkTn9We9bBf2BtrE
 rmpHM0nf0WSNivc26HI7POJFo1PtB7m9JRHHph4OD/XHfB9clQflcbEj5b6/l4ckOHGQzJMkORB
 5pRygN1iQTQG0A9KqHa3zubgZf/lJnAPDeeUJvnR8bND6Lo6rDoUBcmwBo5hocfpwvdQxXSCHxW
 OvKWDrbCF+NImRC1vXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 phishscore=0 spamscore=0 clxscore=1011
 suspectscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240048

On Tue, Sep 08, 2026 at 07:31:49PM +0800, Zhang Yi wrote:
> On 9/3/2026 9:14 PM, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> > - [High] Skipping ordered I/O wait based on an unstabilized `i_disksize` allows stale data exposure due to a race with concurrent writeback and mmap.
> > --
> > 
> > commit 9f1f97ff9aa74fccfe7305cebcde6a641f847ab5
> > Author: Zhang Yi <yi.zhang@huawei.com>
> > 
> > ext4: skip ordered I/O wait when zeroing beyond i_disksize block
> > 
> > ext4_block_zero_eof() zeros the tail of a partial block beyond EOF.
> > After zeroing, it waits for ordered I/O completion to prevent stale
> > data exposure from concurrent post-EOF mmap writes during folio
> > writeback.
> > 
> > However, if the zeroed range lies entirely beyond the block containing
> > i_disksize, no stale data can be exposed because the zeroed region is
> > beyond existing on-disk data. The zeroed pages will be written out
> > before i_disksize is later extended past i_size, so the ordered I/O
> > wait is unnecessary. Add a condition to skip it.
> > 
> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> index d0ccafa554f8d..339ebd553959b 100644
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> >> @@ -4241,9 +4241,22 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
> > 
> > [ ... ]
> > 
> >> +	 * Note that it's safe to read i_disksize without holding i_data_sem
> >> +	 * here. Since we already hold i_rwsem, the only possible race is with
> >> +	 * concurrent writeback that updates i_disksize. And if such a race
> >> +	 * occurs, it means the previous unaligned EOF block has already been
> >> +	 * zeroed (if needed) and persisted to disk.
> >>  	 */
> >>  	if (ext4_should_order_data(inode) &&
> >> -	    did_zero && zero_written && !IS_DAX(inode)) {
> >> +	    did_zero && zero_written && !IS_DAX(inode) &&
> >> +	    from < round_up(READ_ONCE(EXT4_I(inode)->i_disksize), blocksize)) {
> > 
> > [Severity: High]
> > Does this condition rely on an unstabilized i_disksize to skip the ordered
> > I/O wait, creating a window where in-flight writeback IO can leak stale data
> > upon a crash?
> > 
> > If a file has a delayed allocated block at the end, its on-disk size
> > (i_disksize) could be lagging (e.g., 0). If the user mmaps the file and
> > writes data past EOF into the page cache, delayed allocation writeback can
> > begin, allocating the block and formatting a BIO with the user's stale
> > post-EOF data.
> > 
> > Concurrently, if a truncate operation extends the file (truncate up), it
> > calls ext4_block_zero_eof(), which zeroes the page cache tail and marks it
> > dirty. However, because READ_ONCE(EXT4_I(inode)->i_disksize) is 0, the
> > check evaluates to false.
> > 
> > This incorrectly skips ext4_jbd2_inode_add_write(), failing to add the
> > newly zeroed data to the ordered data list. The truncate operation then
> > sets i_disksize to the new size and commits the transaction, waiting only
> > for the first BIO (containing the stale data), not the zeroes.
> > 
> > If a crash occurs, upon recovery, the on-disk block would contain the stale
> > data because the transaction committed the new i_disksize without waiting
> > for the zeroed page cache to be written.
> > 
> > Note that this issue does not appear to be resolved by follow-up patches in
> > the series. While commit "ext4: set DISKSIZE_GROW_PENDING after zeroing
> > unaligned EOF block" introduces ext4_iomap_mark_disksize_pending() which
> > safely waits for writeback, it is placed inside the exact same flawed
> > condition branch, meaning the wait is still bypassed.
> 
> I think the concurrency scenario that Sashiko mentioned does exist, so it
> looks like we'll have to abandon this optimization.

Hey Zhang,

Yeah, sadly seems like sashiko is right. We do need to zeroout the isize
block as well.

Regards,
ojaswin

> 
> Thanks,
> Yi.
> 
> > 
> >>  		handle_t *handle;
> >>  
> >>  		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> > 
> 
