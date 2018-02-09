From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.43.9
Date: Fri, 9 Feb 2018 10:42:03 -0500
Message-ID: <20180209154203.GA5710@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54510 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbeBIPmF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Feb 2018 10:42:05 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In prepartion for a 1.44.x release, I've flushed out the remaining bug
fixes (including one which caused 1.43.8 to fail to build on big
endian systems) and released e2fsprogs 1.43.9 in all of the usual
places; it's tagged in the git trees on git.kernel.org, github, and
sourceforge, and available for download at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.9

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.9.tar.gz

The release notes for 1.43.9 can be found below.

                                    - Ted

E2fsprogs 1.43.9 (February 8, 2018)
===================================

Remove the huge file flag from libe2p (and hence from chattr/lsattr),
since it was never made visible by the kernel.  Remove the description
of some compression related flags, and add a description of the
encrypted file flag, and the project hierarchy flag.

Remove a misplaced "MNP is unsupported" message from debugfs.

Fix a build failure in lib/ext2fs/swapfs.c on big-endian systems.
(Addresses Debian Bug #886119)

Fix various Debian packaging issues.  (Addresses Debian Bug #269569).
