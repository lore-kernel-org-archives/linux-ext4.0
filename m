From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] jbd2: correctly unescape journal data blocks
Date: Mon, 17 Mar 2008 16:55:13 -0700
Message-ID: <20080317165513.b6522637.akpm@linux-foundation.org>
References: <1205606985-22645-1-git-send-email-duaneg@dghda.com>
	<1205606985-22645-2-git-send-email-duaneg@dghda.com>
	<1205606985-22645-3-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, linux-ext4@vger.kernel.org, duaneg@dghda.com,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbYCQX4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2008 19:56:21 -0400
In-Reply-To: <1205606985-22645-3-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 15 Mar 2008 18:49:45 +0000
"Duane Griffin" <duaneg@dghda.com> wrote:

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
>  

Thanks.  Ted, I'll scoot this into Linus and stable@kernel.org tomorrowish.

