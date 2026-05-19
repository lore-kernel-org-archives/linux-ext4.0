Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089653FD134;
	Tue, 19 May 2026 09:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779182968; cv=none; b=QAf8Dgck7h3cOkrbRUpgMsncFHxh4GVP4RitdLV2Lon1Q7E/umvCf6ONtH4Cjuc6E70czZhsGEM6rGD1O5kcxS+Ce8CbWRBfiLemkDGbNk83mHnYdehrFQSCgTs4phpinHpZLp/GU1ZUhLwC6utPm2BOMUvq0KLKz9Fa4eadV5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779182968; c=relaxed/simple;
	bh=PMUiZ5voZItO46rTYWv/NL4e46TaxZE4b2t+dnenaqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTlEXfQbjjQu0ElLD5k7q8UO34oe1oBkcHg8YniRqgSQWa2QX0fCi00/6ZEu/JpHzcZESsMZSujEDO1aNov60EqYPHiJparoFKdkfJEr5F1hU2lOtrKmHzkrNE01p8JEkhFQALjnmQ/llwhbBs+e95kS2nvYN4bbYqXI1Sfa+SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B6NQjZ7C; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B6NQjZ7C"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IJ5wC7220135;
	Tue, 19 May 2026 09:28:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=GvCXPaY9Li9eupkMJaDNNHDxW38Vh2
	ZOXrok0QStvNA=; b=B6NQjZ7CjmuKTMHnUvN6UlPgOLfjQ/zwwkko2a73r2D234
	iGC3ByHTiqeyBsNiEZYCUQpvA/Dg+9At7k3vcbKM3p76f4UEMOM1AsjYzcy2TSDU
	QbmFsQLZC3yIq5BZej9a6Jn1B/yBDmKg3zKKbcPITz2JUUSA5S/VcGOMq6Tih5n4
	M2dEUFxBNeo3hk7PXAfxika22MEkPBe7EjcMJG24GQDrjzBEObPxCBPt4LLAmsAR
	Q9yUz5pDoTsUZiV6gZZBKdNDVSCaGdU2FTzy4W64xAYDE4E+t5pNgmqwhxvAmQci
	6fdrillt3medqJfwalzAHveGCosKVjtkB5+8WZgg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9xv8nd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 09:28:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J9OUld016855;
	Tue, 19 May 2026 09:28:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739vt1mq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 09:28:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64J9SCTs31850892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 09:28:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CC282004B;
	Tue, 19 May 2026 09:28:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1383120043;
	Tue, 19 May 2026 09:28:09 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 May 2026 09:28:08 +0000 (GMT)
Date: Tue, 19 May 2026 14:58:06 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
        djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 04/23] ext4: add iomap address space operations for
 buffered I/O
Message-ID: <agwtJq5-B2E-t7zT@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-5-yi.zhang@huaweicloud.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDA4OSBTYWx0ZWRfXwfFQ+Wz8DJaR
 bGdhWvXo+JN6yUmhM9kGGwBlm4nVIsr3EFovujef+ueKUPgaUZPvy79qAGb3Bxcy4mcl6PacxlN
 kUQ0tke+wdX69yJd8F4MpAtZRjQLEvrV+r6rrhSrO94KNZcHL76ZVFC4LJii8r2D3NeOJBmbBU7
 oGRiZ2BGob0tuJHUnhV4PnSxxtfOyRJSX7vmDDOvUlDragNq6qmFVWSSjnsBb1udfkOvHFv6Oyc
 ErDGLhaRLnD8YqCNmuJ3N3auWWuCSXbTS3neyIC+5P8gjXHhOTSwR3E2LkrdRCNepmChOil/kBG
 sey8soZSGeCc9e1CUy8YyhhpQTMtk89yszs+uRojVkuvGMRqVLAispwxInN2WjMuAsRFfC13EoL
 V+86HAVoBwr4b7l30PME8CQohhXTsrhDwvBL6XHWAAo8beMKrOGuyQWT+RNmQqWqsWXj8xPz3C1
 QA/zH1DrWLHdFbxdN4g==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0c2d30 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=i0EeH86SAAAA:8
 a=4_HcevU3tUaN4LvWHNsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: YXJ2Yzw7qXJufjJsDhcnx-8SgeX-Ao83
X-Proofpoint-GUID: q4tzlombJEIgEV1TbKYjz7nUo6b6qSaO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190089

