From: Eric Sandeen <sandeen@redhat.com>
Subject: RFC: "file" magic for ext4
Date: Wed, 30 Jan 2008 11:19:59 -0600
Message-ID: <47A0B1BF.4010109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbYA3RUB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 12:20:01 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0UHK08E004202
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 12:20:00 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0UHK0n9027206
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 12:20:00 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0UHJxLi026187
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2008 12:19:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This seems to work fine; any comments, either about
the logic, or the text descriptions, or the various
options I've shown/not shown?

To test, copy your "magic" file somewhere local, 
replace the ext2/3 section with the following,
and do something like:

# file -C -m magic; file -m ./magic -s /dev/sda1

-Eric

# ext2/ext3 filesystems - Andreas Dilger <adilger@turbolabs.com>
0x438   leshort         0xEF53          Linux
>0x44c  lelong          x               rev %d
>0x43e  leshort         x               \b.%d
# No journal?  ext2
>0x45c  lelong          ^0x0000004      ext2 filesystem data
>>0x43a leshort         ^0x0000001      (mounted or unclean)
# Has a journal?  ext3 or ext4
>0x45c  lelong          &0x0000004
#  and small INCOMPAT?
>>0x460 lelong          <0x0000040
#   and small RO_COMPAT?
>>>0x464 lelong         <0x0000008      ext3 filesystem data
#   else large RO_COMPAT?
>>>0x464 lelong         >0x0000007      ext4 filesystem data
#  else large INCOMPAT?
>>0x460 lelong          >0x000003f      ext4 filesystem data
# General flags for any ext* fs
>0x460  lelong          &0x0000004      (needs journal recovery)
>0x43a  leshort         &0x0000002      (errors)
# INCOMPAT flags
>0x460  lelong          &0x0000001      (compressed)
#>0x460 lelong          &0x0000002      (filetype)
#>0x460 lelong          &0x0000010      (meta bg)
>0x460  lelong          &0x0000040      (extents)
>0x460  lelong          &0x0000080      (64bit)
#>0x460 lelong          &0x0000100      (mmp)
#>0x460 lelong          &0x0000200      (flex bg)
# RO_INCOMPAT flags
#>0x464 lelong          &0x0000001      (sparse super)
>0x464  lelong          &0x0000002      (large files)
>0x464  lelong          &0x0000008      (huge files)
#>0x464 lelong          &0x0000010      (gdt checksum)
#>0x464 lelong          &0x0000020      (many subdirs)
#>0x463 lelong          &0x0000040      (extra isize)
