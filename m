Return-Path: <SRS0=ONaI=RT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0136C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 16 Mar 2019 18:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E9CA218AC
	for <linux-ext4@archiver.kernel.org>; Sat, 16 Mar 2019 18:58:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="aHmQihqQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfCPS6A (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 16 Mar 2019 14:58:00 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:38208 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbfCPS6A (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Mar 2019 14:58:00 -0400
Received: by mail-pg1-f171.google.com with SMTP id v1so3933331pgi.5
        for <linux-ext4@vger.kernel.org>; Sat, 16 Mar 2019 11:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dab68utpehBactTECDVb4gMNSwiRft8nsqFzzCJFp3Y=;
        b=aHmQihqQJ7BO7v5ixjzDoRSToNIb0Vw34K6qsShJu0Q8xz4J5lJpc8PSr47ZiOayEj
         006FNJSm8YvOT/qPEYfREFD7Z4i4DY7iSgqVWy+yqJZWtKKNe37V5TIBVzfm+zCyzpD1
         b2+N5WANnYtQQI0vowgWKvtXB7O6cIBCDTzepBDWVI/0sOK0yoYyjEh4nMLikJf6nPtd
         0Q196lU7qv7KQzzBwQTnuwFd4Xe1+xq5WY6mabE3RhSdoUXj6pJAsKYbkTSbBt+RH2fk
         3ie7vwYNkbciszRUh3RhOtwJXVTJjQv9RTAozHMrm+Mg2VYTmi8CANExitrtTmbCskvf
         vbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dab68utpehBactTECDVb4gMNSwiRft8nsqFzzCJFp3Y=;
        b=I4m7b53+vHaak/mrZhbLcqaIaiFlc4ghbZSM7PFcmXt0J6mIRkvoLZW9hagPmWuzJN
         JUkAfM6r7En+oBtRvxnkzbbG5zLWOloujGFETiKacHgQweCBJlRc1QGHv9xuxYQflTYl
         xUthZxNaqtAcrYIJs6z2Pwz1wPiD8nF1PRLq/JJHiWivYP2gVcrYhT0IDABrUyTJOs3G
         IELxvFX0U/5+ZLnfwx6Hn3RVOPlZA9q802/2oKZ5C+brFKa6Uvss6fvWWnPuV6LQwP3Z
         VpoQfiO9l29AGtKqN2Ug9yU8k3BPuBMSIs9o1z0Qtns834bwEtPQMMGBmDm4O/Xqtw3L
         3CZw==
X-Gm-Message-State: APjAAAVhq/xoz52bFlWWpy3GK/x672fTFOwsYpCoCaARsu2iitIkiobf
        X1H4DIcorj4fij/E3/3kEjjeOhBBOS8=
X-Google-Smtp-Source: APXvYqyHuc/Ndbo+b8X1upO42RdfSAdJ2daoa5ZEvJTNVXpxDefm63PaoUj4bq5hreCiftts+6eKPQ==
X-Received: by 2002:a65:4806:: with SMTP id h6mr9726394pgs.408.1552762678892;
        Sat, 16 Mar 2019 11:57:58 -0700 (PDT)
Received: from ?IPv6:2605:8d80:423:1a44:8ddd:8724:9c2b:a536? ([2605:8d80:423:1a44:8ddd:8724:9c2b:a536])
        by smtp.gmail.com with ESMTPSA id v1sm9749307pff.9.2019.03.16.11.57.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Mar 2019 11:57:58 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Should Never Happen: Resize Inode Corrupt
