From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: [PATCH 0/4] FS: userspace notification of errors
Date: Wed,  3 Jun 2009 18:05:14 +0300
Message-ID: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
Cc: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
	artem.bityutskiy@nokia.com
To: axboe@kernel.dk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60097 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbZFCPFq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 11:05:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello, 

these patches are resent (a bit re-worked and separated from other stuff).
The issue was discussed here:
http://marc.info/?l=linux-fsdevel&m=124402900920380&w=2

Summary:

1. Generic mechanism for notifications of user space about file system's
   errors/inconsistency on a particular partition using:

     - sysfs entry /sys/block/<bdev>/<part>/fs_unclean
     - uevent KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]

   Userspace might want to monitor these notifications (poll2() on sysfs 
   file or udevd's rule for uevent) and fix the fs damage.
   Filesystem can be marked clean again by writing '0' to the 
   corresponding 'fs_unclean' sysfs file.

   Currently some file systems remount themselves r/o on critical errors
   (*FAT; EXT2 depending on 'errors' mount option), userspace is generally
   unaware of such events. This feature will allow user space to become 
   aware of possible file system problems and do something about them 
   (e.g. run fsck automatically or with user's consent).
   [PATCH 1]

2. Make FAT and EXT2 file systems use the above mechanism to optionally
   notify user space about errors. Implemented as 'notify' mount option
   (PATCH 3,4).
   FAT error reporting facilities had to be re-factored (PATCH 2) in 
   order to simplify sending error notifications.

Adrian Hunter and Artem Bityutskiy provided input and ideas on implementing
these features.

Denis Karpov.
