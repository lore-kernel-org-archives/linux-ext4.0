From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: correctly unescape journal data blocks
Date: Mon, 17 Mar 2008 16:38:54 +0100
Message-ID: <20080317153854.GC31183@atrey.karlin.mff.cuni.cz>
References: <1205606985-22645-1-git-send-email-duaneg@dghda.com> <1205606985-22645-2-git-send-email-duaneg@dghda.com> <1205606985-22645-3-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37731 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYCQPiz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 11:38:55 -0400
Content-Disposition: inline
In-Reply-To: <1205606985-22645-3-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Fix a long-standing typo (predating git) that will cause data corruption if a
> journal data block needs unescaping. At the moment the wrong buffer head's data
> is being unescaped.
> 
> To test this case mount a filesystem with data=journal, start creating and
> deleting a bunch of files containing only JBD2_MAGIC_NUMBER (0xc03b3998), then
> pull the plug on the device. Without this patch the files will contain zeros
> instead of the correct data after recovery.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
>  fs/jbd2/recovery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
> index 1464113..5d0405a 100644
> --- a/fs/jbd2/recovery.c
> +++ b/fs/jbd2/recovery.c
> @@ -535,7 +535,7 @@ static int do_one_pass(journal_t *journal,
>  					memcpy(nbh->b_data, obh->b_data,
>  							journal->j_blocksize);
>  					if (flags & JBD2_FLAG_ESCAPE) {
> -						*((__be32 *)bh->b_data) =
> +						*((__be32 *)nbh->b_data) =
>  						cpu_to_be32(JBD2_MAGIC_NUMBER);
>  					}
  Acked-by: Jan Kara <jack@suse.cz>

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
