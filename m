Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9C40BCD0;
	Mon, 15 Jun 2026 16:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541075; cv=none; b=cc741NjUQAcfgb+SQgCtjYhPja8WK1yFOb35iNGErqhJYLJwuXxYmJ6kE39cugq+EG+nGyiQGTmWa4YA/tbKE8u+8nC2g5aYLyqgt6b60h05uWlBH18A+7raXFTFiOCdOzmTIWpAXR9bAZoAE/PYwLBnL9uKThWlIZXn9l+xgsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541075; c=relaxed/simple;
	bh=vXtEUyvg3lFN1w6RDPNQQESAw1IyfCV3cI8WnyPqzCo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJ47Wa7JT7rSvYohjkLijjgqENI4nXcDdunz5knSbr4c7P9X4uKshwxU/EBfeeRRg6iygyjgGmUYGupw0nsgcoE4cXRSk5zmlFeT7BfFJsWcPrYK1VF3edEz84ELKTg3M+HMlICAPTdVSMF2tEcQRzcp4bESIk3cvHxaHuhVbH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=DYDZ14pP; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="DYDZ14pP"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFf893768965;
	Mon, 15 Jun 2026 16:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=0+ZPIQm8ZdKKVBIv6a3V8SGvplpKPGbXNlTOTRGRCJ0=; b=
	DYDZ14pPrqUCU7VOdosEnzL4Qv2oT0iT03EDDG8jrr5/xbFZ41QLi+99eUXoy6vL
	LrAB+fsXgFt6Opx1vRKC/nLi37sSOkAXFF7q+2u1RMTDeYxLUsMsMNEBufOHlVad
	RSV+psKoXEhRKoIRRlLAMq/G7nwC1P/mzFKh/VCIavGVMu+DIL2m6SRP6LIYB7Dy
	1KW9kmVq7EsAAkJzU1FPA0PZ5AjfrEWI3LZVtkvxGJep/DZfaciY+suEg5+IkaCU
	UwCRkuc5o5ZZi3hE9OkWdtdt9yKiUywscz1ufRd7WgHYlb8P81SJ6nz7Ck5771kg
	5SsRjD23AVWpL0H2MCfgsw==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4erx63u180-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 16:30:49 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 15 Jun 2026 09:30:48 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 15 Jun 2026 09:30:45 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 2/3] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Tue, 16 Jun 2026 00:30:37 +0800
Message-ID: <20260615163038.1223293-3-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260615163038.1223293-1-yun.zhou@windriver.com>
References: <20260615163038.1223293-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=SvmgLvO0 c=1 sm=1 tr=0 ts=6a3028b9 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=t7CeM3EgAAAA:8 a=5t83pWKoPL1BlknkHKcA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: QE862o3ghb78eK1UwyfufgmhdQ-_1bLR
X-Proofpoint-ORIG-GUID: QE862o3ghb78eK1UwyfufgmhdQ-_1bLR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE3NCBTYWx0ZWRfX8w16g0D2Orma
 QX7QH2yHgELhaOsI4EiMJxjVycrbPJIlkH2ygAoZ9zwYILEY18UXVoSOIaYiv3pMdB6GiHSXNiC
 IujIBqH8kr9iC1aknjetYotSgz2gaJWEk5+0XyAofpZIRwqgTddOvVsNrd/K1QXxLU2BCo1V95H
 9BqPIS6V3zuV24AbOcsEF6W/peM5+5s85M4cZCjT2EsnY6t7PWgCvIzXw559EhvugrNTHZbzmwF
 +QR3JDxvhNQtfQQv/ir8UlEngG+uWYTrFcX6fAVyVzcRZjAdLTc8eonV9M5zGB5OEs/6v6llJor
 KElLcOWGYIZcBKceAe7LOgI2gv8smrwZfiS0z1HfDu8wsEnbYGlYKA9UeAtfvgQ25g7DHrocQfg
 FMptXK95RDnGwC26wKpWHu0bXFF5gsgBa3OyzoyBVtAcVPR60PNH64kKnqh927oj4H/921g8ksi
 8bTu3siOXgB5NnZzV2w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE3NCBTYWx0ZWRfXy5PET7ZsdWCn
 rgHy2KnWUW+P9xMPmyLSXYXcGtkTUhC2V/BUb02TBpVMIYsis2Ro9lzOvv51eVcE27GRFomD23u
 W7+7dPuPc9AZPSXRaeQ1vVMZOHI/sCsL/54zMzvBDKeGAKkxJMMA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150174

An inode being evicted will never need its extra isize expanded.  Set
EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
to make this explicit and prevent any unnecessary work in
ext4_try_to_expand_extra_isize().

This also provides defense-in-depth for the s_writepages_rwsem deadlock
during mount-time orphan cleanup, ensuring the expand path is blocked
for inodes under eviction regardless of how they are reached.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index be1e3eaa4f23..60c91c098fa0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -264,6 +264,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.43.0

