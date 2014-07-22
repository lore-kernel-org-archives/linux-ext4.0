From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/24] e2fsck: clear i_block if there are too many bad
 block mappings
Date: Tue, 22 Jul 2014 14:59:33 -0400
Message-ID: <20140722185933.GM25291@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225321.31374.48416.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50617 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbaGVUfG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:35:06 -0400
Content-Disposition: inline
In-Reply-To: <20140718225321.31374.48416.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:53:21PM -0700, Darrick J. Wong wrote:
> If there are too many bad block mappings in a file and the user says
> to zap it, erase i_block before clearing the inode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Why is this necessary?  E2fsck will clear i_links_count and set dtime,
so the contents of i_block shouldn't matter, yes?

						- Ted

> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index b696d02..18980f1 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -2329,6 +2329,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
>  	}
>  
>  	if (pb.clear) {
> +		memset(inode->i_block, 0, sizeof(inode->i_block));
>  		e2fsck_clear_inode(ctx, ino, inode, E2F_FLAG_RESTART,
>  				   "check_blocks");
>  		return;
> 
