Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316AC3FE35D;
	Wed, 29 Apr 2026 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777471974; cv=none; b=X8zRudrQabxg5J06JcFEzhAmiPKg+ZDqdQssPnw2C7ODwphSKYCL68I+IWE5nw4y/iAZ29fTT8fnNA7jfr52WErHqzXYtKxJeKIcMJj5suEkyS5zsNdu4WXy7mMhcxzgVrvoTatIb1b5a1Tdbr/lEWrgfjXHJd2PKkIjmRZibwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777471974; c=relaxed/simple;
	bh=H88RuBnXJiK5hQfdWQDhe+732bMfMKcPuGgJ5tVileo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NPRlyV8g5w5QEAgyyncTRdyvFo3KNQoi3Uuvxl4PXwACFGbpvMwb3lW9O+3ZhHdp8jr9QzBMjtcz5NKQ3vM/4WdUKQbL7mi8RLJyyB7SztXF51EiT5/SaRICEZCJEANmTUOPtFmi57fQ2/1uFflh0X9FDa6Y/xUcBvekI/Op7SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MRJtb58I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRJtb58I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632E0C19425;
	Wed, 29 Apr 2026 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777471973;
	bh=H88RuBnXJiK5hQfdWQDhe+732bMfMKcPuGgJ5tVileo=;
	h=Date:From:To:Cc:Subject:From;
	b=MRJtb58If3XskNhNifTgP4LUZBIp7u+RSfUEZ1DTNRSo9Lgd6D0ql4mIA82mRyQSK
	 9gf+2rUbV4FbLzZ9QR6aOK1OsojGQOF0Zgn/P1hNJBC9OjkkDVXBb6LIzLCJ3Du0LZ
	 c19mfU7lgBklhFU/J1J5eAgbC6IIfGu6KgW8/utkbwK/sznHHSDV1FoL6oC09Cy6wM
	 gkbxXAOhm2gmiSUN6+wr7o/h1TgXAx6X48CeT6zw6VAHJRIWQLMCOWbQFhxvVph024
	 0fWH7AZaDsvM7PMNEkZsGPlQuGMO53y1ZJUrUapfm4qZN0VQXTgxxXvYX0FZg2zu4w
	 ABNP5PQT6Rmvw==
Date: Wed, 29 Apr 2026 07:12:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCHBLIZZARD v8] fuse/libfuse/e2fsprogs: faster file IO for
 containerized ext4 servers
