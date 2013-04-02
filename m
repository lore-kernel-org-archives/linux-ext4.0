From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Tue, 2 Apr 2013 20:33:56 +0800
Message-ID: <20130402123356.GA10703@gmail.com>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com>
 <87ip46ss0o.fsf@openvz.org>
 <1211053180.322948.1364797847717.JavaMail.root@redhat.com>
 <87fvzaspr8.fsf@openvz.org>
 <874841142.414482.1364875584266.JavaMail.root@redhat.com>
 <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org>
 <877gkls1q7.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>,
	CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:61561 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3DBMRy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2013 08:17:54 -0400
Content-Disposition: inline
In-Reply-To: <877gkls1q7.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 02, 2013 at 01:47:44PM +0400, Dmitry Monakhov wrote:
> On Mon, 1 Apr 2013 23:15:07 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> > Hi,
> > 
> > my machine (PowerBook G4) just crashed and the only thing netconsole was 
> > able to transmit was:
> > 
> >   ------------[ cut here ]------------
> >   kernel BUG at /usr/local/src/linux-git/fs/ext4/inode.c:1591!
> > 
> > But (unfortunately) nothing more. I have no clear way to reproduce this, 
> > but I have some kind of a (longish) backstory to this, see below. The 
> > system is running 3.9-rc4, its .config and dmesg:
> > 
> >   http://nerdbynature.de/bits/3.9.0-rc1/config.gz (oldconfig'ed to -rc4)
> >   http://nerdbynature.de/bits/3.9.0-rc1/dmesg.txt (w/o the calltrace at the end)
> > 
> > 
> > I was having trouble all day downloading a file via bittorrent to an 
> > ext4 filesystem.

It looks like the same problem [1].  But it should have been fixed in
3.9-rc4.  Frankly, I think the root cause is es_cache.  Sorry, it hasn't
been well tested.

1. http://www.serverphorums.com/read.php?12,667656

Could you please revert your tree to this commit (3a225670), and try
again. I want to make sure that the regression won't be fixed until now
or it is introduced after this commit.

Thanks in advance,
                                                - Zheng
