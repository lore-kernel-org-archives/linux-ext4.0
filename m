From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/5] e2fsck logging improvements
Date: Sun, 18 Mar 2012 15:52:43 -0400
Message-ID: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40345 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab2CRTwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 15:52:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These improvements to e2fsck's logging capabilities were motiviated by
an fs corruption problem which caused the block group checksums to be
incorrect, and so some uninitalized bitmaps got read into memory, and
they contained garbage.  This resulted in e2fsck pass 5 output which was
extremely voluminous, and if the server was attached to a serial
console, could potentially delay the boot sequence by hours, which in
turn triggered a watchdog timer.

To avoid similar problems causing secondary ripple effects that are far
worse, we need to be able to control how much output gets sent to the
console, while also allowing the full log files to be written to disk
since it can contain valuable information.

So these patches allow the system administrator to limit the number of
problem reports which get sent to the console.  The full, unredacted
e2fsck output will still get written to the log file, however.

An additional bonus of doing things this way is that some distributions
have resisted using the logsave program to assure that fsck gets saved,
and with the advent of systemd, this may be even harder to configure
since the author of systemd doesn't believe in shell scripts.  So this
allows us to save the full set of fsck log files without having to mess
with obscure and undocumented distro-specific boot setups, whether it is
systemd or plymouth, or some other drug-induced nightmare that is
supposedly an improvement on sysvinit scripts.  It's an
ext2/3/4-specific solution, but.... oh, well.

						- Ted

Theodore Ts'o (5):
  e2fsck: add support for field widths in messages using %-expansion
  e2fsck: print the current and expected block group checksums
  e2fsck: print a notice when we've started suppressing a problem code
  e2fsck: add the max_count_problems setting in e2fsck.conf
  e2fsck: add logging capability

 e2fsck/Makefile.in                |  186 +++++++++++-------
 e2fsck/e2fsck.c                   |    3 +
 e2fsck/e2fsck.conf.5.in           |  146 ++++++++++++++
 e2fsck/e2fsck.h                   |   17 ++-
 e2fsck/logfile.c                  |  383 +++++++++++++++++++++++++++++++++++++
 e2fsck/message.c                  |  204 +++++++++++---------
 e2fsck/problem.c                  |   40 +++--
 e2fsck/problem.h                  |    3 +-
 e2fsck/super.c                    |    2 +
 e2fsck/unix.c                     |  266 +++++++++++++++-----------
 e2fsck/util.c                     |   99 ++++++----
 tests/f_illitable_flexbg/expect.1 |    2 +-
 tests/f_unused_itable/expect.1    |    4 +-
 13 files changed, 1023 insertions(+), 332 deletions(-)
 create mode 100644 e2fsck/logfile.c

-- 
1.7.9.107.g97f9a

