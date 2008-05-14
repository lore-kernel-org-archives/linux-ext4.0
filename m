From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Updated ext4 patchset
Date: Wed, 14 May 2008 15:39:39 -0400
Message-ID: <E1JwMp9-0002pJ-9b@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51906 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942AbYENTjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2008 15:39:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


There's a new ext4 patchset available, here:

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.26-rc2-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.26-rc2-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-rc2-ext4-1

The bug fixes patches marked as with an "+" below probably be pushed to
Linus fairly shortly.


The double "There are a few cases direct IO could race with kjournal
flushing" that are credited to me are from two patches,
jbd-dio-kjournal-race-EIO.patch, and jbd2-dio-kjournal-race-EIO.patch,
where I didn't notice the patches weren't correctly formatted until
after I had cut the patch series.

Unfortunately I missed this until after I made the patch series, but
I'll fix it before those patches are pushed to Linus --- or better yet,
if someone else wants to fix it, and be careful to make sure new patches
added to the patch queue are correctly formatted, even better.  :-)

There was similar problem with Julia Lawall's patch which was missing a
one-line description that has already been fixed in the patch queue.


Just as a reminder, the correct format is a single one-line description
(under 70 characters long, please) followed by a blank line, followed by
a "From: John. Q. Author <author@of.the.patch.com>", followed by another
blank line, followed by the patch description.  (For the patch
description, please check out other git commits to get an idea of the
appropriate writing style and detail that is needed.)

Also, note that Andrew gets cranky when we push fs/jbd or fs/ext3
patches through the ext4 tree.  So we really should get that into
Andrew's -mm tree, and then dropped from ours.

Finally, while I'm carping about consistency and style of the git
headers, how about using all lower case for "ext4" or "jbd2", followed
by a colon, followed by a single space, hmm?  It's a minor point, but it
looks nicer in gitk if they are all consistent, instead of some patches
using "jbd2: ", some with "Jbd2: ", and some with "JBD2:  ".

Thanks,

					- Ted

Stable series:

Alexey Dobriyan (1):
      ext4: switch to seq_files

Aneesh Kumar K.V (2):
    + ext4: Retry block allocation if new blocks are allocated from system zone.
      ext4: start seraching for the right extent from the goal group.

Jan Kara (4):
    + ext4: correct mount option parsing to detect when quota options can be changed
    + ext4: Fix mount messages when quota disabled
    + ext4: fix synchronization of quota files in journal=data mode
    + ext4: fix typos in messages and comments (journalled -> journaled)

Julia Lawall (1):
      if (...) BUG(); should be replaced with BUG_ON(...) when the test has no

Mingming Cao (1):
    + JBD2: update transaction t_state to T_COMMIT fix

Theodore Ts'o (1):
      jbd2: Add commit time into the commit block

Valerie Clement (1):
    + ext4: mballoc fix mb_normalize_request algorithm for 1KB block size filesystems


Development patches:

Akira Fujita (7):
      ext4: online defrag-- Exchange the blocks between two inodes
      ext4: online defrag-- Read and write file data with memory page
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag-- Main function of defrag and ioctl implementation
      ext4: online defrag-- Defragmentation for the relevant files (-r mode)
      ext4: online defrag-- Check the free space fragmentation (-f mode)
      ext4: online defrag-- Move victim files for the target file (-f mode)

Alex Tomas (2):
      vfs: add basic delayed allocation support
      ext4: Add basic delayed allocation support

Aneesh Kumar K.V (3):
      ext4:  Update i_diskzie during writepage for delayed allocation.
      ext4: Enable delalloc and mballoc by default.
      ext4: Show delalloc options

Eric Sandeen (3):
      vfs: vfs-level fiemap interface
      ext4: reinstate ext4_ext_walk_space()
      ext4: fiemap implementation

Jan Kara (1):
      Ext4: Inverse locking order of page_lock and transaction start.

Jose R. Santos (1):
      ext4: New inode allocation for FLEX_BG meta-data groups.

Mingming Cao (5):
      ext4: fix  delalloc write_begin failure case
      ext4: Handling preallocated blocks in delayed allocation
      jbd: blocks reservation fix for large block support
      jbd2: blocks reservation fix for large block support
      Ext4:  inverse locking ordering of page_lock and transaction start in delalloc

Theodore Ts'o (2):
      There are a few cases direct IO could race with kjournal flushing
      There are a few cases direct IO could race with kjournal flushing

Valerie Clement (1):
      ext4: Fix filesystem corruption on FS mounted with delalloc

\"Aneesh Kumar K.V\ (1):
      ext4: Use page_mkwrite vma_operations to get mmap write notification.

