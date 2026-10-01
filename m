Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FB44E80CC;
	Thu,  1 Oct 2026 11:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852814; cv=none; b=AtJ3qflwtam2J4ztj++LVRr2Dc3GXst2NI27y5k3bHMUyqhJ6BpEmnuw0OhPCkMlWG0WhTQFS+Ju0YCRj1CbIzlDVdILmZ7XAFGsXiI6Nz55Ni9yrIJFsV3rjwMHfNMX3q0r6fLS5Y9DX9XxeuY2dHGNfEihwRmCsBJK6ZoByW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852814; c=relaxed/simple;
	bh=hs2CUJ+3RLhBqSeiTPh1ffFJwGiHYW9lryprVq3GVQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YmfJWUyzh7QkgxFqdk2rBVJk2kuP2EN+jG5fSNftdOD9I/bB6BCInISYYOxWU5AfHO8M0E1sP/I/MqA3wmqCXdWcM8xykpRg6HzZBVFm7Me8LJaX2iyScGCPUE1QawLqa6bMZt4yL5cgqGPCHkpbg8AWtL/cU7KMX98DsadqUeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AVmWgXHY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AVmWgXHY"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69175Rda3446121;
	Thu, 1 Oct 2026 11:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=wQEAZjUCGWTvi5sGliuTB7okeKs+uI
	l0LNZ/3gW38vU=; b=AVmWgXHYZRQMOqMPEmv9/4MdeLyTB0tGWEkMpa3HBd3BIX
	+1udAZzBEJB4ZoHYxzNbeu7OHiTKys6UccsyubWxweFDfoij7hH7246m1QfzX8mk
	3iY5Exh8puevYaBsLl/QNqT3Cy8iO9Fc3q7vL31aVV9fnsU7cLOr+MQyyoVBUvYD
	9PSM5T2N0Cl0+TcSCe9KaR7BSZPF415jh+1Vk0XHB6ZnOFz7tEjYoOVKeIXN60dB
	Wg9oVqhpyop47/cMkPPSLP3WzsGixzboQDofhWWGOrmxO7K2FiCnh4FfJLCSH/r5
	J0soWN69IZjNYHNH5ohVvgE7fmFemJ8KH5pvA4Nw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qrjqse-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 11:06:07 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6917HR1U545538;
	Thu, 1 Oct 2026 11:06:06 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0xcsdkqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 11:06:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 691B64DP30933570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Oct 2026 11:06:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AE4620043;
	Thu,  1 Oct 2026 11:06:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DCC720040;
	Thu,  1 Oct 2026 11:05:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.22.19])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Oct 2026 11:05:58 +0000 (GMT)
Date: Thu, 1 Oct 2026 16:35:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 18/31] ext4: drain writeback before removing extents
 on the iomap path
Message-ID: <ar4-lMpSvHFJtv1x@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-19-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-19-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA0NCBTYWx0ZWRfX1/ymU3XUzaYa
 bJ1vBMt46zbouCShc1Esp/h2V2NjhnODLF8dYQAcJEjjfo/hDZNuqjfAuxBBBTTu/Z3RaSMfDRM
 58zH0MSAtKoWI6kHmSK7slWJMPRCnAbxhzmMQ11V5kkuRLRqbHCcTM/DNOR8VrjZd/9gHtBNYNF
 JREqKjmri2NXNjef2Cj5xDJUiV2ADoxpRtoEbZAlSRXbajtx6OGAIHEXhQEC+mu/J9dAaO1/E9N
 WuaQqEtMGJieGZiaJ1yD9pPD76ETZRrqDY7apG14n5FsaA8dHmYioL5flzQSee7HWGm0JLgHi4Y
 sc1eg/4DaZOjHhokccjKMLstjBSPJ4wZ7Ns6GWGZmjMdyEez14heWboAI1sGVCZdQzizHqSqAT9
 Z6gMaMsazDXpS5X23HFq92/nHwNVso3/xpnjf7tKkLMS7mOwgqaCe1iLZQbMxLQwtFLR3/padrs
 aXLCsYem1ZlvN8jGA9w==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6abe3e9f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=yIeerrc4Y9cehcyY2r8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: J3W7ibs6jZAgrm9kJbcI8JRhZZDArG4R
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA0NCBTYWx0ZWRfX6+GhoAT9Wfa0
 ZbJpdg+HQ/Omgl+bCZMeRvbSgGAwvZ5ORIaCmMBsZnpl6InmJpROQSIgzHd0kfupTs4t5ex7qYG
 bJY9rDx9aBGNJmM9E66WVSe3x3MyvuY=
