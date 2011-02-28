From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: ext2/3/4: punch support?
Date: Mon, 28 Feb 2011 15:50:09 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102281549050.5172@dhcp-27-109.brq.redhat.com>
References: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com> <20110228131118.GA18193@dhcp231-156.rdu.redhat.com> <AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571140353-850269878-1298904612=:5172"
Cc: Josef Bacik <josef@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Dave Young <hidave.darkstar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab1B1OuP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 09:50:15 -0500
In-Reply-To: <AANLkTimwpoi6agwO4q8qhOcohhSnYFrKhFOCnk0BuTEC@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571140353-850269878-1298904612=:5172
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 28 Feb 2011, Dave Young wrote:

> On Mon, Feb 28, 2011 at 9:11 PM, Josef Bacik <josef@redhat.com> wrote:
> > On Mon, Feb 28, 2011 at 03:03:40PM +0800, Dave Young wrote:
> >> Hi, josef and ext guys
> >>
> >> Do you have any plan with ext4 hole punching support? And the
> >> fallocate for ext2/3?
> >>
> >> What's the obstacle to work on this? could someone tell the status of
> >> this issue?
> >
> > There is no obstacle, just nobody has bothered to do it.  If you want to do it
> > go for it.  Thanks,
> 
> Yes, I want to do some kvm image space discard stuff,
> I use ext4 as my filesystem, but currently only xfs support something
> like trim/discard.

Ext4 supports discard as well, actually batched discard support was
added into ext4 before xfs :)

Thanks!
-Lukas

> 
> I know general knowledge about ext filesystem, but nearly new to ext4 code,
> could you give some hint where to start?
> 
> --
> Thanks
> dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--571140353-850269878-1298904612=:5172--
