From: torn5 <torn5@shiftmail.org>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Sat, 22 Jan 2011 02:11:34 +0100
Message-ID: <4D3A2EC6.3020700@shiftmail.org>
References: <1295568782.2459.29.camel@tybalt>
 <20110121013140.GA8949@dhcp231-156.rdu.redhat.com>
 <1295601083.5799.3.camel@tybalt>
 <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
 <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
 <1295620109.22802.1.camel@tybalt>
 <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
 <20110121235641.GM3043@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:54772 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1AVBND (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jan 2011 20:13:03 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWWOJ86EHSOMK4KG@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Sat, 22 Jan 2011 02:11:41 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWWOJ75RK0ONS4LJ@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Sat, 22 Jan 2011 02:11:37 +0100 (MET)
In-reply-to: <20110121235641.GM3043@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 01/22/2011 12:56 AM, Ted Ts'o wrote:
> On Fri, Jan 21, 2011 at 09:31:45AM -0500, Josef Bacik wrote:
>    
>> Yup, whatever you are doing in your webapp is making your database do lots of
>> fsyncs, which is going to suck.  If you are on a battery backed system or just
>> don't care if you lose your database and rather it be faster you can mount your
>> ext4 fs with -o nobarrier.  Thanks,
>>      
> Note that if you don't use -o barrier on ext3, or use -o nobarrier on
> ext4, the chance of significant file system damage if you have a power
> failure, since without the barrier, the file system doesn't wait for
> disk to acknowledge that the data has hit the barrier.  The problem is
> that if you are using a barrier operation, you're not going to be able
> to get more than about 30-50 non-trivial[1] fsync's per second on a
> standard HDD; barriers are inherently slow.
>    

I think that currently the fsyncs have a double meaning: they are used 
to make a filesystem operation happen before another filesystem 
operation, and to make a filesystem operation happen before a network 
operation. I don't think the second case can be speeded up (there can be 
a distributed transaction involved) but the first could probably be 
speeded up, but I'm thinking how...

Do you think nobarrier + data=journal would provide the same guarantees 
of barrier and almost the same performances of nobarrier (for random I/O)?

Hmm maybe you need the barriers enabled to make even data=journal work 
reliably?
But then there should be a mount option (barriersonlyjournal?) so that 
barriers are only generated every so many seconds and only for 
committing a big transaction to the journal, while applications' fsyncs 
would be made with nobarriers.
This should provide the benefits I mentioned, for disk-to-disk 
sequentiality (not disk-to-network), shouldn't it?


