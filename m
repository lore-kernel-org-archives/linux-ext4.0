From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc,
 e4defrag...)
Date: Fri, 18 Apr 2014 10:45:03 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404181042200.2128@localhost.localdomain>
References: <534F39F6.2000208@ovh.fr> <20140417152457.GE18591@thunk.org> <5350205E.3030403@ovh.fr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1773886606-1397810706=:2128"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Contact <neitsab@ovh.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaDRIpL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 04:45:11 -0400
In-Reply-To: <5350205E.3030403@ovh.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1773886606-1397810706=:2128
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Thu, 17 Apr 2014, Contact wrote:

> Date: Thu, 17 Apr 2014 20:41:34 +0200
> From: Contact <neitsab@ovh.fr>
> To: Theodore Ts'o <tytso@mit.edu>, lczerner@redhat.com
> Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
> Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc,
>     e4defrag...)
> 
> Le 17/04/2014 14:04, Lukáš Czerner a écrit :
> >
> > This is not how it it supposed to be used. Yes fallocate
> > preallocates the file, but cp will truncate it so fallocate will
> > certainly not help you in any way. In order for fallocate to be
> > useful you'll have to write into the file without actually
> > truncating it (dd can do this if you do not want to write your own
> > program)
> >
> > Also the file is probably as contiguous as it could be. Here is what
> > I get on the file system with default mkfs options.
> >
> > # e4defrag -c /mnt/test/file1
> > <File>                                         now/best      size/ext
> > /mnt/test/file1                                 10/1         120649 KB
> >
> > But that does not tell the whole story. See
> >
> > xfs_io -f -c "fiemap -v" /mnt/test/file1
> > /mnt/test/file1:
> >  EXT: FILE-OFFSET        BLOCK-RANGE       TOTAL FLAGS
> >    0: [0..262143]:       2768896..3031039 262144   0x0
> >    1: [262144..524287]:  3031040..3293183 262144   0x0
> >    2: [524288..786431]:  3293184..3555327 262144   0x0
> >    3: [786432..1048575]: 3555328..3817471 262144   0x0
> >    4: [1048576..1310719]: 3817472..4079615 262144   0x0
> >    5: [1310720..1425407]: 4079616..4194303 114688   0x0
> >    6: [1425408..1687551]: 4456448..4718591 262144   0x0
> >    7: [1687552..1949695]: 4718592..4980735 262144   0x0
> >    8: [1949696..2211839]: 4980736..5242879 262144   0x0
> >    9: [2211840..2412991]: 5242880..5444031 201152   0x1
> >
> > (Note that the output is in 512B blocks)
> >
> > As you can see the file is mostly contiguous, but it is divided into
> > several extents because of two reasons.
> >
> > 1. The extent in ext4 has a limited size of 32768 blocks for
> > initialized extent and 32767 block for unwritten extent. So when we
> > exceed that size we need another extent which might be physically
> > contiguous on disk with the previous one.
> >
> > 2. Ext4 divides disk space into allocation groups of certain size
> > (cluster size * 8)blocks. Now with flex_bg medatada such as inode
> > tables, block bitmaps and so one are packed closely together so the
> > do not have to be stored with each block group and you'll get more
> > contiguous data space.
> >
> > However we're still storing backup superblock and Groups descriptors
> > in certain groups and those are the gaps you're seeing in the fiemap
> > list.
> >
> > For detailed overview you can use dumpe2fs to see what is allocated
> > where on the file system.
> >
> 
> Thanks, that was much interesting. I had delved a bit into ext4 data
> structure before posting but was never able to get a clear grasp on the
> limitations concerning contiguity.
> 
> So, I tried the correct way you recommended about how to use fallocate:
> 
> # mkfs.ext4 -m 0 -L iso -i 67108864 -E root_owner=1000:100 /dev/sdc2
> $ fallocate -l 1589166080
> '/run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso'
> $ dd if='/home/neitsab/iso/Manjaro/manjaro-gnome-0.8.9-x86_64.iso'
> of='/run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso'

The way you're using dd for this purpose is wrong. I
said that dd can write to the file without truncating it first, but
it's not doing it by default. You have to use 'notrunc' see man
page. But I think that it would not have made a difference anyway.

-Lukas
--8323328-1773886606-1397810706=:2128--
