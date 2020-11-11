Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D010DC388F9
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Nov 2020 21:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A2C720825
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Nov 2020 21:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgKKVw2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 11 Nov 2020 16:52:28 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49736 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgKKVw2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Nov 2020 16:52:28 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 4A0CE1F45DAF
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     dhowells@redhat.com
Cc:     viro@zeniv.linux.org.uk, tytso@mit.edu, khazhy@google.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com
Subject: [PATCH RFC v2 0/8] Superblock Notifications
Date:   Wed, 11 Nov 2020 16:52:05 -0500
Message-Id: <20201111215213.4152354-1-krisman@collabora.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

This is a second RFC with an implementation to support superblock and
specifically ext4 notifications over the watch_queue interface, as
originally proposed by David Howells.  The original cover letter
follows.

This version of the RFC introduces the design changes requested by Ted
on the previous version (thanks).  It folds the _inode_error and
_inode_warning types into their error and warning counterparts.  This
version also introduces a patch to samples/ exemplifying how the
interface can be used.

I'm still sending it as an RFC as I'd love to gather a bit more
feedback, before actually proposing it for merging.

Dave, can you comment on the changes to watch_queue and how it fits
your original watch_queue model?

The reasoning for this work, and some background can be found in the
cover letter below.

I also shared the patches at:

https://gitlab.collabora.com/krisman/linux.git

under the tag ext4-error-notifications_RFC-v2

Thanks,

---
Original cover letter:

Google has been using an out-of-tree mechanism for error notification in
Ext4 and we decided it is time to push for an upstream solution.  This
would surely fit on top of David's notification work.

This patchset is an attempt to restart that discussion.  It forward ports
some code from David on top of Linus tree, adds features to
watch_queue and implements ext4 support.

The new notifications are designed after ext4 messages, so it exposes
notifications types to fit that filesystem, but it doesn't change much
to other filesystems, so it should be easily extensible.

I'm aware of the discussion around fsinfo, but I'd like to ask if there
are other missing pieces and what we could do to help that work go
upstream.  From a previous mailing list discussion, Linus complained
about lack of users as a main reason for it to not be merged, so hey! :)

In addition, I'd like to ask for feedback on the current implementation,
specifically regarding the passing of extra unformatted information at
the end of the notification and the ext4 support.

The work, as shared on this patchset can be found at:

  https://gitlab.collabora.com/krisman/linux.git -b ext4-error-notifications

And there is an example code at:

  https://gitlab.collabora.com/krisman/ext4-watcher

I'm Cc'ing Khazhismel Kumykov, from Google, who can provide more
information about their use case, if requested.
---

David Howells (3):
  watch_queue: Make watch_sizeof() check record size
  security: Add hooks to rule on setting a watch for superblock
  vfs: Add superblock notifications

Gabriel Krisman Bertazi (5):
  watch_queue: Support a text field at the end of the notification
  vfs: Include origin of the SB error notification
  fs: Add more superblock error subtypes
  ext4: Implement SB error notification through watch_sb
  samples: watch_queue: Add sample of SB notifications

 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 fs/Kconfig                             |  12 ++
 fs/ext4/super.c                        |  31 +++--
 fs/super.c                             | 127 +++++++++++++++++++++
 include/linux/fs.h                     | 150 +++++++++++++++++++++++++
 include/linux/lsm_hook_defs.h          |   1 +
 include/linux/lsm_hooks.h              |   4 +
 include/linux/security.h               |  13 +++
 include/linux/syscalls.h               |   2 +
 include/linux/watch_queue.h            |  21 +++-
 include/uapi/asm-generic/unistd.h      |   4 +-
 include/uapi/linux/watch_queue.h       |  54 ++++++++-
 kernel/sys_ni.c                        |   3 +
 kernel/watch_queue.c                   |  29 ++++-
 samples/watch_queue/Makefile           |   2 +-
 samples/watch_queue/watch_sb.c         | 114 +++++++++++++++++++
 security/security.c                    |   6 +
 18 files changed, 556 insertions(+), 19 deletions(-)
 create mode 100644 samples/watch_queue/watch_sb.c

-- 
2.29.2

