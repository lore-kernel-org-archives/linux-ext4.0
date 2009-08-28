From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: >16TB issues
Date: Thu, 27 Aug 2009 19:30:47 -0700
Message-ID: <150c16850908271930x277daa95sdea8c34868f2ce36@mail.gmail.com>
References: <20090721161018.GH4231@webber.adilger.int>
	 <20090721192123.GK4231@webber.adilger.int>
	 <150c16850907221527l3060aa85h883656bcc7d7e1c4@mail.gmail.com>
	 <20090730222349.GC31141@shell>
	 <150c16850907311824n71e36f66i86b508bc25d0c4bb@mail.gmail.com>
	 <20090811213947.GA11100@shell> <20090811220511.GC31342@mit.edu>
	 <20090812012538.GD11100@shell> <20090812020439.GE31342@mit.edu>
	 <20090812175916.GE11100@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, Nick Dokos <nicholas.dokos@hp.com>,
	Julia Lawall <julia@diku.dk>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:41922 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZH1Cap (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2009 22:30:45 -0400
Received: by pxi4 with SMTP id 4so1606469pxi.21
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2009 19:30:47 -0700 (PDT)
In-Reply-To: <20090812175916.GE11100@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been testing the latest 64-bit e2fsprogs from the git pu branch
(kernel.org 2.6.30.5/x86_64) on a 64-bit (~22TB) filesystem for a
couple days, since it seems like 32-bit e2fsprogs on a 64-bit
filesystem is going to take a while longer.  I'm able to create and
check a filesystem without any problem.  I've also run Andreas'
llverfs utility for a few hours and not had any complaints.  But, I'm
running into another strange issue.  Here's what I'm doing:
# mkfs.ext4 /dev/md0
# mount /dev/md0 /mnt
# mkdir /mnt/1 /mnt/2 /mnt/3 /mnt/4 /mnt/5
# umount /mnt
# fsck.ext4 -C0 -fy /dev/md0
** No errors at all at this point.  fsck returns 0. **
# mount /dev/md0 /mnt
The last mount command fails, and the kernel log contains:
EXT4-fs: ext4_check_descriptors: Checksum for group 0 failed (3412!=9428)
EXT4-fs: group descriptors corrupted!

If I redo the same steps without the mkdir, or doing fsck.ext4 -fn,
the mount works fine.  I'm running a full llverfs run just to make
sure, but it looks like it will be okay.  Has anyone had success with
this yet?  Any other suggestions?

-Justin
