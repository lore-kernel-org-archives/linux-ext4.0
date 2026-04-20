Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25E137F74B;
	Mon, 20 Apr 2026 09:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776676379; cv=none; b=mFHnKc17S6RUJrz/463lb05ny1DL1TQqkwqkzU0f2oId9LNYBDQmLGlReblvi6h5MzEtfcfTBc+/APtliFKXzJJ6zP4JgCfoPpp5lkSR2G3os49GGMbvfgNrjrkF8JU+Qmy+cM6NvJdLXnQICKcNdUZbDi0NfC/igHBD3gSYUdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776676379; c=relaxed/simple;
	bh=KoGVtdg1g+MrCDc5eiHeWpU+D5GYDjyCFCA1eewjko0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYXhe0bS3llB5d6vhaLSvMDoif8yltFxDGoZGsq5CrW80jmVDGM7NIvSgB5VtjCfNha30mkv0QNIMVRixUUpTcDPdwje4kJduDRwn/yQhV7XJ3kMI5nOmPGpG7RmjQ943gvnKCK1Ra0Gz4g/OGAyzRe2xzFih7MXmz8yjK6bg7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OOCt5gjr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OOCt5gjr"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JCYwSp2133288;
	Mon, 20 Apr 2026 09:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=c21OFCBwUIbp/u9lP+p9fQGxA2aLra
	42dGdz6tx7Ch4=; b=OOCt5gjrrOIjJJkcWtZevSyx0DOk5oUOKH/8TYrMxR8yma
	PJRu+J7eJyB2wq23FAYFLUju+p8NpaPKt2fhDsg0q/lAqrQc2zNLk8bgnuaDgo9I
	zbzYapDMHKh3S/iHulxXE3GLv2iGlXkwwXxAUlMsbpAnPhi2PlUMrZVYN2cyu8yf
	gnwR9cv01Blm4jS46CfornXprRmf3mwUY3OLA/bc/88hvkvWeaJ+olUCmlYO4s17
	KwTnTbFeM+grPDEe/PxwNdr2q0b9OpyQMcYl3UdOqU+Xhnhw+Y8QybTVy+dFK/oK
	WOtZomgEHlBJBeFOEhE9DgK6tDE2Ut8N+P5UtDRQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k4y24t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:12:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63K95Iej010640;
	Mon, 20 Apr 2026 09:12:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmmnvm78h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 09:12:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63K9CZ1d41746884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 09:12:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 122252004B;
	Mon, 20 Apr 2026 09:12:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7EA420043;
	Mon, 20 Apr 2026 09:12:32 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 20 Apr 2026 09:12:32 +0000 (GMT)
Date: Mon, 20 Apr 2026 14:42:30 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Baolin Liu <liubaolin12138@163.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, wangguanyu@vivo.com,
        yi.zhang@huaweicloud.com, ritesh.list@gmail.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Baolin Liu <liubaolin@kylinos.cn>
Subject: Re: [PATCH v2 v2 2/2] ext4: allow clearing mballoc stats through
 mb_stats
Message-ID: <aeXt_qg1SprB9Gu_@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260419063436.17999-1-liubaolin12138@163.com>
 <20260419063436.17999-3-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419063436.17999-3-liubaolin12138@163.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: -d-WdsSmI4NZJ5Cyzh28ctBXX_Us7wqe
X-Proofpoint-ORIG-GUID: KHFqeRS9YESLyi-Vy-yE428N19hyYnTi
X-Authority-Analysis: v=2.4 cv=VP7tWdPX c=1 sm=1 tr=0 ts=69e5ee06 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=Z9s8-SXkMn35Qo44R9YA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA4NCBTYWx0ZWRfX/kLP3j9QBbB7
 L3F4OlaJWktGtV1De63+yJ8/x1ruEIlXdoqRplvWgDxSIaqXOsg1Ou9JHRIl68bNtHgVVl1UcHG
 769CciISNnXYKsqyDIeyS8EpEjcSpPOQ5TJqQ9DIQqJRNxLZGJtIAXe8dK3xIRwTRB2QSawkgTr
 Nfk6/GHBQa/QRmSab/m0FPPAXtN8/Ug5R9pKSlW95E70f7VbFIorhtXK0hq91xOywpnPqmW+9fe
 A1LtHkne1+lNmFWBqWz69/nXiGKmQx9majNk0Fkc9yyPlHJW2MNZaqgMOo3DDaj/pJNwtkNeZwX
 kmytCjDz5sDIPfGK1svf3pU22ZG/MdWhQi3s8iM6hQ0FL0ovnmg3OeChxXGo9z7VBRuErrbGhxS
 FYhWV+ZxxukEYKjHEldWMR1/uee5MRV1/qn1nl0psEnOlJZrAaPJHimbuNL2sFUNi8SYOTyXhDH
 6oqdbgVJStKPemOYcFA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200084

On Sun, Apr 19, 2026 at 02:34:36PM +0800, Baolin Liu wrote:
> From: Baolin Liu <liubaolin@kylinos.cn>
> 
> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
> mballoc statistics when 0 is written.
> 
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
> ---
Hi Baolin, thanks for the changes.

Seems like userspace doesn't have any way to know that writing 0 will
clear the that. Well, I guess if you are looking at this file you are
anyways debugging kernel code so that should be fine

Feel free to add:

Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin


>  fs/ext4/ext4.h    |  1 +
>  fs/ext4/mballoc.c | 29 +++++++++++++++++++++++++++++
>  fs/ext4/sysfs.c   | 40 ++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 68 insertions(+), 2 deletions(-)
> 
