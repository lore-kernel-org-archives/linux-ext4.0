From: Jan Kara <jack@suse.cz>
Subject: [RFC] Defragmentation interface
Date: Thu, 2 Nov 2006 15:39:29 +0100
Message-ID: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53173 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S1750916AbWKBOja (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Nov 2006 09:39:30 -0500
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  from the thread after my patch implementing ext3 online
defragmentation I found out that probably the only (and definitely the
biggest) issue is the interface. Someone wants is common enough so that
we can profit from common tools for several filesystems, others object
that some applications, e.g. defragmenter, need to know something about
ext3 internals to work reasonably well. Moreover ioctl() is ugly and has
some compatibility issues, on the other hand ext2meta is too lowlevel,
fs-specific and it would be hard to do any reasonable application
crash-safe...
  So in this email I try to propose some interface which should hopefully
address most of the concerns. The type of the interface is sysfs like
(idea taken from ext2meta) - that has a few advantages:
 - no 32/64-bit compatibility issues
 - easily extensible
 - generally nice ;)

  Each filesystem willing to support this interface implements special
filesystem (e.g. ext3meta, XFSmeta, ...) and admin/defrag-tool mounts it
to some directory. There are parts of this interface which should be
common for all filesystems (so that tools don't have to care about
particular filesystem and still get some useful results), other parts
are fs-specific. Here is basic structure I propose:

meta/features
  - bitmap of features supported by the interface (ext2/3-like) so that
    the tool can verify whether it understands the interface and don't
    mess with it otherwise
meta/allocation/free_blocks
  - RO file - if you read from fpos F, you'll get a list of extents
    describing areas with free blocks (as many as fits into supplied
    buffer) starting from block F. Fpos of your file descriptor is
    shifted to the first unreported free block.
meta/super/blocksize
  - filesystem block size
meta/super/id
  - filesystem ID (for paranoid tools to verify that they are accessing
    really the right meta-filesystem)
meta/nodes/<ident>
  - this should be a directory containing things specific for a fs-object
    with identification <ident>. In case of ext3 these would be inode
    numbers, I guess this should be plausible also for XFS and others
    but I'm open to suggestions...
  - directory contains the following:
  alloc_goal
    - block number with current allocation goal
  data/extents
    - if you read from this file, you get a list of extents describing
      data blocks (and holes) of the file. The listing starts at logical
      block fpos. Fpos is shifted to the first unreported data block.
  data/alloc
    - you write there a number L and fs allocates L blocks to a file
      (preferable from alloc_goal) starting from file-block fpos. Fpos
      is shifted after the last block allocated in this call.
  data/reloc
    - you write there <ident> and relocation of data happens as follows:
      All blocks that are allocated both in original file and <ident>
      are relocated to <ident>. Write returns number of relocated
      blocks.
  metadata/
    - this directory is fs-specific, contains fs block pointers and
      similar. Here I describe what I'd like to have for ext3.
  metadata/alloc
    - you write there number Level and a fs allocates an indirect block
      to a file for logical block fpos at level Level of the indirect
      tree. Parent indirect block must be already allocated.
  metadata/reloc
    - you write two numbers <ident> Level and an indirect block for
      logical offset fpos at level Level will be swapped with
      corresponding indirect block of <ident>.

  This is all that is needed for my purposes. Any comments welcome.

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
