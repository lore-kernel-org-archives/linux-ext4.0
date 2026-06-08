Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A80C346E70
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 11:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917126; cv=none; b=CeKa5hu/KacrccRKolA3SwUJ8ynqiqAZP/yfGTwMPro3UCb1KiD6bFVpxZ5ZlzZV9yxd0idsvxmPWk7At7KxI/b/c4RQUnO5SdKOegAxA+Czg0J7hHhWHHfX1Z7Y3qAPB0wHzhXMzhCNsB8FqsLNW4m+a79d+Tvt3j0T01P1ExM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917126; c=relaxed/simple;
	bh=M7yrcL/EzM1tz/bSFknfQeNFsncLaVJd/iSeSs8fgjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gEDh0P/dxwkfD1yQAL77BI6Hw31wZk18NrpV5MZcN5yTzJCT5buP6V2Es5MVM2yy7nviH/Zb6DlxgeTO+vw6en4rOcO6s/Xke65axu82TCUlz1CDbV7PpdFORQRmF56xsED/xVm0fn5gZDya9K5eI3Al8MeKbco2P7I/LBc/GJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Tta5IHjM; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Tta5IHjM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780917122; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qJ4c1jrpBGmta4Y8+T335OrN8ukx1Sm8v2BMNxxp+QU=;
	b=Tta5IHjMJYF/9UddEkHXTImbj8xiZC/cJXcNzBChmZtOq74sCIzzpaBsVvL6JSVyURzKwKnUwVOYD5k0Aqt+K/2lRraOxu9+gBduc7a7aP1vukCg8vkoPcJWax9PBWFPmKyZb4N4AuCtn4lu8w6ikubp6WlUV1rfPyIvAhk51vc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X4Nw8OR_1780917110;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4Nw8OR_1780917110 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 19:12:01 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH v2 0/3] ext4: tighten mount-time superblock geometry validation
Date: Mon,  8 Jun 2026 19:11:47 +0800
Message-ID: <20260608111150.827117-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
 * Patch 1: Removed a spurious newline in the error message format string.
 * Added Patches 2 and 3 to fix additional issues reported by Sashiko
   (independent of Patch 1).

v1: https://patch.msgid.link/20260608061112.392391-1-libaokun@linux.alibaba.com

This series adds missing mount-time sanity checks for superblock
geometry parameters, preventing crafted filesystem images from causing
bitmap checksum corruption, integer overflow, or out-of-bounds inode
table access.

Patch 1 rejects filesystems where s_clusters_per_group or
s_inodes_per_group is not 8-aligned, since the bitmap checksum
functions operate on whole bytes and would leave trailing bits
unprotected.

Patch 2 reduces EXT4_MAX_CLUSTER_LOG_SIZE from 30 to 28 to match
the documented 256MB limit in mke2fs, preventing a 32-bit overflow
in the blocks-per-group consistency check on bigalloc filesystems.

Patch 3 rejects filesystems where s_inodes_per_group is not a
multiple of s_inodes_per_block, preventing truncation in the
s_itb_per_group calculation that could lead __ext4_get_inode_loc()
to read beyond the inode table.

Baokun Li (3):
  ext4: reject mount if clusters/inodes per group are not 8-aligned
  ext4: reduce max cluster size to match documented 256MB limit
  ext4: reject mount if inodes per group is not a multiple of inodes per
    block

 fs/ext4/ext4.h  |  2 +-
 fs/ext4/super.c | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.43.7

