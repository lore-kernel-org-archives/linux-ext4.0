Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9185648D890;
	Mon, 28 Sep 2026 10:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790591858; cv=none; b=nFVNwGzfIFHvkdYjArBUQj6vAFSkh0AF/9DmW13cT0MlVApP79lsqwJ7sg4NWRwGHcISO201A3ilz02SB1dqBBNnizYz4qmWel4W5IE9rfdZP2C0j0uE74KlqqzWkTnWymYA+Jk65UMyKK6oCN1PjvXqDhXe6igP8XkVtiYyLCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790591858; c=relaxed/simple;
	bh=c5tuQoEdlF5IPBJbLqozrMCTXsNhWkHgmi2tjpQToBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKqPT9E6ma5dP8A2Y26KCoX3eYNI7GEI20waY8UJbEcKDi1RjGbmuokHBZ/rogo7VwGxQXRKndYfARO86qkgtTEnxtEHlToAvVPkcN86Cc0Jo43BzjbFoSi4vCXbrxXutDhnhoD856kGhoNcEtiQA1hBf9LYYPS/DJTihuk5SVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kADR6fWP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kADR6fWP"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9Zl5Q577538;
	Mon, 28 Sep 2026 10:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=JuH9RPjud1DwKJCzuLhj6G807cgzLP
	jFKV6YWMJuM7c=; b=kADR6fWPS8Klpjt60istW31E0hCE5cWCTh6gBOOm3ok9tO
	shxuj/o5nd7TlraCxBwtbEJhf6KatpOq/F2vrStg+vjI7KJOvqIm6CjCSpca6MBO
	c7rpuKpJI13MPmqtszZ5dhlUPIxg12fRmoH8LI1ViAWzu5mDE4GljA3P99vdtyqR
	jENe0/DEp8TkpVw5sEYe6T5MqlPNhsARILAflZyzIgADcTrNMGnyUyamPbh1ZHKQ
	Ev20d/WnGMbNbR84RUGYc2OfwkePEv3t4CHUcCAr6CAyWTGBX/69CuEFINIYXL2g
	F7UOz51mJ/hanvlLFkQkROFpOiOKassxegOEKN6Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx3fk0ptc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 10:36:58 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68S9Hwe62810204;
	Mon, 28 Sep 2026 10:36:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg4n3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 10:36:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SAau6g50069784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 10:36:56 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1313B2004E;
	Mon, 28 Sep 2026 10:36:56 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8363920040;
	Mon, 28 Sep 2026 10:36:50 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 28 Sep 2026 10:36:50 +0000 (GMT)
Date: Mon, 28 Sep 2026 16:06:47 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
        wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v6 09/31] ext4: skip block allocation for holes in the
 data submission path
Message-ID: <arpDP43MIAGjaWYx@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-10-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903123543.2302999-10-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: KnGRxV1NpjEfVpeq6xmwODQRk0ftQQiy
X-Proofpoint-GUID: uMp-NBB3qG_zHv09oXqbuF6gU4SjwgIZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0MiBTYWx0ZWRfX8VuDzYoG4jlP
 OAfbbl9uFXK/r+PpUvCGRbYAPpryJ5mO82Chm+e5CZcf9U+IE6VGBbh8Tk7UTg+C1rflTNXVe8a
 sRhNA42HunzXlAOq3XzcFp9Nmn8R3aU=
X-Authority-Analysis: v=2.4 cv=Vv62kO2n c=1 sm=1 tr=0 ts=6aba434b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=uegeSZEF0Te5fBA9WTAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0MiBTYWx0ZWRfX3qmpos6/VY7e
 hpWTp90Z3r5sTxWzhfavwXy6IjmBOCGweIJV5ytbH1bXp13NDXJd1R6L9bdCLmSxgUs04+NT1gT
 TJvTDvq/MEaFcAGcTD2wYwruQOsMOvdW0gdRK8IFXwcE3sYbX8WErbGsoNq8wous69v+vChdgAS
 Vdj3A4R1zAnxv5woy2nnFKxHruLIwB1KSD9N4ap552KkeoZTdyitSsuP1+xcHFsDEeyR0lJNaUP
 URMHDR9gHgBz1xzrb6vnUwGhGehAKe5JdugLgYL+E5RK8hoi5jGymOZktL2SJFpB88/0bC6Fghv
 krpafvx0NYL1o1g4GsWtPyhns/1w0sGO/PC+sPGSwQuevXK21zNKPUkwcqIWzLztsPtooMXXg4/
 n504qpO30jXpwLHOeyVnznqCvxGxEsDXIMMx9Yr5Fzkogllfv+VW2llPw95DNT+iknPJc6VY/Di
 f/NY4y7eOrGlaAIGlbA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280042

On Thu, Sep 03, 2026 at 08:35:21PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When ext4_map_blocks() is called from the data submission path and I/O
> end extent conversion path (EXT4_GET_BLOCKS_IO_SUBMIT), it should not
> allocate blocks if the lookup returns a hole.
> 
> The writeback path can legitimately encounter dirty ranges that map to
> holes. For example, when a folio straddles i_size and the tail beyond
> i_size is dirtied via a mmap write. Allocating blocks for such ranges is
> wrong because there is no data to write back, the dirty bits should
> simply be discarded without submitting I/O. This prepares for the
> buffered iomap writeback conversion, mirrors the existing buffer_head
> writeback path, where mpage_add_bh_to_extent() skip unmapped buffers and
> ext4_bio_write_folio() clears their dirty bits.

Looks good, checking the iomap vs bh head logic. If we consider
a 1k bs FS with 4k page size, with hte following ops:

  ftruncate(fd, 0);
  pwrite(fd, buf, 1024, 0);
  map = mmap(NULL, 1024, PROT_WRITE, MAP_SHARED, fd, 0);
  map[0] = 'a';  ---->  mkwrite allocates 1 block and dirties the whole 
                        page
  ftruncate(fd, 10000);

Here both non-iomap path (ext4) and iomap path (xfs) will allocate a
single block but both will mark the whole page range dirty in bh/ifs.

In both iomap and ext4, while writeback, we skip bhs which are holes,
and we clear dirty on them as well.. The only difference is that in
iomap xfs_map_blocks() shall detect a hole and inform about the hole but
in ext4, we filter holes out before the map block call.

So with this change we will be closer to iomap's behavior. Looks good
althought it's unfortunate that IO_SUBMIT has yet another implicit
behavior added to it's scope :)

Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

> 
> In the ioend extent conversion path, holes are also not expected because
> we should wait for folio writeback before punching hole. If one is
> encountered, it likely indicates a failure in the concurrency
> protection, so ext4_map_blocks() returns zero, and we keep warning and
> bail out with -EINVAL to surface the failure rather than continuing
> conversion on torn data. Atomic writes in
> ext4_convert_unwritten_extents_atomic() already bail out similarly.

Ahh that's right we do bail out but we don't seem to be returning an
error in the atomic write path. I think ideally that would be the right
thing to do. I'll fix it, thanks!

Regards,
ojaswin

> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7a5c74af8ff3..2881596bff8b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -825,6 +825,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  			map->m_flags |= EXT4_MAP_MAPPED;
>  			goto out_handle;
>  		}
> +	} else if (retval == 0) {
> +		/*
> +		 * Do not allocate blocks for holes in the context of
> +		 * data submission path.
> +		 */
> +		if (!map->m_flags && (flags & EXT4_GET_BLOCKS_IO_SUBMIT))
> +			goto out_handle;
>  	}
>  
>  	if (!handle) {
> -- 
> 2.52.0
> 
