Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B61C282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 18:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1347E218A6
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 18:33:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="Q9xytXuS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbfBASc7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 13:32:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35578 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfBASc7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 13:32:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id t200so7269667wmt.0
        for <linux-ext4@vger.kernel.org>; Fri, 01 Feb 2019 10:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=D5l4TjFRAWR0EKpMI9V025aiICAbEfW1/LEQOH7i3aM=;
        b=Q9xytXuSVjwqzf9RCOyIU9Gok9Gv/akbXnA1rXVrplO36dTl5SUa1Hbgfz4Cy/O5vO
         UjygxR8K+Hjy5YU/SdF2l9NV5Vgvu6XSww7ENQYFFmDIeYDjCRYIUQVxDSQy+kWLDZDu
         AfvuKvPkdGeckkWZ8gGaUKXIKmvDhPIStLwXTMPt+BW5O5cF1fir/LjInoPCD4RYRCkj
         POgkceBHvHbaeySwQV1lmsfSZL6W8i2QnZWi1P13jTF3YiDUSZCREIEhibergru0wdzW
         JWtLlPBoJk6cJi29h/1zE7J6MOerPtIdhYQV3nZluxiU49dR4PEImMNvPM7TrUFioQ4p
         Bk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=D5l4TjFRAWR0EKpMI9V025aiICAbEfW1/LEQOH7i3aM=;
        b=F6DwNnYnGjVqiSUP3G/XIvBULJWS+r6+9U6V9lw+XmsIAwtjzPSf6L6Y/iA3JJXqrU
         Gy71+aygxgKoFaeZtUKov8S+nD6uzcbdVRg3XVLVM6G45RrxtzVd1Vryrzin8AIFGO+W
         hkNG3gJMqy5+BomQuXI+ngxTTlXw5HJQMQtfbUONXhRpad3BGINdCzM5jDpvyNmW2otI
         Y0kY13rA/5ESnI1TI0E2WPs1swTrpGBgxmxP3m/1t6fwPZddl+wL8Ec9bggKXF5KcGZ3
         srpDL/AX/r2lC/xZFIZ5DpV/TpH05bjK72YDM15iBLC4PTVkC3se/PODLFy6Lpw+Bjxr
         MSKA==
X-Gm-Message-State: AHQUAuaV9ta6Io86RIQW8YCfp91GsVuYei1MohpsvCUDiuwbWzmGR0ZP
        8Fewfu+6Gj5EKeTM1N3AYFgCPyYOJCs=
X-Google-Smtp-Source: AHgI3IYJdo0dhI9n+OkNadGaQF4Ms7JV2NE3sYcDpg480ltU8F40qrVgUZdybbvtmg+VzlGh23h0vg==
X-Received: by 2002:a1c:8010:: with SMTP id b16mr3453330wmd.57.1549045976738;
        Fri, 01 Feb 2019 10:32:56 -0800 (PST)
Received: from flashheart.burtonini.com (35.106.2.81.in-addr.arpa. [81.2.106.35])
        by smtp.gmail.com with ESMTPSA id c14sm3023783wme.13.2019.02.01.10.32.55
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Feb 2019 10:32:55 -0800 (PST)
From:   Ross Burton <ross.burton@intel.com>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH v2] create_inode: fix copying large files
Date:   Fri,  1 Feb 2019 18:32:47 +0000
Message-Id: <20190201183247.8148-1-ross.burton@intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

When copying large files into a ext filesystem at mkfs time the copy fails at
2^31 bytes in.  There are two problems:

copy_file_chunk() passes an offset (off_t, 64-bit typically) to
ext2fs_file_lseek() which expects a ext2_off_t (typedef to __u32) so the value
is truncated. Solve by calling ext2fs_file_llseek() which takes a u64 offset
instead.

try_lseek_copy() rounds the data and hole offsets as found by lseek() to block
boundaries, but the calculation gets truncated to 32-bits.  Solve by casting the
32-bit blocksize to off_t to ensure this doesn't happen.

Signed-off-by: Ross Burton <ross.burton@intel.com>
---
 misc/create_inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 05aa6363..1b35c769 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -438,7 +438,7 @@ static errcode_t copy_file_chunk(ext2_filsys fs, int fd, ext2_file_t e2_file,
 				ptr += blen;
 				continue;
 			}
-			err = ext2fs_file_lseek(e2_file, off + bpos,
+			err = ext2fs_file_llseek(e2_file, off + bpos,
 						EXT2_SEEK_SET, NULL);
 			if (err)
 				goto fail;
@@ -480,8 +480,8 @@ static errcode_t try_lseek_copy(ext2_filsys fs, int fd, struct stat *statbuf,
 		if (hole < 0)
 			return EXT2_ET_UNIMPLEMENTED;
 
-		data_blk = data & ~(fs->blocksize - 1);
-		hole_blk = (hole + (fs->blocksize - 1)) & ~(fs->blocksize - 1);
+		data_blk = data & ~(off_t)(fs->blocksize - 1);
+		hole_blk = (hole + (off_t)(fs->blocksize - 1)) & ~(off_t)(fs->blocksize - 1);
 		err = copy_file_chunk(fs, fd, e2_file, data_blk, hole_blk, buf,
 				      zerobuf);
 		if (err)
-- 
2.11.0

