From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: dumpe2fs/dump/restore not working correctly for ext4?
Date: Thu, 4 Mar 2010 16:22:38 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1003041621550.17723@p34.internal.lan>
References: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:41932 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab0CDVWj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Mar 2010 16:22:39 -0500
In-Reply-To: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 4 Mar 2010, Justin Piszcz wrote:

> Hi,
>
> I need to look into this more obviously and try other dumps etc, but I even 
> tried extracting a single (smaller) directory and it also segfaulted, has 
> dump been tested properly with ext4?
>
> # restore -f ../p34-root-2010-03-02.ext4dump -r .
> Segmentation fault (core dumped)

And from another day:

p34:/x2/bup/p34/2010-03-01/d# restore -f ../p34-root-2010-03-01.ext4dump 
-r .
Segmentation fault (core dumped)
p34:/x2/bup/p34/2010-03-01/d# ls
a/      core.restore.18181  l2/          nfs/             sbin/     var/
app@    dev/                lib/         opt/             selinux/  x@
appc@   etc/                lib64@       proc/            sys/      x2@
bin/    home/               lost+found/  r1/              tmp/      x3@
boot/   initrd/             media/       restoresymtable  usr/      x4@
cdrom@  l1/                 mnt/         root/            vapp@     x5@
p34:/x2/bup/p34/2010-03-01/d#

Does anyone use dump/restore with ext4?

Justin.

