Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792334;
	b=E/C5SWadehTE2nCrEI84n5b5YdTsAp3RrJ3/5iKZ7YcV6fCUbDVlFg40qH5q49UJXera
	 iQWcl/sv2yJNMMDM05lbB8hMZGJZHa6R+nDsgclLxtuNFTz9g4qEVBu6q+qdJPeW46+ta
	 nLWAzewd4cs9YtbRy0uaeWqzWM/75fT4VetFCb5vd2jCA/RnAQftjHeBp56tsqXFLYMM9
	 ySrwzB/DHRx5oLxGYke98lCY5ogLd90iTyKhr6COdX0xxi4MvzJ0lZVmHqaBFuLbYxApE
	 mA0XnQuhLtgrg1OpFqAKFr4/nlU6yRAckpaus8o4n1FJpx8t66b/SHdBg7A1xzRPhzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792334;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=JguMDeketz0aJ5tG4V2w4wg3L7yYMiRjEQk6NS/fJ8w=;
	b=CIET1Xv2xGZnHrf3QKRGHVFVnrU5+K/WR2OmUhIJELg93AnGGRRUo3LXzUY2EhaVfJZE
	 WGK8ip9p/5FUdyrVZ2DBb5xo3vujOUpLc4Oz0xkhbLWW9RaxaKUkSyQb1b8rNthOP1HIi
	 ahE+TDgs5yois0/AoQhnygZqwmYpW2RQMex/R8ys1PVRKARrDGQBa2j3K4z4A6IzH4lxb
	 Ukpq7NeBQQbK4CHsdJvmmmnogRJGStszKs5tJYt7BdijmqBlEEpERpG+NXTr9Q0x2j1A0
	 dt0mJf+BdTy3b0mamQMpvz7OTJB2AVWgy+sF+nBsWwIF3vojWBL6tRkaObGnQ7UZMQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CqBikNXw;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E40606A6A1;
	Fri, 27 Nov 2026 15:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78E40606A6A1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=CqBikNXw
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4cSJ1650134;
	Fri, 27 Nov 2026 15:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JguMDe
	ketz0aJ5tG4V2w4wg3L7yYMiRjEQk6NS/fJ8w=; b=CqBikNXwtNBwN7FSUezTMN
	PEchtNoAJ+4V5hk4m19MMZ8U1L2AQvxuLms9NBxn3AUSLalS2kziXVVCSRKOw5Tu
	S5gzhrf0ORcQomDRVW7xC8kOroWGEF97/TRCpdZpE0NUHDWH6g440cikR3rRqUUg
	UzY2FlejFxZ0lc70mVS3F47OZoTJ50Q8/IwsMJ3BTel2+wVKMJ25dgzzIarAUtmT
	ibJTmszdV4RUdXTl7CAAcJ+S2lxC6CSa012wSrvQVBwYFl8nUI5cccHzaLo9gmDt
	D06zJRT8kPEzYg6tpQQ1ytPsSib6EMPwYjmacHIn9haA0CBjEdTXs5BZHVNYAnTA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3pde4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:12:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4FZ31180983;
	Fri, 27 Nov 2026 15:12:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6rhckqdc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:12:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBvfM7471382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54C8020043;
	Fri, 27 Nov 2026 15:11:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E43A20040;
	Fri, 27 Nov 2026 15:11:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:54 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:41:00 +0530
Subject: [PATCH v2 13/13] ext4: re-enable zeroout fallback
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-ext4-endio-zero-bug-v2-13-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b099dc2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=yX2KSBNdrbUira0Ip4AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX5JGemIKXWBgB
 97YhN1iFevShqbKYi2eWvPdbAHCRnMt5LeDojZWq/wtj90ln0u+Xi94VXRLeccVWluP9OxDe++5
 ESESRULaS1wdFhmcXQ/GpfVkezJQNyE=
X-Proofpoint-ORIG-GUID: 3sEDHlN1BPnS1F3ZzzdCDUg52_2loTeN
X-Proofpoint-GUID: zGvkzZ2boJR31jIKWKcZ2UmsTIiUWkih
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX/opeB1LRUg7D
 fcrSCxX92GzlQj1BRC5ZEzS6MdT+EQmGe1K4qIE60HiqgGhtSgX1QCut9jkbfpUA1Xs2LfVahKK
 rw6DyILpc5/Lr9h+G+QWyRr9Kr7dM/Fo30knVM/EpRYNybFHD1BUAQv3WXnzq0t3BIvwcV6PSSE
 YSqDaEOez3S+NIwhm7MtWjR/rnZgXge+ZQJQOAAtbmnunJ831hPf0aglSpgmyxWxC2H8jjzz/0k
 L7fi9dF1AbJ2AVSA8oRui50DQaAnC47U/hj4mWFQQaSt19z+f6DvJRjxLsLXXz9W+ZOowomj1c2
 DXTD/vGyUf0b1rSyXeGBKwzrW3K9/Q+fkJPIrFoga4zo182t912hUw3cMgGqQ86w3PSbeb57QBS
 XXT4Eb81PymTU8OqGlf5PvWyj4T6zOwcWdTWDNMVpXZXmz+7F/5TvYKjq+UZKENLpgnA2IkGL7s
 75E1lV0MivkUMNzUlBQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270060

Now that we have fixed the data corruption and cache consistency bugs
around zeroout fallback, lets re-enable the feature.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5130416aa8b4..df3085f2fc44 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3567,9 +3567,6 @@ static struct ext4_ext_path *ext4_split_extent(handle_t *handle,
 	if (orig_err != -ENOSPC && orig_err != -EDQUOT && orig_err != -ENOMEM)
 		goto out_orig_err;
 
-	/* zeroout fallback disabled: always return the original err */
-	goto out_orig_err;
-
 	/* we can't zeroout? just return the original err */
 	if (!(split_flag & EXT4_EXT_MAY_ZEROOUT))
 		goto out_orig_err;

-- 
2.55.0

