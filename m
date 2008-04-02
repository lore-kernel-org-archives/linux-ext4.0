From: Szabolcs Szakacsits <szaka@ntfs-3g.com>
Subject: [ANNOUNCEMENT] Linux POSIX file system test suite (fwd)
Date: Thu, 3 Apr 2008 00:47:37 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0804030034200.664@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tamago.serverit.net ([91.189.209.155]:43937 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758241AbYDBWGh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Apr 2008 18:06:37 -0400
Received: from szaka (helo=localhost)
	by mail.hosting2.serverit.net with local-esmtp (Exim 4.63)
	(envelope-from <szaka@ntfs-3g.org>)
	id 1JhAnx-0001vv-2a
	for linux-ext4@vger.kernel.org; Thu, 03 Apr 2008 00:47:37 +0300
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi extX developers,

This is a resend as a consequence of the ext3 home page at 
http://ext2.sourceforge.net/ referring to 
http://fedoraproject.org/wiki/ext3-devel which is referring to 
ext2-devel@lists.sourceforge.net which asked me to resend here.

---------- Forwarded message ----------
Date: Thu, 3 Apr 2008 00:29:47 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
    ext2-devel@lists.sourceforge.net, zfs-fuse@googlegroups.com,
    Marc Andre Tanner <mat@brain-dump.org>,
    Jean-Pierre ANDRE <jean-pierre.andre@wanadoo.fr>
To: ntfs-3g-devel@lists.sf.net
Subject: [ANNOUNCEMENT] Linux POSIX file system test suite


Hello file system developers,

There are several POSIX file system test suites: closed source, commercial, 
one which needs reading 174 pages installation guide, etc. Because of these 
frustrations when Pawel Jakub Dawidek ported ZFS to FreeBSD, he also wrote 
such a test suite quickly.

Last year the NTFS-3G team ported it to Linux/ext3 and Linux/NTFS-3G to 
validate Jean-Pierre Andre's full file permissions and ownership support 
for NTFS-3G. We sent our patches to Pawel for integration but this doesn't 
seem to happen him (he didn't see problems but is busy).

Since this topic regularly appears on several lists, we are also often 
asked about it and NTFS-3G does need it to be maintained, hence we decided 
to release it and if nobody else would like to maintain it then we will do 
so.

The test suite mostly checks POSIX compliance and works for FreeBSD, 
Solaris, and Linux with UFS, ZFS, ext3, and NTFS-3G file systems. The list 
of system calls tested is: chmod, chown, link, mkdir, mkfifo, open, rename, 
rmdir, symlink, truncate, unlink. There are currently 1950 regression 
tests.

Availability:

	http://ntfs3g.org/sw/qa/pjd-fstest-20080402.tgz

  and in the NTFS-3G CVS as pjd-fstest module:

	http://sourceforge.net/cvs/?group_id=181143

The usage is extremely simple:

  # tar czf pjd-fstest-20080402.tgz
  # cd pjd-fstest-20080402
  # vi tests/conf
  Change 'fs' to file system type you want to test (UFS, ZFS, ext3, ntfs-3g).
  # make
  It will compile fstest utility which is used by regression tests.
  # cd /path/to/file/system/you/want/to/test/
  The test must be run as root user and requires a few basic Perl modules.
  # prove -r /path/to/fstest/

It's also possible to run individual set of tests:

  # /path/to/fstest/tests/chown/00.t

Or make single system call tests:

  # fstest mkdir foo 0750
  0
  # fstest mkdir foo 0750
  mkdir returned -1
  EEXIST

The test suite is easy to understand, modify and extend. For instance doing 
a test cases for the above examples is only

  expect 0 fstest mkdir foo 0750
  expect EEXIST fstest mkdir foo 0750

The default file system type is ext3 and it passes all tests.

NTFS-3G also passes all the tests if the latest PERMISSION_HANDLING_BRANCH 
CVS branch is used with the below UserMapping file placed in the .NTFS-3G 
control directory:

--------------------------------------------------------------->
:500:S-1-5-21-2271520284-214583110-2989893066-513
500::S-1-5-21-2271520284-214583110-2989893066-1007
# default mapping pattern
::S-1-5-21-2271520284-214583110-2989893066-10000
<--------------------------------------------------------------

Many thanks to Pawel Jakub Dawidek for writing this fantastic test suite, 
to Jean-Pierre Andre for tirelessly working on the port and fixing 
countless file system problems over the last half year and to Szeredi 
Miklos for his exceptionally rapid FUSE fixes.

Enjoy,
	    Szaka

--
NTFS-3G:  http://ntfs-3g.org

