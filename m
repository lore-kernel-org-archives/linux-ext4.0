From: Andrew Morton <akpm@linux-foundation.org>
Subject: fallocate support for bitmap-based files
Date: Fri, 29 Jun 2007 13:01:20 -0700
Message-ID: <20070629130120.ec0d1c75.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Mike Waychison <mikew@google.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbXF2UBf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jun 2007 16:01:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Guys, Mike and Sreenivasa at google are looking into implementing
fallocate() on ext2.  Of course, any such implementation could and should
also be portable to ext3 and ext4 bitmapped files.

I believe that Sreenivasa will mainly be doing the implementation work.


The basic plan is as follows:

- Create (with tune2fs and mke2fs) a hidden file using one of the
  reserved inode numbers.  That file will be sized to have one bit for each
  block in the partition.  Let's call this the "unwritten block file".

  The unwritten block file will be initialised with all-zeroes

- at fallocate()-time, allocate the blocks to the user's file (in some
  yet-to-be-determined fashion) and, for each one which is uninitialised,
  set its bit in the unwritten block file.  The set bit means "this block
  is uninitialised and needs to be zeroed out on read".

- truncate() would need to clear out set-bits in the unwritten blocks file.

- When the fs comes to read a block from disk, it will need to consult
  the unwritten blocks file to see if that block should be zeroed by the
  CPU.

- When the unwritten-block is written to, its bit in the unwritten blocks
  file gets zeroed.

- An obvious efficiency concern: if a user file has no unwritten blocks
  in it, we don't need to consult the unwritten blocks file.

  Need to work out how to do this.  An obvious solution would be to have
  a number-of-unwritten-blocks counter in the inode.  But do we have space
  for that?

  (I expect google and others would prefer that the on-disk format be
  compatible with legacy ext2!)

- One concern is the following scenario:

  - Mount fs with "new" kernel, fallocate() some blocks to a file.

  - Now, mount the fs under "old" kernel (which doesn't understand the
    unwritten blocks file).

    - This kernel will be able to read uninitialised data from that
      fallocated-to file, which is a security concern.

  - Now, the "old" kernel writes some data to a fallocated block.  But
    this kernel doesn't know that it needs to clear that block's flag in
    the unwritten blocks file!

  - Now mount that fs under the "new" kernel and try to read that file.
     The flag for the block is set, so this kernel will still zero out the
    data on a read, thus corrupting the user's data

  So how to fix this?  Perhaps with a per-inode flag indicating "this
  inode has unwritten blocks".  But to fix this problem, we'd require that
  the "old" kernel clear out that flag.

  Can anyone propose a solution to this?

  Ah, I can!  Use the compatibility flags in such a way as to prevent the
  "old" kernel from mounting this filesystem at all.  To mount this fs
  under an "old" kernel the user will need to run some tool which will

  - read the unwritten blocks file

  - for each set-bit in the unwritten blocks file, zero out the
    corresponding block

  - zero out the unwritten blocks file

  - rewrite the superblock to indicate that this fs may now be mounted
    by an "old" kernel.

  Sound sane?

- I'm assuming that there are more reserved inodes available, and that
  the changes to tune2fs and mke2fs will be basically a copy-n-paste job
  from the `tune2fs -j' code.  Correct?

- I haven't thought about what fsck changes would be needed.

  Presumably quite a few.  For example, fsck should check that set-bits
  in the unwriten blobks file do not correspond to freed blocks.  If they
  do, that should be fixed up.

  And fsck can check each inodes number-of-unwritten-blocks counters
  against the unwritten blocks file (if we implement the per-inode
  number-of-unwritten-blocks counter)

  What else should fsck do?

- I haven't thought about the implications of porting this into ext3/4. 
  Probably the commit to the unwritten blocks file will need to be atomic
  with the commit to the user's file's metadata, so the unwritten-blocks
  file will effectively need to be in journalled-data mode.

  Or, more likely, we access the unwritten blocks file via the blockdev
  pagecache (ie: use bmap, like the journal file) and then we're just
  talking direct to the disk's blocks and it becomes just more fs metadata.

- I guess resize2fs will need to be taught about the unwritten blocks
  file: to shrink and grow it appropriately.


That's all I can think of for now - I probably missed something. 

Suggestions and thought are sought, please.
