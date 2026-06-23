Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5C3368D6D;
	Tue, 23 Jun 2026 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782195581; cv=none; b=pkoCetv7HzKoTsY3s7CRtLo+Nvn3Si9Z40pDBW3WyL56WCoOFDNVwwVlfO2IUoNq5x7cdOum85Ijc05O78/rJc+FnDwF9wMLHFVMxDaQRWi4AACnYAh+2dw5Q3jS2ILHTHPq7Ko7OiI7ZiZ+ZVoxukd15QSZgBrl7l7+bcB7Xn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782195581; c=relaxed/simple;
	bh=2jQUE3KpSfqAGwpQ+5+aQuMdDxmb23Zu/LwKrqoPkwg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KzKJhoYrqdMvS4DmAf2mF4rcO64qeBTdULrfmdq533Or0ZMotbzq6NuXqPErKHvgoFhUxQsNHFwSfNYbQFqPD2jxo/Aa5T9Jd8SfWXaE4BaUbCvxut5o1BqFDTcR4/7TxaiazFHbAUjpOdt7VPiHZYqbi5maX5zOGFG6ywNsRe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Ep4aCgNF; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Ep4aCgNF"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N5M9uT3183232;
	Tue, 23 Jun 2026 06:19:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=vx+tI7uQ2
	VfiVL7itldP9YRrLxcYgwitIq617k7CFBE=; b=Ep4aCgNFr/26sjB3syBArR9JC
	UBEtSy6471LDibXFNcl80hPSXnkEOK8xKoU1TvttUcsN8oI00tsIhfmD3mwrtWEc
	Ovg0AHxmr/+qaQCM+ZhoTLoTQimkwm9kG+kUrglpixzPMJptDtafLmMuaMVOxjaH
	hx8u1hwrXRwH3BXLX8TRBlmSQkHnIhyDuc8PrQTphpG2tzzHSX08g/eu1ziBgsUv
	Y8v2GZIzXnDMmFxoF0RpStwCc/vqjgHpNHoizzLDxWCPAp6aE2K53gXITD7UQ8er
	SvkhARu/eg+IoCCzUU5Wkg9FUAnCnxUJJJV5PJ5B2kpoHqtEtFZ8UX240qH9A==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wu3j7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 23 Jun 2026 06:19:07 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 22 Jun 2026 23:19:06 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 22 Jun 2026 23:19:03 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH 1/2] ext4: skip extra isize expansion during mount to prevent deadlock
Date: Tue, 23 Jun 2026 14:19:02 +0800
Message-ID: <20260623061903.2148767-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: N99fnzOAct-FscLW7IWtPxDsaPQcDq39
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA0OCBTYWx0ZWRfX0oirbX2WFCD2
 crUa5MqUOL1Vy1G7+PynQ4NJfcXGZBFVQzBtRY8KaW3kX5iC1FfthC2OBSa7+h5Nbqi4nihgeWI
 J6S0KRX8AORKoBA9q4pQ+viMePJx7mfqEb1r2Xd+GEI884H6iTZr
X-Proofpoint-GUID: N99fnzOAct-FscLW7IWtPxDsaPQcDq39
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a3a255b cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=nphdFjCg5VZFgBW92ZIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA0OCBTYWx0ZWRfX5VbJs9Q3N4nN
 2Q4Vdh/CfBSdRJW1umWFSEWr1N8sqqDdedpJcYIKm7N6MUsPHD3nSglygECg++jVOAh2pacamIs
 23zQOzEogZVFkTgVeTGssc5x7gTm5c+M24ARreQJxFvKRdGUVK715t3zAStPSDWvq5APA28lLXw
 oB8qgO2gDpISe3MqrM+08b0K5bKKOt2slBUqJpnqfZKAQbLhKYwOUChtSz/WloKDfZzKj24L2KL
 Vl+sSRri2SDPjbExL+Xhu4gWxgJU8uVsmN+QBf6vFtll3lqn6PZSQ5etdjNbbIi+2Uf6hkETp/y
 39y5mbmZdO41VokMv8VhsIAbdzjaUo5wf0Uyt99k7mDPgm17Wkmx7GcWha5DC25z8x+f7yVvaxc
 loQ7sG3dDElFk1gx6YcTbBM9pvgilLesVwYZo0mmmzhEg/4WatnIAB/1BewqLMLIqxpYQOSUFPs
 V3tk7oixW+1pJZM5j8w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230048

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
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..a5409324d965 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6510,6 +6510,16 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
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

