From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/35] e2fsck: read-ahead metadata during passes 1, 2,
 and 4
Date: Mon, 20 Apr 2015 23:03:52 -0400
Message-ID: <20150421030352.GE3238@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023427.25243.66810.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49225 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbbDUDDx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 23:03:53 -0400
Content-Disposition: inline
In-Reply-To: <20150402023427.25243.66810.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:34:27PM -0700, Darrick J. Wong wrote:
> e2fsck pass1 is modified to use the block group data prefetch function
> to try to fetch the inode tables into the pagecache before it is
> needed.  We iterate through the blockgroups until we have enough inode
> tables that need reading such that we can issue readahead; then we sit
> and wait until the last inode table block read of the last group to
> start fetching the next bunch.
> 
> pass2 is modified to use the dirblock prefetching function to prefetch
> the list of directory blocks that are assembled in pass1.  We use the
> "iterate a subset of a dblist" and avoid copying the dblist.  Directory
> blocks are fetched incrementally as we walk through the directory
> block list.  In previous iterations of this patch we would free the
> directory blocks after processing, but the performance hit to e2fsck
> itself wasn't worth it.  Furthermore, it is anticipated that most
> users will then mount the FS and start using the directories, so they
> may as well remain in the page cache.
> 
> pass4 is modified to prefetch the block and inode bitmaps in
> anticipation of pass 5, because pass4 is entirely CPU bound.
> 
> In general, these mechanisms can decrease fsck time by 10-40%, if the
> host system has sufficient memory and the storage system can provide a
> lot of IOPs.  Pretty much any storage system capable of handling
> multiple IOs in-flight at any time will see a fairly large performance
> boost.  (Single-issue USB mass storage disks seem to suffer badly.)
> 
> By default, the readahead buffer size will be set to the size of a block
> group's inode table (which is 2MiB for a regular ext4 FS).  The -E
> readahead_kb= option can be given to specify the amount of memory to
> use for readahead or zero to disable it entirely; or an option can be
> given in e2fsck.conf.
> 
> v2: Fix an off-by-one error in the pass1 readahead which made the
> readahead trigger one inode too late if the block groups are full.
> 
> v3: Use the dblist partial iterator function to read ahead parts
> of the directory block list in pass 2, instead of making sublists.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
