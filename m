Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0409D369D68;
	Tue, 19 May 2026 10:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779187334; cv=none; b=N6d8mIfd0zH2RDVmRsl3yl+C4jxtE99GWUYlwVvbZVmxa1AklbbK/gHpWYumUXswPUCsYnQITr6henD9wjxoM7kmexjpBRuxwPVcKjkMg241js3TnTMrrsMHszHRCqM7MW37DUDyAUGKZ5eXMvCVShBdI/RQ8k8Kx970MYujmg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779187334; c=relaxed/simple;
	bh=RwBHKA3fKZHSODB/o0YGhmaRKBi761SHfE2RmbgpMVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ROn717P1G38Jq4Q/ufW2s6wFY1hj4Wwb0SrhXVwMx8L8PW7+S3orUFb8uUk285rBS1qx7gM8JwUon1bVq9+uMh+/sJe1tMT2WL733NdNIRgp51z/EkYxbqPhj984cOR4+ZmqVCwNnbOz4Of+lKzkzxKj93pik91QXU8idrMd8G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ibXg+qDN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ibXg+qDN"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ILA2c83865342;
	Tue, 19 May 2026 10:41:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=CzlaVTiLMC9dYGrHbJ6R3ZG5TWrYa7
	OUx8kqbbtLgxA=; b=ibXg+qDNKzdtgyV0pV4j2dS8v5slwJNuHar0PKwY4MoHG8
	z4ni8Bt4kt0KebN1CtQtTeIrfccXv0riPpeBLF3D8nD6TmXMIqjxruQOkDBtJqVS
	E+hTrnd+sa/NXyO7ljkZ74JH0g2unGiUozshvhV1vbH45zY/az4ApsR0W6+2l6Ty
	pV4wm5gSun0lWivc9fgULg83bOS6jJl//CTZwY+1y5j7RVtrYbEFJzT5TBAyl9g/
	jvFMtBHAd/oKfUw0RQrIBAiQv01TFZ4MILHcHAg8s7S808YCmrzWRFQGecLfCfHs
	MSVRdvieyKoQTWsiZumhCgsvRiYDvwgDUfN/0IbQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h74vfnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 10:41:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64JAdDOe006163;
	Tue, 19 May 2026 10:41:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754g9x76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 10:41:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64JAfavh59310488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 10:41:37 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C859F2004B;
	Tue, 19 May 2026 10:41:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4417A20040;
	Tue, 19 May 2026 10:41:33 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 10:41:33 +0000 (GMT)
Date: Tue, 19 May 2026 16:11:30 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 07/23] ext4: do not use data=ordered mode for inodes
 using buffered iomap path
Message-ID: <agw-Wt4c4Fwevezk@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-8-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-8-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ffCdDUQF c=1 sm=1 tr=0 ts=6a0c3e64 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=i0EeH86SAAAA:8
 a=By4nrtBw8wy__9B6cK4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: eaG9bBLPc4ejCq1LypTrhsTrgzd4ZPMo
X-Proofpoint-GUID: GuGffA5FI9sAaxtVFXROqks8TJ2Wkxac
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEwNCBTYWx0ZWRfXyVvuGMaCvwsK
 l2WwNsa+9tSiOeXwxCeowT7Dd1l3j3Pdy5cEVI66bzZc1cQmsdKjvG36hDkFpEF0IYL8jmD0qgn
 00GWKaiB42DkAlxcy1frr+ia3cPAt+xRFYO8yv0wTT8utlWAcBjWgM5MDYJxIu/Li0ec3TB2bRq
 26YhLSqRPoWfifWJi3IgEuC4wpPvQW9V4zXUejjy42BhJwvdUDgFquAUQk5T7YpMR+ENvuKP7CG
 EGUEzbnRcWYUKg/w2N4mKKV4E6IPv+n0tIktni/fvCmyb42ke/2bSuHiWzXo786W/82DbKbAogf
 nwg1IOcTYRiUAh6mlRV6ClgNDvCURdWigP/xyvdXNIMIC0ISCucX6XlHHVQDQEv4t7XvrPnGANF
 STzHyxX2KitnBcuo+4wALImgn3i16ktp+FwisgrQ266W/7MVmDIlrJ7Z9BnlKw2VvtvlXdgq33s
 HrJM70n/Cf3mtXBYV4w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190104

On Mon, May 11, 2026 at 03:23:27PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The data=ordered mode introduces two fundamental conflicts with the
> iomap buffered write path, leading to potential deadlocks.
> 
> 1) Lock ordering conflict
>    In the iomap writeback path, each folio is processed sequentially:
>    the folio lock is acquired first, followed by starting a transaction
>    to create block mappings. In data=ordered mode, writeback triggered
>    by the journal commit process may attempt to acquire a folio lock
>    that is already held by iomap. Meanwhile, iomap, under that same
>    folio lock, may start a new transaction and wait for the currently
>    committing transaction to finish, resulting in a deadlock.

Right, makes sense.
> 
> 2) Partial folio submission not supported
>    When block size is smaller than folio size, a folio may contain both
>    mapped and unmapped blocks. In data=ordered mode, if the journal
>    waits for such a folio to be written back while the regular writeback
>    process has already started committing it (with the writeback flag
>    set), mapping the remaining unmapped blocks can deadlock. This is
>    because the writeback flag is cleared only after the entire folio is
>    processed and committed.

Okay so IIUC, if we do end up using iomap with ordered data, there are 2
codepaths with issues here:

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
	  
Currently, this is taken care because we try to start the txn before
taking any folio locks/starting writeback, and hence we cannot deadlock.

If the above description makes sense, do you think it'd be good to add
them to the commit message. The reason is that although these paths seem
obvious when we look at them a lot, it took me a good bit of time to
understand what deadlocks you are talking about here :p

Having the code traces like above makes it very clear.
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

I'm still going through how we are addressing no data=ordered so will
get back on this in some time.

Thanks,
Ojaswin

> 
> Online defragmentation does not yet support iomap; this can be resolved
> separately in the future.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/ext4_jbd2.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 63d17c5201b5..26999f173870 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -383,7 +383,12 @@ static inline int ext4_should_journal_data(struct inode *inode)
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
