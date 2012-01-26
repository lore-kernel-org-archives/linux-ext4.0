From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Thu, 26 Jan 2012 15:58:32 -0500
Message-ID: <4F21BE78.3050808@redhat.com>
References: <1325774407-28531-1-git-send-email-jack@suse.cz> <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com> <20120116160136.GC16431@quack.suse.cz> <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com> <20120117003613.GA28571@dastard> <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com> <20120123030422.GE15102@dastard> <20120123214709.GB17974@thunk.org> <20120124003657.GJ15102@dastard> <4F214465.9010600@redhat.com> <20120126205105.GC27283@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, "Ted Ts'o" <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab2AZU7J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jan 2012 15:59:09 -0500
In-Reply-To: <20120126205105.GC27283@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/26/2012 03:51 PM, Jan Kara wrote:
> On Thu 26-01-12 07:17:41, Ric Wheeler wrote:
>> On 01/23/2012 07:36 PM, Dave Chinner wrote:
>>> On Mon, Jan 23, 2012 at 04:47:09PM -0500, Ted Ts'o wrote:
>>>>> The thing is, transient write errors tend to be isolated and go away
>>>>> when a retry occurs (think of IO timeouts when multipath failover
>>>>> occurs). When non-isolated IO or unrecoverable problems occur (e.g.
>>>>> no paths left to fail over onto), critical other metadata reads and
>>>>> writes will fail and shut down the filesystem, thereby terminating
>>>>> the "try forever" background writeback loop those delayed write
>>>>> buffers may be in. So the truth is that "trying forever" on write
>>>>> errors can handle a whole class of write IO errors very
>>>>> effectively....
>>>> So how does XFS decide whether a write should fail and shutdown the
>>>> file system, or just "try forever"?
>>> The IO dispatcher decides that. If the dispatcher has handed the IO
>>> off to the delayed write queue, then failed writes will be tried
>>> again. If the caller is catching the IO completion (e.g. sync
>>> writes) or attaching a completion callback (journal IO), then the
>>> completion context will handle the error appropriately. Journal IO
>>> errors tend to shutdown the filesystem on the first error, other
>>> contexts may handle the error, retry or shutdown the filesystem
>>> depending on their current state when the error occurs.
>>>
>>> Reads are even more complex, because ithe dispatch context can be
>>> within a transaction and the correct error handling is then
>>> dependent on the current state of the transaction....
>> I think that having retry logic at the file system layer is really
>> putting the fix in the wrong place.
>>
>> Specifically, if we have multipath configured under a file system,
>> it is up to the multipath logic to handle the failure (and use
>> another path, retry, etc).  If we see a failed IO further up the
>> stack, it is *really* dead at that point.
>    Yes, that makes sense. Only, if my memory serves well, e.g. with iSCSI we
> do see transient errors so it's not like they don't happen.

iSCSI is "just" a transport for SCSI - you can have multipath enabled for iSCSI 
as well of course :)
>
>> Transient errors on normal drives are also rarely worth re-trying
>> since pretty much all modern storage devices have firmware that will
>> have done exhaustive retries on a failed write. Definitely not worth
>> retrying forever for a normal device.
>    Agreed. But we could still be clever enough to write the data / metadata
> to a different place.

Most storage devices totally lie to you about the layout, but there is some 
value (like btrfs) in writing things twice to make sure that you can survive a 
single bad sector.  Even in that case, you still want to avoid a re-try of a 
failed IO though.

>
>> At one end of the spectrum, think of a box with dozens of storage
>> devices attached (either via SAN or local S-ATA devices). If we are
>> doing large, streaming writes, we could get a large amount of memory
>> dirtied while writing. If that one device dies and we keep that
>> memory in use for the endless retry loop, we have really cripple the
>> box which still has multiple happy storage devices and file
>> systems....
>    I agree that if we ever decide to keep unwriteable data in memory,
> kernel has to have a way to get rid of this data if it needs to.

I seem to recall having this discussion (LinuxCon Japan?) a few years back.

Ric


