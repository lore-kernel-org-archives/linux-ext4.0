From: Theodore Ts'o <tytso@mit.edu>
Subject: e2fsprogs update
Date: Tue, 01 Jan 2013 22:24:20 -0500
Message-ID: <nsxpq1ol123.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41262 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab3ABDYY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jan 2013 22:24:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've just pushed out large number of updates to e2fsprogs's git
repository.  The maint branch is close to what I hope to release as
1.42.7.  It has the flex_bg resize2fs fixes, and is gcc -Wall clean.

Please test it out, and let me know if you see any issues before we do a
release.

One known issue.  There still seems to be some resize2fs problems when
the 64-bit feature is set when doing off-line (unmounted) resizing:

touch /mnt/testfs
truncate -s 8T /mnt/testfs
mke2fs -t ext4 -O 64bit /mnt/testfs
e2fsck -fy /mnt/testfs
truncate -s 20T /mnt/testfs
resize2fs -p /mnt/testfs
e2fsck -fy /mnt/testfs
#
# Pass 5 errors found:
#
# Free blocks count wrong (1031374305, counted=5326341601).
# Fix<y>? yes
truncate -s 21T /mnt/testfs
resize2fs -p /mnt/testfs
e2fsck -fy /mnt/testfs
#
# Pass 5 errors found:
#
# Block bitmap differences:  +(1073774592--1073807359)
# Fix<y>? yes
# Free blocks count wrong for group #32769 (32768, counted=0).
# Fix<y>? yes
# Free blocks count wrong (1297725793, counted=5592660321).
# Fix<y>? yes

Apparently somehow the blocks associated with the journal inode got
released as part of the resize2fs.  I'm not sure what's going on, but
this is clearly something we'll want to fix up before we release 1.42.7.
Still, it's much less serious set of problems than we had before.

                                            - Ted
