From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
	(EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Mon, 8 Mar 2010 11:31:49 -0500
Message-ID: <87f94c371003080831n4d310e10i2b9badf4290f1ede@mail.gmail.com>
References: <201003072132.10579.borntraeger@de.ibm.com>
	 <4B94367E.9080506@garzik.org>
	 <201003080853.42978.borntraeger@de.ibm.com>
	 <4B9518DA.8010201@davidnewall.com> <4B952437.8020607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Newall <davidn@davidnewall.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: jim owens <owens6336@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57871 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0CHQbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Mar 2010 11:31:50 -0500
In-Reply-To: <4B952437.8020607@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 8, 2010 at 11:22 AM, jim owens <owens6336@gmail.com> wrote:
> David Newall wrote:
>> Christian Borntraeger wrote:
>>> Some bigger things are missing in the e4defrag tool:
>>> ...
>>> - overall layout considerations (e.g. putting files close to its
>>> directory or
>>> =A0 use the atime to move often used files to the beginning of a di=
sk etc.)
>>
>> Shouldn't oft-used files be placed closer to the middle? =A0If you p=
lace
>> them at the beginning of the file, it's only possible for the head-s=
tack
>> to be close to the file from the inner direction. =A0Place them in t=
he
>> middle and it's possible for the head-stack to be close from the out=
er
>> direction, too, which sounds like a doubling of probability. =A0It s=
eems
>> that it's the least frequently used files that should be placed at o=
ne
>> end of the disk or the other.
>
> No. =A0Your logic would be correct if rotating disks had
> similar speed at all locations. =A0Current disks are much
> faster at the 0 end than at the middle or highest address.
>
> It is not unusual to see 2x difference in transfer speed
> so you always want the important stuff as low as possible.
>
> jim

Jim, I should know this, but is sector 0 on the outside edge, or the in=
ner edge?

I assume outer so that the linear speed of the platter under the head
is faster and thus more data per second is passing under the head.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
