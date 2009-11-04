From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: one way to dmesg
Date: Wed, 4 Nov 2009 10:46:30 -0500
Message-ID: <87f94c370911040746k49dce1f6ge8591f7714b8b19d@mail.gmail.com>
References: <1257344804.2852.11.camel@zwerg>
	 <87f94c370911040718k766d910fr23342c82d4632faa@mail.gmail.com>
	 <1257348551.2091.1.camel@mini>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:37827 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbZKDPqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 10:46:25 -0500
Received: by iwn10 with SMTP id 10so5016778iwn.4
        for <linux-ext4@vger.kernel.org>; Wed, 04 Nov 2009 07:46:30 -0800 (PST)
In-Reply-To: <1257348551.2091.1.camel@mini>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 4, 2009 at 10:29 AM, Alexey Fisher
<bug-track@fisher-privat.net> wrote:
> Am Mittwoch, den 04.11.2009, 10:18 -0500 schrieb Greg Freemyer:
>> On Wed, Nov 4, 2009 at 9:26 AM, Alexey Fisher
>> <bug-track@fisher-privat.net> wrote:
>> > Hallo,
>> > this is sort of continue of discussion about unified way to mount =
fs
>> > readonly.
>> > I wont to know how about dmesg/printk. I see ext[234] produce diff=
erent
>> > logs on mount even it use same code. I feel like i have some time =
to
>> > digg in. My target is easy to parse dmesg.
>>
>> Patches for unified mount messages already exist. =A0Various version=
s
>> have been posted in the last couple months.
>>
>> I don't know if they have been accepted yet or not.
>
> Can you point me this patch?
> I found only "add a message in remount/umount for ext4"
> http://patchwork.ozlabs.org/project/linux-ext4/list/?page=3D1

Looks like Toshiyuki Okajima is the author.

http://markmail.org/message/ghyjee2krfmgtybt was just posted in the
last day or two.

That patch only adds the new unified dmesg print to the vfs layer.  I
think there were other patches that removed the scattered prints from
the various individual filesystems.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
