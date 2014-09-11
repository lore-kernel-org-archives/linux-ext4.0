From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Thu, 11 Sep 2014 16:07:58 -0700
Message-ID: <20140911230758.GB11640@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911223347.GH17990@thunk.org>
 <20140911225022.GA10351@birch.djwong.org>
 <20140911225223.GJ17990@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34492 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaIKXIE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 19:08:04 -0400
Content-Disposition: inline
In-Reply-To: <20140911225223.GJ17990@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 06:52:23PM -0400, Theodore Ts'o wrote:
> On Thu, Sep 11, 2014 at 03:50:22PM -0700, Darrick J. Wong wrote:
> > 
> > Looks like most everything landed ok except for:
> > 
> > Yikes, make check explodes:
> 
> Hmm, works for me.  Could you make sure you've done a "make clean" and
> also a "git clean"?  In particular, make sure you don't have a
> leftover file in debugfs/jfs_user.h....

There aren't any stray jfs_user.h files, but rearranging DEBUGFS_CFLAGS seems
to fix it.  On Ubuntu 14.04 it seems that the compile command for
lib/ext2fs/journal.o is:

gcc -I. -I../../lib -I../../lib -Wall -g -O2 -fstack-protector --param=ssp-buffer-size=4 -DHAVE_CONFIG_H -I./../../e2fsck -DDEBUGFS -c ../../debugfs/journal.c -o journal.o

...which means that it picks up lib/ext2fs/jfs_user.h instead of the one in
e2fsck/.  The attached patch changes it to:

gcc -I./../../e2fsck -I. -I../../lib -I../../lib -Wall -g -O2 -fstack-protector --param=ssp-buffer-size=4 -DHAVE_CONFIG_H  -DDEBUGFS -c ../../debugfs/journal.c -o journal.o

...which runs the compile ok.

--D

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 597bed6..bc0dc8a 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -7,7 +7,7 @@ INSTALL = @INSTALL@
 DEPEND_CFLAGS = -I$(top_srcdir)/debugfs -I$(srcdir)/../../e2fsck -DDEBUGFS
 # This nastyness is needed because of jfs_user.h hackery; when we finally
 # clean up this mess, we should be able to drop it
-DEBUGFS_CFLAGS = $(ALL_CFLAGS) -I$(srcdir)/../../e2fsck -DDEBUGFS
+DEBUGFS_CFLAGS = -I$(srcdir)/../../e2fsck $(ALL_CFLAGS) -DDEBUGFS
 
 @MCONFIG@
 

