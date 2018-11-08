Return-Path: <SRS0=LXqi=NT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbeKIEY3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2018 23:24:29 -0500
Date: Thu, 8 Nov 2018 10:47:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Elana Hashman <Elana.Hashman@twosigma.com>
Cc: "'tytso@mit.edu'" <tytso@mit.edu>,
        "'linux-ext4@vger.kernel.org'" <linux-ext4@vger.kernel.org>
Subject: Re: Phantom full ext4 root filesystems on 4.1 through 4.14 kernels
Message-ID: <20181108184722.GB27852@magnolia>
References: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2018 at 05:59:18PM +0000, Elana Hashman wrote:
> Hi Ted,
> 
> We've run into a mysterious "phantom" full filesystem issue on our Kubernetes fleet. We initially encountered this issue on kernel 4.1.35, but are still experiencing the problem after upgrading to 4.14.67. Essentially, `df` reports our root filesystems as full and they behave as though they are full, but the "used" space cannot be accounted for. Rebooting the system, remounting the root filesystem read-only and then remounting as read-write, or booting into single-user mode all free up the "used" space. The disk slowly fills up over time, suggesting that there might be some kind of leak; we previously saw this affecting hosts with ~200 days of uptime on the 4.1 kernel, but are now seeing it affect a 4.14 host with only ~70 days of uptime.
> 
> Here is some data from an example host, running the 4.14.67 kernel. The root disk is ext4.
> 
> $ uname -a
> Linux <hostname> 4.14.67-ts1 #1 SMP Wed Aug 29 13:28:25 UTC 2018 x86_64 GNU/Linux
> $ grep ' / ' /proc/mounts
> /dev/disk/by-uuid/<some-uuid> / ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> 
> `df` reports 0 bytes free:
> 
> $ df -h /
> Filesystem                                              Size  Used Avail Use% Mounted on
> /dev/disk/by-uuid/<some-uuid>   50G   48G     0 100% /

This is very odd.  I wonder, how many of those overlayfses are still
mounted on the system at this point?  Over in xfs land we've discovered
that overlayfs subtly changes the lifetime behavior of incore inodes,
maybe that's what's going on here?  (Pure speculation on my part...)

> Deleted, open files account for almost no disk capacity:
> 
> $ sudo lsof -a +L1 /
> COMMAND    PID   USER   FD   TYPE DEVICE SIZE/OFF NLINK    NODE NAME
> java      5313 user    3r   REG    8,3  6806312     0 1315847 /var/lib/sss/mc/passwd (deleted)
> java      5313 user   11u   REG    8,3    55185     0 2494654 /tmp/classpath.1668Gp (deleted)
> system_ar 5333 user    3r   REG    8,3  6806312     0 1315847 /var/lib/sss/mc/passwd (deleted)
> java      5421 user    3r   REG    8,3  6806312     0 1315847 /var/lib/sss/mc/passwd (deleted)
> java      5421 user   11u   REG    8,3   149313     0 2494486 /tmp/java.fzTwWp (deleted)
> java      5421 tsdist   12u   REG    8,3    55185     0 2500513 /tmp/classpath.7AmxHO (deleted)
> 
> `du` can only account for 16GB of file usage:
> 
> $ sudo du -hxs /
> 16G     /
> 
> But what is most puzzling is the numbers reported by e2freefrag, which don't add up:
> 
> $ sudo e2freefrag /dev/disk/by-uuid/<some-uuid>
> Device: /dev/disk/by-uuid/<some-uuid>
> Blocksize: 4096 bytes
> Total blocks: 13107200
> Free blocks: 7778076 (59.3%)
> 
> Min. free extent: 4 KB
> Max. free extent: 8876 KB
> Avg. free extent: 224 KB
> Num. free extent: 6098
> 
> HISTOGRAM OF FREE EXTENT SIZES:
> Extent Size Range :  Free extents   Free Blocks  Percent
>     4K...    8K-  :          1205          1205    0.02%
>     8K...   16K-  :           980          2265    0.03%
>    16K...   32K-  :           653          3419    0.04%
>    32K...   64K-  :          1337         15374    0.20%
>    64K...  128K-  :           631         14151    0.18%
>   128K...  256K-  :           224         10205    0.13%
>   256K...  512K-  :           261         23818    0.31%
>   512K... 1024K-  :           303         56801    0.73%
>     1M...    2M-  :           387        135907    1.75%
>     2M...    4M-  :           103         64740    0.83%
>     4M...    8M-  :            12         15005    0.19%
>     8M...   16M-  :             2          4267    0.05%

Clearly a bug in e2freefrag, the percentages are supposed to sum to 100.
Patches soon.

--D

> 
> This looks like a bug to me; the histogram in the manpage example has percentages that add up to 100% but this doesn't even add up to 5%.
> 
> After a reboot, `df` reflects real utilization:
> 
> $ df -h /
> Filesystem                                              Size  Used Avail Use% Mounted on
> /dev/disk/by-uuid/<some-uuid>   50G   16G   31G  34% /
> 
> We are using overlay2fs for Docker, as well as rbd mounts; I'm not sure how they might interact.
> 
> Thanks for your help,
> 
> --
> Elana Hashman
> ehashman@twosigma.com
