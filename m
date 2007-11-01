From: "Bram Neijt" <bneijt@gmail.com>
Subject: Re: User permissions or UID/GIDs for portable disks?
Date: Thu, 1 Nov 2007 18:07:36 +0100
Message-ID: <46c2f4ab0711011007l62437ca2jf789069a6c5cbdb4@mail.gmail.com>
References: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com>
	 <1193279915.25351.18.camel@eric-laptop>
	 <1193320570.12664.19.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.230]:12654 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXKARHl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2007 13:07:41 -0400
Received: by nz-out-0506.google.com with SMTP id s18so450134nze
        for <linux-ext4@vger.kernel.org>; Thu, 01 Nov 2007 10:07:40 -0700 (PDT)
In-Reply-To: <1193320570.12664.19.camel@norville.austin.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks to Dave and Eric for their replies.

I'm moving the feature discussion to a higher level (pmount) and I've
opened a blueprint on it[1] with more words on why I think it's a
problem[2].

This means that I'm leaving this thread and closing it with this mail.

I would like to thank everybody who replied and read this, for their help.

Greetings,
  Bram

[1] https://blueprints.launchpad.net/launchpad/+spec/usermount-permission-granting
[2] http://docs.google.com/Doc?id=dqqr5r6_41w7hfbx

On 10/25/07, Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> On Wed, 2007-10-24 at 19:38 -0700, Eric wrote:
> > On Wed, 2007-10-24 at 20:10 +0200, Bram Neijt wrote:
> > > One of the best solutions I can come up with is if the filesystem
> > > would allow for a switch that would help ignore these permissions as
> > > part of the filesystem.
> >
> > Ignoring file permissions on removable, user-supplied media sounds like
> > something that ought to be done above the level of individual
> > filesystems, just like how we ignore device files and suid/sgid files in
> > certain cases. Maybe this is something that ought to be one level up
> > from the ext2/3/4 filesystem driver?
>
> It would be a nice feature to implement at a higher level.  A lot of
> file systems do something like this.
>
> > In any case, this raises interesting questions. If we ignore permissions
> > on removable media, then anyone logged into your work computer (to which
> > you do not have root access) will be able to muck about with your files.
> > Is that something you want?
>
> Mount options should override on-media permissions, but those overriding
> permissions could still deny access to others:
>
> mount -o uid=1000,gid=1000,fmask=137,dmask=027 /dev/sdb1 /mnt/usbstick
>
> --
> David Kleikamp
> IBM Linux Technology Center
>
>