Message-ID: <20260429141253.GQ7739@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[let's send this as a separate thread]

Hi everyone,

This is the eighth public draft of a prototype to connect the Linux
fuse driver to fs-iomap for regular file IO operations to and from files
whose contents persist to locally attached storage devices.  With this
release, I show that it's possible to build a fuse server for a real
filesystem (ext4) that runs entirely in userspace yet maintains most of
its performance.

This effort is now separate from the one to run fuse servers in a
constrained environment via systemd.  Putting fuse servers in a
container gets you all the blast radii reduction advantages and provides
a pathway to removing less popular filesystem drivers to reduce
maintenance work in the kernel; now we want trade relaxation of that
isolation for better performance.

The fuse command plumbing is very simple -- the ->iomap_begin,
->iomap_end, and iomap ->ioend calls within iomap are turned into
upcalls to the fuse server via a trio of new fuse commands.  Pagecache
writeback is now a directio write.  The fuse server can upsert mappings
into the kernel for cached access (== zero upcalls for rereads and pure
overwrites!) and the iomap cache revalidation code works.

At this stage I still get about 95% of the kernel ext4 driver's
streaming directio performance on streaming IO, and 110% of its
streaming buffered IO performance.  Random buffered IO is about 85% as
fast as the kernel.  Random direct IO is about 80% as fast as the
kernel; see the cover letter for the fuse2fs iomap changes for more
details.  Unwritten extent conversions on random direct writes are
especially painful for fuse+iomap (~90% more overhead) due to upcall
overhead.  And that's with (now dynamic) debugging turned on!

This series has been rebased to 7.1-rc1 since the seventh RFC, but it
has not otherwise changed much.  Most changes happened in userspace
this time:

1. I've written some example fuse-iomap servers, so I now have a vehicle
   for testing that out of place writes works (they do) and that inline
   data works.

2. Ted has started merging the very large quantity of fuse2fs
   improvements into e2fsprogs.

3. I reordered the systemd service container patchset towards master
   because the maintainer indicated that he wanted to merge it.

There are some questions remaining:

a. I would like to continue the discussion about how the design review
   of this code should be structured, and how might I go about creating
   new userspace filesystem servers -- lightweight new ones based off
   the existing userspace tools?  Or by merging lklfuse?

b. fuse2fs doesn't support the ext4 journal.  Urk.

c. I've dropped the fstests and BPF parts of the patchbomb because v7
   was just way too long.  I'm also not including some extra
   enhancements to fuse4fs, also for brevity.

I would like to get the main parts of this submission reviewed for 7.2
now that this has been collecting comments and tweaks in non-rfc status
for 5.5 months.

Kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-service-container

libfuse:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git/log/?h=fuse-iomap-cache

e2fsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-memory-reclaim

fstests:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuse2fs

--Darrick

Unreviewed patches:

[PATCHSET v8 1/8] fuse: general bug fixes
  [PATCH 3/4] fuse: update file mode when updating acls
  [PATCH 4/4] fuse: propagate default and file acls on creation
[PATCHSET v8 2/8] iomap: cleanups ahead of adding fuse support
  [PATCH 2/2] iomap: allow NULL swap info bdev when activating swapfile
[PATCHSET v8 3/8] fuse: cleanups ahead of adding fuse support
  [PATCH 1/2] fuse: move the passthrough-specific code back to
[PATCHSET v8 4/8] fuse: allow servers to use iomap for better file IO
  [PATCH 01/33] fuse: implement the basic iomap mechanisms
  [PATCH 02/33] fuse_trace: implement the basic iomap mechanisms
  [PATCH 03/33] fuse: make debugging configurable at runtime
  [PATCH 04/33] fuse: adapt FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} to add
  [PATCH 05/33] fuse_trace: adapt FUSE_DEV_IOC_BACKING_{OPEN,CLOSE} to
  [PATCH 06/33] fuse: enable SYNCFS and ensure we flush everything
  [PATCH 07/33] fuse: clean up per-file type inode initialization
  [PATCH 08/33] fuse: create a per-inode flag for setting exclusive
  [PATCH 10/33] fuse_trace: create a per-inode flag for toggling iomap
  [PATCH 11/33] fuse: isolate the other regular file IO paths from
  [PATCH 12/33] fuse: implement basic iomap reporting such as FIEMAP
  [PATCH 13/33] fuse_trace: implement basic iomap reporting such as
  [PATCH 14/33] fuse: implement direct IO with iomap
  [PATCH 15/33] fuse_trace: implement direct IO with iomap
  [PATCH 16/33] fuse: implement buffered IO with iomap
  [PATCH 17/33] fuse_trace: implement buffered IO with iomap
  [PATCH 18/33] fuse: use an unrestricted backing device with iomap
  [PATCH 20/33] fuse: advertise support for iomap
  [PATCH 21/33] fuse: query filesystem geometry when using iomap
  [PATCH 22/33] fuse_trace: query filesystem geometry when using iomap
  [PATCH 23/33] fuse: implement fadvise for iomap files
  [PATCH 24/33] fuse: invalidate ranges of block devices being used for
  [PATCH 25/33] fuse_trace: invalidate ranges of block devices being
  [PATCH 26/33] fuse: implement inline data file IO via iomap
  [PATCH 27/33] fuse_trace: implement inline data file IO via iomap
  [PATCH 28/33] fuse: allow more statx fields
  [PATCH 29/33] fuse: support atomic writes with iomap
  [PATCH 30/33] fuse_trace: support atomic writes with iomap
  [PATCH 31/33] fuse: disable direct fs reclaim for any fuse server
  [PATCH 32/33] fuse: enable swapfile activation on iomap
  [PATCH 33/33] fuse: implement freeze and shutdowns for iomap
[PATCHSET v8 5/8] fuse: allow servers to specify root node id
  [PATCH 1/3] fuse: make the root nodeid dynamic
  [PATCH 2/3] fuse_trace: make the root nodeid dynamic
  [PATCH 3/3] fuse: allow setting of root nodeid
[PATCHSET v8 6/8] fuse: handle timestamps and ACLs correctly when
  [PATCH 1/9] fuse: enable caching of timestamps
  [PATCH 2/9] fuse: force a ctime update after a fileattr_set call when
  [PATCH 3/9] fuse: allow local filesystems to set some VFS iflags
  [PATCH 4/9] fuse_trace: allow local filesystems to set some VFS
  [PATCH 5/9] fuse: cache atime when in iomap mode
  [PATCH 6/9] fuse: let the kernel handle KILL_SUID/KILL_SGID for iomap
  [PATCH 7/9] fuse_trace: let the kernel handle KILL_SUID/KILL_SGID for
  [PATCH 8/9] fuse: update ctime when updating acls on an iomap inode
  [PATCH 9/9] fuse: always cache ACLs when using iomap
