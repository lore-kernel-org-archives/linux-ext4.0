From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update
Date: Wed, 18 Jul 2007 09:42:47 -0400
Message-ID: <E1IB9nj-000777-Fi@candygram.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:32991 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbXGRNmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jul 2007 09:42:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

It contains the following feature enhancements, including support for
the new fallocate() system call.  These have been in -mm for a while,
consensus reached for the fallocate() interface between other filesystem
and architecture maintainers.  Patches to wire up the other arches and
XFS should be showing up shortly after this gets merged into mainline.

Regards,

							- Ted

Alex Tomas (1):
      ext4: Make extents code sanely handle on-disk corruption

Amit Arora (4):
      sys_fallocate() implementation on i386, x86_64 and powerpc
      fallocate support in ext4
      write support for preallocated blocks
      Change on-disk format to support 2^15 uninitialized extents

Andreas Dilger (1):
      ext4: Remove 65000 subdirectory limit

Dave Hansen (1):
      ext4: remove extra IS_RDONLY() check

Dmitry Monakhov (2):
      Fix compilation with EXT_DEBUG, also fix leXX_to_cpu conversions.
      ext4: extent macros cleanup

Eric Sandeen (1):
      Use zero_user_page() in ext4 where possible

Jan Kara (1):
      ext4: copy i_flags to inode flags on write

Jose R. Santos (3):
      ext4: Set the journal JBD2_FEATURE_INCOMPAT_64BIT on large devices
      jbd2: Fix CONFIG_JBD_DEBUG ifdef to be CONFIG_JBD2_DEBUG
      jbd2: Move jbd2-debug file to debugfs

Kalpak Shah (2):
      ext4: Add nanosecond timestamps
      ext4: Expand extra_inodes space per the s_{want,min}_extra_isize fields

Mingming Cao (1):
      ext4: Enable extents by default

Vignesh Babu (1):
      ext4: Use is_power_of_2()

 arch/i386/kernel/syscall_table.S |    1 
 arch/powerpc/kernel/sys_ppc32.c  |    7 
 arch/x86_64/ia32/ia32entry.S     |    1 
 arch/x86_64/ia32/sys_ia32.c      |    8 
 fs/Kconfig                       |   10 
 fs/ext4/balloc.c                 |    4 
 fs/ext4/extents.c                |  706 ++++++++++++++++++++++++++++++---------
 fs/ext4/file.c                   |    1 
 fs/ext4/ialloc.c                 |    8 
 fs/ext4/inode.c                  |  118 +++++-
 fs/ext4/ioctl.c                  |    9 
 fs/ext4/namei.c                  |   76 ++--
 fs/ext4/super.c                  |   50 ++
 fs/ext4/xattr.c                  |  276 ++++++++++++++-
 fs/ext4/xattr.h                  |   17 
 fs/jbd2/journal.c                |   81 +---
 fs/jbd2/recovery.c               |    2 
 fs/open.c                        |   59 +++
 include/asm-i386/unistd.h        |    3 
 include/asm-powerpc/systbl.h     |    1 
 include/asm-powerpc/unistd.h     |    3 
 include/asm-x86_64/unistd.h      |    2 
 include/linux/ext4_fs.h          |  104 +++++
 include/linux/ext4_fs_extents.h  |   49 ++
 include/linux/ext4_fs_i.h        |    5 
 include/linux/ext4_fs_sb.h       |    3 
 include/linux/falloc.h           |    6 
 include/linux/fs.h               |    2 
 include/linux/jbd2.h             |    6 
 include/linux/syscalls.h         |    1 
 30 files changed, 1344 insertions(+), 275 deletions(-)
