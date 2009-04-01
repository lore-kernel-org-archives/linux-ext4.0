From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH][TRIVIAL] ext2: fix a typo in ext2.h
Date: Wed, 1 Apr 2009 10:48:14 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0904011047570.2777@wotan.suse.de>
References: <20090330121927.GA2237@lilem.mirepesht>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jack@atrey.karlin.mff.cuni.cz, trivial@kernel.org
To: Ali Gholami Rudi <ali@rudi.ir>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761792AbZDAIse@vger.kernel.org>
In-Reply-To: <20090330121927.GA2237@lilem.mirepesht>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 30 Mar 2009, Ali Gholami Rudi wrote:

> Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
> ---
>  fs/ext2/ext2.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index 3203042..6888b2d 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -27,7 +27,7 @@ struct ext2_inode_info {
>  	/*
>  	 * i_block_group is the number of the block group which contains
>  	 * this file's inode.  Constant across the lifetime of the inode,
> -	 * it is ued for making block allocation decisions - we try to
> +	 * it is used for making block allocation decisions - we try to
>  	 * place a file's data blocks near its inode block, and new inodes
>  	 * near to their parent directory's inode.
>  	 */

Applied to trivial tree, thanks Ali.

-- 
Jiri Kosina
SUSE Labs
