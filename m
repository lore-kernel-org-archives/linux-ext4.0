From: amir73il@users.sourceforge.net
Subject: [PATCH v1 00/30] Ext4 snapshots
Date: Tue,  7 Jun 2011 18:07:27 +0300
Message-ID: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab1FGPIa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:08:30 -0400
Received: by wya21 with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:08:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I am resending the snapshots patch series as per Lukas's request.
This time, the snapshot*.c files have not been omitted, as in
the previous posting.

The series is still based on ext4 dev branch sometime in the preparation
for 3.0 merge window. It was not yet rebased on 3.0-rc1, so punch holes
changes have not been addressed yet.

As always, I advocate online review of the patches at:
https://github.com/amir73il/ext4-snapshots/commits/for-ext4-v1
but if you insist on doing it the old way, I won't complain.

Thanks,
Amir.

[PATCH v1 01/36] ext4: EXT4 snapshots (Experimental)
[PATCH v1 02/36] ext4: snapshot debugging support
[PATCH v1 03/36] ext4: snapshot hooks - inside JBD hooks
[PATCH v1 04/36] ext4: snapshot hooks - block bitmap access
[PATCH v1 05/36] ext4: snapshot hooks - delete blocks
[PATCH v1 06/36] ext4: snapshot hooks - move data blocks
[PATCH v1 07/36] ext4: snapshot hooks - direct I/O
[PATCH v1 08/36] ext4: snapshot hooks - move extent file data blocks
[PATCH v1 09/36] ext4: snapshot file
[PATCH v1 10/36] ext4: snapshot file - read through to block device
[PATCH v1 11/36] ext4: snapshot file - permissions
[PATCH v1 12/36] ext4: snapshot file - store on disk
[PATCH v1 13/36] ext4: snapshot file - increase maximum file size limit to 16TB
[PATCH v1 14/36] ext4: snapshot block operations
[PATCH v1 15/36] ext4: snapshot block operation - copy blocks to snapshot
[PATCH v1 16/36] ext4: snapshot block operation - move blocks to snapshot
[PATCH v1 17/36] ext4: snapshot block operation - copy block bitmap to snapshot
[PATCH v1 18/36] ext4: snapshot control
[PATCH v1 19/36] ext4: snapshot control - init new snapshot
[PATCH v1 20/36] ext4: snapshot control - fix new snapshot
[PATCH v1 21/36] ext4: snapshot control - reserve disk space for snapshot
[PATCH v1 22/36] ext4: snapshot journaled - increase transaction credits
[PATCH v1 23/36] ext4: snapshot journaled - implement journal_release_buffer()
[PATCH v1 24/36] ext4: snapshot journaled - bypass to save credits
[PATCH v1 25/36] ext4: snapshot journaled - cache last COW tid in journal_head
[PATCH v1 26/36] ext4: snapshot journaled - trace COW/buffer credits
[PATCH v1 27/36] ext4: snapshot list support
[PATCH v1 28/36] ext4: snapshot list - read through to previous snapshot
[PATCH v1 29/36] ext4: snapshot race conditions - concurrent COW bitmap operations
[PATCH v1 30/36] ext4: snapshot race conditions - concurrent COW operations
[PATCH v1 31/36] ext4: snapshot race conditions - tracked reads
[PATCH v1 32/36] ext4: snapshot exclude - the exclude bitmap
[PATCH v1 33/36] ext4: snapshot cleanup
[PATCH v1 34/36] ext4: snapshot cleanup - shrink deleted snapshots
[PATCH v1 35/36] ext4: snapshot cleanup - merge shrunk snapshots
[PATCH v1 36/36] ext4: snapshot rocompat - enable rw mount

 fs/ext4/Kconfig           |   11 +
 fs/ext4/Makefile          |    3 +
 fs/ext4/balloc.c          |  132 +++
 fs/ext4/ext4.h            |  188 ++++-
 fs/ext4/ext4_jbd2.c       |  162 ++++-
 fs/ext4/ext4_jbd2.h       |  266 ++++++-
 fs/ext4/extents.c         |  157 ++++-
 fs/ext4/file.c            |   11 +-
 fs/ext4/ialloc.c          |   19 +-
 fs/ext4/inode.c           |  668 +++++++++++++--
 fs/ext4/ioctl.c           |  120 +++
 fs/ext4/mballoc.c         |  161 ++++-
 fs/ext4/move_extent.c     |    3 +-
 fs/ext4/namei.c           |    9 +
 fs/ext4/resize.c          |   19 +-
 fs/ext4/snapshot.c        | 1000 ++++++++++++++++++++++
 fs/ext4/snapshot.h        |  690 ++++++++++++++++
 fs/ext4/snapshot_buffer.c |  393 +++++++++
 fs/ext4/snapshot_ctl.c    | 2002 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot_debug.c  |  107 +++
 fs/ext4/snapshot_debug.h  |  105 +++
 fs/ext4/snapshot_inode.c  |  960 ++++++++++++++++++++++
 fs/ext4/super.c           |  157 ++++-
 fs/ext4/xattr.c           |    4 +-
 24 files changed, 7182 insertions(+), 165 deletions(-)

