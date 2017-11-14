From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] Quota, ext2, isofs, udf fixes for 4.15-rc1
Date: Tue, 14 Nov 2017 11:23:43 +0100
Message-ID: <20171114102343.GF7053@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50331 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753997AbdKNKXo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 14 Nov 2017 05:23:44 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

The pull contains two small quota error handling fixes, two isofs fixes for
architectures with signed char, several udf block number overflow and
signedness fixes, ext2 rework of mount option handling to avoid GFP_KERNEL
allocation with spinlock held. The pull also contains a patch to implement
auditing of responses to fanotify permission events. That should have been in
the first pull request but I've mistakenly merged that patch into a wrong
branch and noticed only now at which point I don't think it's worth rebasing
and redoing the pull request. Sorry for that.

Top of the tree is 838bee9e756e. The full shortlog is:

Arnd Bergmann (2):
      isofs: fix timestamps beyond 2027
      isofs: use unsigned char types consistently

Chao Yu (1):
      quota: be aware of error from dquot_initialize

Jan Kara (5):
      ext2: Parse mount options into a dedicated structure
      ext2: Fix possible sleep in atomic during mount option parsing
      udf: Avoid overflow when session starts at large offset
      udf: Remove some outdate references from documentation
      Merge udf, isofs, quota, ext2 changes for 4.15-rc1.

Steve Grubb (1):
      audit: Record fanotify access control decisions

Steve Magnani (3):
      udf: Fix 64-bit sign extension issues affecting blocks > 0x7FFFFFFF
      udf: Fix signed/unsigned format specifiers
      udf: Fix some sign-conversion warnings

zhangyi (F) (1):
      quota: fix potential infinite loop

The diffstat is

 Documentation/filesystems/udf.txt  |   8 +-
 fs/ext2/super.c                    | 161 ++++++++++++++++++------------------
 fs/isofs/isofs.h                   |  22 ++---
 fs/isofs/rock.h                    |  64 +++++++--------
 fs/isofs/util.c                    |   2 +-
 fs/notify/fanotify/fanotify.c      |   8 +-
 fs/notify/fanotify/fanotify_user.c |  16 +++-
 fs/notify/fdinfo.c                 |   3 +
 fs/quota/dquot.c                   |  13 ++-
 fs/udf/balloc.c                    |  29 ++++---
 fs/udf/dir.c                       |   2 +-
 fs/udf/directory.c                 |   9 ++-
 fs/udf/ialloc.c                    |   2 +-
 fs/udf/inode.c                     |  50 ++++++------
 fs/udf/misc.c                      |   8 +-
 fs/udf/namei.c                     |  13 +--
 fs/udf/partition.c                 |   6 +-
 fs/udf/super.c                     |  56 ++++++-------
 fs/udf/truncate.c                  |   2 +-
 fs/udf/udfdecl.h                   |  21 +++--
 fs/udf/unicode.c                   |   2 +-
 include/linux/audit.h              |  10 +++
 include/linux/fsnotify_backend.h   |   1 +
 include/uapi/linux/audit.h         |   1 +
 include/uapi/linux/fanotify.h      |   3 +
 include/uapi/linux/iso_fs.h        | 162 ++++++++++++++++++-------------------
 kernel/auditsc.c                   |   6 ++
 27 files changed, 366 insertions(+), 314 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
