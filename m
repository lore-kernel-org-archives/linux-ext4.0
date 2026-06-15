Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689622EEE77;
	Mon, 15 Jun 2026 11:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781524440; cv=none; b=HW+L+EGHZL77LMgq2EE/L6p9JwhHtf2uIxdHI0m8uh/qbw8hDrJ0NAAkC6SMUQNIpLiLDey4O8X4t71RydAGcSOPb7oaxUe3nbnr+qiunDHrcchaFNCc4rr2yA6eHpafx67hDZIk7X5r+Wnguw16d8RBpwTlpM2uWhQYHQQ7tDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781524440; c=relaxed/simple;
	bh=vXtEUyvg3lFN1w6RDPNQQESAw1IyfCV3cI8WnyPqzCo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uKqcihzJJAttx7yk1E9klXfORxAEHSEdn+xo5S+EUKjqA5gXvPK2nrIWFYPYRe0aMZlJ0ffpjrI7hWWtMd8oU9VX1W9sOrLywn+eCEnPjW7pE7OPQ4ZsbG83Jzfm5mrPJ6M+199MXw+8Y/xlMeTo2dXVxPrLd7+sJ2VQjzDBIq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=LclR4xkk; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="LclR4xkk"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FArOLV863406;
	Mon, 15 Jun 2026 04:53:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=0+ZPIQm8ZdKKVBIv6a3V8SGvplpKPGbXNlTOTRGRCJ0=; b=
	LclR4xkk2l0VsB6UPDenqOxdTSqXlvlhivev9anTsW1nejOc3/JxSbPTrfxSrH5w
	H4krnWHAOLlM0PyGzq5VkhIzSyRYqNUQXVTwP54KYTJKBYcw1t4KV6uYsjKBNRXx
	2Pe1KZ2JfEYZG7xtpTyH+uGDjLqIp7gka9jVkmMXfRbhWPq2BmlnQxNbpm24V1Ql
	/lWyLpdfGCOkA6aNvNb5DZFnRMjONrQVjnFF0luFTbXZ4Vp2YHGK+8ZRkeqouuIP
	zmN+U+6WKKC7+MQ2Xk9WGJp/wnfasPtvXMo57FLA5kTBxKotc+5+UhZcC4Imprjf
	TWl67JeZ4LEnXClpq14shw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es2g0abyk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 04:53:27 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 15 Jun 2026 04:53:27 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 15 Jun 2026 04:53:24 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 2/3] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Mon, 15 Jun 2026 19:53:16 +0800
Message-ID: <20260615115317.3549469-3-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260615115317.3549469-1-yun.zhou@windriver.com>
References: <20260615115317.3549469-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ZJ/nX37b c=1 sm=1 tr=0 ts=6a2fe7b7 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=t7CeM3EgAAAA:8 a=5t83pWKoPL1BlknkHKcA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDEyNSBTYWx0ZWRfX5DuR065TREAm
 gW+1Dy3R5vh972pYqlTQTV/fyjxh3dLuW088siUe5b7a2bAQaRyt8Tu2+R0KH4C5QQtAzeHw4yU
 0ZdvT50TKsJy/LNU8jFjEGCCc/hursnCC7t0UHYqXH6YixBD8yPjn8LFODGZCJzb2UG5AsMUmfc
 AhaJnwKAprFhWR3L1DoNoKl9hMPAoB2FmerZVQB8fkvDeR3uT9BQAN3Jp1hMWLjnbcaLkIShYvg
 xxuo5YrURnJiOceBYymz/TIJit1kQtBc2S6gDQki9JH8YZyvT5CEQvqkwBY+oPcWY+87pIsgg52
 CvDdTOoP8DaE5AAigYzOyUypi5YL3US4vJqhAwJiU9mY62WF6pADH6V9V1lH5INFEt2RsMsd/RU
 Z4Vtvs4zLvZwG2LfA+DXX1fUywWTdcgCOVM+f+sNDhTPpMocRkdk0xZbqgcHY/D5Yfv3pAeLL36
 +9MJIhkSUwQp7bg3Dpg==
X-Proofpoint-ORIG-GUID: aycmv16hpV3MwsWBuM8ctsei-CzYY5De
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDEyNSBTYWx0ZWRfXypvtT4Ll/P91
 uqpfQw1EnTGiDZWRXjXF1c3yvRUKPwhWI4+4TjFF4GpOd929Al79f6jC1gfJ8VWjzsA9xD/I4uq
 DtnQOQQOAto+MZbpUMyTeYxL10u2jgcmlsNRhSRoaVnpKaR1qEzZ
X-Proofpoint-GUID: aycmv16hpV3MwsWBuM8ctsei-CzYY5De
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_03,2026-06-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150125

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

