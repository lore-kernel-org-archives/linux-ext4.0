Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.204.34.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795762290;
	b=P4YETK66iZOfSzRXm1XyhFsP/zd4nNfu0ocVP1K5nQXMu22IYOxvhNbGzQAQuUaM9qkK
	 MxfAd1gLaiH9lbsFEN2OfhTTxhOkY8nxZjgjpEH0Uuj3uRgeWRRx+tiPz9CDGliMqQGAk
	 zh0NbrLc0MthWonFN/k0nEJeeTdMsWN0i3CpkLktLA8sKBgJZcpXKoF1p7LiEGr0OgusS
	 QF3101go2o4qu0zaMwLHPOJddyCEuHa5XjhxK5Ac6aCl4NvqkKklkc+83KnmQkjpSHsDT
	 DEdlKUGQie054foOn+LiZNnkrpBU3e+LBmu87zJCQj+NHbvhUJ3h0Yh8KG2pS2qRMCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795762290;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=cvnXua/nHcgLtSt6EsGSNHAA3wqFqcuIHEJ28ikFwvc=;
	b=2tA3UP9MAQeZl0TL30RB2rt1woW2Znet4S4OJf93kt53Z/ZWZG8SZV21EsZfUJOuqaOm
	 JaI3fzH2bA9w3PkVt3MRFySo39zhbQvWtAB55mpsBQ9eMIswTeUem8hpnkgN+2obFMuhm
	 J1OMeJ+Z2gNCB1S8vjX19rceWTmBKC1uGzwaLL54G51h4x9eZS/jkilNtToo9dNimpCpx
	 OPhLB8tEOogomiH7Y4fUt5m3pbiBFrY0KCAgmiKA6Xrb1myQxN4lswBAzPXBre8LtJOtr
	 6JPMbt2+dEF4P3AyBMM4pG+Pfs2l8Hy8viXHOhVjMeCEq2n3tmQwMeOAc3HR/FuG40w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=hvAGFlmQ;
	arc=none smtp.remote-ip=54.204.34.129
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6BE606A31E;
	Fri, 27 Nov 2026 06:51:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D6BE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=hvAGFlmQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1795762237;
	bh=cvnXua/nHcgLtSt6EsGSNHAA3wqFqcuIHEJ28ikFwvc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=hvAGFlmQyR4qWebKCdX5v85Oa8VBibWkYhFH2ehoMJk97btFeWJYvnObHEoyR12ou
	 Y6j0GlV4cqC9hgOCJ/wxZoeka+OuwfoGS6yNiobt2gZmxC7W6TURzbdmw/+zydNLS9
	 x8uS5zEEKLdui11AvoOUiimVC0ciKWe+cCPOe0Kc=
X-QQ-mid: zesmtpgz7t1795762172t89614fbe
X-QQ-Originating-IP: Yv7xVc8yer1gpMf4TXe0Q8fpjF4+3IvlLh59L2vth1g=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 27 Nov 2026 14:49:29 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10414204801948035402
EX-QQ-RecipientCnt: 15
From: jiazhenyuan <jiazhenyuan@uniontech.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	gouhao@uniontech.com,
	niecheng1@uniontech.com,
	guanwentao@uniontech.com,
	caina@uniontech.com,
	zhaoshuang@uniontech.com,
	wangqing@uniontech.com
