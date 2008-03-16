From: Andreas Dilger <adilger@sun.com>
Subject: Re: strange ext{3,4}_settattr logic
Date: Sun, 16 Mar 2008 08:23:00 +0800
Message-ID: <20080316002300.GB26939@webber.adilger.int>
References: <20080315160731.GA4186@dmon-lap.sw.ru>
 <20080315230544.GV3542@webber.adilger.int>
 <20080315235427.GA26939@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38095 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYCPAXd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Mar 2008 20:23:33 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2G0NWxE011435
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 17:23:32 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXS00F01RQ6GV00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 15 Mar 2008 17:23:32 -0700 (PDT)
In-reply-to: <20080315235427.GA26939@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 16, 2008  07:54 +0800, Andreas Dilger wrote:
> A call to  inode_setattr() can fail by trying a shrinking vmtruncate()
> on a swapfile, which returns ETXTBUSY.  This was added after the
> ext3_setattr() code was written.
> 
> We need to handle the IS_SWAPFILE() case properly.
> Granted, it probably isn't a very common problem, but the IS_SWAPFILE()
> check was added explicitly because of clueless users, so it must be hit
> occasionally in real life.
> 
> It would seem that if you have a swapfile, try to truncate it to 0 (which
> will fail with -ETXTBUSY) and then unmount the filesystem the size will
> be truncated to 0.  It is also possible to directly write to a swapfile
> and corrupt memory, or read from a swapfile and access potentially sensitive
> information.

Dmitri, (or anyone)
can you please give this patch a try.  It should be OK, but I'm hesitant
to test it on my test box because I'm out of town and if it fails to
reboot I can't fix it for a week.  It _should_ still be possible to chown,
rename, ls, etc the swapfile, can you please verify that in addition
to the simple test in my previous email.

Note that the "dd" test I did previously was incorrect since "dd"
was trying to do a truncate before the write, it needs to be run with
conv=notrunc, and then the write succeeds:

[root@lin-cli1 tests]# dd if=/dev/zero of=/tmp/foo bs=4k count=1 seek=99
dd: advancing past 405504 bytes in output file `/tmp/foo': Text file busy
[root@lin-cli1 tests]# dd if=/dev/zero of=/tmp/foo conv=notrunc bs=4k count=1
seek=99
1+0 records in
1+0 records out
[root@lin-cli1 tests]# ls -l /tmp/foo
404 -rw-r--r--  1 root root 409600 Mar 15 17:56 /tmp/foo
[root@lin-cli1 tests]# debugfs -R "stat /tmp/foo" /dev/hda1
debugfs 1.40.2.cfs4 (12-Jul-2007)
Inode: 1346639   Type: regular    Mode:  0644   Flags: 0x0   Generation:
2276953
732
User:     0   Group:     0   Size: 405504
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 808
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x47dc6211 -- Sat Mar 15 17:56:01 2008
atime: 0x47dc5f06 -- Sat Mar 15 17:43:02 2008
mtime: 0x47dc6211 -- Sat Mar 15 17:56:01 2008
dtime: 0x00148c4f -- Fri Jan 16 07:03:59 1970
BLOCKS:
(0):2688759, (1-11):2688800-2688810, (IND):2688811, (12-44):2688812-2688844,
(45):2689410, (46-99):2689460-2689513
TOTAL: 101



--- linux-2.6.24/fs/namei.c.orig	2008-02-05 07:29:57.000000000 +0800
+++ linux-2.6.24/fs/namei.c	2008-03-16 08:11:41.000000000 +0800
@@ -233,6 +233,10 @@ int permission(struct inode *inode, int 
 	if (nd)
 		mnt = nd->mnt;
 
+	/* Don't allow direct read, write, or truncate on a swapfile */
+	if (IS_SWAPFILE(inode))
+		return -ETXTBUSY;
+
 	if (mask & MAY_WRITE) {
 		umode_t mode = inode->i_mode;
 


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