X-Proofpoint-GUID: Yu9zO6ybfqG9fgDJIBfCEGwWvTyQBs6s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010044

On Thu, Sep 03, 2026 at 08:35:30PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Because the iomap infrastructure does not always create an ifs to
> manage sub-folio state when folio size is larger than blocksize,
> invalidating a partial dirty folio during punch hole may fail to
> clear the dirty state of the affected range. As a result, writeback
> of that folio may observe a hole. At writeback submit time,
> ext4_map_blocks() already handles this case and will not allocate
> blocks. However, when punch hole races with writeback, the
> following scenario can cause I/O completion to encounter a hole.
> 
>   punch hole                        writeback
>   ----------                        ---------
>   ext4_punch_hole()
>     ext4_truncate_page_cache_block_range()
>       iomap_invalidate_folio() [partial folio]
>         iomap_clear_range_dirty()
>         -- no ifs, sub-block dirty bits NOT cleared
>                                     ext4_iomap_writepages()
>                                       iomap_writepages()
>                                         ext4_iomap_writeback_submit()
>                                           ext4_iomap_map_writeback_range()
>                                             ext4_map_blocks(IO_SUBMIT)
>                                               -> extent exists, not a hole
>                                           submit_io()  -> bio in flight
>     down_write(&i_data_sem)
>     ext4_es_remove_extent()
>     ext4_ext_remove_space()
>       -> extent removed, hole inserted
>     up_write(&i_data_sem)
>     [ transaction commits, freed blocks released to buddy ]
>     [ allocator reuses freed blocks for another inode ]
>                                     [bio completes]
>                                     ext4_iomap_finish_ioend()
>                                       ext4_convert_unwritten_extents()
>                                         ext4_map_blocks(IO_CONVERT_EXT)
>                                           -> returns 0 (hole found)
>                                     [bio writes to reallocated blocks ]
>                                     -> silent data corruption

Hey Zhang,

Yes makes sense and I believe in case of bs < ps since we have already 
mkclean the to-be-partially-truncted folios, we won't have any user
process dirtying them again between writeback and freeing the blocks, so
the fix should be enough.

Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> 
> If the bio completes after the freed blocks have been reallocated to
> another inode, it silently overwrites them and causes data corruption.
> Therefore, on the iomap path, drain writeback in ext4_punch_hole() after
> partial zeroing and before starting the freeing transaction, so any bio
> in flight on a partial folio completes against blocks still owned by
> this inode before extent removal.  Once extent removal begins, the ES
> hole insert and the existing IO_SUBMIT short-circuit prevent further bio
> submission.
> 
> This is a workaround. The proper fix is for the iomap infrastructure to
> always maintain an ifs when folio size is larger than blocksize, so that
> partial invalidate reliably clears sub-block dirty bits and no draining
> is needed.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b876a8127d09..e91b4efce098 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5028,7 +5028,14 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	ret = ext4_zero_partial_blocks(inode, offset, length, &partial_zeroed);
>  	if (ret)
>  		return ret;
> -	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
> +	/*
> +	 * On the iomap path, partial invalidate of a folio without an ifs
> +	 * leaves sub-block dirty bits uncleared.  Drain writeback before
> +	 * removing extents so that any bio in flight on a partial folio
> +	 * completes against blocks still owned by this inode.
> +	 */
> +	if (ext4_inode_buffered_iomap(inode) ||
> +	    (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed)) {
>  		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
>  						   end - 1);
>  		if (ret)
> -- 
> 2.52.0
> 
