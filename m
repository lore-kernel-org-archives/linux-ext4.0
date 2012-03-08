From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 8 Mar 2012 13:52:08 -0800
Message-ID: <4F592A08.7020806@panasas.com>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com> <4F57F523.3020703@redhat.com> <4F581BF6.8000305@zabbo.net> <20120308155419.GB6777@thunk.org> <20120308180951.GB29510@shiny> <4F59148A.4070001@panasas.com> <20120308212412.GC11861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zab@zabbo.net>,
	Eric Sandeen <sandeen@redhat.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:44356 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab2CHVwY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2012 16:52:24 -0500
In-Reply-To: <20120308212412.GC11861@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/08/2012 01:24 PM, Ted Ts'o wrote:
> On Thu, Mar 08, 2012 at 12:20:26PM -0800, Boaz Harrosh wrote:
>>
>> I have a theory of how we can fix that 2-sec wait, by avoiding writeback of
>> the last n pages of an inode who's mtime is less then 2-sec. This would
>> solve any sequential writer wait penalty, which is Ted's case
> 
> That won't work in general, *unless* 2 seconds is enough time that the
> appending writer is done writing to that particular 4k page and moved
> on to the next 4k block, so nothing touches that page and potentially
> blocks for however long it takes for the queues to drain.
> 

Exactly. Is that not the case for a sequential writer. It modifies
the top page for a while inode time keeps incrementing, then eventually
it advances to the next page, now the before the last page is never
touched again. and can be submitted for writeout.

> Let's take another example, suppose you have a file-backed mmap
> region, and you modify the page, and now let's suppose the process is
> under enough memory pressure that the page cleaner decides to initiate
> writeback of the page.  Now suppose you get unlucky (this is the 1% or
> 0.1% case; remember, 99th or 99.9 percentile latencies matter), and
> you try to modify the page in question again.  ***THUNK*** your
> process takes a page fault, and is frozen solid in amber for
> potentially seconds until the I/O queues drain.
> 

As I said, if the IO is random you are in though luck, and BTW mmap
is not a must, just simple write() call will behave just the same
since it sits in the same mkwrite().

But that was not your case. Your case was an appending logger.

But my new theory is that your case is not the "writeback" to
app-write collision, but the app-write to sync() collision which
is a different case.

> Hmm.... let's turn this around.  If the issue is checksum calculation,
> how about trying to solve this problem in some cases by deferring the
> checksum calculation until right before the block I/O layer is going
> to schedule the write (i.e., have the I/O submitter provide a callback
> function which calculates the checksum, which gets called by the BIO
> layer at the very last moment)?
> 

iscsi is that case, but the problem is not when "calculates the checksum"
but: when "changing page state" your schema can work but you will need to
add a new page state, dirty => writeback => stable (new state).

> This won't work in all cases (I can see this getting really messy in
> the software RAID-5/6 case if you don't want to memory copies) but it
> might solve the problem in at least some of the cases where people
> care about this.
> 
> 					- Ted

Thanks
Boaz
