From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Make barrier messages less scary
Date: Tue, 27 Jul 2010 09:58:23 -0400
Message-ID: <20100727135823.GG18966@thunk.org>
References: <4C4DE515.5020307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56885 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab0G0N6T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 09:58:19 -0400
Content-Disposition: inline
In-Reply-To: <4C4DE515.5020307@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 26, 2010 at 02:42:13PM -0500, Eric Sandeen wrote:
> Saying things like "sync failed" when a device does
> not support barriers makes users slightly more worried than
> they need to be; rather than talking about sync failures,
> let's just state the barrier-based facts.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 75716d3..3d15b28 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -150,8 +150,8 @@ static int journal_submit_commit_record(journal_t *journal,
>  	 */
>  	if (ret == -EOPNOTSUPP && barrier_done) {
>  		printk(KERN_WARNING
> -		       "JBD: barrier-based sync failed on %s - "
> -		       "disabling barriers\n", journal->j_devname);
> +		       "JBD2: Disabling barriers on %s, "
> +		       "not supported by device\n", journal->j_devname);
>  		spin_lock(&journal->j_state_lock);
>  		journal->j_flags &= ~JBD2_BARRIER;
>  		spin_unlock(&journal->j_state_lock);
> @@ -180,8 +180,8 @@ retry:
>  	wait_on_buffer(bh);
>  	if (buffer_eopnotsupp(bh) && (journal->j_flags & JBD2_BARRIER)) {
>  		printk(KERN_WARNING
> -		       "JBD2: wait_on_commit_record: sync failed on %s - "
> -		       "disabling barriers\n", journal->j_devname);
> +		       "JBD2: %s: barriers no longer supported on %s - "
> +		       "disabling barriers\n", __func__, journal->j_devname);

Any reason this message has "no longer supported" as opposed to the
"not supported by device" printed above?

						- Ted
