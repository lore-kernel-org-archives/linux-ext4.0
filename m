From: Daniel Drake <dsd@laptop.org>
Subject: Re: ext4 online resize crash
Date: Sat, 31 Mar 2012 18:53:20 -0600
Message-ID: <CAMLZHHTYhi4jo-2m1tSRUR5GDDhu-87iTYenjQ4qZ40c1zEV2g@mail.gmail.com>
References: <CAMLZHHQ=FMXAzvhE7GOCONtr8d4RB1HBx9Wbjx+01MOYuN85ng@mail.gmail.com>
	<CAGBYx2a21NRaED3bwNV+hVBsbteYQ+oTA_jtfWQfvwTCrr_74w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46268 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2DAAxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Mar 2012 20:53:21 -0400
Received: by vcqp1 with SMTP id p1so1068034vcq.19
        for <linux-ext4@vger.kernel.org>; Sat, 31 Mar 2012 17:53:20 -0700 (PDT)
In-Reply-To: <CAGBYx2a21NRaED3bwNV+hVBsbteYQ+oTA_jtfWQfvwTCrr_74w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 30, 2012 at 6:30 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> According to dumpe2fs, the filesystem initially has 28 groups, that i=
s
> 3.5GB, then it is resized to a new size. Right? =A0Could you point ou=
t
> what's the new size, a specific number will be appreciated!

That's right. The filesystem is being grown by approximately 100mb.
I'll get you the exact numbers on Monday.

Thanks,
Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
