Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C8E40D587;
	Sat, 20 Jun 2026 01:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781919666; cv=none; b=GYQxUPZfnmYuBOso4MmH2E+MWU4b/PMWy0892LSka5TbpTOpz9PiPnYSrBwHmNUweMFBYBvo1lgQBGGnhQCfewxG+ObqrXWwTdSY5J1tMO5MqIX+nq7dTwo6cTis9cjDJS7CYBrKqgLri0zfxNpb7U8pz1cHKm8bbzrESMW5YTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781919666; c=relaxed/simple;
	bh=v9tztnzpoAxDrc+KB7Nv3vOPFOsumE4Cdy+fmYWB988=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hRw7A2aJ7shwQMr/HC443PoP82q1HK399fOamDmuzOgFoPt3iYhVHnrPNo3UOvgeeVLDp31nvwDIjiDvy9S7/lW3FRbK9CMot/v4bF7kOwp+ad3ypZ/XiRgXUBIScgG3glCvMg1ZvsM38iUiOLkoapw0JvzHOetkZSqzEyF4oMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=mK+ZFpQH; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="mK+ZFpQH"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65K1Ul2m3823382;
	Sat, 20 Jun 2026 01:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=o+YbTNDrpGoCI17M/gyztRKnpqxmFLPvuZGkMYZReY8=; b=
	mK+ZFpQHkeOxSMVWeyjNE/y80r2JwWX+B7MhX8tSqRqscD8ZnXiY/H5rs3TCGusi
	oQDgwoB16wtfbpyhcodLdvkOdGFOvzcD43gPJQYlC/LsHYbeL0+JnEK4fHMcWIXk
	Vg6O8QHAnvRgmUxlJ3IY9AXDQowvVkAZcDCowG6x9rccKA23beTQ05JN8OcyRfvS
	UT91+0e/QXd3GnKiOWWTvnNoPY1A4Z/QrptERAmH+mTq5w7yVxq3A9q+rCOQj1an
	YPA7cOO3VNHhADDM2YeVfXB0CI5tJcGPUDXbjExmjIMmw/IDGBLGhSJ8jUNfHN92
	MI8ggoCAYOkzLMnd9n06Yw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wr1su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 20 Jun 2026 01:39:47 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 19 Jun 2026 18:39:46 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 19 Jun 2026 18:39:43 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v8 2/4] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Sat, 20 Jun 2026 09:39:35 +0800
Message-ID: <20260620013937.2564269-3-yun.zhou@windriver.com>
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
X-Proofpoint-ORIG-GUID: Oz80VuCZ3AGzkky78biM_my6u9beKrkV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfXyDLeS3n7RKGe
 jqINttp9kr+qLvlhwAnexhNZGEMu/7RVUgy37FaUwkNdardqwa4eweLm49eX21ATBlaOS2NRJJk
 WtbYHuLo5ejjy9UoCGsauEdgWE69CX1mETl9+pYWksEtsmtAp0ZK
X-Proofpoint-GUID: Oz80VuCZ3AGzkky78biM_my6u9beKrkV
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a35ef63 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=5t83pWKoPL1BlknkHKcA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfX9CKETWbNRtjD
 JzEXuJoBBUgbX+yMsfaGm8ooW7kE8T4QcZZh9aqn+VTFr2S7vPzcgXdwf3YJFcopzEAjSNsZGhC
 nSvh7BGNkg4Grx53E1vzxfWA+WWZV0wWmIzWSoueaMzU38euJjIzfLyw8jRAO+DbwhEEzHvdbIr
 oijVTqvJ9M9SlkDalVudUyIe/XaXCRsXKubQsz05BtD8umWpFObpvt3Mpj+cFjG5ajpdBuQ46UW
 Wd8Ao7goEIfsDWqirwImATxWOwkJDbJgBAH/pTbn+/DoxMW0msLXXRmKVl7HjnVpMAcCc3njOJ5
 OGKMjjLtM92oJD7TYcLu2AgXmQc/HxHMYn2p2RuP5zgW79CIe4ljdggeulk+d3Wq7Ef8Us3+T3K
 rcoHBb9pmp2RE8EmT0VhR6rXmaRBmxEM0C1T2qgfitrj4ymsCTEw7+2vhooXz2fyoROAR8xIlCV
 UigRRM2mJZ/XUX4xT7g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_05,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606200014

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
index 09dcfb6bf48c..1de0aaa28e63 100644
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

