From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Thu, 1 Mar 2012 15:57:50 +0100
Message-ID: <CADDYkjQn-2-XjAZYe6AZeVcNa_A3Jc_qYcOUd3bExBDNWxDMUw@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
	<CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
	<20120229144244.GF5054@shiny>
	<CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
	<CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
	<CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
	<CADDYkjR+d+pFYN-mQ91ZP4KcU4zzwC5jmxj1xxMDrp+X+Z8c6g@mail.gmail.com>
	<20120301141823.GV5054@shiny>
	<CADDYkjRs934T2D7DPCk_dcrazptWtLu70=A61R32p22Ee1iXsw@mail.gmail.com>
	<20120301145155.GY5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Hillf Danton <dhillf@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	lczerner@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34360 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2CAO5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Mar 2012 09:57:52 -0500
In-Reply-To: <20120301145155.GY5054@shiny>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/3/1 Chris Mason <chris.mason@oracle.com>:
> On Thu, Mar 01, 2012 at 03:43:41PM +0100, Jacek Luczak wrote:
>> 2012/3/1 Chris Mason <chris.mason@oracle.com>:
>> > XFS will probably beat btrfs in this test. =A0Their directory inde=
xes
>> > reflect on disk layout very well.
>>
>> True, but not that fast on small files.
>>
>> Except the question I've raised in first mail there's a point in all
>> those action. We are maintaining host that are used for building
>> software: random access, lot of small files and dirs (always a co),
>> heavy parallel IO. We were testing XFS vs ext4 a year ago and XFS wa=
s
>> around 10% slower on build times. We did not - yet - done same on
>> btrfs. Now we're looking for replacement for ext4 as we suffer from
>> those issue - but we were not aware of that until stepped into this
>> issue.
>>
>> If you would like me to do some specific tests around ext4 and btrfs=
,
>> let me know.
>
> I'm always curious to see comparisons in real world workloads. =A0You
> should definitely consider testing XFS again, the big three filesyste=
ms
> are under pretty constant improvement. =A0For btrfs, please stick to =
3.2
> kernels and higher.

That's the plan but I'm waiting for more of the briliant work that
recently popped up in XFS. For btrfs, the 3.2 introduced changes led
me to give here a try. I don't have nice pictures and digits in my
hand now but first tests shown close to 40% of timing improvements
between 2.6.39.4 and 3.2.7 - keep doing that great work guys (and
girls if any)!

-Jacek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
