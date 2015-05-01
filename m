From: Christian Kujau <lists@nerdbynature.de>
Subject: large directory entry
Date: Thu, 30 Apr 2015 22:02:58 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.7.1504301634450.29119@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:39140 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbbEAFMR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2015 01:12:17 -0400
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 6014B3DB57
	for <linux-ext4@vger.kernel.org>; Fri,  1 May 2015 07:02:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 2F99E3DADD
	for <linux-ext4@vger.kernel.org>; Fri,  1 May 2015 07:02:59 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have a somewhat larger "directory entry" on this ext4 filesystem, and it 
takes quite some time to list its contents:

------------------------------------
# time ls -lah /var/lib/php5
total 18M
drwxrwx--T.  6 root     www-data  18M Apr 28 04:41 .
drwxr-xr-x. 48 root     root     4.0K Apr 28 06:03 ..
drwxr-xr-x.  5 root     root     4.0K Apr 28 04:41 modules
drwxr-xr-x.  2 www-data www-data 4.0K Oct  9  2014 owncloud-51d9c764244bc
drwxr-xr-x.  2 www-data www-data 4.0K Jan  6 23:27 owncloud-oc55674097b9
drwx-wx-wt.  2 root     root      92K May  1 01:14 sessions

real    0m39.292s
user    0m0.000s
sys     0m3.964s
------------------------------------

Notice the "18M" entry for "." - I realize this is a directory for 
temporary files, meaning that lots of files are generated here, but
the server is not _that_ busy; according to lsof(8) no files are
currently open in /var/lib/php5 and only the "sessions" directory
contains 100 files, there are far less files below the other directories.

Once the above is run, the next run of "ls" is fast, of course:

------------------------------------
# time ls -Rl /var/lib/php5 | wc -l
119

real    0m0.017s
user    0m0.004s
sys     0m0.008s
------------------------------------

There isn't really much content here, copying the structure to a new 
directory results in ~450 KB of data.

I feel like this is some kind of FAQ, but I could not find anything 
similar for Ext4. The only similar thing I could think of is an older 
bug[0] in JFS, where a directory slowly grows when many files are 
generated & deleted, but I could not reproduce this for Ext4.

The /var/lib/php5 directory from above is located on an Ext4 filesystem 
from 2010, now running a 3.16 kernel (Debian/jessie, amd64), with the 
following features as per tune2fs(8):

  Filesystem features:      has_journal ext_attr resize_inode dir_index
       filetype needs_recovery extent sparse_super large_file uninit_bg
  Filesystem flags:         signed_directory_hash

Mount options:

  /dev/sda1 on / type ext4 (rw,relatime,data=ordered)


Any pointers what's going on here?

Thanks,
Christian.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=15154
-- 
BOFH excuse #268:

Neutrino overload on the nameserver
