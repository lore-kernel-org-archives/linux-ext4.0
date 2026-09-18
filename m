Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B283B4E87;
	Fri, 18 Sep 2026 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789726452; cv=none; b=T68A4fwZVzdUU3cJ/Dv65TbL6l3B2ncbsb628Lk+obt9vva8+hjd1HsNDTqqNdsPZt2udu+LkiGBdOwoeMcY3aQCzXokJ8bGyGRYepHVW7VAYcoBQeL5R4dsBT0bJrkJjAIODcUMqy5gJ6JlEPRGkwzSLho4Pu2BvhPx7kHhM98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789726452; c=relaxed/simple;
	bh=6YYj288nL3A7x7X8OeL7wLcwbvIuGI86AqM85QfuEA4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WyQyNecYrn1DL/6OVdR78sWUxeJrSla4TvYNHZklDsgZeLLKJZCngQelO1tytttU2VzzS1ufwdWsESRbodCUJWFRFD0qngSP/FN876tqTpFwWsi1Xy1+Apy0stH54dr2oHM+xYKaF+igTP/K3F73j+H2lRO0yu2RQ91XrNvePcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dZ2U+Hsp; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dZ2U+Hsp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1789726384;
	bh=z3rtAnpTaCBhOBulUgQk5hXYorxOdTRKUWGzxObqXF8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=dZ2U+Hsp7rSa+1hgxworcyfoFhtySh91A7QnaQWiKYRQI57y+RCqygK3PWrJnyT7s
	 EZGY7KBvCat9xOBWX0PoaZiajo99CeojSvwISeyjV3b3pMOp7Wj5gy+4WOHIJcp1bY
	 0Js784GJQbP6XSYobRnzEBFRtlCn05Kjz3vVmuq8=
X-QQ-mid: esmtpsz16t1789726365t4b52b81f
X-QQ-Originating-IP: 01JchSmDf3cfyE9ym0NCGe7/Ay5aYhAOf5Y/jluU7OI=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 18 Sep 2026 18:12:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11805283164246825907
EX-QQ-RecipientCnt: 11
From: Yichong Chen <chenyichong@uniontech.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] ext4: don't free the tmp_inode tree after a partial migration swap
Date: Fri, 18 Sep 2026 18:12:40 +0800
Message-Id: <20260918101240.3721805-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OW4JKxETGMY2Biz6KcG/VPV6BeuQJN8dat0sTJjO6qRQ6sYRr76JaICM
	GISrHtxeyM3UK4aDPJRhwxQClYP05NEobyl972iv9HSlTC5ftSehUNuPjn5RSoAWJzhF8m2
	yLK2Pw1aHcuQ+vT7gBZq0ottuhJi9XazPmEAUVX2FOifV4pn4otzScFWTbdUgFP2MpoOAht
	Wb+qu8S1yhFOr/v2EsJ8gi0BsXP0kz6TbgWPmOMNhTVy1pz0ogTcT3FJrfDLIwYI/mnR6Ny
	aufUxKFgSmu3GToIIHJdk5rtou7n8lIDom+4OLAOIaleToUIb1ASA4oR4wD23aV8A2kcwQq
	DWYCQ2h8+aeoahuAM3YQ5IBj27QjT5/d2v6sFwdWiOhQfeFHatiLKi/C++8S26RQXNVnRZs
	RPZ7UraRR8fZ4c5Ajs5EfBXBvl8QLjl83HuwywnRQRHf1a2XBw2+6fR8Sm27Pq9TKE0UCQu
	0DJa2XdU/zs7xAZaENO0mlFPy4A6tOUFixeYk6CeIIhr7iajy3u92rK6lR+0Hg/dXlSgYuD
	RAEbk5LQkTRN2KfLgW4wHqFpGNa/dShKvvcniQEp996E4F6+d4KlzSGB9YublDdY9s4wzeK
	xUwP0HIu6mAqm4fo29N9dpLE/IRoIqOdsuGMYX5GVRA9zgwn43Kx/G/GoZyKwA93lFbZf82
	T+W47DfE1Zx3Zd7tNZNQHJhIqWayNVhHiiM0US/j1MlSP7bo/93KNvYNPKw8Y/na8gquaUH
	4GzWE0wyXK8EoBbsYn7Y7uDaM16sLYhU65BAbMOotJtGj8IoDc6BxkvLmoP20h4lw0/F1pW
	T18+DUIH5VubdRZMleNY+BE3CALqgyjSRzniV81SvBiKGrAfMqFc6GNEhpR6tYHY4b4RGhM
	Hk+op4EZNJ/nvZHuPR0Oq5xHhA9zwYpxvhdDR58LuXCAE97LGXdvMhv/Xe7NAqqohAj1Qs/
	8zW2iPStqkLOAgZEc0GTmtmJmGDfnuHiUCpjVBy4GjLT1iF7DncFlju8hGcLzSNk+27LgyU
	Hwb09ziG8oxbMfHSi8bEtaVzqlwGofgSHAgL3eZqUdEP8HKMnf
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

ext4_ext_migrate() cleans up the temporary inode when
ext4_ext_swap_inode_data() fails:

	retval = ext4_ext_swap_inode_data(handle, inode, tmp_inode);
	if (retval)
		free_ext_block(handle, tmp_inode);

ext4_ext_swap_inode_data() switches the inode to extents and copies the
tree root into it before it frees the old indirect block map, so it can
return an error after the swap has already happened.  The copied root
points at index blocks that tmp_inode allocated, and free_ext_block()
walks that same tree and frees them, leaving the migrated inode with a
tree node that the block bitmap considers free.

Only free the tmp_inode tree when the inode has not been switched to
extents, which is exactly the case where the swap did not happen.

Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/ext4/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 2ce587043945..e588b4157604 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -562,7 +562,7 @@ int ext4_ext_migrate(struct inode *inode)
 		free_ext_block(handle, tmp_inode);
 	else {
 		retval = ext4_ext_swap_inode_data(handle, inode, tmp_inode);
-		if (retval)
+		if (retval && !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 			/*
 			 * if we fail to swap inode data free the extent
 			 * details of the tmp inode
-- 
2.51.0

