From: Eryu Guan <eguan@redhat.com>
Subject: generic/346 fails on ext4 DAX mount
Date: Fri, 2 Jun 2017 13:33:19 +0800
Message-ID: <20170602053319.GF23805@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Xiong Zhou <xzhou@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbdFBFdV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Jun 2017 01:33:21 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I occasionally hit generic/344 and generic/346 failures when testing
4.12-rc[1-3] kernels on ext4 DAX mount.

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 hp-xl420gen9-01 4.12.0-rc3
MKFS_OPTIONS  -- /dev/pmem2
MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:root_t:s0 /dev/pmem2 /mnt/testarea/scratch

generic/344 1s ... 1s
generic/346 1s ... - output mismatch (see /var/lib/xfstests/results//generic/346.out.bad)
    --- tests/generic/346.out   2017-05-24 10:13:38.592436565 -0400
    +++ /var/lib/xfstests/results//generic/346.out.bad  2017-06-01 12:46:50.122007818 -0400
    @@ -10,7 +10,8 @@
     INFO: sz = 1048576
     INFO: thread 0 created
     INFO: thread 1 created
    -INFO: 0 error(s) detected
    +ERROR: thread 0, offset 000ff400, 00000000 != 7f1068063700
    +INFO: 1 error(s) detected
 
     INFO: ftruncate test...
     INFO: sz = 1048576

And it seems generic/346 is easer to hit, usually it can be reproduced
within 20 iterations on 4.12-rc kernels.

At first I thought it was a regression introduced in 4.12-rc1, but after
two failed bisects (pointed first bad to unrelated networking patch), I
enlarged the iteration count to 5000 and found that generic/346 failure
can also be seen on 4.11 and 4.10 kernel. I haven't tried other old
kernels yet. It's just much harder to hit on 4.10/4.11 kernels (need
hundreds of iterations).

But the failure could only be reproduced with ext4 DAX mount, XFS DAX
mount survived 5000 runs of generic/346 on 4.12-rc3 kernel.

I was testing with pmem device created by memmap kernel param
"memmap=10G!5G memmap=15G!15G", but it can be reproduced with brd
ramdisk too.

If more info is needed please let me know.

Thanks,
Eryu
