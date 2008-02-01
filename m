From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: Re: [PATCH 33/49] ext4: Add the journal checksum feature
Date: Sat, 02 Feb 2008 02:20:08 +0530
Message-ID: <1201899008.3417.39.camel@alpha.linsyssoft.com>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <20080123140704.01249f86.akpm@linux-foundation.org>
 <1201209848.4105.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	adilger@clusterfs.com, shaggy@linux.vnet.ibm.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:56506 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYBAUmt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2008 15:42:49 -0500
In-reply-to: <1201209848.4105.14.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, 2008-01-24 at 13:24 -0800, Mingming Cao wrote:
> -static int journal_write_commit_record(journal_t *journal,
> -					transaction_t *commit_transaction)
> +static int journal_submit_commit_record(journal_t *journal,
> +					transaction_t *commit_transaction,
> +					struct buffer_head **cbh,
> +					__u32 crc32_sum)
>  {
>  	struct journal_head *descriptor;
> +	struct commit_header *tmp;
>  	struct buffer_head *bh;
> -	int i, ret;
> +	int ret;
>  	int barrier_done = 0;
>  
>  	if (is_journal_aborted(journal))
> @@ -117,21 +122,33 @@ static int journal_write_commit_record(j
>  
>  	bh = jh2bh(descriptor);
>  
> -	/* AKPM: buglet - add `i' to tmp! */
> -	for (i = 0; i < bh->b_size; i += 512) {
> -		journal_header_t *tmp = (journal_header_t*)bh->b_data;
> -		tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
> -		tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
> -		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
> +	tmp = (struct commit_header *)bh->b_data;
> +	tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
> +	tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
> +	tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
> +
> +	if (JBD2_HAS_COMPAT_FEATURE(journal,
> +				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
> +		tmp->h_chksum_type 	= JBD2_CRC32_CHKSUM;
> +		tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
> +		tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
>  	}
>  
> -	JBUFFER_TRACE(descriptor, "write commit block");
> +	JBUFFER_TRACE(descriptor, "submit commit block");
> +	lock_buffer(bh);
> +
get_bh() is missing here. 
bh refcount is decremented in journal_wait_on_commit_record(), but it is
not incremented in journal_submit_commit_record().
Thanks to Johann Lombardi for pointing this out.

Comments.

>  	set_buffer_dirty(bh);
> -	if (journal->j_flags & JBD2_BARRIER) {
> +	set_buffer_uptodate(bh);
> +	bh->b_end_io = journal_end_buffer_io_sync;
> +
> +	if (journal->j_flags & JBD2_BARRIER &&
> +		!JBD2_HAS_COMPAT_FEATURE(journal,
> +					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
>  		set_buffer_ordered(bh);
>  		barrier_done = 1;
>  	}
> -	ret = sync_dirty_buffer(bh);
> +	ret = submit_bh(WRITE, bh);
> +
>  	/* is it possible for another commit to fail at roughly
>  	 * the same time as this one?  If so, we don't want to
>  	 * trust the barrier flag in the super, but instead want
> @@ -152,14 +169,72 @@ static int journal_write_commit_record(j
>  		clear_buffer_ordered(bh);
>  		set_buffer_uptodate(bh);
>  		set_buffer_dirty(bh);
> -		ret = sync_dirty_buffer(bh);
> +		ret = submit_bh(WRITE, bh);
>  	}
> -	put_bh(bh);		/* One for getblk() */
> -	jbd2_journal_put_journal_head(descriptor);
> +	*cbh = bh;
> +	return ret;
> +}
> +
> +/*
> + * This function along with journal_submit_commit_record
> + * allows to write the commit record asynchronously.
> + */
> +static int journal_wait_on_commit_record(struct buffer_head *bh)
> +{
> +	int ret = 0;
> +
> +	clear_buffer_dirty(bh);
> +	wait_on_buffer(bh);
> +
> +	if (unlikely(!buffer_uptodate(bh)))
> +		ret = -EIO;
> +	put_bh(bh);            /* One for getblk() */
> +	jbd2_journal_put_journal_head(bh2jh(bh));
>  
> -	return (ret == -EIO);
> +	return ret;
>  }
>  
-Girish
