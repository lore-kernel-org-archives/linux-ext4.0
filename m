From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 Secure Delete 0/7 v4] Ext4 secure delete
Date: Fri,  7 Oct 2011 00:10:58 -0700
Message-ID: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40723 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758772Ab1JGHHM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Oct 2011 03:07:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Sorry for the delay in getting this next version out.
I had some tasks to take care of, and now I'm picking up my
secure delete work again. I'm still not quite done yet,
but a lot has changed and I wanted to update people so that
we have an idea of where its going.  Currently the patch
deals with data blocks, meta blocks, directory entries,
journal blocks, and also provides an option for secure
deleting with random data instead of just zeros.
I'm also planning on adding some more patches to
deal with inodes and also a mount option that turns
on secure delete by default.  Im still not quite done
debugging, but Im just sending it out early to get
some more eyes on it. Feed back appreciated!  :)

v3->v4
Added a new file attribute flag EXT4_SECRM_RANDOM_FL
This flag causes the secure delete operations to over write
blocks with random data instead of zeros.

New function ext4_secure_delete_lblks added to walk
data blocks and secure delete them before any blocks
are removed.

Meta blocks are secure deleted before they are
released

New function added to identify holes in ind files.
Used by ext4_secure_delete_lblks to skip over holes
during secure delete.

Added another list in the journal structure to track
journal blocks so that they can be secure deleted later.

Added new ext4_secure_delete_jblks that secure deletes
journal blocks that were used to journal the specified
logical blocks

Allison Henderson (7):
  ext4: Secure Delete: Add new EXT4_SECRM_RANDOM_FL flag
  ext4: Secure Delete: Add ext4_ind_hole_lookup function
  ext4: Secure Delete: Add secure delete functions
  ext4: Secure Delete: Secure delete file data
  ext4: Secure Delete: Secure delete directory entry
  ext4: Secure Delete: Secure delete meta data blocks
  ext4/jbd2: Secure Delete: Secure delete journal blocks

 fs/ext4/ext4.h         |   28 +++-
 fs/ext4/ext4_extents.h |    2 +
 fs/ext4/extents.c      |   21 +++-
 fs/ext4/indirect.c     |    2 +-
 fs/ext4/inode.c        |  391 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/mballoc.c      |    8 +
 fs/ext4/namei.c        |   64 +++++++-
 fs/jbd2/commit.c       |    6 +
 fs/jbd2/journal.c      |  112 ++++++++++++++
 include/linux/jbd2.h   |   21 +++
 10 files changed, 642 insertions(+), 13 deletions(-)

