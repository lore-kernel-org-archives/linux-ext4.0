Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6569143DA2C;
	Tue, 16 Jun 2026 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622997; cv=none; b=Z2v56XiJXAi1bKvYeQgAL2be9mrW2LO2djDK8prTaLiptr1zOohvamnjKeehuQ/8I3eK7dFuI2X8aaMGl/haY+mJiEuicJ9YJ0ZBaWB0kCN9Kq8jUmgk5PU5+DVC6FOPLmxV1JA0OMDfbhEEExMSsoXySkugc2Gak+3JgrbHyYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622997; c=relaxed/simple;
	bh=btcPOL11/6PwI6Xh5BaZ4t7EPYNrRosYLjDTOTuUDcs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=noT9hv8TnjFhK2G5TJmP5RJO3zaLxFzX4wI6xJl5obPUe8LHq9ssDpD7qGzo56bynJ3FSCbWZPQR+cw1Ko8XS7lHa6qerahW8fUGQP4GTKkMviRBb6qTscf2RDfT/mxeA1F0wr18NSiBRvfQS81TIqL+3Gf94B8YjNUUxsZ7VEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Vh6RcM15; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Vh6RcM15"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GDtjTn3673289;
	Tue, 16 Jun 2026 08:16:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=tHyfyrKHzd+Dp7VYXJYS9zJwzbB5urqMS/0px7AC0yg=; b=
	Vh6RcM15t0RTheFvI1Jhh1aNx5ojmxQuT7TZFG+y3QQuouumOWQUnZOVQ7v/sPba
	LkGqTxiA/WOTVa1YfZTJLioTVfNSCVpNcc9UHTepfb9e+ylvm15TVDuYmW+jWCse
	/dSkQOrLT6Y+pTJnnx3l2wQE+xnDUp7+1qQzcyY0YJhAEKPBn4QbaPFyUaz9xBaA
	HMCd1RPWbfQd3K+LcMjUz2AzyIjshrzvIxUhJK+YQCvZJPrJlzhVYb7lQbiJKbRE
	CFHGHURsqzDoTI2sQRxMlqNWWoSpW9dp/6x/IKgZLZ+oEkW82Q10VAsyDcBmi9WR
	v/x5OOtYiUdK1MjAR7QF2Q==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es2g0cpky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 16 Jun 2026 08:16:04 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 16 Jun 2026 08:16:03 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 16 Jun 2026 08:16:01 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v7 1/4] ext4: skip extra isize expansion during mount to prevent deadlock
Date: Tue, 16 Jun 2026 23:15:55 +0800
Message-ID: <20260616151558.1728881-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616151558.1728881-1-yun.zhou@windriver.com>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ZJ/nX37b c=1 sm=1 tr=0 ts=6a3168b4 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=nphdFjCg5VZFgBW92ZIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfX1Kloq7JrggdF
 00dSE+wtaaoJa1VIZbvpmxOWnJumy/Bl4jH92ZAH7nlvqJUgoqj5768Z3Vs6CBq2IGi0c+9iMWK
 E1+J2JV5nLfqUkCrvgw98NVxLwovEwXjUqCxWBWtUYq/FkAVUiZqoor6IvQ90elWrDQkmcf7G2E
 Vuk9cOTdSUYc7sc8rmJZLOzpJ5rdUoFfTM3efb8ExeX71yjbk4fQQZ1k9RQMvvYNnz/gNamwQta
 3CVXmA1llyn+027QaWQY/okIwy27jW3ZNdOlg+ANcjp7vqw5M4TSDJBEWh6z8zbtNfRxH+5vN5I
 Rxtk+P3WijXBkdDGKVUUMNhv+zwKyBO3OOCYLi6tuPqN4wzXtI4jFKHLx7vpDkCm/+WpGkDYEHU
 PN1tcJjucuB1hN1vCcellzfvWYWXsybtvYZL9wDITNRZS6Al3ePq74SeBbw+gr/B0XJOe50Dh6E
 W90PiaRj2+VQsEI10Lg==
X-Proofpoint-ORIG-GUID: EVwtXwwYYb3C1sa4IMc2ixTLrOGQCFvb
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfX+fuFxKrEz5gi
 b6fSyGoxOZovBYJzJckextEonDjchxIZ57sYEGYj5mKrndQnoLKdV0U5I4zFlJi2ejX4fvXdUD1
 AVvUq73RGAQdCicGRpRUTDPqV3savWwpPZnfBHj8ZnoUoxQVIwaT
X-Proofpoint-GUID: EVwtXwwYYb3C1sa4IMc2ixTLrOGQCFvb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606160156

ext4_try_to_expand_extra_isize() is called from __ext4_mark_inode_dirty()
while holding an active jbd2 handle.  During mount (!SB_ACTIVE), the
expand path may move xattrs to external blocks and release ea_inodes via
iput().  When !SB_ACTIVE, iput() calls write_inode_now() which acquires
s_writepages_rwsem, creating a circular lock dependency:

  s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem

This can be triggered via:

  ext4_process_orphan() -> ext4_truncate() -> ext4_mark_inode_dirty()
    -> ext4_try_to_expand_extra_isize()

or:

  ext4_evict_inode() -> ext4_mark_inode_dirty()
    -> ext4_try_to_expand_extra_isize()

Skip expansion when !SB_ACTIVE.  This is a minor loss of functionality
(extra isize won't grow for these inodes during mount), which e2fsck
can resolve later if needed.

Reported-by: syzbot+5d19358d7eb30ffb0cc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..09dcfb6bf48c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6458,6 +6458,16 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
 		return -EOVERFLOW;
 
+	/*
+	 * Skip expansion during mount (!SB_ACTIVE).  Expanding extra isize
+	 * may move xattrs to external blocks and release ea_inodes via iput.
+	 * When !SB_ACTIVE, iput triggers write_inode_now() which acquires
+	 * s_writepages_rwsem, causing a deadlock with the caller's active
+	 * jbd2 handle (lock order: s_writepages_rwsem -> jbd2_handle).
+	 */
+	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE)))
+		return -EBUSY;
+
 	/*
 	 * In nojournal mode, we can immediately attempt to expand
 	 * the inode.  When journaled, we first need to obtain extra
-- 
2.43.0

