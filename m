From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix buffer double free in ext4_alloc_branch()
Date: Wed, 11 Jun 2014 09:57:17 -0400
Message-ID: <20140611135717.GA27151@thunk.org>
References: <1402493826-13776-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1402493826-13776-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 11, 2014 at 03:37:06PM +0200, Jan Kara wrote:
> Error recovery in ext4_alloc_branch() calls ext4_forget() even for
> buffer corresponding to indirect block it did not allocate. This leads
> to brelse() being called twice for that buffer (once from ext4_forget()
> and once from cleanup in ext4_ind_map_blocks()) leading to buffer use
> count misaccounting. Eventually (but often much later because there
> are other users of the buffer) we will see messages like:
> VFS: brelse: Trying to free free buffer
> 
> Another manifestation of this problem is an error:
> JBD2 unexpected failure: jbd2_journal_revoke: !buffer_revoked(bh);
> inconsistent data on disk
> 
> The fix is easy - don't forget buffer we did not allocate. Also add an
> explanatory comment because the indexing at ext4_alloc_branch() is
> somewhat subtle.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Nice catch!

I've added a cc: stable@vger.kernel.org tag, and will queue this for
the post-merge window bugfix push.

Thanks,

							- Ted
