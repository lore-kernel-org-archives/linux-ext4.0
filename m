From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Tue, 21 Jun 2011 09:45:57 -0600
Message-ID: <0A68B7C0-C7DD-456C-BC52-A169C5521933@dilger.ca>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net> <BANLkTimC9N6nLYg2+FqjVv_J4RGy1t8nZA@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:56415 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1FUPpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 11:45:40 -0400
In-Reply-To: <BANLkTimC9N6nLYg2+FqjVv_J4RGy1t8nZA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-21, at 5:06 AM, "Amir G." <amir73il@users.sourceforge.net> wrote:
> On Tue, Jun 7, 2011 at 6:07 PM,  <amir73il@users.sourceforge.net> wrote:
>> 
>> I am resending the snapshots patch series as per Lukas's request.
>> This time, the snapshot*.c files have not been omitted, as in
>> the previous posting.
>> 
>> The series is still based on ext4 dev branch sometime in the preparation
>> for 3.0 merge window. It was not yet rebased on 3.0-rc1, so punch holes
>> changes have not been addressed yet.
>> 
>> As always, I advocate online review of the patches at:
>> https://github.com/amir73il/ext4-snapshots/commits/for-ext4-v1
>> but if you insist on doing it the old way, I won't complain.
>> 
>> 
> 
> To answer your question about possible diet to snapshot patches,
> following are some diffstat on groups of patches (by functionality).
> The diffsstat includes only ext4 core file (excluding new snapshot* files).
> 
> As you can see, removing the shrink/merge functionality for multiple
> snapshots, will remove the need for exclude bitmap and reduce the changes
> to core files by ~300 insertions.
> 
> There is some advantage of not having to add the exclude bitmap to existing
> fs, but I think the win is not so big, assuming that we will want to have the
> shrink/merge functionality eventually.

Wouldn't that also mean if shrink/merge are added later it needs another feature flag and added complexity due to another row in the feature test matrix?


