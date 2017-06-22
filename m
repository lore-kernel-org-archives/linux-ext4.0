From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 28/32] quota: add get_inode_usage callback to transfer
 multi-inode charges
Date: Thu, 22 Jun 2017 11:47:37 -0400
Message-ID: <20170622154737.avhrwgasrjej7tez@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
 <20170622014939.3592-5-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-5-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 06:49:35PM -0700, Tahsin Erdogan wrote:
> Ext4 ea_inode feature allows storing xattr values in external inodes to
> be able to store values that are bigger than a block in size. Ext4 also
> has deduplication support for these type of inodes. With deduplication,
> the actual storage waste is eliminated but the users of such inodes are
> still charged full quota for the inodes as if there was no sharing
> happening in the background.
> 
> This design requires ext4 to manually charge the users because the
> inodes are shared.
> 
> An implication of this is that, if someone calls chown on a file that
> has such references we need to transfer the quota for the file and xattr
> inodes. Current dquot_transfer() function implicitly transfers one inode
> charge. With ea_inode feature, we would like to transfer multiple inode
> charges.
> 
> Add get_inode_usage callback which can interrogate the total number of
> inodes that were charged for a given inode.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> Acked-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
