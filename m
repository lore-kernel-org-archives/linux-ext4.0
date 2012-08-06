From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: e2fsck_handle_read_error - pass along
 negative count
Date: Mon, 6 Aug 2012 18:55:17 -0400
Message-ID: <20120806225517.GC30677@thunk.org>
References: <20120806200553.9312.52751.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, ddstreet@us.ibm.com, mcao@us.ibm.com,
	alexfr@il.ibm.com
To: Jim Keniston <jkenisto@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43345 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab2HFWz2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Aug 2012 18:55:28 -0400
Content-Disposition: inline
In-Reply-To: <20120806200553.9312.52751.stgit@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 06, 2012 at 01:05:53PM -0700, Jim Keniston wrote:
> When passed a negative count (indicating a byte count rather than
> a block count) e2fsck_handle_read_error() treats the data as a full
> block, causing unix_write_blk64() (which can handle negative counts
> just fine) to try to write too much.  Given a faulty block device,
> this resulted in a SEGV when unix_write_blk64() read past the bottom
> of the stack copying the data to cache.  (check_backup_super_block ->
> unix_read_blk64 -> raw_read_blk -> e2fsck_handle_read_error)
> 
> Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
> Signed-off-by: Dan Streetman <ddstreet@us.ibm.com>
> Reviewed-by: Mingming Cao <mcao@us.ibm.com>
> Reported-by: Alex Friedman <alexfr@il.ibm.com>

Thanks, applied!  I changed the one-line summary to read:

e2fsck: fix potential segv when handling a read error in a superblock

	    	      	   		 - Ted
