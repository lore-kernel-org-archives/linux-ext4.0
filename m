From: Andreas Dilger <adilger@sun.com>
Subject: mke2fs and lazy_itable_init
Date: Thu, 08 May 2008 16:48:47 -0600
Message-ID: <20080508224847.GR3627@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52639 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760930AbYEHWtO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 May 2008 18:49:14 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m48MnDI0010091
	for <linux-ext4@vger.kernel.org>; Thu, 8 May 2008 15:49:14 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K0K00A01NDAJ600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 08 May 2008 15:49:13 -0700 (PDT)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I just noticed lazy_itable_init in the mke2fs.8.in man page.  I think
a warning needs to be added there that this is not currently safe to
use, because the kernel does not yet do the background zeroing.  There
is nothing in the man page to indicate that this is unsafe...

 .B lazy_itable_init\fR[\fb= \fI<0 to disable, 1 to enable>\fR]
 If enabled and the uninit_bg feature is enabled, the inode table will
 not fully initialized by 
 .BR mke2fs .
 This speeds up filesystem
 initialization noitceably, but it requires the kernel to finish
 initializing the filesystem in the background when the filesystem is
 first mounted.  If the option value is omitted, it defaults to 1 to
 enable lazy inode table initialization.
+.BR NOTE :
+No kernels do the background zeroing of the inode table at this time,
+so this option is unsafe for production use, due to the risk of serious
+filesystem corruption if e2fsck has to scan the whole inode table for
+some reason (e.g. incorrect group descriptor checksum).

Sorry for half patch, but my GIT repo is broken somehow and I wanted to
email before I forget.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

