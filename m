Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B669341077;
	Thu, 11 Jun 2026 12:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781182006; cv=none; b=ht3pqHNT+2FT9ZCKrlm57z6lgKEGx1zfhTLUW5R7c13cZWsmoDsRVerkwbOMSqol6KujSP8yLlJcr14LcT5PST0oZ+tdvndv7X6AwAxKejDUYIDWqWigYGvKIqS7/WCgonPGwQqtRkgAWu1kavYvFjFFo8w1bVLvsCtNgZ0pMys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781182006; c=relaxed/simple;
	bh=QAfl5bWYK8k9supmUsXQy+oawd+MtKb+Ih5BF/GPzUM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J9Y5jVDE6S4ElA77TtWyl3/b0sqo1SBFzd/Nm5rrHYG3v6kfSaCtIHxFU8cFRCaGbfQJi/r7I8ZJeduinF7Xf2ykHyvdDCFeCRFObfwCYlY7udKls3iVxNwGTxl51j0MxXKfE8fYt1dBr+7d9IHPl3LwTQ/HEoN8ZSBobhn+qHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=WowO13kN; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="WowO13kN"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65BCUGQA3936895;
	Thu, 11 Jun 2026 05:46:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=J/05NlvIl
	MuNUzHnXKGqy6o2T0/kkQ59dPotC1CzE10=; b=WowO13kNCU/TuHMyaUc65wMer
	IiaZOw9IhXXLOzk6CnhRtTiUmUYhSQaO59JHnOKKyAgndCmrEON0T8ijG2BDnGgg
	uGJeFkcnPdybJufmHBUIQi4Mh++M9X5FrIJAMcCYgX9FUqavC0McU05qFi6pkmBJ
	3M4Hht0jf+xMzMdSTLto4ShjGyk+HkfQYsGwG/rNWLkqx+BEbkY+fVwNbS8OT4Iq
	fDf49ggvltayKqEw5SlNlZ5ViPwgWVDeE7Oqv1rocpwx3kGkmwRyUFa8D6uRquyg
	JSn4j1ZattcdqMYswM2qgiO3/LhwXHjIXlzkql0dEIVHoELu5JNZZROocRh7A==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4eqe7agyts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 11 Jun 2026 05:45:59 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 11 Jun 2026 05:45:59 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 11 Jun 2026 05:45:56 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: skip extra isize expansion on inode eviction to avoid deadlock
Date: Thu, 11 Jun 2026 20:45:55 +0800
Message-ID: <20260611124555.1541195-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mK5UTHzDTkZTxJMcoarxFlNIw04SWNhy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDEyNyBTYWx0ZWRfX5yBC1X3gc/m1
 47gAZOHEYvW2jAW+sBDnaiTxPlVl7IKzz1+CPUxlOT51QYXvfy8uYpJVnvEZOLdDEsOw5qBHybJ
 JlORNSsiAXlTt0qtQb0jzrw+IrNJB2LOpIaRAXUuNPBCzW+FsCirF2b4//o7R/6IYxfLBMa3l6d
 3ACbpHw2ylhZZdwwuq8wFj1S10Lp9Tjf3LUmsyhsq/P9Q1j17PL5RX1lNeHI6x4SSlhiLVzPKyd
 ozXzll5rJ1buseltJn6445HkdE3WooAnkVVmXoiF2p6zYbvIpMcgYcMPamb8aCHKJokFdL9eL9n
 sXf9GCPCXyW29RkCBkowniM2d5KBWIAGT7UqfIAxpjYOyz0MBeoeS79vWnHvgfrxWFwM3rys0ax
 SGbsmw4kepUijtER8ebDS5BmaNZPAvZXml2t0Vm/2YZYWOqoSeQ7KM2Sx9Z9RdenOgmWcIozZDw
 AxWZn6IaqvC9jm8GhLg==
X-Proofpoint-GUID: mK5UTHzDTkZTxJMcoarxFlNIw04SWNhy
X-Authority-Analysis: v=2.4 cv=P+cKQCAu c=1 sm=1 tr=0 ts=6a2aae07 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=tC_4fVRVKstPqIJIqKIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDEyNyBTYWx0ZWRfX8RbAXFSEuTlm
 N3obCN+UNuxsjs67Xa6VFsAKE+06bCp6WWD/ARP3AE3t5bFLn+yAPuFUs9mg/8VWrH74kJoLZNn
 kFtXH1drukHP1SzCrRW6xar+ADiQ9IB8Ym+ukDcYsNlJpphaTmF9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_02,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 spamscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110127

Expanding extra isize on an inode that is being evicted is pointless
since the inode is about to be deleted.  Skip it by setting
EXT4_STATE_NO_EXPAND before calling ext4_mark_inode_dirty() in the
eviction path.

This also breaks a circular lock dependency reported by lockdep during
orphan cleanup at mount time:

  CPU0 (writeback worker)            CPU1 (open)
  ----                               ----
  ext4_writepages()
    s_writepages_rwsem (read)        ext4_create()
    ext4_do_writepages()               __ext4_new_inode()
      ext4_journal_start()               [holds jbd2 handle]
        wait_transaction_locked()        ext4_xattr_set_handle()
        [WAIT for jbd2_handle]             xattr_sem (write)

  CPU2 (mount / orphan cleanup)
  ----
  ext4_evict_inode()
    __ext4_mark_inode_dirty()
      ext4_try_to_expand_extra_isize()
        xattr_sem (write)
        ext4_expand_extra_isize_ea()
          ext4_xattr_block_set()
            iput(ea_inode)
              write_inode_now()
                ext4_writepages()
                  s_writepages_rwsem (read)
                  [WAIT for s_writepages_rwsem -- if blocked by write lock holder]

This forms a circular dependency on lock classes:

  s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem

The iput() inside ext4_xattr_block_set() triggers write_inode_now()
because SB_ACTIVE is not yet set during mount, so iput_final() cannot
cache the inode in the LRU and must flush it synchronously.

Setting EXT4_STATE_NO_EXPAND prevents ext4_try_to_expand_extra_isize()
from executing, which eliminates the xattr_sem --> s_writepages_rwsem
edge and breaks the cycle.

Reported-by: syzbot+5d19358d7eb30ffb0cc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cd7588a3fa45..cbfd1d1282e6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -264,6 +264,12 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	/*
+	 * Skip extra isize expansion on inodes being deleted -- it is
+	 * pointless and can trigger a circular lock dependency:
+	 *   xattr_sem -> ext4_xattr_block_set -> iput -> s_writepages_rwsem
+	 */
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.43.0

