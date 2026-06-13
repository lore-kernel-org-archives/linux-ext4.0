Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87958397342;
	Sat, 13 Jun 2026 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781357405; cv=none; b=BuPDvXOtXHclPFhZVAgtAPY9uOu7LfEFdOKAYtJuboqAMfTKX8EJi1FBjDhpkmhUbz+wn44EE0EJT4rOBQTqbb+fIYXZfFf0Li6gsfprD2EzVXpjvTtOW9JPJSWsuLjDlsaC6E4sX/vN1gaRdts7D7Bt3q0aHt/ujehnddW64yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781357405; c=relaxed/simple;
	bh=FwWKAhJObxWHJd06E3GwY0i49Mgh0kr+M0lTukAkv3I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FzS8vZKZ1yG02mGFD2DLXRjbBwcO0bDEeSLk91RCEZVVZg8MuP80/1dpUrJPsaTjoksJx+0HdBNAuTA2fBzhCm67f71DrcIY9silHyeX1USXcCsByApONQecpwGYQQOA8Pr0TwmHi/WZJScNSYaKojLEkZQW2fzroi/nHU2mc/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=JN4swWb7; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="JN4swWb7"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DCNOru118612;
	Sat, 13 Jun 2026 13:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=BWh8i145y
	lb+eDRSiowVh5O8KlZJ/zE2bYdmicfIOe0=; b=JN4swWb7eNY41Cr0TGo94ckQy
	LOJwx194wJ80uVjqguDoPFKhiLry7W8ecq1noBuMoYjjxCZLhbkRLwIClai4APMY
	SLzgF6YS3VZPvv7heTZKrI+8f9tyqWNseNmgg5Wn6c/5VlQ3pcUVlJBUdSIK63ji
	KVhQnPyjwGxW9uHGvNU70fsR5N2IxYT8boMdekd9pCOiczpi9IlZmz3q0jowH5qs
	aoFAFHDdoDHFm49hfzClGBRWUBasr+CosS5wW92KorQppdj9+qpo6+0iMPkZhz9K
	L65fAL6vYNfDGxK/LJ74qMZp4XYSeGLas/umiWtVpW8KmuxhyHQwl7hwWQqHw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ervkp0jw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 13 Jun 2026 13:29:11 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sat, 13 Jun 2026 06:29:10 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sat, 13 Jun 2026 06:29:07 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: validate EA inode i_nlink in ext4_xattr_inode_iget
Date: Sat, 13 Jun 2026 21:29:07 +0800
Message-ID: <20260613132907.3533376-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDEzOCBTYWx0ZWRfX67hO1fbokdfx
 m4vommJYSPQvqsXkHdY650wMVzh7ky/rjAoSUYveGpf0YVGbugpMvaRL8n4m6p84r8gnx9N4bov
 WDWYu7o7ZoYJVmcR/yrLTw043kXMwSFBwbI2b7f2vI6Cd+x++LR2uJZjTTL/xAuy+CdECrY7Wgh
 lsg7hIU4wqIy2RRZ3P4ojIF51x4efAKNJ6n2ToganxvkPbh7OLn62H1Zkyp2FdqeXSVTR5TE1Lq
 lhVCmJ9RBRcwuE1H+3Ye8ZFBUUPH6tnnhlg/kzhX1lcqYKeF2AXgzlCV3wG40+iQtFZVSZtVDT4
 MWlYfm5SsFEwO+4Llfua6VYFNS17N++bebWGnarNgh+v6rr2fOrFLwIi3W9YLZ2+63GiFsjHzQ3
 wbUA542Rm56EYId5qPCeZuEAJDDoX31pQk+6/YDMhNIq39h+zjj/pIFZRqV3lgsfG1aoOqq6R+c
 cAxVtWwH/bWTGeB2NXQ==
X-Authority-Analysis: v=2.4 cv=BK+DalQG c=1 sm=1 tr=0 ts=6a2d5b27 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=SG9YRtuN4gMFblbNuEUA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDEzOCBTYWx0ZWRfXxMgjpFEc2qk3
 iW/IVl3DSxPt/SYcLS+FS7pPzid4KFHOq1IWoV/30XyowezqjZ+mGypOYxVUCkK+DVyxddnoGqP
 3xkPmzCfu/jEqDwd46C2krmbE0Xop1DF3iiXD0JvNBicB4i5Z0jl
X-Proofpoint-GUID: fe0K_KXL1SCrFCbP6sa6LV19GO_CW1FZ
X-Proofpoint-ORIG-GUID: fe0K_KXL1SCrFCbP6sa6LV19GO_CW1FZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_02,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606130138

Validate EA inode i_nlink early in ext4_xattr_inode_iget() to convert
a WARN_ONCE in ext4_xattr_inode_update_ref() into a graceful error
return.

When a corrupted ext4 image has an EA inode with i_nlink set to an
invalid value (e.g. 65535), the code currently allows it through and
later hits a WARN_ONCE when ref_count reaches 0.  While this is not a
security or stability issue -- it only fires on crafted filesystem
images and merely prints a call trace -- it is better handled as an
early sanity check that returns -EFSCORRUPTED, consistent with how ext4
treats other on-disk corruption.

An EA inode should only ever have i_nlink of 0 (orphaned, pending
deletion) or 1 (active).  Reject anything above 1 at iget time.

Reported-by: syzbot+76916a45d2294b551fd9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76916a45d2294b551fd9
Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/xattr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 982a1f831e22..2fc41a06a446 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -448,6 +448,14 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 	}
 	ext4_xattr_inode_set_class(inode);
 
+	if (inode->i_nlink > 1) {
+		ext4_error(parent->i_sb,
+			   "EA inode %lu has unexpected i_nlink=%u",
+			   ea_ino, inode->i_nlink);
+		iput(inode);
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Check whether this is an old Lustre-style xattr inode. Lustre
 	 * implementation does not have hash validation, rather it has a
-- 
2.43.0

