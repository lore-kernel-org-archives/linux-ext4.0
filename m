From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: Fix delalloc enospace handling counter update
	race
Date: Mon, 14 Jul 2008 14:05:06 -0400
Message-ID: <20080714180505.GA8886@mit.edu>
References: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org> <20080714010828.GD7938@mit.edu> <1216052897.7937.1.camel@mingming-laptop> <20080714165324.GA3545@skywalker> <1216058076.6468.11.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54914 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751250AbYGNSFN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 14:05:13 -0400
Content-Disposition: inline
In-Reply-To: <1216058076.6468.11.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 10:54:36AM -0700, Mingming Cao wrote:
> Updated patch with only the first race fix, 
> 
> If no objection I will fold this to the parent patch
> delalloc-ext4-ENOSPC-handling.patch in the patch queue.

If you're going to fold this to the parent patch (which makes sense),
the following grammatical correction won't be necessary, but here are
some mostly verb tense fixups.

> Ext4: Fix delalloc enospace handling counter update race
> 
> From: Mingming Cao <cmm@us.ibm.com>
> 
> Ext4 delalloc reserve meta blocks ahead of time so later when real block
                reserves
> allocation fs will not short of free blocks for allocating meta blocks.
  	        "will not run out"
> It keeps track of the real number of new allocated meta data blocks, so
     	   	    	     	       newly                          and
> after block allocation it will update how much meta data blocks still
                            updates
> need to be reserved for that inode.
> 
> Both per inode reserved metadata blocks and per-allocation allocated metablocks
> are protected by the per inode delalloc reservation lock. The per-allocation
> allocated metablocks counter should be protected by the i_data_sem as well,
> so that it could avoid race with other block allocation to the same inode
  to avoid racing with ther block allocations
> in parallel. The patch moves the code under the i_data_sem protection.

Please feel free to add a

       Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

to the patch.

     	       	   	       	   	      - Ted
