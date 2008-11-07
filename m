From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH][BUG] jbd: fix the root cause of "no transactions"	error
 in __log_wait_for_space()
Date: Fri, 07 Nov 2008 12:17:46 +0900
Message-ID: <4913B35A.8080203@jp.fujitsu.com>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com> <20081020160249.ff41f762.akpm@linux-foundation.org> <20081023174101.85b59177.toshi.okajima@jp.fujitsu.com> <20081027142657.2120aa3f.akpm@linux-foundation.org> <49067D03.6080609@jp.fujitsu.com> <20081105131140.7689f048.toshi.okajima@jp.fujitsu.com> <20081105135349.GA22998@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, sct@redhat.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081105135349.GA22998@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted-san,
thank you for your reading my mail.

Theodore Tso wrote:
 > Toshiyuki-san,
 >
 > I authored a patch a few days ago which I am about to push to Linus,
 > since it two people who have reported this problem has confirmed that
 > it solves the problem for them.  That patch can be found here:
 >
 >    http://lkml.org/lkml/2008/11/1/61
I haven't checked it yet. So, I check it now.

 > As you can see, it has a rather different theory about the root cause
 > of the problem; but it makes sense to me, and it has empircally solved
 > the problem.
uh-huh.

 > So I read your proposed description of the root cause of the problem
 > with interest.  If I understand you correctly, your concern is that
 > various functions in jbd2 are cleaning up the memory associated with
 > tracking the transactions, thus leaving potentially leaving
 > journal->j_checkpoint_transactions to be NULL, even though the on-disk
 > tail of the journal hasn't been updated yet in the jbd superblock.
Yes.

 > Your solution to this is to avoid cleaning up the in-memory
 > representation of the transaction until log_do_checkpoint() has a
 > chance to clean it up.
Yes.

 > Your reasoning and your general diagnosis is sound and I agree with
 > your observation.  However, I disagree with your belief that the
 > fundamental problem is that journal->j_free is being left "out of
 > date", and that this is the issue that must be addressed.  This is
 > because your proposed solution of deferring dropping the in-memory
 > transaction structure has a number of disadvantages.  For one, it adds
 > a lot more code complexity; for another, it means that we are tieing
 > up memory until we have a chance to call log_do_checkpoint.
Yes, I have concerned about it, but I thought it simple to release
a checkpoint transaction in log_do_checkpoint() only.
However, I agree that jbd should try to release a checkpoint transaction
  at any places if possible.

 > Therefore, I believe my original strategy of fixing
 > __log_wait_for_space() is the correct one, since it was a change in in
 > that function which introduced the regression in the first place.
OK.

 > However, your insight that the problem is that cleanup_journal_tail()
 > can sometimes free up space even if journal->j_checkpoint_transactions
 > is NULL is very important, and it will be more efficient to try to
 > call cleanup_journal_tail() before trying to wait on the current
 > transaction to finish.
I agree this idea because also it seems to be able to solve the root cause
which I am thinking.

 > So here is my revised patch, which includes your key insight, but
 > which does not make a large number of changes in other parts of the
 > jbd code, and which allows transactions to be dropped as soon as we no
 > longer need to track any buffers associated with them, even though
 > cleanup_journal_tail() hasn't been called yet.
 >
 > 						- Ted

 > jbd: don't give up looking for space so easily in __log_wait_for_space wait
 >
 > From: Theodore Ts'o <tytso@mit.edu>
Your revised patch looks good to me because your new logic is reasonable.

But I think that here need to be changed from "int tid = 0"
into "tid_t tid = 0".
 >  			int chkpt = journal->j_checkpoint_transactions != NULL;
 > +			int tid = 0;
And the bug which you have already known is needed to fix.
("Re: ext3: kernel BUG at fs/jbd/journal.c:412!" you posted
at Thu, 6 Nov 2008 12:13:22 -0500)

I tested your revised patch with the "journal mode", and then I confirmed
that "no transactions" error doesn't happen.
* You know, this error can happen the most easily by the "journal mode" of
   three modes.

P.S.
Another problem can happen with an original kernel plus your revised patch
instead of "no transactions" error.
This problem is the one that I have been working since one month ago.
First patch to try to fix it was posted by me on 17/10/2008 JST.
"[RFC][PATCH] JBD: release checkpoint journal heads through try_to_release_page
when the memory is exhausted"

I found "no transactions" error happen easily with the "journal mode" when
I was fixing this problem. So, I have needed a patch which fixes
"no transactions" error in order to fix it. Because my fix patch enables
journal_heads release more efficiently, and then "no transactions" error can
happen more easily than before by jbd to which my patch is applied on not only
  the "journal mode" but also "ordered mode" or "writeback mode".

I will post the revised patch which fixes this problem later.

Best Regards,
Toshiyuki Okajima