Subject: [PATCH 1/2] ext4: fix buffer head leak in ext4_ext_precache()
Date: Fri, 27 Nov 2026 14:49:25 +0800
Message-Id: <20261127064926.135945-1-jiazhenyuan@uniontech.com>
X-Mailer: git-send-email 2.20.1
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: NGizNBd3uSau65nQ5TIxSPLGqCKj77fqhIOOuxLxSbDFxssUq7MVpyWV
	bdHyj7ESCzFuzXsRLbAEKkcAWPXRyZG8lZPyDqn23de33Y3C75sxboDTdC07lAuaGRDEjzC
	0Q36pXmxl79EhYFHpsGEQhUMxTX8J6cG41bk7WOqROFCQ6VaiV8t7fs/AsqrfGUP4r+5GFF
	y2vaDHGACpKuRQMY7dMlIc4CcE6i3MZEKyaIxzjNvAu8yFzLoacTam2BxsPlRg41Y6MXlPD
	Ght5u1553vyeJn8/CBwfVN6+F9SQmu4iOpShCcDlIprldDBF3ODxJ79/S9PNRTORBowtpKl
	UoKxxBPfUJLSiq5wEVgDuSeMR1fRd4CO95FxYaKVh+Q0HXJY9S6/h2egg7VFw+SdtBBrO0R
	djQOj5ttFTDrVIB0Bart/ZzBZUT6uaYCMa/5OxaPFH0YGGFHHzH3UigNzUABxhCBLN+Tzv1
	uBVzR6abMRFwZg/rPSTpWLr8ZKfe+3hn/koeqk5hYh0Ufp32oW15sZIjzBf8492cknZ+1vn
	ymsWlG4iNrcfBjnvlnoL/69B7DK1lHdr2EvSVOjOwOXkHUCwECUfCHKgdRfFIKzJrHhDInc
	ccg+LLm6Xy/IixvpeWQcq9e/QbnpaWX216bybnBOzcgQCx9wAtADf2GfnLSoe16xceEdrPB
	cEFOnRgh7dEy54JHIbfawWPG9gog2GBbOkx9PY+nNbdP9ih0Ai9CeWwShdwZlMz+OgW+nEH
	HACeN+xY2WHm9rehnhZqX+H+H9MDbZu71Z4LPlqJNsW5BsAlXLD2zGAiKB+kMJfm2N3yB3y
	TYoePLwLUUH+EzD7I8s7Q2xRdVhkvIR3iK8+ved+pDH/VjUmg+yv0QXUNzOld+zDOYlYtq+
	lPS49v0uETxoxy3LarzY8RoerhE8bnmKmmiNPpyPFQmArNEzCLwCq4AKC+XYwhYrBRYUKKz
	AHRYKHnKzDREIuh5AxUTs//c8BvE/06CBkeCgFy+WWVbgPuaeowwe2TIIbVpAwtzIjBWD1J
	o+YLmgU1k6zt5tpR3yL96B2031e4x5uN9H4IRi5cFtsU9CJohz9wp3R5yd16UYBwSKBXhmu
	I4SkvZoQiOK8SA8XXgc5UMneS0Y+CSZbQ3zyt5FJzgB
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

ext4_ext_precache() stores each successfully read child extent block in
path[1..depth].p_bh. During normal traversal, these references are
released as the loop backtracks. If a later read fails, traversal breaks
to out and calls ext4_free_ext_path() before all ancestor references
have been dropped.

path[0].p_depth is not initialized, so ext4_ext_drop_refs() only
releases path[0].p_bh. Since the root block is inline and path[0].p_bh
is NULL, buffer heads held by path[1..depth] are leaked.

Set path[0].p_depth to the inode's extent depth so cleanup covers the
entire traversal stack.

Without this patch, the KUnit test added in the following patch reports:

    # test_ext_precache_read_failure_bh_leak: EXPECTATION FAILED at
    # fs/ext4/extents-test.c:1568
    Expected atomic_read(&bh->b_count) == 2, but
        atomic_read(&bh->b_count) == 3 (0x3)

Fixes: 7869a4a6c5caa ("ext4: add support for extent pre-caching")
Cc: stable@vger.kernel.org
Signed-off-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 fs/ext4/extents.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b65b0261ee5c..4c775aa41459 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -638,6 +638,8 @@ int ext4_ext_precache(struct inode *inode)
 		return -ENOMEM;
 	}
 
+	path[0].p_depth = depth;
+
 	path[0].p_hdr = ext_inode_hdr(inode);
 	ret = ext4_ext_check(inode, path[0].p_hdr, depth, 0);
 	if (ret)
-- 
2.20.1

