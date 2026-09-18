Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31DD4C33C8
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 10:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789726414; cv=none; b=FhL98zFvbgVtKtl/Rc4fgawcADt2XMChHn7XayuUqhG5qS63mS0jSN2ULZ415bNtxxExLjLeWfsdW6/0JBlKld2aXcsMBkuTZzJ7VIVEMXcFwGb63lFAG8zSVWsJzgWaWnLi71F1i6gk2HirQn5cAPlZAX0N2jdTR19Yy5X8cKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789726414; c=relaxed/simple;
	bh=dZHhw90Zo7hwyMM0KWsX/6pY2ExSGOUDO83AkrjYefY=;
	h=Cc:Subject:Date:Message-Id:Content-Type:To:From:Mime-Version; b=on0idD5Nc14bX0HfOOjGHBrVUYSuULHdSt9g//XdPCVaLz7njv7KMV0Z4Gw4E4rlGgXT7a/bO/4QCGW+MS/YhjOtYMxogul5HOV3/1XZtS89SzMhwDXiEyMI6SRjpYt98c+8wlYKB2dKJJagmBU506aRp01sJ5FAj/9GQ5iPcX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=nOS2JkU9; arc=none smtp.client-ip=209.127.231.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="nOS2JkU9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1789726394; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jUh0oO6Klx+ZE+PWk/0c8jcKPhTLuXbCHk9sShXLA5g=;
 b=nOS2JkU9i6ZySyKuqTa1toPHrOdppKcv171Y8ix4e2Ym6UP4y6JrZ6uZmhzKgwO5Un3HQ1
 KGvtf5TYSe6bNS+54h2soxzkt6Jt0WLn9ckbGDqI4RRUm1C07LHArPYdedjQTcp64WKU4R
 YjTjEHh/X+2Mguxq7Sx5ynged0YVL9La0vUaf9GG9pNDTjnfKBTsmfWApXmvuvb9D9Bnn9
 cZ6GsvWCyFmCi5H9UTg+g1CS4rmIkSaJ37/0eOre7lCqIcadwtxMYMP+b3VMxlaNhuNNEG
 8KZomwBWGJGjYKJDRu7uN7XA/Vp1cwVdIOy/cgeQav44A1eMTyzsWAWVbkKGDQ==
Cc: "Andreas Dilger" <adilger.kernel@dilger.ca>, 
	"Baokun Li" <libaokun@linux.alibaba.com>, "Jan Kara" <jack@suse.cz>, 
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	"Zhang Yi" <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, 
	"Zhao Gongyi" <zhaogongyi@bytedance.com>
X-Lms-Return-Path: <lba+26aad0eb8+74b509+vger.kernel.org+zhaogongyi@bytedance.com>
Subject: [PATCH] ext4: fix OOB memmove in ext4_xattr_set_entry
Date: Fri, 18 Sep 2026 18:12:49 +0800
Message-Id: <20260918101249.43643-1-zhaogongyi@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

A corrupted filesystem can leave an inode marked as having inline data
while the system.data xattr is missing. ext4_destroy_inline_data_nolock()
then asks ext4_xattr_set_entry() to remove an entry even though
ext4_xattr_ibody_find() left the search state at the insertion position.

In the syzkaller reproducer, the old xattr value offset is smaller than
min_offs. ext4_xattr_set_entry() then computes val - first_val for
memmove(), the length wraps to a huge size_t, and memmove() can run out of
the xattr buffer. This results in an out-of-bounds memmove and a kernel
page fault.

A crafted corrupted ext4 image can trigger this while inline data is being
converted out of the inode. Treat the inconsistent inline/xattr state as
filesystem corruption before updating the xattr entry.

The issue was found by syzkaller and reproduced with the generated C
reproducer. The crash signature is:

  BUG: unable to handle page fault for address: ffff8880074cf000
  RIP: 0010:memmove+0x28/0x1b0
  Call Trace:
   ext4_xattr_set_entry+0xe2f/0x1e90 fs/ext4/xattr.c:1761
   ext4_xattr_ibody_set+0x3d6/0x5d0 fs/ext4/xattr.c:2268
   ext4_destroy_inline_data_nolock+0x288/0x5b0 fs/ext4/inline.c:467
   ext4_convert_inline_data_nolock+0x178/0xe80 fs/ext4/inline.c:1222
   ext4_convert_inline_data+0x52a/0x610 fs/ext4/inline.c:2083
   ext4_fallocate+0x1a0/0x3ba0 fs/ext4/extents.c:4752

Reject the missing system.data xattr before destroying inline data, and
validate the old value offset before ext4_xattr_set_entry() reaches the
memmove().

The crash was reproduced on unpatched 7.3.0-rc3 and 6.6.122 kernels. With
this fix applied to both versions, the same syzkaller C reproducer ran for
120 seconds without triggering KASAN, Oops, a memmove fault, or panic.

Fixes: 67cf5b09a46f ("ext4: add the basic function for inline data support")
Cc: stable@vger.kernel.org # v3.8+
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
 fs/ext4/inline.c |  6 ++++++
 fs/ext4/xattr.c  | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66..0a30d40cb 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -461,6 +461,12 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 	error = ext4_xattr_ibody_find(inode, &i, &is);
 	if (error)
 		goto out;
+	if (is.s.not_found) {
+		EXT4_ERROR_INODE(inode,
+				 "corrupted inline data without system.data xattr");
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 
 	BUFFER_TRACE(is.iloc.bh, "get_write_access");
 	error = ext4_journal_get_write_access(handle, inode->i_sb, is.iloc.bh,
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5c310747b..9a0ee5779 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1712,6 +1712,18 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 		}
 	}
 
+	if (!s->not_found && here->e_value_size && !here->e_value_inum) {
+		size_t offs = le16_to_cpu(here->e_value_offs);
+
+		if (offs < min_offs) {
+			EXT4_ERROR_INODE(inode,
+					 "corrupted xattr: value offset %zu < min_offs %zu",
+					 offs, min_offs);
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+	}
+
 	/*
 	 * Getting access to old and new ea inodes is subject to failures.
 	 * Finish that work before doing any modifications to the xattr data.
-- 
2.39.5 (Apple Git-154)
