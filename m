From: Eric Sandeen <sandeen@redhat.com>
Subject: Any qualms about reverting 3d0518f4, ext4: New rec_len encoding for
 very large blocksizes ?
Date: Tue, 03 Aug 2010 17:30:19 -0500
Message-ID: <4C58987B.2040602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0HCWaY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 18:30:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think we should possibly revert this commit, due to a perf regression:

commit 3d0518f4758eca4339e75e5b9dbb7e06a5ce08b4
Author: Wei Yongjun <yjwei@cn.fujitsu.com>
Date:   Sat Feb 14 23:01:36 2009 -0500

    ext4: New rec_len encoding for very large blocksizes

    The rec_len field in the directory entry is 16 bits, so to encode
    blocksizes larger than 64k becomes problematic.  This patch allows us
    to supprot block sizes up to 256k, by using the low 2 bits to extend
    the range of rec_len to 2**18-1 (since valid rec_len sizes must be a
    multiple of 4).  We use the convention that a rec_len of 0 or 65535
    means the filesystem block size, for compatibility with older kernels.

    It's unlikely we'll see VM pages of up to 256k, but at some point we
    might find that the Linux VM has been enhanced to support filesystem
    block sizes > than the VM page size, at which point it might be useful
    for some applications to allow very large filesystem block sizes.

    Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


It's a novel solution to the problem, but I'm not sure it's a problem
that needs to be solved today since we cannot even make filesystems with
> 64k blocks:

$ mkfs.ext4 -b 131072 fsfile
mkfs.ext4: invalid block size - 131072

Further, the patch un-inlines ext4_rec_len_from_disk() and adds
complexity to it, and this is a pretty hot function (called from
ext4_check_dir_entry) on a file-creation workload.

We could maybe try to fix it up or make it conditional on blocksize,
but it seems to me that there's no reason to have this complexity in the
codepaths today, when it's addressing an impossible situation.

Just for reference, the testing I did on RHEL6 was:

# bonnie++ -u root -s 0 -f -x 200 -d /mnt/test -n 32

(this does 200 iterations) and got this for the file creations:

ext4 stock:   Average =  21206.8 files/s
ext4 patched: Average =  22822.1 files/s

This is a 7.6% improvement...

Thoughts?

Thanks,
-Eric

-Eric
