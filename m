From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Tue, 13 Nov 2012 16:13:31 -0600
Message-ID: <50A2C60B.1040405@redhat.com>
References: <20120903220213.GE19158@chaosreigns.com> <20120904032919.GJ5066@thunk.org> <20120905024848.GK19158@chaosreigns.com> <20120905033818.GL19158@chaosreigns.com> <87liekovgo.fsf@passepartout.tim-landscheidt.de> <509401E2.30402@redhat.com> <878vajq1g6.fsf@passepartout.tim-landscheidt.de> <50A29161.4060506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab2KMWNc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2012 17:13:32 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qADMDW16025957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Nov 2012 17:13:32 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qADMDV1i019751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Nov 2012 17:13:31 -0500
In-Reply-To: <50A29161.4060506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/13/12 12:28 PM, Eric Sandeen wrote:
> On 11/2/12 1:55 PM, Tim Landscheidt wrote:

...

>>> What does
>>
>>> # debugfs -R "dump_extents <274258>" /dev/dm-4
>>
>>> show? (or whatever the appropriate device node path is)
>>
>> See attachment.
> 
> Level Entries       Logical          Physical Length Flags
>  0/ 1   1/  2     0 -  3665 1114157             3666
>  1/ 1   1/ 59     0 -   132  510721 -  510853    133 
>  1/ 1   2/ 59   133 -   139  511415 -  511421      7 
> ...
>  1/ 1  58/ 59  3039 -  3664  573440 -  574065    626 
>  1/ 1  59/ 59  3665 -  4092  574066 -  574493    428 
>  0/ 1   2/  2  3666 -  9217  395702             5552
>  1/ 1   1/307  4093 -  4093  574494 -  574494      1 
>  1/ 1   2/307  4094 -  4095  395758 -  395759      2 
> ...
> 
> Ok, so the first top-level record says it covers logical 0->3665,
> but the last extent actually goes from 3665->4092.
> 
> Then the next top level extent says it covers 3666->9217,
> but that overlaps w/ the last real extent just prior, and
> the first allocated extent under it actually starts at 4093.
> 
> so,
> a) how'd it get into this state, and
> b) why doesn't fsck care ...
> 
> Looking into that . . .

So this is pre-existing corruption somehow' that 2nd 0-level
record's first logical block should match the first 1st-level
extent's logical block under it.  I was hoping you had just
run into some sort of extent tree traversal bug when looking
up this block, but I think you have an actual corruption in the
extent tree already.

You could work around this by just copying the file then renaming
it back, to get a different (presumably correct) extent tree.
But it'll be hard to work out how it got into this state, I don't
yet see how this can happen.  :(

Does your box wind up crashing or losing power, and replaying the
log once?  I'm wondering if it's possible that an extent tree
metadata update got lost in a crash . . .

-Eric

-Eric
