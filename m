From: "Michal Nazarewicz" <mina86@mina86.com>
Subject: Re: [PATCH 01/18] Added hacking menu for override optimization by
 GCC.
Date: Thu, 16 Feb 2012 15:11:30 -0800
Message-ID: <op.v9sn1gld3l0zgt@mpn-glaptop>
References: <1329402705-25454-1-git-send-email-mail@smogura.eu>
 <op.v9sctsrj3l0zgt@mpn-glaptop>
 <76ede790fcc4ab73f969761034554e92@rsmogura.net>
 <op.v9skpfhq3l0zgt@mpn-glaptop>
 <ab8f1052da1c6b03f70379ecbd9e1d65@rsmogura.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-mm@kvack.org, "Yongqiang Yang" <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?UmFkb3PFgmF3IFNtb2d1cmE=?= <mail@smogura.eu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48761 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2BPXLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 18:11:38 -0500
Received: by pbcun15 with SMTP id un15so3013095pbc.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2012 15:11:38 -0800 (PST)
In-Reply-To: <ab8f1052da1c6b03f70379ecbd9e1d65@rsmogura.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Feb 2012 14:40:17 -0800, Rados=C5=82aw Smogura <mail@smogura=
=2Eeu> wrote:

> On Thu, 16 Feb 2012 13:59:29 -0800, Michal Nazarewicz wrote:
>> On Thu, 16 Feb 2012 12:26:00 -0800, Rados=C5=82aw Smogura
>> <mail@smogura.eu> wrote:
>>
>>> On Thu, 16 Feb 2012 11:09:18 -0800, Michal Nazarewicz wrote:
>>>> On Thu, 16 Feb 2012 06:31:28 -0800, Rados=C5=82aw Smogura
>>>> <mail@smogura.eu> wrote:
>>>>> Supporting files, like Kconfig, Makefile are auto-generated due t=
o
>>>>> large amount
>>>>> of available options.
>>>>
>>>> So why not run the script as part of make rather then store
>>>> generated
>>>> files in
>>>> repository?
>>> Idea to run this script through make is quite good, and should work=
,
>>> because new mane will be generated before "config" starts.
>>>
>>> "Bashizms" are indeed unneeded, I will try to replace this with sed=
=2E
>>
>> Uh? Why sed?
> There are some substitutions so I it will be better to use sed.

Do you mean this:

> cfg_o=3D"${CFG_PREFIX}_${o//-/_}";

It can be achieved with =E2=80=9Ctr=E2=80=9D like I've shown:

> cfg_o=3D$CFG_PREFIX_$(echo "$o" | tr '[:lower:]-' '[:upper:]_')


--=20
Best regards,                                         _     _
=2Eo. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
=2E.o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarew=
icz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
