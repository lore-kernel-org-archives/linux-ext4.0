From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: [PATCH v2] mke2fs: fix coping of empty file using fiemap
Date: Tue, 17 Jan 2017 18:14:19 +0300
Message-ID: <CAO3qy=EeD4y6cX3JaA4ZKptoL9JH0Kc9zYqPWj-UZ+ythC6LXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:39739 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750932AbdAQPXz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 17 Jan 2017 10:23:55 -0500
Received: from pps.filterd (m0075552.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0HF98Xm028997
        for <linux-ext4@vger.kernel.org>; Tue, 17 Jan 2017 10:14:20 -0500
Received: from mail-qt0-f200.google.com (mail-qt0-f200.google.com [209.85.216.200])
        by mx0a-00003501.pphosted.com with ESMTP id 281ne8037q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 17 Jan 2017 10:14:20 -0500
Received: by mail-qt0-f200.google.com with SMTP id x49so136845689qtc.7
        for <linux-ext4@vger.kernel.org>; Tue, 17 Jan 2017 07:14:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Darrick J. Wong, thank you for inspection. Here is second version of the patch.

Changes since v1:
* errno is returned in case failed ioctl
* loop is terminated any time fm_mapped_extents == 0

During filesystem creation with -d option files copied from given
directory. If supported, FS_IOC_FIEMAP ioctl is used to get file
extents. For empty file fm_mapped_extents is 0 and no error code
is returned, because this is not fail situation.

Without this patch errno from previous operation is returned and
successful FS_IOC_FIEMAP ioctl call for empty file is interpreted
as error.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 misc/create_inode.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 5122e56..d9e9b9b 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -510,10 +510,12 @@ static errcode_t try_fiemap_copy(ext2_filsys fs,
int fd, ext2_file_t e2_file,
         if (err < 0 && (errno == EOPNOTSUPP || errno == ENOTTY)) {
             err = EXT2_ET_UNIMPLEMENTED;
             goto out;
-        } else if (err < 0 || fiemap_buf->fm_mapped_extents == 0) {
+        } else if (err < 0) {
             err = errno;
             goto out;
-        }
+        } else if (fiemap_buf->fm_mapped_extents == 0)
+            goto out;
+
         for (i = 0, ext = ext_buf; i < fiemap_buf->fm_mapped_extents;
              i++, ext++) {
             err = copy_file_range(fs, fd, e2_file, ext->fe_logical,
--
