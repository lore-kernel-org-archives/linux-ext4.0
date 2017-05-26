From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix data corruption with EXT4_GET_BLOCKS_ZERO
Date: Fri, 26 May 2017 17:44:56 -0400
Message-ID: <20170526214456.4dihz6evugpfrlff@thunk.org>
References: <20170525084313.29894-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42866 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948755AbdEZVpC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 26 May 2017 17:45:02 -0400
Content-Disposition: inline
In-Reply-To: <20170525084313.29894-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 25, 2017 at 10:43:13AM +0200, Jan Kara wrote:
> When ext4_map_blocks() is called with EXT4_GET_BLOCKS_ZERO to zero-out
> allocated blocks and these blocks are actually converted from unwritten
> extent the following race can happen:
> 
> CPU0					CPU1
> 
> page fault				page fault
> ...					...
> ext4_map_blocks()
>   ext4_ext_map_blocks()
>     ext4_ext_handle_unwritten_extents()
>       ext4_ext_convert_to_initialized()
> 	- zero out converted extent
> 	ext4_zeroout_es()
> 	  - inserts extent as initialized in status tree
> 
> 					ext4_map_blocks()
> 					  ext4_es_lookup_extent()
> 					    - finds initialized extent
> 					write data
>   ext4_issue_zeroout()
>     - zeroes out new extent overwriting data
> 
> This problem can be reproduced by generic/340 for the fallocated case
> for the last block in the file.
> 
> Fix the problem by avoiding zeroing out the area we are mapping with
> ext4_map_blocks() in ext4_ext_convert_to_initialized(). It is pointless
> to zero out this area in the first place as the caller asked us to
> convert the area to initialized because he is just going to write data
> there before the transaction finishes. To achieve this we delete the
> special case of zeroing out full extent as that will be handled by the
> cases below zeroing only the part of the extent that needs it. We also
> instruct ext4_split_extent() that the middle of extent being split
> contains data so that ext4_split_extent_at() cannot zero out full extent
> in case of ENOSPC.
> 
> CC: stable@vger.kernel.org
> Fixes: 12735f881952c32b31bc4e433768f18489f79ec9
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
