Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53193E3D83;
	Wed, 27 May 2026 13:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887696; cv=none; b=JHboIKgMZb2OkXQt9nt+5KJw99C3Q0ce6cUdpSBu63H383McmWwMAziqeVvC6RadR4QZqMerwLpQgxaTfI9sjTveMZQkKELYiCUYQrnSM8uGDfhJV65TWyYShNN8XIRrMi2s1MTZcvDgBv66VFlREC3o+mAmZQo8vv5vp9fadDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887696; c=relaxed/simple;
	bh=7xKP6h0UVXZ/rqxIC+n13p8mqxlllVZd16KF4syq73g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmdpP/vx/r/VswBBna6md455fAoind4sFUlI/ZSGHAV68+ZpksiPYe83nh+fMDMihScjQmu0ZKNgkTspP9idFDPE3LeO0fVHeQKLK0mIDpxwJBBJUE1sxhqCNDbaZbzlsUEZTaA5vpqJlMMdcwSh6SKcZsxSqmEDKrRQOfBQfVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZaT5XsFV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZaT5XsFV"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RCUwff346721;
	Wed, 27 May 2026 13:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ojJiTejRlpqWhjkrBV7siwdeZujbQv
	wjtEYhtMEIA54=; b=ZaT5XsFVNRFQbbGGQI8pellkZVquznxdcQxXAG457iOfcB
	aGiXEgQhg7LoYSo224LVIQnHxwZc+M76VGyPFRC+j5SKeUaCCP0JCfUmRMgcP36G
	2VPniRkvMMsQKNZjJ7OTd/l6LPmPNpMPXLot2eMLvLS4AQI3QQiGH1F2EINb14DV
	OxPZQGbF9BHAEfb5gRgbCM1qAV522k64doz7B+Tm42dfEqU8U98Yl2wSopnhdhkC
	usizjczXpgFKHLS0lcgDy8pIkeSjed46RdvmKyGrKGP+/5RT6Ksqv3MAifXYnSwC
	plWyRemjtkzc4juW5AUBpFEVR8Z2H6BJHLBnpYRQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eb4nushbd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 13:14:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64RD98Ja005068;
	Wed, 27 May 2026 13:14:20 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4edjrb346e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 13:14:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64RDEIXE49938718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 May 2026 13:14:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B84620043;
	Wed, 27 May 2026 13:14:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FECB20040;
	Wed, 27 May 2026 13:14:13 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.21.79])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 27 May 2026 13:14:13 +0000 (GMT)
Date: Wed, 27 May 2026 18:44:10 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 15/23] ext4: add block mapping tracepoints for iomap
 buffered I/O path
Message-ID: <ahbuIvX_MQ8Cxznw@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-16-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-16-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDEyOCBTYWx0ZWRfX1wg/tM3qULgI
 q4uZceS8494hULbi5kVQaA/A18d6/pwOY/TvfXV60BhDKRxtnSTnRZWjkcGd3cVgwyFO6CoFmU4
 tM1IPm9eeuGs6KQs0CMVLpeDLPtoTHHEdV9b0mNDUGCzVIMsPY2ewn8GVeHJWu5ZC89y3ZoITUH
 k9hLHY0B9Z48j8RFIpgVs8H+DmH5qdaUAp0ALICjiI/qYb9965irl9viDvnuBTPWw52jlZvvy5i
 KBjNg4CKvUNrU0FZZ6DEwSpVppzG/21famQZYXNepD9EWKK+nT8w6rkAsb3caP+URQOtBEVFczT
 x80yv4jiDnWvkC/G3RveIS54N13artBg4RwMdvO0Eoso07JQDgZejqGd3PI5KJmUq3r2fwJem2J
 PvA5rmw43Lx8+09xb8XtrhcVCmC2HwdLlAyU1lN0hccIypGXOKNTr8Zd1l7n0D1NoWr4X7khVJD
 wa3cwEfvrX68cO8dN8A==
X-Authority-Analysis: v=2.4 cv=UtJT8ewB c=1 sm=1 tr=0 ts=6a16ee2d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=VnNF1IyMAAAA:8 a=Yys7tXmMPiojT3oJJpUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: kW_SprQPii9r1Ntb9gWZNZDxpiOxmafX
X-Proofpoint-GUID: VCfacHA8fNDcuEtGMiIScDRlgcROiY5D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605270128

