Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750892;
	b=cyjLleJ2AhcjFd2gaMpZ6EXC0UXYAJaBzGlkrZXy/YnVflwbMf1GctW8wad/NwKKfeee
	 YI18VuZqZlbP6f4uCCz2eRFoWMt5mCbCImmwEb/52/yejLN1ruk7p1HyS6BL8SAMO47M4
	 QdPYlCYcmVwDYeS5hNy6Aco7rjGu/+D7eQFk8/Kd9+ZJXDMTqSuu4HyMh4OSp8BP4kVWM
	 MDnY+wopcbdhxYgRnWPm4mO8mXwAKudwNE7L2LCXgcUesqys288CKDn2uSnpvn7IhB+C8
	 vUWhi5EVgiJ7sfrQUYOfCH/tk79ej0yhzVTpr1/da3nPoUH/Rk3zBXGYobpHZ/eY43g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750892;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=rPPJB9loT0Wtb3chvJCPPmg+5VgZ6rc04nKglwRnLTo=;
	b=mb9aEWMJ979R0KrfeIddLSjb/Oe5Tqc9i6Ea9unqifWZjlDysNpcvLloMnJhbOhtdTX0
	 KV3mEtQSs1WDXD3ZC/gJRb9WgOcihdELqGkrc75nUhmkzBGHbr88fX5qvhp9jCow52bjT
	 /RcdIA7rjktrSG/5fhnA2kkg13rxcnqThEc8JeLdDoSOsfGKSuejUx7nu4bnQAOV2KdoE
	 tG/+NR0imxHDQa5qgzf9c3LqNraIoSt3PBiylQ4rl3ODRBA3H2UtgwXuTeZClQzXHvMTg
	 BvqeMf7lolK+mg28FGvTW9LsxailGend9PMlu/+VxBqNSzfBpoGUPcZVXBe4ISpbnEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="SEB/IYoq";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6627C606A31B;
	Fri, 23 Oct 2026 10:21:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6627C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=SEB/IYoq
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAECC11465918;
	Fri, 23 Oct 2026 10:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=rPPJB9loT0Wtb3chvJCPPmg+5VgZ
	6rc04nKglwRnLTo=; b=SEB/IYoq6S9n5JyYANkzjwL1kIyzcDoz5YXeSIdb1xk/
	02+RKo0lnreqLRjvcS6n2kXqcM3jDTdZi29zFJD4/4ntaLQX7/yMRYBsra6+ca9v
	RnvEW49TWN0G4CLpCreT3ZmQ/Dz60ERY7CPmCJRqjb1DXmhQt3duNmSA60GVb7/3
	pTA4Kvxzjq1q7Qvpx4rEvKOMa0xcKpZyAGd2abCxw2IKeqKEtDcKZJY3D5CCEoD2
	r8ZYjX7Ja8cNV+aTcEh5VRCqwAvHFGApfhtgNhNhcDSVlDX4ArG+ydl26P4LAfM8
	AkBCqjoQZMTOvLn/6Y5eI5mZF4C4ofkNr60eWMnsHA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw58kvta-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 10:21:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAJxa72008284;
	Fri, 23 Oct 2026 10:21:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hfmpn41b4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 10:21:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69NALBfk45089170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Oct 2026 10:21:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 589D320063;
	Fri, 23 Oct 2026 10:21:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 815422005A;
	Fri, 23 Oct 2026 10:21:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.15])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 Oct 2026 10:21:07 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 23 Oct 2026 15:53:45 +0530
Subject: [PATCH] ext4: return -EINVAL on hole in
 ext4_convert_unwritten_extents_atomic()
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
Message-Id: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqDMBBFryKz7oBJRWivIi7G5KuzaFISKQHx7
 g7dPHg8/j+poigqvbuTCn5aNScT9+go7JI2sEZz8r0fXe+fjHYMLEf+aGCkqJlXbbwM/IKDRKM
 EIZt/C6z8r6f5um6XGE3YagAAAA==
X-Change-ID: 20261023-ext4-atomic-endio-fix-b4-9e1ead9e1aca
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX8bOdthKUefl+
 u5zV/nk2kfkgKzoZttEnKtxdtc13BX1yP6yssyGjIO7RDeZxTLbNhO1m1mgZAT40dS6gzL5SZrc
 8EcsAS7Sm+nPDE4ewCMD153EQbCdFAg=
X-Proofpoint-GUID: PC6XiTfKpINoqA8bMJYOZ5VCLz6MsBTc
X-Proofpoint-ORIG-GUID: Zmlo_W_MO11WYjmJuAxRYCa5M0gOLIbr
X-Authority-Analysis: v=2.4 cv=UOBIjyfy c=1 sm=1 tr=0 ts=6adb351a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=Qgodh-6GP45rOP8ZG-IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX0w9CYbUVznkv
 HI2i2s8SAP7WOStHbI1AUYIfTBQP4jc0aeEbyB6joQFiTvIm2n0pGG5X7PC5lbWIW4wlTU+rsrP
 q2alDZJ6RRn/Otd2zs4UzF/3Orw+BTEE32hjOkJmsUQMg1pMv2GqlQkaiYOmsd9PvpeFlbNWHJO
 lm6SHYXx4D9VQ9WsTETtV4pPWVkUX3njRYmbVZP501bBzC/pwEtmdMNwrATFpJFV5X8w8KLzd3b
 CtjX2HUHn9IUok9WT2lGo5P56lfvLDgWesysT1Pl1YJA1FPqYDy/ZZeHrQXRqtP4WQERTXh+WF4
 T1LmSXAwCcn91MZbZ/y5lYluqcNW08hYIvICGBBdqEBmlI6Q36jHFCgAb+aQDlLtLPG34zunROj
 Ojrg5N/e6VaHAhnoeL117/q2hrnunYV6G/LyR8kMhxUj8Gr1f/DT/TlRVp2ybtazTIaLfaBqCl9
 v8UVtxLezK8r0EoSpbA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230039

We should ideally never encounter a hole during the endio conversion as
that indicates something is wrong with our extent handling. Still if we do
find a hole at atomic write endio, ext4_map_blocks() returns 0 which would
be returned back to callers by ext4_convert_unwritten_extents_atomic().
This can be wrongly interpreted as a success. Fix this by bailing out with
-EINVAL instead.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7193429a05e1..b54d8227786b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5107,6 +5107,14 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
 		map.m_lblk += ret;
 		map.m_len = (max_blocks -= ret);
 		ret = ext4_map_blocks(handle, inode, &map, flags);
+		if (ret == 0) {
+			ext4_msg(inode->i_sb, KERN_ERR,
+				 "inode #%llu: block %u: len %u: "
+				 "hole found while converting extents for atomic write",
+				 inode->i_ino, map.m_lblk, map.m_len);
+			ret = -EINVAL;
+			break;
+		}
 		if (ret != max_blocks)
 			ext4_msg(inode->i_sb, KERN_INFO,
 				     "inode #%llu: block %u: len %u: "

---
base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
change-id: 20261023-ext4-atomic-endio-fix-b4-9e1ead9e1aca

Best regards,
-- 
Ojaswin Mujoo <ojaswin@linux.ibm.com>

