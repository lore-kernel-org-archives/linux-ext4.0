From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH V7 00/12] Add new online resize (Ted's modified version)
Date: Wed,  4 Jan 2012 00:07:22 -0500
Message-ID: <1325653654-10478-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50271 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab2ADFHf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 00:07:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a revised set of the on-line resizing patches after my
cleanups.  I've folded some patches together, as well as collapsed a few
functions to make the code easier to understatnd/maintain.

I've also fixed up the English in a few places in the commit
descriptions and in the comments, as well as made some style fix ups.

Finally, I've added some error checking to make sure the on-line
resizing code doesn't try to resize file systems that it can't handle
(most notably, meta_bg file systems).  We do need to add meta_bg support
into the on-line resize, but this patch series has enough benefits that
we should get this merged first, and then we can add the meta_bg support
later.

Yongqiang Yang (12):
  ext4: add a function which extends a group without checking
    parameters
  ext4: add a function which adds a new group descriptors to a fs
  ext4: add a structure which will be used by 64bit-resize interface
  ext4: add a function which sets up group blocks of a flex bg
  ext4: add a function which sets up a block group descriptors of a
    flex bg
  ext4: add a function which updates the super block during online
    resizing
  ext4: pass verify_reserved_gdb() the number of group decriptors
  ext4: add a new function which allocates bitmaps and inode tables
  ext4: add a new function which adds a flex group to a fs
  ext4: add new online resize interface
  ext4: let ext4_group_extend() use common code
  ext4: let ext4_group_add() use common code

 Documentation/filesystems/ext4.txt |    7 +
 fs/ext4/ext4.h                     |   10 +
 fs/ext4/ioctl.c                    |   58 ++
 fs/ext4/resize.c                   | 1175 +++++++++++++++++++++++++++---------
 4 files changed, 961 insertions(+), 289 deletions(-)

-- 
1.7.8.11.gefc1f.dirty

