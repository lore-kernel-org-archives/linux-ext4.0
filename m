From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Tue, 7 Jun 2011 17:56:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, lczerner@redhat.com,
	linux-kernel@vger.kernel.org, sandeen@redhat.com
To: amir73il@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab1FGP47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 11:56:59 -0400
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Amir,

thanks very much for the resend. I'll take a look at the whole patch
series, but first I want to bring up one important thing.

While this being a huge feature for ext4 (regardless on how
intrusive it is for the usual code paths) and while we already have
patches in the list with people interesting in looking into them, you
should clearly clarify what is the gain of it, what is the use case (and
I know you have one), and why it is better than other approaches. You
know, advertise it a bit in the marketing way :).

There is some confusion among developers on what actually are benefits
of ext4 snapshots in comparison to btrfs, or in comparison to the new
dm_multisnap code. I know that you have done quite a lot of testing to
assure that it does not actually change old ext4 behavior when snapshot
disabled, and that it works well when enabled, but have you done any
performance related benchmarks ? Do you have any expectations on how it
should behave in different work loads ?

It would be great to see and be able to confirm that ext4 snapshots are
really a win, not only on the feature side, but on the performance side
as well. I know that there are people out there still undecided or
having a strange feeling about your snapshot work. But who can blame
them, when we have not seen any hard data on this matter ?

So I, for myself, and I believe there are others, would like to see some
benchmark numbers and comparison (both, features and performance) with at
least new dm-multisnap code and probably btrfs and plain ext4 as well.

Thanks!
-Lukas


On Tue, 7 Jun 2011, amir73il@users.sourceforge.net wrote:

> Hi All,
> 
> I am resending the snapshots patch series as per Lukas's request.
> This time, the snapshot*.c files have not been omitted, as in
> the previous posting.
> 
> The series is still based on ext4 dev branch sometime in the preparation
> for 3.0 merge window. It was not yet rebased on 3.0-rc1, so punch holes
> changes have not been addressed yet.
> 
> As always, I advocate online review of the patches at:
> https://github.com/amir73il/ext4-snapshots/commits/for-ext4-v1
> but if you insist on doing it the old way, I won't complain.
> 
> Thanks,
> Amir.
> 
> [PATCH v1 01/36] ext4: EXT4 snapshots (Experimental)
> [PATCH v1 02/36] ext4: snapshot debugging support
> [PATCH v1 03/36] ext4: snapshot hooks - inside JBD hooks
> [PATCH v1 04/36] ext4: snapshot hooks - block bitmap access
> [PATCH v1 05/36] ext4: snapshot hooks - delete blocks
> [PATCH v1 06/36] ext4: snapshot hooks - move data blocks
> [PATCH v1 07/36] ext4: snapshot hooks - direct I/O
> [PATCH v1 08/36] ext4: snapshot hooks - move extent file data blocks
> [PATCH v1 09/36] ext4: snapshot file
> [PATCH v1 10/36] ext4: snapshot file - read through to block device
> [PATCH v1 11/36] ext4: snapshot file - permissions
> [PATCH v1 12/36] ext4: snapshot file - store on disk
> [PATCH v1 13/36] ext4: snapshot file - increase maximum file size limit to 16TB
> [PATCH v1 14/36] ext4: snapshot block operations
> [PATCH v1 15/36] ext4: snapshot block operation - copy blocks to snapshot
> [PATCH v1 16/36] ext4: snapshot block operation - move blocks to snapshot
> [PATCH v1 17/36] ext4: snapshot block operation - copy block bitmap to snapshot
> [PATCH v1 18/36] ext4: snapshot control
> [PATCH v1 19/36] ext4: snapshot control - init new snapshot
> [PATCH v1 20/36] ext4: snapshot control - fix new snapshot
> [PATCH v1 21/36] ext4: snapshot control - reserve disk space for snapshot
> [PATCH v1 22/36] ext4: snapshot journaled - increase transaction credits
> [PATCH v1 23/36] ext4: snapshot journaled - implement journal_release_buffer()
> [PATCH v1 24/36] ext4: snapshot journaled - bypass to save credits
> [PATCH v1 25/36] ext4: snapshot journaled - cache last COW tid in journal_head
> [PATCH v1 26/36] ext4: snapshot journaled - trace COW/buffer credits
> [PATCH v1 27/36] ext4: snapshot list support
> [PATCH v1 28/36] ext4: snapshot list - read through to previous snapshot
> [PATCH v1 29/36] ext4: snapshot race conditions - concurrent COW bitmap operations
> [PATCH v1 30/36] ext4: snapshot race conditions - concurrent COW operations
> [PATCH v1 31/36] ext4: snapshot race conditions - tracked reads
> [PATCH v1 32/36] ext4: snapshot exclude - the exclude bitmap
> [PATCH v1 33/36] ext4: snapshot cleanup
> [PATCH v1 34/36] ext4: snapshot cleanup - shrink deleted snapshots
> [PATCH v1 35/36] ext4: snapshot cleanup - merge shrunk snapshots
> [PATCH v1 36/36] ext4: snapshot rocompat - enable rw mount
> 
>  fs/ext4/Kconfig           |   11 +
>  fs/ext4/Makefile          |    3 +
>  fs/ext4/balloc.c          |  132 +++
>  fs/ext4/ext4.h            |  188 ++++-
>  fs/ext4/ext4_jbd2.c       |  162 ++++-
>  fs/ext4/ext4_jbd2.h       |  266 ++++++-
>  fs/ext4/extents.c         |  157 ++++-
>  fs/ext4/file.c            |   11 +-
>  fs/ext4/ialloc.c          |   19 +-
>  fs/ext4/inode.c           |  668 +++++++++++++--
>  fs/ext4/ioctl.c           |  120 +++
>  fs/ext4/mballoc.c         |  161 ++++-
>  fs/ext4/move_extent.c     |    3 +-
>  fs/ext4/namei.c           |    9 +
>  fs/ext4/resize.c          |   19 +-
>  fs/ext4/snapshot.c        | 1000 ++++++++++++++++++++++
>  fs/ext4/snapshot.h        |  690 ++++++++++++++++
>  fs/ext4/snapshot_buffer.c |  393 +++++++++
>  fs/ext4/snapshot_ctl.c    | 2002 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/snapshot_debug.c  |  107 +++
>  fs/ext4/snapshot_debug.h  |  105 +++
>  fs/ext4/snapshot_inode.c  |  960 ++++++++++++++++++++++
>  fs/ext4/super.c           |  157 ++++-
>  fs/ext4/xattr.c           |    4 +-
>  24 files changed, 7182 insertions(+), 165 deletions(-)
> 
> 

-- 
