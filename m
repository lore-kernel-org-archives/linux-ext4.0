From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][take 2] e2fsprogs: Add ext4migrate
Date: Tue, 3 Apr 2007 14:32:52 -0600
Message-ID: <20070403203252.GZ5967@schatzie.adilger.int>
References: <11755948452525-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50305 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945915AbXDCUcy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Apr 2007 16:32:54 -0400
Content-Disposition: inline
In-Reply-To: <11755948452525-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 03, 2007  15:37 +0530, Aneesh Kumar K.V wrote:
> The extent insert code is derived out of the latest ext4 kernel
> source. I have tried to keep the code as close as possible to the
> kernel sources. This makes sure that any fixes for the tree building
> code in kernel should be easily applied to ext4migrate.  The ext3_ext
> naming convention instead of ext4_ext found in kernel is to make sure
> we are in sync with rest of e2fsprogs source.

Of course, the other way to do this would be to temporarily mount the
filesystem as ext4, copy non-extent files via "cp" (can use lsattr to
check for extent flag) and then rename new file over old one.  Care
must be taken to not mount filesystem on "visible" mountpoint, so that
users cannot be changing the filesystem while copy is being done.

This can be done to convert an ext4 filesystem back to ext3 also, if
the ext4 filesystem is mounted with "noextents" (to disable creation
of new files with extent mapping).

The only minor issue is that the inode numbers of the files will change.

> The inode modification is done only at the last stage. This is to make
> sure that if we fail at any intermediate stage, we exit without touching
> the disk.
> 
> The inode update is done as below
> a) Walk the extent index blocks and write them to the disk. If failed exit
> b) Write the inode. if failed exit.
> c) Write the updated block bitmap. if failed exit ( This could be a problem
>    because we have already updated the inode i_block filed to point to new
>    blocks.). But such inconsistancy between inode i_block and block bitmap
>    can be fixed by fsck IIUC.

Why not mark all the relevant blocks in use (for both exent- and block-mapped
copies) until the copy is done, then write everything out, and only mark the
block-mapped file blocks free after the inode is written to disk?  This avoids
the danger that the new extent-mapped file's blocks are marked free and get
double-allocated (corrupting the file data, possibly the whole filesystem).

I don't think there is a guarantee that an impatient user will run a lengthy
e2fsck after interrupting the migrate.  Also, you should mark the filesystem
unclean at first change unless everything completes successfully.  That way
e2fsck will at least run automatically on the next boot.


Other general notes:
- wrap lines at 80 columns
- would be good to have a "-R" mode that walked the whole filesystem,
  since startup time is very long for large filesystems
- also allow specifying multiple files on the command-line
- changing the operation to be multi-file allows avoiding sync of bitmaps
  two times (once after extents are allocated and inode written, once after
  indirect blocks are freed).  There only needs to be one sync per file.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
