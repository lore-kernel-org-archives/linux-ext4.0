Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792293;
	b=gRoI4RApkZLsGQrIyyXykL+PZsgTRcF1vAFlEDJKsgKlJdrNYFDhKzHA57Q4OnN4bW5Q
	 +Khgyvl0NuYomBBFBbqOfB2WxpUBFTF2UvZ8/Xt9YAALsVT9nt8QrjgpL65FZQlKY9Lg2
	 9K8wn4GuNoD1Nu+4Yhdfvug9WssQ+Z4nt+0N+KAiq7SY+4lfsq6xamhzPIH7Fxds3QscA
	 sXOVqKoSHfdxR7H60XycHZboEZxpdXPeNCewKbF3uQtzaYRvEh9lJUOrmkUE9+I+E3fu7
	 G9JhTWTcu9P1DyISIQA0GAwgZwFBBxS5PegNHaQXSt0Dk2th00+3Sg+fv/UfG6zqZbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792293;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=qmgCPoiLe1bkF8uoaWFVJiLz8gR4odA1E0byFhsm68c=;
	b=zP7AiahQQJch0EJz8Ln0udN1ixGre1PFVej2Shj9rgME6yAjghx97nAUwwPDtlH2F12d
	 MBz1hpyKiVes4yRAv0iUNETdOuML+f0YBRQCVBgVyZTRN41E4oXaMnUS0zdDp17qLwmmz
	 VDUlKUQA2pToZUI4izLdaBXg9FiU39v8YZqusZpX8mHruXyG9fV6hf7tjOyjdQpZoJ9fc
	 N4YTWhwM6d5CD1X/PgkAIr6bvaa1NwsjM094Ggq8qAVI4PP90B2fsInA1Wlz6rAqS/taK
	 k8i8fpCNtgVKayzYg1FhG0cSRbitAA2eNlwNVyr8969W9O+Coom6oq2lCEHvQgDbp9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=tgTCgk9L;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35747606A31C;
	Fri, 27 Nov 2026 15:11:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35747606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=tgTCgk9L
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4pta3419789;
	Fri, 27 Nov 2026 15:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qmgCPo
	iLe1bkF8uoaWFVJiLz8gR4odA1E0byFhsm68c=; b=tgTCgk9LziYTZyn7yg9OhC
	QPg9wMXNT2MQMBszFzyth6BBejbf2elGv9cB6bv45vfKfpvC6lpOgrltdHlOjDIe
	lJ8njjhowt9ofj1JyhtFE6V/mz5/tQlSCY4qOT8HBB1LuwvOxmGPR0VYINLeuJ6F
	ZW+JnB7E07l7gIMOmH+QK8lPw37DYZp37LY53Enp8eaa+t8eXFx7hM7yYhOeCBZS
	G3BviwXuH04pJO+Kt9WGi7ILEpIU0iyB2pQeeKm9QkdvHI4+z62kBaJwtGPZelXH
	hb8kykngyyyS5AjA5cepj/PSa2NM5/K/1xmS6RNFxG6wvrzpde/LtP0ZJbc8c2zA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fape7f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:20 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4Svg3245805;
	Fri, 27 Nov 2026 15:11:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5uxx9a3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:19 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBHZp36897180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:17 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7AE012004B;
	Fri, 27 Nov 2026 15:11:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5C022005A;
	Fri, 27 Nov 2026 15:11:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:13 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:48 +0530
Subject: [PATCH v2 01/13] ext4: disable zeroout fallback in
 ext4_split_extent()
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-1-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX5x7LQGMARY9K
 yTNu+tEvLRuC2lF+kWnTJ3qY5YJeMZgf0l709duI5zgV0zxj3OKHiPh9BFV0vPSzFmZ9ymqiiyI
 dwZ5ULjYpyv8+8BKdxT82g074bIkNc9iAHvuR9qcMOK2Bzsgm5QmzOtV97md++Xq+c1EMHVuXNw
 wUyf9ZmdfpzHwDUDS3GSYj3yWmdHN0QaUZJu4+iDEWCduQ0tGoAL0uba9EiyUPcn+2YvSwBmOYx
 3Zl/uP1vgDjQ0Nf4sCivmQsBuJzOxTuYMQ0tnu3c8lDXDNMvRN2G0ME/xARWGQSL0KArng7l9Kn
 ppZc0d1RLfq9g2DCRzmTrSG506+U8TwLYEyxgFAp78OyukHZ7wDrDToGhW0LsNzM3RdZ8d3CEUR
 70++IXFtA4hk6q6VfHgSITG65WarvJCo9HTpGhZsX/m4V+HNd4WiZeLPjnTAZqEK3HfgQq2WGtz
 72/NJa6TG+e7tlsw2Tg==
X-Proofpoint-ORIG-GUID: Fdj_29VKG8pphQsHgb9l-95O8xX_labH
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b099d99 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=CY3r3d1AUxzD-SLtvMAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: QaKoTSy8J9Sfac1DQkA-rGTMUHSi7RiL
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX6gOqXKXuAbcr
 mBnbRuioFodKylSTICm9BeDvxdPPCh9R6e4DqH2DskKGNAAFsgZ1EY7HPZb+P0x3tCqNT01SawN
 Ex/gHg/SBGjVNZOFAe66oY9QK1p22+w=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611270060

The zeroout fallback can race with in-flight endio conversion of unwritten
extents and zero out valid data. Just disable it for now with a plan to fix
the race and re-enable it in future patches.

Fixes: ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10d36012ade4..48c36322bbc8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3512,6 +3512,9 @@ static struct ext4_ext_path *ext4_split_extent(handle_t *handle,
 	if (orig_err != -ENOSPC && orig_err != -EDQUOT && orig_err != -ENOMEM)
 		goto out_orig_err;
 
+	/* zeroout fallback disabled: always return the original err */
+	goto out_orig_err;
+
 	/* we can't zeroout? just return the original err */
 	if (!(split_flag & EXT4_EXT_MAY_ZEROOUT))
 		goto out_orig_err;

-- 
2.55.0

