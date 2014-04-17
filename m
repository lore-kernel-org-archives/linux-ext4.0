From: jon ernst <jonernst07@gmail.com>
Subject: [PATCH] ext4: fallocate_zero_range, check if is regular file
Date: Thu, 17 Apr 2014 00:22:04 -0400
Message-ID: <CAGW2f1GoMPwcO3o4Q=As-DkiT2WPN7BiEkq1=RYfX6rnpExipA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:46983 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaDQEWF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 00:22:05 -0400
Received: by mail-qc0-f170.google.com with SMTP id x13so13262656qcv.29
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 21:22:04 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fallocate_zero_range, check if inode is regular file.

Signed-off-by: Jon Ernst <jonernst07@gmail.com>
---
 fs/ext4/extents.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1bb3e4b..756a3b9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4742,6 +4742,8 @@ static long ext4_zero_range(struct file *file,
loff_t offset,

    trace_ext4_zero_range(inode, offset, len, mode);

+   if (!S_ISREG(inode->i_mode))
+       return -EOPNOTSUPP;
    /*
     * Write out all dirty pages to avoid race conditions
     * Then release them.
-- 
1.8.1.2
