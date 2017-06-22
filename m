From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 29/32] ext4: reserve space for xattr entries/names
Date: Thu, 22 Jun 2017 11:49:56 -0400
Message-ID: <20170622154954.aggwvszb3ijgzwel@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
 <20170622014939.3592-6-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60640 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbdFVPt7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Jun 2017 11:49:59 -0400
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-6-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 21, 2017 at 06:49:36PM -0700, Tahsin Erdogan wrote:
> New ea_inode feature allows putting large xattr values into external
> inodes. struct ext4_xattr_entry and the attribute name however have to
> remain in the inode extra space or external attribute block. Once that
> space is exhausted, no further entries can be added. Some of that space
> could also be used by values that fit in there at the time of addition.
> 
> So, a single xattr entry whose value barely fits in the external block
> could prevent further entries being added.
> 
> To mitigate the problem, this patch introduces a notion of reserve in
> the
> external attribute block that cannot be used by value data. This reserve
> is enforced when ea_inode feature is enabled. The amount of reserve is
> arbitrarily chosen to be min(block_size/8, 1024). The table below shows
> how much space is reserved for each block size and the guaranteed
> mininum
> number of entries that can be placed in the external attribute block.
> 
> block size     reserved bytes  entries (name length = 16)
>  1k            128              3
>  2k            256              7
>  4k            512             15
>  8k            1024            31
> 16k            1024            31
> 32k            1024            31
> 64k            1024            31
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
