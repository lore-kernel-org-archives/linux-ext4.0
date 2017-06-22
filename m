From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/32] ext4: fix credits calculation for xattr inode
Date: Wed, 21 Jun 2017 22:19:06 -0400
Message-ID: <20170622021906.dsmb6wts3yjsew6x@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-17-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-17-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:27PM -0700, Tahsin Erdogan wrote:
> When there is no space for a value in xattr block, it may be stored
> in an xattr inode even if the value length is less than
> EXT4_XATTR_MIN_LARGE_EA_SIZE(). So the current assumption in credits
> calculation is wrong.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
