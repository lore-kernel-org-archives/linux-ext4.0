Return-Path: <SRS0=ONaI=RT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15722C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 16 Mar 2019 17:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2950218D4
	for <linux-ext4@archiver.kernel.org>; Sat, 16 Mar 2019 17:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nPHt5huK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfCPRL2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 16 Mar 2019 13:11:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34966 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfCPRL2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Mar 2019 13:11:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id 81so1519633wme.0
        for <linux-ext4@vger.kernel.org>; Sat, 16 Mar 2019 10:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UtledzxpYbtnbADBzBmpad4N+SxNFod9lkP7lpSiGI=;
        b=nPHt5huK5/b82athYBnoQfox3qePeIIN6vnnQM0ohsY2AAxLRWOTIiaLLkjEZFOSbr
         X8VJn3K+NF55H0QVXP5EizziP6/vIKJnTQpoz/eSP3dcd7W4fdXj/aKCLYNsACJUg3Cb
         oNORGy+A1bl7uRwWIGWt4Zm8PblSw0YfigkcxoqRObNVlfPZtJUd3FDIZ0lEw6o0iQBB
         94RfLl5aOYT2AYAzuVUJEQiVLIOS2gqN57m24iQKP6Yz7XNBfojcKOCWt1UL7WWg2qb+
         +2gi29SDANqaa7TnIuoVVtrF5Sg3st1X08We5ClKSeR4tqArrTqxT4RubOBI9ci1Lwm/
         y6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UtledzxpYbtnbADBzBmpad4N+SxNFod9lkP7lpSiGI=;
        b=CV4vPfhXHbAi0FyjLd1mRMbQaYseolwwvoLrgBwd8+fgKjuR84eXrFinUl+VxL16A0
         yUGqYQmPIVpZ63YVh0xk/WEhSAUno+kpiSAZaCYWQ3DcF/oIBv/6Z1c+t05JAy5W3JfB
         iduxQn00DNDf2BandLJ/YLGyUvc82nZKsfSVUi25KQYLR6lnJzw5Llx8DcwrKr29zkxZ
         yJ9YBklcyrtU+IkceZg/7IAYrrot030Yo9WFuhi2ejXeZ2kBOPLfUo63FxWk1tyO+QEz
         1jZdsJ8Ho30zjfI5vperq46n69NGn7HK5yo0nbxPWmjyq9JUD7V9YYJicJiUwt7pgLLc
         Yoig==
X-Gm-Message-State: APjAAAWTZaQOhy0xM/ZVMl+sI9/bOGl6bZjXOmAm4Kvwd9pzXwvbEB+I
        DdpKDujUmbs1jLZu4vq+qlzzP/6QYX+RALaYcAQ=
X-Google-Smtp-Source: APXvYqzVwDHvXCJjdtGKTQZc3lLFBxVnfk9aTLjsyHzo3VTK8V+F93XFKxMTxlKim3UEb9usYJMTpQyJlVxq09TOiy4=
X-Received: by 2002:a1c:4b03:: with SMTP id y3mr5952421wma.75.1552756285511;
 Sat, 16 Mar 2019 10:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAB5bDOiUNd_-5FTrCL0vEs_6UUqi=xKkQeH0hWL256i7p=0Kkg@mail.gmail.com>
 <48911DBD-B419-4C61-8F53-6CB41C304985@dilger.ca>
In-Reply-To: <48911DBD-B419-4C61-8F53-6CB41C304985@dilger.ca>
From:   Burke Harper <go88team@gmail.com>
Date:   Sat, 16 Mar 2019 13:11:18 -0400
Message-ID: <CAB5bDOiGPiOmupPepWjNnV7e1xL0wgaA4bY243rfkvSDCanAOA@mail.gmail.com>
Subject: Re: Should Never Happen: Resize Inode Corrupt
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

I updated to 1.44.5.

It's been going along now for about 21 hours.  There is some
noticeable io this time around.  Looks like it's still trying to
recreate the resize inode.

