From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] trivial: fix ext3/ext4 comment typo
 s/compain/complain/
Date: Sun, 17 Jan 2010 22:18:46 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1001172218360.30977@pobox.suse.cz>
References: <1263762607-8996-1-git-send-email-cascardo@holoscopio.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab0AQVSx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jan 2010 16:18:53 -0500
In-Reply-To: <1263762607-8996-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 17 Jan 2010, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  fs/ext3/super.c |    2 +-
>  fs/ext4/super.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index afa2b56..7761c68 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -164,7 +164,7 @@ void ext3_msg(struct super_block *sb, const char *prefix,
>   * write out the superblock safely.
>   *
>   * We'll just use the journal_abort() error code to record an error in
> - * the journal instead.  On recovery, the journal will compain about
> + * the journal instead.  On recovery, the journal will complain about
>   * that error until we've noted it down and cleared it.
>   */
>  
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 735c20d..adcb713 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -302,7 +302,7 @@ void ext4_journal_abort_handle(const char *caller, const char *err_fn,
>   * write out the superblock safely.
>   *
>   * We'll just use the jbd2_journal_abort() error code to record an error in
> - * the journal instead.  On recovery, the journal will compain about
> + * the journal instead.  On recovery, the journal will complain about
>   * that error until we've noted it down and cleared it.
>   */

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
