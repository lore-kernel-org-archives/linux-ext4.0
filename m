From: Jan Kara <jack@suse.cz>
Subject: [RFC] System calls for online defrag
Date: Mon, 3 Sep 2007 20:03:29 +0200
Message-ID: <20070903180329.GK7524@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39308 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755153AbXICRn6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2007 13:43:58 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  I've finally got to writing up some proposal how could look system calls
allowing for online filesystem defragmentation and generally moving file
blocks around for improving performance. Comments are welcome.

								Honza

int sys_movedata(int datafd, int spacefd, loff_t from, size_t len)
   The call takes blocks used to carry data starting at offset @from of length
@len in @spacefd and places them instead of corresponding blocks in @datafd.
Data is copied from @datafd to newly spliced data blocks. If @spacefd contains
a hole in the specified interval, a hole is created also in @datafd in the
corresponding place. A data block from @spacefd and also replace a hole in
@datafd - zeros are copied to such data block. @from and @len should be
multiples of filesystem block size (otherwise EINVAL is returned). Data blocks
from @datafd in the interval are released, a hole is created in @spacefd. The
call returns either 0 (success) or an error code.
  Another possibility would be to just replace data blocks without any copying
of data (that would have to be done by the caller to before calling
sys_movedata()). The problem here is how to avoid data loss if someone writes
to the file after userspace has copied the data and before sys_movedata() is
called.



ssize_t sys_allocate(int fd, int mode, loff_t goal, ssize_t len)
  Allocate new space to file @fd at offset defined by file position.  Both file
offset and @len should be a multiple of filesystem block size. The whole
interval must not contain any allocated blocks. If the interval extends past
EOF, the file size is changed accordingly.  @mode defines a way the filesystem
will search for blocks. @mode is a bitwise OR of the following flags:
  ALLOC_FIXED_START - allocation must start at @goal; if not specified, @goal
is just a hint where to start an allocation
  ALLOC_FIXED_LEN - allocate exactly space for @len; if not specified, upto
@len bytes may be allocated.
  ALLOC_CONTINGUOUS - allocation must be one continguous run of blocks

  If the allocation succeeds, number of allocated bytes is returned. Otherwise
an error code is returned.



The following syscall may be also useful - although I'm not completely
convinced this is the right way to go. But on the other hand, disk optimizer
should have a way to find out about free space so that he can decide what and
where is beneficial to move.

int sys_get_free_blocks(const char *fs, loff_t start, loff_t end, int count,
  struct alloc_extent *space)

  Get a description of free space on a filesystem between @start and @end (in
bytes, should be blocksize aligned). @fs is a path where the filesystem is
mounted (I guess it's better than dev_t, isn't it?). @space is a pointer to an
array of 'struct alloc_extent'. In each struct alloc_extent is stored
description of one extent of free space. Upto @count extents are stored.

struct alloc_extent {
  loff_t start;
  size_t len;
};
  Function returns a number of extents stored. Note that the result of the
function is unreliable as the space can be already allocated by the time system
call returns.

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
