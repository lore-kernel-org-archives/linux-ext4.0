Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0228138AC83;
	Fri, 31 Jul 2026 13:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785503284; cv=none; b=jRUQry/u+o+vbCT4osGNW2CeAMjAxHdB/XQkBz6nRiJtOZJcVn+TtJlG29igr5Rb9H0qufOPdXI9tek7K9z2RjxSMfYFLV4Z76iPWmYg0gPve8Hsx7EovX2lGo+AIyqzT6BaIjST1hG9klimbP/wTSwuJFOWTVPqTq4fhxHUYh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785503284; c=relaxed/simple;
	bh=DzAzVdxf3fhwunMx8MquiIZhkaMYX1shMj5NUh2jnHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FlDzZS+IUiOViPJAKZHd2eNCXi0G/zd/1CISYAHV4DXXSaiRvsNssvyN3GCwx/igfSaZR5eXQsxwF8yq69ImsHZ/7Xaocw7+5YOJmRlXX2y2VPBC5/OacLnNP6S7Z7JpEONelcKVp6ATJ0egvkdxG+5jscE57HOWZuZoNGATjZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B8F/ME6+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B8F/ME6+"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VBlqWd1765837;
	Fri, 31 Jul 2026 13:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=e/llAvWoxRkcp9yr8XX8OTAt+j0CoD
	qjLuH9fhk6XSo=; b=B8F/ME6+25HZ1EU9w+Al9h4+vwD0aWX5VyhHaPaAe46Epi
	o/tZIx77mPNQRjL+xiqd9/yjC4YtF531zWs8sBsHW9YhGhqTy7s529fvWaWd+C2Z
	+S2A6L8HbQnO+Mdd3ZyjcKe45+vzNNVfnHmUc3w9Q9YUc+ox/dlOsd5banzI8xWO
	QyXivkrUIdUizKWTjGscgErndIk0wsK0IkS/gIytQtkxhWYABbv+HlfBgJDpWfRM
	+zPHwIuPgn9dO5HdiZhqtLPeWPtrk06fpofyrTu5bBAXCw9lAInuX+7TYIeqqGT+
	2V0xUaA/s6UITzO7+GX4LXIhjcfBENjKGis6RJVg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0y55yf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 13:07:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VCuGGp021726;
	Fri, 31 Jul 2026 13:07:41 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn7uwg3xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 13:07:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VD7cQt50790842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 13:07:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA66A2004B;
	Fri, 31 Jul 2026 13:07:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63E4E2004E;
	Fri, 31 Jul 2026 13:07:36 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.209.143])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 Jul 2026 13:07:36 +0000 (GMT)
Date: Fri, 31 Jul 2026 18:37:33 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Reduce object size of ext4_msg uses
Message-ID: <amyeFUiajzssyOs_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <7fbad87ae7e108571cafffa8fa0715ce4d2c5261.camel@perches.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fbad87ae7e108571cafffa8fa0715ce4d2c5261.camel@perches.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: KhWaUOzY-9VIeMPMEUo54E9GRYpcUy8o
X-Proofpoint-ORIG-GUID: uYv4N274_yScIEHwnIYp1vH9BA0vMyTG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA5NiBTYWx0ZWRfXytr451++Ycc2
 ox774wzmyWR/vID3WCxvxR0knvVOowvrq+X9y1A6EIibPmIrw0KP4kW0gDI3XJHchMurASUfRiE
 DJFEbg6BPFWfWHoUC3G/2PyUJvd1CYM=
X-Authority-Analysis: v=2.4 cv=dYuwG3Xe c=1 sm=1 tr=0 ts=6a6c9e1e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=IJv9LcIfAAAA:8
 a=VnNF1IyMAAAA:8 a=sFNIgBltbu1xmj6tgGIA:9 a=CjuIK1q_8ugA:10
 a=cmr4hm9N53k6aw-X_--Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA5NiBTYWx0ZWRfX6Xj5kn5X2NrI
 dK9Xdtfid/K1G99+kHhTW+lRngYs0+bgiyllQDfaI1/LPRWlF3loOQ9ZY0Lna8F1h+Qh8T+4xk3
 HAOZtKxkansjk25wPjFWTn95jknvcDi4bF7CXCSCJna8GgZwtl225fAgSn4hOJxd3vaVJTo/nX0
 KYdbpe/djX3gD752Xu/kw/AyBHf5ir3RueF0lE87+wPPvI5bJU/f1FPMfs7hMNCoVkeIfbdhjmA
 QyYNoVl/yk6fqVcb2wMn7G4VKNgZuqNiFmWbCdWZB1Cc23YNU/O0b4qZwiwkIFM1Eix7+3IqJj+
 YmSYaT/yTRVguWQbVA5ZUxSiH8x88EOEZ2tC95Hpov2YbZMdYU8Tw69tUil/1PC2ENAO1EYlzdf
 zgjj4SJPcutOso+s31M1YfHBKnuRw4CcuW8f9udgw1nG4CrtXTkFm3Jz65JSigvESnRE2uJASj9
 ReumvU3wATiXXUH8HkQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310096

