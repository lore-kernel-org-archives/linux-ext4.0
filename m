From: Alexander Harrowell <a.harrowell@gmail.com>
Subject: Re: strange e2fsck magic number behaviour
Date: Thu, 12 Sep 2013 16:43:31 +0000
Message-ID: <CA+qGm=85QTGwe4a4_+v+bvXwf5VfpWxpErYEzSz+eUKRhFORWg@mail.gmail.com>
References: <CA+qGm=-0w+gTh6=ZJhns_=4LKksJueiaYF0gxogmj=TmFN7yQg@mail.gmail.com>
	<CA+qGm=_BBsNM6ZYYWhHucMiP7QWCfD0ApVQNa3ijN22AMN8mGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52929 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3ILQnb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Sep 2013 12:43:31 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so47718pdj.15
        for <linux-ext4@vger.kernel.org>; Thu, 12 Sep 2013 09:43:31 -0700 (PDT)
In-Reply-To: <CA+qGm=_BBsNM6ZYYWhHucMiP7QWCfD0ApVQNa3ijN22AMN8mGw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To be clearer, I meant 24 bits.

On Thu, Sep 12, 2013 at 4:39 PM, Alexander Harrowell
<a.harrowell@gmail.com> wrote:
> I'm currently trying to recover an ext4 filesystem. Last night, during
> a resize operation, the system (Ubuntu 12.04 LTS on my fix-stuff usb
> stick) locked up hard and eventually crashed. Restarting,
> unsurprisingly, gparted offered to check the volume. e2fsck, called
> from within gparted, replayed the journal overnight and completed the
> resize.
>
> however, where I was expecting a volume with about 3.5GB of free
> space, there was now a volume with 32GB free space, a bit more than
> 50% utilised. inevitably, trying to boot the linux that lives in there
> dropped into grub rescue.
>
> going back, I tried to e2fsck it. this reported large numbers of inode
> issues and eventually reported clean. I could mount the volume, but
> file metadata looked generally broken (lots of ?s). testdisk showed
> the partitions were intact, although it claimed the drive was the
> wrong size (incorrectly), and found lots of deleted files within my
> ecryptfs home folder. It also found the backup superblocks for the
> damaged volume.
>
> the first couple I tried were corrupt, but the third was valid. e2fsck
> -b [superblock] -y reports fixing a lot of inode things, checksums,
> and then restarts.  it then starts to report hunormous numbers of
> multiply-claimed blocks.
>
> and now comes the interesting bit - at some point, block 16777215
> starts to appear more and more often in the inodes, often duplicated,
> until it starts to print out the number 16777215 in a fast loop. in
> fact, it looks like it hits some inode and keeps printing block
> 16777215 to the same very long line (it's generated 500MB of log)
>
> I removed the first inode containing this block via debugfs, without
> this helping.
>
> It sticks out that 16777215 is a magic number (the maximum in a 48 bit
> address space) and I google that either ext4 or e2fsck has had a bug
> involving it before.
