From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 26/32] ext4: cleanup transaction restarts during inode
 deletion
Date: Thu, 22 Jun 2017 11:43:36 -0400
Message-ID: <20170622154336.5ry5lzhw3yv27u4q@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
 <20170622014939.3592-3-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-3-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 06:49:33PM -0700, Tahsin Erdogan wrote:
> During inode deletion, journal credits that will be needed are hard to
> determine, that is why we have journal extend/restart calls in several
> places. Whenever a transaction is restarted, filesystem must be in a
> consistent state because there is no atomicity guarantee beyond a
> restart call.
> 
> Add ext4_xattr_ensure_credits() helper function which takes care of
> journal extend/restart logic. It also handles getting jbd2 write access
> and dirty metadata calls. This function is called at every iteration of
> handling an ea_inode reference.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Applied, thanks.

					- Ted
