From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Soft lockups in mballoc code
Date: Mon, 26 May 2008 10:27:37 -0400
Message-ID: <18517.1211812057@gamaville.dokosmarshall.org>
References: <25037.1210612895@alphaville.zko.hp.com> <1210785517.3657.42.camel@localhost.localdomain> <27364.1210787137@alphaville.zko.hp.com> <18481.37660.871969.813688@frecb006361.adech.frec.bull.fr>  <18490.27904.103939.811128@frecb006361.adech.frec.bull.fr>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:37759 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059AbYEZO2L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2008 10:28:11 -0400
In-Reply-To: Message from Solofo.Ramangalahy@bull.net
   of "Mon, 26 May 2008 09:55:44 +0200." <18490.27904.103939.811128@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Solofo.Ramangalahy@bull.net wrote:

> I have not been able to reproduce it on 2.6.26-rc3 and
> 2.6.25-14.fc9.x86_64 (fedora 9 kernel).
> 
> besides, on 2.6.25.4, it was much more longer than
> > # /home/nick/src/fsstress/fsstress -d /mnt2/fsstress -l 10 -n 100 -p 20
> to reproduce (I also changed -n and -p).
> 
> Could you confirm that you still easily see the soft lockups?
> If yes, could you attach your x86-64 .config?
> (On my side, I have been using defconfig + ext4dev:
> > CONFIG_EXT4DEV_FS=m
> > CONFIG_EXT4DEV_FS_XATTR=y
> > CONFIG_EXT4DEV_FS_POSIX_ACL=y
> > CONFIG_EXT4DEV_FS_SECURITY=y
> )

No, I am not seeing them any more: it does seem to be a config problem.

I got my original config from the distro that I was running on the box
at the time (RHEL5.1), doing "make oldconfig" and adding ext4dev. I was
trying to get 2.6.26-rc3 going with the same method, but I was running
into severe problems, even without ext4 in the picture (soft lockups
whenever any significant disk IO was done: since the configuration
included a readahead init script for optimization, the machine was
getting hung late in the boot.)

So I got a config file from a colleague's setup and that got me past the
2.6.26-rc3 problem. I also had no problem with ext4 on top of that.  I
went back and tried a similar config file on 2.6.25.3 and that also did
not show the problem. So it seems to be entirely caused by my bad choice
of a config file.

As a matter of good practice, is defconfig+ext4dev the best way of
producing a kernel for ext4 testing purposes? Are there any settings
that should be added/delete/modified from the default?

Thanks,
Nick


