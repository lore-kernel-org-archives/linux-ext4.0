From: Steve Brown <sbrown25@gmail.com>
Subject: Re: ext4 benchmark questions
Date: Thu, 22 Apr 2010 17:11:20 -0500
Message-ID: <m2h1f4ef0971004221511wa0ea3d3fteb90ad1c38c9511d@mail.gmail.com>
References: <x2m1f4ef0971004221438n76bbc32bu6835dfe17dd702d8@mail.gmail.com>
	 <4BD0C50A.5050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.211.194]:54160 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab0DVWLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Apr 2010 18:11:34 -0400
Received: by ywh32 with SMTP id 32so5150627ywh.33
        for <linux-ext4@vger.kernel.org>; Thu, 22 Apr 2010 15:11:33 -0700 (PDT)
In-Reply-To: <4BD0C50A.5050508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> I'll start with the craziest one: noatime. =A0Everything I have read
>> says that the noatime option should increase both read and write
>> performance. =A0My results are finding that write speeds are compara=
ble
>> with or without this option, but read speeds are significantly faste=
r
>> *without* the noatime option. =A0For example, a 16GB file reads abou=
t
>> 210MB/s with noatime but reads closer to 250MB/s without the noatime
>> option.
>
> the kernel uses "relatime" now by default, which gives you most of th=
e
> benefit already.

So should I see any performance change by using the noatime mount optio=
n at all?

>> Next is the write barrier. =A0I'm an in a fully battery-backed
>> environment, so I'm not worried about disabling it. =A0From my testi=
ng,
>> setting barrier=3D0 will improve write performance on large files
>> (>10GB), but hurts performance on smaller files (<10GB). =A0Read
>> performance is effected similarly. =A0Is this to be expected with fi=
les
>> of this size?
>
> not expected by me; barriers =3D=3D drive write cache flushes, which =
I
> would never expect to speed things up...

hmmm... this would seem to conflict with the docs in the kernel, especi=
ally:

"Write barriers enforce proper on-disk ordering
of journal commits, making volatile disk write caches
safe to use, at some performance penalty.  If
your disks are battery-backed in one way or another,
disabling barriers may safely improve performance."

>> Next is the data option. =A0I am seeing a significant increase in re=
ad
>> performance when using data=3Dordered vs data=3Dwriteback. =A0Readin=
g is as
>> much as 20% faster when using data=3Dordered. =A0The difference in w=
rite
>> performance is almost none with this option.
>
> data=3Dwriteback is not safe for data integrity; unless you can handl=
e
> scrambled files post-crash/powerloss, don't use it.

I'm not worried about powerloss.  The kernel docs seem to imply that
data=3D[journaled,ordered] come with a performance hit.  My results
would indicate otherwise.  Should I be seeing this kinda of
performance difference?

>> Finally is the commit option. =A0I did my testing mounting with comm=
it=3D5
>> and commit=3D90. =A0While my read performance increased with commit=3D=
90, my
>> write performance improved by as much as 30% or more with commit=3D5=
=2E
>
> not sure offhand what to make of decreased write performance with a l=
onger
> commit time...

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
