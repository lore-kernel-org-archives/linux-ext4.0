From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [BUG] ext4: i_size, EOFBLOCKS_FS corruption with xfstests 269
Date: Wed, 18 Jul 2012 11:40:38 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207181137190.2291@dhcp-1-248.brq.redhat.com>
References: <50066C93.1070006@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab2GRJkq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jul 2012 05:40:46 -0400
In-Reply-To: <50066C93.1070006@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 18 Jul 2012, Akira Fujita wrote:

> Date: Wed, 18 Jul 2012 16:58:11 +0900
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> To: Theodore Tso <tytso@mit.edu>
> Cc: ext4 development <linux-ext4@vger.kernel.org>
> Subject: [BUG] ext4: i_size, EOFBLOCKS_FS corruption with xfstests 269
> 
> Hi,
> 
> I got a issue which makes i_size and EOFBLOCKS_FL corrupted
> on ext4 with xfstests 269.
> In my environment (linux-3.5-rc7), this can be reproduced
> once of 10 times trial.
> 
> Kernel: 3.5-rc7
> Arch: x86_64
> 
> Step and log are as bellow, after xfstests 269, e2fsck outputs
> i_size and EOFBLOCKS_FL corruption.
> Is this an already known issue?

Hi Akira,

thanks for reporting this. Could you please try to use the most
recent e2fsprogs ? The EOFBLOCKS_FL has been removed from e2fsprogs
with:

010dc7b90d97b93907cbf57b3b44f1c1cad234f6 e2fsck: remove
EXT4_EOFBLOCKS_FL flag handling

and is about to be removed from kernel as well, so the EOFBLOCKS_FL
problem probably does not even matter. Though the i_size problem
might be real.

Not sure if it is a known problem, but I've certainly seen it before
with xfstest 269, though I have not had time to look at this yet. So
I guess I should :).

Thanks!
-Lukas

> 
> # ./check 269
>     FSTYP         -- ext4
>     PLATFORM      -- Linux/x86_64 mcds1 3.5.0-rc7
>     MKFS_OPTIONS  -- /dev/sdb3
>     MOUNT_OPTIONS -- -o acl,user_xattr /dev/sdb3 /mnt/mp2
> 
>     269 97s ... [failed, exit status 1] - output mismatch (see 269.out.bad)
>     --- 269.out	2012-07-02 10:51:34.000000000 +0900
>     +++ 269.out.bad	2012-07-18 14:09:03.000000000 +0900
>     @@ -3,3 +3,4 @@
>      Run fsstress
> 
>      Run dd writers in parallel
>     +_check_generic_filesystem: filesystem on /dev/sdb3 is inconsistent (see 269.full)
>     Ran: 269
>     Failures: 269
>     Failed 1 of 1 tests
> 
> 
>     # cat 269.full
>       (snip)
> 
>     e2fsck 1.41.12 (17-May-2010)
>     Pass 1: Checking inodes, blocks, and sizes
>     Inode 2336, i_size is 625045, should be 1277952.  Fix? no
> 
>     Inode 3193 should not have EOFBLOCKS_FL set (size 1928717, lblk 218)
>     Clear? no
> 
>     Inode 4198 should not have EOFBLOCKS_FL set (size 380389, lblk 73)
>     Clear? no
> 
> 
> Regards,
> Akira Fujita
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
