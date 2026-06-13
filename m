Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C9B25B0BD;
	Sat, 13 Jun 2026 14:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781360110; cv=none; b=eLsNfkCw3FIZ/K0FBJ+/xM14nsZ4FqXeCtpe0CSIRdqRqdtPkXzWR2HozzTsZG2H7PcR8i3pXuh/yDOVFcruErMfADsbYjGAvCbvJjs77PuKsHX8zFn0Pe/JW9zrYjumIuaJjrfbNZqNJzJRYsAEm1iNdYff/jvo7GZ2pYAQwvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781360110; c=relaxed/simple;
	bh=KRRSKX33DAlwmch6R0Bhx1NkJl6QQSW9znK9ao/DBEU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PVCGOGwX3AWgRbG6xTxeKFIAJ/YlCL7bpBzJpVW25tnFLG7OBvXMrsM1++udkjQ5b+lIxK9JOBs6X1MCLYZIxRpapfykmAhA8OlOvnigT//+dKVx+7Szy2o0JI2rFm1zlu/hYcqPr2rwScWrd13oJPZQtu79DhFNckNr/NbTs+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=sb6uWjvO; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="sb6uWjvO"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DEEU604118511;
	Sat, 13 Jun 2026 14:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=FknHwe2pM
	dg8Hk/IscC+yb9Tnp+rGXV3fO00shQLWz8=; b=sb6uWjvOZefzgTjhdUhz+n+j6
	ARSX6D9B9pGzH//o5wzzvQTU4Hch2QG/2s5vTbgcbTagHKeV1Yj2NS7rEjTOXs1B
	3kXHw74qeC6JiEBFRcIW4ucSpPlgV8EVUpMz2u6RoKFECkLRqhc27zXUwg2OH1yO
	iyzlx4YhI4V4Bj3tTS5uK/MogylFigw3+GT6M0YtYPl5N5Guzix1ATGJIRfsNl8O
	tiXFzqm8hdo8Oyv9lGe6oGD0SKrn4a8+51klxdsBUg6Bq6Dj+AMg0LOvQcOIxNtU
	IWcblMOHAc6Mh6QEuPYNgX/mgPVWpzHvGppBlmn0E1rx2ec5csYOBGuGZS9rw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4erx63rgy5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 13 Jun 2026 14:14:29 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sat, 13 Jun 2026 07:14:27 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sat, 13 Jun 2026 07:14:24 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ext4: validate EA inode i_nlink in ext4_xattr_inode_iget
Date: Sat, 13 Jun 2026 22:14:24 +0800
Message-ID: <20260613141424.3871984-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=SvmgLvO0 c=1 sm=1 tr=0 ts=6a2d65c5 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=HEtmIkWGiS16Wf9jDpIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: ujuq4j247sHlGmI4VwczM4oOlrY4uHBv
X-Proofpoint-ORIG-GUID: ujuq4j247sHlGmI4VwczM4oOlrY4uHBv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE0NyBTYWx0ZWRfX1Clx4+xIxTED
 6pBtaaKnEuTrdSugmKULuoVkc2zz5wf+W0NQk4WouHVr3h65D24wCgRYjmyhEPmBHHymn2gHQkv
 TpL69u80EQBspTYs+3PgrkaX7hZEoqly/cSSD+cJd+2UwfHlA497ETyi1PKR1U+Hb28prI20T4E
 Zr1TPiCtOR5nLJQR4iQA7Ug2Th80gKUAtUtkixwy0N+0NNTiCOHZItlv88iFiVGLwfpY+7yeHJa
 swBFyXO28r/UyqEkyGVttzfJLtKx0V3F5E+z1qzV7nVJAu3GVXrdliH1xtm+mbZQLz3w3hsq48h
 1gcaSYaXBJLx7O2q/EFTg4T5GSYrJpxUs2hnj1b2SGYJhyUKLIPO4C8fEmy9Bs87cfOdOdB8DQZ
 CusZJpAAANt9IINc9Ca5PfdP6P28PEgLb1Oirzlu1U4GZ8PCBk/uHht7bPXuZ3PcvLwK/W2Pfnf
 YlePWpYvV3Ctm1VJxww==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE0NyBTYWx0ZWRfX3Ii1wDrZairN
 dMM8EUfRS5uGKanjrD1u0Gdg2MCTf9QxU4fbelkpjniFodFNLhqXR5aKeE7QHqpqvGHtoO9rXK5
 VN4G75ISJ51BFiUXhQLnRMPRqAo/AygmkZYDwG/HCl9Ts9sNXGZW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_02,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606130147

Validate EA inode i_nlink early in ext4_xattr_inode_iget() to convert
a WARN_ONCE in ext4_xattr_inode_update_ref() into a graceful error
return.

When a corrupted ext4 image has an EA inode with inconsistent i_nlink
and ref_count values, the code currently allows it through and later
hits WARN_ONCE when ref_count transitions cross the 0/1 boundary.
While this is not a security or stability issue -- it only fires on
crafted filesystem images and merely prints a call trace -- it is
better handled as an early sanity check that returns -EFSCORRUPTED,
consistent with how ext4 treats other on-disk corruption.

The valid states for an EA inode are:
  - i_nlink=0, ref_count=0: orphaned, pending deletion
  - i_nlink=1, ref_count>0: active, referenced

Reject any EA inode that does not match one of these states at iget
time.

Reported-by: syzbot+76916a45d2294b551fd9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76916a45d2294b551fd9
Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/xattr.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..4deb17b7bcbe 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -448,6 +448,23 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 	}
 	ext4_xattr_inode_set_class(inode);
 
+	/*
+	 * EA inode has two valid states:
+	 *   i_nlink=0, ref_count=0: orphaned, pending deletion
+	 *   i_nlink=1, ref_count>0: active, referenced by one or more inodes
+	 * Anything else indicates on-disk corruption.
+	 */
+	if (inode->i_nlink > 1 ||
+	    (inode->i_nlink && !ext4_xattr_inode_get_ref(inode)) ||
+	    (!inode->i_nlink && ext4_xattr_inode_get_ref(inode))) {
+		ext4_error(parent->i_sb,
+			   "EA inode %lu has unexpected i_nlink=%u ref_count=%llu",
+			   ea_ino, inode->i_nlink,
+			   ext4_xattr_inode_get_ref(inode));
+		iput(inode);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Check whether this is an old Lustre-style xattr inode. Lustre
 	 * implementation does not have hash validation, rather it has a
-- 
2.43.0

