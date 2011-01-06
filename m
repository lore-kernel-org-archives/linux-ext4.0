From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] ext4: Dynamically allocate the jbd2_inode in
 ext4_inode_info as necessary
Date: Thu, 6 Jan 2011 17:14:04 -0500
Message-ID: <20110106221404.GB2857@thunk.org>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu>
 <1294189270-16733-7-git-send-email-tytso@mit.edu>
 <A562E0CA-9CA6-4654-8FCB-9849F6EB09E7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47449 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab1AFWO0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jan 2011 17:14:26 -0500
Content-Disposition: inline
In-Reply-To: <A562E0CA-9CA6-4654-8FCB-9849F6EB09E7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 05, 2011 at 12:26:33PM -0700, Andreas Dilger wrote:
> In fact, the only callsites of this function are protected with:
> 
> 	if (ext4_should_order_data(inode))
> 		ext4_begin_ordered_truncate(inode, size)
> 
> which will skip the call to ext4_begin_ordered_truncate() if the
> filesystem is running in no-journal mode (EXT4_JOURNAL(inode) ==
> NULL)).  That means the only reason this function could be called
> with jinode == NULL is due to memory corruption, and it makes sense
> to replace this with:

While it's true all of the callers of this function are protected with
ext4_should_order_data(), this function can be called by unlink(), and
if the file hasn't been opened for write, jinode will be NULL.  So
returning if jinode is NULL is in fact the right thing to do.

	     	       	       	  - Ted
