From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] more ext4 bug fixes for 3.7
Date: Tue, 30 Oct 2012 15:27:57 -0400
Message-ID: <nsxy5inoj42.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58512 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654Ab2J3T2E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 15:28:04 -0400
Subject: 
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to ffb5387e85d528fb6d0d924abfa3fbf0fc484071:

  ext4: fix unjournaled inode bitmap modification (2012-10-28 22:24:57 -0400)

----------------------------------------------------------------
This fixes the root cause of the ext4 data corruption bug which raised
a ruckus on LWN, Phoronix, and Slashdot.  This bug only showed up when
non-standard mount options (journal_async_commit and/or
journal_checksum) were enabled, and when the file system was not
cleanly unmounted, but the root cause was the inode bitmap
modifications was not being properly journaled.  This could
potentially lead to minor file system corruptions (pass 5 complaints
with the inode allocation bitmap) after an unclean shutdown under the
wrong/unlucky workloads, but it turned into major failure if the
journal_checksum and/or jouaral_async_commit  was enabled.

----------------------------------------------------------------
Eric Sandeen (1):
      ext4: fix unjournaled inode bitmap modification

 fs/ext4/ialloc.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)
