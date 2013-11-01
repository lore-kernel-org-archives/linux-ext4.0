From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: "make check" broken on maint branch?
Date: Fri, 1 Nov 2013 10:35:56 +0800
Message-ID: <20131101023556.GA28605@gmail.com>
References: <CE98293A.7BB07%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40759 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3KACdk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Oct 2013 22:33:40 -0400
Received: by mail-pd0-f170.google.com with SMTP id v10so3227980pde.15
        for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 19:33:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CE98293A.7BB07%andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

On Thu, Oct 31, 2013 at 09:35:25PM +0000, Dilger, Andreas wrote:
> It seems that the current e2fsprogs "maint" branch has broken tests?
> At least on two different systems I tried this on had the same problem:
> 
>   r_64bit_big_expand: very large fs growth using ext4 w/64bit: failed
>   r_bigalloc_big_expand: ext4 with bigalloc: failed
>   r_ext4_big_expand: very large fs growth using ext4: failed
> 
> The test logs show:
> 
>   /tmp/e2fsprogs-tmp.VitAZy: 13/32768 files (7.7% non-contiguous),
> 6870/131072 blocks
>   ../resize/resize2fs -d 31 /tmp/e2fsprogs-tmp.VitAZy 2T
>   resize2fs 1.42.8 (20-Jun-2013)
>   The containing partition (or device) is only 131072 (4k) blocks.
>   You requested a new size of 536870912 blocks.
> 
> 
> I tried to add in a "truncate -s $SIZE_2 $TMPFILE", but it complains that
> it
> isn't able to truncate the file in /tmp to 2TB:
> 
>   truncating `/tmp/e2fsprogs-tmp.OGxb09' at 2199023255552 bytes: File too
> large
> 
> Testing manually, it seems I'm not allowed to create a file in tmpfs larger
> than 256GB.  How large does this file need to be for this test to be valid?
> 
> 
> I'm also seeing a consistent test failure in f_extent_oobounds on ONE of
> the
> two systems, though I can't see why the results are inconsistent since they
> have the same GCC, glibc and almost the same kernel (RHEL
> 2.6.32-358.11.1.el6
> and 2.6.32-279.5.1.el6, not that it should make any difference).
> 
>   more f_extent*.failed
>   --- f_extent_oobounds/expect.1  2013-10-31 20:01:06.299616314 +0000
>   +++ f_extent_oobounds.1.log     2013-10-31 21:16:21.008616804 +0000
>   @@ -1,24 +1,20 @@
>    Pass 1: Checking inodes, blocks, and sizes
>   -Inode 12, end of extent exceeds allowed value
>   -       (logical block 15, physical block 200, len 30)
>   -Clear? yes
>   -
>   -Inode 12, i_blocks is 154, should be 94.  Fix? yes
>   +Inode 12, i_blocks is 154, should be 0.  Fix? yes
> 
> This is still true after "make distclean" and rebuilding the whole tree.
> It seems that e2fsck isn't detecting the new PR_1_EXTENT_END_OUT_OF_BOUNDS
> problem on this system for some reason?  Usually this kind of inconsistency
> is due to some uninitialized stack variable being used that is different
> on the two systems.
> 
> 
> Anyone else seen these problems, or do I need to dig in further?

Yes, I also can see these problems.

Thanks,
                                                - Zheng
