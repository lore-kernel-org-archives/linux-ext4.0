From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Fri, 9 Jan 2015 16:52:11 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net> <20150109035123.GG22149@ZenIV.linux.org.uk> <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Al Viro <viro@ZenIV.linux.org.uk>, kzak@redhat.com,
	Dexuan Cui <decui@microsoft.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"'linux-ext4'" <linux-ext4@vger.kernel.org>
To: Stefan Hajnoczi <stefanha@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682AbbAIPwY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2015 10:52:24 -0500
In-Reply-To: <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 9 Jan 2015, Stefan Hajnoczi wrote:

> Date: Fri, 9 Jan 2015 12:01:59 +0000
> From: Stefan Hajnoczi <stefanha@redhat.com>
> To: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Dexuan Cui <decui@microsoft.com>,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
>     'linux-ext4' <linux-ext4@vger.kernel.org>
> Subject: Re: Can one file system be R/W mounted multiple times in Linux?
> 
> On Fri, Jan 09, 2015 at 03:51:23AM +0000, Al Viro wrote:
> > On Fri, Jan 09, 2015 at 03:44:16AM +0000, Dexuan Cui wrote:
> > > The 'mount' utility allows me to mount 1 file systems multiple times at different
> > > mount points, like "mount /dev/sdb1 /a; mount /dev/sdb1 /b".
> > > 
> > > I tried to write from /a and /b at the same time and it seems everything is OK
> > > and no data corruption happens.
> > > I tried only  ext4 only.
> > > 
> > > Can somebody please tell me if this usage is safe?
> > 
> > Yes.
> 
> Can you explain under what conditions mounting the same file system
> twice will work?
> 
> I guess the kernel is looking up the block device and then sharing the
> superblock if the file system is already mounted on this block device?
> 
> If I use two loop devices for the same underlying storage it does not
> work:
> 
>   # mount -o loop /var/tmp/ext4.img /tmp/a
>   # mount -o loop /var/tmp/ext4.img /tmp/b

Because now you have two block devices backed by the same file.
Which as Christoph pointed out is equivalent of accessing it from
two different systems.

What you probably want to do is this:

# losetup --show -f /var/tmp/ext4.img
/dev/loop0

mount /dev/loop0 /tmp/a
mount /dev/loop0 /tmp/b

Now the question is, whether 'mount' can be a bit smarter than that
and just mount the already existing block device instead of creating
new one ? Karel ?

-Lukas


>   # touch /tmp/a/a
>   # ls /tmp/b
>   lost+found
>   # umount /tmp/a
>   # umount /tmp/b
>   # mount -o loop /var/tmp/ext4.img /tmp/a
>   [1078357.297245] EXT4-fs error (device loop0): ext4_lookup:1441: inode #2: comm ls: deleted inode referenced: 12
> 
> Stefan
> 
