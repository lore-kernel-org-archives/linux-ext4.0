From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.43.6
Date: Thu, 31 Aug 2017 11:37:22 -0400
Message-ID: <20170831153722.pyyp6s6lzr7b7wcs@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45786 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbdHaPhY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Aug 2017 11:37:24 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released e2fsprogs 1.43.6 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for download at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.6

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.6.tar.gz

The release notes for 1.43.6 can be found below.

E2fsprogs 1.43.6 (August 29, 2017)
==================================

Fix printing of quota inconsistency messages on 32-bit platforms in
e2fsck.  Also fix a bug which cause project quota problems to be
labelled as group quota problems.

Fix UI problems caused by fuzzy translations such that some messages
are in English and some are in the foreign language, and it's not
obvious to user how to answer yes/no questions.  (Addresses Debian
Bug: #856586).

Fix some out-of-bounds memory accesses in e2fsck caused by (usually
maliciously) corrupted file systems.  (Addresses Debian Bugs: #871539,
#871540)

Optimize CPU usage in e2fsck for very large, very fragmented sparse
files.

Add an optional mode in e2fsck which trades off additional memory for
CPU time when processing file systems that are heavily hard-linked.
(This can be a very large amount of memory, so this feature is
disabled for now.  How to automatically determine when it would be
helpful to enable this optimization, and when it is _safe_ to enable
this optimization is still a bit of a research problem.)

The mke2fs program will automatically upsize the inode size to 256 if
it is not explicitly specified on command-line and the default inode
size is not large enough to support the project quota feature
requested by the user.  If the inode size is explicitly specified to
be 128 bytes, and the project quota is enabled mke2fs will fail since
with an error explaining that project id's can't be supported when the
inode size is < 256 bytes.

The tune2fs program will not allow the project feature or project
quotas to be enabled in the inode size is 128 bytes.

The tune2fs progam now prints a more understandable message explaining
that the file system needs to be checked using e2fsck -f before
running certain complex tune2fs operations.  (Addresses Debian Bug:
#857336)

If the proceed_delay option is enabled in /etc/e2fsck.conf, the message
indicating that user can wait N seconds to proceed was ambiguous.
That message has been made more clear.  (Addresses Debian Bug:
#857336)

Fix LFS bug which caused e2image to fail to create regular e2image
files which are larger than 2 GiB on 32-bit platforms.  (Addresses
Debian Bug: #855246)

Fix FreeBSD portability problem caused by the fact that they no longer
use block devices.  (Disks are character mode devices.)

Update the Czech, French, Polish, Swedish, and Vietnamese translations.

Fixed various Debian Packaging Issues.


Programming notes
-----------------

Avoid changing the blkid cache when running tests.  (Normally the
blkid cache is not writable by the user running tests, but...)

The tar file generation process will now create reproducible
artifacts.

Removed legacy entries for ext4dev in the default mke2fs.conf file.
