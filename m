From: Theodore Tso <tytso@mit.edu>
Subject: Re: Fix softlockup caused by illegal i_file_acl value in on-disk
	inode
Date: Wed, 3 Jun 2009 15:24:36 -0400
Message-ID: <20090603192436.GK31943@mit.edu>
References: <1243944479-20574-5-git-send-email-tytso@mit.edu> <1243944479-20574-6-git-send-email-tytso@mit.edu> <1243944479-20574-7-git-send-email-tytso@mit.edu> <1243944479-20574-8-git-send-email-tytso@mit.edu> <1243944479-20574-9-git-send-email-tytso@mit.edu> <1243944479-20574-10-git-send-email-tytso@mit.edu> <1243944479-20574-11-git-send-email-tytso@mit.edu> <1243944479-20574-12-git-send-email-tytso@mit.edu> <1243944479-20574-13-git-send-email-tytso@mit.edu> <20090603181608.GO9002@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40981 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbZFCTYi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jun 2009 15:24:38 -0400
Content-Disposition: inline
In-Reply-To: <20090603181608.GO9002@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 03, 2009 at 12:16:08PM -0600, Andreas Dilger wrote:
> On Jun 02, 2009  08:07 -0400, Theodore Ts'o wrote:
> > +	if (ei->i_file_acl &&
> > +	    ((ei->i_file_acl < 
> > +	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
> > +	       EXT4_SB(sb)->s_gdb_count)) ||
> > +	     (ei->i_file_acl >= ext4_blocks_count(EXT4_SB(sb)->s_es)))) {
> 
> I was just thinking it might make sense to wrap this check into a helper
> like the following.  We check the validity of blocks in at least half a
> dozen different places.  The elaborate ext4_blocktype is to allow for
> future expansion of this checking mechanism to allow it to check for
> blocks overlapping with e.g. the inode table and such, and possibly for
> using with the jbd2 buffer checksum mechanism at some later date.

We do have a helper function that is waiting to be merged in the patch
queue.  See the patch "add-check-block-validity-to-ext4_get_blocks_wrap".  

It doesn't have the blocktype extension, since to keep things fast and
simple, I have a single red-black tree for any blocks that shouldn't
be used for file blocks allows for a *much* more compact
representation in the red-black tree, thanks to flex_bg putting the
block and inode bitmaps and inode tables back-to-back with each other.
If I were to add blocktype information to the red-black tree that
ext4_data_block_valid() could check against, the red-black tree would
at least triple in size.

The nice thing about this patch (which will be merged for 2.6.31) is
that it's a runtime mount option.  So if we have a customer that runs
into problems, we don't have to ship them a custom debugging kernel;
we just tell them to mount the filesystem with block_validity, and we
can start debugging the problem right away.

					- Ted
 
