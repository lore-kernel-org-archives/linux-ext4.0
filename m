Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36D752FE40
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 13:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169759; cv=none; b=sb3yZ8m2gh4OUyj8VWWCgAjHoSKNfekiaRz7O25zLBx8UMGetJAGCTZEzitkO2eoERuXEg8zQpcWTnn5wBi111WBMoeFQy41z871YGmsXlUV72pI/nULmoJFWscy2DDNuJCOiQlh7i8AvrljXw1BVv683pNLN1xqEPqeWMceNBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169759; c=relaxed/simple;
	bh=McLHh27bKU4NcS+BWnlFB5U1ZtaThbc8HnyCvTeA72k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CEckFGpxyDlEyoBk1a5gcGKuEHm8vEFMMIX8GzJ2z4W53oXwSMGE8J1vKRphRMh655+VDWw7do06Uzblfcjgia3CuWdbUZBZRCePCST3TMJahm7NnMp56ApY37JYLojXF5EcRMFra2z5D1SK3Cbu11F402ahJKUybAvnWHF3x/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GVbhpwZl; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GVbhpwZl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790169752; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kty9VEdQczxTARde9umnXNvIvp61XHrJxSc5DKx8CAk=;
	b=GVbhpwZlSINlrYPKo0JeaGQoK4Ab6I3x9cs9NWJYUE2Hj2g63TzB27lDRMGpc/8HFlNvPI2gROUNAj7+4dRUvjQMLQYSMt2vl/lm960WbAyh0+f/TyeS1maKvgt9da7U4h/oJ6qCEXvQZ2aH59PTGSGGMvnBw5OBTqXbINjTmBg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XBX4czS_1790169743;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBX4czS_1790169743 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 21:22:31 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	djwong@kernel.org
Subject: [PATCH e2fsprogs] tune2fs: touch the device node after setting the label via ioctl
Date: Wed, 23 Sep 2026 21:22:23 +0800
Message-ID: <20260923132223.3355764-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the file system is mounted, tune2fs sets the label through
FS_IOC_SETFSLABEL, which updates the label without touching the
mtime of the device node.  Consumers such as blkid use that mtime
to validate their cached superblock information, so the old label
can still be returned right after the change:

  blkid -s LABEL /dev/sdb    # gets "old" and caches it
  tune2fs -L new /dev/sdb    # online path, node mtime unchanged
  blkid -s LABEL /dev/sdb    # still gets "old" within 2s

The offline path is unaffected because writing the superblock
through the device node updates its mtime as a side effect.  The
ioctl path has no such side effect, so add an explicit utime() on
the device after a successful FS_IOC_SETFSLABEL.

The return value is ignored; if the touch fails, the behavior is
no worse than before.

Suggested-by: Theodore Ts'o <tytso@mit.edu>
Link: https://patch.msgid.link/arKZu30pMe0ZavVA@mit.edu
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 misc/tune2fs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2d85fb704e15..87b8e6830bb9 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -48,6 +48,7 @@ extern int optind;
 #endif
 #include <string.h>
 #include <time.h>
+#include <utime.h>
 #include <unistd.h>
 #include <sys/types.h>
 #include <libgen.h>
@@ -3167,6 +3168,14 @@ static int handle_fslabel(int setlabel)
 		return 1;
 	}
 	close(fd);
+
+	/*
+	 * FS_IOC_SETFSLABEL does not touch the device mtime that
+	 * blkid uses to validate its cache; touch the device so
+	 * mtime-based consumers see the change.
+	 */
+	utime(device_name, NULL);
+
 	return 0;
 #else
 	return -1;
-- 
2.43.7

