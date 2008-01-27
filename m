From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix commit block write in JBD
Date: Sat, 26 Jan 2008 22:02:07 -0800
Message-ID: <20080126220207.9152ff8b.akpm@linux-foundation.org>
References: <20080123190943.GG10144@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776AbYA0GCp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jan 2008 01:02:45 -0500
In-Reply-To: <20080123190943.GG10144@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, 23 Jan 2008 20:09:43 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> Commit block is expected to have several copies of the header. Fix the
> bug Andrew has spotted ages ago.
> 

"ages" indeed.

> 
> diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
> index 610264b..a69b240 100644
> --- a/fs/jbd/commit.c
> +++ b/fs/jbd/commit.c
> @@ -116,9 +116,8 @@ static int journal_write_commit_record(journal_t *journal,
>  
>  	bh = jh2bh(descriptor);
>  
> -	/* AKPM: buglet - add `i' to tmp! */
>  	for (i = 0; i < bh->b_size; i += 512) {
> -		journal_header_t *tmp = (journal_header_t*)bh->b_data;
> +		journal_header_t *tmp = (journal_header_t*)(bh->b_data+i);
>  		tmp->h_magic = cpu_to_be32(JFS_MAGIC_NUMBER);
>  		tmp->h_blocktype = cpu_to_be32(JFS_COMMIT_BLOCK);
>  		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);

But I don't think we can _use_ this feature now.  Because there are
100000000000 disks out there which didn't implement it.

So why not just remove the loop and do a single write?
