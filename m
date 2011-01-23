From: torn5 <torn5@shiftmail.org>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Sun, 23 Jan 2011 19:43:10 +0100
Message-ID: <4D3C76BE.3090908@shiftmail.org>
References: <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
 <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
 <1295620109.22802.1.camel@tybalt>
 <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
 <20110121235641.GM3043@thunk.org> <4D3A2EC6.3020700@shiftmail.org>
 <20110122013415.GN3043@thunk.org> <4D3B03FA.4040604@shiftmail.org>
 <EF21BE9C-2457-4C17-A667-9839E23C58B8@mit.edu>
 <4D3B66AB.6030102@shiftmail.org> <20110123051718.GA3237@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: torn5 <torn5@shiftmail.org>, Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.isti.cnr.it ([194.119.192.4]:4169 "EHLO mx2.isti.cnr.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1AWSoO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Jan 2011 13:44:14 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWZ3JEI21COMKMHX@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Sun, 23 Jan 2011 19:43:16 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWZ3JDZI6OONSC2D@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Sun, 23 Jan 2011 19:43:15 +0100 (MET)
In-reply-to: <20110123051718.GA3237@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/23/2011 06:17 AM, Ted Ts'o wrote:
>
>> that's why a fakefsync mount option would be nice to have.
>>      
> Yes, except the file system developers don't want to take on the moral
> liability of system administrators using such a mount option
> incorrectly.

I understand

> The fsync waits for all data to be sent to disk.  It has to; since we
> can't easily, given the current disk protocols, distinguish between
> the 5 MB of I/O that pertains to file A which is being fsync'ed, but
> not the 20 MB of I/O pertaining to file B which is going on in the
> background.

So it's a queue drain + cache flush, right?

> There is a way, for some newer disk drives, to do what's
> called a FUA (Force Unit Attention) ...
>    

I thought it was possible via the completion notifications from the disk.
AFAIK if a disk is in NCQ mode it will return completion for a command 
only when the write was really delivered to the platters. While in 
non-NCQ mode the disk immediately returns completion and caches the 
write. Is this correct?

Oh ok but that's not the problem, I understand now, the problem is that 
you want to see all 5MB of data delivered to the platters, not only 1 
write command...
So the only way is a queue drain.

So if we want to see faster fsyncs we have to reduce the nr_requests of 
a disk, so that the request_queue is short, right?


There were ideas around for an API for dependencies among BIOs.
e.g. here:
https://lwn.net/Articles/399148/
This would solve the problem of needing a queue drain for an fsync, 
right? Ext4 could make the last BIO of the file being synced to depend 
on all the other BIOs related to the same file, and then wait the NCQ 
completion notification for the last BIO. There wouldn't be a need to to 
drain the queue any more.
At that point it could even make sense to make all fsyncs-related I/O to 
jump at the head of the request_queue, so that fsyncs (hopefully related 
to small amounts of data) could return quickly even when there is a 
large file streaming or copy in the background filling the whole 
request_queue...
Does what I'm saying make sense?
I understand this feature would require major changes in Linux though...


Thank you for all these explanations,
these things really help us ignorant ext4 users understand...

