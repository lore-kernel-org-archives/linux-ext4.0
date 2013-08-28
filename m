From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] jbd2: optimize jbd2_journal_force_commit
Date: Wed, 28 Aug 2013 14:33:40 -0400
Message-ID: <20130828183340.GD27079@thunk.org>
References: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
 <1365966097-8968-2-git-send-email-dmonakhov@openvz.org>
 <20130415122913.GF2299@quack.suse.cz>
 <87vc7lsj0w.fsf@openvz.org>
 <20130418180727.GA14470@quack.suse.cz>
 <87k3nvhtnk.fsf@openvz.org>
 <20130423085140.GB4596@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50769 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab3H1Sdn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 14:33:43 -0400
Content-Disposition: inline
In-Reply-To: <20130423085140.GB4596@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 23, 2013 at 10:51:40AM +0200, Jan Kara wrote:
> > Do you give me your ACK/Reviewed  signature?
>   Looking at it with a fresh mind I think there's still one bug:
>  	read_unlock(&journal->j_state_lock);
>  	if (need_to_start)
> -		jbd2_log_start_commit(journal, tid);
> -	jbd2_log_wait_commit(journal, tid);
> -	return 1;
> +		ret = jbd2_log_start_commit(journal, tid);
> +	if (!ret)
> +		ret = jbd2_log_wait_commit(journal, tid);
>   jbd2_log_start_commit() will return 0 if it didn't wake jbd2 thread and 1
> if it did. In either case we should call jbd2_log_wait_commit()...
> 
> +	if (!ret && progress)
> +		*progress = 1;

I was going through old patch series, and I came across this one.

Dmitry, did you have a chance to look at Jan's comments?  

Thanks,

					- Ted
