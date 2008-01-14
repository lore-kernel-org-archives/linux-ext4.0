From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH resend] Fix reading of bitmaps from filesystem image
Date: Mon, 14 Jan 2008 17:17:29 +0100
Message-ID: <20080114161729.GF4214@duck.suse.cz>
References: <20080109195435.GD2215@duck.suse.cz> <20080114155718.GC25813@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:37050 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750744AbYANQRc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2008 11:17:32 -0500
Content-Disposition: inline
In-Reply-To: <20080114155718.GC25813@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 14-01-08 10:57:18, Theodore Tso wrote:
> On Wed, Jan 09, 2008 at 08:54:35PM +0100, Jan Kara wrote:
> > 
> > Reading of bitmaps from image file could never work with more than one
> > group in a filesystem... Fix the loops so that we read appropriate number
> > of blocks.
> 
> OK, so I'm probably being dense, but.... what's the problem?
> 
> You changed the loop from counting in bytes to inodes, but either
> method should work.
  At the beginning of read_bitmap() there is:
        unsigned int block_nbytes = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
        unsigned inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;

  Therefore in the loop:
     while (inode_nbytes > 0)

  we end up reading bitmap for just one group...

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
