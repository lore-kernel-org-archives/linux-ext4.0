From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] jbd: Fail to load a journal if it is too short
Date: Tue, 21 Jul 2009 09:19:46 -0700
Message-ID: <20090721091946.06bcdef8.akpm@linux-foundation.org>
References: <1248170659-11771-1-git-send-email-jack@suse.cz>
	<1248170659-11771-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbZGUQUT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 12:20:19 -0400
In-Reply-To: <1248170659-11771-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 21 Jul 2009 12:04:15 +0200 Jan Kara <jack@suse.cz> wrote:

> Due to on disk corruption, it can happen that journal is too short. Fail
> to load it in such case so that we don't oops somewhere later.
> 
> Reported-by: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/jbd/journal.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 737f724..94a64a1 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -848,6 +848,12 @@ static int journal_reset(journal_t *journal)
>  
>  	first = be32_to_cpu(sb->s_first);
>  	last = be32_to_cpu(sb->s_maxlen);
> +	if (first + JFS_MIN_JOURNAL_BLOCKS > last + 1) {
> +		printk(KERN_ERR "JBD: Journal too short (blocks %lu-%lu).\n",
> +		       first, last);
> +		journal_fail_superblock(journal);
> +		return -EINVAL;
> +	}
>  
>  	journal->j_first = first;
>  	journal->j_last = last;

It's odd that sb->s_first/s_maxlen are 32-bit and
journal->j_first/j_last are unsigned long.

These things will only ever be 32-bit unless we change the journal
superblock.
