Return-Path: <SRS0=vuM7=RP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAA7C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 19:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E7E6214AE
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Mar 2019 19:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfCLT7R (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:59:17 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53190 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726329AbfCLT7R (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Mar 2019 15:59:17 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2019 15:59:16 EDT
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2CJp0GK012123
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Mar 2019 15:51:00 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B64FA4207E1; Tue, 12 Mar 2019 15:50:59 -0400 (EDT)
Date:   Tue, 12 Mar 2019 15:50:59 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext4 changes for 5.1
Message-ID: <20190312195059.GA19660@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Sorry, I thought I had sent this a week ago, but I had failed to push
the send button apparently...

The following changes since commit 49a57857aeea06ca831043acbb0fa5e0f50602fd:

  Linux 5.0-rc3 (2019-01-21 13:14:44 +1300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 0df6f46995a9fc92a6b9e591428e77527dd9609a:

  jbd2: jbd2_get_transaction does not need to return a value (2019-03-01 00:36:57 -0500)

----------------------------------------------------------------
A large number of bug fixes and cleanups.  One new feature to allow
users to more easily find the jbd2 journal thread for a particular
ext4 file system.

----------------------------------------------------------------
Andreas Dilger (1):
      ext4: don't update s_rev_level if not required

Dan Carpenter (1):
      ext4: fix some error pointer dereferences

Eric Whitney (1):
      ext4: fix bigalloc cluster freeing when hole punching under load

Geert Uytterhoeven (1):
      ext4: Change debugging support help prefix from EXT4 to Ext4

Jan Kara (1):
      ext4: fix crash during online resizing

Konstantin Khlebnikov (1):
      ext4: add sysfs attr /sys/fs/ext4/<disk>/journal_task

Liu Song (1):
      jbd2: jbd2_get_transaction does not need to return a value

Mathieu Malaterre (2):
      ext4: annotate implicit fall throughs
      ext4: annotate more implicit fall throughs

Nikolay Borisov (1):
      ext4: replace opencoded i_writecount usage with inode_is_open_for_write()

Theodore Ts'o (4):
      Revert "ext4: use ext4_write_inode() when fsyncing w/o a journal"
      ext4: disallow files with EXT4_JOURNAL_DATA_FL from EXT4_IOC_SWAP_BOOT
      jbd2: fix race when writing superblock
      jbd2: fold jbd2_superblock_csum_{verify,set} into their callers

Xiaoguang Wang (2):
      jbd2: fix deadlock while checkpoint thread waits commit thread to finish
      ext4: unlock unused_pages timely when doing writeback

luojiajun (1):
      jbd2: fix invalid descriptor block checksum

yangerkun (4):
      ext4: fix check of inode in swap_inode_boot_loader
      ext4: cleanup pagecache before swap i_data
      ext4: update quota information while swapping boot loader inode
      ext4: add mask of ext4 flags to swap

zhangyi (F) (5):
      jbd2: clear dirty flag when revoking a buffer from an older transaction
      jbd2: discard dirty data when forgetting an un-journalled buffer
      ext4: cleanup clean_bdev_aliases() calls
      jbd2: fix compile warning when using JBUFFER_TRACE
      ext4: fix compile error when using BUFFER_TRACE

 Documentation/ABI/testing/sysfs-fs-ext4 |   7 +++
 fs/ext4/Kconfig                         |   2 +-
 fs/ext4/ext4.h                          |   9 ++-
 fs/ext4/extents.c                       |  29 ++++-----
 fs/ext4/fsync.c                         |  13 ++--
 fs/ext4/hash.c                          |   2 +
 fs/ext4/indirect.c                      |   6 ++
 fs/ext4/inode.c                         |  21 +++----
 fs/ext4/ioctl.c                         | 101 +++++++++++++++++++++++---------
 fs/ext4/mballoc.c                       |   7 +--
 fs/ext4/page-io.c                       |   4 +-
 fs/ext4/resize.c                        |   3 +-
 fs/ext4/super.c                         |   1 -
 fs/ext4/sysfs.c                         |  13 ++++
 fs/ext4/xattr.c                         |   3 +
 fs/jbd2/checkpoint.c                    |  17 +++++-
 fs/jbd2/commit.c                        |   6 +-
 fs/jbd2/journal.c                       |  90 ++++++++++++----------------
 fs/jbd2/transaction.c                   |  83 +++++++++++++++++++-------
 19 files changed, 261 insertions(+), 156 deletions(-)
