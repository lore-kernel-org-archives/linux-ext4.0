From: Ted Ts'o <tytso@mit.edu>
Subject: Problems building xfsprogs
Date: Wed, 20 Jul 2011 13:59:18 -0400
Message-ID: <20110720175918.GB17971@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33784 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1GTR7U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jul 2011 13:59:20 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was trying to build xfsprogs in preparation for building xfstests in
an hermetic environment (as opposed to depending on magic XFS headers
being installed in /usr/include...)

What I found first of all (building on Ubuntu 10.10) was

a) "make configure" doesn't work until I patch the top-level Makefile:

diff --git a/Makefile b/Makefile
index c40fb2c..37973f5 100644
--- a/Makefile
+++ b/Makefile
@@ -82,7 +82,7 @@ configure:
 	libtoolize -c $(LIBTOOLIZE_INSTALL) -f
 	cp include/install-sh .
 	aclocal -I m4
-	autoconf
+	autoconf -I m4
 
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS

b) By default xfsprogs builds with DEBUG, and this causes building
libxfs/xfs_ialloc.c to blow up since there a reference of
xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
two figure this out....

					- Ted
