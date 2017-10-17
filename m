From: Theodore Ts'o <tytso@mit.edu>
Subject: Release of e2fsprogs 1.43.7
Date: Tue, 17 Oct 2017 12:42:46 -0400
Message-ID: <20171017164246.atxwp33wategeiba@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57602 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754644AbdJQQmr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 17 Oct 2017 12:42:47 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've released e2fsprogs 1.43.7 in all of the usual places; it's tagged
in the git trees on git.kernel.org, github, and sourceforge, and
available for download at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.7

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.7.tar.gz

The release notes for 1.43.7 can be found below.

E2fsprogs 1.43.7 (October 16, 2017)
===================================

Fix the error handling code in debugfs, fuse2fs and tune2fs so errors
trying to replay the journal won't accidentally result in a seg fault
if reopening the file system after the journal replay fails for some
reason.

Fix resize2fs to avoid it from either failing or corrupting the file
system image in certain corner cases when doing an off-line resize.

Fix many spelling mistakes in various man pages, code comments, and
program messages.

Fix e2fsck and debugfs so that maliciously corrupted file systems will
not cause buffer overflows.  (Addresses Debian Bugs: #873757, #878104)

Update German translation.  (Addresses Debian Bug: #833514)

Fixed various Debian Packaging Issues.  (Addresses Debian Bugs:
#873812, #873813, #876551)

Programming notes
-----------------

Test descritions have been shorted to fit in 80 columns.

Fix various tests to avoid leaving temp files in /tmp.
