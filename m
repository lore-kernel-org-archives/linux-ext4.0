From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 37/74] libext2fs: don't always read backup group
 descriptors on a 1k-block meta_bg fs
Date: Sat, 11 Jan 2014 13:59:44 -0500
Message-ID: <20140111185944.GC1582@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012226.30655.66387.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47563 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaAKS74 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 13:59:56 -0500
Content-Disposition: inline
In-Reply-To: <20131211012226.30655.66387.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:26PM -0800, Darrick J. Wong wrote:
> On a filesystem with 1K blocks and meta_bg enabled, opening a
> filesystem with automatic superblock detection tries to compensate for
> the fact that the superblock lives in block 1.  However, the method by
> which this is done is later misinterpreted to mean "read the backup
> group descriptors", which is not what we want in this case.
> 
> Therefore, in ext2fs_open3() separate the 'group zero' adjustment into
> its own variable so that we don't get fed backup group descriptors
> when we try to load meta_bg group descriptors.
> 
> Furthermore, enhance ext2fs_descriptor_block_loc2() to perform its own
> group zero correction.  The other caller of this function neglects to
> do any group-zero correction of their own, so this fixes them too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied to the maint branch.

							- Ted
