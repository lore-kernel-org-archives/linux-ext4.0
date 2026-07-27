Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A083365A14;
	Mon, 27 Jul 2026 11:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785150037; cv=none; b=ti+37kT6xiqg2tLXh5iH/U3zXes02skjVOVc8A5Bf6wUzbLzEaJobyRvkneBW+BJv3MPKm2GtSmGMmOCveYi5aF4nbhW0q31vppsSQ/euSaMsGQ9QmYzIvXr+J5DqKtZ/2RutiB+vLQ40FCUn8sGvZqMesfcnPZYe8LpC/4gJiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785150037; c=relaxed/simple;
	bh=bkzUILaf/GfT3fmWiePhHMw/EkyDFKEM9tN67C8jH5I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KMwn/zg2jSXjLfVz03P1pM2KFcVhGJNxOgh/HT35BerYoDDOhbudNQPI1XiEGSOP+5yxtgMd7fN6mx3/a23+VPaLJFVLhFk0xvkUsC6oI/MK5rhyyylBwqtY6MqEDZvIgdred9BYmjE40HDhIndsbKCuegLPo2qFD7Vm7MAt/tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=GxB9Oc/5; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="GxB9Oc/5"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAOA3Q512943;
	Mon, 27 Jul 2026 03:54:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=wbVL8wR2p5kAcsRz0BJc4YQSzZhsPH+Cge/LCwi5Zj4=; b=
	GxB9Oc/5MqNG64EH44eEvymCtEX7CJCf0b/0zjFQOwXP48URO2SlSUG1NIROWnWB
	jW5h3WkgMw91wrQNoiNpJO/qmhE6I1KpVtHFStrBEnU6fzdgXBNvN2v+/A8tAx1Y
	NEYInoRgruDOHI1wD4ROPQ+3HvGOs0FjAiFytz5j37ZvKYMIcELc1b37Rlhyqhzy
	6AKyhouf8WmTIMwnbXVJktKZ94EqovQWFfUFKacjVqJFxNK4AHQwVpyEULKUZ2cW
	NVGB6OzsvfvMA89ZCB43/INSPz6oogW6Ry/Byuzc3O5Vtw0PaPl/n+wt0mCumMMP
	9yQduCZUuRJocrmw1d4KOw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmre01vyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 03:54:51 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:54:50 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:54:48 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 2/9] ext4: stop creating inline data for new regular files
Date: Mon, 27 Jul 2026 18:54:34 +0800
Message-ID: <20260727105441.3213095-3-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727105441.3213095-1-yun.zhou@windriver.com>
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 3HYrCyW178-DcsN8rTEacd2_LqAoHJEm
X-Authority-Analysis: v=2.4 cv=E6z9Y6dl c=1 sm=1 tr=0 ts=6a6738fb cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=t7CeM3EgAAAA:8 a=q8Co8EDd4P4rKw-q85oA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX2g6XC2S+746N
 tY40c3E0Ku4Q16bL/vrqXlt6/TdcyoWTp1TPrQF/d2g3UHsMzY5xSjsceq43zssOT5Zscr/qE/K
 n535CtIogu+ABRo48IP1Nqds5oFmYqzL9otNJq25xfoH7h/zAccv
X-Proofpoint-ORIG-GUID: 3HYrCyW178-DcsN8rTEacd2_LqAoHJEm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX6FAUMamdSiLL
 arQZ+UmGh/48pcF2UB/jrBf/JhU+6bapdXc1EqH8URjLalAXph9X7JjdrK04iGnOd9wlN2+XjCu
 geasIa+rEBdPACUL03U0FKesnnTE293fj4GgxEuPguItpVTKhq+LLCoRJiZEiXAMVPaoP4wQcNz
 oe7Fx/t7qhZ59G93gH2aJUHSzsUqSIPLoG0TBgdt0ExGE+63XR9qLAsICanDWDtEI42fZWXvBe1
 2EXgIgNSrIBL7OKIryFLtUZU0UPIt89f2Bke+gYw/t4Hl92+0o4aWY5DUvXlSyCR4KVeC+fw0gQ
 J000f6iw+RDpitncMKBRcNmEnm21TSzEUek/6fEtEFYUswSUmBMoiHrkXhlto+KppzSM0TmmuQK
 eLaBLLi+CSunPUE5P9af+TWbGPHNhXV5mY3sKVDmb7HcTmA+EDL2EnvBpTn4+hJzYjKHmsQbwse
 6DD4S/SJl63WZJKjt4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Stop setting EXT4_STATE_MAY_INLINE_DATA for newly allocated regular
file inodes.  New files always use block-based storage.  Directories
retain inline data capability as it still provides value for small
directories without the write path complexity.

Existing file inodes with inline data are not affected -- MAY_INLINE_DATA
is still set for them during iget via ext4_find_inline_data_nolock().

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/ialloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a40cb27f8116..278f0ab8c996 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1305,8 +1305,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 
 	ei->i_extra_isize = sbi->s_want_extra_isize;
 	ei->i_inline_off = 0;
-	if (ext4_has_feature_inline_data(sb) &&
-	    (!(ei->i_flags & (EXT4_DAX_FL|EXT4_EA_INODE_FL)) || S_ISDIR(mode)))
+	if (ext4_has_feature_inline_data(sb) && S_ISDIR(mode) &&
+	    !(ei->i_flags & EXT4_DAX_FL))
 		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ret = inode;
 	err = dquot_alloc_inode(inode);
-- 
2.43.0

