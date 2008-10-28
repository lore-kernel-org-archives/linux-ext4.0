From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: general protection fault:  from release_blocks_on_commit
Date: Mon, 27 Oct 2008 19:08:37 -0500
Message-ID: <49065805.1080303@redhat.com>
References: <1224612181.19719.20.camel@paris-laptop> <20081027181928.GB23111@mit.edu> <49064027.9010509@redhat.com> <20081027232843.GA9797@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYJ1AJR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Oct 2008 20:09:17 -0400
In-Reply-To: <20081027232843.GA9797@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Oct 27, 2008 at 05:26:47PM -0500, Eric Sandeen wrote:
>> Ted, you probably need some slab debugging on to hit it.
> 
> I had slab debugging enabled, but haven't been able to replicate it
> yet.  I'll do some more work to try to replicate it.
> 
>> I think the problem is that jbd2_journal_commit_transaction may call
>> __jbd2_journal_drop_transaction(journal, commit_transaction) if the
>> checkpoint lists are NULL, and this frees the commit_transaction.
> 
> I think you're right.  I would probably change the patch around so
> that after calling __jbd2_jurnal_drop_transaction(), we set
> commit_transaction to NULL, and then adding an "if
> (commit_transaction)" to the lines in questions; that way we keep the
> commit callback outside of the j_list_lock() spinlock.

Ok, I thought about that; sounds good.  will resend.

>> Also, I'm not certain that it matters, but the loop in 
>> release_blocks_on_commit() is kfreeing list entries w/o taking
>> them off the list; I suppose maybe this is safe if the whole thing
>> is getting discarded when we're done, but just to keep things sane,
>> would this make sense
> 
> There are plenty of other loops in the kernel where we go through the
> linked list and free all of the items on the list that don't bother to
> call list_del().  That was one of the things I checked when I created
> the patch.

Ok.

>> (also, I think we need to double-check use of
>> s_md_lock; it's taken when adding things to the list, but not when
>> freeing/removing ... if it's needed, isn't it needed on both ends...):
> 
> No, because the linked list is hanging off the transaction structure.
> While the transaction is active, multiple CPU's can be adding elements
> to the linked list.  But once the transaction has been committed, we
> don't have to worry about any one else trying to modify the linked list.
> 
>       	      	    	      	       	      - Ted

ok, just double checking.

Thanks,
-Eric
