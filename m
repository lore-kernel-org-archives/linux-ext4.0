From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Re: 64k Page size + ext3 errors
Date: Mon, 28 Jul 2008 16:44:15 -0700 (PDT)
Message-ID: <802670.26931.qm@web81303.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, sandeen@sandeen.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web81303.mail.mud.yahoo.com ([68.142.199.119]:45080 "HELO
	web81303.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751613AbYG1XoQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2008 19:44:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dan,
=A0 Sure=A0 I will post my driver with some cleanup done.
Thanks,
Marri

----- Original Message ----
=46rom: Dan Williams <dan.j.williams@intel.com>
To: sandeen@sandeen.net
Cc: tirumalareddy marri <tirumalareddymarri@yahoo.com>; linux-raid@vger=
=2Ekernel.org; linux-ext4@vger.kernel.org
Sent: Monday, July 28, 2008 1:04:39 AM
Subject: Re: 64k Page size + ext3 errors

On Sun, Jul 27, 2008 at 6:52 PM,=A0 <sandeen@sandeen.net> wrote:
>> I am using HW accelerated XOR engine for RAID-5 . I am seeing EXT3-f=
s
>> errors when I use 64K page size. When I use 4K page size I don't see=
 any
>> issue. As many of you know, we will get better performance when we s=
tore
>> bigger files like videos.
>
> Do you think it is specific to the filesystem on raid-5?=A0 Have you =
tested
> w/o md?=A0 I'd be a little surprised if the problem is at the raid la=
yer (so
> cc'ing the ext3/4 list), but maybe you tested that already.
>
> Which arch is it, and which kernel?=A0 How big is the filesystem?=A0 =
With full
> geometry information it might be easier for someone to reproduce & de=
bug.
>

Marri, can you post your XOR driver the problem may be there.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
