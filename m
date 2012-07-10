From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv5 0/4] ext4: stop using write_supers and s_dirt
Date: Tue, 10 Jul 2012 15:17:49 +0300
Message-ID: <1341922673-14147-1-git-send-email-dedekind1@gmail.com>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch-set makes ext4 file-system stop using the VFS '->write_supers()'
call-back and the '->s_dirt' superblock field because I plan to remove them
once all users are gone.

Most of the ext4 changes were done or suggested by Jan Kara (thanks!). This
patch does not do anything complex - we basically notice that ext4 does not
really needed the 'write_super()' functionality and we can remove it. We
mark the superblock buffer as dirty directly, rather than postponing this till
the next 'sync_supers()' kernel thread wake-up.

However, this means that we'll end up with calculating the checksum more often,
see patch 3 for more information.

I've also dropped the fifth patch which removes the 'now' argument from
'__ext4_handle_dirty_super()' - simply because I do not understand why we
should prefer marking the buffer as dirty directly instead of calling
'ext4_commit_super()': the speed difference must be neglectable and
'ext4_commit_super()' performs some error checking. I can submit this patch
later - just need some more explanation from Jan.

Tested with xfstests (both journalled and non-journalled ext4 modes).

Reminder:

The goal is to get rid of the 'sync_supers()' kernel thread. This kernel thread
wakes up every 5 seconds (by default) and calls '->write_super()' for all
mounted file-systems. And the bad thing is that this is done even if all the
superblocks are clean. Moreover, many file-systems do not even need this end
they do not register the '->write_super()' method at all (e.g., btrfs).

So 'sync_supers()' most often just generates useless wake-ups and wastes power.
I am trying to make all file-systems independent of '->write_super()' and plan
to remove 'sync_supers()' and '->write_super()' completely once there are no
more users.

======
Overall status:

1.  ext4: patches submitted,
    https://lkml.org/lkml/2012/7/3/210
2.  exofs: patch submitted,
    https://lkml.org/lkml/2012/6/4/211
3.  sysv: patches submitted,
    http://lkml.org/lkml/2012/7/3/250
4.  udf: patch submitted, sits in Jan Kara's tree:
    https://lkml.org/lkml/2012/6/4/233
    git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs for_testing
5.  affs: patches submitted, sit in Al Viro's tree:
    https://lkml.org/lkml/2012/6/6/400
    git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs for-next
6.  hfs: patches submitted, sit Andrew Morton's tree
    http://lkml.org/lkml/2012/6/12/82
7.  hfsplus: patches submitted, sit in Andrew Morton's tree:
    https://lkml.org/lkml/2012/6/13/195
8.  ext2:     done, see commit f72cf5e223a28d3b3ea7dc9e40464fd534e359e8
9.  vfat:     done, see commit 78491189ddb6d84d4a4abae992ed891a236d0263
10. jffs2:    done, see commit 208b14e507c00ff7f108e1a388dd3d8cc805a443
11. reiserfs: done, see commit 033369d1af1264abc23bea2e174aa47cdd212f6f

TODO: ufs
======

 fs/ext4/ext4.h      |   10 +---------
 fs/ext4/ext4_jbd2.c |    2 +-
 fs/ext4/file.c      |   14 +++++++++++++-
 fs/ext4/ialloc.c    |    2 --
 fs/ext4/mballoc.c   |    2 --
 fs/ext4/super.c     |   15 ++-------------
 6 files changed, 17 insertions(+), 28 deletions(-)

Thanks,
Artem.
