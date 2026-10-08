Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4244848BB;
	Thu,  8 Oct 2026 09:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791451869; cv=none; b=Aat2RX4GGzHmUE8yx1n685GWAs3x4RJ3KSO4gbk5dOvJKOzOykJyXBMI4Vo7COrBgQIYggyT1qMWTrTdojYJDneEiGigyQoWasleq0NBJgTn9KVIhjU+/VDaQ1Nmr96Rr/fjc5mUYkMSgLIX3QepFYiqhN+bAUuD+Uh00Ch6HUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791451869; c=relaxed/simple;
	bh=yHVgXx/uvblcf4FGPKl/5MPvA0vy7kyz12X9k+fx0VE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfDojq6QPghnai4h2dHSTUgXQOGAF3sdYvihh10TpMQQ+MxXqutdLuoMZwdHmpp1rdHAykf5BdWRWKyWCcm2SAZ4jiw3ZezSvJ9mbOPjTePr5HGNuMHd4STesCic3lgfBbIUPoqU/xgzvlcbaAd/4fRkzyTG4Ev57hrplHLKeqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aKOvUH9f; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aKOvUH9f"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987ZUqB702521;
	Thu, 8 Oct 2026 09:30:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4mmlYcOAw1Ji/kRyN8Y92cAcT8+RCP
	7yF1qo+dl5+s8=; b=aKOvUH9fIcStWCpPrIO0u7Jzx8mXTXza3+Y3/NIbN5lUYI
	Iiv7WKBtSbb7FHetTtnp7v7O+6AZIhV5IxxrjixbaaFJAknJc7LV0KPZvGkgQvnj
	QPEc7QA+Wf+2+R+bwL+clzlZnhdNm3BcxaOvM8dFWWdnTuMwV05Bk61jB/QclvtJ
	BDtHkKL9nOot91LGlFt7qu5cnF8Kzyfb3rpxw398Pa4XoW0LGqIRzD6+mBQWNvM1
	IztnsttK4NPCaMFFusfs12q92JbQuZpJL0RQ48r5QaO16y0xtE9/R+SrHp/UwuIy
	rze1g0jrT4Hb0Go98aUWS6F2Gzu/J2y+rFRyibhw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjvaptn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 09:30:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6987IZoH1873310;
	Thu, 8 Oct 2026 09:30:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5f3twh78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 09:30:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6989UmEX39780820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 09:30:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC69420043;
	Thu,  8 Oct 2026 09:30:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A53042004B;
	Thu,  8 Oct 2026 09:30:44 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.26.191])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  8 Oct 2026 09:30:44 +0000 (GMT)
Date: Thu, 8 Oct 2026 15:00:41 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: daejun7.park@samsung.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Li Chen <me@linux.beauty>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ext4: don't cache unzeroed blocks as written
 after a failed zeroout
Message-ID: <asdiwfbq_b4xcedy@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com>
 <20261008-ext4-fc-zeroout-v2-1-55cab1e24fa3@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008-ext4-fc-zeroout-v2-1-55cab1e24fa3@samsung.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: k-GlGNU0xsbbSlAZkAtoMNJC-R66gFrP
X-Proofpoint-ORIG-GUID: iVuC10Oq2SFlJRGIO5XnHnsg1soO3gv_
X-Authority-Analysis: v=2.4 cv=H8NOUOYi c=1 sm=1 tr=0 ts=6ac762cb cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=hD80L64hAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=j3eI-2nGvsLuMrB2CGwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzNiBTYWx0ZWRfX8jU8YLz6T7eJ
 o8MJHBLJLbJ/jXhbPliRK0bLkhaTolBKiZaDZhsXbNsIe4ebYU+//XuguHLTMOmVIEffMsI22oR
 LmKNqWYvW6wcZlHKAP0Aj1F4gyMeTa56mRSBBK8IIC2htUe/KN3SB9spPKr4Lne4vZJ6LVwYtJa
 hjxkBlMCYFqxV5ifHhVKp5xVs4U5Nil+8YI3JqPOxhW5bT41RSNRAqvWcroGjXQLWBxv7VZ/mcZ
 MG7E5DnFPUBDOi2FGU/WbNhugLj/NzZXQTsuvmNxbNBqzkhsD3ypNGZVgjWLDqKnSdJ5ochrNAQ
 xvlwEpUit95MzFDFnAX2tVsaCdexRSdbYMJOwn3rQUy0n9QWbDIrqlD3meDsCg1gE2z9Qakb36J
 adAokjE7WxzfrEezHg5p5zkE265UekCEQ7bnVM6imxnnZjSHomoah5TqFunZva0QNAQwicyTtna
 N3chWB4ppfZhPgaMVDg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzNiBTYWx0ZWRfXzk5RBx2zeldZ
 4nKOI6IkKxuE8yRnAvBjCZpBoB4NRR1xMxhLgMeRK8drgLtW/+lTCsNpTIx+Z4lGuSDuDrfCOzY
 SnMVwZxELT6wUiNaJOlHasV67vfaJoI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080036

On Thu, Oct 08, 2026 at 10:25:36AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> ext4_ext_convert_to_initialized() may zero out the blocks before and
> after the range being written and convert them to written together with
> it, instead of splitting them off the unwritten extent. If
> ext4_ext_zeroout() fails for one side, it falls back to splitting the
> extent, so the blocks on that side stay unwritten in the extent tree.
> But zero_ex1 or zero_ex2 keeps its length, and ext4_zeroout_es() still
> inserts those blocks into the extent status tree as written.
> 
> Until that entry goes away, a read of those blocks returns whatever was
> on the disk before the extent was allocated. A write to them is mapped
> from the cache and goes in place without converting the extent, so its
> data would read back as zeroes once the entry is dropped. To reproduce
> on 4 KiB blocks with -o nodelalloc: fallocate 32 KiB, map the last seven
> blocks of that extent to dm-error, write the first block, restore the
> mapping and read the second block. It returns the old disk contents
> instead of zeroes.
> 
> Clear the length of an extent that could not be zeroed out, so that
> ext4_zeroout_es() skips it, as the comment at the out label intends.
> 
> Fixes: 308c57ccf431 ("ext4: if zeroout fails fall back to splitting the extent node")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  fs/ext4/extents.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 836396ea79..d65e30f3c1 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3755,8 +3755,10 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
>  				ext4_ext_pblock(ex) + split_map.m_lblk +
>  				split_map.m_len - ee_block);
>  			err = ext4_ext_zeroout(inode, &zero_ex1);
> -			if (err)
> +			if (err) {
> +				zero_ex1.ee_len = 0;
>  				goto fallback;
> +			}
>  			split_map.m_len = *allocated;
>  		}
>  		if (split_map.m_lblk - ee_block + split_map.m_len <
> @@ -3769,8 +3771,10 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
>  				ext4_ext_store_pblock(&zero_ex2,
>  						      ext4_ext_pblock(ex));
>  				err = ext4_ext_zeroout(inode, &zero_ex2);
> -				if (err)
> +				if (err) {
> +					zero_ex2.ee_len = 0;
>  					goto fallback;
> +				}
>  			}
>  
>  			split_map.m_len += split_map.m_lblk - ee_block;
> 
> -- 
> 2.43.0
> 
> 
