From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/32] ext4: change ext4_xattr_inode_iget() signature
Date: Wed, 21 Jun 2017 21:55:46 -0400
Message-ID: <20170622015546.q4okustbh4yyxwjr@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-10-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-10-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:20PM -0700, Tahsin Erdogan wrote:
> In general, kernel functions indicate success/failure through their return
> values. This function returns the status as an output parameter and reserves
> the return value for the inode. Make it follow the general convention.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

The fact that we have several conventions for error passing, is due to
the long history of the ext2/3/4 code base.  In the long term, I'd
actually like to see us gradually move everyhing to use the ERR_PTR
convention.  It's a bit more efficient for the common (no error) case,
and it allows us to drop an extra parameter from the function
signature.

Still, it's incrementally better this way, so thanks, added to the
ext4 patch queue.

					- Ted
