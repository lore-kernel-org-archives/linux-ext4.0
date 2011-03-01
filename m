From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: ext2/3/4: punch support?
Date: Tue, 1 Mar 2011 09:27:40 +0800
Message-ID: <AANLkTimntcYVCyVo3-GRhFKd2eCbBpRan4G8+hLSRyLZ@mail.gmail.com>
References: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com>
	<20110228131118.GA18193@dhcp231-156.rdu.redhat.com>
	<AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
	<4D6BBCA2.8030104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Josef Bacik <josef@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41250 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1CAB1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Feb 2011 20:27:42 -0500
In-Reply-To: <4D6BBCA2.8030104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 28, 2011 at 11:17 PM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> On 2/28/11 8:29 AM, Dave Young wrote:
>> On Mon, Feb 28, 2011 at 9:11 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>>> On Mon, Feb 28, 2011 at 03:03:40PM +0800, Dave Young wrote:
>>>> Hi, josef and ext guys
>>>>
>>>> Do you have any plan with ext4 hole punching support? And the
>>>> fallocate for ext2/3?
>>>>
>>>> What's the obstacle to work on this? could someone tell the status=
 of
>>>> this issue?
>>>
>>> There is no obstacle, just nobody has bothered to do it. =C2=A0If y=
ou want to do it
>>> go for it. =C2=A0Thanks,
>>
>> Yes, I want to do some kvm image space discard stuff,
>> I use ext4 as my filesystem, but currently only xfs support somethin=
g
>> like trim/discard.
>
> As Lukas said, ext4 & ext3 support various forms of trim/discard alre=
ady.
>
> But that's different from punch...

Lukas and Eric, thanks for pointing out, I think I means punch,
although trim/discard is
useful as well in guest side.

>
> And as for fallocate on ext3, you need somewhere to put the metadata =
to indicate a block is allocated but not written. =C2=A0This was a lot =
more straightforward for ext4, since it describes a large range of bloc=
ks with a single extent structure.

As for ext3 fallocate, I found some interesting discuss:
http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg02371.html

Andrew, do you know what's the status of above issue?

>
> -Eric
>
>> I know general knowledge about ext filesystem, but nearly new to ext=
4 code,
>> could you give some hint where to start?
>>
>> --
>> Thanks
>> dave
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>



--=20
Regards
dave
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
