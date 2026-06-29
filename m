Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7014D305667;
	Mon, 29 Jun 2026 06:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782714792; cv=none; b=IU7OBlrxjHhYtKjR0WnAsKpOqJbebSi7t5yiqU9ORsIoUO+UeATwr4UUwWnHyDCfgXggeCqsDywWVu494jjeWvR+y/7q3x4Fm/jNRoS87mss2kTSHSDQDc6pBhZNAuQxQapXtLSgEDkuXQ/hacGV48NKf76xOyxOGKiiuzzoH/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782714792; c=relaxed/simple;
	bh=Cjh2h4lvJTs1QDS1Sy/ZG/tkVo7J8Yr5csCJ4qyvjOg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y1ypjAF2lsloUxA5XXmh9jkeNymMdyXxnevYQWkrm9yllFh8O1QLT39G8NeWS7Ah0Id2JOoEITh+pKRsKI71NMyHlxqr8e04zHtzkHZjiZd+OWLuU+cLwRj4debTXJsQbPlMtY8sGg0u8TKzfay7WzKiwYjVuiZCk/JLpwHY5w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=AGBXh5lT; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="AGBXh5lT"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T5gQF02033213;
	Mon, 29 Jun 2026 06:27:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=e7QwzxIGS
	rsEoWkOalXCs0/hsEwo/krYT/+cPZYdCjI=; b=AGBXh5lTqYy4VO1i9qfxlDCgq
	Db8Dtn2aBkrjo4umgWGjR87ergo0Z6yyjsia+P+bj1YpmwiYkNhkE0fXuEApzVfU
	JojV69RmNRByVC6Jjp6F4h11rClDGudHp0JiNuhmIT1SZ+wnmHxlLkl9/haXwstb
	m+0rwEyOMd7h5Q3VwYWURgr6UJyQYrFL5Jl5UOo2XONJMf+g1Eh4ufjba0kVC3FT
	VOYubEw95VizG6X5+4EQKxN4M63cdd/yphEXxl9pNuQnSnkfZRlu33ZRGpUv3O7s
	bUkOdX7pf0OFPGsQhYXYMLz8M+8RK5QWwMfqp9/7ZHnzmZ/07nR3CtNXM6xUw==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f23r09u0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 29 Jun 2026 06:27:38 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 28 Jun 2026 23:27:37 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 28 Jun 2026 23:27:34 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v2] ext4: fix deadlock in ext4_evict_ea_inode() vs cache_find()
Date: Mon, 29 Jun 2026 14:27:33 +0800
Message-ID: <20260629062733.1788981-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DNC/JSNb c=1 sm=1 tr=0 ts=6a42105a cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=c92rfblmAAAA:8 a=t7CeM3EgAAAA:8
 a=hSkVLCK3AAAA:8 a=XvSWbZsiBRkCmCy2_jIA:9 a=DcSpbTIhAlouE1Uv7lRv:22
 a=GvGzcOZaWPEFPQC_NcjD:22 a=FdTzh2GWekK77mhwV6Dw:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-ORIG-GUID: _pXOAgcM8hQK7fJJf_sVhPSNyHKWG-52
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA1MiBTYWx0ZWRfX9IrqV6x8FlW6
 JmBvX3weAYb6NJ0K5P5kLiD/PNWXp+LYNcHMd4/ryCvkq7Er8fuFE5V3MiADRs9bwh4/EIpMgNS
 E1AbxQGlCs06vh2D6SEJdiUWEOG0e9b5gxBGlXlgA42WHsuB7thLzNeqxI0mKJzzHoT3D6oN9WP
 Jt2YvBGpc0EvKxhWlGC/4RF+5RCiySSXif5mJ5/NxluDXtl6a/cAkfNgQY92jvcZkmqiporsgAx
 RroLHxTv3gnj7nnjBYj1ufKsAszwBMTTxt3jNAga/zUZ4ksp4Xx6RgHVVqLlY6DL05oNItQcgu2
 2n8zhe8sM8OaZsxwwvdEL57qgx623tiMtOAeCO0dS4dkGv2TBEFmrQkP+5BMNH9mTMfKi8d1Pd0
 8o46m0jfppPQDHPbA+xO/U62XAjXKV58ANWXmK/lZvWNgTs0QcUcFukDZTeJOHaKBCryL0t5ogh
 zaL2GxVZBVsSff3sWeQ==
