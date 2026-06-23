Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711C13C73EA;
	Tue, 23 Jun 2026 08:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782204811; cv=none; b=uEBbkymi/XgDFsBH6r0eBqzeRCosqwbEh/UamEnY8fVlEp8sn+YsMFVlOUqsc3n02Xcwq3QMD/Lxp0v2h/c3smQ9G1XM/nLSCUM8ZuhZ2HBCxvlGyAar3nwOnQnu2uS8bCmoa9EPXA/3il4jDKlELgLnKqvqKVtAfu4mRu4+PL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782204811; c=relaxed/simple;
	bh=7qX5PxOZFCtuuEqounfZX8OvsYIKviwn8Dxc9sX/y7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mr3SpTQdH+L+doKw6vA19+hz7GpWhR136kE/DsFUS0BLCwvopwnminh+Wr0MAYFmxHEDYnoBtxW7yaABvamentmqQHJUMv2Nk9nns+13s7TSY39ih4215A6M1s+uMdNzu6HM9uB35pzpQaeSNXa9sgQ3KfeRrA4Rv4zg+8gCv7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Y/iS1uLt; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Y/iS1uLt"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6eRMU3472458;
	Tue, 23 Jun 2026 01:52:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=QJjTXBsZQ0cJpWN4Cy+e34JE0ClahDpK6gFd/pPry7I=; b=
	Y/iS1uLtJIrxfNI9Pt6zvgr9WKZu27mmfp1M8A8fvyYgvq8860ea758okCcPC4BR
	7OoPQVeLIM83lVSJf5/NtmrZlqw8JvkH3003nujVKIWiYrHmp+DPWEgDqFnQMRHn
	5eTjdGy9ufhnvWZuqwGv+FA4t4I8jQW/OII91U3hRPqHXuN/x9ZTADVve7cygc+L
	J+fLF6vgHfdJWYfp1LTjzrhwC+Uv91Kc1yJ7qwluAj1siYxkB2XL01X4qYZ38+Nj
	5aqwVZIVpa2YSeN90BP0Bd/uUHVMe206zVMEgbEyCxURhEt2qiXMgAsguUycVr4Q
	Y22wR43MgkCSuu4JWye1Yw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4eykj1g6pe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 23 Jun 2026 01:52:50 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 23 Jun 2026 01:52:50 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 23 Jun 2026 01:52:47 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yun.zhou@windriver.com>
Subject: [PATCH v9 1/4] fs: add iput_if_not_last() helper
Date: Tue, 23 Jun 2026 16:52:40 +0800
Message-ID: <20260623085243.2816425-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623085243.2816425-1-yun.zhou@windriver.com>
References: <20260623083540.2744885-5-yun.zhou@windriver.com>
 <20260623085243.2816425-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA3MCBTYWx0ZWRfX4VJNjPEd/85z
 NdDc2b7/JEhus/3LWXXxZ2yCHD9bS6q6cHxyZpv3KEcvDbJ/IQgi/AVj93Nkx8hUlImFcTL0w6W
 21/2MgVGy+uTWDCYpdwWOEljpzUITgUdmN/p/kGLaC4d5KEyk4gp0uGGNlXTRNpfKIIl2R6XS25
 XbL6YHXxPavkR9f4UUdW2yxlVlHYFta+HYhSJchHH6X4Io5MRWYn3KtO7joIyaKjcWvpWR1dJiA
 WQD12UgOcK8NTR+N5cj3MGnoCLan0GwpWPfBPZo0xe667Q8vCy4Eo+3Nv5BLjTZBA1BLtTa5qGl
 4oQSsdlDVBp2s/P8vQ1DugiRP46mN61hvjsX6KKstKKOjGaZIUOYNtPdTaSnbdFSgPdXMIMs8yu
 NFCTy07VIJDHWT0XRKyugTXdxzQW5wRdIaE3zx1HxpIn1SnUxwiJYhEJPZqSOUvFSkyI9YtrlgQ
 ts6lvn2Pd3JQmk980gQ==
X-Proofpoint-ORIG-GUID: C4t1mSfJS5CuIlTBxdB_6furtEducsJS
X-Authority-Analysis: v=2.4 cv=JNILdcKb c=1 sm=1 tr=0 ts=6a3a4962 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=t7CeM3EgAAAA:8 a=vCr0if_IiwaKUNF-nsEA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA3MCBTYWx0ZWRfX/80U4XZ3ZGTe
 v4qa0cf6NWZrwAxmVGCb55GIBiLFRfpDG2SKKoRC/7HJ8f61wtJUQ11PXbjkp8tirQo0k690acB
 wrNpvnxMfP6g+0LUHnBIvDAipr9j/PFUHwy5w6eOSukrsGW9fAzs
X-Proofpoint-GUID: C4t1mSfJS5CuIlTBxdB_6furtEducsJS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230070

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

