From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/32] ext4: improve journal credit handling in set xattr
 paths
Date: Wed, 21 Jun 2017 22:30:21 -0400
Message-ID: <20170622023021.qfwvdb53hg6butan@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-20-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-20-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:30PM -0700, Tahsin Erdogan wrote:
> Both ext4_set_acl() and ext4_set_context() need to be made aware of
> ea_inode feature when it comes to credits calculation.
> 
> Also add a sufficient credits check in ext4_xattr_set_handle() right
> after xattr write lock is grabbed. Original credits calculation is done
> outside the lock so there is a possiblity that the initially calculated
> credits are not sufficient anymore.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
