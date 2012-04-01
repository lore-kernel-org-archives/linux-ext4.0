From: Daniel Drake <dsd@laptop.org>
Subject: Re: ext4 online resize crash
Date: Sat, 31 Mar 2012 18:55:01 -0600
Message-ID: <CAMLZHHS+SrJKQ-axE4wB5pSHQfie8iCModJU=rju2yR9k3_k3w@mail.gmail.com>
References: <CAMLZHHQ=FMXAzvhE7GOCONtr8d4RB1HBx9Wbjx+01MOYuN85ng@mail.gmail.com>
	<CAGBYx2a21NRaED3bwNV+hVBsbteYQ+oTA_jtfWQfvwTCrr_74w@mail.gmail.com>
	<CAMLZHHTYhi4jo-2m1tSRUR5GDDhu-87iTYenjQ4qZ40c1zEV2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45249 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2DAAzC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Mar 2012 20:55:02 -0400
Received: by vbbff1 with SMTP id ff1so1084562vbb.19
        for <linux-ext4@vger.kernel.org>; Sat, 31 Mar 2012 17:55:02 -0700 (PDT)
In-Reply-To: <CAMLZHHTYhi4jo-2m1tSRUR5GDDhu-87iTYenjQ4qZ40c1zEV2g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 31, 2012 at 6:53 PM, Daniel Drake <dsd@laptop.org> wrote:
> That's right. The filesystem is being grown by approximately 100mb.
> I'll get you the exact numbers on Monday.

Actually, I just realised I have them here.
The partition was originally 7409856 sectors, I enlarged it to 7605248
sectors and then tried to grow the ext4 filesystem contained inside.

Thanks,
Daniel
