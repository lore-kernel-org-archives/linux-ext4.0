From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/32] ext4: fix ref counting for ea_inode
Date: Wed, 21 Jun 2017 21:40:40 -0400
Message-ID: <20170622014040.bse3rxjn3cnrxifh@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-8-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-8-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:18PM -0700, Tahsin Erdogan wrote:
> The ref count on ea_inode is incremented by
> ext4_xattr_inode_orphan_add() which is supposed to be decremented by
> ext4_xattr_inode_array_free(). The decrement is conditioned on whether
> the ea_inode is currently on the orphan list. However, the orphan list
> addition only happens when journaling is enabled. In non-journaled case,r
> we fail to release the ref count causing an error message like below.
> 
> "VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.
> Have a nice day..."
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
