From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch 4/13] Allow regular files to be preallocated on-disk.
Date: Fri, 3 Aug 2007 20:40:13 -0400
Message-ID: <20070804004013.GF7449@thunk.org>
References: <1185275088.3789.69.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35356 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbXHDGCU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2007 02:02:20 -0400
Content-Disposition: inline
In-Reply-To: <1185275088.3789.69.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 24, 2007 at 04:34:48PM +0530, Girish Shilamkar wrote:
> Allow regular files to be preallocated on-disk up to the next multiple
> of the system PAGE_SIZE without complaining about extra blocks.

Applied, with some fixups.

>  	} else {
> +		e2_blkcnt_t blkpg = getpagesize() / fs->blocksize;

The getpagesize() call was marked LEGACY in SuSv2, and it was dropped
in POSIX.1-2001.  It's much better to use sysconf(_SC_PAGESIZE).

Also, the patch will cause e2fsck to core dump if it is asked to check
a filesystem where fs->blocksize is > page_size.  So in that case, we
have to set blkpg to 1.

Finally, it's a bad idea to call getpagesize() for every single inode,
since potentially getpagesize() or sysconf(_SC_PAGESIZE) could
potentially require a system call.  So this should be factored out and
stashed away in the e2fsck context structure.

I'm also a little concerned this patch doesn't solve the problem where
a filesystem that had been previously mounted on an IA64 machine gets
connected to an x86 machine and then e2fsck is run.  This patch
doesn't make the problem any more worse, and to fix this for real
would require stashing the largest blocksize ever used by the
filesystem in the superblock, and I'm not entirely convinced it's
worth it.

					- Ted