[PATCHSET v8 7/8] fuse: cache iomap mappings for even better file IO
  [PATCH 01/12] fuse: cache iomaps
  [PATCH 02/12] fuse_trace: cache iomaps
  [PATCH 03/12] fuse: use the iomap cache for iomap_begin
  [PATCH 04/12] fuse_trace: use the iomap cache for iomap_begin
  [PATCH 05/12] fuse: invalidate iomap cache after file updates
  [PATCH 06/12] fuse_trace: invalidate iomap cache after file updates
  [PATCH 07/12] fuse: enable iomap cache management
  [PATCH 08/12] fuse_trace: enable iomap cache management
  [PATCH 09/12] fuse: overlay iomap inode info in struct fuse_inode
  [PATCH 10/12] fuse: constrain iomap mapping cache size
  [PATCH 11/12] fuse_trace: constrain iomap mapping cache size
  [PATCH 12/12] fuse: enable iomap
[PATCHSET v8 8/8] fuse: run fuse servers as a contained service
  [PATCH 1/2] fuse: allow privileged mount helpers to pre-approve iomap
  [PATCH 2/2] fuse: set iomap backing device block size
[PATCHSET v8 1/6] libfuse: allow servers to use iomap for better file
  [PATCH 01/25] libfuse: bump kernel and library ABI versions
  [PATCH 02/25] libfuse: wait in do_destroy until all open files are
  [PATCH 03/25] libfuse: add kernel gates for FUSE_IOMAP
  [PATCH 04/25] libfuse: add fuse commands for iomap_begin and end
  [PATCH 05/25] libfuse: add upper level iomap commands
  [PATCH 06/25] libfuse: add a lowlevel notification to add a new
  [PATCH 07/25] libfuse: add upper-level iomap add device function
  [PATCH 08/25] libfuse: add iomap ioend low level handler
  [PATCH 09/25] libfuse: add upper level iomap ioend commands
  [PATCH 10/25] libfuse: add a reply function to send FUSE_ATTR_* to
  [PATCH 11/25] libfuse: connect high level fuse library to
  [PATCH 12/25] libfuse: support enabling exclusive mode for files
  [PATCH 13/25] libfuse: support direct I/O through iomap
  [PATCH 14/25] libfuse: don't allow hardlinking of iomap files in the
  [PATCH 15/25] libfuse: allow discovery of the kernel's iomap
  [PATCH 16/25] libfuse: add lower level iomap_config implementation
  [PATCH 17/25] libfuse: add upper level iomap_config implementation
  [PATCH 18/25] libfuse: add low level code to invalidate iomap block
  [PATCH 19/25] libfuse: add upper-level API to invalidate parts of an
  [PATCH 20/25] libfuse: add atomic write support
  [PATCH 21/25] libfuse: allow disabling of fs memory reclaim and write
  [PATCH 22/25] libfuse: create a helper to transform an open regular
  [PATCH 23/25] libfuse: add swapfile support for iomap files
  [PATCH 24/25] libfuse: add lower-level filesystem freeze, thaw,
  [PATCH 25/25] libfuse: add upper-level filesystem freeze, thaw,
[PATCHSET v8 2/6] libfuse: allow servers to specify root node id
  [PATCH 1/1] libfuse: allow root_nodeid mount option
[PATCHSET v8 3/6] libfuse: implement syncfs
  [PATCH 1/2] libfuse: add strictatime/lazytime mount options
  [PATCH 2/2] libfuse: set sync, immutable,
[PATCHSET v8 4/6] libfuse: add some service helper commands for iomap
  [PATCH 1/3] mount_service: delegate iomap privilege from
  [PATCH 2/3] libfuse: enable setting iomap block device block size
  [PATCH 3/3] mount_service: create loop devices for regular files
[PATCHSET v8 5/6] fuse: add sample iomap fuse servers
  [PATCH 1/7] example/iomap_ll: create a simple iomap server
  [PATCH 2/7] example/iomap_ll: track block state
  [PATCH 3/7] example/iomap_ll: implement atomic writes
  [PATCH 4/7] example/iomap_inline_ll: create a simple server to test
  [PATCH 5/7] example/iomap_ow_ll: create a simple iomap out of place
  [PATCH 6/7] example/iomap_ow_ll: implement atomic writes
  [PATCH 7/7] example/iomap_service_ll: create a sample systemd service
