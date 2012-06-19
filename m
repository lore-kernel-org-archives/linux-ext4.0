From: Zachary Mark <zmark@cleversafe.com>
Subject: Re: [PATCH 0/2] Re: Discrepancy in 'df' output between kernel 3.0
 and 3.2 for ext4?
Date: Tue, 19 Jun 2012 16:01:06 -0500
Message-ID: <4FE0E892.4090603@cleversafe.com>
References: <4FD8D731.9070008@cleversafe.com> <1340055909-7683-1-git-send-email-tytso@mit.edu> <4FE0D904.7050401@cleversafe.com> <20120619201325.GE22805@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail131.messagelabs.com ([216.82.242.99]:43681 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2FSVBo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2012 17:01:44 -0400
In-Reply-To: <20120619201325.GE22805@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/19/2012 03:13 PM, Ted Ts'o wrote:
> On Tue, Jun 19, 2012 at 02:54:44PM -0500, Zachary Mark wrote:
>>
>> Ted, thanks for the patches!  I've tested your patches against
>> 3.5~rc3.  I had to return the machine on which I first spotted the
>> problem, but here are results from a box with identical hardware:
>>
>> df from 3.0:
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> /dev/sdh1            2907178636    205816 2906972820   1%
>> /dev/sdi1            2907178636   1056768 2906121868   1%
>>
>> df from 3.2.20 (identical to 3.5~rc3 without your patches):
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> /dev/sdh1            2928733612  21760792 2906972820   1%
>> /dev/sdi1            2928733612  22611744 2906121868   1%
>>
>>
>> df from 3.5~rc3 with your patches applied (as they didn't apply to 3.2):
>> /dev/sdh1            2907178636    205816 2906972820   1%
>> /dev/sdi1            2907178636   1060936 2906117700   1%
>>
>> sdh1 is mostly empty.  sdi1 has about 6700 128k files written to it plus
>> everything on sdh1.  There seems to be slightly more overhead accounted
>> for after your patches.  Not sure if this is to be expected or not.
>
> Hmm... it looks like df output /dev/sdh1 is identical between 3.0 and
> 3.5~rc3 with my patches.  I'm not sure why there is a difference for
> /dev/sdi1.  However, I note that the "Available" figure is the same
> between 3.0, 3.2.20 and 3.5~rc3 for /dev/sdh1, but there is a
> difference in the Available column between 3.2.20 and 3.5~rc3 for
> /dev/sdi3.  Could it be that some files got written to /dev/sdi
> between your test run?
>
> It would be good if we could get this sorted out.  I was pretty
> careful to account for all of the fs overhead blocks between when I
> did my patch with an empty file system.
>
> If this can't be accounted by more files being written to /dev/sdi1,
> could you send me the (compressed, since they will be large) output of
> dumpe2fs for /dev/sdh1 and /dev/sdi1 with the "df" output from your
> three test kernel so I can investigate further?
>
> Thanks,
>
> 						- Ted

Actually, you're right, I must have screwed up my original test somehow. 
  I just repeated the test.  The 3.0 and 3.5~rc3-patched numbers are 
identical to each other, and the 3.2.20/3.5~rc3-unpatched are also 
identical to each other.

-- Zach


