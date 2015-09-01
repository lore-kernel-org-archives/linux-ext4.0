From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Mon, 31 Aug 2015 21:19:51 -0600
Message-ID: <EDB725A6-436E-4B98-8EBF-DAB1E4E68FE4@dilger.ca>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com> <28A25D6A-DA5A-42D2-9BFE-9F6C95B51BE7@dilger.ca> <CAETWcfti7NL3N96K1pEAX9ezKUrZn0QeGTwjn0qUni0u6i=Gcg@mail.gmail.com> <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com> <20150827190548.GC3357@thunk.org> <CAETWcftzdWdjzVQnP-rD-o0iEFLgZFQeLx++90ZyQZiaFJB0kw@mail.gmail.com> <20150828175325.GB10211@thunk.org> <CAETWcfsK2tPf0RrAFnHfOYxHxV7X9pwMeKwqToVnnzEz+6sw0w@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35444 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbbIADTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2015 23:19:55 -0400
Received: by pacdd16 with SMTP id dd16so160197818pac.2
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2015 20:19:55 -0700 (PDT)
In-Reply-To: <CAETWcfsK2tPf0RrAFnHfOYxHxV7X9pwMeKwqToVnnzEz+6sw0w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2015, at 1:20 AM, Alexander Afonyashin <a.afonyashin@madnet-team.ru> wrote:
> 
> Hi,
> 
> Running fsck from e2fsprogs-1.42.13 results in SIGKILL:
> 
> Inode 4425496 is too big.  Truncate? yes
> 
> Block #524289 (103743230) causes directory to be too big.  CLEARED.
> Block #524290 (3236857350) causes directory to be too big.  CLEARED.
> Block #524291 (3625464338) causes directory to be too big.  CLEARED.
> Block #524292 (1370882069) causes directory to be too big.  CLEARED.
> Block #524293 (3868016883) causes directory to be too big.  CLEARED.
> Block #524294 (3919147116) causes directory to be too big.  CLEARED.
> Block #524295 (279419478) causes directory to be too big.  CLEARED.
> Block #524296 (194746972) causes directory to be too big.  CLEARED.
> Block #524297 (1695856868) causes directory to be too big.  CLEARED.
> Block #524298 (587425254) causes directory to be too big.  CLEARED.
> Block #524299 (142614537) causes directory to be too big.  CLEARED.
> Too many illegal blocks in inode 4425496.
> Clear inode? yes
> 
> Inode 4425357 has compression flag set on filesystem without
> compression support.  Clear? yes
> 
> Warning... fsck.ext4 for device /dev/sda3 exited with signal 9.
> root@rescue ~ # e2fsprogs-1.42.13/build/misc/fsck -v -y /dev/sda3

Hmm, the "fsck" command is just a wrapper, and it is not necessarily
calling the e2fsck command from your build tree.  You should run:

   e2fsprogs-1.42.13/build/e2fsck/e2fsck -fy /dev/sda3

That said, if you are having problems with the e2fsck, could you
run it under gdb to see where it is failing?  Signal 9 is SIGKILL
which means that the process was killed by some external signal?

> Regards,
> Alexander
> 
> On Fri, Aug 28, 2015 at 8:53 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> If dumpe2fs is hanging as well, it's likely that the problem may be at
>> the hardware level.  You might want to check dmesg or the kernel log
>> to see if there are any I/O errors being reported from hard drive.
>> What might be happening is that when a program (such as e2fsck or
>> dumpe2fs) tries to read from a specific part of the hard drive, the
>> hard drive is retrying a large number of times because the hard drive
>> head or platter surface has gotten damaged in some way.
>> 
>> It might also be a good idea to check the S.M.A.R.T. status using the
>> smartctl program.
>> 
>> Cheers,
>> 
>>                                                - Ted


Cheers, Andreas





