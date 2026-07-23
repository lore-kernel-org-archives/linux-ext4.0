Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4E540B396;
	Thu, 23 Jul 2026 08:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784797038; cv=none; b=mYV329TtVEwdi9yIjOIhZ1vyJ/3CCXguq0HKToflA0W3gwPHZJl1e1kNiq9+jQ1Py278Envix8QwXtc5f0xQ7PdLfWjZn6QPhzvxxxjRSWJXTZxuDb6ICwmQo6IaWSpCyUVvfq+WiAZQWp2d/94IYCX436zqCx3npEkUROlrtIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784797038; c=relaxed/simple;
	bh=1n89HV/oi39ey1WCmn5q0qrfsKyJxMhmoEzq+7Ozlcc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pOdqSihVmgLXhS5xuvFmlM4BCoW6/bVn22mTsm8yHEZui7waKBx1mAucg/PP9CDG9x3nJRsrXz1w+meGXxmI23yZxuo2KOH1rS035Zl+5j57s9fabdq0PyZuWuscduGbMENuIOv0x+kS12K855MKN/s1xNBDqqo8W8Ia+eIBUBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DnJp5zeh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DnJp5zeh"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N5CIsR2072148;
	Thu, 23 Jul 2026 08:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=T9pVRfuh86Sw2+olp4/N6FmPjlbIoU0aU1AqGrBEy
	aQ=; b=DnJp5zehDdxfyQOVleSO7JuR3+QJI7r2pyDgTMBKkIh+Rp64mQQECLhnQ
	NMVV4kwLRA959Rf39c6+m1NPrUpefGexhi/5N2IsUZLY4UeFeKp5eSw3yRh3dpcA
	+6pkarfU7oo6A2MygI9rt9Lyc3b8J4cZgt+l+DxngB+CF7H2eWx3pPJIIU169JNJ
	gzR9d7QN58GOc9EETpIHak3yOShGALO8weuSkMP4DKC1FUq58ey2du+PV06vpsgO
	vFGLDfTHhRgsnF7LeUBoO4fEUYajKSoiefUZPqO7es2QSqz3LEC5hFe35LB37+14
	pM6I/hM19J5ardPLLO3HlpAQ37Uqg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abpq2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 08:56:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66N8nlJ9007506;
	Thu, 23 Jul 2026 08:56:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6wbfcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 08:56:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N8uqUv31130276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 08:56:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3839820132;
	Thu, 23 Jul 2026 08:56:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E52820130;
	Thu, 23 Jul 2026 08:56:49 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.19.73])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 08:56:49 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        linux-kernel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>,
        Jan Kara <jack@suse.cz>, Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH] ext4: turn off DAX on new files when encryption is set
Date: Thu, 23 Jul 2026 14:26:48 +0530
Message-ID: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA4NiBTYWx0ZWRfX2Q8x3FoWIEWR
 5IB5lwzzSFyv3/xLJr2DDhLWak3r6JD3nmhWBCCwtikRrtw2azV1tDtvTNHxZUFgbRgzvY9dM/Z
 WEYTTkdf5f8iCDJfyZUgohHDaGCoRVFpwja8s9EVfRTdMKFPCdhiU1yjwUKFbDcE7kT4FXxqSlQ
 8YS667ZtQokkn4/wWWtFE3WlZwFTFWuGWiuELnozIbzhkPEmC3mP9FXmW9KSnSgA/GU56txa/ZD
 1m9s1Sb9rVVjGdfMvBdCT+FcOskzLZBS3x+reYpH7nPdAv8lTlArCVWOMtXx+V4KT3ekueiVHdf
 pgj879FjCvpjAhC+bIcGxXqLlqcaUXgWcrjLvvW0uRJgVy3u9JgGS0fWtXNW1gnmebQwkkcwDE0
 D1+GUzA6+UlDiCbrMefA4rki3lp+4NhcG/ugLsqF0sW2fGJ35XoTGbTdcaMQCRnglQosXXmIlbI
 kvNFjMczA/XFqCtv6nQ==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a61d758 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=EdVn9jYfiogK2UA388UA:9