X-Proofpoint-GUID: _pXOAgcM8hQK7fJJf_sVhPSNyHKWG-52
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA1MiBTYWx0ZWRfXyErphr2V85CH
 88qxr3GEGobte44sTPBA3ghli34s3tgjzO7XRrR31TciLzGHnKM8mU/cJqTglbkuXJDcbIJcxA4
 rNfKqhDeuwGIv9Bwd2Po2X1HiEbG0KUdDIeTZkYZgGQgb2NzAU7u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290052

ext4_evict_ea_inode() calls mb_cache_entry_wait_unused() to wait for
the EA inode's mb_cache entry refcount to drop before deleting it.
This can deadlock against ext4_xattr_inode_cache_find() which holds
an mb_cache entry reference while calling ext4_iget():

  Thread A (evicting EA inode X):
    ext4_evict_ea_inode -> mb_cache_entry_wait_unused  [waits for refcnt]

  Thread B (setxattr looking for dedup):
    ext4_xattr_inode_cache_find -> mb_cache_entry_find  [holds refcnt]
      -> ext4_iget(X) -> __wait_on_freeing_inode        [waits on I_FREEING]

Thread A's eviction sets I_FREEING and then waits for the mb_cache
refcount to drop.  Thread B holds that refcount and waits for
I_FREEING to clear -- circular dependency.

Fix by making ext4_evict_ea_inode() non-blocking: try to delete the
entry once, and if it's currently in use, clear MBE_REUSABLE_B and
release it.  Clearing the reusable bit prevents future cache lookups
from finding this entry (mb_cache_entry_find skips non-reusable
entries), avoiding stale hits that could trigger spurious filesystem
errors when the inode number is later reused for a non-EA inode.

Fixes: 458aee4a6e5b ("ext4: remove EA inode entry from mbcache on inode eviction")
Reported-by: syzbot+fd5533bcd0f7343bb8ca@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd5533bcd0f7343bb8ca
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v2:
 - Clear MBE_REUSABLE_B on the in-use entry instead of just leaving it
   stale.  This prevents future cache lookups from finding the entry,
   avoiding spurious ext4_error_inode() if the inode number is later
   reallocated to a non-EA inode. [1]

[1] https://sashiko.dev/#/patchset/20260629052732.1442618-1-yun.zhou@windriver.com?part=1

 fs/ext4/xattr.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 85ad2561474b..3588fe933d5e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -471,10 +471,17 @@ void ext4_evict_ea_inode(struct inode *inode)
 
 	if (!EA_INODE_CACHE(inode))
 		return;
-	/* Wait for entry to get unused so that we can remove it */
-	while ((oe = mb_cache_entry_delete_or_get(EA_INODE_CACHE(inode),
-			ext4_xattr_inode_get_hash(inode), inode->i_ino))) {
-		mb_cache_entry_wait_unused(oe);
+	/*
+	 * Try to delete the cache entry.  If it's currently in use by
+	 * another thread (e.g. ext4_xattr_inode_cache_find), mark it
+	 * non-reusable so future lookups won't find it.  Waiting here
+	 * would deadlock if the other thread's iget is blocked on this
+	 * inode's I_FREEING.
+	 */
+	oe = mb_cache_entry_delete_or_get(EA_INODE_CACHE(inode),
+			ext4_xattr_inode_get_hash(inode), inode->i_ino);
+	if (oe) {
+		clear_bit(MBE_REUSABLE_B, &oe->e_flags);
 		mb_cache_entry_put(EA_INODE_CACHE(inode), oe);
 	}
 }
-- 
2.43.0

