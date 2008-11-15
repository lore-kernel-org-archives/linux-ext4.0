From: bmj001@ippimail.com (Bruce Jerrick)
Subject: Conversion to ext4 renders a filesystem unbootable
Date: Sat, 15 Nov 2008 05:04:50 -0800
Message-ID: <491ec8f2.h+/NctvgrQETYou26OH9qFQ1@Brain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: sandeen@redhat.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from c-98-246-49-80.hsd1.or.comcast.net ([98.246.49.80]:55537 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751700AbYKSDpW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Nov 2008 22:45:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Despite ext4[dev] support in Fedora 9 and 10, conversion of an ext3 filesystem
to ext4 will render it permanently unbootable (read on; there's a "yes, I know"
down there).

I'm not looking for a rescue (this was all done to an expendable system), and
it appears to be a known "issue", but additional warnings in 'man tune2fs'
(or even in the executable) seem to be warranted.

The scenario was:

On a multi-boot machine with my main system being Fedora 8 (with
kernel-2.6.26.6-49.fc8 and e2fsprogs-1.41.3-2.fc9, so it has ext4dev support),
I "converted" an ext3 filesystem by setting 'test_fs' with tune2fs, then
mounting it (successfully) under the F8 system as type ext4dev.

The converted filesystem contained an F10 installation all on one filesystem,
i.e., no separate /boot .  (I had overlooked the fact that the anaconda
installer doesn't support ext4 on a bootable partition; the goal was just to
make sure I can access F10 ext4 filesystems from the F8 system.)  Later I
discovered that the F10 system wouldn't boot, with a message about
"unsupported features".

Presumably this was because it now uses extents instead of indirect blocks
(after it was ext4, I modified a file on it, so I assume it started
using extents).  The really bad news is that this conversion seems to
be irreversible.  So there should probably be warnings in 'man tune2fs'
similar to those in 'man mkfs.ext4' (and also a warning about rendering a
partition permanently unbootable).

BTW, there's a minor inconsistency in F10 'man mke2fs' (and its hardlink
clones).  In the OPTIONS section, "-O" has "extent" listed, but the example
after "-t fs-type" uses "-O extents" (granted, either form seems to be
accepted).

Similarly, 'tune2fs -l' reports "extent" (in Filesystem features), but
/etc/mke2fs.conf uses "extents" (as a features value).

-- Bruce Jerrick

PS.  If feasible, a two-way ext3 <-> ext4 converter would be nice.
PPS.  Are bootable ext4 partitions in the cards?  (I assume yes.)
PPPS.  Why am I still using F8?  <flame> Because gnome-session/gnome-terminal
 save/restore is (repairably) broken in F9 and gone entirely in F10. </flame>