X-Proofpoint-ORIG-GUID: sX57jV7DmzCFu7iWB6rRa-GUSA7xDCWL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA4NiBTYWx0ZWRfX8gR/L301bZ4a
 9fWdQmbyUElNt8ryAq63gWJbJIfZLI4niuuaaGjunZ5kngmbQw9LDPTPZZ4BYRuBYmhyV63JE/d
 j+leL+2Zdz7itDz9PS+fuZESSh3enno=
X-Proofpoint-GUID: meyxhGD4sb6jW9UX5qO80asqJ8WD-1rP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230086

Currently, when setting the S_ENCRYPTED flag on a new regular inode in
a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
flag. This is because the newly created inode ends up with the following:

  __ext4_new_inode()
    ext4_set_inode_flags(init=true) // sets S_DAX
      fscrypt_set_context()
        ext4_set_context()
          ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
                                              doesn't clears S_DAX
      ext4_set_aops
        inode->i_mapping->a_ops = &ext4_dax_aops;

Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
silently ends up bypassing encryption completely. This is reflected in
multiple xfstests failures like generic/548. To fix this, ensure we disable
S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
is safe to change DAX state there because ext4_set_aops() later can
correctly detect S_DAX unset and assign the correct aops.

The fix was actually the intended behavior however it seemed to have
silently changed in 043546e46dc7.

Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
Reported-by: Disha Goel <disgoel@linux.ibm.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/crypto.c | 15 +++++++++++----
 fs/ext4/inode.c  | 10 ++++++----
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index f41f320f4437..2d409114e02e 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 {
 	handle_t *handle = fs_data;
 	int res, res2, credits, retries = 0;
+	bool init = S_ISREG(inode->i_mode);
 
 	/*
 	 * Encrypting the root directory is not allowed because e2fsck expects
@@ -179,10 +180,16 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 			ext4_clear_inode_state(inode,
 					EXT4_STATE_MAY_INLINE_DATA);
 			/*
-			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
-			 * S_DAX may be disabled
+			 * Update inode->i_flags, S_ENCRYPTED will be enabled.
+			 * If this is a regular inode, then we must be coming
+			 * via __ext4_new_inode() as only new inodes can be
+			 * encrypted, so we must set the init flag so
+			 * S_DAX can be disabled. This is a bit fragile but
+			 * seems like the easiest way to make sure we don't let
+			 * the DAX flag linger when encryption is enabled as
+			 * that result in writes silently bypassing encryption.
 			 */
-			ext4_set_inode_flags(inode, false);
+			ext4_set_inode_flags(inode, init);
 		}
 		return res;
 	}
@@ -209,7 +216,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 		 * Update inode->i_flags - S_ENCRYPTED will be enabled,
 		 * S_DAX may be disabled
 		 */
-		ext4_set_inode_flags(inode, false);
+		ext4_set_inode_flags(inode, init);
 		res = ext4_mark_inode_dirty(handle, inode);
 		if (res)
 			EXT4_ERROR_INODE(inode, "Failed to mark inode dirty");
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..a57179655353 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5113,8 +5113,6 @@ void ext4_set_inode_flags(struct inode *inode, bool init)
 	unsigned int flags = EXT4_I(inode)->i_flags;
 	unsigned int new_fl = 0;
 
-	WARN_ON_ONCE(IS_DAX(inode) && init);
-
 	if (flags & EXT4_SYNC_FL)
 		new_fl |= S_SYNC;
 	if (flags & EXT4_APPEND_FL)
@@ -5129,8 +5127,12 @@ void ext4_set_inode_flags(struct inode *inode, bool init)
 	/* Because of the way inode_set_flags() works we must preserve S_DAX
 	 * here if already set. */
 	new_fl |= (inode->i_flags & S_DAX);
-	if (init && ext4_should_enable_dax(inode))
-		new_fl |= S_DAX;
+	if (init) {
+		if (ext4_should_enable_dax(inode))
+			new_fl |= S_DAX;
+		else
+			new_fl &= ~S_DAX;
+	}
 
 	if (flags & EXT4_ENCRYPT_FL)
 		new_fl |= S_ENCRYPTED;
-- 
2.53.0

