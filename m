From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 2.6.27-git2
Date: Sun, 12 Oct 2008 18:16:53 -0400
Message-ID: <E1Kp9F7-0000Dd-RC@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39774 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753398AbYJLWQ6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Oct 2008 18:16:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This fixes a typo in fs/Kconfig, a build problem when CONFIG_PROC_FS is
not defined, and some patches that address error handling for disk write
failures that had been forward ported from ext3 by Hidehiro-san that I
hadn't time to audit before my last pull.

Thanks!!

                                                - Ted

Alexander Beregalov (1):
      ext4: fix build failure without procfs

Hidehiro Kawai (5):
      jbd2: abort when failed to log metadata buffers
      jbd2: fix error handling for checkpoint io
      ext4: add checks for errors from jbd2
      jbd2: don't dirty original metadata buffer on abort
      ext4: add an option to control error handling on file data

Jan Engelhardt (1):
      ext4: fix kconfig typo and extra whitespace

 Documentation/filesystems/ext4.txt |    5 +++
 fs/Kconfig                         |    4 +-
 fs/ext4/ext4.h                     |    2 +
 fs/ext4/ioctl.c                    |   12 ++++++---
 fs/ext4/super.c                    |   41 +++++++++++++++++++++++++++---
 fs/jbd2/checkpoint.c               |   49 +++++++++++++++++++++++++++---------
 fs/jbd2/commit.c                   |   10 ++++++-
 fs/jbd2/journal.c                  |   28 ++++++++++++++++----
 fs/jbd2/recovery.c                 |    7 +++-
 include/linux/jbd2.h               |    5 +++-
 10 files changed, 131 insertions(+), 32 deletions(-)
