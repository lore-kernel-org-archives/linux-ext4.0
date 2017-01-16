From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: [PATCH] mke2fs: fix coping of empty file using fiemap
Date: Mon, 16 Jan 2017 19:59:17 +0300
Message-ID: <CAO3qy=HA2K9j0a86R1EyM-zCnQxEgUVP-trr_5cgaeJThmrWyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:34267 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750827AbdAPRYH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 16 Jan 2017 12:24:07 -0500
Received: from pps.filterd (m0075028.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0GGw4Ep010455
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2017 11:59:18 -0500
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com [209.85.216.198])
        by mx0b-00003501.pphosted.com with ESMTP id 280x49ru5j-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2017 11:59:18 -0500
Received: by mail-qt0-f198.google.com with SMTP id l7so99627068qtd.2
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2017 08:59:18 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During filesystem creation with -d option files copied from given
directory. If supported, FS_IOC_FIEMAP ioctl is used to get file
extents. For empty file fm_mapped_extents is 0 and no error code
is returned, because this is not fail situation.

Without this patch errno from previous operation is returned and
successful FS_IOC_FIEMAP ioctl call for empty file is interpreted
as error.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 misc/create_inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 5122e56..6083d94 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -510,7 +510,7 @@ static errcode_t try_fiemap_copy(ext2_filsys fs,
int fd, ext2_file_t e2_file,
         if (err < 0 && (errno == EOPNOTSUPP || errno == ENOTTY)) {
             err = EXT2_ET_UNIMPLEMENTED;
             goto out;
-        } else if (err < 0 || fiemap_buf->fm_mapped_extents == 0) {
+        } else if (err < 0 && fiemap_buf->fm_mapped_extents == 0) {
             err = errno;
             goto out;
         }
--
