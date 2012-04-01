From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: ext4 online resize crash
Date: Sun, 1 Apr 2012 04:17:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1204010415500.7626@dhcp-27-109.brq.redhat.com>
References: <CAMLZHHQ=FMXAzvhE7GOCONtr8d4RB1HBx9Wbjx+01MOYuN85ng@mail.gmail.com> <CAGBYx2a21NRaED3bwNV+hVBsbteYQ+oTA_jtfWQfvwTCrr_74w@mail.gmail.com> <CAMLZHHTYhi4jo-2m1tSRUR5GDDhu-87iTYenjQ4qZ40c1zEV2g@mail.gmail.com>
 <CAMLZHHS+SrJKQ-axE4wB5pSHQfie8iCModJU=rju2yR9k3_k3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Daniel Drake <dsd@laptop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab2DACSE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Mar 2012 22:18:04 -0400
In-Reply-To: <CAMLZHHS+SrJKQ-axE4wB5pSHQfie8iCModJU=rju2yR9k3_k3w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 31 Mar 2012, Daniel Drake wrote:

> On Sat, Mar 31, 2012 at 6:53 PM, Daniel Drake <dsd@laptop.org> wrote:
> > That's right. The filesystem is being grown by approximately 100mb.
> > I'll get you the exact numbers on Monday.
> 
> Actually, I just realised I have them here.
> The partition was originally 7409856 sectors, I enlarged it to 7605248
> sectors and then tried to grow the ext4 filesystem contained inside.
> 
> Thanks,
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Daniel,

there is a fix bug that happens when resizing the file system in a way
that a new size is still in the same group:

a0ade1deb86d2325aecc36272bb4505a6eec9235
	ext4: fix resize when resizing within single group

I am not sure if that really solves your problem, since the actual bug
in you backtrace happens somewhere else, but you can give it a try. It
was merged into the main line just recently.

Thanks!
-Lukas
