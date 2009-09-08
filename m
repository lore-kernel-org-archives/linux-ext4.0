From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Automatically enable journal_async_commit on
 ext4 file systems
Date: Tue, 08 Sep 2009 07:50:35 -0400
Message-ID: <4AA6450B.9040001@redhat.com>
References: <1252189963-23868-1-git-send-email-tytso@mit.edu> <1252189963-23868-2-git-send-email-tytso@mit.edu> <4AA59A82.9090502@gmail.com> <20090908044541.GF22901@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbZIHLu1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 07:50:27 -0400
In-Reply-To: <20090908044541.GF22901@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/08/2009 12:45 AM, Theodore Tso wrote:
> On Mon, Sep 07, 2009 at 07:42:58PM -0400, Ric Wheeler wrote:
>    
>> I am not sure that we are really good with ASYNC commit being on all of
>> the time - I really worry that we will see lots of issues.
>>      
> There really isn't much difference between async commit and non-async
> commit.  In fact, the name is really a bit of a misnomer at this
> point.
>
> So here's what we do on a non-async commit:
>
> 1)  Write the journal data, revoke, and descriptor blocks
> 2)  Wait for the block I/O layer to signal that all of these blocks
>      have been written out --- *without* a barrier
> 3)  Write the commit block with a barrier
> 4)  Wait for the I/O to commit block to be done
>
> This is what we do with an async commit:
>
> 1)  Write the journal data, revoke, and descriptor blocks
> 2)  Write the commit block (with a checksum) with a barrier
> 3)  Wait for the I/O to in steps (1) and (2) to be done
>
> That's the only difference at this point.  The fatal flaw with async
> commit from before was this that we weren't writing the commit block
> in step (2) with a barrier --- and that *was* disastrous, since it
> meant the equivalent of mounting with barrier=0.
>    

I think that the difference is basically that in the original mode, 
waiting for stage (2) to finish means that our commit block will never 
hit the storage before the dependent data is committed. Remember that 
barriers are actually 2 CACHE_FLUSH_EXT commands - one before the 
flagged barrier IO is issued and one afterwards.

In effect, this means that we have little to no window where our commit 
block could be on persistent storage while we have the commit block on 
platter.

In the second scenario, it sounds like that data that would still be in 
flight is not going to get flushed by those barrier ops?

In any case, I think that we are opening a window here. The checksum 
should flag how often we end up with an invalid state, but I would still 
prefer to see a clear advantage in performance as well as testing (power 
fail, etc) to make sure that we are safe :-)

ric


> But now that it is fixed, this code path does make sense, and given
> that we weren't inserting a barrier between steps 2 and 3, we were in
> fact (theoretically) vulnerable to the commit block and the journal
> blocks getting reordered in 2.6.30 and older kernels.  Turning on the
> journal checksum (in the prior commit) helps solve that issue, but at
> that point, we might as well write the commit block before we start
> waiting on all of the journal blocks.
>
> As far as the code complexity issue concern, it really wasn't that
> complicated, and in fact we're not really changing the existing code
> path that we've been using for over a year now by very much.  The only
> difference in fact is where we call the function to write the commit
> record.
>
> 						- Ted
>    

