From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] ext4: fix memory leak in ext4_free_branches
Date: Mon, 10 Jan 2011 16:02:11 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1101101557400.21100@tigran.mtv.corp.google.com>
References: <20110110175234.GD3128@thunk.org> <1294682207-10494-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:48722 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1AKACR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jan 2011 19:02:17 -0500
Received: from hpaq7.eem.corp.google.com (hpaq7.eem.corp.google.com [172.25.149.7])
	by smtp-out.google.com with ESMTP id p0B02GP3012877
	for <linux-ext4@vger.kernel.org>; Mon, 10 Jan 2011 16:02:16 -0800
Received: from iwn40 (iwn40.prod.google.com [10.241.68.104])
	by hpaq7.eem.corp.google.com with ESMTP id p0B02EAV001441
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Jan 2011 16:02:15 -0800
Received: by iwn40 with SMTP id 40so19860757iwn.28
        for <linux-ext4@vger.kernel.org>; Mon, 10 Jan 2011 16:02:14 -0800 (PST)
In-Reply-To: <1294682207-10494-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 10 Jan 2011, Theodore Ts'o wrote:

> Commit 40389687 moved a call to ext4_forget() out of
> ext4_free_branches and let ext4_free_blocks() handle calling
> bforget().  But that change unfortunately did not replace the call to
> ext4_forget() with brelse(), which was needed to drop the in-use count
> of the indirect block's buffer head, which lead to a memory leak when
> deleting files that used indirect blocks.  Fix this.
> 
> Thanks to Hugh Dickins for pointing this out.
> 
> Cc: stable@kernel.org
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Many thanks: I've given that a run with the added debug I'd put in,
and it fixes the problems nicely.  I thought it would be a brelse(bh)
somewhere, but wouldn't dare trust my data to my own guesses of where!

Hugh

> ---
>  fs/ext4/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 84b6162..e80fc51 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4378,6 +4378,7 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
>  					(__le32 *) bh->b_data,
>  					(__le32 *) bh->b_data + addr_per_block,
>  					depth);
> +			brelse(bh);
>  
>  			/*
>  			 * Everything below this this pointer has been
> -- 
> 1.7.3.1
> 
> 
