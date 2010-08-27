From: Justin Maggard <jmaggard10@gmail.com>
Subject: EXT4 online resize limitations
Date: Fri, 27 Aug 2010 16:33:06 -0700
Message-ID: <AANLkTin-q=dOHRh2TB9PtUyvB2YcbLTz+en_aTp+voVU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35490 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0H0XdH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Aug 2010 19:33:07 -0400
Received: by vws3 with SMTP id 3so3443041vws.19
        for <linux-ext4@vger.kernel.org>; Fri, 27 Aug 2010 16:33:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Is there any way to allow for a larger online resize with ext4?  On
x86 hardware (4kb block size), it looks to me like the current
limitation is up to 16TB for regular 32-bit filesystems (which isn't
an issue), but only 8TB additional for filesystems with the 64bit flag
set.  Is there any chance that can/will be improved?

Also, while I was trying this out, I ran into a divide by zero error
when running mke2fs with the 64bit flag enabled, and the resize=
extended option set.  This is because EXT2_DESC_PER_BLOCK() tries to
use s_desc_size if the 64bit flag is set, which isn't set at that
time.  This diff against master works around it, but perhaps there's a
more appropriate way?  Should EXT2_DESC_PER_BLOCK() make sure that the
s_desc_size != 0?

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index add7c0c..b1a6d62 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -722,6 +722,8 @@ static void parse_extended_opts(struct
ext2_super_block *param,
                        bpg = param->s_blocks_per_group;
                        if (!bpg)
                                bpg = blocksize * 8;
+                       if (!param->s_desc_size &&
(param->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT))
+                               param->s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
                        gdpb = EXT2_DESC_PER_BLOCK(param);
                        group_desc_count = (__u32) ext2fs_div64_ceil(
                                ext2fs_blocks_count(param), bpg);
