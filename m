Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280873CE4B5;
	Tue, 23 Jun 2026 08:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203894; cv=none; b=T2QLVsAIzS7b1X9wbUhwKQAczSkUlVCY3EDOSj20lwaZUoRsqpx+UnL5zSciEv6PdMjQTnc7gsEmfS96X3G/D/WTEONLkGpRq5FHhJiDttHXkVX3WaTyEhnQEGEYA5VSvslJdrt57FxqtxubpnDVYrvW3NnMCCt81Y2iJGBQ7E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203894; c=relaxed/simple;
	bh=7qX5PxOZFCtuuEqounfZX8OvsYIKviwn8Dxc9sX/y7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o9L21+6VWSrhuw09LR0QK0jtAAGC8vFvhgZBo0w2wnWMaCk96S2wX2u6ltmDlK9RjHpIZfPglwmgwsQEtqJbd+Zf9qLOYL+hWrDawuAbL/ugXPCSfEdqQl4LWY2Z3vnNYcJTGUdq1fIdAYoau8LfZrySklmzZ3Cc3HOJ85bewC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=FKLs780X; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="FKLs780X"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6ni0u3337966;
	Tue, 23 Jun 2026 08:35:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=QJjTXBsZQ0cJpWN4Cy+e34JE0ClahDpK6gFd/pPry7I=; b=
	FKLs780XPM+GzkoOMjmIknqQIrzVIxwTFGeZ4j90TPSIwoIX0Iy/IFHdmsSMfYLO
	0uiaROkDsP96vtf9FIDD5BxcAmYe41G8P3dLwDcpM6QugXR+E8kqpvymWDFHeSBQ
	451xIyy+OS/zACy6WVPYnIZeDdWhl1ertKAALALTO3R5XTi0p+hm2CWUP6+7NGsr
	Ei4pxH99iR90kER/BqQgOKN3DshLy1hXQn3FbRIjI6iAUMSkFdVNnRaCjQRCydCR
	2HgJ3kuY94G/8RoVgCxvdEB0yoigyyH2Qvk05/RJhEShRn5A3zlAa9yTjlr+ZIet
	g/WjXGnR0kQys/HWwWDG0g==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wu7pe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 23 Jun 2026 08:35:48 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 23 Jun 2026 01:35:46 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 23 Jun 2026 01:35:44 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v9 1/4] fs: add iput_if_not_last() helper
Date: Tue, 23 Jun 2026 16:35:37 +0800
Message-ID: <20260623083540.2744885-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623083540.2744885-1-yun.zhou@windriver.com>
References: <20260623083540.2744885-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: rrHMABjFZ0xjwNBYfN1tuGFhNyImOZLB
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA2OCBTYWx0ZWRfX1jmOPNh5/Qy0
 sAce/viXPrZmBMnwiUj6GxKhelWglvvSErBiDxMrZ+nMejGTtjTnlA2OBCf6B0Sh+JAKtPXjJ+f
 DktLdtv5nyT3MyZ/JkWXJW6U9oNX1iZSMrFC14fOhENHsP95xF1S
X-Proofpoint-GUID: rrHMABjFZ0xjwNBYfN1tuGFhNyImOZLB
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a3a4564 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=vCr0if_IiwaKUNF-nsEA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA2OCBTYWx0ZWRfX8BBUXLz8oje3
 QBmqO+RJeOi/m4HlFnLMi1J2AsWSHJzHl2l80Axj35XQd/uR0CDZCNqs8eZWDqGKhENA5DouOta
 SSptSdXYlPYYYAemkha3YzFb9VhiFxjFAa9zd0CEgdD3PaM2fTHCASJD81I+2+0aKibimoYrVPJ
 cISFsEHv1F4Men+Jqszl6N+2lDvv9FUm17NiRjhe7ILajG0AJZ/8INzDASgFiYLn9N8OgH4twzI
 makLyiY+O7QzdojAoO0wVf5ckRlZRCyTncJ2gX8WJR+tDqlO/ut5lHmqyEhe+4Y1E7IBW7YHiYm
 185FgB+fmrIOUEMyNrlr5C4hligOZ8eV4v7gEtWUBYRPo+2Zs/BE2XuSRe0kHfJZtOMH+O4zK0N
 0+L/KiIbPMLEu0whNRax02g5F0M9FaENDzSPzkZTCxl6++9/itJSn4dML2I4tb9YIpGCUP6hE+A
 BqDuVyBS40gwIlgG9Jw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230068

Add a helper that drops an inode reference only if the caller does not
hold the last one.  Returns true if the reference was dropped, false
otherwise.

This is useful for filesystems that need to release inode references
in contexts where triggering final iput (and thus eviction) would be
unsafe due to lock ordering constraints.  The caller can check the
return value and defer the final iput to a safe context.

Unlike iput_not_last() which BUG_ON's if called with the last ref,
this variant is designed to be called speculatively.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6da44573ce45..4916a9d54347 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2418,6 +2418,19 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
 extern void ihold(struct inode * inode);
 extern void iput(struct inode *);
 void iput_not_last(struct inode *);
+
+/**
+ * iput_if_not_last - drop an inode reference only if it is not the last one
+ * @inode: inode to put
+ *
+ * Returns true if the reference was dropped, false if this was the last
+ * reference and the caller must arrange for final iput() in a safe context.
+ */
+static inline bool iput_if_not_last(struct inode *inode)
+{
+	return atomic_add_unless(&inode->i_count, -1, 1);
+}
+
 int inode_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
 int generic_update_time(struct inode *inode, enum fs_update_time type,
-- 
2.43.0

