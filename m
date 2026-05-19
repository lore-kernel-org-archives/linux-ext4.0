Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7758477E31;
	Tue, 19 May 2026 10:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779185168; cv=none; b=r2W58pHGDooDF5u8NQ1t5DTGosmz7Cl5Pzi3NtWhNayX5Wgtx1eRuB8QkUgbU7syzrKU5JL4sYOjmMbZ3qn+i0+l3pgfJDeoHvGSKJ5aJO6N0y6yZ05NdOxYkfXHa3YMxQL2qpxUWKzigC93l2dzG2OtQR/eM3umkS2nyzNdjdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779185168; c=relaxed/simple;
	bh=qCkg6WJyml0RE+NEaLUD+DpAC48i08S3xDEcvBLhAes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U61vCTQmsC0usOsBm1M1LljWyZhE8ld/xJxFkVbYyi7xN9bvEXRm3z+q/znfa3AC0CnAGAwOmkMYH+PaywkwWiqhQVaY87+aumMTQprcBTBCH4XYT2a3PlxfVqWmJP81upDP9MzFtoiWgatnoKVuBwJN0QSXuvRncXIm8qzqCAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YnocCoKp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YnocCoKp"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64II54o41249248;
	Tue, 19 May 2026 10:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=LrRAT7eaCTzaXiDcJOZPjs0hoRwYrY
	EnNRNFkLmBDZo=; b=YnocCoKpAwtrpwy1yMh4I9VDZIIcLlZZ+TQZibJYjRqUu/
	2LAdeCO4O8/XBDXl/9RLnuVyYfsQEBqFz/Igh0SWOUdwFWqpGvLs3iy2knMtomiX
	GAENiOkUkDzaFp7d8fOUEC0cxyHYphTGx8pZ2qLdDNF/E43vTyrsl8JHufdOdgON
	WqeP2sod60up00MKd+WeBHOTdNjJ8t+YhqF/QJlNsINUfeRCt+NWmaNnKl577OcN
	Np+A8eywxHU8f2NYD8kHuMoSb02KOemd7Qujsax5yn47yosN2WttiUj8AiujV5IU
	8adN/PA84qj8qpqO/iAVsulXG4gfyyzxWPY8Qs+w==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88bn7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 10:00:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J9sCb4023459;
	Tue, 19 May 2026 10:00:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754g9sm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 10:00:27 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64JA0PJL62062952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 10:00:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 725D220043;
	Tue, 19 May 2026 10:00:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DB8E20040;
	Tue, 19 May 2026 10:00:22 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 10:00:22 +0000 (GMT)
Date: Tue, 19 May 2026 15:30:19 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 05/23] ext4: implement buffered read path using iomap
Message-ID: <agw0s_gw5GsWHyBS@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-6-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 5-4CiHuerqSGQ1aPtyol8tLKpzWZLkI_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDA5NCBTYWx0ZWRfX20m5ZOSJEw1E
 GhDzPjSNvJmyCk2CHkSbomBXxyEljW9loFJWoq7UlVwN4BS4GM7jFI5UHvOMEjfnFtEWaPlXwMS
 rAfaCKGDGm01ve3SoSpYh9SQIGvThdhsEm6KaiPJ28X4zRCb1rjT4ybFn37T86nz4jEt5hJA0RW
 UEHPWPdGtZKhcRDULZE3N/USQlX1yCh06D0RfPrsZ/dH7pP8n1Q0TybLgjHSrfU7S5lqnO7gQ4Y
 79MPBoSh4zHXWNOzMlrJ5rPa6oAsSQ6WWlP+RhuV/d8RSBfBbHwClz3vQa8KIdAi3x/MeJC2q9y
 aULBeGbB7iHG7/zbOLQ6FUbka6rk4V+0gHGzdwxD61pExaDkCYrbcjKlLDRoRFxm1i6HKWJSjC3
 r52nEbda62NvWjpMRqo9o4MViBsIAO2ibTDk7WmvzVRQcGeJ2Fef65yhi+6/a+Ru8C1Cbm20PpO
 AHRSFoBmW1r2b0hGQ4A==
X-Proofpoint-GUID: zL8HeulcwwQjka698jOWd-eRsNwAwOfv
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a0c34bc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=JEw_asZQ9MhHPAIv3icA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605190094

On Mon, May 11, 2026 at 03:23:25PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Implement the iomap read path for ext4 by introducing a new
> ext4_iomap_buffered_read_ops instance. This provides the read_folio()
> and readahead() callbacks for ext4_iomap_aops. The implementation
> introduces:
> 
>  - ext4_iomap_map_blocks(): Helper function to query extent mappings for
>    a given read range using ext4_map_blocks() and convert the mapping
>    information to iomap type
>  - ext4_iomap_buffered_read_begin(): The iomap_begin callback that maps
>    blocks, validates filesystem state, and populates the iomap. It
>    returns -ERANGE for inline data which is not yet supported.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Looks good, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
Ojaswin

> ---
>  fs/ext4/inode.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 178ac2be37b7..6c4d9137b279 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3908,14 +3908,57 @@ const struct iomap_ops ext4_iomap_report_ops = {
>  	.iomap_begin = ext4_iomap_begin_report,
>  };
>  
> +static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
> +		loff_t length, struct ext4_map_blocks *map)
> +{
> +	u8 blkbits = inode->i_blkbits;
> +
> +	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
> +		return -EINVAL;
> +
> +	/* Calculate the first and last logical blocks respectively. */
> +	map->m_lblk = offset >> blkbits;
> +	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
> +			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
> +
> +	return ext4_map_blocks(NULL, inode, map, 0);
> +}
> +
> +static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
> +		loff_t length, unsigned int flags, struct iomap *iomap,
> +		struct iomap *srcmap)
> +{
> +	struct ext4_map_blocks map;
> +	int ret;
> +
> +	if (unlikely(ext4_forced_shutdown(inode->i_sb)))
> +		return -EIO;
> +
> +	/* Inline data support is not yet available. */
> +	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> +		return -ERANGE;
> +
> +	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
> +	if (ret < 0)
> +		return ret;
> +
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> +	return 0;
> +}
> +
> +const struct iomap_ops ext4_iomap_buffered_read_ops = {
> +	.iomap_begin = ext4_iomap_buffered_read_begin,
> +};
> +
>  static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
>  {
> +	iomap_bio_read_folio(folio, &ext4_iomap_buffered_read_ops);
>  	return 0;
>  }
>  
>  static void ext4_iomap_readahead(struct readahead_control *rac)
>  {
> -
> +	iomap_bio_readahead(rac, &ext4_iomap_buffered_read_ops);
>  }
>  
>  static int ext4_iomap_writepages(struct address_space *mapping,
> -- 
> 2.52.0
> 
