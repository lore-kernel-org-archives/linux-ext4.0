From: Daniel Drake <dsd@laptop.org>
Subject: Re: ext4 online resize crash
Date: Sun, 1 Apr 2012 10:42:02 -0600
Message-ID: <CAMLZHHSLZf6fsCoR=YixAc+yQ1x9LMzDpnExjxj7GBadv=JZ4g@mail.gmail.com>
References: <CAMLZHHQ=FMXAzvhE7GOCONtr8d4RB1HBx9Wbjx+01MOYuN85ng@mail.gmail.com>
	<CAGBYx2a21NRaED3bwNV+hVBsbteYQ+oTA_jtfWQfvwTCrr_74w@mail.gmail.com>
	<CAMLZHHTYhi4jo-2m1tSRUR5GDDhu-87iTYenjQ4qZ40c1zEV2g@mail.gmail.com>
	<CAMLZHHS+SrJKQ-axE4wB5pSHQfie8iCModJU=rju2yR9k3_k3w@mail.gmail.com>
	<alpine.LFD.2.00.1204010415500.7626@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56612 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2DAQmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Apr 2012 12:42:03 -0400
Received: by vcqp1 with SMTP id p1so1250280vcq.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Apr 2012 09:42:02 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1204010415500.7626@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,

On Sat, Mar 31, 2012 at 8:17 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> there is a fix bug that happens when resizing the file system in a wa=
y
> that a new size is still in the same group:
>
> a0ade1deb86d2325aecc36272bb4505a6eec9235
> =A0 =A0 =A0 =A0ext4: fix resize when resizing within single group
>
> I am not sure if that really solves your problem, since the actual bu=
g
> in you backtrace happens somewhere else, but you can give it a try. I=
t
> was merged into the main line just recently.

Thanks for the suggestion but I am already using latest mainline which
includes that patch.

Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
