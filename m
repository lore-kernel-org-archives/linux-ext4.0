Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644042;
	b=tht2niwA9xbL62F8sB8clGEcHm+TN4V9jjLQ9QY1dAp/0wIArteXJl3yz1WDEApXet4r
	 lmOW9GUScEy0Q1ZKhHlG4joiZgpk5z7YW1lwmR4BN8Tvursg6Ah9pRamy4nctwgwyEc+I
	 IIKc+B1/2Xk2rMMtVsHxNOaJ24yRzQd5CSzMcevW3bjfzSyObRIzk6hmrfNvKPOwegxse
	 fWvrt5XfbKNbX6adpRO4oK8H9MRSyoM05p4x9zp7swrGIR1WN56AzWlmGfkiTAtXo7OsP
	 QaGyVK9p+z8dgBbpcgD6dhYnpTcKWwX2l731fZEjbyT5xzsc3eWUQDwhVsnDbyPwlLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644042;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/0aotXz26W78JqP6F5g01mEo858p3GRxvHZN5sradXA=;
	b=wAQFosf21pWqEaTdfsHkSv2XaiuCx/793hh+HJvy7OAVl1omU5yQhk7MxLSHYpz/cqpv
	 W08XFpSmc6TtZjuzUHMy61DXs9N3om1bvuojWNUQAwh7djBGAuRBqOAM1ulE2p7GHI5TX
	 SkN+PbJXRowQKM6hG5m9fYXxOR7iyYy7u9wzF+AIqLQAq3n4LgMrRm+HTSjl+4kfkM7Ot
	 khllfcr5SgzwRniQY+ptT/5LjX4AM8/CEcJMiTIx+sRqFkCcZtTOSVWHNPQ2Ud6vOPQqa
	 G56ui3zX9OIAsJKCL4kuvt172QgX1h6ueX/ID612hAC37iIgwxD2RacL6JvEltOHMLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=IfjQXoON;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444B7606A334;
	Mon,  2 Nov 2026 18:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 444B7606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=IfjQXoON
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2Hi60E1933428;
	Mon, 2 Nov 2026 18:27:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/0aotX
	z26W78JqP6F5g01mEo858p3GRxvHZN5sradXA=; b=IfjQXoON/0R5JdrTEcTp7B
	SwRABbCOALMV6WWFBvzLWWn4R7Bq1OfndOfFxTXHExlnfXRIPnlrfqP++A/by9md
	Vc1tVqJA/X3Smh6nknchDoFAy/TVF2ZHssxlq7tH7zxiWRCXsB5zBTb8YJgm7ejR
	NUOk/y3KUrl4P9/i8bAd6EHqoxcRXrOpT2jmm4YA9QPBFFQPbCLDHXTVk1vOzmq+
	uFzI2pWvRBl2TP0DGQyt5CEs9pCvKiXjFyLDWKM0c+kgsRVnGxMi3u4q4+uVZQhY
	rb1ZQeu129nlIkmLqnJqgm6t+baL10+z9LLD+vFGBzRZ2xaLH5QsSXWALCs2QOzw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn80sj5yv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HYvS7089187;
	Mon, 2 Nov 2026 18:27:10 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hnvvfq3c4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IR9Qp49742192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:27:09 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19DB120043;
	Mon,  2 Nov 2026 18:27:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24DF620040;
	Mon,  2 Nov 2026 18:27:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:27:06 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Mon, 02 Nov 2026 23:56:21 +0530
Subject: [PATCH 6/8] ext4: make sure zero range WRITE_ZEROES uses
 NO_CONV_ACC flag
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
Message-Id: <20261102-ext4-endio-zero-bug-v1-6-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Q4jXjvtoY0OWVgE_iAaOC8Oje8__IItH
X-Proofpoint-ORIG-GUID: 73yv250hHCP7479WIaVPh5oSfxbeqxTz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfXzK2YcEuiQ+jR
 BwmMZIzRdH4mQNrHY9NBbd5ADd6xgMy5O0Zl/kSY8z1irXP0cAplsvphCvGQ8+q9SbVUER2bLPC
 JeoXnmZOejXpHLce91SZrVimb7T2QoOSDBI164sG8xdkQ3lSQZI8mFgzsbwKi+f7hLB+DQrrEVT
 ExpvsvvqhuXiFYl70wpoAxpZ1lBZLEHDu/Ljg8FI7gzp6+cVSv+Lt3fNG85yzika+aM+jTANwbn
 fmcS4Pd/bdoJP2VnlpmkiyKt0BzaddZCIH1w74b8IUZ/bxuZQ/LkHFrP2EizcCP/KC2FaID/XMe
 jbWk5VzkZBK1mEvazWn+13hPMoEY8bjdzRSTk4UqUGXjyuKwy/DRqPLxacNJv/m2H7LrauWbQWk
 POkfuEDLbXwRYNVM4i0ZxtKanU5vsFZ642u4BI+88YAbIaKPiZ9S4or5plitUesYO382WOLuq44
 dY2+xC4rMcP18g/scFA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX/CMRUH2fuihg
 0um/GnogSSmcayWZaOEd6oP6ums20bEXHYnbAGRsYAJd0rjysKuXj8LVAFws2I+gk8Kpulrokcr
 0LzFZCV1l9TadknX3YIGUSKLJCXukAc=
X-Authority-Analysis: v=2.4 cv=FIqOVOos c=1 sm=1 tr=0 ts=6ae8d600 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=xqtzGnP-aES5OxGh3-QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020072

A zero range WRITE_ZEROES splits and converts an unwrit -> written extent
but it doesn't need any protection against the zeroout fallback in
ext4_split_extent_zeroout() because it's data is just zeroes anyways.

Hence, indicate to the zeroout code that the caller doesn't account for
itself in ei->i_conv_pending_ios.

Fixes: ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e4e65f3f576d..d546001fedc6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4765,7 +4765,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 			ret = ext4_convert_unwritten_extents(handle,
 					inode, (loff_t)map.m_lblk << blkbits,
 					(loff_t)map.m_len << blkbits,
-					&converted, 0);
+					&converted, EXT4_GET_BLOCKS_NO_CONV_ACC);
 			if (ret)
 				map.m_len = converted;
 

-- 
2.55.0