[PATCHSET v8 6/6] libfuse: cache iomap mappings for even better file
  [PATCH 1/9] libfuse: enable iomap cache management for lowlevel fuse
  [PATCH 2/9] libfuse: add upper-level iomap cache management
  [PATCH 3/9] libfuse: allow constraining of iomap mapping cache size
  [PATCH 4/9] libfuse: add upper-level iomap mapping cache constraint
  [PATCH 5/9] libfuse: enable iomap
  [PATCH 6/9] example/iomap_ll: cache mappings for later
  [PATCH 7/9] example/iomap_inline_ll: cache iomappings in the kernel
  [PATCH 8/9] example/iomap_ow_ll: cache iomappings in the kernel
  [PATCH 9/9] example/iomap_service_ll: cache iomappings in the kernel
[PATCHSET v8 1/6] libext2fs: refactoring for fuse2fs iomap support
  [PATCH 1/5] libext2fs: invalidate cached blocks when freeing them
  [PATCH 2/5] libext2fs: only flush affected blocks in unix_write_byte
  [PATCH 3/5] libext2fs: allow unix_write_byte when the write would be
  [PATCH 4/5] libext2fs: allow clients to ask to write full superblocks
  [PATCH 5/5] libext2fs: allow callers to disallow I/O to file data
[PATCHSET v8 2/6] fuse2fs: use fuse iomap data paths for better file
  [PATCH 01/19] fuse2fs: implement bare minimum iomap for file mapping
  [PATCH 02/19] fuse2fs: add iomap= mount option
  [PATCH 03/19] fuse2fs: implement iomap configuration
  [PATCH 04/19] fuse2fs: register block devices for use with iomap
  [PATCH 05/19] fuse2fs: implement directio file reads
  [PATCH 06/19] fuse2fs: add extent dump function for debugging
  [PATCH 07/19] fuse2fs: implement direct write support
  [PATCH 08/19] fuse2fs: turn on iomap for pagecache IO
  [PATCH 09/19] fuse2fs: don't zero bytes in punch hole
  [PATCH 10/19] fuse2fs: don't do file data block IO when iomap is
  [PATCH 11/19] fuse2fs: try to create loop device when ext4 device is
  [PATCH 12/19] fuse2fs: enable file IO to inline data files
  [PATCH 13/19] fuse2fs: set iomap-related inode flags
  [PATCH 14/19] fuse2fs: configure block device block size
  [PATCH 15/19] fuse4fs: separate invalidation
  [PATCH 16/19] fuse2fs: implement statx
  [PATCH 17/19] fuse2fs: enable atomic writes
  [PATCH 18/19] fuse4fs: disable fs reclaim and write throttling
  [PATCH 19/19] fuse2fs: implement freeze and shutdown requests
[PATCHSET v8 3/6] fuse4fs: adapt iomap for fuse services
  [PATCH 1/3] fuse4fs: configure iomap when running as a service
  [PATCH 2/3] fuse4fs: set iomap backing device blocksize
  [PATCH 3/3] fuse4fs: ask for loop devices when opening via
[PATCHSET v8 4/6] fuse4fs: specify the root node id
  [PATCH 1/1] fuse4fs: don't use inode number translation when possible
[PATCHSET v8 5/6] fuse2fs: handle timestamps and ACLs correctly when
  [PATCH 01/10] fuse2fs: add strictatime/lazytime mount options
  [PATCH 02/10] fuse2fs: skip permission checking on utimens when iomap
  [PATCH 03/10] fuse2fs: let the kernel tell us about acl/mode updates
  [PATCH 04/10] fuse2fs: better debugging for file mode updates
  [PATCH 05/10] fuse2fs: debug timestamp updates
  [PATCH 06/10] fuse2fs: use coarse timestamps for iomap mode
  [PATCH 07/10] fuse2fs: add tracing for retrieving timestamps
  [PATCH 08/10] fuse2fs: enable syncfs
  [PATCH 09/10] fuse2fs: set sync, immutable,
  [PATCH 10/10] fuse4fs: increase attribute timeout in iomap mode
[PATCHSET v8 6/6] fuse2fs: cache iomap mappings for even better file
  [PATCH 1/4] fuse2fs: enable caching of iomaps
  [PATCH 2/4] fuse2fs: constrain iomap mapping cache size
  [PATCH 3/4] fuse4fs: upsert first file mapping to kernel on open
  [PATCH 4/4] fuse2fs: enable iomap
