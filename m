From: Jan Kara <jack@suse.cz>
Subject: Re: very long fsck(weeks) for a small(500GB) ext4 partition.
Date: Tue, 22 Jan 2013 14:23:51 +0100
Message-ID: <20130122132351.GA28331@quack.suse.cz>
References: <20130119174044.53b84456@x60.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab3AVNXx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 08:23:53 -0500
Content-Disposition: inline
In-Reply-To: <20130119174044.53b84456@x60.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Sat 19-01-13 17:40:44, Denis 'GNUtoo' Carikli wrote:
> I was shrinking my ext4 partition with resize2fs when the electricity
> went off.
  Heh, bad luck...

> Then I launched an fsck against my partition which is
> at /dev/mapper/something because it's an opened LUKS partition.
> The partition is a bit less than 500GB in size because it's a 500GB hdd.
  When something really bad happens, as it happened to you, it is a good
idea to spend some more time, find some external hard drive or spare space
elsewhere and backup the corrupted device. When you later come to a
situation like "Oh, I forgot to give -y to fsck", you can just stop it
without thinking twice and you will be glad you spent the extra time with
finding free space.

> Now the problem is that it's checking the filesystem since more than
> 433 hours according to htop.
> 
> since I've forgetten to add -y in the fsck command I've something
> mechanical that keep pressing y on the keyboard all the time.
  ;)

> here's what fsck says at the time of writing the email:
> File ... (inode #129283, mod time Tue Sep 25 21:09:35 2012) 
>   has 3 multiply-claimed block(s), shared with 1 file(s):
> /home/gnutoo/networking/SDR/uhd.20121031204636/host/build/docs/doxygen/???/structuhd_1_1not__implemented__error.html 
> (inode #14946569, mod time Tue Sep 25 21:09:35 2012)
> Clone multiply-claimed blocks<y>? yes
  I suppose the first inode number is increasing right? As you can see you
are now at inode 129283. I estimate your filesystem has about 31250000
inodes (chosen by mke2fs with default settings for your fs size) and although
not all of them are used by far, it will take years before the fsck will
finish. So I think you can terminate it with peace in mind. There's no
point in letting it run.
 
> 1) Can I stop the fsck and continue it later?
  You can run it again (with -y this time). It shouldn't do much harm
AFAIK.

> 2) I've no idea how much inodes there are in the filesystem but I fear
> that it it's only at the beginning of it and will last forever.
  Yup.

> 3) If I stop, and mount it, maybe I'll be able to copy the data?
  Maybe. It's definitely worth a try. Make sure to mount read-only.

> e2fsprogs are at version 1.41.14-1ubuntu3.
  And using newer e2fsprogs may give better results as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
