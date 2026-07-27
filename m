Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E556B3F4DDC;
	Mon, 27 Jul 2026 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149749; cv=none; b=Po3G6SfVBiZ1NsHvlHFpSbvy7C7st05OUp+f5wWrJ7ob0I/44ny6igAHt7dqdAcfAFIX228YBpFrW08blbe1rF/HIaYSjoh+ivQkrgoYRa2lvm7FckFGkjlVgYcx7u0CyiB/TKO4bOfnTM2C04Jr94bcYnvdFDBa2mkgl12TQxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149749; c=relaxed/simple;
	bh=LXer5m/WWNCoO3gfrJAV8u4yta9oULW/8KKh7fEiOsA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lb+7qbOqpwkx+mNKrYT8ZX5O8/DicXlAITqwSef861d4+wDywWLzXS3KHzVurdFhCqTUzBs1q0DdMdwCo2NUzRdga33q3ssf9AZgSvYaFW3Vq8XGNc9JHstEsVBXKpDp6Xpq8mNSLG/D2g98UiryTeiLm6qxsNeY2Cpe/lgaMKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=ndzIVbEE; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="ndzIVbEE"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAQPpq696664;
	Mon, 27 Jul 2026 10:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=Pv9GSXhwvCBRWFZjomjjYf3HqQlojcMZj8MunevsbWI=; b=
	ndzIVbEEY9X1bhY3alkvVrdSUM5WUB4OgArQtd7zYIDz99AmYKdt23gIWROocdtb
	kccpQoJ+Qt+pRlDqv3KCLFwObhCCGskeS6vyjdDuIfqLd6Cy8+pB3UTmqLkrUFW0
	gYBvov7urNPYo6lsZinKidyJNbzvhV4hZhUh5WtSbVjJSxHSMzY0sxTdP6Bgj9Su
	mTPEtYAkoM7NY418F6Tr8t5RVBlkv/8dSnEV3WqvRdZmdVLsew/IEnltr589lIxD
	IAPpwntOfYeQfpGk9mftB+IDIkfkD64q+lVwqNlCJd2OTGw9v7czQfhPChnwK1iK
	s/Nl+uoexSTMJfVB97/Y4Q==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmjnft3e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 10:54:49 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:54:47 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:54:45 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 1/9] ext4: add deprecation warning for inline_data feature
Date: Mon, 27 Jul 2026 18:54:33 +0800
Message-ID: <20260727105441.3213095-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727105441.3213095-1-yun.zhou@windriver.com>
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX9lI9YhKh/U2T
 oFUlTQF+U/AChPCmdb1QdKXegryG0okKQty4T8kATOuy6UPpNYbtUDmXSr98D+gBhmk6frthbTx
 3Pg9F1QJinOnPq6csxtAdEVUHz6NSr0rTwey15Wl0iI0YQa59S2B
X-Proofpoint-ORIG-GUID: Qb32BtvHK7NEZJp8D1aZvIgB3gE0exFY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX68U2RlLjZygs
 ArACNne6BYElAWedaQJ9o0StZLsOKikKmf1SqX6Zh1DsuwYJbl/mK9G7Qw4zbMivHsgfuBJaJnG
 rdNgW2J9UTJkY+FHs4kFgbc6N4nFOyIjpb3OPhVXn8CV3MKXycJxsDHVSRtk3dySmUjzzFxP0kt
 7BHo0PFVfr5hsYZJDCeMFCii1b+1Yr4K+L/pfAfI8lkL2dYWg4jZLe46rwuP7CgQGgIGF07K8bl
 vDk0oj09lNHxKQzVP5MCDDSYpSzW1fpkXk86NF30EQ+4HdlGB/aCeQu6In9CuDKk7+uQCXQ+OgD
 2eifgD5f6FUzrVxFFPDKe+TMBZ97qKigJHlP/4S90KwfezOz8Bs/aDvk74j54tx24pngKOIHo/g
 JM7Vih04HooEaM0OvKPpEu0PlQkEBKWlHAiNxWxG6Y8iax0nsNosCrxYWXJbVoBr+3FHrUcwNef
 680qe9jLHryRNgBdvdQ==
X-Authority-Analysis: v=2.4 cv=MuRiLWae c=1 sm=1 tr=0 ts=6a6738f9 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=HKzSNcaD-M7PAaJIIN8A:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: Qb32BtvHK7NEZJp8D1aZvIgB3gE0exFY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Emit a mount-time warning when the inline_data feature is enabled,
directing users to convert their filesystems with tune2fs.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6c18b5adffca..9913e30b7040 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3145,6 +3145,12 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 		ext4_msg(sb, KERN_WARNING,
 			 "warning: checktime reached, "
 			 "running e2fsck is recommended");
+	if (ext4_has_feature_inline_data(sb))
+		ext4_msg(sb, KERN_WARNING,
+			 "warning: inline_data feature is deprecated and "
+			 "will be removed in a future kernel release. "
+			 "Use 'tune2fs -O ^inline_data' to convert.");
+
 	if (!sbi->s_journal)
 		es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
-- 
2.43.0