From:   Andreas Dilger <adilger@dilger.ca>
X-Mailer: iPhone Mail (16D57)
In-Reply-To: <CAB5bDOiGPiOmupPepWjNnV7e1xL0wgaA4bY243rfkvSDCanAOA@mail.gmail.com>
Date:   Sat, 16 Mar 2019 12:57:57 -0600
Cc:     linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CB5B81C1-C1C8-4A19-8062-89B2B50C4F65@dilger.ca>
References: <CAB5bDOiUNd_-5FTrCL0vEs_6UUqi=xKkQeH0hWL256i7p=0Kkg@mail.gmail.com> <48911DBD-B419-4C61-8F53-6CB41C304985@dilger.ca> <CAB5bDOiGPiOmupPepWjNnV7e1xL0wgaA4bY243rfkvSDCanAOA@mail.gmail.com>
To:     Burke Harper <go88team@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

You could kill e2fsck and disable the resize_inode feature?  There is a diff=
erent resize mechanism available now (meta_bg) that doesn't need it.=20

Cheers, Andreas

> On Mar 16, 2019, at 11:11, Burke Harper <go88team@gmail.com> wrote:
>=20
> I updated to 1.44.5.
>=20
> It's been going along now for about 21 hours.  There is some
> noticeable io this time around.  Looks like it's still trying to
> recreate the resize inode.
>=20
>> On Fri, Mar 15, 2019 at 3:19 PM Andreas Dilger <adilger@dilger.ca> wrote:=

