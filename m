From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4/jbd2: Fix jbd2_journal_destory() for umount path
Date: Wed, 9 Mar 2016 23:59:47 -0500
Message-ID: <20160310045947.GD4937@thunk.org>
References: <87fuwh58ro.fsf@mail.parknet.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fuwh58ro.fsf@mail.parknet.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 25, 2016 at 08:28:27PM +0900, OGAWA Hirofumi wrote:
> On umount path, jbd2_journal_destroy() writes latest transaction ID
> (->j_tail_sequence) to be used at next mount.
> 
> The bug is that ->j_tail_sequence is not holding latest transaction ID
> in some cases. So, at next mount, there is chance to conflict with
> remaining (not overwritten yet) transactions.
> 
> 	mount (id=10)
> 	write transaction (id=11)
> 	write transaction (id=12)
> 	umount (id=10) <= the bug doesn't write latest ID
> 
> 	mount (id=10)
> 	write transaction (id=11)
> 	crash
> 
> 	recovery
> 	transaction (id=11)
> 	transaction (id=12) <= valid transaction ID, but old commit
> 	                       must not replay
> 
> Like above, this bug become the cause of recovery failure, or FS
> corruption.
> 
> So why ->j_tail_sequence doesn't point latest ID?
> 
> Because if checkpoint transactions was reclaimed by memory pressure
> (i.e. bdev_try_to_free_page()), then ->j_tail_sequence is not updated.
> (And another case is, __jbd2_journal_clean_checkpoint_list() is called
> with empty transaction.)
> 
> So in above cases, ->j_tail_sequence is not pointing latest
> transaction ID at umount path. Plus, REQ_FLUSH for checkpoint is not
> done too.
> 
> So, to fix this problem with minimum changes, this patch updates
> ->j_tail_sequence, and issue REQ_FLUSH.  (With more complex changes,
> some optimizations would be possible to avoid unnecessary REQ_FLUSH
> for example though.)
> 
> BTW,
> 
> 	journal->j_tail_sequence =
> 		++journal->j_transaction_sequence;
> 
> Increment of ->j_transaction_sequence seems to be unnecessary, but
> ext3 does this.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks, applied.

					- Ted
