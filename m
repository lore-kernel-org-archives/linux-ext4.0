From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/32] ext4: clean up ext4_xattr_inode_get()
Date: Wed, 21 Jun 2017 21:58:30 -0400
Message-ID: <20170622015830.x26e5pbmmjj7tmzy@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-11-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-11-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:21PM -0700, Tahsin Erdogan wrote:
> The input and output values of *size parameter are equal on successful
> return from ext4_xattr_inode_get(). On error return, the callers ignore
> the output value so there is no need to update it.
> 
> Also check for NULL return from ext4_bread(). If the actual xattr inode
> size happens to be smaller than the expected size, ext4_bread() may
> return NULL which would indicate data corruption.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
