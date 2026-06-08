Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D46C3FD140;
	Mon,  8 Jun 2026 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780932381; cv=none; b=M7yr2yiDOa1JqB2jnq8q/eKIHwX2PV5y6UDKEu8swfUkRis5iGTOcbwcmDLf9JB0C4KTIC74aIDOey4dFUpOE340D/SVcthxu0B7dYT/XsVOMocYYN06Dz8vS8wUZrJcwJMjI4hbdK9BKa5yFHvnVBs/OJs5f+haSBC1as4vRYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780932381; c=relaxed/simple;
	bh=sapMXFPHMvmzto9KFp7qWBBRcKWBT8Q1/5bkQCxL3Rw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tTd9ZV64IVAHl1Y9i//uNpnf5zhBFRy7UFnn3CRmCeIB3PclZAy8pgGl0EncEWOWo/Ki9T2VbFIDpuLJKAh4Ywr5/DhkXVPLIoQQ5J9RACZAGRmgH9VH5Ruqmy9G8fHvf9w60g9qfDMT77gA/spVJ7YHJ+GsZMyOWJ53uDDjSu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Ui88opgr; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Ui88opgr"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658EZjsp300336;
	Mon, 8 Jun 2026 08:25:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=qv3h/vmau
	6Iw78C1ublWCFGWUbSvihxFZ/IMg9zx2l4=; b=Ui88opgrAfYLdBgVk75zbAKBQ
	RLAZo3YjyqilrSUh+vU+l8C2hM9rGxV2DuVvtYPT53xTCtiDnAiy0r2SqrKT8rie
	51ls/tXIF6UEJ0ke1D5V1L7VPxa7eqPFwoSu+KjctbEXpWTppYgG3Ah4nwY3Ugj1
	GQ+pkXTuVSYqnhd2G3iIee9hD9JYklXrS4azUtcZ5epeEAo81EDsOaX1EYKybMu2
	zRu32rWgKna9U1yHREo7tb7e11JOEn0LMF3EQhR4DoqjDY77TeVKcS2e1JiCCPOi
	Oe/dZOAHLGQTCYhEyVInHO0xO54pKh/+waG4agxs4MkbGLb1HCIz5yebkTpTA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4emety2qss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 08 Jun 2026 08:25:26 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 8 Jun 2026 08:25:25 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 8 Jun 2026 08:25:24 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <dmonakhov@openvz.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Mon, 8 Jun 2026 23:25:21 +0800
Message-ID: <20260608152521.1292656-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: L8TP6Dg3br0ojLR0dIIItateyo1B-PBb
X-Authority-Analysis: v=2.4 cv=VKjtWdPX c=1 sm=1 tr=0 ts=6a26dee6 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=sbZrjurcE57j4PJPAZIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE0NyBTYWx0ZWRfX0IxKiO5dDHSB
 iAOvYCQbqrSb6BkyX6OjaMV5U/eMVnvafkC3uoLiKiptu3ZNUBwT3JNdhEsJCXUgQ5Q3jvTLwBR
 EBPVEhlZ7N05yZmmrR5W5Quqf/EfhgKT/3nI31qOm4JRnY/Ha8Haqbe00W/n2SOBA1G+FFX9e6+
 ZYOWe6yscUx54fm/FPayfxksFxVEuopZ4L06CN8l4Xm50ADfzbqmiTWc0K+pMXtBMXsIgTwrykk
 yOIB9x/bdCIWDpg5QnQr71Qdh8Ff7AfbFpR3EjdyR0ZFaU44qcwutjbGODsEIjnKOe/ycggKuKM
 4A6NVRw9gvGX42u7jAspGFKqvsjDgtzPuWlhoc8UWEaN/jPe8S35HxNO68uKfY41VzF7avOMhiE
 jlEW53OMgzCUQL/qSoslULl0FkIHO0Sb/Y0mXDaecDhK/PCO8NurILa2vvLc3TOTUE9nd3IKkQp
 pWr/gIe6EYYZqwID5eg==
X-Proofpoint-GUID: L8TP6Dg3br0ojLR0dIIItateyo1B-PBb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080147

Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
belong to the same superblock as the original file.  Currently, this
validation is performed inside ext4_move_extents() by
mext_check_validity(), but only after lock_two_nondirectories() has
already acquired the inode locks.  When the donor fd refers to a file
on a different filesystem (e.g., overlayfs), this late validation
creates a circular lock dependency:

  CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
  ----                              ----
  inode_lock(ovl_inode)
                                    mnt_want_write_file(filp)
                                      sb_start_write(ext4_sb)   [sb_writers]
    backing_file_write_iter()
      vfs_iter_write(real_file)
        file_start_write(real_file)
          sb_start_write(ext4_sb)   [blocked by freeze]
                                    lock_two_nondirectories()
                                      inode_lock(ovl_inode)     [blocked]

With a concurrent freeze operation holding sb_writers write side, this
forms a deadlock cycle: CPU0 waits for freeze to complete, freeze waits
for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode lock.

Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
it fundamentally requires both files to reside on the same ext4
filesystem.  Moving the superblock check before any lock acquisition
is both semantically correct and eliminates the circular dependency
by ensuring that cross-filesystem donor fds are rejected before
sb_writers or inode locks are taken.

Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1d0c3d4bdf47..f7cd419a3218 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1650,6 +1650,9 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!(fd_file(donor)->f_mode & FMODE_WRITE))
 			return -EBADF;
 
+		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
+			return -EXDEV;
+
 		err = mnt_want_write_file(filp);
 		if (err)
 			return err;
-- 
2.43.0

