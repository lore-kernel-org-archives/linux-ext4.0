Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DA03ECBE3;
	Tue, 30 Jun 2026 10:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814154; cv=none; b=md8h3ZWWoUuXBkkWqZley1kmtFy5A5ZBo3mcvwIkyB9xgqf6HTG2o7AKlSOiUQ7haPebKYtSM6e2sNkBAFaHJf2rKtt139Qwftuing6LCM4usq34jEhCUjDqU2JXDeM+azFx5muzfjp7JMJJesiDkjdaffogfl2/yDOJcyzgVks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814154; c=relaxed/simple;
	bh=33PUqLBndmr7Em2HQ+fPhL0r4dS7gUCyBnlesE6JeQo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j8k5Yf6XKP7mrSKDDoFpzWuxXa1BjNQjrqT9YsvNc+Ts3VXsUe291QzVQBMr8hf7SfZAvMxwLBTzRBf/gRftXPp3b+IpY4+kmVIoK+ai//8fNk/KQSlVUs6jtKVe+jzd6z1cRKYDWl7kWOc3bozGwBztYbMInMpLoKxurWwSxO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=dfaW0G9/; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="dfaW0G9/"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U9oWth715972;
	Tue, 30 Jun 2026 03:08:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=fiopdP/EpgkRgWya9e3nhtUo0uGnjwoSrXLJZjX00m4=; b=
	dfaW0G9/DtaCxG+/twKUbYIbVn8r+RGl+TFkfjpST6xK0cwN+my3GMmzGHLiX6Yt
	OBwUGpWyld+u1x5PTRWLVjWLKx4vyWBZbn7ICDvYSrqyGndllgIao2gBxBRdbCpt
	1JfMI1tMSi09VngAPuqK+m4lbaOu2Ndh8O/KmP6bRkW/zIOhh2fwve6tLMy/a6sp
	sURMcoef5+2BA0EM5EybfxAqccRaKcuLqFjXCveoHYZ5v1OzixkcFD10qrdJzKBw
	+YRkDHgwwKs9lR4jfglIwGKt1mlJ4//WHZicypD1E0M7d2tT5EX/Kg4gvY7qYZA1
	Vvmt35A8Pu5R3XcUsJIxQg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f29sykkwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 30 Jun 2026 03:08:37 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 30 Jun 2026 03:08:36 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 30 Jun 2026 03:08:33 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v12 1/4] fs: add iput_if_not_last() helper
Date: Tue, 30 Jun 2026 18:08:26 +0800
Message-ID: <20260630100829.1257618-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630100829.1257618-1-yun.zhou@windriver.com>
References: <20260630100829.1257618-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 847kMgzQmbSQnyPpFQOLfeoZUEUUQ1Wm
X-Authority-Analysis: v=2.4 cv=HsJG3UTS c=1 sm=1 tr=0 ts=6a4395a5 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8
 a=vCr0if_IiwaKUNF-nsEA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: 847kMgzQmbSQnyPpFQOLfeoZUEUUQ1Wm
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA5MSBTYWx0ZWRfX1ob3c2rfqd2+
 UxcKJhTDuhbJO/VImJqCH52qL9QeUitV+O+IReNnbsJ1bkbZG0POxbevN4F0kCWA8/Q2JVIBrep
 aXV9E+qtSCN59aQD1xvC7NPNdz6BwDWYiN54cJnT+BNEHRkSI4EM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA5MSBTYWx0ZWRfX+ogSmW6rdTxK
 rZEKBizk91oRAAjhCaJ3X6Is8aoqXnN8a/i9Hdn9QG/ntzYR3xfwFxyLa9UzWuudOs+gAdxOJIn
 zCYZ96JzpDwWUByb9SzMwo18a6WAE72XEsOjoUC4ddQ2MT/CSgUzxqhHsqQhGULF+BdKzIJoqK/
 X+nn5vHizx8aezhahgV+MKWe9Uy6y0ghiSlCbSgvu3yfjfu4OtA6XnfKAeWjwCg3uGI/w7wQeRn
 zos25lAU+7xJmaOy6h6V5gBLbgxYUm1Wwy+4X8V6DFNETtDy6UNCGKlTCF+Sr577gamjLggMCor
 6zpJKHlJNGxYV/fC+J9my7ln4w2klEucjlgigvnFR1bpkjTkyNsB/IYF40myvnYh61KBe/VQ8IS
 h4NdmQgs8jt/0GARgyJplHJxLOlDeBRHyUuMY8JzTYkz5pv4ZSU10ff+3S0oEFyLA4vFrlRGVCY
 Q2KxZ2tMElsrTCyyDiw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300091

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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/fs.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d10897b3a1e3..04f0de78fa7a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2413,6 +2413,19 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
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
+static inline bool __must_check iput_if_not_last(struct inode *inode)
+{
+	return atomic_add_unless(&inode->i_count, -1, 1);
+}
+
 int inode_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
 int generic_update_time(struct inode *inode, enum fs_update_time type,
-- 
2.43.0

