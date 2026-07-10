Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15C9364042;
	Fri, 10 Jul 2026 03:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783653268; cv=none; b=XjlUQqYwHS558mTgbP7opAW3EdsnwYbgqC+HM9OKTvoabk5VyyM68xqwTFMasODonTA7Qyh6t61pAKq6Ey/7X3/JfZoG6IErco///nOWP8rfjq2B5xytK7iap1k2HF193EycVDao3646SECjptS/KBe8RJz/96d85WXvDoGM0Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783653268; c=relaxed/simple;
	bh=Wx/QOvXFisSTYK6TZWMSOaJZ4tgu59e9kAIEl5Zq9do=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNj4yW46Myw8vOuuRUDoEU9YsEg8V4jan92filECtlX+eIEGmPlx5DotAZgOVl+KAEvlwP5PwK29JgYwRrtG0n03Rn/94tRpM9w5bDkQ7PTd7get8QZA0U6AurxauuoHiWtdOa7Q/ttBCu5ihmC+G4VxTBFeWQpjQCX2p/QCh0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=OiY6AXkd; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="OiY6AXkd"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66A1t3tN3753799;
	Fri, 10 Jul 2026 03:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=C8Ra/lEdlkhDbix2aNrnAVbHIhjzmCUXip2VQkyA2q0=; b=
	OiY6AXkdUK1YlLFSQkLvCE0h6Qzr2ferR7EqvbRvmvsa5Pcs4gQuyhrPIAC8RG0u
	vn+ADJASGBcNzfPgBdDykx9Erl8X7qOQp4hiuwEABUk13haDmfvAd7aLNMbWv5H0
	l+3qK1aamnCPAw5B4fWLe9b4IOqAJRSwkJCrl66MzG2L75yKkgOv+sw0TIccFbz6
	RledHlNT3On2wfqiEVuqh0Lbx/xvGVUaeYd4GIyb3PnnKiK57MjSNZb+3T3fmQZP
	t8oQA5w65LOJPVuKkTk95aq7P+Ebr6fnNe3eyRPU+7Hp8RLZczFNOjVTnl61WZaz
	rPIT8f1tFx3UeoeQqWGnTA==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fa1aqa18h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 10 Jul 2026 03:09:00 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 9 Jul 2026 20:08:59 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 9 Jul 2026 20:08:56 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v14 1/4] fs: add iput_if_not_last() helper
Date: Fri, 10 Jul 2026 11:08:48 +0800
Message-ID: <20260710030851.2791589-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710030851.2791589-1-yun.zhou@windriver.com>
References: <20260710030851.2791589-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nSpXEtNkB3wel51yIOraLY5MbPCqk2Qe
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDAyNiBTYWx0ZWRfXzml8HkWzX7bE
 fJGkvhgXBQ0ROhMviIB3WihdavlbttE0fsdJbMIpoTyzDoL10NNgBQPMZBk9lBy3WV0Z3FfB7yL
 MaNrXpI8h4hgOZBNBK5mf0V7iLfwGGvCk8lHSwtBfwlUUtzdfrvY
X-Authority-Analysis: v=2.4 cv=XIkAjwhE c=1 sm=1 tr=0 ts=6a50624c cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=vCr0if_IiwaKUNF-nsEA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: nSpXEtNkB3wel51yIOraLY5MbPCqk2Qe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDAyNiBTYWx0ZWRfX+rZ/jgQQCK95
 DBlcuZAA5xviyyDGghNAwSrOuzCM0MAz/NFlTHoq3Dx8bFx/3GIbcbZkJ8cDDLbBsWIZuYVwQTD
 3y7duNcw5vN2JYJr7UYsU8iIRAFvpJqjjxNCYwUl/VRdM+6y10ReKjo/mCn+FXZOL4B2d0NBC2D
 RQVHvHTVVHHBFcaTIaiTujiz5WcR1V9Cq37RDuvowJFXI5ezgUFGI2gQzVny2f5PjoHpPeMV7n6
 VIv55LInGc5uuQK4YCzglyQyylEzZPY07iOv/yuFtbdKZhB3sxwh7lQ2YPAXUJoUyL0c8+jtuyX
 0JWGKhSdjgK1JlI9a7CFye2q9Cx9l1Uzdbv37F0XRmuqbIrMiPddDi8qsgsqo5ZRQIeIm2VaDe2
 j0uEhlT+mp5LfWgkvhMrtKiUM2s9EDx8iQE8yi7Ejl97hLQzrIEfSNhI4bj17E8jN8b6CABxpeW
 hTcy/YKOlERBWmcI78w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_04,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607100026

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
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/fs.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d10897b3a1e3..709519617c7a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2413,6 +2413,21 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
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
+	VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
+	VFS_BUG_ON_INODE(icount_read_once(inode) < 1, inode);
+	return atomic_add_unless(&inode->i_count, -1, 1);
+}
+
 int inode_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
 int generic_update_time(struct inode *inode, enum fs_update_time type,
-- 
2.43.0

