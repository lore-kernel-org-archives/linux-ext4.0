From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 24/51] ext3: wait on all pending commits in ext3_sync_fs
Date: Thu, 6 Nov 2008 14:20:20 -0800
Message-ID: <20081106142020.b64dee83.akpm@linux-foundation.org>
References: <200811062053.mA6KratV013440@imap1.linux-foundation.org>
	<20081106214431.GL18939@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbYKFWVN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 17:21:13 -0500
In-Reply-To: <20081106214431.GL18939@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 6 Nov 2008 16:44:31 -0500
Theodore Tso <tytso@mit.edu> wrote:

> My version of this patch also cleaned up the following comment, which
> has been wrong since 2.5.70 or thereabouts...

oh, I didn't spot that.

I looked at the version in linux-next and saw that it was propagating
the error value back to the VFS as well.  Or maybe that was done in a
separate patch, dunno.  But while that's a good change, I felt that we
should separate it from this bugfix.  I meant to mention it but I
forgot, sorry.
 
> This isn't urgent, so could you just queue this up for the next merge
> window in the -mm tree?
> 
> 						- Ted
> 
> ext3: Clean up outdated and incorrect comment for ext3_write_super()
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: <linux-ext4@vger.kernel.org>
> ---
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index e5717a4..296c044 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2375,12 +2375,9 @@ int ext3_force_commit(struct super_block *sb)
>  /*
>   * Ext3 always journals updates to the superblock itself, so we don't
>   * have to propagate any other updates to the superblock on disk at this
> - * point.  Just start an async writeback to get the buffers on their way
> - * to the disk.
> - *
> - * This implicitly triggers the writebehind on sync().
> + * point.  (We can probably nuke this function altogether, and remove
> + * any mention to sb->s_dirt in all of fs/ext3; eventual cleanup...)
>   */
> -
>  static void ext3_write_super (struct super_block * sb)
>  {
>  	if (mutex_trylock(&sb->s_lock) != 0)

Sure.
