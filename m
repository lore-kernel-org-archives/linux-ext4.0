From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: transaction batching performance & multi-threaded synchronous
 writers
Date: Mon, 14 Jul 2008 13:26:01 -0400
Message-ID: <487B8C29.3000908@redhat.com>
References: <487B7B9B.3020001@gmail.com> <20080714165858.GA10268@unused.rdu.redhat.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>, jens.axboe@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbYGNR0m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2008 13:26:42 -0400
In-Reply-To: <20080714165858.GA10268@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Josef Bacik wrote:
> On Mon, Jul 14, 2008 at 12:15:23PM -0400, Ric Wheeler wrote:
>   
>> Here is a pointer to the older patch & some results:
>>
>> http://www.spinics.net/lists/linux-fsdevel/msg13121.html
>>
>> I will retry this on some updated kernels, but would not expect to see a 
>> difference since the code has not been changed ;-)
>>
>>     
>
> I've been thinking, the problem with this for slower disks is that with the
> patch I provided we're not really allowing multiple things to be batched, since
> one thread will come up, do the sync and wait for the sync to finish.  In the
> meantime the next thread will come up and do the log_wait_commit() in order to
> let more threads join the transaction, but in the case of fs_mark with only 2
> threads there won't be another one, since the original is waiting for the log to
> commit.  So when the log finishes committing, thread 1 gets woken up to do its
> thing, and thread 2 gets woken up as well, it does its commit and waits for it
> to finish, and thread 2 comes in and gets stuck in log_wait_commit().  So this
> essentially kills the optimization, which is why on faster disks this makes
> everything go better, as the faster disks don't need the original optimization.
>
> So this is what I was thinking about.  Perhaps we track the average time a
> commit takes to occur, and then if the current transaction start time is < than
> the avg commit time we sleep and wait for more things to join the transaction,
> and then we commit.  How does that idea sound?  Thanks,
>
> Josef
>   
I think that this is moving in the right direction. If you think about 
this, we are basically trying to do the same kind of thing that the IO 
scheduler does - anticipate future requests and plug the file system 
level queue for a reasonable bit of time. The problem space is very 
similar - various speed devices and a need to self tune the batching 
dynamically.

It would be great to be able to share the approach (if not the actual 
code) ;-)

ric

