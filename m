Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAB722A7F6;
	Thu, 27 Aug 2026 07:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787816638; cv=none; b=XVK8f3yHWXMy6nHuQS3QkL8gXyyIUwK+8YjwdLzxBTPtN+94Slg3PPsBQbIqUZXK+WodFMuY6CKnuHh/0H+nDpHtSIR9jfwkXD5Wg3HJDmmuRKx0jq47Ad9efYq2uvHHe3UQ+N7PI5N7oF096WsSJq0cNOc8alOn1XH/dm3WUiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787816638; c=relaxed/simple;
	bh=aRWu0BCR75bZA36JVsM6pSTeAyLk+1fRzVYLR+qzZ+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ShU+Zokae9CFp883/WSIHfjoJOfPCz4j4jcAhx0m4sVT5NQt3hTquB9oWNhKudvI81PJ75E6lVITHih7kYeucLnM59UIb2lSotgbFft1/fcYKzFwJfzvl5e5lXwmKGZzBtlcgjeSFfezjH9ZMjnfJMgoHZM/UEnCftWTwS0xzyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hVtmw6ljNzbywch;
	Thu, 27 Aug 2026 15:43:44 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.208.166])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4hVtmv4mp1zbywch;
	Thu, 27 Aug 2026 15:43:43 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.24.13])
	by zhaoxin.com (8.30) with ESMTP01b69ef6ebedde94149aef5b3f1450d4
	Thu, 27 Aug 2026 15:43:43 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: JonasZhou <jonaszhou-oc@zhaoxin.com>
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhuizzzzz@gmail.com,
	JonasZhou <jonaszhou-oc@zhaoxin.com>
Subject: [RFC PATCH] ext4: cacheline-align inode cache to avoid false sharing
Date: Thu, 27 Aug 2026 15:43:34 +0800
Message-ID: <20260827074334.616360-1-jonaszhou-oc@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>

struct ext4_inode_info embeds struct inode, but ext4_inode_cache does
not request cache-line alignment.  On the tested x86-64 build,
struct ext4_inode_info is 1072 bytes, so consecutive objects can start
at different offsets within a 64-byte cache line.

The embedded inode starts at offset 232, with i_ctime_nsec, i_blkbits,
i_state, and i_rwsem at offsets 352, 366, 376, and 384, respectively.
When the containing object is not cache-line aligned, inode metadata
and i_rwsem can occupy the same cache line.  Metadata updates then
invalidate the line used by CPUs contending on i_rwsem.

Add SLAB_HWCACHE_ALIGN to ext4_inode_cache.  This makes the containing
objects start at cache-line boundaries and, with the tested layout,
places i_rwsem at the start of a cache line separate from the preceding
metadata.

Tests were run on Linux 7.2 on a two-socket Intel Xeon Silver 4208
system with 16 CPUs, SMT disabled, and the frequency fixed at 2 GHz.
Ten normal-mode runs of each zjhbench workload gave:

                         before          after         change
  unixbench.fstime       488330.6       543996.2       +11.40%
  unixbench.fsdisk      1396385.0      1501352.5        +7.52%

On this build, the slab allocation size grows from 1072 to 1088 bytes,
an increase of 16 bytes (1.49%) per ext4 inode.

RFC questions:

1. Is using SLAB_HWCACHE_ALIGN for ext4_inode_cache acceptable when
   the measured benefit depends on the current struct inode layout?

2. Would it be preferable to enable the alignment only when
   vfs_inode.i_rwsem is naturally cache-line aligned within
   struct ext4_inode_info, rather than enabling it unconditionally?

3. Should this false sharing instead be addressed in the generic VFS
   inode layout, despite the significantly larger memory and
   cross-filesystem impact?

4. What additional workloads or configuration coverage would be
   required before this could be considered as a non-RFC patch?

Link: https://lore.kernel.org/linux-fsdevel/CAGudoHFgtM8Px4mRNM_fsmi3=vAyCMPC3FBCzk5uE7ma7fdbdQ@mail.gmail.com/
Signed-off-by: JonasZhou <jonaszhou-oc@zhaoxin.com>
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 245f67d10ded..11090fca1613 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1510,7 +1510,8 @@ static int __init init_inodecache(void)
 	ext4_inode_cachep = kmem_cache_create("ext4_inode_cache",
 				sizeof(struct ext4_inode_info),
 				&args,
-				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT);
+				SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT |
+				SLAB_HWCACHE_ALIGN);
 
 	if (ext4_inode_cachep == NULL)
 		return -ENOMEM;
-- 
2.43.0


