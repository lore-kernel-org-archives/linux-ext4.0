From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix assertion failure in jbd2_journal_flush()
Date: Fri, 21 Dec 2012 00:16:39 -0500
Message-ID: <20121221051639.GA16958@thunk.org>
References: <1355325462-26757-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355325462-26757-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 12, 2012 at 04:17:42PM +0100, Jan Kara wrote:
> The following race is possible between start_this_handle() and someone
> calling jbd2_journal_flush().
> 
> Process A                              Process B
> start_this_handle().
>   if (journal->j_barrier_count) # false
>   if (!journal->j_running_transaction) { #true
>     read_unlock(&journal->j_state_lock);
>                                        jbd2_journal_lock_updates()
>                                        jbd2_journal_flush()
>                                          write_lock(&journal->j_state_lock);
>                                          if (journal->j_running_transaction) {
>                                            # false
>                                          ... wait for committing trans ...
>                                          write_unlock(&journal->j_state_lock);
>     ...
>     write_lock(&journal->j_state_lock);
>     if (!journal->j_running_transaction) { # true
>       jbd2_get_transaction(journal, new_transaction);
>     write_unlock(&journal->j_state_lock);
>     goto repeat; # eventually blocks on j_barrier_count > 0
>                                          ...
>                                          J_ASSERT(!journal->j_running_transaction);
>                                            # fails
> 
> We fix the race by rechecking j_barrier_count after reacquiring j_state_lock
> in exclusive mode.
> 
> CC: stable@vger.kernel.org
> Reported-by:yjwsignal@empal.com
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
