From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: what happened with dccaf33fa37 "ext4: flush any pending end_io
 requests before DIO" for 3.0?
Date: Sat, 17 Mar 2012 13:31:30 +0400
Message-ID: <4F6459F2.8010403@msgid.tls.msk.ru>
References: <4ED6942F.7070006@msgid.tls.msk.ru> <4F4CBDA1.1080302@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jiaying Zhang <jiayingz@google.com>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:34752 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab2CQJbc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Mar 2012 05:31:32 -0400
In-Reply-To: <4F4CBDA1.1080302@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ping?

Maybe just a one-line reply isn't THAT difficult?

We've a data corruption bug in current longterm stable kernel
series which is known and has a fix and tagged for -stable for
over half a year already...

Thanks,

/mjt

On 28.02.2012 15:42, Michael Tokarev wrote:
> Is there something wrong with my question?  I asked it 1.5 months ago...
> 
> Meanwhile, we're using this patch on our database server since
> Aug-2011, and it appears to work correctly - direct and buffered
> I/O works together without surprizes.  Without this patch, I see
> unexpected results.
> 
> Thanks,
> 
> /mjt
> 
> On 01.12.2011 00:38, Michael Tokarev wrote:
>> Hello.
>>
>> Back in August 2011, a commit has been tagged to be included
>> into stable, this one:
>>
>> commit dccaf33fa37a1bc5d651baeb3bfeb6becb86597b
>> Author: Jiaying Zhang <jiayingz@google.com>
>> Date:   Fri Aug 19 19:13:32 2011 -0400
>>
>>     ext4: flush any pending end_io requests before DIO reads w/dioread_nolock
>>
>>     There is a race between ext4 buffer write and direct_IO read with
>>     dioread_nolock mount option enabled. The problem is that we clear
>>     PageWriteback flag during end_io time but will do
>>     uninitialized-to-initialized extent conversion later with dioread_nolock.
>>     If an O_direct read request comes in during this period, ext4 will return
>>     zero instead of the recently written data.
>>
>>     This patch checks whether there are any pending uninitialized-to-initialized
>>     extent conversion requests before doing O_direct read to close the race.
>>     Note that this is just a bandaid fix. The fundamental issue is that we
>>     clear PageWriteback flag before we really complete an IO, which is
>>     problem-prone. To fix the fundamental issue, we may need to implement an
>>     extent tree cache that we can use to look up pending to-be-converted extents.
>>
>>     Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>     Cc: stable@kernel.org
>>
>>
>> There was one more ext4 commit at that time, which made its way into
>> stable but this one did not.
>>
>> I wonder if the reason for that was the fact that it needed a small
>> "backport" for 3.0, since in 3.1+ the code has been moved into another
>> file, and the context is slightly different.  In that case, attached
>> is the "backport" which we use with 3.0.x since that time.
>>
>> Thanks!
>>
>> /mjt
> 

