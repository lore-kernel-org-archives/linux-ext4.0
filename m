Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC21C282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 12:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 108DB21872
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 12:52:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="qYGRWAk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfBAMwG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:52:06 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37283 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfBAMwG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 07:52:06 -0500
Received: by mail-wm1-f67.google.com with SMTP id g67so6086142wmd.2
        for <linux-ext4@vger.kernel.org>; Fri, 01 Feb 2019 04:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=3lYqCxI5+8JsHDSh2N0Qw4sRP80hM05gFadMbnH9GgE=;
        b=qYGRWAk3Epy4nDyUpjV4JlX/YYs4C5JVrAILN1gsdJHH3IaCWgm5Wz6dxvLTWXTu9s
         2waW/0NK3pEO8q8yU1Mbav6JBKLbngmVUyn0FoU9i/rYPcAlN9K0oGN7IAbhhDMfsoqg
         yfdk41jzzCHRxPb2BU9mLe96cUqKqPdjf1naWqv0qk4MM+Y2us15vF0mab9ri3bf+2gr
         Htk2l3vDI6vMEQZeRDhT3IvFhPKXmXqHO5xESdfyVIkaSEWQblfr0TatijNa6sMd2bwg
         nM5RWx5nRS99MN4RAuQlXvao9yFTXfy54VPVwqvtqDZG7YbhJRwyJ589hV8FOKuhE/4X
         zAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=3lYqCxI5+8JsHDSh2N0Qw4sRP80hM05gFadMbnH9GgE=;
        b=K+3xUcsMhTMsklM0brWzs6rdTwDKxnzb5D8+AUuivXIjKGbi5a2pnV/mTIezbbx3hc
         bJ25iwuBffqNn3DzA0giOVOm5/1JwGseBPbVb5C/roDv0ToUjJEBnJL4iYCN4k0Eoe6t
         qX3k+CLNfX+ft/PY3C4w1+N0pT+PdTvPFR/18D7KBfaNMHTwCdmYyNdiULd+M5H2oTz5
         C6JYQcX9cfpOj73lQ4QrPxAEoM2MAt7W5sCZ45KTeSVM+io0Fx5lbn4QfCCcJVaE7lAK
         nUvaMtTVkG/jQjPXzPtExRkQMZS+olI5M7QQ4VsQSUMgQI9SJ67UgZ1kHTMENVfjRvgc
         8XPA==
X-Gm-Message-State: AHQUAuY0myWeD3qOzrGpZZ0+ocy/B6wKBxYIf3S0/rjPubS/CehdwBq6
        eXpX9DuLwCKSJA7k5nfoRrNwWFl14AQ=
X-Google-Smtp-Source: AHgI3IYu3+gKjISIljZy8BgZBEwc9TdBtiKexhY0Yoa12Oeb86urAlyZZ+sgeiZipqwusa8byUAqLA==
X-Received: by 2002:a1c:c1c9:: with SMTP id r192mr2300519wmf.146.1549025524288;
        Fri, 01 Feb 2019 04:52:04 -0800 (PST)
Received: from flashheart.burtonini.com (35.106.2.81.in-addr.arpa. [81.2.106.35])
        by smtp.gmail.com with ESMTPSA id a132sm4351362wmh.5.2019.02.01.04.52.03
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Feb 2019 04:52:03 -0800 (PST)
From:   Ross Burton <ross.burton@intel.com>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH] create_inode: fix copying large files
Date:   Fri,  1 Feb 2019 12:51:59 +0000
Message-Id: <20190201125159.31880-1-ross.burton@intel.com>
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
 misc/create_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 05aa6363..f106dcda 100644
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
@@ -481,7 +481,7 @@ static errcode_t try_lseek_copy(ext2_filsys fs, int fd, struct stat *statbuf,
 			return EXT2_ET_UNIMPLEMENTED;
 
 		data_blk = data & ~(fs->blocksize - 1);
-		hole_blk = (hole + (fs->blocksize - 1)) & ~(fs->blocksize - 1);
+		hole_blk = (hole + (off_t)(fs->blocksize - 1)) & ~(off_t)(fs->blocksize - 1);
 		err = copy_file_chunk(fs, fd, e2_file, data_blk, hole_blk, buf,
 				      zerobuf);
 		if (err)
-- 
2.11.0

