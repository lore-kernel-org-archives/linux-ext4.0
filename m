From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [BUG] e2fsprogs: e2fsck -b outputs checksum warnings
Date: Tue, 31 Jan 2012 15:56:57 -0500
Message-ID: <20120131205657.GC25951@thunk.org>
References: <4E6726E4.8070203@rs.jp.nec.com>
 <4F28527D.9030405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58653 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab2AaU5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jan 2012 15:57:01 -0500
Content-Disposition: inline
In-Reply-To: <4F28527D.9030405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 31, 2012 at 02:43:41PM -0600, Eric Sandeen wrote:
>         /*
>          * If recovery is from backup superblock, Clear _UNININT flags &
>          * reset bg_itable_unused to zero
>          */
> 
> This makes the group look like it is initialized and that all inodes
> are used.
> 
> Can someone remind me why we want to do this?

It's because the kernel don't update the backup block group
descriptors.  So there may very well be bitmaps that have since been
initialized and in use, and there may very well be inodes that have
been allocated that are not represented by the value of
bg_itable_unused in the backup bg descriptors.  And the inode iterator
functions will simply skip inodes that are marked as not in use;
indeed, that's one of the ways we speed up fsck times; by skipping
portions of the inode table that are not in use.  The problem is that
if the primary superblock and block group descriptors are corrupt, we
don't know which portions of the inode table are in use and which are
not.

This is also why the lazy itable init code is so important; if we're
going to skip zero'ing the inode table, then until the inode table
gets initialized, we are at risk of finding old inodes from previous
file systems that had been on the storage device in the case where we
are using backup bg descriptors and/or the checksums are incorrect.
This doesn't happen that often, but it's still important that the
inode table get appropriately initialized, which is why it may be ok
for a distro installer to disable the lazy itable init to speed up the
install process, but you still want to let the lazy itable process
finish up as soon as possible.

> > One or more block group descriptor checksums are invalid.  Fix<y>? yes
> > 
> > Group descriptor 0 checksum is invalid.  FIXED.
> > Group descriptor 1 checksum is invalid.  FIXED.
> > Group descriptor 2 checksum is invalid.  FIXED.
> > Group descriptor 3 checksum is invalid.  FIXED.

This is certainly scary, though.  In the case where we do need to use
the backup block group descriptors, it would be better to reset the
checksum to the correct value so we don't get all of this extra
output, which isn't useful to the user and is just going to alarm them
unnecessarily.

						- Ted