On Mon, May 11, 2026 at 03:23:24PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce initial support for iomap in the buffered I/O path for regular
> files on ext4.
> 
>   - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
>     inode uses iomap instead of buffer_head for buffered I/O
>   - Add helper ext4_inode_buffered_iomap() to check the flag
>   - Add new address space operations ext4_iomap_aops with callbacks that
>     will use generic iomap implementations
>   - Add ext4_iomap_aops to ext4_set_aops() when the flag is set
> 
> The following callbacks(read_folio(), readahead(), writepages()) are
> provided as placeholders and will be implemented in later patches.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Hi Zhang, looks good to me. Just a questions below:
> ---
>  fs/ext4/ext4.h  |  7 +++++++
>  fs/ext4/inode.c | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..1e27d73d7427 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1972,6 +1972,7 @@ enum {
>  	EXT4_STATE_FC_COMMITTING,	/* Fast commit ongoing */
>  	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
>  	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
> +	EXT4_STATE_BUFFERED_IOMAP,	/* Inode use iomap for buffered IO */
>  };
>  
>  #define EXT4_INODE_BIT_FNS(name, field, offset)				\
> @@ -2040,6 +2041,12 @@ static inline bool ext4_inode_orphan_tracked(struct inode *inode)
>  		!list_empty(&EXT4_I(inode)->i_orphan);
>  }
>  
> +/* Whether the inode pass through the iomap infrastructure for buffered I/O */
> +static inline bool ext4_inode_buffered_iomap(struct inode *inode)
> +{
> +	return ext4_test_inode_state(inode, EXT4_STATE_BUFFERED_IOMAP);
> +}
> +
>  /*
>   * Codes for operating systems
>   */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b1ef706987c3..178ac2be37b7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3908,6 +3908,22 @@ const struct iomap_ops ext4_iomap_report_ops = {
>  	.iomap_begin = ext4_iomap_begin_report,
>  };
>  
> +static int ext4_iomap_read_folio(struct file *file, struct folio *folio)
> +{
> +	return 0;
> +}
> +
> +static void ext4_iomap_readahead(struct readahead_control *rac)
> +{
> +
> +}
> +
> +static int ext4_iomap_writepages(struct address_space *mapping,
> +				 struct writeback_control *wbc)
> +{
> +	return 0;
> +}
> +
>  /*
>   * For data=journal mode, folio should be marked dirty only when it was
>   * writeably mapped. When that happens, it was already attached to the
> @@ -3994,6 +4010,20 @@ static const struct address_space_operations ext4_da_aops = {
>  	.swap_activate		= ext4_iomap_swap_activate,
>  };
>  
> +static const struct address_space_operations ext4_iomap_aops = {
> +	.read_folio		= ext4_iomap_read_folio,
> +	.readahead		= ext4_iomap_readahead,
> +	.writepages		= ext4_iomap_writepages,
> +	.dirty_folio		= iomap_dirty_folio,
> +	.bmap			= ext4_bmap,
> +	.invalidate_folio	= iomap_invalidate_folio,
> +	.release_folio		= iomap_release_folio,
> +	.migrate_folio		= filemap_migrate_folio,
> +	.is_partially_uptodate  = iomap_is_partially_uptodate,
> +	.error_remove_folio	= generic_error_remove_folio,
> +	.swap_activate		= ext4_iomap_swap_activate,
> +};

So one question, for ->release_folio() we are using
iomap_release_folio() instead of ext4_release_folio() here which doesnt
make the jbd2_journal_try_to_free_bufferes() call. IIUC this function
seems to be trying to clean up already checkpointed buffers.

I wanted to check if ->release_folio() can be called for folios with
ext4 metadata buffers? (from my limited understanding of
shrink_folio_list() -> filemap_release_folio() it seems we can) And if
it can be called, is it okay to skip the
jbd2_journal_try_to_free_buffers call?

Regards,
ojaswin

> +
>  static const struct address_space_operations ext4_dax_aops = {
>  	.writepages		= ext4_dax_writepages,
>  	.dirty_folio		= noop_dirty_folio,
> @@ -4015,6 +4045,8 @@ void ext4_set_aops(struct inode *inode)
>  	}
>  	if (IS_DAX(inode))
>  		inode->i_mapping->a_ops = &ext4_dax_aops;
> +	else if (ext4_inode_buffered_iomap(inode))
> +		inode->i_mapping->a_ops = &ext4_iomap_aops;
>  	else if (test_opt(inode->i_sb, DELALLOC))
>  		inode->i_mapping->a_ops = &ext4_da_aops;
>  	else
> -- 
> 2.52.0
> 
