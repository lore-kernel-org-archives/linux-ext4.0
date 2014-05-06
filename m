From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Why does not freeblocks number change after deleting a big
 file?
Date: Tue, 6 May 2014 12:35:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405061229410.2255@localhost.localdomain>
References: <536857BC.3010002@gmail.com> <20140506095748.GD23108@azat>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1246622429-1399372534=:2255"
Cc: Younger Liu <younger.liucn@gmail.com>, linux-ext4@vger.kernel.org
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbaEFKfg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 06:35:36 -0400
In-Reply-To: <20140506095748.GD23108@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1246622429-1399372534=:2255
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 6 May 2014, Azat Khuzhin wrote:

> Date: Tue, 6 May 2014 13:57:48 +0400
> From: Azat Khuzhin <a3at.mail@gmail.com>
> To: Younger Liu <younger.liucn@gmail.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Why does not freeblocks number change after deleting a big file?
> 
> On Tue, May 06, 2014 at 11:32:12AM +0800, Younger Liu wrote:
> > Hi:
> >   Analyze ext4 filesystem with "debugfs -R "stats" <device>",
> > Why does not free blocks number change after deleting a big file?
> > 
> > The big file:
> > # stat test
> >   file："test"
> >   size：290554084       blocks：567496     IO block：4096
> > 
> > before deleting the file "test":
> > # debugfs -R "stats" /dev/sdb
> > ...
> > Inode count:              243593216
> > Block count:              1948728320
> > Reserved block count:     97436416
> > Free blocks:              406830314
> > Free inodes:              151667854
> > ...
> > 
> > deleting the file "test"
> > # debugfs -R "stats" /dev/sdb
> > ...
> > Inode count:              243593216
> > Block count:              1948728320
> > Reserved block count:     97436416
> > Free blocks:              406830314
> > Free inodes:              151667854
> 
> Hi,
> 
> Seems that you are trying to do this on a mounted partition, and the
> super block are not dumped to disk after every write/flush.
> 
> You could use statfs(2) instead of debugfs/stats command, or "mount -o
> remount /dev/sdb_X_" and after debugfs, this _must_ work only in case
> you don't have journal.
> 
> For more information you could look into ext4_commit_super().

Yes, it really looks like you're doing this on mounted file system.
However we do not update the superblock for some of the summary
statistics such as number of free blocks, inodes and so on.

This is because it is recalculated from per block group
descriptors when the file system is mounted, or unmounted. So when
the file system is mounted debugfs is not going to give you an
accurate information. You have to use something else like 'stat -f'
for example.

Thanks!
-Lukas

> 
> > ...
> > 
> >      Younger
> >      thx.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
--8323328-1246622429-1399372534=:2255--
