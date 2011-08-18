From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Thu, 18 Aug 2011 11:54:17 -0700
Message-ID: <CAFgt=MC0NJC9fgGaS7Oe7LTpjDgcN-53Wx7TV-1Q=X3zFv73Ew@mail.gmail.com>
References: <4E48390E.9050102@msgid.tls.msk.ru>
	<4E488625.609@tao.ma>
	<4E48D231.5060807@msgid.tls.msk.ru>
	<4E48DF31.4050603@msgid.tls.msk.ru>
	<CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
	<20110816135325.GD23416@quack.suse.cz>
	<4E4A86D0.2070300@tao.ma>
	<CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
	<4E4AEF13.7070504@msgid.tls.msk.ru>
	<CAFgt=MBMyf=n2GM6iNPdOoBiC2o0PqLSi7yrssHn562K96wn_g@mail.gmail.com>
	<20110817170236.GB6901@thunk.org>
	<4E4CB5F0.6000202@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, Tao Ma <tm@tao.ma>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:28366 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab1HRSyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Aug 2011 14:54:21 -0400
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id p7IIsITJ006185
	for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 11:54:19 -0700
Received: from yia13 (yia13.prod.google.com [10.243.65.13])
	by wpaz17.hot.corp.google.com with ESMTP id p7IIrD6U026646
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 11:54:17 -0700
Received: by yia13 with SMTP id 13so2157524yia.12
        for <linux-ext4@vger.kernel.org>; Thu, 18 Aug 2011 11:54:17 -0700 (PDT)
In-Reply-To: <4E4CB5F0.6000202@msgid.tls.msk.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 17, 2011 at 11:49 PM, Michael Tokarev <mjt@tls.msk.ru> wrot=
e:
> 17.08.2011 21:02, Ted Ts'o wrote:
> []
>> What I'd like to do long-term here is to change things so that (a)
>> instead of instantiating the extent as uninitialized, writing the
>> data, and then doing the uninit->init conversion to writing the data
>> and then instantiated the extent as initialzied. =A0This would also
>> allow us to get rid of data=3Dordered mode. =A0And we should make it=
 work
>> for fs block size !=3D page size.
>>
>> It means that we need a way of adding this sort of information into =
an
>> in-memory extent cache but which isn't saved to disk until the data =
is
>> written. =A0We've also talked about adding the information about whe=
ther
>> an extent is subject to delalloc as well, so we don't have to grovel
>> through the page cache and look at individual buffers attached to th=
e
>> pages. =A0And there are folks who have been experimenting with an
>> in-memory extent tree cache to speed access to fast PCIe-attached
>> flash.
>>
>> It seems to me that if we're careful a single solution should be abl=
e
>> to solve all of these problems...
>
> What about current situation, how do you think - should it be ignored
> for now, having in mind that dioread_nolock isn't used often (but it
> gives _serious_ difference in read speed), or, short term, fix this
> very case which have real-life impact already, while implementing a
> long-term solution?
I plan to send my patch as a bandaid fix. It doesn't solve the fundamen=
tal
problem but I think it helps close the race you saw on your test. In th=
e long
term, I agree that we should think about implementing an extent tree ca=
che
and use it to hold pending uninitialized-to-initialized extent conversi=
ons.

Jiaying

>
> Thank you!
>
> /mjt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
