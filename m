Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD4528E0F;
	Thu, 25 Jun 2026 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782401726; cv=none; b=G1bluI2S+oqbLfZpBeQdd4DbmiFxuYhQOZ82bwWrPPIL/TadvvITpTKOt0JBN9Wh5IrqvuIyhV73BQV+SXOnjl0UGtr6tfr5MgtGmnJSK68Wk4Wi07QvEp1l79mgA3XOzcX7QWVobb7AFOW1dvagJio65i+1BKJlykR6nfgFFis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782401726; c=relaxed/simple;
	bh=7qX5PxOZFCtuuEqounfZX8OvsYIKviwn8Dxc9sX/y7k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r58QOCNeTZr/ws7q/IMvO2Yr6aZ1iHRqiZBJ4ZSOY6Bsr5ZvSrOmmN5haedVp+SLADboOs7m2L2tQafeT2UPs7asdGgnVFcBPdLsy5auDTi3gg9zqKy7TQme+RA5HxLKEL+8mLMTeicypmEOGRQIxixBndCt6AFMbDthHeeFsd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=gyFex1lr; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="gyFex1lr"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65PABeLr1019015;
	Thu, 25 Jun 2026 08:29:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=QJjTXBsZQ0cJpWN4Cy+e34JE0ClahDpK6gFd/pPry7I=; b=
	gyFex1lr0snNuR7uyyViPtZx0z4aHvK+1oWGxb1ddfBWphb3p138shG2sq+iQ0da
	5EZ2tuu3+5PtwZed3TrGQL1HE2w5knoDBNM5C9GtdNj2nttZygbII041dP6gjyDW
	SPgjg8CEQHRw44PvsByfDIhl+Vhj7INV0NSZr6OeysKqLGaMth6amXsoRbY64bDd
	+tBueiozaQS+08VkHbK98eurkeWANEELV19SVKKHW7WoJspElz62ffcJJ6dEJjUN
	wJSYLyHUaUw82/B0FKoXnSJ5rQp1kvG/erOEd3JIm/Fg98KfSSe3e4PakYehNL8t
	QdQIlLg40XUMhq9LwCwODQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f0t06gw59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 25 Jun 2026 08:29:49 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 25 Jun 2026 08:29:48 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 25 Jun 2026 08:29:45 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v10 1/5] fs: add iput_if_not_last() helper
Date: Thu, 25 Jun 2026 23:29:37 +0800
Message-ID: <20260625152941.24788-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625152941.24788-1-yun.zhou@windriver.com>
References: <20260625152941.24788-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDEzMiBTYWx0ZWRfX4sw0+Q/A3+gE
 UHEG/NCmCbuL2JUx1Rgo12j2R+lSMxDOnhLhnQObkzBl8d4iXp1+5Wwm2fZxMojhY/zJRLlqj27
 tQldthcqA4JSaR01IAUHVkwO5qsKfEdf6uwgilTI5VMySQOKPbPh
X-Proofpoint-ORIG-GUID: gozED9R3g0VzSZX_dUsTCUN1TZEzfA0v
X-Authority-Analysis: v=2.4 cv=M6t97Sws c=1 sm=1 tr=0 ts=6a3d496d cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=vCr0if_IiwaKUNF-nsEA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: gozED9R3g0VzSZX_dUsTCUN1TZEzfA0v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDEzMiBTYWx0ZWRfX48XJNz+zqV6I
 JVcLinOvGvbCB23TRhePqQLSNLDya05ySfQiDrC1S4/Qs3kzs1Nw5LPwSNpwwGR1I2C71AXdz9V
 hs4DkVTwKTe/w7kBnJW39v1gZz33AkdQFYX6vmyHlKsVmD63+XvLEFtb7HQquYSqImptWe8Ogrd
 FMMn4AMrBYOj6UHlmoE4RtCtcfL/0t+LkRxmxCX85sMnVcqbkgpcZpQ1pT82vx5dLb3uoGPAsNt
 Ah09ny8H7r5P4BjYwVHOmNYvCy+xBh9404aGKCWxBnM0NGsXDnY331Fkl3sHMvhXprfsPPCnquB
 xHaAhJEby5XJuPa/2DvahB4y1UqYqE5DSigWdMD3twI/bzyBvE7s2e3A7ue9lUFQKTz7wBSnxeq
 cHKp31qhu+6BDMM4A3sdYsK5vQpfAg0ny0OgEtz8bk4mNi+r7vLIPCfXrlGxaxwszhmQpZ1ZNkx
 onQPoB+SioQLZmfqjow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 adultscore=0 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250132

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

