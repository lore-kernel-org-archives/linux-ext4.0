From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Sat, 24 Apr 2010 11:03:27 -0400
Message-ID: <h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>
	 <4BCF4C53.3010608@redhat.com>
	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
	 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
	 <alpine.LFD.2.00.1004230944070.2814@localhost>
	 <w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>
	 <4BD2F69D.7070508@redhat.com>
	 <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>
	 <4BD30393.4050800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:50228 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0DXPD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Apr 2010 11:03:28 -0400
Received: by qyk9 with SMTP id 9so14733613qyk.1
        for <linux-ext4@vger.kernel.org>; Sat, 24 Apr 2010 08:03:27 -0700 (PDT)
In-Reply-To: <4BD30393.4050800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 24, 2010 at 10:43 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> Greg Freemyer wrote:
>> On Sat, Apr 24, 2010 at 9:48 AM, Ric Wheeler <rwheeler@redhat.com> w=
rote:
>>> On 04/24/2010 09:24 AM, Greg Freemyer wrote:
>
> ...
>
>>>> I know I've been arguing against this patch for the single SSD cas=
e
>>>> and I still think that use case should be handled by userspace as
>>>> hdparm/wiper.sh currently does. =A0In particular for those extreme
>>>> scenarios with JBOD SSDs, the user space solution wins because it
>>>> knows how to optimize the trim calls via vectorized ranges in the
>>>> payload.
>>>>
>>> I think that you have missed the broader point. This is not on by d=
efault,
>>> so you can mount without discard and use whatever user space utilit=
y you
>>> like at your discretion.
>>>
>>> ric
>>
>> Ric,
>>
>> I was trying to say the design should be driven by the large discard
>> range use case, not the potentially pathological small discard range
>> use case that would only benefit SSDs.
>>
>> Greg
>
> Bear in mind that this patch makes the discard range requests substan=
tially
> -larger- than what mount -o discard does on ext4 today, in fact that =
was
> a main goal.
>
> If the kernel could assemble vectors of ranges and pass them down, I =
think it
> could be extended to use that as well.
>
> -Eric
>
Eric/Ric,

I was responding to the Lukas latest post which stated:

=3D=3D
And also, currently I am rewriting the patch do use rbtree instead of t=
he
bitmap, because there were some concerns of memory consumption. It is a
question whether or not the rbtree will be more memory friendly.
Generally I think that in most "normal" cases it will, but there are so=
me
extreme scenarios, where the rbtree will be much worse. Any comment on
this ?
=3D=3D

If one optimizes for large discard ranges and ignores the pathological
cases only beneficial to SSDs, then a rbtree wins.

Correct?

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
