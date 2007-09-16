From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Potential pitfall in the clusterfs extent patches for e2fsprogs
Date: Sat, 15 Sep 2007 21:22:40 -0400
Message-ID: <E1IWiqO-0002zY-0p@candygram.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42856 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXIPBWn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Sep 2007 21:22:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've been busy working on extents support in e2fsck, and so as part of
that I was looking at the clusterfs extent patches (mostly for
inspiration to see how they work).  One of the things which I noticed is
the patches seem to check the inode direct blocks, and if they look like
the extent header, but the EXTENTS_FL flag isn't set, it flags this as
an error.  

The problem with this is that it's fragile; you could potentially have
an inode that happens to have as its first block something which looks
like the extent magic number, and if the second block passes the extent
validity checks, e2fsck will flag an error --- and if e2fsck is run in
preen mode, it will just set the extent flag without prompting the user
or aborting the boot process.

Not a problem for people who are using it for testing, but if anyone is
using these patches in production (such as Gentoo, cough, who is
shipping the patches), I thought I should give a warning --- these
patches are not ready for prime-time, and anyone who wants to use it
production will probably want to take out that particular check.

						- Ted