On Fri, Jul 24, 2026 at 06:23:36PM -0700, Joe Perches wrote:
> Reduce the object size of ext4 ~2KB (~.5%) by combining the KERN_<LEVEL>
> and format uses of ext4_msg.
> 
> Separate them in __ext4_msg using printk_get_level and printk_skip_level
> and emitting the appropriate level.
> 
> x86 object sizes before and after:
> 
> defconfig size before:
> $ size -t fs/ext4/built-in.a | tail -1
>  579013	 121634	    316	 700963	  ab223	(TOTALS)
> 
> defconfig size after:
> $ size -t fs/ext4/built-in.a | tail -1
>  577196	 121650	    316	 699162	  aab1a	(TOTALS)
> 
> defconfig size before with CONFIG_EXPERT=y and CONFIG_PRINTK=n:
> $ size -t fs/ext4/built-in.a | tail -1
>  537999	 121432	    316	 659747	  a1123	(TOTALS)
> 
> defconfig size after with CONFIG_EXPERT=y and CONFIG_PRINTK=n:
> $ size -t fs/ext4/built-in.a | tail -1
>  536837	 121424	    316	 658577	  a0c91	(TOTALS)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Interesting, on powerpc64, we save around 1 - 2K. Its not much but sure,
maybe some embedded or chip bringup scenarios might find it useful.

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> ---
>  fs/ext4/ext4.h  | 12 ++++++------
>  fs/ext4/super.c | 14 +++++++++-----
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..981918f32067 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3309,8 +3309,8 @@ void __ext4_warning(struct super_block *, const char *, unsigned int,
>  extern __printf(4, 5)
>  void __ext4_warning_inode(const struct inode *inode, const char *function,
>  			  unsigned int line, const char *fmt, ...);
> -extern __printf(3, 4)
> -void __ext4_msg(struct super_block *, const char *, const char *, ...);
> +extern __printf(2, 3)
> +void __ext4_msg(struct super_block *, const char *fmt, ...);
>  extern void __dump_mmp_msg(struct super_block *, struct mmp_struct *mmp,
>  			   const char *, unsigned int, const char *);
>  extern __printf(7, 8)
> @@ -3354,8 +3354,8 @@ void __ext4_grp_locked_error(const char *, unsigned int,
>  	__ext4_warning(sb, __func__, __LINE__, fmt, ##__VA_ARGS__)
>  #define ext4_warning_inode(inode, fmt, ...)				\
>  	__ext4_warning_inode(inode, __func__, __LINE__, fmt, ##__VA_ARGS__)
> -#define ext4_msg(sb, level, fmt, ...)				\
> -	__ext4_msg(sb, level, fmt, ##__VA_ARGS__)
> +#define ext4_msg(sb, level, fmt, ...)					\
> +	__ext4_msg(sb, level fmt, ##__VA_ARGS__)
>  #define dump_mmp_msg(sb, mmp, msg)					\
>  	__dump_mmp_msg(sb, mmp, __func__, __LINE__, msg)
>  #define ext4_grp_locked_error(sb, grp, ino, block, fmt, ...)		\
> @@ -3401,8 +3401,8 @@ do {									\
>  } while (0)
>  #define ext4_msg(sb, level, fmt, ...)					\
>  do {									\
> -	no_printk(fmt, ##__VA_ARGS__);					\
> -	__ext4_msg(sb, "", " ");					\
> +	no_printk(level fmt, ##__VA_ARGS__);				\
> +	__ext4_msg(sb, "" " ");						\
>  } while (0)
>  #define dump_mmp_msg(sb, mmp, msg)					\
>  	__dump_mmp_msg(sb, mmp, "", 0, "")
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 245f67d10ded..72d6f6353a27 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -981,11 +981,11 @@ void __ext4_std_error(struct super_block *sb, const char *function,
>  	ext4_handle_error(sb, false, -errno, 0, 0, function, line);
>  }
>  
> -void __ext4_msg(struct super_block *sb,
> -		const char *prefix, const char *fmt, ...)
> +void __ext4_msg(struct super_block *sb, const char *fmt, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> +	int level;
>  
>  	if (sb) {
>  		atomic_inc(&EXT4_SB(sb)->s_msg_count);
> @@ -995,12 +995,16 @@ void __ext4_msg(struct super_block *sb,
>  	}
>  
>  	va_start(args, fmt);
> -	vaf.fmt = fmt;
> +
> +	level = printk_get_level(fmt);
> +	vaf.fmt = printk_skip_level(fmt);
>  	vaf.va = &args;
>  	if (sb)
> -		printk("%sEXT4-fs (%s): %pV\n", prefix, sb->s_id, &vaf);
> +		printk("%c%cEXT4-fs (%s): %pV\n",
> +		       KERN_SOH_ASCII, level, sb->s_id, &vaf);
>  	else
> -		printk("%sEXT4-fs: %pV\n", prefix, &vaf);
> +		printk("%c%cEXT4-fs: %pV\n",
> +		       KERN_SOH_ASCII, level, &vaf);
>  	va_end(args);
>  }
>  