> 
>> [PATCH v1 01/36] ext4: EXT4 snapshots (Experimental)
>> [PATCH v1 02/36] ext4: snapshot debugging support
> 
> Generic stuff.
> 
> 15 files changed, 122 insertions(+), 1 deletions(-)
> 
>> [PATCH v1 03/36] ext4: snapshot hooks - inside JBD hooks
>> [PATCH v1 04/36] ext4: snapshot hooks - block bitmap access
>> [PATCH v1 05/36] ext4: snapshot hooks - delete blocks
>> [PATCH v1 06/36] ext4: snapshot hooks - move data blocks
>> [PATCH v1 07/36] ext4: snapshot hooks - direct I/O
>> [PATCH v1 08/36] ext4: snapshot hooks - move extent file data blocks
> 
> Most of the code in this group handles MOW.
> 
> 7 files changed, 550 insertions(+), 68 deletions(-)
> 
>> [PATCH v1 09/36] ext4: snapshot file
>> [PATCH v1 10/36] ext4: snapshot file - read through to block device
>> [PATCH v1 11/36] ext4: snapshot file - permissions
>> [PATCH v1 12/36] ext4: snapshot file - store on disk
>> [PATCH v1 13/36] ext4: snapshot file - increase maximum file size limit to 16TB
> 
> Implementation of special snapshot file.
> 
> 7 files changed, 220 insertions(+), 14 deletions(-)
> 
>> [PATCH v1 14/36] ext4: snapshot block operations
>> [PATCH v1 15/36] ext4: snapshot block operation - copy blocks to snapshot
>> [PATCH v1 16/36] ext4: snapshot block operation - move blocks to snapshot
>> [PATCH v1 17/36] ext4: snapshot block operation - copy block bitmap to snapshot
> 
> Copy/move to snapshot file operations.
> 
> 5 files changed, 126 insertions(+), 24 deletions(-)
> 
>> [PATCH v1 18/36] ext4: snapshot control
>> [PATCH v1 19/36] ext4: snapshot control - init new snapshot
>> [PATCH v1 20/36] ext4: snapshot control - fix new snapshot
>> [PATCH v1 21/36] ext4: snapshot control - reserve disk space for snapshot
> 
> Mostly new code in ioctl.c.
> 
> 6 files changed, 171 insertions(+), 3 deletions(-)
> 
>> [PATCH v1 22/36] ext4: snapshot journaled - increase transaction credits
>> [PATCH v1 23/36] ext4: snapshot journaled - implement journal_release_buffer()
>> [PATCH v1 24/36] ext4: snapshot journaled - bypass to save credits
>> [PATCH v1 25/36] ext4: snapshot journaled - cache last COW tid in journal_head
> 
> Helper functions to handle extra COW credits.
> 
> 7 files changed, 284 insertions(+), 31 deletions(-)
> 
>> [PATCH v1 26/36] ext4: snapshot journaled - trace COW/buffer credits
> 
> Trace/debug for extra COW credits.
> 
> 3 files changed, 108 insertions(+), 0 deletions(-)
> 
>> [PATCH v1 27/36] ext4: snapshot list support
>> [PATCH v1 28/36] ext4: snapshot list - read through to previous snapshot
> 
> Not much to gain from dropping snapshot list support...
> 
> 2 files changed, 2 insertions(+), 0 deletions(-)
> 
>> [PATCH v1 29/36] ext4: snapshot race conditions - concurrent COW bitmap operations
>> [PATCH v1 30/36] ext4: snapshot race conditions - concurrent COW operations
>> [PATCH v1 31/36] ext4: snapshot race conditions - tracked reads
> 
> We must handle race conditions.
> 
> 2 files changed, 32 insertions(+), 0 deletions(-)
> 
>> [PATCH v1 32/36] ext4: snapshot exclude - the exclude bitmap
> 
> We do not need the exclude bitmap if we do not shrink/merge snapshots.
> 
> 5 files changed, 226 insertions(+), 3 deletions(-)
> 
>> [PATCH v1 33/36] ext4: snapshot cleanup
>> [PATCH v1 34/36] ext4: snapshot cleanup - shrink deleted snapshots
>> [PATCH v1 35/36] ext4: snapshot cleanup - merge shrunk snapshots
> 
> We could support multiple snapshots without shrinking/merging deleted snapshot,
> but that means that only disk space of oldest snapshot is reclaimed on delete.
> 
> 2 files changed, 74 insertions(+), 22 deletions(-)
> 
>> [PATCH v1 36/36] ext4: snapshot rocompat - enable rw mount
>> 
>>  fs/ext4/Kconfig           |   11 +
>>  fs/ext4/Makefile          |    3 +
>>  fs/ext4/balloc.c          |  132 +++
>>  fs/ext4/ext4.h            |  188 ++++-
>>  fs/ext4/ext4_jbd2.c       |  162 ++++-
>>  fs/ext4/ext4_jbd2.h       |  266 ++++++-
>>  fs/ext4/extents.c         |  157 ++++-
>>  fs/ext4/file.c            |   11 +-
>>  fs/ext4/ialloc.c          |   19 +-
>>  fs/ext4/inode.c           |  668 +++++++++++++--
>>  fs/ext4/ioctl.c           |  120 +++
>>  fs/ext4/mballoc.c         |  161 ++++-
>>  fs/ext4/move_extent.c     |    3 +-
>>  fs/ext4/namei.c           |    9 +
>>  fs/ext4/resize.c          |   19 +-
>>  fs/ext4/snapshot.c        | 1000 ++++++++++++++++++++++
>>  fs/ext4/snapshot.h        |  690 ++++++++++++++++
>>  fs/ext4/snapshot_buffer.c |  393 +++++++++
>>  fs/ext4/snapshot_ctl.c    | 2002 +++++++++++++++++++++++++++++++++++++++++++++
>>  fs/ext4/snapshot_debug.c  |  107 +++
>>  fs/ext4/snapshot_debug.h  |  105 +++
>>  fs/ext4/snapshot_inode.c  |  960 ++++++++++++++++++++++
>>  fs/ext4/super.c           |  157 ++++-
>>  fs/ext4/xattr.c           |    4 +-
>>  24 files changed, 7182 insertions(+), 165 deletions(-)
>> 
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
