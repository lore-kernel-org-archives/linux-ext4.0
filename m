From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add mount options in superblock
Date: Tue, 3 Aug 2010 14:31:47 -0400
Message-ID: <20100803183147.GC9453@thunk.org>
References: <1280718904-7590-1-git-send-email-tytso@mit.edu>
 <C270D256-EC9B-4449-9CBA-4C7DD51D0B22@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47562 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262Ab0HCSgS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 14:36:18 -0400
Content-Disposition: inline
In-Reply-To: <C270D256-EC9B-4449-9CBA-4C7DD51D0B22@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 03, 2010 at 11:55:39AM -0600, Andreas Dilger wrote:
> On 2010-08-01, at 21:15, Theodore Ts'o wrote:
> > Allow mount options to be stored in the superblock.  Also add default
> > mount option bits for nobarrier, block_validity, discard, and nodelalloc.
> 
> Don't we already store mount options in s_default_mount_opts?  It
> seems more efficient to store them as binary flags instead of as a
> string.

For mount options that are going to be around for a long time, this
makes sense and it is indeed the preferred mechanism.  The problem is
that if we are adding and removing mount options, perhaps for internal
testing purposes using binary bitfields don't work as well, because
(a) it means we have to synchronize e2fsprogs with the kernel updates,
and (b) once used, it's hard to recycle a binary bit position since
there might be old file systems around.  So the 64 byte character
array is intended to be used as an adjunct for the binary bitfield.

      	 	     	     	   	   - Ted
