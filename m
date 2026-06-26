Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071073E3C48
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462947; cv=none; b=RINWfT3qLBtTjwfK3TTcTEEM2FWMmMqksYinyTlLbdiBPNz41gwKU0v+sJbwYeiwRhzO23ThPvZL907FACYtRg7Ah18qExvNklDyJHVhjIHp/x3sgbFqKTH55F8XZIVdAzYP74UDuDRd7d8Z5WWz5mBGJY9N+Un1dKltGfmzb2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462947; c=relaxed/simple;
	bh=JDTeiv979mxN08L7WVISZh/2rarKfPUziyDJCxl39Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iMDY2/qAbIIx3ZRunTXsshNQ+qiIH18BW7KyN0fBoM2n+b0wYZY+yzWxOGNlSW2LIuFNNkLldvaJRK4LH/bMC2I6+oAZ8hoyPoEAW5cLxH1R6/3DFD/rU85MqPAehNmeH+IVc4ioPnPwUPMA42Vi+LVrp2IcYvZzMv7fdUoyAQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Zp5u/nGr; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Zp5u/nGr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782462938; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=hsl1G9nsXeu0/YIHTza3W0opySmcPof0Mhm37h+qA9E=;
	b=Zp5u/nGr6X8gnuRf0HYYUqz9ot5IXakTY1tNJZ0mPn0+wsuDyzKA+7fNN9NVChxoqHdjDX4N4QipmoxgUfR7JcTDsyFxh1ar6R9T7NUZVf9QzHddixsIoGIBLPl+7v7aOrdi5vKArSNFUqczGN+84EX2Mt4LJ/ORgqhmkgpclj8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X5e4zkB_1782462936;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4zkB_1782462936 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 16:35:36 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 9/9] ext4: fix NOWAIT semantic violation in DAX extending writes
Date: Fri, 26 Jun 2026 16:35:18 +0800
Message-ID: <20260626083518.1064517-10-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
References: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a DAX write starts before EOF but extends past i_disksize,
ext4_write_checks() skips the IOCB_NOWAIT check because
iocb->ki_pos <= old_size. However, ext4_dax_write_iter() later calls
ext4_journal_start() to prepare for inode extension, which can sleep
waiting for journal space or transaction commit.

This violates NOWAIT semantics and can stall asynchronous I/O frameworks
like io_uring that rely on non-blocking behavior.

Fix this by checking IOCB_NOWAIT before calling ext4_journal_start()
in the extending write path. If NOWAIT is set and extension is needed,
return -EAGAIN so the caller can retry in blocking context.

Example scenario:
  - File: i_size = 1000, i_disksize = 1000
  - DAX NOWAIT write: offset = 500, count = 2000
  - ext4_write_checks(): ki_pos (500) <= old_size (1000), skip NOWAIT check
  - ext4_dax_write_iter(): offset + count (2500) > i_disksize (1000)
  - ext4_journal_start() → may sleep → violates NOWAIT

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260618125735.4156639-1-libaokun@linux.alibaba.com?part=5
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 49074cc13751..610e109fcd36 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -731,6 +731,11 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	count = iov_iter_count(from);
 
 	if (offset + count > EXT4_I(inode)->i_disksize) {
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
+		}
+
 		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-- 
2.43.7

