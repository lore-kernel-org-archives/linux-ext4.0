Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5303E556C;
	Mon, 15 Jun 2026 11:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781524444; cv=none; b=U1OfFjapA691Ld/mrKRcKq4Yd7eQVK5TbSQRB9UAGo38eMGOgIJd4Cd9pyjm1GrxUI75AKIzdI18tQ/ZlrvG/nEe+Z0rLfuitYyGHnh22U97b5Do71sG4zFj119k9UYyhGu82RP1XyKPpypKumTLa2fh0NcUk1GmNl69LLwwCHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781524444; c=relaxed/simple;
	bh=tL2V0Uqb/Ohk5X2Cjq49ZLAX22F5k8A6Gp37owoA0Mw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=snZzjxq4ch/unJrlI2oFQ6LlnxeolL1uygxsOjGoyCfYR1Qrhw7oiyIoYE8S4qlQBvSFO/cYeQzN01/fUOw95HB0SNdhIR7EJ9vrE1D1b6BMOfr04ukGpP3Tmefm+VbyB0rs9PojtAAPfd1FmMHYK8HBBNADBrGs2iI5isIo038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Osjq9hcP; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Osjq9hcP"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FBHhjb905786;
	Mon, 15 Jun 2026 04:53:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=9JwwIJTewOjYoSrws8qzFDhQ9NcnPXqD/cb2h88roX8=; b=
	Osjq9hcP+pxHbyYBKmo4oGHlWxJf5G7lWm5jUuuvVljI0hcRRR9q7oYuMhsSCK/4
	GBjlZnAYtviLvXX463earSM3S1fHDoWx+jG5vv0/VKpIvlD2Y6ojUEptyGrf6+tL
	6v0n8DdXc/x18PO0uQI65x7Lbb+0iqUd5AEMv9PN8tYj6beRQ92qhe21SyB890mq
	/l5gN5EbPpCAdUkx1B4kBav1h2u2PVXolxvBsVdVPTdv0LaIOaKNCOB4aN/NhsUW
	m5xQpBwnGFj2TVcDx0P6mBiOWoZcQE/1KHtxGWlt9jY98D6rLdIC6kLfST52jQ2i
	4GDmYVv/uPnbfklcceGRag==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es2g0abyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 04:53:24 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 15 Jun 2026 04:53:23 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 15 Jun 2026 04:53:21 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 1/3] ext4: skip extra isize expansion during mount to prevent deadlock
Date: Mon, 15 Jun 2026 19:53:15 +0800
Message-ID: <20260615115317.3549469-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260615115317.3549469-1-yun.zhou@windriver.com>
References: <20260615115317.3549469-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=ZJ/nX37b c=1 sm=1 tr=0 ts=6a2fe7b4 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=nphdFjCg5VZFgBW92ZIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDEyNSBTYWx0ZWRfX/MvO+4kbiGfo
 vo6NizUkEwBvYMWPtHiVUIlxHxFH2w2QsCznCw9Ayy97OoDcqVD5SPcWcTLialmeiHUqcp4d3j0
 u2vlGuRsweBFgldzC/jSHcTK72XecK3jWqXPRpodU4lewI1KWFotOZam8jANk+/17mgklqV64rf
 a5Z2WGXlG4+glkBtrlqT0MSTtFrebb+yCwHgEF1KWoAdJBo4tXorcKwbhi2FZhvxTtr1kaxY0KW
 y2dtKTtRvcd3UOFvJxGXnOBnP9mL2WmklVZ+KkIdchSZL1p8L8EkG3krohUJEwyl42iA6ThE/qf
 C1PU+V6YCiLPMo47u7yJBQ/z8itySScGNGsAoAr70gW4XT/v28FnJtFOtu3Jg/jznFz8ou0g3rc
 HCfrbPAfdYyyOERMNcpfs+Pe2x3vE7AehIqd1AYrhP9mAU8+8Vd+29+sRXPWTdYYXIAHal9qNiq
 5RRktYQG+aNed4yg5wA==
X-Proofpoint-ORIG-GUID: Nnb4ZEZ24RjqaiGGvVKOE6V3M0yPKyRu
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDEyNSBTYWx0ZWRfX6g29mgUpsrZU
 LoNl8GC0ENjilt3B8i7PHQcS8olvaBBTekAYzlfK5lHniFsuyEhicYCxrC6XqHJ0URityWkJ1Hj
 sHf1W5UEc4r6wnuciyNIyLBfNKMuLicMvV1Evs/rziCAwMx2qPFk
X-Proofpoint-GUID: Nnb4ZEZ24RjqaiGGvVKOE6V3M0yPKyRu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_03,2026-06-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150125

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
---
 fs/ext4/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cd7588a3fa45..be1e3eaa4f23 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6479,6 +6479,16 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
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

