From: Theodore Tso <tytso@mit.edu>
Subject: Re: Incompatibility between mballoc and online resize
Date: Tue, 10 Jun 2008 08:36:25 -0400
Message-ID: <20080610123625.GA18768@mit.edu>
References: <E1K5uo4-0004t4-4d@closure.thunk.org> <20080610062445.GH3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex.tomas@sun.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37488 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752856AbYFJMga (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jun 2008 08:36:30 -0400
Content-Disposition: inline
In-Reply-To: <20080610062445.GH3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 10, 2008 at 12:24:45AM -0600, Andreas Dilger wrote:
> When Lustre is mounting the backing filesystem on the server, there is
> no ext3 mountpoint visible to userspace, hence no access to the underlying
> filesystem to pass the resize ioctl to, so we haven't had this problem
> yet.  We filed a bug on it, for the time that we can pass an ioctl through:
> 
> https://bugzilla.lustre.org/show_bug.cgi?id=15208
> 
> We have another open bug related to resize2fs and uninit_bg, but that
> is for offline resizing:
> 
> https://bugzilla.lustre.org/show_bug.cgi?id=12002
> 
> Both of these bugs are mere placeholders, they don't have any patches.

There is a third (and possibly fourth) problem, which is that online
resizing with ext4dev (even without any patches from the ext4 patch
queue) is corrupting the filesystem, by not properly initializing the
block group descriptors:

Group 8: (Blocks 65537-73728)
  Block bitmap at 0, Inode bitmap at 0
  Inode table at 0-255
  0 free blocks, 0 free inodes, 0 directories
  Free blocks: 
  Free inodes: 
Group 9: (Blocks 73729-79999)
  Backup superblock at 73729, Group descriptors at 73730-73730
  Reserved GDT blocks at 73731-73985
  Block bitmap at 0, Inode bitmap at 0
  Inode table at 0-255
  0 free blocks, 0 free inodes, 0 directories
  Free blocks: 
  Free inodes: 

Furthermore, if the filesystem is grown to the point where a second
set of blocks need to be pulled from the resize inode, apparently the
resize inode is getting corrupted:

Performing an on-line resize of /dev/ubd16 to 12582912 (1k) blocks.
EXT4-fs warning (device ubdb): verify_reserved_gdb: reserved GDT 3 missing grp 1 (8195)
resize2fs: Invalid argument While trying to add group #25

I'm not sure if this is related to the third probably above, since
until that problem is fixed it makes it hard to determine what is
going on with the 4th.  They may end up having the same root cause.

I'm looking into it, but it seems pretty clear to me no one has really
tested online resizing on ext4 in quite a while, and the code has
bitrotted.  Hopefully it won't be too hard to fix it.  In the mean
time, it really makes me wonder how on earth Josef Bacik actually
tested this patch:

commit 944600930a37aa725ba6f93c3244e2d77a1e3581
Author: Josef Bacik <jbacik@redhat.com>
Date:   Fri Jun 6 18:05:52 2008 -0400

    ext4: fix online resize bug
    
    There is a bug when we are trying to verify that the reserve inode's
    double indirect blocks point back to the primary gdt blocks.  The fix is
    obvious, we need to mod the gdb count by the addr's per block.  This was
    verified using the same testcase as with the ext3 equivalent of this
    patch.
    
    Signed-off-by: Josef Bacik <jbacik@redhat.com>
    Signed-off-by: Mingming Cao <cmm@us.ibm.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