On Fri, Mar 15, 2019 at 3:19 PM Andreas Dilger <adilger@dilger.ca> wrote:
>
> Kill your e2fsck and upgrade to the latest version 1.44.5, as it has a lot of fixes over 1.42.13.
>
> If you have the ability, make a "dd" copy of the filesystem first, or a snapshot, and run e2fsck on that first.
>
> Cheers, Andreas
>
> > On Mar 15, 2019, at 00:38, Burke Harper <go88team@gmail.com> wrote:
> >
> > Over the past weekend, I added 2 more drives to my /dev/md0 array:
> >
> > sudo mdadm --detail /dev/md0
> > /dev/md0:
> >        Version : 1.2
> >  Creation Time : Sat Dec 16 18:32:08 2017
> >     Raid Level : raid6
> >     Array Size : 54697266176 (52163.38 GiB 56010.00 GB)
> >  Used Dev Size : 7813895168 (7451.91 GiB 8001.43 GB)
> >   Raid Devices : 9
> >  Total Devices : 9
> >    Persistence : Superblock is persistent
> >
> >  Intent Bitmap : Internal
> >
> >    Update Time : Mon Mar 11 05:13:12 2019
> >          State : clean
> > Active Devices : 9
> > Working Devices : 9
> > Failed Devices : 0
> >  Spare Devices : 0
> >
> >         Layout : left-symmetric
> >     Chunk Size : 512K
> >
> >           Name : powerhouse:0  (local to host powerhouse)
> >           UUID : 19b5c7a5:59e4bd00:b4b1c18c:089df9bd
> >         Events : 45981
> >
> >    Number   Major   Minor   RaidDevice State
> >       0       8        0        0      active sync   /dev/sda
> >       1       8       16        1      active sync   /dev/sdb
> >       2       8       32        2      active sync   /dev/sdc
> >       3       8       48        3      active sync   /dev/sdd
> >       5       8      144        4      active sync   /dev/sdj
> >       4       8      128        5      active sync   /dev/sdi
> >       6       8      112        6      active sync   /dev/sdh
> >       8       8       80        7      active sync   /dev/sdf
> >       7       8       64        8      active sync   /dev/sde
> >
> > Afterwards I did an fsck:
> >
> > sudo fsck.ext4 -f /dev/md0
> > e2fsck 1.42.13 (17-May-2015)
> > Pass 1: Checking inodes, blocks, and sizes
> > Pass 2: Checking directory structure
> > Pass 3: Checking directory connectivity
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information
> > /dev/md0: 70089/1220923392 files (3.6% non-contiguous),
> > 7726498938/9767368960 blocks
> >
> > Following that, I tried to perform an offline resize:
> >
> > sudo resize2fs /dev/md0
> > resize2fs 1.42.13 (17-May-2015)
> > Resizing the filesystem on /dev/md0 to 13674316544 (4k) blocks.
> > Should never happen: resize inode corrupt!
> >
> > After having done that, it looks like it should have been an online
> > resize from reading a thread on here from 2015.
> >
> > After trying the resize I tried to do another fsck:
> >
> > sudo fsck.ext4 -f /dev/md0
> > e2fsck 1.42.13 (17-May-2015)
> > ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
> > fsck.ext4: Group descriptors look bad... trying backup blocks...
> > Superblock has an invalid journal (inode 8).
> > Clear<y>? yes
> > *** ext3 journal has been deleted - filesystem is now ext2 only ***
> >
> > Resize inode not valid.  Recreate<y>? yes
> >
> > It's been stuck here for days, with:
> >
> > 14827 root      20   0  141796 121044   2688 R  93.8  0.4   5546:26 fsck.ext4
> >
> > It's been running at around 100% the whole time.  I don't see any disk
> > io happening either.
> >
> > sudo dumpe2fs -h /dev/md0
> > dumpe2fs 1.42.13 (17-May-2015)
> > Filesystem volume name:   <none>
> > Last mounted on:          /Media10
> > Filesystem UUID:          d36119d5-e3ec-47f7-b93e-124eb4598367
> > Filesystem magic number:  0xEF53
> > Filesystem revision #:    1 (dynamic)
> > Filesystem features:      has_journal ext_attr resize_inode dir_index
> > filetype extent 64bit flex_bg sparse_super large_file huge_file
> > uninit_bg dir_nlink extra_isize
> > Filesystem flags:         signed_directory_hash
> > Default mount options:    user_xattr acl
> > Filesystem state:         clean with errors
> > Errors behavior:          Continue
> > Filesystem OS type:       Linux
> > Inode count:              1709293568
> > Block count:              13674316544
> > Reserved block count:     683715825
> > Free blocks:              5886063280
> > Free inodes:              1709223479
> > First block:              0
> > Block size:               4096
> > Fragment size:            4096
> > Group descriptor size:    64
> > Blocks per group:         32768
> > Fragments per group:      32768
> > Inodes per group:         4096
> > Inode blocks per group:   256
> > RAID stride:              128
> > RAID stripe width:        256
> > Flex block group size:    16
> > Filesystem created:       Sun Dec 17 10:10:08 2017
> > Last mount time:          Sat Mar  9 17:58:06 2019
> > Last write time:          Mon Mar 11 05:48:14 2019
> > Mount count:              0
> > Maximum mount count:      -1
> > Last checked:             Mon Mar 11 05:16:14 2019
> > Check interval:           0 (<none>)
> > Lifetime writes:          29 TB
> > Reserved blocks uid:      0 (user root)
> > Reserved blocks gid:      0 (group root)
> > First inode:              11
> > Inode size:               256
> > Required extra isize:     28
> > Desired extra isize:      28
> > Journal inode:            8
> > Default directory hash:   half_md4
> > Directory Hash Seed:      23fd4260-aee9-4f36-8406-240f3b7a39d2
> > Journal backup:           inode blocks
> > Journal superblock magic number invalid!
> >
> >
> > Should I let the fsck continue, or is it safe to exit to try something else.
> >
> > I recently did an offline resize a few weeks ago on the same array and
> > it worked out just fine.  I'm not sure what happened this time, I
> > followed the same steps.
> >
> > Thanks for any help.
