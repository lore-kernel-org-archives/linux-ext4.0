From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 0/2] Add tracepoints for ext3/jbd
Date: Mon, 23 May 2011 17:02:55 +0200
Message-ID: <1306162977-23061-1-git-send-email-lczerner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab1EWPDP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 11:03:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series adds fixed tracepoints into ext3 a nd jbd code. It has
been based on ext4 and jbd2 tracepoints and contains most of them. However
due to the differences in the code there are some tracepoint missing (all
multi-block allocation in ext4) and there are some added (inode reservation
windows in ext3).

Regarding jbd, there is not the code for collecting statistics and appropriate
tracepoints. That's because this code is little bit more intrusive, so I think
it deserves its own commit, hence can be added later if someone needs it.

The reason for those tracepoints is that our customer intend to use it
for monitoring and data collecting from servers running ext3. There is no
plan to migrate to ext4 any time soon.

These patches are as little intrusive as it can be, pretty straightforward and
should not change the behaviour at all.

Thanks!
-Lukas

--- 
[PATCH 1/2] ext3: Add fixed tracepoints
 fs/ext3/balloc.c            |   34 +-
 fs/ext3/fsync.c             |   15 +-
 fs/ext3/ialloc.c            |    4 +
 fs/ext3/inode.c             |   29 ++
 fs/ext3/namei.c             |    3 +
 fs/ext3/super.c             |   13 +
 include/trace/events/ext3.h |  888 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 970 insertions(+), 16 deletions(-)
 create mode 100644 include/trace/events/ext3.h
[PATCH 2/2] jbd: Add fixed tracepoints
 fs/jbd/checkpoint.c        |    4 +
 fs/jbd/commit.c            |   11 +++
 fs/jbd/journal.c           |    4 +
 include/trace/events/jbd.h |  203 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 222 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/jbd.h
