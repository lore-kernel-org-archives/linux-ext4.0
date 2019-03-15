Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CB4C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 06:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AE19218A5
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 06:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+lvAZMO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfCOGi1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Mar 2019 02:38:27 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:40504 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfCOGi0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2019 02:38:26 -0400
Received: by mail-wr1-f49.google.com with SMTP id t5so8325874wri.7
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2019 23:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7aYAw20FYOjCth+k8uqItWfvvuW9VpDdMgIOv3DRbNg=;
        b=O+lvAZMOHKtT7SA+2fk//MUR5gcRHN9gFS+5vEKik/F6MoyodY1BN/FZmITPWY7xDf
         QnJv75zHyob8D/Efv7i2y/Dn1CM3gwNfZu7o0EXgjMOIagCzExYsw249bm0HTCg4te4J
         TTF/8XaC+W76mzLFyOjehS9eQpJ7qgMpn2A3CzAPmRMAW89rhfrZbgBTluVXfXtxk5qn
         QnIzNdzQR2Y3mkBpLI4oK1TEvioENm+F9Sdn3Ccs5zD/qo+TXqkb2H/r60gvJ78s2r4D
         Aiq5mrShxcauziLYpR0VTcElX+2VTwAGcnGGY8KOTW27LTIb5qONOvzcwNq0ts6dEhAi
         tcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7aYAw20FYOjCth+k8uqItWfvvuW9VpDdMgIOv3DRbNg=;
        b=omyMWn2zWacOLztfMEiamzY7sNOvaIsoWJBHMbeqL1yq+GMpBdRaw5kGpM61ckBbPt
         zxQ+anbe/kRsS3k7G4hzaIgCmwYuYPXNRiuWfouVs7lMuzMPek0FFLuFNERjYxUN4Z5q
         Lj9EgFBE3kosr+3tKqk/w8LDIE55ogmouixlGsCcZpvn2V4y0nuSmIz8sK2d4cOGG61I
         QGx5YcdShiHxmhQYTPklx/lEaYCCeNolBNd3iNKmr3I/mAGs45YlwwAPwI8HDl5hQ1rS
         MKmzBBhm/pzNt08mS9qTSjEwSUHVB9To0xPADCw/IngcMp0SzbcqjqEJ13RufWJSyAhh
         7fbg==
X-Gm-Message-State: APjAAAVgFVMgpeKMfOC8W4+bo4cwMwJ2Can6eHFkcDuVe0OLO2U2YP11
        eEQwxhNxpJU6qdjJJeUhYNSyECWTGMlR9G0ZykAWwbao
X-Google-Smtp-Source: APXvYqxHOOV8XnCiEsdVYe4/hCCLNwz/T9vjCYHF65dxhyqzGpZIyKBPqKoylgJ34OHQgWTIuY976lW/ei/rAjTWrVM=
X-Received: by 2002:adf:dd4d:: with SMTP id u13mr1229487wrm.284.1552631903802;
 Thu, 14 Mar 2019 23:38:23 -0700 (PDT)
MIME-Version: 1.0
From:   Burke Harper <go88team@gmail.com>
Date:   Fri, 15 Mar 2019 02:38:12 -0400
Message-ID: <CAB5bDOiUNd_-5FTrCL0vEs_6UUqi=xKkQeH0hWL256i7p=0Kkg@mail.gmail.com>
Subject: Should Never Happen: Resize Inode Corrupt
To:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Over the past weekend, I added 2 more drives to my /dev/md0 array:

sudo mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sat Dec 16 18:32:08 2017
     Raid Level : raid6
     Array Size : 54697266176 (52163.38 GiB 56010.00 GB)
  Used Dev Size : 7813895168 (7451.91 GiB 8001.43 GB)
   Raid Devices : 9
  Total Devices : 9
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Mar 11 05:13:12 2019
          State : clean
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : powerhouse:0  (local to host powerhouse)
           UUID : 19b5c7a5:59e4bd00:b4b1c18c:089df9bd
         Events : 45981

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       5       8      144        4      active sync   /dev/sdj
       4       8      128        5      active sync   /dev/sdi
       6       8      112        6      active sync   /dev/sdh
       8       8       80        7      active sync   /dev/sdf
       7       8       64        8      active sync   /dev/sde

Afterwards I did an fsck:

sudo fsck.ext4 -f /dev/md0
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md0: 70089/1220923392 files (3.6% non-contiguous),
7726498938/9767368960 blocks

Following that, I tried to perform an offline resize:

sudo resize2fs /dev/md0
resize2fs 1.42.13 (17-May-2015)
Resizing the filesystem on /dev/md0 to 13674316544 (4k) blocks.
Should never happen: resize inode corrupt!

After having done that, it looks like it should have been an online
resize from reading a thread on here from 2015.

After trying the resize I tried to do another fsck:

sudo fsck.ext4 -f /dev/md0
e2fsck 1.42.13 (17-May-2015)
ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
fsck.ext4: Group descriptors look bad... trying backup blocks...
Superblock has an invalid journal (inode 8).
Clear<y>? yes
*** ext3 journal has been deleted - filesystem is now ext2 only ***

Resize inode not valid.  Recreate<y>? yes

It's been stuck here for days, with:

14827 root      20   0  141796 121044   2688 R  93.8  0.4   5546:26 fsck.ext4

It's been running at around 100% the whole time.  I don't see any disk
io happening either.

sudo dumpe2fs -h /dev/md0
dumpe2fs 1.42.13 (17-May-2015)
Filesystem volume name:   <none>
Last mounted on:          /Media10
Filesystem UUID:          d36119d5-e3ec-47f7-b93e-124eb4598367
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent 64bit flex_bg sparse_super large_file huge_file
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              1709293568
Block count:              13674316544
Reserved block count:     683715825
Free blocks:              5886063280
Free inodes:              1709223479
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         4096
Inode blocks per group:   256
RAID stride:              128
RAID stripe width:        256
Flex block group size:    16
Filesystem created:       Sun Dec 17 10:10:08 2017
Last mount time:          Sat Mar  9 17:58:06 2019
Last write time:          Mon Mar 11 05:48:14 2019
Mount count:              0
Maximum mount count:      -1
Last checked:             Mon Mar 11 05:16:14 2019
Check interval:           0 (<none>)
Lifetime writes:          29 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      23fd4260-aee9-4f36-8406-240f3b7a39d2
Journal backup:           inode blocks
Journal superblock magic number invalid!


Should I let the fsck continue, or is it safe to exit to try something else.

I recently did an offline resize a few weeks ago on the same array and
it worked out just fine.  I'm not sure what happened this time, I
followed the same steps.

Thanks for any help.