On Mon, May 11, 2026 at 03:23:35PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Add tracepoints for iomap buffered read, write, partial block zeroing,
> and writeback operations to help debug the iomap buffered I/O path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
Ojaswin

> ---
>  fs/ext4/inode.c             |  6 +++++
>  include/trace/events/ext4.h | 45 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e0dae2501292..239d387ffaf2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3961,6 +3961,8 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>  	if (ret < 0)
>  		return ret;
>  
> +	trace_ext4_iomap_buffered_read_begin(inode, &map, offset, length,
> +					     flags);
>  	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  	return 0;
>  }
> @@ -4034,6 +4036,8 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
>  	if (ret < 0)
>  		return ret;
>  
> +	trace_ext4_iomap_buffered_write_begin(inode, &map, offset, length,
> +					      flags);
>  	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  	return 0;
>  }
> @@ -4136,6 +4140,7 @@ static int ext4_iomap_zero_begin(struct inode *inode,
>  			map.m_len = (start >> blkbits) - map.m_lblk;
>  	}
>  
> +	trace_ext4_iomap_zero_begin(inode, &map, offset, length, flags);
>  	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>  	iomap->flags |= iomap_flags;
>  
> @@ -4308,6 +4313,7 @@ static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wpc,
>  		return ret;
>  	}
>  out:
> +	trace_ext4_iomap_map_writeback_range(inode, &map, offset, dirty_len, 0);
>  	ext4_set_iomap(inode, &wpc->iomap, &map, offset, dirty_len, 0);
>  	return 0;
>  }
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index f493642cf121..ebafa06cd191 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -3096,6 +3096,51 @@ TRACE_EVENT(ext4_move_extent_exit,
>  		  __entry->ret)
>  );
>  
> +DECLARE_EVENT_CLASS(ext4_set_iomap_class,
> +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map,
> +		 loff_t offset, loff_t length, unsigned int flags),
> +	TP_ARGS(inode, map, offset, length, flags),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(u64, ino)
> +		__field(ext4_lblk_t, m_lblk)
> +		__field(unsigned int, m_len)
> +		__field(unsigned int, m_flags)
> +		__field(u64, m_seq)
> +		__field(loff_t, offset)
> +		__field(loff_t, length)
> +		__field(unsigned int, iomap_flags)
> +	),
> +	TP_fast_assign(
> +		__entry->dev		= inode->i_sb->s_dev;
> +		__entry->ino		= inode->i_ino;
> +		__entry->m_lblk		= map->m_lblk;
> +		__entry->m_len		= map->m_len;
> +		__entry->m_flags	= map->m_flags;
> +		__entry->m_seq		= map->m_seq;
> +		__entry->offset		= offset;
> +		__entry->length		= length;
> +		__entry->iomap_flags	= flags;
> +
> +	),
> +	TP_printk("dev %d:%d ino %llu m_lblk %u m_len %u m_flags %s m_seq %llu orig_off 0x%llx orig_len 0x%llx iomap_flags 0x%x",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->ino, __entry->m_lblk, __entry->m_len,
> +		  show_mflags(__entry->m_flags), __entry->m_seq,
> +		  __entry->offset, __entry->length, __entry->iomap_flags)
> +)
> +
> +#define DEFINE_SET_IOMAP_EVENT(name) \
> +DEFINE_EVENT(ext4_set_iomap_class, name, \
> +	TP_PROTO(struct inode *inode, struct ext4_map_blocks *map, \
> +		 loff_t offset, loff_t length, unsigned int flags), \
> +	TP_ARGS(inode, map, offset, length, flags))
> +
> +DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_read_begin);
> +DEFINE_SET_IOMAP_EVENT(ext4_iomap_buffered_write_begin);
> +DEFINE_SET_IOMAP_EVENT(ext4_iomap_map_writeback_range);
> +DEFINE_SET_IOMAP_EVENT(ext4_iomap_zero_begin);
> +
>  #endif /* _TRACE_EXT4_H */
>  
>  /* This part must be outside protection */
> -- 
> 2.52.0
> 
