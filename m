From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Plans to evaluate the reliability and integrity of ext4 against power failures.
Date: Wed, 01 Jul 2009 15:58:52 -0400
Message-ID: <x49prckw4xv.fsf@segfault.boston.devel.redhat.com>
References: <d1c7fadd0906301627v44fa4a23x6b60726f8ce672c1@mail.gmail.com>
	<f3177b9e0907011107q17507be5icae2c1105faf4800@mail.gmail.com>
	<532480950907011131o7e9fc8bdn64002f130cc9615d@mail.gmail.com>
	<4A4BAEA2.6000101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Rubin <mrubin@google.com>,
	Chris Worley <worleys@gmail.com>,
	Shaozhi Ye <yeshao@google.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42618 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbZGAT6y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jul 2009 15:58:54 -0400
In-Reply-To: <4A4BAEA2.6000101@redhat.com> (Ric Wheeler's message of "Wed, 01
	Jul 2009 14:44:50 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler <rwheeler@redhat.com> writes:

> On 07/01/2009 02:31 PM, Michael Rubin wrote:
>> On Wed, Jul 1, 2009 at 11:07 AM, Chris Worley<worleys@gmail.com>  wrote:
>>    
>>> On Tue, Jun 30, 2009 at 5:27 PM, Shaozhi Ye<yeshao@google.com>  wrote:
>>> This looks like a very valuable project.  I do lack understanding of
>>> how certain problems that very much need to be tested will be tested.
>>>  From your pdf:
>>>
>>>        "Data loss: The client thinks the server has A while the server
>>> does not."
>>>
>>> I've been wondering how you test to assure that data committed to the
>>> disk is really committed?
>>>      
>>
>> What we are trying to capture is what the users perceives and can
>> expect in our environment. This is not an attempt to know the moment
>> the OS can guarantee the data is stored persistently. I am not sure if
>> that's feasible to do with write caching drives today.
>>
>> This experiment's goal as of now is not to know the exact moment in
>> time "when the data is committed". It has two goals. The first to
>> assure ourselves there is no strange corner case making ext4 behave
>> worse or unexpectedly compared to ext2 in the rare event of a power
>> failure. And to deliver expectations to our users on the
>> recoverability of data after the event.
>>    
>
> The key is not to ack the clients request until you have done the best
> effort in moving the data to persistent storage locally.
>
> Today, I think that the best practice would be to either disable the
> write cache on the drive or have properly configured write barrier
> support and use an fsync() on any file before sending the ack back
> over the wire to the client. Note that disabling the write cache is
> required if you use some MD/DM constructs that might not honor barrier
> requests.
>
> Doing this consistently has been shown to significantly reduce the
> data loss due to power failure.
>
>
>> For now we are employing a client server model for network exported
>> sharing in this test. In that context the App doesn't have a lot of
>> methods to know when the data is committed. I know of O_DIRECT, fsync,
>> etc. Given these current day interfaces what can the network client
>> apps expect?
>>    
>
> Isn't this really just proper design of the server component?
>
>> After we have results we will try to figure out if we need to develop
>> new interfaces or methods to improve the situation and hopefully start
>> sending patches.
>>
>>    
>>> I just don't see a method to test this, but it is so critically important.
>>>      
>>
>> I agree.
>>
>> mrubin
>>    
>
> One way to test this with reasonable, commodity hardware would be
> something like the following:
>
> (1) Get an automated power kill setup to control your server
>
> (2) Configure the server with your regular storage stack and one
> local, non-write cache enabled device (could be a normal S-ATA drive
> with write cache disabled)
>
> (3) On receipt of each client request, record with O_DIRECT writes to
> the non-caching device the receipt of the request and the sending of
> the ack back to the client. Getting a really low latency device for
> the recording skews the accuracy of this technique much less of course
> :-)
>
> (4) On the client, record locally its requests and received acks.
>
> (5) At random times, drop power to the server.
>
> Verification would be to replay the client log of received acks &
> validate that the server (after recovery) still has the data that it
> acked over the network.
>
> Wouldn't this suffice to raise the bar to a large degree?

I already have a test app that does something along these lines.  See:

  http://people.redhat.com/jmoyer/dainto-0.99.3.tar.gz

I initially wrote it to try to simulate I/O that leads to torn pages.  I
later reworked it to test to ensure that data that was acknowledged to
the server was actually available after power loss.

The basic idea is that you have a client and a server.  The client
writes blocks to a device (not file system) in ascending order.  As
blocks complete, the block number is sent to the server.  Each block
contains the generation number (which indicates the pass number), the
block number and a crc of the block contents.  When the generation
wraps, it calls out to the generation script provided.  In my case, this
was a script that would delay for a random number of seconds and then
power cycle the client using an ilo fencing agent.  When the client
powers back up, you run the client code in check mode, which pulls its
configuration from the server and then proceeds to ensure that blocks
that were acknowledged as written were, in fact, intact on disk.

Now, I don't remember in what state I left the code.  Feel free to pick
it up and send me questions if you have any.  I'll be on vacation, of
course, but I'll answer when I get back.  ;-)

Cheers,
Jeff
