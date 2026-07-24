Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EAF3B14DA;
	Fri, 24 Jul 2026 10:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784887724; cv=none; b=uyoxeeGP9DBWhH4eHnGodQeq/QjSOQAApdbOhDPlMINpbsla2TUF+yCyaJdtnnRDtXRWZjjlYYnixSTfcJGmPhRn9x0XtgXIpKLKSgLOap3NoCrFnbn4XiEp8738E4BKIwfBqpC+/fG3Khbncxex+/hFXlWi2DppatTc7RzbgBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784887724; c=relaxed/simple;
	bh=g4eVH56hO25tdcUHvLAWj2R1ErZEyrsY8G10QVthuRk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rcvUzPZrBzB/klk+lGAs4/iJcGLSupJ5W4FMSw4M0OI9Vwuw2wQhE4QnK3Eg9N2oKytJQW6r8AZSHFMm41TYs62Bkj+olek0hercXL2FMLkmB/EKPZJLLJTpCUmQ4f3UuwmPWZtfehTuVHoZ/++UlFy9H0c4VQV9UpFKouJ0Lfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=rFPDW5NO; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="rFPDW5NO"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O5ukRW1071013;
	Fri, 24 Jul 2026 03:02:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=HeH9MdeMu
	twl8N2LmDZcJUna4FECWmZlKsMBO+7MjPs=; b=rFPDW5NOBkIl/h6LKnXJyH2dh
	QGAPsOimxqvFGgjE+JdZoqlEyk4NuuqxI8uKcszLlM8rArPe9x5zY1XeOtlkPrFW
	ffW+kn2TNQsYVdyguP21qXF8KPXtEVdYsbT/+fRMInLW/KaOy7dx8gS922SqZo3n
	V0PPHcC/+Ayj9lhKvayLtqfavgiXvRDjQn8HjO8bWJzNWjTRbfweLQP1++HphoY/
	1gUnTHvO47mATn3bAau1L5grbyFf0v8k3cfd1P53//01enJwr9/0qWLxhxR8VprQ
	cDRcNHN9i/rGNqDTQb/cGc4KEmhddZ+Uz5emSmztLaQS1PqqG7HPbdOESyHug==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fk5tttv0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 24 Jul 2026 03:02:59 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 24 Jul 2026 03:02:58 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 24 Jul 2026 03:02:56 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v5] ext4: validate EA inode i_nlink in ext4_xattr_inode_iget
Date: Fri, 24 Jul 2026 18:02:55 +0800
Message-ID: <20260724100255.144768-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA5MSBTYWx0ZWRfXy/8VbDu/g68v
 kEykaXbtf4QP2OpjmvDuVCFCztOkdpN9ujdim59hvzlAudO2hEN0vKr+6MGScEUn5O2Cuaoz0Jt
 +Z7Pn4GWLSx04z1Ee6mDG8NyiateIZpyICta1PZrPnaH8pWPiDi9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA5MSBTYWx0ZWRfX2Eisz6f71n0b
 MXC9zO550xyJnn0NFgflq4s86nOR2sIF1+1z3TJyaTj2VbA7MKXthP5Sa2hkcsRKI2FAeBgUAB6
 l76hC7tiQEC2iULdMFp/Hsz/ZH1C4yDFs6NsIR81Uqydj+aJfoV5VkBQnjMG6/bG2L/vhNY9YRR
 tzZjfCiA6tga5NJ4W6eCsPmL9hrQQsUpTKEMh3jzpKpoilyVJgFuDywV7i2CQzkhhPDDaYbgcs4
 sNJ0f/p32QPWGTKuJZfLjo2QCn8ZhJelN7LBGvEcVEE3ERClOCeADg8yHtCgUwvs52AKE84JDkC
 e2Pb+b/V48RrB+MxbZ3pYFzmnkENukj9R/lWnujXUHmy0mt+BcpfyeiJmUfU1027ThYCWM4hj6A
 TczgUtx/pJhXqttpHseX4G9NsiI5lfkWiU7E7dNX0lLxBeCcOPcMpo/qfNE4mDsakB3fRrB5tcZ
 stoM3gVOcDtObZNY2cA==
X-Proofpoint-GUID: UX0jgYGTi5hXBnSLTsvpwNClM2hmnvzD
X-Authority-Analysis: v=2.4 cv=cabiaHDM c=1 sm=1 tr=0 ts=6a633853 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=L5zdWEjsUepxmB3FffwA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: UX0jgYGTi5hXBnSLTsvpwNClM2hmnvzD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240091

Validate EA inode state in ext4_xattr_inode_iget() to reject corrupted
EA inodes early, before they trigger WARN_ONCE in
ext4_xattr_inode_update_ref().

When a corrupted ext4 image has an EA inode with inconsistent i_nlink
and ref_count values (e.g. i_nlink=65535), the code currently allows it
through and later hits WARN_ONCE when ref_count transitions cross the
0/1 boundary.  This is better handled as an early sanity check that
returns -EFSCORRUPTED, consistent with how ext4 treats other on-disk
corruption.

Since ext4_xattr_inode_iget() resolves references from active xattr
entries, the target EA inode must be in active state (i_nlink=1,
ref_count>0).  Reject any inode that does not satisfy this.

Reported-by: syzbot+76916a45d2294b551fd9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76916a45d2294b551fd9
Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v5:
 - Use ext4_put_ea_inode() instead of make_bad_inode() + iput() to
   safely release the rejected inode regardless of jbd2 handle or
   SB_ACTIVE state.

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

 fs/ext4/xattr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 4ae6ce111566..1eee25955107 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -460,6 +460,21 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 		inode_unlock(inode);
 	}
 
+	/*
+	 * Since this function resolves references from active xattr entries,
+	 * the EA inode must be in active state (i_nlink=1, ref_count>0).
+	 * i_nlink > 1, i_nlink == 0 (dangling reference), or ref_count == 0
+	 * (inconsistent with an active entry) all indicate on-disk corruption.
+	 */
+	if (inode->i_nlink != 1 || !ext4_xattr_inode_get_ref(inode)) {
+		ext4_error(parent->i_sb,
+			   "EA inode %lu has unexpected i_nlink=%u ref_count=%llu",
+			   ea_ino, inode->i_nlink,
+			   ext4_xattr_inode_get_ref(inode));
+		ext4_put_ea_inode(inode);
+		return -EFSCORRUPTED;
+	}
+
 	*ea_inode = inode;
 	return 0;
 }
-- 
2.43.0

