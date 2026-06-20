Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143719CD1B;
	Sat, 20 Jun 2026 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781919622; cv=none; b=khz0I+D65JKqlogsg3wHzI/6l1fj7xLH7mmCnZP+RS6l6dzT6QY0jitrveABIaA5smpEsiXYMJr6qYzBLn41Sd60gmQ0E4uozZr1E5TkzvsBYMYxwC2C47Ibcb4XfVqwjAck9h65hJUOr7g7zo70VN9Boe80IiV4GaxavjzWvEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781919622; c=relaxed/simple;
	bh=kpLahbmgCbjh29EOoQs3zFJCxx0NDikY0yLq+mcFV4U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVz8gwk8vztJVu1J9hdVfk962NDi+tuXhCFwDKV0rRb7KVQ2/4yCTuLGAyRvXnuieR9LZ5iA591DUIU/0axyMy+k/6hIqhGhVzkv1ZncnUTeBpdA9q7nAKN+SZokPfBcy+mUQfugCfbaop4uK8jviY/LnUiVR+cpkPfnnJmjVL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=LSsDl6eI; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="LSsDl6eI"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65K1U2bG3822841;
	Sat, 20 Jun 2026 01:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=qpAw0tZ+ZDrwtnFCHPOP9dbpXPmJ/tfKREqNKCDgw8M=; b=
	LSsDl6eIc+twAvRA1hZUW6lGGIQG+BoHSXr0pqlAU1SX+Q1e2fQamwiH8VHRfnVj
	uzRzY42kxRK9/u8JBKwCNFRD8kr/Dr5UJXRkp9LHyDRSuAIHDJ+gp0uX7bpTWifk
	yRY9jBHVHbsJAQP2qmFoSmO0/h4QQYVG2/dRZKERDCz2XfGf80qgQS5ckV8k+svS
	mXq0aNtotL5theqh2Kwz1xtXvxOCp+zlFLyFJ/zGERMsrOE8WdpzMkxYgR9FuVhI
	fg2DkBlVdgu0NMXFCoczmdZJC1k0KQHJ0X2wWud/kR0FfriQ/enrQ2NfYUaZo4fa
	ERlDbMqvmeFVmdcgWj8I5w==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wr1st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 20 Jun 2026 01:39:44 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 19 Jun 2026 18:39:43 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 19 Jun 2026 18:39:40 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v8 1/4] ext4: skip extra isize expansion during mount to prevent deadlock
Date: Sat, 20 Jun 2026 09:39:34 +0800
Message-ID: <20260620013937.2564269-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260620013937.2564269-1-yun.zhou@windriver.com>
References: <20260620013937.2564269-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Xyu9TVFKIr-xKCkIxAUGh7l3b444IUrR
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfX9ZzYgUH13KNz
 U4gww0orFh5Zco9prlJHxiP+mACKiWuzIUW7Up1am00gM0O+/SgqaCFg/5PcJnfShbW4nVVC8wu
 VaBp102ax63qSQbFq0Y+GRATrEn4wrsqZ3Ehw5m9qSsWvpAGWzUX
X-Proofpoint-GUID: Xyu9TVFKIr-xKCkIxAUGh7l3b444IUrR
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a35ef60 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=nphdFjCg5VZFgBW92ZIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfX27dI2dkjkMkK
 SIj1EnFs5IwtRTa7weqvJNOKj3bxly1Z61CRKKqDl+hJdopqJ7ZkdHg3nJz+VKf5sXhpypxaptq
 5QhdMX7UJobZreMQZ+KXqftiQuGuozPFgqFNqd134eRCObzS9EAt2dbnzvF0XjTrAT8nx/e8Evd
 yQ/SVp3T+aXHQmOwtWCMLL+KDc/G2JCrmR3zTlAfULdl84S1bi0jVF0g0cpcwz8f9w0m3KBZUjP
 3K2C+BaOtHV0e2EJbktpEt3apgVMa8yzco65Q6X8QQZQtvRNF0V515l8UqRPsiKVoJ3hmT02VBL
 W3cz3zPeUfo7gBsG1uLnNieoBmo7H9tzkBpdSF48+JeW06XnG85wma02huLTwqNTn6SJ6avG2GC
 g+x8jtedqDU6BXpImh2LSt0FKm1lLidBS1Qjr4rNHyKHlr+V63LUvxZgmVpxtLD7bwc9iu+WKmA
 VHC4hWepaEJHT4jFtgQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_05,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606200014

ext4_try_to_expand_extra_isize() is called from __ext4_mark_inode_dirty()
while holding an active jbd2 handle.  During mount (!SB_ACTIVE), the
expand path may move xattrs to external blocks and release ea_inodes via
iput().  When !SB_ACTIVE, iput() calls write_inode_now() which acquires
s_writepages_rwsem, creating a circular lock dependency:

  s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem

This can be triggered via:

  ext4_process_orphan() -> ext4_truncate() -> ext4_mark_inode_dirty()
    -> ext4_try_to_expand_extra_isize()

or:

  ext4_evict_inode() -> ext4_mark_inode_dirty()
    -> ext4_try_to_expand_extra_isize()

Skip expansion when !SB_ACTIVE.  This is a minor loss of functionality
(extra isize won't grow for these inodes during mount), which e2fsck
can resolve later if needed.

Reported-by: syzbot+5d19358d7eb30ffb0cc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..09dcfb6bf48c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6458,6 +6458,16 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
 		return -EOVERFLOW;
 
+	/*
+	 * Skip expansion during mount (!SB_ACTIVE).  Expanding extra isize
+	 * may move xattrs to external blocks and release ea_inodes via iput.
+	 * When !SB_ACTIVE, iput triggers write_inode_now() which acquires
+	 * s_writepages_rwsem, causing a deadlock with the caller's active
+	 * jbd2 handle (lock order: s_writepages_rwsem -> jbd2_handle).
+	 */
+	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE)))
+		return -EBUSY;
+
 	/*
 	 * In nojournal mode, we can immediately attempt to expand
 	 * the inode.  When journaled, we first need to obtain extra
-- 
2.43.0

