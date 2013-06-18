From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext3,ext4] old bug in htree_dirblock_to_tree()
Date: Tue, 18 Jun 2013 12:01:20 -0400
Message-ID: <20130618160120.GG7359@thunk.org>
References: <20130617152338.GS4165@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130617152338.GS4165@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 17, 2013 at 04:23:38PM +0100, Al Viro wrote:
> 	Both ext3 and ext4 htree_dirblock_to_tree() is just filling
> the in-core rbtree for use by call_filldir().  All updates of
> ->f_pos are done by the latter; bumping it here (on error) is obviously
> wrong - we might very well have it nowhere near the block we'd found
> an error in.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied, thanks.  Nice catch!

Jan, I'll carry the fix for ext3 as well in the ext4 tree, unless
you'd prefer otherwise.

					- Ted
