From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] debugfs: update to handle newer inode fields
Date: Sun, 6 Mar 2016 19:54:44 -0500
Message-ID: <20160307005444.GF30238@thunk.org>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
 <1457224716-72388-6-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38412 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbcCGAyr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 19:54:47 -0500
Content-Disposition: inline
In-Reply-To: <1457224716-72388-6-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 05, 2016 at 05:38:36PM -0700, Andreas Dilger wrote:
> Remove the printing of fragment fields that are HURD only, and
> instead print the i_checksum_lo and i_checksum_hi fields.
> 
> Allow setting newer fields in extra inode space with modify_inode.
> 
> Add inode_includes() macro to simplify checking for fields in the
> large inode, rather than hard-coding field offsets in the code.
> 
> Fix corresponding tests for newly added Checksum field.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

This patch changes way too much at one time, and won't apply given
other changes that have been made by Li Xi and myself.

I wouldn't bother adding stuff to modify_inode; that's an old
interface that is extremely awkward to use, and is there because there
might be a few people who might like it.  These days, set_inode_field
is the new interface that is much more flexible and easier to use.

Li Xi has added inode_includes into lib/ext2fs/ext2_fs.h.  I will
probably rename it to ext2fs_inode_includes() just to avoid namespace
collision problems.

Cheers,

						- Ted