>>=20
>> Kill your e2fsck and upgrade to the latest version 1.44.5, as it has a lo=
t of fixes over 1.42.13.
>>=20
>> If you have the ability, make a "dd" copy of the filesystem first, or a s=
napshot, and run e2fsck on that first.
>>=20
>> Cheers, Andreas
>>=20
>>> On Mar 15, 2019, at 00:38, Burke Harper <go88team@gmail.com> wrote:
>>>=20
>>> Over the past weekend, I added 2 more drives to my /dev/md0 array:
>>>=20
>>> sudo mdadm --detail /dev/md0
>>> /dev/md0:
>>>       Version : 1.2
>>> Creation Time : Sat Dec 16 18:32:08 2017
>>>    Raid Level : raid6
>>>    Array Size : 54697266176 (52163.38 GiB 56010.00 GB)
>>> Used Dev Size : 7813895168 (7451.91 GiB 8001.43 GB)
>>>  Raid Devices : 9
>>> Total Devices : 9
>>>   Persistence : Superblock is persistent
>>>=20
>>> Intent Bitmap : Internal
>>>=20
>>>   Update Time : Mon Mar 11 05:13:12 2019
>>>         State : clean
>>> Active Devices : 9
>>> Working Devices : 9
>>> Failed Devices : 0
>>> Spare Devices : 0
>>>=20
>>>        Layout : left-symmetric
>>>    Chunk Size : 512K
>>>=20
>>>          Name : powerhouse:0  (local to host powerhouse)
>>>          UUID : 19b5c7a5:59e4bd00:b4b1c18c:089df9bd
>>>        Events : 45981
>>>=20
>>>   Number   Major   Minor   RaidDevice State
>>>      0       8        0        0      active sync   /dev/sda
>>>      1       8       16        1      active sync   /dev/sdb
>>>      2       8       32        2      active sync   /dev/sdc
>>>      3       8       48        3      active sync   /dev/sdd
>>>      5       8      144        4      active sync   /dev/sdj
>>>      4       8      128        5      active sync   /dev/sdi
>>>      6       8      112        6      active sync   /dev/sdh
>>>      8       8       80        7      active sync   /dev/sdf
>>>      7       8       64        8      active sync   /dev/sde
>>>=20
>>> Afterwards I did an fsck:
>>>=20
>>> sudo fsck.ext4 -f /dev/md0
>>> e2fsck 1.42.13 (17-May-2015)
>>> Pass 1: Checking inodes, blocks, and sizes
>>> Pass 2: Checking directory structure
>>> Pass 3: Checking directory connectivity
>>> Pass 4: Checking reference counts
>>> Pass 5: Checking group summary information
>>> /dev/md0: 70089/1220923392 files (3.6% non-contiguous),
>>> 7726498938/9767368960 blocks
>>>=20
>>> Following that, I tried to perform an offline resize:
>>>=20
>>> sudo resize2fs /dev/md0
>>> resize2fs 1.42.13 (17-May-2015)
>>> Resizing the filesystem on /dev/md0 to 13674316544 (4k) blocks.
>>> Should never happen: resize inode corrupt!
>>>=20
>>> After having done that, it looks like it should have been an online
>>> resize from reading a thread on here from 2015.
>>>=20
>>> After trying the resize I tried to do another fsck:
>>>=20
>>> sudo fsck.ext4 -f /dev/md0
>>> e2fsck 1.42.13 (17-May-2015)
>>> ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
>>> fsck.ext4: Group descriptors look bad... trying backup blocks...
>>> Superblock has an invalid journal (inode 8).
>>> Clear<y>? yes
>>> *** ext3 journal has been deleted - filesystem is now ext2 only ***
>>>=20
>>> Resize inode not valid.  Recreate<y>? yes
>>>=20
>>> It's been stuck here for days, with:
>>>=20
>>> 14827 root      20   0  141796 121044   2688 R  93.8  0.4   5546:26 fsck=
.ext4
>>>=20
>>> It's been running at around 100% the whole time.  I don't see any disk
>>> io happening either.
>>>=20
>>> sudo dumpe2fs -h /dev/md0
>>> dumpe2fs 1.42.13 (17-May-2015)
>>> Filesystem volume name:   <none>
>>> Last mounted on:          /Media10
>>> Filesystem UUID:          d36119d5-e3ec-47f7-b93e-124eb4598367
>>> Filesystem magic number:  0xEF53
>>> Filesystem revision #:    1 (dynamic)
>>> Filesystem features:      has_journal ext_attr resize_inode dir_index
>>> filetype extent 64bit flex_bg sparse_super large_file huge_file
>>> uninit_bg dir_nlink extra_isize
>>> Filesystem flags:         signed_directory_hash
>>> Default mount options:    user_xattr acl
>>> Filesystem state:         clean with errors
>>> Errors behavior:          Continue
>>> Filesystem OS type:       Linux
>>> Inode count:              1709293568
>>> Block count:              13674316544
>>> Reserved block count:     683715825
>>> Free blocks:              5886063280
>>> Free inodes:              1709223479
>>> First block:              0
>>> Block size:               4096
>>> Fragment size:            4096
>>> Group descriptor size:    64
>>> Blocks per group:         32768
>>> Fragments per group:      32768
>>> Inodes per group:         4096
>>> Inode blocks per group:   256
>>> RAID stride:              128
>>> RAID stripe width:        256
>>> Flex block group size:    16
>>> Filesystem created:       Sun Dec 17 10:10:08 2017
>>> Last mount time:          Sat Mar  9 17:58:06 2019
>>> Last write time:          Mon Mar 11 05:48:14 2019
>>> Mount count:              0
>>> Maximum mount count:      -1
>>> Last checked:             Mon Mar 11 05:16:14 2019
>>> Check interval:           0 (<none>)
>>> Lifetime writes:          29 TB
>>> Reserved blocks uid:      0 (user root)
>>> Reserved blocks gid:      0 (group root)
>>> First inode:              11
>>> Inode size:               256
>>> Required extra isize:     28
>>> Desired extra isize:      28
>>> Journal inode:            8
>>> Default directory hash:   half_md4
>>> Directory Hash Seed:      23fd4260-aee9-4f36-8406-240f3b7a39d2
>>> Journal backup:           inode blocks
>>> Journal superblock magic number invalid!
>>>=20
>>>=20
>>> Should I let the fsck continue, or is it safe to exit to try something e=
lse.
>>>=20
>>> I recently did an offline resize a few weeks ago on the same array and
>>> it worked out just fine.  I'm not sure what happened this time, I
>>> followed the same steps.
>>>=20
>>> Thanks for any help.
