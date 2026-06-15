Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0070E3A3E98;
	Mon, 15 Jun 2026 05:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781501766; cv=none; b=dEPZs8lyw2+zpLpMzTV8da1k7MG91uEOWeLikNY3r0TrcozUGXO+iEiRCbVcAObPTvSnM/e/y04uX/Yc+pDwMv/XgoWGwr9CU0t1ujy1KfLDd7bDI9fZN4tRJmAblVGr1yQtlzJtZeNZ2yTKHhummF511XY/CVsK6MqTCk6dNQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781501766; c=relaxed/simple;
	bh=dik9hQAXyrKw2yxIH/6wkn6mflWN+lLhDyTipaPiFDk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JRi2skEBX5g7bOJlPVTEJlxBy2eorkBUzqUQ6oVEXT76AoZu3pZxV2TPAlhdC/phGot07m6nmdo7U+ItZI6NF2jFSUiZtdGYnYyxXInPOsrR/GNGJzQ/25gAPwtvf1Im//I24XyBC6VnNZ/j2NZyNuKX87nXcZy6XV570Lsilsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=q4NrMOue; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="q4NrMOue"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F4o357055090;
	Mon, 15 Jun 2026 05:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=kFlanmWQX
	nGvtK6J325lu6ziz7IlkrAxVT9Ps4nGIF4=; b=q4NrMOue7//HAEcYyA+4iXycs
	f4G/kF0f443S/Oaj3GZcxGQT+e1IZJ6ZzyisTV3hKlGUBb7EPYySQqq0tTvr2DXd
	PfdwkQquaCvKETqBN0qzehe7OsFouNTokiVw8/tfeEu1EHMBU3icfgT1ebkgfpJl
	ztHl/kP+nPSl9PPiReQ8hIgKibk3jIoPQ+VXvzgjTFQaA9BIDfVnOZxAs7TOIwQN
	j6yuyrPv5leV8sER/G1a+5rzi829C2JhP+qE4TY3vUxe6GgOfAPO71JukzIZmtPu
	rn1TtPQ4Xy29YWVxzJ5KQVg4VyG/ed0yzbRR/UJWTY3CfTwXgAHF4Rr0LPMiA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ervkp2adc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 05:35:16 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 14 Jun 2026 22:35:15 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 14 Jun 2026 22:35:12 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] ext4: validate EA inode i_nlink in ext4_xattr_inode_iget
Date: Mon, 15 Jun 2026 13:35:12 +0800
Message-ID: <20260615053512.1315992-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA1NiBTYWx0ZWRfX9AhcpYtF+KrZ
 bZN96vKZ/nWIFMhb9uDsptgOs/DExPW7zIAQN7jKBrmZBasM/p1B3rnyWtZbNTZ1XEIhKNpQy0L
 hIyyowTXq45dLYyy2kztwSGQdqs3EMgr+JBph3fqGG/ErcWV+SkdfYCbLd5ktUT4arpbqxooYK+
 b6Kphg4x0E+VHFq+gd+QT2e17e/8y6kzZSe4kWSt9dLZg467hqSRGS+SXa4BTooNHO19TCEorr3
 43JlvDYh2F67SEQgFssjklvRWhJCHescEE+ZrS0BEL9e3TmIQDREPAKF3iGU9ySL0EBtDjh0OyU
 bOqpSMHJvhVgdTZ7YxOBUJXB+mpZQs8gl9BKYTooifj5DncOSZgGZiMqv30YrezI7VyzUHG60D0
 PsYP5nLR4WcE4P5qMrj5GHPL4x7mRpsPKxW5ttvVhLTjh90xaIMQTm295mBmMPmSgTtb4BqYMe9
 4XYHg1D+G5/axaYJL+w==
X-Authority-Analysis: v=2.4 cv=BK+DalQG c=1 sm=1 tr=0 ts=6a2f8f14 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=koN9hN1cqCdmWGGOw6QA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA1NiBTYWx0ZWRfX0eYcq7vv2n6o
 BbYZvxpArYUzN1zwo9hJxqX1HX1zxx446MoPwiJQmVpaia5lQA9nOuHpXWbfFPiUDCuzDXmxQlP
 CGYYAChVne4uQ0tXAXKM3IKpHyAP2Ya/1BZCF4JL5bm8hk1yLBrL
X-Proofpoint-GUID: AjS4S4ypHD8XG3vUv5tzbeU1hUW7IYbT
X-Proofpoint-ORIG-GUID: AjS4S4ypHD8XG3vUv5tzbeU1hUW7IYbT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_01,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150056

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
v4:
 - Take I_MUTEX_XATTR before checking orphan state to safely decide
   whether to call make_bad_inode(), avoiding orphan list corruption
   if another thread is concurrently freeing the EA inode

v3:
 - Move check after Lustre branch to avoid false positives on Lustre EA inodes
 - Merge into single condition: i_nlink != 1 || !ref_count
 - Add make_bad_inode() before iput() to avoid truncation in active txn

v2:
 - Add ref_count validation to also catch i_nlink=1, ref_count=0 case

 fs/ext4/xattr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..8efd6368f956 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -464,6 +464,33 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 		inode_unlock(inode);
 	}
 
+	/*
+	 * Since this function resolves references from active xattr entries,
+	 * the EA inode must be in active state (i_nlink=1, ref_count>0).
+	 * i_nlink > 1, i_nlink == 0 (dangling reference), or ref_count == 0
+	 * (inconsistent with an active entry) all indicate corruption or
+	 * a concurrent last-reference drop.
+	 */
+	if (inode->i_nlink != 1 || !ext4_xattr_inode_get_ref(inode)) {
+		ext4_error(parent->i_sb,
+			   "EA inode %lu has unexpected i_nlink=%u ref_count=%llu",
+			   ea_ino, inode->i_nlink,
+			   ext4_xattr_inode_get_ref(inode));
+		/*
+		 * Mark rejected inode to prevent ext4_evict_inode() from
+		 * attempting truncation on a corrupted inode within an active
+		 * transaction, which could exhaust journal credits. The lock
+		 * serializes against ext4_xattr_inode_update_ref() which
+		 * does clear_nlink() + ext4_orphan_add() under the same lock.
+		 */
+		inode_lock_nested(inode, I_MUTEX_XATTR);
+		if (!ext4_inode_orphan_tracked(inode))
+			make_bad_inode(inode);
+		inode_unlock(inode);
+		iput(inode);
+		return -EFSCORRUPTED;
+	}
+
 	*ea_inode = inode;
 	return 0;
 }
-- 
2.43.0

