Received: from out28-196.mail.aliyun.com (out28-196.mail.aliyun.com [115.124.28.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9EE370AC1;
	Mon, 12 Oct 2026 06:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791785656; cv=none; b=u0UwVLDt1uBlAdG5Ir+uDwPvaqrD5OtjoFVC8cksJPw0M/lktdQW3bHnTFZr6U0HdUxWSsFib1Ip8YnVolEOyNte4LlzL7y0vTo7fpmcYorRwKs0gyyfI1vajel6dNToBqVvr1AKp87nFBMWVGy0IJ8801lHJhOqE8gMdn8Nlaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791785656; c=relaxed/simple;
	bh=G3zia0fAD1Xjp5IB9tmukHlhULFPWd/UwqU36D5fWWM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AMqohwpus97rLRR30K2a7VufBiyzCdDPZxkLFIncCmkPk4657PifZ8ZKGFM5VwKhYAogID9qksEqfZNlOSkm4pF0R++OTGTpHo8AGNGuYfBzGQawCThVNaO2WROIuEtFg+kWhPXmNu+NwOHFdouUJ53/IcIrLwaOx0+LiZ/J3A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=P6yzpfXJ; arc=none smtp.client-ip=115.124.28.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="P6yzpfXJ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791785646; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kjnA+HKIDKMdO4iTV9A0Np7u/MqM+l7JBDNldFYKQJM=;
	b=P6yzpfXJ6R/qdJw3MnEiS7weJUtqt6u9pfHIeNWf11poHeZKAvc9c2sNYcWEnDWuE5s/5gTpJheghkHqlfpW620mAIaQWeiVob0SmochpAJxIj+OKbsmUB2o0G8/Hcmn9GGzeFrZf8oTXSBU4RWtS2GmwksJE1ZE16myQU+xwNw=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07654795|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0209884-0.000911751-0.9781;FP=9707083562314532082|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037032089;MF=zhugl3@xiaopeng.com;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.jZhXNTs_1791785324;
Received: from DESKTOP-UL5U09E.xiaopeng.local(mailfrom:zhugl3@xiaopeng.com fp:SMTPD_---.jZhXNTs_1791785324 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 14:08:46 +0800
From: Guanglei Zhu <zhugl3@xiaopeng.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guozh23@xiaopeng.com
Subject: [PATCH] ext4: check CAP_SYS_ADMIN in ext4_ioctl_get_tune_sb()
Date: Mon, 12 Oct 2026 14:08:44 +0800
Message-ID: <20261012060844.836001-1-zhugl3@xiaopeng.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_ioctl_set_tune_sb() requires CAP_SYS_ADMIN before changing the
superblock tunables, but the GET side has no permission check.  Any
user who can open a file on the filesystem read-only can read the
whole tune struct, including the 64-byte mount_opts string that
mount(2) stored in the superblock.

Require CAP_SYS_ADMIN on the GET side as well.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
---
Verified in a QEMU guest with the ext4 image on a virtio disk: a
process demoted to uid 65534 reads the tune struct of a read-only
opened file unpatched, and gets -EPERM with this patch while root
is unaffected.

 fs/ext4/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c8387e6a2..d7125a8be 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1284,6 +1284,9 @@ static int ext4_ioctl_get_tune_sb(struct ext4_sb_info *sbi,
 	struct ext4_tune_sb_params ret;
 	struct ext4_super_block *es = sbi->s_es;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	memset(&ret, 0, sizeof(ret));
 	ret.set_flags = TUNE_OPS_SUPPORTED;
 	ret.errors_behavior = le16_to_cpu(es->s_errors);
-- 
2.43.0

