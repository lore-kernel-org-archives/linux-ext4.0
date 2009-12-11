From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: System hang with EXT4
Date: Fri, 11 Dec 2009 04:29:48 +0300
Message-ID: <87fx7ixppv.fsf@openvz.org>
References: <150c16850911231816t514bb1dds4deb541b14a5bad6@mail.gmail.com>
 <20091208151816.GB3141@atrey.karlin.mff.cuni.cz>
 <150c16850912091723x7659bf4ke42f209595ceb147@mail.gmail.com>
 <150c16850912101541k5293b3d7l947b5850fed707b1@mail.gmail.com>
 <150c16850912101543q231fb703u130c9e646289a8fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:50811 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762161AbZLKB3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 20:29:36 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KUG00A13SDFNE30@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Fri, 11 Dec 2009 04:34:30 +0300 (MSK)
In-reply-to: <150c16850912101543q231fb703u130c9e646289a8fe@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Maggard <jmaggard10@gmail.com> writes:

> On Wed, Dec 9, 2009 at 5:23 PM, Justin Maggard <jmaggard10@gmail.com>=
 wrote:
>> On Tue, Dec 8, 2009 at 7:18 AM, Jan Kara <jack@suse.cz> wrote:
>>> =C2=A0Can you still switch consoles after the system hangs (it's go=
od to
>>> debug this on a text console)? If yes, could you press Alt-Sysrq-w =
and
>>> take a picture of the console by digital camera or so (take picture=
s of
>>> as many screens as possible using console scrollback)? Thanks.
>>
>> Thanks for the response. =C2=A0Console scrollback doesn't seem to wo=
rk for
>> me in that mode. =C2=A0I tried it three times. =C2=A0Two of the time=
s the list
>> was empty. =C2=A0The other time, the screen just listed a bunch of r=
m
>> processes.
>
> I have a little more information to add. =C2=A0After noticing the rec=
ent
> "Fix potential quota deadlock" patch on the mailing list, I figured i=
t
> would be worth a shot to try it without quotas enabled. =C2=A0This al=
so
> avoids the system hang. =C2=A0I tried applying that patch, but still =
had
> the same symptoms using that kernel. =C2=A0So I'm seeing a consistent
> system hang with ext4 when delalloc and quotas are enabled on an SMP
> system. =C2=A0With either quotas or delalloc disabled, it doesn't han=
g.
> Both enabled on a single processor system also doesn't hang.
You also may try another patch
"[PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2"
>
> -Justin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
