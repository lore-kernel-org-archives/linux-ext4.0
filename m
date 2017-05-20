From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] jbd2: preserve original nofs flag during journal
 restart
Date: Sat, 20 May 2017 00:09:43 -0400
Message-ID: <20170520040943.kf4sy4ssixoz7coo@thunk.org>
References: <20170518093939.GD9084@quack2.suse.cz>
 <20170518162850.7618-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45042 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdETEJs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 20 May 2017 00:09:48 -0400
Content-Disposition: inline
In-Reply-To: <20170518162850.7618-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 18, 2017 at 09:28:50AM -0700, Tahsin Erdogan wrote:
> When a transaction starts, start_this_handle() saves current
> PF_MEMALLOC_NOFS value so that it can be restored at journal stop time.
> Journal restart is a special case that calls start_this_handle() without
> stopping the transaction. start_this_handle() isn't aware that the
> original value is already stored so it overwrites it with current value.
> 
> For instance, a call sequence like below leaves PF_MEMALLOC_NOFS flag set
> at the end:
> 
>   jbd2_journal_start()
>   jbd2__journal_restart()
>   jbd2_journal_stop()
> 
> Make jbd2__journal_restart() restore the original value before calling
> start_this_handle().
> 
> Fixes: 81378da64de6 ("jbd2: mark the transaction context with the scope GFP_NOFS context")
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
