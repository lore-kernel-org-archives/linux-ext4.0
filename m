Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652AF26F2B9;
	Sun, 14 Jun 2026 03:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781409331; cv=none; b=HYf0modpyefHTI5ainCqmw4D5PyU12aSLncw3WqcSJBNgDHEGFCFPjC4xZ8Pu9+xR3E6k/jleuU5PZtyTU33J33kMrxvgKUrl+51QNpi8AOO5i3mVrmCTxkW/qC+WNdh0E/5ZYLKUOwNj+6P0okb/3jVjMB0AAitUqMas1PazDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781409331; c=relaxed/simple;
	bh=W+v/edvtg5wwcSFTF9R73S1f+/fam1oej6vvv70CMK8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Yp357fOE+ZGjaEN/5RUfF7+PCba56OgyZT/Sv9V+MSU+QNJAuIueaW58yuW1dFLfL+EyUmvnXQP2nizqbe7s4dKNl0b8HKwOC1b5r0KlxjnT8kDwuNb0qTKVQ2ayCXqwapxRVHHa2SECnytPl1qcg4dJN3QmnR3aP6+roh/pzxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=q7Mp4GZe; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="q7Mp4GZe"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65E3o37k1884570;
	Sat, 13 Jun 2026 20:54:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=ZRBv62Gfa
	GFM6ZPVmRMPLyCRyLninox12W/42yIqzXA=; b=q7Mp4GZekhCyjR3bul+vorD4+
	bg1ilDW67gaQvyCVQWTQnAO9/1A71vyuyusny0rnHHrb0VTqAhQiongp5vE49McB
	DM65btzGNGMb7lAc68l4qL+/2iMpORSBDsqCIZhn2fPeVihlCResZ+X4zO+Lt5ao
	1f5qAC99CRrU1B4Cl5Dh2Rm8pxavCKKNFTkstLyXJFeWiIrIZdbn0sOLCYG7Uzag
	ICD5F7n+nU/fXtoIP1pRzg+UvGpE/n6BjBp3QLIIyUA1jpyE+oGRt6cqKJoglVsA
	Z3iXm3xUpRier2ZF2+vxsAdfR+kby+oz9ywCerti8Cqp0DmvIvA5/ByDqOwtw==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es2g08x77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 13 Jun 2026 20:54:53 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sat, 13 Jun 2026 20:54:53 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sat, 13 Jun 2026 20:54:50 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windrive.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ext4: validate EA inode i_nlink in ext4_xattr_inode_iget
Date: Sun, 14 Jun 2026 11:54:49 +0800
Message-ID: <20260614035449.235442-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ZJ/nX37b c=1 sm=1 tr=0 ts=6a2e260d cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=L5zdWEjsUepxmB3FffwA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE0MDAzMyBTYWx0ZWRfXyDhBnPh0bFxT
 gU5geQQAYdIyUQWnyW/YL377RZShiWEo7yko9CB+L56kY4UbZWMVHm0ItJgMNVYckoRwTx0Ucqx
 NCotKk4dRIbffJIT8Fu1Sv8MmtHKTP4Ipz8kzMqpiJ3xtxVwpx2PqMlLO1wkFTvW4oJVBw5iEfo
 x7k0IB0tTJLF3y3zJZLsLTfNcmtPG92t7ooHeDQdyjYADoZNBvzfAvN31WVlcNMmS86gCC6Utvu
 dwTpBr6u5EEvd70o3iXvc//GmFXOXtZl9r5CyzGErGTt1aFmnzeWXUHWAxjYJZ1fvhADyETmPnb
 XDWSiufPkwVPISKo6ve7rYWU0dMILiXC/HjGvFfZ++SP6Wsk0+R7WzbvSgS0hAS8DKLMg6s1sBM
 RY2rsoCiKpdkyfBHmeaeBvIUfxyL6XIukwEYY9tFn64NAwGoN5UiKXtqUKIFDxT8tcN44OTZ0Pa
 QrCzGc+ZTvRy9NHe6WA==
X-Proofpoint-ORIG-GUID: ThPPrOu_Qw79rOrzHrGeBF312Dwz7day
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE0MDAzMyBTYWx0ZWRfX1JcInN7Hw5Lv
 d6Ho4OXjqZzons3NQzSJwC1wwr+0fqFWpFZCSWn5llXoYOolM9cqh2IwMtSqLbKr26HzSBQupYz
 WxuGFVAkWfTfjP8EgWNSHECZq+BRosWk6vv3CywXQeefClgJhfAX
X-Proofpoint-GUID: ThPPrOu_Qw79rOrzHrGeBF312Dwz7day
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_05,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1011
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606140033

Validate EA inode state in ext4_xattr_inode_iget() to prevent
WARN_ONCE triggers in ext4_xattr_inode_update_ref() and reject
corrupted EA inodes before they can cause further damage.

When a corrupted ext4 image has an EA inode with inconsistent i_nlink
and ref_count values, the code currently allows it through and later
hits WARN_ONCE when ref_count transitions cross the 0/1 boundary.
While this is not a security or stability issue -- it only fires on
crafted filesystem images and merely prints a call trace -- it is
better handled as an early sanity check that returns -EFSCORRUPTED,
consistent with how ext4 treats other on-disk corruption.

Since ext4_xattr_inode_iget() resolves references from active xattr
entries, the target EA inode must be in active state (i_nlink=1,
ref_count>0).  Reject any inode that does not satisfy this.

Reported-by: syzbot+76916a45d2294b551fd9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76916a45d2294b551fd9
Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v3:
 - Move check after Lustre branch to avoid false positives on Lustre EA inodes
 - Merge into single condition: i_nlink != 1 || !ref_count
 - Add make_bad_inode() before iput() to avoid truncation in active txn

v2:
 - Add ref_count validation to also catch i_nlink=1, ref_count=0 case

 fs/ext4/xattr.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..77c11e4096bb 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -464,6 +464,27 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 		inode_unlock(inode);
 	}
 
+	/*
+	 * Since this function resolves references from active xattr entries,
+	 * the EA inode must be in active state (i_nlink=1, ref_count>0).
+	 * i_nlink > 1, i_nlink == 0 (dangling reference), or ref_count == 0
+	 * (inconsistent with an active entry) all indicate corruption.
+	 */
+	if (inode->i_nlink != 1 || !ext4_xattr_inode_get_ref(inode)) {
+		ext4_error(parent->i_sb,
+			   "EA inode %lu has unexpected i_nlink=%u ref_count=%llu",
+			   ea_ino, inode->i_nlink,
+			   ext4_xattr_inode_get_ref(inode));
+		/*
+		 * Mark rejected inode to prevent ext4_evict_inode() from
+		 * attempting truncation on a corrupted inode within an active
+		 * transaction, which could exhaust journal credits.
+		 */
+		make_bad_inode(inode);
+		iput(inode);
+		return -EFSCORRUPTED;
+	}
+
 	*ea_inode = inode;
 	return 0;
 }
-- 
2.43.0

