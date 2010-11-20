From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 2.6.37-rc3
Date: Fri, 19 Nov 2010 22:34:57 -0500
Message-ID: <E1PJeE5-0000CB-Vs@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Mustly bug fixes, but also we undo a change we made to the core VFS
during -rc1 to keep things simpler.  (Basically, we vector the FITRIM
ioctl through ioctl interface instead of through a new super_operations
vector.)

                                        - Ted

Dan Carpenter (1):
      ext4: missing unlock in ext4_clear_request_list()

Darrick J. Wong (1):
      ext4: ext4_fill_super shouldn't return 0 on corruption

Lukas Czerner (2):
      fs: Do not dispatch FITRIM through separate super_operation
      ext4: Add EXT4_IOC_TRIM ioctl to handle batched discard

Markus Trippelsdorf (1):
      ext4: fix setting random pages PageUptodate

yangsheng (1):
      jbd2: fix /proc/fs/jbd2/<dev> when using an external journal

 fs/ext4/ioctl.c    |   24 ++++++++++++++++++++++++
 fs/ext4/page-io.c  |    4 ++--
 fs/ext4/super.c    |    9 +++------
 fs/ioctl.c         |   39 ---------------------------------------
 fs/jbd2/journal.c  |   16 ++++++++--------
 include/linux/fs.h |    1 -
 6 files changed, 37 insertions(+), 56 deletions(-)
