From: Andreas Dilger <adilger@sun.com>
Subject: FS_DIRECTIO_FL in VFS
Date: Thu, 05 Jun 2008 00:06:52 -0600
Message-ID: <20080605060652.GP2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49733 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYFEGGy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 02:06:54 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m5566sEf015975
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2008 23:06:54 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1Z000017K1MP00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 04 Jun 2008 23:06:54 -0700 (PDT)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was just looking at the FS_*_FL flags in a recent linux/fs.h, and
I see that there is now a FS_DIRECTIO_FL defined as 0x100000.  This
does not originate from ext* or e2fsprogs, and could result in a
conflict with a future ext* flag allocation without some attention
(at least defining it in e2fsprogs, along with EXT4_HUGE_FILE_FL 0x40000
which hasn't made it into e2fsprogs yet either).

There are a few things that worry me here:
- The migration of the EXT*_FL flags from ext*.h into fs.h has
  hidden the fact that these flags define the on-disk format of
  ext* inodes.  There is no comment that these flags even need
  to remain constant, and being part of an ioctl() interface
  makes this less likely to change than an internal constant,
  but it doesn't have the permanence of an on-disk (forever) constant.
- Since these values have been usurped from ext* into the VFS, we need
  to add a translation function in ext*_ioctl() to convert from the
  ioctl parameter into ext* values.  There is no guarantee that these
  mappings will remain identical.
- The ext2 code was changed to use the FS_*_FL values, but not
  ext3 and ext4.
- The inode attribute flag is only a 32-bit value, and if these flags
  are shared among all filesystems it could lead to exhaustion of the
  flags before we would have wanted for ext* or the VFS.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

