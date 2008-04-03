From: Szabolcs Szakacsits <szaka@ntfs-3g.com>
Subject: Re: [ANNOUNCEMENT] Linux POSIX file system test suite
Date: Thu, 3 Apr 2008 07:12:12 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0804030705050.12223@tamago.serverit.net>
References: <Pine.LNX.4.62.0804022313390.664@tamago.serverit.net>
 <20080402222344.GC23382@mail.oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ntfs-3g-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.sourceforge.net, zfs-fuse@googlegroups.com,
	Marc Andre Tanner <mat@brain-dump.org>,
	Jean-Pierre ANDRE <jean-pierre.andre@wanadoo.fr>,
	linux-ext4@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tamago.serverit.net ([91.189.209.155]:60181 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751077AbYDCEM1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2008 00:12:27 -0400
In-Reply-To: <20080402222344.GC23382@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2 Apr 2008, Joel Becker wrote:
> On Thu, Apr 03, 2008 at 12:29:47AM +0300, Szabolcs Szakacsits wrote:
> > The test suite mostly checks POSIX compliance and works for FreeBSD, 
> > Solaris, and Linux with UFS, ZFS, ext3, and NTFS-3G file systems. The list 
> > of system calls tested is: chmod, chown, link, mkdir, mkfifo, open, rename, 
> > rmdir, symlink, truncate, unlink. There are currently 1950 regression 
> > tests.
> <snip> 
> > Availability:
> > 
> > 	http://ntfs3g.org/sw/qa/pjd-fstest-20080402.tgz
> 
> 	Very interesting.  ocfs2, running as 'ext3' mode, gets:
>
> Failed 9/184 test scripts, 95.11% okay. 32/1950 subtests failed, 98.36% okay.

That's not bad as a start and it doesn't necessarily mean that there is 
anything wrong with ocfs2. There are many cases when SuS says that the 
behavior can be implementation specific.

But we did find that following ext3 as close as possible will reduce the 
number of bug reports. We started from "574/1950 subtests failed, 70.56% 
okay."

Regards,
	    Szaka

--
NTFS-3G:  http://ntfs-3g.org
