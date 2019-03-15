Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A780DC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 19:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F394218A1
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 19:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="g7l2W15m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfCOTTQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Mar 2019 15:19:16 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:39709 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCOTTP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2019 15:19:15 -0400
Received: by mail-pg1-f177.google.com with SMTP id h8so7110133pgp.6
        for <linux-ext4@vger.kernel.org>; Fri, 15 Mar 2019 12:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=o8sODZLyt5jGKB0TRda2qE9QMg6xFyX8dRkp8loAsc0=;
        b=g7l2W15msef+ccWWzSignMjJvYCwzICGjQ3KSrIrPA9xArGOd2jyLN00RmWHIxXiaA
         RPjVT6l84EiI4HyAwjsgoDg04eGnjGmIVDXwr+p5dnWZ6ftfhPecTwIaZnn2nCMW0ilX
         k028rFKJEtrzj+/Sz1Z3wBUZHN412pzTRAKj6tzUbrSwBYnAdp27AG82aeXB4Qynutkl
         AvJTnMMxcJFyH7myB4JhEbKCsaBM/PCQ90shusfeO1oATM2UkBhAJmf1zFCYbE4q/oFl
         4vZgKGSWCRFbLT5DfjGg+jLjsikeo/I6UJ5Eg85rwKeRbMm8ao7dlhu7RTVr8hJEswuG
         rZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=o8sODZLyt5jGKB0TRda2qE9QMg6xFyX8dRkp8loAsc0=;
        b=L2/pixkwAZn1l7rTN6iCz7aN9vBdsk6gFIB/+5tNVz34/k6nVMy8O/1rUe6LKIsq7c
         +Htmopa4DL9Jdwm4O1Uz4Z4hw13d7VzfS+ne9NC46o3VXwBQgJV5HGg5fTDNm3Pa+GAM
         FAFoq2VSAP02T7sKEELZncztqGOPEq1EuTepukFaKQvvaeMvpKK8FmMjSoxev/+DBwRA
         Ws5VV8osLYjezuw1Q71MdlOCDABszlszCRmlM8JIgDkZpLLmxKqzueONXNwwsTLJ7+bP
         4QFzdJFp9WeL74KXayCaMTt5A7G2SUcKYzrZ9nDnJBB19FpW+yhxpDYecchmB3pM3Ac8
         3eFw==
X-Gm-Message-State: APjAAAURg2+DiK7bk9C1h6e2rkYjCrRWzc+caTNai6jIrypwUXNs5m9l
        /V3qSVHHbhBGpXTPQA88ja4HGUbnTLg=
X-Google-Smtp-Source: APXvYqz6nmDqgv5z4yoNZ8hDgvqL/gGupLCNFVuUoJCh6rPvIeU3kEjbprnLO7fGgiYn7i23zLsnoA==
X-Received: by 2002:aa7:8c48:: with SMTP id e8mr5679961pfd.166.1552677554369;
        Fri, 15 Mar 2019 12:19:14 -0700 (PDT)
