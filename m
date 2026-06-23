Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562053B993B;
	Tue, 23 Jun 2026 06:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782195583; cv=none; b=IdSA01PfXAvOymnYia7wMD7fuI1xyug3tnzRYFMdFq6YuHTnAY1CQeNHEsuM9XYRZ4BLXH1jQ0zjop+UGlJQuEFAuLQk/KovVnAOw96grA4tv5vxmxhUFkUUvKCAgGsZZa/ZtFchTYmNRSSStcH95mWAh2PiHGMxqjyEIWHCqdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782195583; c=relaxed/simple;
	bh=RJaaqUBjalK1z/fA6HWyf/+RuPp215MeeRWeEoAxZmw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wp3Jwmnb9NCTi/qwTYYzwygn8Xs4OgTYcI6uVVnsmnl6nQ9ONYQZoO2PRZaBZZAuu8qLLT9PrKD7TZSViHzk5vm2tbQH3lduXNTxajBvv8hQizMCW5IHTvJ0zCHHkntkWYEmgTg8BXmdTUtcsyK+2X0c3UF2jz3bL1UQLYnu0Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=g0YsqXf5; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="g0YsqXf5"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N5CH1C3581049;
	Mon, 22 Jun 2026 23:19:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=YlOhf/JchjUXFNgxcygVe6yrQN6XjhMu7qH7iJ4wXu8=; b=
	g0YsqXf5ed0xJzMD49wE6fUOenS/wS60tnejrbTgpl5OhU9rE1jbpVf0c6TQE4k7
	40Oqh2Htc7MPFT1pylKqIpd2QP4lLvi0vh8jXUW24Q8CBYZlL6ZEoTuhTYb/6c8M
	EuVSra/sbmVkpQ0wXZ3VNg85BOh187tF1hL3isJaZB0nt1pMYk3TcgKphNpnKV1X
	Vm72oS0CoMcA6CwzrCLGLsMSrkuhYfM2lEaJUruyL4zSbU6Dn89PZsmf2CtAtgHN
	+DEYMkEPIimZITDx9llHY1sx6+rZ0DDDXWvE+H0aYTU5dEjukpG08cPZIeAEsbfC
	p/jcIKE2lpAN9jW/IFyXqA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewtcctqu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 22 Jun 2026 23:19:09 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 22 Jun 2026 23:19:09 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 22 Jun 2026 23:19:06 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH 2/2] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Tue, 23 Jun 2026 14:19:03 +0800
Message-ID: <20260623061903.2148767-2-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623061903.2148767-1-yun.zhou@windriver.com>
References: <20260623061903.2148767-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA0OCBTYWx0ZWRfX8EojG3FV/wp/
 gyOBIspIabD5xLqu/OPZhW9Go+0//D66JlpXCIAC+m+xu9TW7o8qOSA9Vtkhh5mvTYRdcLnTONA
 t2sVwk+cXtCQNpTo2XyMPQBAgXIjgzydL2enAO56vwWRpJrzEw0/xVzH1zTbWDtcgPCPcOh0mrJ
 bYXhIkoNUBv9eGKzn/KUzXS3wXHfooELde83vpF4I3jXyC0PvMjsICSRO1b/Tw257nJC/lO1hrA
 UgtfGgxuBKoDbA4GGA2huV7JcOihW5Tr4rQm9Ewk5SbKyML275kGrFltKco15aF0GWUw6dMMfbo
 T897b3UlzQNXwuKvHhqi3KlKGZNxTljkoAqvs5l3EL6BIssvM3ha4ECyzjREvusyfNQJgCuL6eo
 HuxY6j4A998ZgjjglsYBx4uKbzPm1xnVmfCUCPH3i9XMn/Qh+wf1c7Apr5tYru1FBqcG1TMAGzb
 x9E2DjiLwq7ZdFv/YYw==
X-Proofpoint-ORIG-GUID: RjXKetorSj8fx9T9im0bbzEdDrYgIty_
X-Authority-Analysis: v=2.4 cv=GuVyPE1C c=1 sm=1 tr=0 ts=6a3a255d cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=5t83pWKoPL1BlknkHKcA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA0OCBTYWx0ZWRfX+JGfAj3zEuqv
 9T8Hw4GUQu687lY034MH5yzQhiw9u2VqpFVzUx0t6gUhSiwWJjxKuUS8WBn6N8kSZuUEebFe6B3
 zfVFs3J8W23KJ2PKR2/BOZ4nCsTTLe8AvkcIeayqxGVmj7Js2b+H
X-Proofpoint-GUID: RjXKetorSj8fx9T9im0bbzEdDrYgIty_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230048

An inode being evicted will never need its extra isize expanded.  Set
EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
to make this explicit and prevent any unnecessary work in
ext4_try_to_expand_extra_isize().

This also provides defense-in-depth for the s_writepages_rwsem deadlock
during mount-time orphan cleanup, ensuring the expand path is blocked
for inodes under eviction regardless of how they are reached.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a5409324d965..0d131371ad3d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -264,6 +264,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.43.0

