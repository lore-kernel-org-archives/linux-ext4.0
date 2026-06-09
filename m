Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03A622423A;
	Tue,  9 Jun 2026 08:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780994460; cv=none; b=kRkpqqfgCFmLcEx8WKwvDpgQAcnUaH8ICdZ8XrUAEfNbys3sntXVyWLK/Seqf+QAOjycrautOk/2ZrZi8LPPpvp21Hq+n7RJgN3u7P2dW94SiEaB6bOaxXrae5zeljmB8Qe9ctQZugHqxpFqSfhBsGllPFe69dk4R6+/GpIWQ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780994460; c=relaxed/simple;
	bh=3CvKZcMjo8H65x99mYmnk4KR29HYklIHPgWJf2U6+N4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fzkQ5IChTdJGT9mmJKSb/o7SXJTrbP9dpz12JQqkjkJD+AQdqL/pSMGxMcVyXfyN61EPJk4/qsJ3fgZlBt29aLzPnfTSDcttj7w1gOvmGODb7NNACg+5yx6Iv3rNYw6CYzuV5vOtluRgO8zzjjt2Kfz/UQce9H9ht69WbysI9/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=GLCP89go; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="GLCP89go"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6597xJrh1939008;
	Tue, 9 Jun 2026 08:40:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=+iBGZs1MN
	Dp8B/04ZrI7WmJq+squVS9WGmMyKzP7n1A=; b=GLCP89goKa9katY79hIEJAEOr
	AQ9e7CF32GZ2aCN7SEnCMo7JafCxOy8uU18W9gznO1kn0DyK6RXpfrSK+N6rna4O
	BxqTvWvvNiKWkjJYODjwm2a4p0NSklhyFDaYdLTC5i/5e7bcIN6rpmDZ8NPjKBtM
	T4pZcWPejMBEU6IqL87sDjsT0Qq+gBhuCGQ8nPxfNw3EAP4FRfT4UV2YvID4YbNm
	FKGd7DrAx0Om2hOBsfRRYzFVvwg5B2lBGrjmL8kYSgDRykAGrrywkL26vrVMN2GJ
	nalG2p2bNtwPSFcQQHgLIDcHjTve9rgFcK+q8cLUk18rWse2Foeq6/SOmkIhg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4emah7c5tv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 09 Jun 2026 08:40:12 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 9 Jun 2026 01:40:11 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 9 Jun 2026 01:40:08 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: fix circular lock dependency in ext4_ext_migrate
Date: Tue, 9 Jun 2026 16:40:07 +0800
Message-ID: <20260609084007.3432061-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4MCBTYWx0ZWRfX1gnuhLii73nL
 F0hxBXrK4P6v48AOUDHcsvTGT4G3b1AeJMfE2kVviy0UYD/d5YmzqKzKPHjmSvDzo6RhITlOjC5
 n0QerhljH4nUQGw8UdHP1mKhX8zzzYyuTqgqlLo2cFSE4bS53kUtYezopZnU8b1Ejp0bpaUDOaL
 tlRazEouBHlKTMru7xj3YZJWsfkpAbxy1NxDIJGH0Q+Biu9t7m0JzpB+BgliefOWJWXsyAgsVMU
 jKhXrTzSBbhKjNdqIhW8rrTFVs1m9ss1Vp4hL/vFD8vVyfq+nAal5wJ/hMA2MWju722oW6Y6yLB
 LCxWqlIZJa/yPqt8elnCOLFeObbcgGrncS+f9f2Z8u9F5XVQD526qxxWQYYlDU98lz96KB+2NJi
 kzCw3A8LKQoUt4PeQ0ii5dpQLVf+aGilZ9Nz2QMHTxGX9th6MFa1GvLt4VSHD4B+7DSbkQB4TZm
 +lSEmFF9ouFzZl8Jizw==
X-Proofpoint-GUID: QoRF62_cE5qdfTgxxKroKMBegq9V_KOe
X-Authority-Analysis: v=2.4 cv=NbDWEWD4 c=1 sm=1 tr=0 ts=6a27d16c cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=y7x6ovvD-WywBiYXLLAA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: QoRF62_cE5qdfTgxxKroKMBegq9V_KOe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606090080

Move iput(tmp_inode) after ext4_writepages_up_write() to avoid a
circular lock dependency between s_writepages_rwsem and sb_internal
(freeze protection).

The deadlock scenario:

  CPU0 (EXT4_IOC_MIGRATE)        CPU1 (orphan cleanup during mount)
  ----                           ----
  ext4_ext_migrate()
    ext4_writepages_down_write()
      s_writepages_rwsem (write)
                                 ext4_evict_inode()
                                   sb_start_intwrite()   [sb_internal]
                                   ...
                                     ext4_writepages()
                                       s_writepages_rwsem (read) [BLOCKED]
    iput(tmp_inode)
      ext4_evict_inode()
        sb_start_intwrite()         [BLOCKED]

The tmp_inode is a temporary inode with nlink=0 created solely for
building the extent tree.  Its eviction does not require
s_writepages_rwsem protection, so deferring iput() until after
releasing the rwsem is safe.

Reported-by: syzbot+f0b58a1f5075a90dd9a5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f0b58a1f5075a90dd9a5
Fixes: cb85f4d23f79 ("ext4: fix race between writepages and enabling EXT4_EXTENTS_FL")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/migrate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 477d43d7e294..25368eb44e85 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -464,6 +464,7 @@ int ext4_ext_migrate(struct inode *inode)
 	if (IS_ERR(tmp_inode)) {
 		retval = PTR_ERR(tmp_inode);
 		ext4_journal_stop(handle);
+		tmp_inode = NULL;
 		goto out_unlock;
 	}
 	/*
@@ -591,9 +592,10 @@ int ext4_ext_migrate(struct inode *inode)
 	ext4_journal_stop(handle);
 out_tmp_inode:
 	unlock_new_inode(tmp_inode);
-	iput(tmp_inode);
 out_unlock:
 	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
+	if (tmp_inode)
+		iput(tmp_inode);
 	return retval;
 }
 
-- 
2.43.0

