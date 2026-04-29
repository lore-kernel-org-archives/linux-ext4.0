Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98C9277C9D;
	Wed, 29 Apr 2026 14:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777472434; cv=none; b=XtMjjbmLtdxTFQCBmUiBEoSnX9MfstORCBPsZ0PyH9B0N8kFtsdZC2ucYxbEZ8DD2FUMfWmC8Arcf+u7cx2VrNdH+Qg09VKhLFjsxTiHxf65SVpCqfxEF4E6GAECnJOHluSWEPRXd9xfNEG/RPQpRfy2PxpkfRLPrdvESJiCj1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777472434; c=relaxed/simple;
	bh=YBQ1Vvl3N3X8rFxDpuVvsiFTa90O0kDuuGuIqb2sACE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mp3QkXRkBPYtNV3GhiH3VpfDjWLIZqz1vb9WPLi1AuQpu3VyVL/kwyyDL+0g4GzNgbM4a+XgHcMMPW0yyxQOMVDQP/U5PzhrIEQ1kbBUEDzaBNxMw/nfT2EKLtlun2Pqu7X5+z4SMlOCXvlAKGISykGj06zVt+ayaOsD9sRwSb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jj9Rsu8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jj9Rsu8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858ADC19425;
	Wed, 29 Apr 2026 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472434;
	bh=YBQ1Vvl3N3X8rFxDpuVvsiFTa90O0kDuuGuIqb2sACE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Jj9Rsu8V9dM6s3mEChI128TRSKVNW4S9h4y1KzrJjCnHzS2IlErMvop7ymQMLKotV
	 UK3PpOCL/ekGj6HtucA8KW/XMqsf3pxnInUkVSGcK0hCtcCLeiRzav3BP/mHiy55R/
	 62T5Nb0KH6dNNSaK3CnupfUdoUQxVdp2X8tK0+1jyJBlaxFZnqNyat6yabacmJeNLT
	 exlqXwIyWXgivY1cF3o91Bquct6t3oYwivLz8N/8SFokRTycrfOYi+fx+pKaNTKGii
	 6VFpxfKr2VPXdCvO+REiKX88uK0FcyilokD21KuUWqxbQCShRN6VrUk7FHQG6h7NQK
	 MsIWCY4mHLb5g==
Date: Wed, 29 Apr 2026 07:20:34 -0700
Subject: [PATCHSET v8 2/6] fuse2fs: use fuse iomap data paths for better file
 I/O performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: tytso@mit.edu
Cc: bernd@bsbernd.com, miklos@szeredi.hu, linux-ext4@vger.kernel.org,
 neal@gompa.dev, linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 joannelkoong@gmail.com
Message-ID: <177747214459.4107473.9520724883867588970.stgit@frogsfrogsfrogs>
In-Reply-To: <20260429141253.GQ7739@frogsfrogsfrogs>
References: <20260429141253.GQ7739@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Switch fuse2fs to use the new iomap file data IO paths instead of
pushing it very slowly through the /dev/fuse connection.  For local
filesystems, all we have to do is respond to requests for file to device
mappings; the rest of the IO hot path stays within the kernel.  This
means that we can get rid of all file data block processing within
fuse2fs.

Because we're not pinning dirty pages through a potentially slow network
connection, we don't need the heavy BDI throttling for which most fuse
servers have become infamous.  Yes, mapping lookups for writeback can
stall, but mappings are small as compared to data and this situation
exists for all kernel filesystems as well.

The performance of this new data path is quite stunning: on a warm
system, streaming reads and writes through the pagecache go from
60-90MB/s to 2-2.5GB/s.  Direct IO reads and writes improve from the
same baseline to 2.5-8GB/s.  FIEMAP and SEEK_DATA/SEEK_HOLE now work
too.  The kernel ext4 driver can manage about 1.6GB/s for pagecache IO
and about 2.6-8.5GB/s, which means that fuse2fs is about as fast as the
kernel for streaming file IO.

Random 4k buffered IO is not so good: plain fuse2fs pokes along at
25-50MB/s, whereas fuse2fs with iomap manages 90-1300MB/s.  The kernel
can do 900-1300MB/s.  Random directio is worse: plain fuse2fs does
20-30MB/s, fuse-iomap does about 30-35MB/s, and the kernel does
40-55MB/s.  I suspect that metadata heavy workloads do not perform well
on fuse2fs because libext2fs wasn't designed for that and it doesn't
even have a journal to absorb all the fsync writes.  We also probably
need iomap caching really badly.

These performance numbers are slanted: my machine is 12 years old, and
fuse2fs is VERY poorly optimized for performance.  It contains a single
Big Filesystem Lock which nukes multi-threaded scalability.  There's no
inode cache nor is there a proper buffer cache, which means that fuse2fs
reads metadata in from disk and checksums it on EVERY ACCESS.  Sad!

Despite these gaps, this RFC demonstrates that it's feasible to run the
metadata parsing parts of a filesystem in userspace while not
sacrificing much performance.  We now have a vehicle to move the
filesystems out of the kernel, where they can be containerized so that
malicious filesystems can be contained, somewhat.

iomap mode also calls FUSE_DESTROY before unmounting the filesystem, so
for capable systems, fuse2fs doesn't need to run in fuseblk mode
anymore.

However, there are some major warts remaining:

1. The iomap cookie validation is not present, which can lead to subtle
races between pagecache zeroing and writeback on filesystems that
support unwritten and delalloc mappings.

2. Mappings ought to be cached in the kernel for more speed.

3. iomap doesn't support things like fscrypt or fsverity, and I haven't
yet figured out how inline data is supposed to work.

4. I would like to be able to turn on fuse+iomap on a per-inode basis,
which currently isn't possible because the kernel fuse driver will iget
inodes prior to calling FUSE_GETATTR to discover the properties of the
inode it just read.

5. ext4 doesn't support out of place writes so I don't know if that
actually works correctly.

6. iomap is an inode-based service, not a file-based service.  This
means that we /must/ push ext2's inode numbers into the kernel via
FUSE_GETATTR so that it can report those same numbers back out through
the FUSE_IOMAP_* calls.  However, the fuse kernel uses a separate nodeid
to index its incore inode, so we have to pass those too so that
notifications work properly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

e2fsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse2fs-iomap-fileio
---
Commits in this patchset:
 * fuse2fs: implement bare minimum iomap for file mapping reporting
 * fuse2fs: add iomap= mount option
 * fuse2fs: implement iomap configuration
 * fuse2fs: register block devices for use with iomap
 * fuse2fs: implement directio file reads
 * fuse2fs: add extent dump function for debugging
 * fuse2fs: implement direct write support
 * fuse2fs: turn on iomap for pagecache IO
 * fuse2fs: don't zero bytes in punch hole
 * fuse2fs: don't do file data block IO when iomap is enabled
 * fuse2fs: try to create loop device when ext4 device is a regular file
 * fuse2fs: enable file IO to inline data files
 * fuse2fs: set iomap-related inode flags
 * fuse2fs: configure block device block size
 * fuse4fs: separate invalidation
 * fuse2fs: implement statx
 * fuse2fs: enable atomic writes
 * fuse4fs: disable fs reclaim and write throttling
 * fuse2fs: implement freeze and shutdown requests
---
 configure            |   90 ++
 configure.ac         |   54 +
 fuse4fs/fuse4fs.1.in |    6 
 fuse4fs/fuse4fs.c    | 1934 +++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/config.h.in      |    6 
 misc/fuse2fs.1.in    |    6 
 misc/fuse2fs.c       | 1947 ++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 4016 insertions(+), 27 deletions(-)

