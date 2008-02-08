From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG_ON at mballoc.c:3752
Date: Thu, 07 Feb 2008 21:30:09 -0600
Message-ID: <47ABCCC1.8070103@redhat.com>
References: <20080131140137.GA20780@alice> <20080131154207.GA22201@alice> <20080204060055.GC7494@skywalker> <1202335188.6886.15.camel@norville.austin.ibm.com> <20080207125548.GA8701@skywalker> <1202434248.3840.22.camel@localhost.localdomain> <20080208031408.GA7111@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, Eric Sesterhenn <snakebyte@gmx.de>,
	linux-ext4@vger.kernel.org,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758515AbYBHDa6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2008 22:30:58 -0500
In-Reply-To: <20080208031408.GA7111@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Thu, Feb 07, 2008 at 05:30:48PM -0800, Mingming Cao wrote:
>> On Thu, 2008-02-07 at 18:25 +0530, Aneesh Kumar K.V wrote:
>>
>>> ext4: Don't panic in case of corrupt bitmap
>>>
>>> From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>>
>>> Multiblock allocator was calling BUG_ON in many case if the free and used
>>> blocks count obtained looking at the bitmap is different from what
>>> the allocator internally accounted for. Use ext4_error in such case
>>> and don't panic the system.
>>>
>> There seems a lot of BUG_ON() and BUG() in mballoc code, other than this
>> case. Should it always panic the whole system in those cases? Perhaps
>> replacing with ext4_error() or some cases just WARN_ON is enough.
>>
> 
> I had looked at the BUG_ON in mballoc code and found them very useful
> while stabilizing the mballoc code. It helped to catch wrong usage of
> functions. Most of the BUG_ON are there to make sure we call the API
> with the lock held or the API should not return value greater than 'x'
> Should not call the function with a particular argument as NULL ...etc
> kind of thing. So i would suggest to keep them as such.

Yep - as long as the BUG_ONs are for programming errors, and not things
like memory allocation failures or corrupted disks, I think it's ok.
Not that I've audited them all.  :)

I asked about this early on, and got that answer... I'm reasonably
satisfied with it.

-Eric
