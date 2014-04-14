From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Date: Mon, 14 Apr 2014 23:05:47 +0900
Message-ID: <CAKYAXd9gAaffvTmsRpEVw_tOxHYvxJ1ffTYpK7dwV3gBnMOMEw@mail.gmail.com>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu>
	<20140413220016.GD8122@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:50416 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaDNOFr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Apr 2014 10:05:47 -0400
Received: by mail-qg0-f45.google.com with SMTP id j5so8124654qga.4
        for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2014 07:05:47 -0700 (PDT)
In-Reply-To: <20140413220016.GD8122@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
> Hi Namjae,
>
> One of the reasons this patch set is that after Lukas added
> COLLAPSE_RANGE support into fsx, we've started seeing a number of
> failures which seem to be directly related to COLLAPSE_RANGE.
>
> For your convenience, I've updated the root_fs.img file for the
> kvm-xfststs system in the xfstests-bld system:
>
> https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/root_fs.img.i386
>
> This has the latest xfstests (plus some bug fixes not yet in the
> xfstests upstream), which means it has the improved fsx.  With this
> updated xfstests, the tests which use fsx, such as generic/075 and
> generic/091, are failing for the 1k and bigalloc configuration, and if
> we apply this patch and then add to the kernel's boot command line:
>
>    ext4.fallocate_mode_block=0x08
>
> this will allow these tests to pass again.
>
> (An easy way to do this using kvm-xfstests is by creating the file
> custom.config with the line "EXTRA_ARG="ext4.fallocate_mode_block=0x08")
>
>
> In addition, although I haven't figured out why what is needed to
> create a reliable production, test generic/091 (with COLLAPSE_RANGE
> enabled) is sometimes causing a file system corruption which causes
> the xfstests run to abort.  (It does seem to reproduce more reliably
> if generic/091 is run as part of a "-g auto" run):
>
> e2fsck 1.42.9 (4-Feb-2014)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 20 has out of order extents
> 	(invalid logical block 3, physical block 492938, len 2)
> Clear? yes
>
> Inode 20, i_blocks is 368, should be 352.  Fix? yes
>
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -(492938--492939)
> Fix? yes
>
> Free blocks count wrong for group #15 (32657, counted=32659).
> Fix? yes
>
> Free blocks count wrong (1136513, counted=1136515).
> Fix? yes
>
>
> /dev/vdb: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/vdb: 10137/327680 files (5.4% non-contiguous), 174205/1310720 blocks
>
> (This was found in the standard 4k configuration, but in the test log
> below it was showing up in the dioread_nolock configuration).
>
> If you could take a look at some of these test failures, I'd be much
> obliged.
Hi. Ted.
I will take a look at this issue.
Thanks for your mail!
>
> Thanks!
>
> 						- Ted
>
