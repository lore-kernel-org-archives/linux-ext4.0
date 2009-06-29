From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: ensure validate_entry doesn't read beyond
	blocksize
Date: Mon, 29 Jun 2009 01:27:01 -0400
Message-ID: <20090629052701.GD6802@mit.edu>
References: <687495.40108.qm@web43515.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36929 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZF2F1d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jun 2009 01:27:33 -0400
Content-Disposition: inline
In-Reply-To: <687495.40108.qm@web43515.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 12, 2009 at 09:04:32AM -0700, number9652 wrote:
> 
> ext2fs_validate_entry would read beyond the end of the block to get dirent->rec_len for certain arguments (like if blocksize == final_offset).  This patch adds a check so that doesn't happen, and changes the types of the arguments to avoid a compiler warning.
> 
> Signed-off-by: Nic Case <number9652@yahoo.com>

Applied.  In the future, please line-wrap the body of the commit
message at 72-75 characters.

I also lined up the arguments to ext2fs_validate_entry on the
continuation line, and used a CPP macro instead of an automatic
variable for dirent_min_length.

					- Ted
