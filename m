From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6 v7] ext4: fix 1k block bugs
Date: Wed, 07 Sep 2011 11:41:14 -0700
Message-ID: <4E67BACA.4040600@linux.vnet.ibm.com>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com> <20110906045942.GA4059@thunk.org> <4E664C83.2080001@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36447 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1IGSlS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Sep 2011 14:41:18 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p87IHkk0026333
	for <linux-ext4@vger.kernel.org>; Wed, 7 Sep 2011 14:17:46 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p87IfH9N221518
	for <linux-ext4@vger.kernel.org>; Wed, 7 Sep 2011 14:41:18 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p87IfHpM020610
	for <linux-ext4@vger.kernel.org>; Wed, 7 Sep 2011 14:41:17 -0400
In-Reply-To: <4E664C83.2080001@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/06/2011 09:38 AM, Allison Henderson wrote:
> On 09/05/2011 09:59 PM, Ted Ts'o wrote:
>> Allison,
>>
>> Many, many thanks for your work on this patch series!! It's clearly
>> been a very long slog.
>>
>> I've pulled in the first three patches, since I think those are
>> clearly correct at this point. One minor change I've made was I fixed
>> the spelling the flag, which I channged to
>> EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED. (Sorry, but seeing MAPED
>> everywhere was just grating on my nerves. :-)
>>
>> I didn't want to apply your 4th patch in the series since we're
>> planning on reducing the usage of i_mutex in the fs/ext4 code proper,
>> as recommended by Christoph. It wasn't immediately obvious to me
>> whether it was safe to apply any of the patches after #4, so for now
>> I've just merged in the first three, since they clearly fix real
>> problems that show up in xfstests.
>>
>> Can you comment on whether patches #5, #6, and #7 depend on #4?
>>
>> Thanks,
>>
>> - Ted
>
> Hi Ted,
>
> Patches 5 and 6 do not depend on 4, and this set only has 6 patches, so
> no need to worry about patch 7 :) So it is ok to just skip patch 4, I
> will see if I can find another way to solve the race conditions
> Yongqiang pointed out with out the use of i_mutex. Many thanks to you
> too for all the help along the way. :)
>
> Allison Henderson
>

Hi Ted,

I've been working on another way to resolve the punch hole races with 
out i_mutex, and Im starting to think that maybe we're going to need 
another semaphore some where.  Can I ask what the plans are for reducing 
the usage of i_mutex in ext4?  I wasnt sure if someone might already be 
doing this.  Thx!

Allison Henderson

>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

