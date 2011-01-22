From: torn5 <torn5@shiftmail.org>
Subject: Re: Severe slowdown caused by jbd2 process
Date: Sun, 23 Jan 2011 00:22:19 +0100
Message-ID: <4D3B66AB.6030102@shiftmail.org>
References: <1295568782.2459.29.camel@tybalt>
 <20110121013140.GA8949@dhcp231-156.rdu.redhat.com>
 <1295601083.5799.3.camel@tybalt>
 <20110121125922.GB8949@dhcp231-156.rdu.redhat.com>
 <20110121140306.GA11313@dhcp231-156.rdu.redhat.com>
 <1295620109.22802.1.camel@tybalt>
 <20110121143145.GB11313@dhcp231-156.rdu.redhat.com>
 <20110121235641.GM3043@thunk.org> <4D3A2EC6.3020700@shiftmail.org>
 <20110122013415.GN3043@thunk.org> <4D3B03FA.4040604@shiftmail.org>
 <EF21BE9C-2457-4C17-A667-9839E23C58B8@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: torn5 <torn5@shiftmail.org>, Josef Bacik <josef@redhat.com>,
	Jon Leighton <j@jonathanleighton.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:50577 "EHLO
	BLADE3.ISTI.CNR.IT" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1AVXWk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jan 2011 18:22:40 -0500
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWXZ05478WOMKFEU@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Sun, 23 Jan 2011 00:22:25 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it
 (PMDF V6.5-x5 #31825) id <01NWXZ044FA8ONS9EA@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Sun, 23 Jan 2011 00:22:23 +0100 (MET)
In-reply-to: <EF21BE9C-2457-4C17-A667-9839E23C58B8@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/22/2011 08:37 PM, Theodore Tso wrote:
> On Jan 22, 2011, at 11:21 AM, torn5 wrote:
>> Is the fsync in a nobarrier mount totally swallowed?
>>      
> No.   It will still cause a journal commit, and send disk writes down to the HDD.   How those disk writes will be interpreted by the HDD is completely up to the HDD's firmware.
...
>> If not:
>> a) what guarantees does it provide in a nobarrier situation and
>>      
> As long as there is not a power failure (or disk failure, of couse), those disk writes will eventually hit the platter. ....

VERY interesting
thanks for the explanation

>> b) is there a "fakefsync" mount option or some other way to make it a no-op? (I understand the risk, and the fact that this is actually a change in the application's logic)
>>      
> No, sorry.   Usually the fsync is there for a good reason, and if fsync's are completely eliminated, you have absolutely no guarantees at all.   (Kernel panics, reset buttons, etc., all will cause the database to be totally scrambled.)   Providing such a knob to system administrators who might use it to "speed up" their application, is considered a bit of an attractive nuisance
>    

Sometimes it's useful, and that's the reason why Postgresql and Mysql 
both have a no-fsync mode.
Sometimes you have to do something for which intermediate state doesn't 
matter. Think at it as a computation: if it fails, you restart it from 
the beginning. In scientific research this is often the case. Often to 
save time you use software already written, which might have an 
excessively conservative behaviour for a "computation" , and this slows 
down your computation. But rewriting such application is simply too 
much, so you end up waiting patiently... that's why a fakefsync mount 
option would be nice to have.

Anyway, you said fsyncs in nobarriers mode (only?) generate a journal 
commit and push writes to the HDD.
Then if I also disable the journal the only thing that remains is the 
push of data to the HDD, right?
This is near to a no-op I would say because data should have gone to the 
disks earlier or later... Ow... oh no, it's not, because you wait for 
the disk to return a completion and in the meanwhile you cannot use the 
CPU. Right? Ok so for a single threaded app there is indeed difference.

May I ask how is this "push of data to the disk" implemented: does it 
skip the request queue for the disk (i.e. jumps ahead of the queue), or 
has other kinds of special priority, or it is submitted to the tail like 
normal and the fysnc waits patiently for it to reach the disk?

Thank you for all these explanations
