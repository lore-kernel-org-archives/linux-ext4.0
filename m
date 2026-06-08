Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADB23101D4
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 06:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780899094; cv=none; b=XbGbQ/IeQxLZA2Hu17oe/Pw5cpsFT/uh2zEmSqnshPTRsTVCYbdV18W4INyJ6JTBA6kOw/f7CPiMunNeZ0L9dsmP/LfBvEHzOS+UMG2jTP1vftTGjio8c/kc8YIthAAC8sF9BpoFc2FFyhB1klu7SBCOAn1IAdp3BXoICU2PPqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780899094; c=relaxed/simple;
	bh=ggtN0L8ikey3twLBnCupoAhgecIRjg6WCIrmKZIkfPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dRk91+2+YdFK2nhSUi+jOpMIHJKdZKVfFUWEL7YLPCJHLj1Fd8wBuucMQ6QmqoCWM6LbYZvnTJL3Iz1Ejcelna79gJ6n2lxamjsX41qaX+WUsEoc0OO+XeHBClNQidtUwSyW8hqSHJu7Jfh8L1sIyW/8bFKx0HoOrvXcxU5C1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lEx56AgO; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lEx56AgO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780899089; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=v1fDPh4Z09Gie6p5PrEh9ZYhtJ8+co83OWcdLrrDzCE=;
	b=lEx56AgO18IeZeJKetp7RZEDppPOyzPjVcIu2DXveuKV0w6SuwozqSn7HE2mI8tjm/fclzlIf87B+zuxE0VtTdU4cI6zU3MYxw0X6amQpwwphwen5zlp0ZmN8W6puTddedrMGLyRWosdgKi5aJRgiIJZrFPsrem8GYSC3SwcIJQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X4KLAnO_1780899073;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4KLAnO_1780899073 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 14:11:29 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] ext4: reject mount if clusters/inodes per group are not 8-aligned
Date: Mon,  8 Jun 2026 14:11:12 +0800
Message-ID: <20260608061112.392391-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The block and inode bitmap checksums are computed over a whole number of
bytes: ext4_inode_bitmap_csum_*() use EXT4_INODES_PER_GROUP(sb) >> 3 and
ext4_block_bitmap_csum_*() use EXT4_CLUSTERS_PER_GROUP(sb) / 8 as the
length passed to ext4_chksum().

If s_inodes_per_group or s_clusters_per_group is not a multiple of 8, the
trailing fractional bits are excluded from the checksum.  Those bits are
then unprotected, and any incremental csum update path that assumes a
byte-aligned bitmap can compute a checksum inconsistent with the full
recalculation, corrupting the on-disk bitmap checksum.

Reject such filesystems at mount time by adding the missing " & 7"
alignment checks alongside the existing range validation.

Suggested-by: Theodore Ts'o <tytso@mit.edu>
Link: https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260508121539.4174601-1-libaokun%40linux.alibaba.com?part=10
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/super.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3124..3daf4cdcf07e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4472,8 +4472,9 @@ static int ext4_handle_clustersize(struct super_block *sb)
 		sbi->s_cluster_bits = 0;
 	}
 	sbi->s_clusters_per_group = le32_to_cpu(es->s_clusters_per_group);
-	if (sbi->s_clusters_per_group > sb->s_blocksize * 8) {
-		ext4_msg(sb, KERN_ERR, "#clusters per group too big: %lu",
+	if (sbi->s_clusters_per_group > sb->s_blocksize * 8 ||
+	    sbi->s_clusters_per_group & 7) {
+		ext4_msg(sb, KERN_ERR, "invalid #clusters per group: %lu",
 			 sbi->s_clusters_per_group);
 		return -EINVAL;
 	}
@@ -5304,7 +5305,8 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
 		return -EINVAL;
 	}
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
-	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
+	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
+	    sbi->s_inodes_per_group & 7) {
 		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
 			 sbi->s_inodes_per_group);
 		return -EINVAL;
-- 
2.43.7

