From: Theodore Tso <tytso@mit.edu>
Subject: Re: [BUG] Badness at fs/ext4/inode.c:1121
Date: Tue, 8 Sep 2009 07:38:09 -0400
Message-ID: <20090908113809.GI22901@mit.edu>
References: <4AA5FE71.7000006@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	sachin p sant <sachinp@linux.vnet.ibm.com>,
	Ramon <rcvalle@linux.vnet.ibm.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56541 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbZIHLiL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 07:38:11 -0400
Content-Disposition: inline
In-Reply-To: <4AA5FE71.7000006@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 12:19:21PM +0530, Nageswara R Sastry wrote:
> Hi,
>
> While working with fsfuzz encountered the following kernel stack traces.
>
> Environment: 2.6.31-rc9
> Architecture: s390
>
> ------------[ cut here ]------------
> Badness at fs/ext4/inode.c:1121

That's coming from check_block_validity, and it indicates a file
system corruption.  Not surprising, since you are using fsfuzzer!

static int check_block_validity(struct inode *inode, sector_t logical,
				sector_t phys, int len)
{
	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), phys, len)) {
		ext4_error(inode->i_sb, "check_block_validity",
			   "inode #%lu logical block %llu mapped to %llu "
			   "(size %d)", inode->i_ino,
			   (unsigned long long) logical,
			   (unsigned long long) phys, len);
		WARN_ON(1); <-------------- line #1121
		return -EIO;
	}
	return 0;
}

The problem is that it looks scary, doesn't tell the user what to do,
and the stack trace isn't really useful.  I'll clean up the error
message, but for now, you can ignore the "Baddness at
fs/ext4/inode.c:1121" for 2.6.31-rc9".  I'll create a patch to drop
the WARN_ON(1) and to add a better explanatory message for
ext4_error().

Depending on the file system's mount options, the ext4_error() call
will result in the filesystem getting remouted read-only, a system
panic, or in the "errors=continue", aka "don't worry, be happy mode",
the error will be logged and then ignored.  The last will lead to file
system corruption and/or further system errors, and is not recommended
on production server systems.

						- Ted
