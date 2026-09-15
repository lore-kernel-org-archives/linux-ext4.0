Received: from out28-196.mail.aliyun.com (out28-196.mail.aliyun.com [115.124.28.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E64374A19;
	Tue, 15 Sep 2026 06:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454701; cv=none; b=E/KOtSGBLbO6RVF6UXztMC7pfHnwqSOphOKOuaU3sCG7mu0jIBqC5QcelBjTOXtZT7/Sex6dSTOWxNOv81f22oAcDJypeN4LAlRsVzuR3A8qenPEBwEGQ8fVVfPuPK65ZUUWsGC3Nr6XYpzhXZW8Jy1vtmd7gxtlI0w2luttp40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454701; c=relaxed/simple;
	bh=gR8ykoNNGOuqw7M2sfr0VVZc2JkCEwrcqwbqvJ638xY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=In0VwELBZL2NN+Lb4RqDKKVmLwUWzOBG/G39cPfhIQuSchdQQQY7+as9eMXIonQNg0DNnevvEsIEOZFvSdLy1NGIY21rYARBMbKuPxgpF/fGWa6E/Goa2xT6QUKBmHma7ijgNBhVJa5LerosaMp3LSfFVjMdlLDlUWzUqCSMEDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=noC9yu0/; arc=none smtp.client-ip=115.124.28.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="noC9yu0/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1789454694; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=eTr0M3JncHKsHc1wHe64uqrYo25gtOIvU5HOPeRozyw=;
	b=noC9yu0/b/iH+NyuS7l5VTZQe9hVYpMI7PCd2XGEO7mhNjNiVy7giN1oSgGPvbCFvXMqa5jv0IBnOwbYZNcbNUwhuAa7TF18njCed8EFOQIYCw3mM1cPiE3RtFqsvrFIWzaSm04dfZsxaysO0RRgHIiFjChFqttw8Zr/fHWvtkQ=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07701874|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.123133-0.0033672-0.873499;FP=9645340444432270914|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037022039;MF=zhugl3@xiaopeng.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.jDy7Am8_1789454693;
Received: from DESKTOP-UL5U09E.xiaopeng.local(mailfrom:zhugl3@xiaopeng.com fp:SMTPD_---.jDy7Am8_1789454693 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 14:44:54 +0800
From: Guanglei Zhu <zhugl3@xiaopeng.com>
To: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ext2: reject xattr value overlapping the entry area
Date: Tue, 15 Sep 2026 14:44:53 +0800
Message-ID: <20260915064453.249419-1-zhugl3@xiaopeng.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext2_xattr_entry_valid() checks that a value ends within the block but
not that it starts after the entry area, so a corrupted block can place
a value inside the entries.  ext2_xattr_set() then underflows the free
space calculation:

	free = min_offs - ((char*)last - (char*)header) - sizeof(__u32);

and writes the new value before the start of the block:

	val = (char *)header + min_offs - size;

Check that the value area does not overlap the entry area and refuse
such a block instead.

Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
---
A crafted ext2 image with an xattr entry whose e_value_offs lies inside
the entry area triggers, on a KASAN build, a use-after-free report in
ext2_xattr_set().  With this patch, setxattr() on such an image returns
-EIO instead.

 fs/ext2/xattr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 9b68c490a..2b89b758e 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -485,6 +485,14 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
 		if (not_found > 0)
 			here = last;
 
+		/*
+		 * The value area must not overlap the entry area, otherwise
+		 * the space calculation below underflows and the new value
+		 * would be written before the start of the block.
+		 */
+		if (min_offs < (size_t)((char *)last - (char *)header) + sizeof(__u32))
+			goto bad_block;
+
 		/* Check whether we have enough space left. */
 		free = min_offs - ((char*)last - (char*)header) - sizeof(__u32);
 	} else {
-- 
2.43.0

