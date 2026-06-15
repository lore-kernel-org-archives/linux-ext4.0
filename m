Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F3940BCDF;
	Mon, 15 Jun 2026 16:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541072; cv=none; b=lRZRTyh0iUCOd8SE4zkiOo/hP4MEulp/0RBZ6FkKSeHvIt/BEZ8yr6k6/4rLfd1R3+k080/fFVrzAvLtCADo7xYR63wSywrVo9yxvGzzgf6+rx/WcOUOfJjxdTEawNgvYMBweHKxWGUCOZi7bwQ48jV37lXakvFnlDmEzZ0PRQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541072; c=relaxed/simple;
	bh=tL2V0Uqb/Ohk5X2Cjq49ZLAX22F5k8A6Gp37owoA0Mw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L0fE+YSnVgKm07FpPtXsC/NyV7X7M46X9x52WVCrcRoZTDyg8WrhZCDsBS2uE3XTxAcSgMdaRQ6gkCovtCsdfxgFf54Boo3S2jM52o4gYrWVE0MkkbIcqAHE9RdkHgkiSLcsIUhFBR3Bh8KmmMQ4JxYpa1PxPO+ZIX5Z9sA+ceE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=JWZTDieh; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="JWZTDieh"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFej4T1186413;
	Mon, 15 Jun 2026 16:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=9JwwIJTewOjYoSrws8qzFDhQ9NcnPXqD/cb2h88roX8=; b=
	JWZTDiehjC6cA4mqh6pdRx65t91DR23Qn4XNZe1l+rSudNfYz0tiD4+RbYqmqsBr
	WiFOH/C9p5SuRqYE04Wcco7/7Oa3gYZBlNwXrypYTCphwNhSyI08VxWEXMzp7m86
	bczTtI7hkFJcJa4W89b/VdIBoOx84ucB2LZO/wPY0X4flKsE1stJCzce7HVU/Tkn
	/4Wx5+KeS3VK1OlgIBxoKGQTrshhsYPtcA0fDxhs6A9GM0PH2dqXLHDu4YJxf98D
	qhzHhZhntl+71K0IJRziQh8eKRc1edcV8dbuXiZtpM5cEHhLyZk53Rcpgybv9kAf
	ZTJPErq1wKO7NBHBXjMLew==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ervkp34mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 16:30:46 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 15 Jun 2026 09:30:45 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 15 Jun 2026 09:30:42 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 1/3] ext4: skip extra isize expansion during mount to prevent deadlock
Date: Tue, 16 Jun 2026 00:30:36 +0800
Message-ID: <20260615163038.1223293-2-yun.zhou@windriver.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE3NCBTYWx0ZWRfXwUvMZJMkYeW8
 FFAo0qESDD+ez+8/dFcHZ3y7Nnz5/9CGjbb07XxpeUz8dMnvaTgzxAe4hC3o0CAVxsjzzu0nQJ1
 iKYpKl94bBXnz2RrTR6Z2z7kKQXEHITAz5cTMqUhQkAqURBO7bp435SfJ1Z/TMIU4FQqQuU82ix
 fLy+HWoh/OU8G1lzRXoSE8SHd2IiVzQmZfD9BgFsXVL+9OzLHXiFpWx/xIYUa1XfMCtMTlWCxO/
 vNxg1fob6r5ptoPxKNTIevWfyS57VScTohMBiIQzsGp85o1bvjZjiKvHJuFe65rpaWMKGKpw1M1
 Pj8y90/XwF6KwSGkyRsA6KyPiYNRVz4nvzw8S4GhV46vba1geO4tN4AL7mzhnFowjnH9YeKtt18
 jBVF+Cg/Q2XXExfxYEeiVlZ9s5xCEdUsob3fVoT6eJRLP5TFSJXh/1iA/nxOupDZlVonWNYy25l
 knhu37qGfOHg9utVQOA==
X-Authority-Analysis: v=2.4 cv=BK+DalQG c=1 sm=1 tr=0 ts=6a3028b6 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=nphdFjCg5VZFgBW92ZIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE3NCBTYWx0ZWRfX8py0kxbMXJ71
 0lKUIFk1aua68/kgUvoFB9OR1smtpSV8iZv2DAgoDFOdTM8wboTMQT6nVv6JOczlXAlzkheomwT
 pOsTYOE9IQV4v/tZ3BnC0VJO2ok55Ez1Pkhd2h7Yqrv85gLknQTD
X-Proofpoint-GUID: 1TXB9X8-3X697NReDZNGt0EtBpHDhlKD
X-Proofpoint-ORIG-GUID: 1TXB9X8-3X697NReDZNGt0EtBpHDhlKD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150174

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
index cd7588a3fa45..be1e3eaa4f23 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6479,6 +6479,16 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
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

