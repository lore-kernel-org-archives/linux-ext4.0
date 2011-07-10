From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_free_blocks() fix
Date: Sun, 10 Jul 2011 19:39:40 -0400
Message-ID: <20110710233940.GA28763@thunk.org>
References: <1307700474-25743-1-git-send-email-maxim.patlasov@gmail.com>
 <BANLkTinZ5Lw0R9Nf1Un_gEA8DZqo7y15TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Maxim Patlasov <maxim.patlasov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41454 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab1GJXjq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 19:39:46 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTinZ5Lw0R9Nf1Un_gEA8DZqo7y15TA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied to the ext4 tree, with the following changes:

1)  I made the one-line summary clearer:

    ext4: fix i_blocks/quota accounting when extent insertion fails

2) I used the flag name EXT4_FREE_BLOCKS_NO_QUOT_UPDATE which was
clearer than "..._SKIP_QUPD".

Apologies for the delay in getting back to you, and thanks for the
patch.

	      	  	   	   	   - Ted

On Fri, Jun 10, 2011 at 02:17:30PM +0400, Maxim Patlasov wrote:
> I apologise for flooding, patch description in former email was for
> slightly different kernel version. Correct description is below:
> 
> Existent implementation of ext4_free_blocks() always calls dquot_free_block
> This looks quite sensible in the most cases: blocks to be freed are associated
> with inode and were accounted in quota and i_blocks some time ago.
> 
> However, there is a case when blocks to free were not accounted by the time
> calling ext4_free_blocks() yet:
> 
> 1. delalloc is on, write_begin pre-allocated some space in quota
> 2. write-back happens, ext4 allocates some blocks in ext4_ext_map_blocks()
> 3. then ext4_ext_map_blocks() gets an error (e.g.  ENOSPC) from
>    ext4_ext_insert_extent() and calls ext4_free_blocks().
> 
> In this scenario, ext4_free_blocks() calls dquot_free_block() who, in turn,
> decrements i_blocks for blocks which were not accounted yet (due to delalloc)
> After clean umount, e2fsck reports something like:
> 
> > Inode 21, i_blocks is 5080, should be 5128.  Fix<y>?
> because i_blocks was erroneously decremented as explained above.
> 
> The patch fixes the problem by passing EXT4_FREE_BLOCKS_SKIP_QUPD flag to
> ext4_free_blocks(). This flag forces ext4_free_blocks() to skip
> dquot_free_block() call.
> 
> Signed-off-by: Maxim Patlasov <maxim.patlasov@gmail.com>
