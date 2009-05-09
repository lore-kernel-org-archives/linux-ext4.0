From: "Don Bowman" <don@sandvine.com>
Subject: RE: ext4 corruption on md [7x1TB in RAID5]
Date: Sat, 9 May 2009 14:36:24 -0400
Message-ID: <EB618291F3454E4DA10D152B9045C01701D2836F@exchange-2.sandvine.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
To: "Don Bowman" <don@sandvine.com>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from Mail1.sandvine.com ([64.7.137.134]:29322 "EHLO
	mail2.sandvine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZEISg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 May 2009 14:36:29 -0400
Content-class: urn:content-classes:message
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Don Bowman
> 
> I cleanly shut down my system, and when it came back up, this was
> reported:
> 
> * Checking file systems...
> Sat May  9 13:00:53 2009
> 
> fsck 1.41.4 (27-Jan-2009)
> fsck.ext4: Unable to resolve 'UUID=52e18bf7-cbe9-4f58-824c-
> 5c943dd074de'^M
> fsck died with exit status 8

To follow my own email, the results of the 'findsuper' program are:

starting at 0, with 512 byte increments
byte_offset  byte_start     byte_end  fs_blocks blksz  grp
last_mount_time           sb_uuid label
       1024           0  6001228775424  1465143744  4096    0  Wed Apr
22 19:04:50 2009 52e18bf7
  134217728           0  6001228775424  1465143744  4096    1  Wed Apr
22 19:04:50 2009 52e18bf7
  402653184           0  6001228775424  1465143744  4096    3  Wed Apr
22 19:04:50 2009 52e18bf7
  671088640           0  6001228775424  1465143744  4096    5  Wed Apr
22 19:04:50 2009 52e18bf7
  939524096           0  6001228775424  1465143744  4096    7  Wed Apr
22 19:04:50 2009 52e18bf7
 1207959552           0  6001228775424  1465143744  4096    9  Wed Apr
22 19:04:50 2009 52e18bf7
 3355443200           0  6001228775424  1465143744  4096   25  Wed Apr
22 19:04:50 2009 52e18bf7
 3623878656           0  6001228775424  1465143744  4096   27  Wed Apr
22 19:04:50 2009 52e18bf7
 6576668672           0  6001228775424  1465143744  4096   49  Wed Apr
22 19:04:50 2009 52e18bf7
10871635968           0  6001228775424  1465143744  4096   81  Wed Apr
22 19:04:50 2009 52e18bf7
16777216000           0  6001228775424  1465143744  4096  125  Wed Apr
22 19:04:50 2009 52e18bf7
32614907904           0  6001228775424  1465143744  4096  243  Wed Apr
22 19:04:50 2009 52e18bf7
46036680704           0  6001228775424  1465143744  4096  343  Wed Apr
22 19:04:50 2009 52e18bf7
83886080000           0  6001228775424  1465143744  4096  625  Wed Apr
22 19:04:50 2009 52e18bf7
97844723712           0  6001228775424  1465143744  4096  729  Wed Apr
22 19:04:50 2009 52e18bf7
 ... [still going]

Can this help me somehow?