Received: from [192.168.10.175] (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id c13sm5303209pfm.34.2019.03.15.12.19.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 12:19:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Should Never Happen: Resize Inode Corrupt
From:   Andreas Dilger <adilger@dilger.ca>
X-Mailer: iPhone Mail (16D57)
In-Reply-To: <CAB5bDOiUNd_-5FTrCL0vEs_6UUqi=xKkQeH0hWL256i7p=0Kkg@mail.gmail.com>
Date:   Fri, 15 Mar 2019 13:19:12 -0600
Cc:     linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <48911DBD-B419-4C61-8F53-6CB41C304985@dilger.ca>
References: <CAB5bDOiUNd_-5FTrCL0vEs_6UUqi=xKkQeH0hWL256i7p=0Kkg@mail.gmail.com>
To:     Burke Harper <go88team@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Kill your e2fsck and upgrade to the latest version 1.44.5, as it has a lot o=
f fixes over 1.42.13.=20

If you have the ability, make a "dd" copy of the filesystem first, or a snap=
shot, and run e2fsck on that first.=20

Cheers, Andreas

> On Mar 15, 2019, at 00:38, Burke Harper <go88team@gmail.com> wrote:
>=20
> Over the past weekend, I added 2 more drives to my /dev/md0 array:
>=20
> sudo mdadm --detail /dev/md0
> /dev/md0:
>        Version : 1.2
>  Creation Time : Sat Dec 16 18:32:08 2017
>     Raid Level : raid6
>     Array Size : 54697266176 (52163.38 GiB 56010.00 GB)
>  Used Dev Size : 7813895168 (7451.91 GiB 8001.43 GB)
>   Raid Devices : 9
>  Total Devices : 9
>    Persistence : Superblock is persistent
>=20
>  Intent Bitmap : Internal
>=20
>    Update Time : Mon Mar 11 05:13:12 2019
>          State : clean
> Active Devices : 9
> Working Devices : 9
> Failed Devices : 0
>  Spare Devices : 0
>=20
>         Layout : left-symmetric
>     Chunk Size : 512K
>=20
>           Name : powerhouse:0  (local to host powerhouse)
>           UUID : 19b5c7a5:59e4bd00:b4b1c18c:089df9bd
>         Events : 45981
>=20
>    Number   Major   Minor   RaidDevice State
>       0       8        0        0      active sync   /dev/sda
>       1       8       16        1      active sync   /dev/sdb
>       2       8       32        2      active sync   /dev/sdc
>       3       8       48        3      active sync   /dev/sdd
>       5       8      144        4      active sync   /dev/sdj
>       4       8      128        5      active sync   /dev/sdi
>       6       8      112        6      active sync   /dev/sdh
>       8       8       80        7      active sync   /dev/sdf
>       7       8       64        8      active sync   /dev/sde
>=20
> Afterwards I did an fsck:
>=20
> sudo fsck.ext4 -f /dev/md0
> e2fsck 1.42.13 (17-May-2015)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/md0: 70089/1220923392 files (3.6% non-contiguous),
> 7726498938/9767368960 blocks
>=20
> Following that, I tried to perform an offline resize:
>=20
> sudo resize2fs /dev/md0
> resize2fs 1.42.13 (17-May-2015)
> Resizing the filesystem on /dev/md0 to 13674316544 (4k) blocks.
> Should never happen: resize inode corrupt!
>=20
> After having done that, it looks like it should have been an online
> resize from reading a thread on here from 2015.
>=20
> After trying the resize I tried to do another fsck:
>=20
> sudo fsck.ext4 -f /dev/md0
> e2fsck 1.42.13 (17-May-2015)
> ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
> fsck.ext4: Group descriptors look bad... trying backup blocks...
> Superblock has an invalid journal (inode 8).
> Clear<y>? yes
> *** ext3 journal has been deleted - filesystem is now ext2 only ***
>=20
> Resize inode not valid.  Recreate<y>? yes
>=20
> It's been stuck here for days, with:
>=20
> 14827 root      20   0  141796 121044   2688 R  93.8  0.4   5546:26 fsck.e=
xt4
>=20
> It's been running at around 100% the whole time.  I don't see any disk
> io happening either.
>=20
> sudo dumpe2fs -h /dev/md0
> dumpe2fs 1.42.13 (17-May-2015)
> Filesystem volume name:   <none>
> Last mounted on:          /Media10
> Filesystem UUID:          d36119d5-e3ec-47f7-b93e-124eb4598367
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index
> filetype extent 64bit flex_bg sparse_super large_file huge_file
> uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         clean with errors
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              1709293568
> Block count:              13674316544
> Reserved block count:     683715825
> Free blocks:              5886063280
> Free inodes:              1709223479
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Group descriptor size:    64
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         4096
> Inode blocks per group:   256
> RAID stride:              128
> RAID stripe width:        256
> Flex block group size:    16
> Filesystem created:       Sun Dec 17 10:10:08 2017
> Last mount time:          Sat Mar  9 17:58:06 2019
> Last write time:          Mon Mar 11 05:48:14 2019
> Mount count:              0
> Maximum mount count:      -1
> Last checked:             Mon Mar 11 05:16:14 2019
> Check interval:           0 (<none>)
> Lifetime writes:          29 TB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      23fd4260-aee9-4f36-8406-240f3b7a39d2
> Journal backup:           inode blocks
> Journal superblock magic number invalid!
>=20
>=20
> Should I let the fsck continue, or is it safe to exit to try something els=
e.
>=20
> I recently did an offline resize a few weeks ago on the same array and
> it worked out just fine.  I'm not sure what happened this time, I
> followed the same steps.
>=20
> Thanks for any help.
