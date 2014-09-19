From: Dexuan Cui <decui@microsoft.com>
Subject: RE: Is ext2 freezable?
Date: Fri, 19 Sep 2014 03:11:40 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99D4840@SINEX14MBXC418.southpacific.corp.microsoft.com>
References: <EE124450C0AAF944A40DD71E61F878C99CE2C3@SINEX14MBXC418.southpacific.corp.microsoft.com>
 <20140918191736.GC19520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:8512
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754532AbaISDM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2014 23:12:28 -0400
In-Reply-To: <20140918191736.GC19520@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> -----Original Message-----
> From: Theodore Ts'o [mailto:tytso@mit.edu]
> Sent: Friday, September 19, 2014 3:18 AM
> To: Dexuan Cui
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Is ext2 freezable?
>
> On Thu, Sep 18, 2014 at 06:46:21AM +0000, Dexuan Cui wrote:
> >
> > I've got the answer:
> > ext2.ko itself does support fsfreeze, but typical linux distros don't supply
> > ext2.ko at all now -- instead, they usually supply ext3.ko and have ext4
> builtin.
> >
> > So when I mount an ext2 partition, actually the kernel is registering the ext4
> > driver as an ext2 driver and in this case the ext2's s_op->freeze_fs is NULL --
> > but, why did ext4 choose this behavior for ext2?
>
> It wasn't a deliberate design choice.  It was just that when
> no-journal mode was added to ext4, freeeze support was never
> implemented, and up until now, no one had asked for it.  We can add it
> to ext4; thanks for calling it to our attention.
>  - Ted

Hi Ted,
Thanks very much for the clarification!

And thanks a lot for implementing this -- I've seen the patches you sent out
several hours ago.

IMO it's useful to have such compatibility, e.g.,
Hyper-V guest has a fsfreeze-based feature to back up the data; the feature
works fine for ext4 partition, but Ubuntu's installer can create /boot
of ext2 partition by default and hence the feature can't work:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362574

I believe the bug will go away after Ubuntu integrates your patches.

Thanks!
-- Dexuan
