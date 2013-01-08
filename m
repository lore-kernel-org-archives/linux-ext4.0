From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC] jbd: don't wake kjournald unnecessarily
Date: Tue, 08 Jan 2013 13:19:25 -0600
Message-ID: <50EC713D.6030800@redhat.com>
References: <50D0A1FD.7040203@redhat.com> <20121219012710.GF5987@quack.suse.cz> <20121219020526.GG5987@quack.suse.cz> <50D12FC3.6090209@redhat.com> <20121219081334.GB20163@quack.suse.cz> <20121219153725.GD7795@thunk.org> <20121219171401.GB28042@quack.suse.cz> <20121219202734.GA18804@thunk.org> <50D49606.3020708@redhat.com> <20121221174602.GA31731@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3AHUNJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jan 2013 15:13:09 -0500
In-Reply-To: <20121221174602.GA31731@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/21/12 11:46 AM, Theodore Ts'o wrote:
> On Fri, Dec 21, 2012 at 11:01:58AM -0600, Eric Sandeen wrote:
>>> I'm also really puzzled about how Eric's patch makes a 10% different
>>> on the AIM7 benchmark; as you've pointed out, that will just cause an
>>> extra wakeup of the jbd/jbd2 thread, which should then quickly check
>>> and decide to go back to sleep.
>>
>> Ted, just to double check - is that some wondering aloud, or a NAK
>> of the original patch? :)
> 
> I'm still thinking....  Things that I don't understand worry me, since
> there's a possibility there's more going on than we think.
> 
> Did you have a chance to have your perf people enable the the
> jbd2_run_stats tracepoint, to see how the stats change with and
> without the patch?

Getting back to this; grabbing this over a whole AIM7 run would 
be huge.  I wonder if a few snapshots will be illustrative.
We can try.

> It would be interesting to see how the stats change --- in particular,
> whether the number of blocks logged per transaction is changing,
> and/or the number of blocks per transaction is changing.  It would
> also be interesting to insert a tracepoint in kjournald so we can
> track the number of times when kjournald is waking, but ends up *not*
> triggering a commit due to the commit timeout firing or
> j_commit_sequence != j_commit_request.  

Ok, I think I can do that w/ systemtap.

> I'll probably take the patch on the grounds that it's obvious, but if
> you could get your perf folks to run the experiment, I'd really
> appreciate it, just so we can understand what might be going on.
> Perhaps there's an opportunity for further optimizations, or we'll
> find that something unexpected that is evidence of a bug.  (Or maybe
> it's just a bug in our understanding, but that's also good to get
> fixed.  :-)

I'll see what I can do.

-Eric


> 						- Ted
> 

