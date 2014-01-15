From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 50/74] libext2fs: support allocating uninit blocks in
 bmap2()
Date: Wed, 15 Jan 2014 17:23:31 -0500
Message-ID: <20140115222331.GB12057@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012353.30655.82545.stgit@birch.djwong.org>
 <20140111225755.GB10995@thunk.org>
 <20140115211122.GJ9229@birch.djwong.org>
 <20140115221951.GA12226@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48761 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbaAOWXd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jan 2014 17:23:33 -0500
Content-Disposition: inline
In-Reply-To: <20140115221951.GA12226@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 15, 2014 at 05:19:51PM -0500, Theodore Ts'o wrote:
> 	{
> 		struct ext2_inode t;
> 
> 		ext2fs_read_inode(fs, *ino, &t);
> 		printf("i_size_high: %lu size: %llu\n", t.i_size_high,
> 		       EXT2_I_SIZE(&t));
> 	}

Oops, ignore this debugging code.  This was to find a bug in
ext2fs_extents_insert() where under some circumstances it end up
running into a buffer overrun bug which causes it to wipe out
i_size_high.

						- Ted
