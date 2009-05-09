From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 corruption on md [7x1TB in RAID5]
Date: Sat, 09 May 2009 12:56:15 -0600
Message-ID: <20090509185615.GN3209@webber.adilger.int>
References: <EB618291F3454E4DA10D152B9045C01701D2836F@exchange-2.sandvine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Don Bowman <don@sandvine.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61035 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZEIS40 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 May 2009 14:56:26 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n49IuRMf010289
	for <linux-ext4@vger.kernel.org>; Sat, 9 May 2009 11:56:27 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KJE00A004LLA000@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sat,
 09 May 2009 11:56:27 -0700 (PDT)
In-reply-to: <EB618291F3454E4DA10D152B9045C01701D2836F@exchange-2.sandvine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 09, 2009  14:36 -0400, Don Bowman wrote:
> To follow my own email, the results of the 'findsuper' program are:
> 
> starting at 0, with 512 byte increments
> byte_offset  byte_start       byte_end   fs_blocks blksz  grp last_mount_time           sb_uuid label
>        1024           0  6001228775424  1465143744  4096    0  Wed Apr 22 19:04:50 2009 52e18bf7
>   134217728           0  6001228775424  1465143744  4096    1  Wed Apr 22 19:04:50 2009 52e18bf7
>   402653184           0  6001228775424  1465143744  4096    3  Wed Apr 22 19:04:50 2009 52e18bf7
>   671088640           0  6001228775424  1465143744  4096    5  Wed Apr 22 19:04:50 2009 52e18bf7
>   939524096           0  6001228775424  1465143744  4096    7  Wed Apr 22 19:04:50 2009 52e18bf7
>  1207959552           0  6001228775424  1465143744  4096    9  Wed Apr 22 19:04:50 2009 52e18bf7
>  3355443200           0  6001228775424  1465143744  4096   25  Wed Apr 22 19:04:50 2009 52e18bf7
>  3623878656           0  6001228775424  1465143744  4096   27  Wed Apr 22 19:04:50 2009 52e18bf7
>  6576668672           0  6001228775424  1465143744  4096   49  Wed Apr 22 19:04:50 2009 52e18bf7
> 10871635968           0  6001228775424  1465143744  4096   81  Wed Apr 22 19:04:50 2009 52e18bf7
> 16777216000           0  6001228775424  1465143744  4096  125  Wed Apr 22 19:04:50 2009 52e18bf7
> 32614907904           0  6001228775424  1465143744  4096  243  Wed Apr 22 19:04:50 2009 52e18bf7
> 46036680704           0  6001228775424  1465143744  4096  343  Wed Apr 22 19:04:50 2009 52e18bf7
> 83886080000           0  6001228775424  1465143744  4096  625  Wed Apr 22 19:04:50 2009 52e18bf7
> 97844723712           0  6001228775424  1465143744  4096  729  Wed Apr 22 19:04:50 2009 52e18bf7
>  ... [still going]
> 
> Can this help me somehow?

These are all showing available backup superblocks and group descriptors.
Pick one of the "grp" numbers and use that as the argument for "-b" per
my previous email:  "e2fsck -f -b $((729 * 32768)) -B 4096 /dev/XXX".
A backup first is still a good idea, however.

Note that this appears to be a bug that has been hit by several Ubuntu
users.  I would suggest to upgrade to the latest vanilla kernel (at
least 2.6.29.stable, search the archives for details), which has fixed
it for many users.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

