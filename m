Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792327;
	b=XKoBASDpec/0kJ0Joazj2BNAJQ3ZjDZIc2PUi0mZQtK5RSuZ0QfhxCVcl6ACxn5tYH/1
	 9JAS8kE4P5MQPtUcOPII/gHkMTg2lM+csQNFNXGL5QsOePCJmg5vJtBSsy3pNdwU4zoXC
	 WJAtFiPWV8YWQ5ybJ28f76buE+GSvT9HDDCqdIjd421SAfV5v/vAJXvDZHG3ee6DCMO4B
	 EM4+YgW9m9ejlA5ttZJGyUg3TS9qG3yET1iabYPbqHGHi6oS2G/kw/PvYvN0rRIhoRCX0
	 UW7sMJNib0GlActB+hTlQ+zIqtQ4Eu5x/87wNDkg0qg4PoPlyd84+WcMD+7riFnYz4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792327;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=/PEswDLIfIODl9CHNJ+djPs3J7u8hUthX7P67wZXIr8=;
	b=kksYnLG6QTHzN23tu+J1snid7j+JQHF2gCVLhfoFV7plrIJvYlB3E5mNGgG4tpoVnpHE
	 YvEPcncuUsQG6SiJpdX9VcGVlRI02lXUuCrkzVl2KySpcCD6mtlAubEhOLnN1SWHhfvHk
	 4IslF4e8WrveY23X530YjhmUaTyQCrLyOxmIOb29P1vqX/VCKEw0RI2i3eJvm0Emwdihf
	 m8N9FmEAPEQkgAiY6RUCyI1SRgYmBozZ8yGsPHJEY+z3FSNMKVUNxPUgB2qUUB92Hq2sM
	 na3MBft+Ta6h3xUFiRJuTtnLaMXDO/36WGkRiT/wjmm2V7JHX/qLo0Dpos98IKQME/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qWTrdOJV;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E92606A69D;
	Fri, 27 Nov 2026 15:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2E92606A69D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=qWTrdOJV
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE58Gd3420095;
	Fri, 27 Nov 2026 15:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/PEswD
	LIfIODl9CHNJ+djPs3J7u8hUthX7P67wZXIr8=; b=qWTrdOJVS1KfE/iNcFT2S8
	WVbBbJvUO7tVB/N8oLKSZf8QPcg7TCOx00AJduXYlQJst63ifwFENhc7XKWKtlAo
	XJ/OBl6lAHW0bemjvWtnw8YLTYrWzidxpQPDJR33aZJF/kt4N7hLIdF8ab1XLDei
	PX9M9QfXSoNnU4uEsbwqSwy9yVjC+htu77lo+y7aRbYe7mG5x1v4/rWxPrqmtJhK
	/ZnAgCbEuZS+eqaYiHE1+gO0wr4gfl3PCpUCy32XxAMKlrD37FRXdK/eL7KIbdzX
	kadYDPxHRrpryGX7OnNRDD5m+wjPY0qxKCsGik2FRnLXGKk/UFfPVuMwZVUh7KuQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fape9j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4ELu1180971;
	Fri, 27 Nov 2026 15:11:56 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6rhckqd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:56 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBsaS44302640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9BF820043;
	Fri, 27 Nov 2026 15:11:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EE8F20040;
	Fri, 27 Nov 2026 15:11:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:51 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Fri, 27 Nov 2026 20:40:59 +0530
Subject: [PATCH v2 12/13] ext4: don't drop the extents in case extent split
 fails
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
Message-Id: <20261127-ext4-endio-zero-bug-v2-12-4106968e4d15@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX1lAzvakL/D1E
 FrsQ3fgal5nhTeiIP6dS5fpcL4EMa3gL2pUkoeq0OSDDASJ1v9gnpesuYGjnKozEOWIwWywoFF7
 WPrfR7YKv2PbaR4vSa1fCd1LXT9IMftBQxHCGNuh0k1OAMpVRfqJl5sRHAhCylafBnQ4TvVdu91
 92i4hTmUCk2Eq8EAOjmX1J5tklGxiksfyAdE+7vvFn15ODGPSC7l4+7nFfNJ6OnfJl+vlCY2lyX
 1MFMySW1QjrJ58RCw6IJ0OdCv8PJ6b2FnMLzdtrV6+sSuTDbf+uBYOhqVaW5Wa4Bbg5MCsbslC3
 +gWqWvnRDfX9bLQC6prSMs2cqMDSlzI3HDv2awgoPyfS5cKj62Y3T6d77bdk/CHlXPvSQTE36ff
 sz07PEgcowjDyCeF+V7aHljbBQOU/TyS6Od39u9bRLdwmaCU0wyTiHVdrHx1lxPsTy14NR7lUng
 SQciF+93akqYspoV+eg==
X-Proofpoint-ORIG-GUID: vs-vG95TeqnFUjttzTQ_NjHHEuujgwg1
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b099dbd cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=KA9uU_c6iAvouP-DfZ4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: u0CCviw-vmzlEVCBc4h3R6AzmoRrTpKw
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfXzOye/pwIOr6L
 4IoHz9X1heNDC9xG2MZrYNq9wEmDnZZxjmyPiBmYFozLNDobPM3B0S/x8Y54ir+cWJ12+e3EHXl
 H2LK8pnPL3D5xwsQKnp7YJUMpiBVxVA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611270060

This was originally added in [1] to avoid leaving stale extents in
cache when the zeroout operation failed. Now, with the recent refactoring
and fixes, this issue no longer exists as the callers handle the split
error correctly and make sure to update the es cache once zeroout and
convertsion is successfully complete.

In fact, we NEED the extent status cache here to exist because we don't
want to drop the CONVERT_PENDING extent entries, as they are used in making
zeroout decision.

Hence, don't drop the extent status cache if we run into an error while
splitting

[1] 6d882ea3b093 ("ext4: drop extent cache after doing PARTIAL_VALID1 zeroout")

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/extents.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e8ebc518e58b..5130416aa8b4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3325,9 +3325,6 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 		path = err ? ERR_PTR(err) : ERR_PTR(insert_err);
 	}
 out_path:
-	if (IS_ERR(path))
-		/* Remove all remaining potentially stale extents. */
-		ext4_es_remove_extent(inode, ee_block, ee_len);
 	ext4_ext_show_leaf(inode, path);
 	return path;
 }

-- 
2.55.0

