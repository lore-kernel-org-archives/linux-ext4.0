From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: System hang with EXT4
Date: Fri, 11 Dec 2009 05:37:17 +0300
Message-ID: <873a3ick2q.fsf@openvz.org>
References: <150c16850911231816t514bb1dds4deb541b14a5bad6@mail.gmail.com>
 <20091208151816.GB3141@atrey.karlin.mff.cuni.cz>
 <150c16850912091723x7659bf4ke42f209595ceb147@mail.gmail.com>
 <150c16850912101541k5293b3d7l947b5850fed707b1@mail.gmail.com>
 <150c16850912101543q231fb703u130c9e646289a8fe@mail.gmail.com>
 <87fx7ixppv.fsf@openvz.org>
 <150c16850912101817g497588b2g3aa4dcaf7c5aed7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:52650 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762211AbZLKChD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 21:37:03 -0500
Received: from dmon-lp ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KUG00AZ6VHVNE30@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Fri, 11 Dec 2009 05:41:58 +0300 (MSK)
In-reply-to: <150c16850912101817g497588b2g3aa4dcaf7c5aed7a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Maggard <jmaggard10@gmail.com> writes:

> On Thu, Dec 10, 2009 at 5:29 PM, Dmitry Monakhov <dmonakhov@openvz.or=
g> wrote:
>> Justin Maggard <jmaggard10@gmail.com> writes:
>>> I have a little more information to add. =C2=A0After noticing the r=
ecent
>>> "Fix potential quota deadlock" patch on the mailing list, I figured=
 it
>>> would be worth a shot to try it without quotas enabled. =C2=A0This =
also
>>> avoids the system hang. =C2=A0I tried applying that patch, but stil=
l had
>>> the same symptoms using that kernel. =C2=A0So I'm seeing a consiste=
nt
>>> system hang with ext4 when delalloc and quotas are enabled on an SM=
P
>>> system. =C2=A0With either quotas or delalloc disabled, it doesn't h=
ang.
>>> Both enabled on a single processor system also doesn't hang.
>> You also may try another patch
>> "[PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2"
>
> Yes, that patch looks like it did the trick.  Thanks!
Ohhh.. in fact i've to apologies my patch is wrong a little bit
after i_block_reservation_lock was reacquired second time
i_reserved_meta_blocks block's may be changed so we have to
use add instead of assign
=20
-       EXT4_I(inode)->i_reserved_meta_blocks =3D mdblocks;
+       EXT4_I(inode)->i_reserved_meta_blocks +=3D md_needed;
As result quota leak is possible on heavy SMP stress test.
I've already send correct version.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
