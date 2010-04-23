From: Steve Brown <sbrown25@gmail.com>
Subject: Re: ext4 benchmark questions
Date: Fri, 23 Apr 2010 10:38:44 -0500
Message-ID: <k2n1f4ef0971004230838w8bfe6b2w41d9a68bf6bda9ee@mail.gmail.com>
References: <x2m1f4ef0971004221438n76bbc32bu6835dfe17dd702d8@mail.gmail.com>
	 <4BD0C50A.5050508@redhat.com>
	 <m2h1f4ef0971004221511wa0ea3d3fteb90ad1c38c9511d@mail.gmail.com>
	 <4BD0CBBF.1060300@redhat.com> <4BD1B1CA.5050502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.211.194]:59401 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab0DWPiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Apr 2010 11:38:50 -0400
Received: by ywh32 with SMTP id 32so5731169ywh.33
        for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 08:38:49 -0700 (PDT)
In-Reply-To: <4BD1B1CA.5050502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>> not expected by me; barriers =3D=3D drive write cache flushes, whi=
ch I
>>>> would never expect to speed things up...
>>>>
>>>
>>> hmmm... this would seem to conflict with the docs in the kernel,
>>> especially:
>>>
>>> "Write barriers enforce proper on-disk ordering
>>> of journal commits, making volatile disk write caches
>>> safe to use, at some performance penalty. =A0If
>>> your disks are battery-backed in one way or another,
>>> disabling barriers may safely improve performance."
>>>
>>
>> what you saw is in conflict with what is expected, yes; I don't know
>> why barriers would ever increase performance.
>>
>> (my description of barriers as drive write caches isn't in conflict
>> with the docs, I just said how they're implemented)
>>
>
> Barriers when working should never make things faster, at best, we sh=
ould
> have parity.
>
> Also important to note that barriers should be disabled if you hardwa=
re RAID
> card exports itself as a "write through" cache, even if you enable ba=
rriers
> on the command line.
>
> What controller are you using and what kind of drives do you have in =
the
> back end?

Thats good to know about the write barriers with WT cache.  I'm still
setting everything manually in /etc/fstab because, well... I don't
always trust software. ;)

The controller is an LSI 9280-8e (megaraid_sas kernel module).  Drives
are 1TB Seagate ES.2s, 16 of them in the chassis.

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
