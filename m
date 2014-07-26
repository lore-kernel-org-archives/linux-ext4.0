From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Sat, 26 Jul 2014 08:45:57 -0400
Message-ID: <20140726124557.GB6725@thunk.org>
References: <53CBA75B.2030102@fnarfbargle.com>
 <53CC66DA.2080804@fnarfbargle.com>
 <20140725081312.GO6397@azat>
 <53D24307.6050903@fnarfbargle.com>
 <20140725140715.GR1865@thunk.org>
 <53D320F6.40809@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57985 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaGZMqB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 08:46:01 -0400
Content-Disposition: inline
In-Reply-To: <53D320F6.40809@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, it looks like the e2fsprogs patch got you through the first
hurdle, but the failure is something that made no sense at first:

> [489412.650430] EXT4-fs (md0): resizing filesystem from 5804916736 to
> 5860149888 blocks
> [489412.700282] EXT4-fs warning (device md0): verify_reserved_gdb:713:
> reserved GDT 2769 missing grp 177147 (5804755665)

The code path which emitted the above warning something that should
ever be entered for file systems greater than 16TB.  But then I took a
look at the first message that you sent on this thread, and I think
see what's going wrong.  From your dumpe2fs -h output:

Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink
extra_isize
Block count:              5804916736
Reserved GDT blocks:      585

If the block count is greater than 2**32 (4294967296), resize_inode
must not be set, and reserved GDT blocks should be zero.  So this is
definitely not right.

I'm going to guess that this file system was originally a smaller size
(and probably smaller than 16T), and then was resized to 22TB,
probably using an earlier version of the kernel and/or e2fsprogs.  Is
my guess correct?  If so, do you remember the history of what size the
file system was, and in what steps it was resized, and what version of
the e2fsprogs and the kernel that was used at each stage, starting
from the original mke2fs and each successive resize?

I'm guessing what happened is that an earlier version of the kernel or
the e2fsprogs left the file system in an unexpected state.  It's
apparently one that e2fsck didn't complain about, but it definitely
wasn't normal.

In any case, the way I would suggest proceeding is the following.

1)  Unmount the file system

2)  Run "e2fsck -f" on the file system to make sure things look sane.

3) Run "debugfs -R 'stat <7>' /dev/md0" and "dumpe2fs -h /dev/md0" and
   send me the outputs just because I'm curious exactly what state the
   resize_inode --- which really shouldn't be there --- was actually in.

4)  Run "tune2fs -O ^resize_inode" on the file system

5) Run e2fsck -fy" on the file system.  The "errors" that fixed are
the result of clearing the resize_inode; don't be alarmed by them.

6) Remount the file system

7) Retry the resize2fs, making sure you are using your 3.15.6 kernel

That should hopefully allow things to work correctly.  In the future,
I will want to make the kernel and e2fsprogs more robust against this
sort of "should never happen" state, which is why I'm interested in
knowing the history of how the file system had been created and
resized in the past, and what the state was of the resize inode before
we blow it away.

Cheers,

							- Ted
