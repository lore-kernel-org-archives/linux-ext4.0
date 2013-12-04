From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mmp: fix 64-bit handling of s_mmp_block
Date: Tue, 3 Dec 2013 20:07:49 -0500
Message-ID: <20131204010749.GA15658@thunk.org>
References: <1376085723-4314-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36223 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3LDBHw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 20:07:52 -0500
Content-Disposition: inline
In-Reply-To: <1376085723-4314-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 09, 2013 at 04:02:03PM -0600, Andreas Dilger wrote:
> Fix the checking of s_mmp_block in e2fsck_pass1() and
> ext2fs_mmp_read() to handle the high 32 bits of s_blocks_count.
> Remove redundant check of s_mmp_block in do_dump_mmp() right before
> ext2fs_mmp_read() is called.
> 
> Also fix s_blocks_count_hi in check_backup_super_block(), since it
> cannot use the ext2fs_blocks_count() helper easily.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.  (Sorry for letting this fall through the cracks for
so long.  Patchwork.ozlabs.org is my friend.  :-)

   	  		       	     	      - Ted
