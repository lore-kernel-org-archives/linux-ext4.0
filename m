From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Sat, 24 Apr 2010 09:43:31 -0500
Message-ID: <4BD30393.4050800@redhat.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>	 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>	 <4BCF4C53.3010608@redhat.com>	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>	 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>	 <alpine.LFD.2.00.1004230944070.2814@localhost>	 <w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>	 <4BD2F69D.7070508@redhat.com> <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab0DXOnn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Apr 2010 10:43:43 -0400
In-Reply-To: <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg Freemyer wrote:
> On Sat, Apr 24, 2010 at 9:48 AM, Ric Wheeler <rwheeler@redhat.com> wrote:
>> On 04/24/2010 09:24 AM, Greg Freemyer wrote:

...

>>> I know I've been arguing against this patch for the single SSD case
>>> and I still think that use case should be handled by userspace as
>>> hdparm/wiper.sh currently does.  In particular for those extreme
>>> scenarios with JBOD SSDs, the user space solution wins because it
>>> knows how to optimize the trim calls via vectorized ranges in the
>>> payload.
>>>
>> I think that you have missed the broader point. This is not on by default,
>> so you can mount without discard and use whatever user space utility you
>> like at your discretion.
>>
>> ric
> 
> Ric,
> 
> I was trying to say the design should be driven by the large discard
> range use case, not the potentially pathological small discard range
> use case that would only benefit SSDs.
> 
> Greg

Bear in mind that this patch makes the discard range requests substantially
-larger- than what mount -o discard does on ext4 today, in fact that was
a main goal.

If the kernel could assemble vectors of ranges and pass them down, I think it
could be extended to use that as well.

-Eric
