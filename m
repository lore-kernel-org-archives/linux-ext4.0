Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7607386C2B;
	Mon, 23 Mar 2026 09:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774259110; cv=none; b=UJtE25o6tNmN+suwwl2Zld7rBsbWxkg+i4L1ZgHJ6KYvwiczWf/Es56HeUvjU6r1DzI5V1O0AF+GFRKsjIoTlaaOvu1imB7k+vOjji3DiGFpSDevq8/OdAVnKYKxiYQslf2Aotr352tTqCIxA+baCfXpWB5pE8J31FhVoue7SaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774259110; c=relaxed/simple;
	bh=bkMz10GazKsvBCiqEyw8PCy441M5sQ1aHI1KHGbl76c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kM77NF3A3s+LpS1r76LrhIIVsEmn/vZrpOyNuW/cZbmmZF/5fiVYhRYcTL2ySVIwd+48MM/pJybsXI/vOAVZE0rUn/y+b5J4Miibozm4xB57hOMgSkEHrsXiS+e3CYMbGgfZFxZcA7O4G6R96tsY6ngWkeC/nJH1hmFi+gfYcsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SGG77JXY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SGG77JXY"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62MHhhgY014213;
	Mon, 23 Mar 2026 09:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4WocIwKApRrJg3/6TGNsHVtrUe/eVw
	dy7tQrAM4tqto=; b=SGG77JXYhoQIESwFoxhbMz9YJVsBJV7eTh8zgHOuQD3Bil
	8Hg7oAZTZaMMRh8h/Mp74yb0cD66JBDvFmXiymfGcymSnzk/dr34A4/Xr8UjtOEc
	2ihmU8T16n+75n9/ONkzMK4u7JZDJe5VEHHOOLlqi5+bS2gOmWyDZKxHSUSwcO7O
	qO6TbL2/AXo750Y73+dMM/ZKszKzxXO3/AuwUj+SHzmWlM0HGIozkZLHCPHPnOri
	fQKnd8HOECvzeD/tqsi7ZnjwRqmmOxdODHVEm9zGsHDXEf/loBqsaHZUoaU2HrIs
	jqLTNL8in5uW7oaQjka1Ke7wZ23UCN6665HSgxsA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ktunyns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 09:44:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62N73Jrm009118;
	Mon, 23 Mar 2026 09:44:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nnctw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 09:44:51 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62N9inW936634948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 09:44:49 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26F1F2004E;
	Mon, 23 Mar 2026 09:44:49 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B14A2004B;
	Mon, 23 Mar 2026 09:44:47 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 23 Mar 2026 09:44:46 +0000 (GMT)
Date: Mon, 23 Mar 2026 15:14:44 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: hongao <hongao@uniontech.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: skip split extent recovery on corruption
Message-ID: <acELjJ63JLWjUC64@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HrzOh_W7k6RlrfFkYtpn6MW1cZ13pyqa
X-Authority-Analysis: v=2.4 cv=aMr9aL9m c=1 sm=1 tr=0 ts=69c10b93 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=edf1wS77AAAA:8
 a=hSkVLCK3AAAA:8 a=iHwBjlyiAAAA:8 a=Uzq8OkaD_vH5s2RQFVEA:9 a=CjuIK1q_8ugA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22 a=uNSKXYNwxGiU6LD0JREI:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA3MSBTYWx0ZWRfX4a2MdijRU6v3
 qh3FtaPnzifx7awG6FggUzRMetp+1q7rB7D+1zNDUiVfTctGNNmPpyubpGNIB8AhCmRH5wrpCQm
 Ofpo7OuvRq3rgL1h8EYVD/rO/WKycXarVbT4MiOkFNyGLOzfDm5lgTIMtDspRCuYboq9bRyqftN
 XdbphvOOVMK2wi/4jsTnmLSa5ZNGXi9SXstSEfhSOzngFLoaLW1octa0f9pzIVgpRgWw0QLVt5B
 DcuRST5xdA5f/J1VpkN3sttVwmNXNals+IBnK9b7RZ7kcB60KIf591Mg5Yl+TPyMHE3sTvgn6b9
 ewdtKHb3tRzk/hJrvaR60AUv14s81rfVDZicyzTs18aHwRoZcWs+SL/inTjgBYM4DtcjisRwsIb
 ecX8V5Cge0J7y5Nqf8USrthB2KENL2AItOxI06IvN25+rjWKsjRZmXxf7/FX0HHUpAToef1Fho7
 pyZqEbJ2BIswnWa/WEg==
X-Proofpoint-GUID: HrzOh_W7k6RlrfFkYtpn6MW1cZ13pyqa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_02,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230071

On Mon, Mar 23, 2026 at 09:57:52AM +0800, hongao wrote:
> ext4_split_extent_at() retries after ext4_ext_insert_extent() fails by
> refinding the original extent and restoring its length. That recovery is
> only safe for transient resource failures such as -ENOSPC, -EDQUOT, and
> -ENOMEM.
> 
> When ext4_ext_insert_extent() fails because the extent tree is already
> corrupted, ext4_find_extent() can return a leaf path without p_ext.
> ext4_split_extent_at() then dereferences path[depth].p_ext while trying to
> fix up the original extent length, causing a NULL pointer dereference while
> handling a pre-existing filesystem corruption.
> 
> Do not enter the recovery path for corruption errors, and validate p_ext
> after refinding the extent before touching it. This keeps the recovery path
> limited to cases it can actually repair and turns the syzbot-triggered crash
> into a proper corruption report.
> 
> Fixes: 716b9c23b862 ("ext4: refactor split and convert extents")
> Reported-by: syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1ffa5d865557e51cb604
> Signed-off-by: hongao <hongao@uniontech.com>
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ae3804f36535..aba9947fd151 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3239,6 +3239,9 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
>  
>  	insert_err = PTR_ERR(path);
>  	err = 0;
> +	if (insert_err != -ENOSPC && insert_err != -EDQUOT &&
> +	    insert_err != -ENOMEM)
> +		goto out_path;

Hi Hongao,

Thanks for the fix. This makes sense to me since we anyways don't
zeroout for these cases and just return the error, the callers
should expect no guarantee that extent is in a stable state.

Are you able to replicate this issue btw as I don't see a syzbot
replicator for this.

>  
>  	/*
>  	 * Get a new path to try to zeroout or fix the extent length.
> @@ -3261,6 +3264,13 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
>  
>  	depth = ext_depth(inode);
>  	ex = path[depth].p_ext;
> +	if (!ex) {
> +		EXT4_ERROR_INODE(inode,
> +				 "bad extent address lblock: %lu, depth: %d pblock %lld",
> +				 (unsigned long)ee_block, depth, path[depth].p_block);
> +		err = -EFSCORRUPTED;
> +		goto out;
> +	}

Looking at the syzbot report, it does seem this is possible, but looking
at ext4_ext_insert_extent() it is not immediately obvious. Do you know
what codepath can lead us to path being valid but p_ext being NULL.

Regards,
ojaswin
>  
>  fix_extent_len:
>  	ex->ee_len = orig_ex.ee_len;
> -- 
> 2.51.0
> 
