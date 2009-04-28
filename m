From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] ext4: Remove outdated comment about lock_super()
Date: Tue, 28 Apr 2009 18:13:53 +0200
Message-ID: <20090428161353.GJ21950@atrey.karlin.mff.cuni.cz>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <1240717765-16572-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53859 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZD1QNy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 12:13:54 -0400
Content-Disposition: inline
In-Reply-To: <1240717765-16572-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> ext4_fill_super() is no longer called by read_super(), and it is no
> longer called with the superblock locked.  The
> unlock_super()/lock_super() is no longer present, so this comment is
> entirely superfluous.
  Yes, the comment seems to be out of date.

Acked-by: Jan Kara <jack@suse.cz>

									Honza
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/super.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e20ff9c..e0b0c9f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2806,14 +2806,6 @@ no_journal:
>  		goto failed_mount4;
>  	};
>  
> -	/*
> -	 * akpm: core read_super() calls in here with the superblock locked.
> -	 * That deadlocks, because orphan cleanup needs to lock the superblock
> -	 * in numerous places.  Here we just pop the lock - it's relatively
> -	 * harmless, because we are now ready to accept write_super() requests,
> -	 * and aviro says that's the only reason for hanging onto the
> -	 * superblock lock.
> -	 */
>  	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
>  	ext4_orphan_cleanup(sb, es);
>  	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
> -- 
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
