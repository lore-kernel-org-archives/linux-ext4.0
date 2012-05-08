From: Andreas Dilger <adilger@whamcloud.com>
Subject: Filesystem pathname distributions
Date: Tue, 8 May 2012 09:44:12 -0600
Message-ID: <9DF36917-829A-4E19-939F-B8377148758B@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50494 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2EHPoR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2012 11:44:17 -0400
Received: by pbbrp8 with SMTP id rp8so8185895pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 08 May 2012 08:44:16 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is an interesting analysis of filesystem pathname distributions
available in a master's thesis at:

http://www.pdl.cmu.edu/PDL-FTP/HECStorage/Yifan_Final.pdf

This shows (at least for the filesystems analyzed) that median
directory sizes continue to be quite small.  Looking at figure
10, 60-90% of all directories have 8 or fewer entries in them,
and in many cases 50% of directories have only 1 or 2 entries.

It would be useful for you to run the fsstats tool (available
from http://www.pdsi-scidac.org/fsstats/) against some filesystems
that you have access to (e.g. typical distro desktop and home
directory, file servers, etc) and compute what fraction of the
files and directories could be stored inside the inode.

Similarly, and perhaps more importantly, for any filesystems you
have using the bigalloc feature, compare the actual size of
files and directories (only the filename + 10 bytes) to see how
many you could fit into an inode of a given size.  A default
256-byte inode has about 100 bytes of space, a 512-byte inode
has about 350 bytes of space, etc).  It would be useful to see
if there is a clear win for having larger inodes to hold small
files/directories in bigalloc filesystems, or whether this would
waste more space in total than is wasted by allocating a full
bigalloc block for each inode.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




