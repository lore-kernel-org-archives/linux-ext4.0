Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4B63EC691;
	Sun, 20 Sep 2026 09:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789897312; cv=none; b=Z6dFw59hbaMXMqBKGkeVDJzME9IFM+WiexzKHT0bPBwaCgfZzWVH0R0+bQ3tVvxVFLM/IE89XgsUwswAdnnIdrJraBKYYiwOn5iTAyhC8nNtBEOkL9w0Ds8JGqErKz5oQY42rtJDljxjEgnBFY+NlzfJkVTOv6veP588UvNMltE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789897312; c=relaxed/simple;
	bh=RJK6BbLCHnOZZOUnen2VZqlg3ixOiEdsUevu8/0WJYA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fo3CB9EyVsLhX58lswvszst5GFKUGaWRLLNfYQcJGWfVnX0a1ZdSUfmunxVH4yc1sxqor1tfTQx5lPgMk8X2hEn2axHntt6zh24AbhP3++zaaI+LaHjkkzVQCoc/oh4Pqt25mn5Nt3rG73csQSVrPFSr/s22Fmhh/BdN0OJrq40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nnquEsfQ; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nnquEsfQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789897306; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=HB839kQM3NZPpQrGhr6AVMFZpD+GG38HAjWMksSHc3A=;
	b=nnquEsfQNAk1PeeKp2+9Pmd/2TkeF4o+b0sIgKu6fCf7RaApkzlX3BZvQrec0UcdwCWIt0KdQeQoyPUj+oB753WvML32uat83g26y8HbLT3rYCZ9KY5/IXDq16uuDAIvJFmnN+Qdj1WjVZAe7OXChxUz63TCioXb12fKnoXohNY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XBFdMm8_1789897297;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBFdMm8_1789897297 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 20 Sep 2026 17:41:45 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	sandeen@redhat.com,
	dgc@kernel.org
Subject: [PATCH] generic/492: bypass the blkid cache when probing the label
Date: Sun, 20 Sep 2026 17:41:37 +0800
Message-ID: <20260920094137.2749428-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

blkid may serve a stale label from its cache instead of probing the
device, so the label just set via xfs_io can be missed and the output
mismatch is non-deterministic.

Pass "-c /dev/null" so that blkid always probes the on-disk superblock
directly.  Unlike the low-level probing mode (-p), which requires
util-linux 2.16 or later, this is also supported by the legacy blkid
shipped with e2fsprogs.

Fixes: c3c9630968a6 ("generic: test online label ioctl")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 tests/generic/492 | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tests/generic/492 b/tests/generic/492
index 51a46b510453..0b4f69b80f17 100755
--- a/tests/generic/492
+++ b/tests/generic/492
@@ -28,14 +28,15 @@ $XFS_IO_PROG -c "label -c" $SCRATCH_MNT
 $XFS_IO_PROG -c "label" $SCRATCH_MNT
 
 # And that userspace can see it now, while mounted
-# NB: some blkid has trailing whitespace, filter it out here
+# NB: bypass the blkid cache which may hold a stale label, and filter
+# out the trailing whitespace some blkid versions emit
 $XFS_IO_PROG -c "label -s label.$seq" $SCRATCH_MNT
 $XFS_IO_PROG -c "label" $SCRATCH_MNT
-blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
+blkid -c /dev/null -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
 
 # And that the it is still there when it's unmounted
 _scratch_unmount
-blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
+blkid -c /dev/null -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
 
 # And that it persists after a remount
 _scratch_mount
-- 
2.43.7

