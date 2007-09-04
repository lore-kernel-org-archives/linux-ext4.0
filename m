From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] System calls for online defrag
Date: Tue, 4 Sep 2007 12:01:53 -0600
Message-ID: <20070904180153.GF5377@schatzie.adilger.int>
References: <20070903180329.GK7524@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070903180329.GK7524@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 03, 2007  20:03 +0200, Jan Kara wrote:
>   I've finally got to writing up some proposal how could look system calls
> allowing for online filesystem defragmentation and generally moving file
> blocks around for improving performance. Comments are welcome.
> 
> int sys_movedata(int datafd, int spacefd, loff_t from, size_t len)
>    The call takes blocks used to carry data starting at offset @from of length
> @len in @spacefd and places them instead of corresponding blocks in @datafd.

Calling these "@spacefd" and "@datafd" is a bit confusing.  How about "@srcfd"
and "@tgtfd" instead?  For defragmentation, are you planning to have @datafd
be the "real" inode and "@spacefd" be the temporary inode with defragged data,
or the reverse?  It isn't really clear.

> Data is copied from @datafd to newly spliced data blocks. If @spacefd contains
> a hole in the specified interval, a hole is created also in @datafd in the
> corresponding place. A data block from @spacefd and also replace a hole in
> @datafd - zeros are copied to such data block. @from and @len should be
> multiples of filesystem block size (otherwise EINVAL is returned). Data blocks
> from @datafd in the interval are released, a hole is created in @spacefd.

This is mostly clear except the last sentence.  I would think that the data
blocks in @datafd are kept, getting a copy of the data, while those in
@spacefd are released?

>   Another possibility would be to just replace data blocks without any copying
> of data (that would have to be done by the caller to before calling
> sys_movedata()). The problem here is how to avoid data loss if someone writes
> to the file after userspace has copied the data and before sys_movedata() is
> called.

Isn't that true in any case?

> ssize_t sys_allocate(int fd, int mode, loff_t goal, ssize_t len)
>   Allocate new space to file @fd at offset defined by file position.  Both file
> offset and @len should be a multiple of filesystem block size. The whole
> interval must not contain any allocated blocks. If the interval extends past
> EOF, the file size is changed accordingly.  @mode defines a way the filesystem
> will search for blocks. @mode is a bitwise OR of the following flags:
>   ALLOC_FIXED_START - allocation must start at @goal; if not specified, @goal
> is just a hint where to start an allocation
>   ALLOC_FIXED_LEN - allocate exactly space for @len; if not specified, upto
> @len bytes may be allocated.
>   ALLOC_CONTINGUOUS - allocation must be one continguous run of blocks

How is this much different than sys_fallocate()?

> int sys_get_free_blocks(const char *fs, loff_t start, loff_t end, int count,
>   struct alloc_extent *space)

One alternate possibility is to call the proposed FIEMAP on the block device,
to return lists of free/used extents?  We have a version of that patch for
ext4 and integration into filefrag, so it would be nice to avoid making up
yet another API/tool if that one is sufficient.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

