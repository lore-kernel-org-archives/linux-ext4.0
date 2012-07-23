From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/2] ext4: warn on delalloc md block allocation
 without reservation
Date: Mon, 23 Jul 2012 00:00:11 -0400
Message-ID: <20120723040011.GA17588@thunk.org>
References: <4F79C245.8010101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Brian Foster <bfoster@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40605 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab2GWEAP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2012 00:00:15 -0400
Content-Disposition: inline
In-Reply-To: <4F79C245.8010101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 02, 2012 at 11:14:13AM -0400, Brian Foster wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> If we hit a condition where we have allocated metadata blocks that
> were not appropriately reserved, we risk underflow of
> ei->i_reserved_meta_blocks. In turn, this can throw
> sbi->s_dirtyclusters_counter significantly out of whack and undermine
> the nondelalloc fallback logic in ext4_nonda_switch(). Warn if this
> occurs and fix up the counter to handle only what we've reserved.
> This condition is reproduced by xfstests 270 against ext2 with
> delalloc enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Hi Brian,

Thanks for looking into this xfstests failure and proposing a bug fix.
My apologies for not getting back to you until now.

I modified your commit description a little, but the patch looks good
to me.

  	   	       		    	    - Ted

Author: Brian Foster <bfoster@redhat.com>
Date:   Sun Jul 22 23:59:40 2012 -0400

    ext4: don't let i_reserved_meta_blocks go negative
    
    If we hit a condition where we have allocated metadata blocks that
    were not appropriately reserved, we risk underflow of
    ei->i_reserved_meta_blocks.  In turn, this can throw
    sbi->s_dirtyclusters_counter significantly out of whack and undermine
    the nondelalloc fallback logic in ext4_nonda_switch().  Warn if this
    occurs and set i_allocated_meta_blocks to avoid this problem.
    
    This condition is reproduced by xfstests 270 against ext2 with
    delalloc enabled:
    
    Mar 28 08:58:02 localhost kernel: [  171.526344] EXT4-fs (loop1): delayed blo
    Mar 28 08:58:02 localhost kernel: [  171.526346] EXT4-fs (loop1): This should
    
    270 ultimately fails with an inconsistent filesystem and requires an
    fsck to repair.  The cause of the error is an underflow in
    ext4_da_update_reserve_space() due to an unreserved meta block
    allocation.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@vger.kernel.org

