From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.43.8
Date: Tue, 2 Jan 2018 15:00:22 -0500
Message-ID: <20180102200022.GA12939@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44150 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbeABUAY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Jan 2018 15:00:24 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released e2fsprogs 1.43.8 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for download at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.8

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.8.tar.gz


n.b.  There is a known bug which causes a build failure on big endian
systems.  Unfortunately it was only noticed after the release was
tagged, uploaded, and sent off to the Debian autobuilders:

https://buildd.debian.org/status/package.php?p=e2fsprogs

A patch for this will be showing up in the maint branch very shortly:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=886119

The release notes for 1.43.8 can be found below.

                                    - Ted

E2fsprogs 1.43.8 (January 1, 2018)
==================================

Fix a bug where updated bitmap checks might not be written to disk.
(Addresses Debian Bug: #883869)

Some newly added fields in the superblocks were not getting byte
swapped (which were not noticed since big endian systems are amazingly
unpopular).  Fix them and compile-time checks to avoid this class of
bugs from happening in the future.  (Lustre Bug #9309)

Fix a potential use after free bug in e2fsck when fixing a corrupted
root node in directory hash tree.

Fix a bug in e2fsck where a badly/maliciously corrupted superblock
(which is not fixed due to the -n option, for example) can cause a
floating point exception when printing the summary statistics.
(Addresses Debian Bug: #879220)

Fix debugfs's ncheck command so that it correctly prints the inode
number when printing an error message.

Fix a bug in e2freefrag where it could print an incorrect free blocks
count on a file system with the 64-bit block number feature.

Update the German, Serbian, Spanish, and Ukrainian translations.

Fix a bug where resize2fs's free blocks sanity check could fail with a
false positive and refuse to check a file system with the 64-bit block
number feature.

Fix and clarify various man pages and documentations.  Also fixed up
some random usage texts that were incorrect.  (Addresses Debian Bugs:
#880483)

Fixed various Debian Packaging Issues.  (Addresses Debian Bugs: #880207,
#881408, #881590, #881591)

Programming notes
-----------------

Fix various compiler warnings.

Clean up Makefile output.

Fix compatibility problems with glibc 2.27 casued by a collision with
copy_file_range().

				    
