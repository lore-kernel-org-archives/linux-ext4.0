From: Lucas Teixeira <lucas@lucasteixeira.com>
Subject: Ext4 newbie trying to recover its partition table
Date: Sun, 27 Nov 2011 14:06:44 -0200
Message-ID: <CAEZOgh80gEP=oW=9adxN7HQHVFjHYJHaT=RKRxDyfUXOTfCGJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51966 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab1K0QHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2011 11:07:07 -0500
Received: by bke11 with SMTP id 11so7168359bke.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Nov 2011 08:07:05 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

=46or more than a year I've been trying to recover data from a harddisk
of mine. I have really important personal files there, and I would
like to recover it myself, as I don't know of any recovering service
that I would trust to analyze ext4 partitions.

I don't know if anyone here even has the time to read my diagnosis
(pasted below).

**I would like good resources and tips to learn ext4 structure and
dive into e2fsprogs source code, in order to recover the files in my
misteriously lost partitions.**

My C experience is limited to CRUD programs, linked lists and search
trees (learned at college, before I dropped out), but I am determined
to learn what is needed.

Thank you very much, and sorry for the sometimes confusing english
(I'm from Brazil)

I'm pasting here what I said at reddit.com a year ago:


	TL;DR: The partition table that I recovered with TestDisk say that
	my three ext4 partitions begin exactly 316 bytes before they really
	begin. I don't know how to make a partition table that says exactly
	where it starts. (see fdisk output after the jump

	Hello,

	I have a Seagate Barracuda ST31000333AS HD (1TB of storage), and I
	recently bought an external case for it. It was already formatted with
	3 ext4 partitions.

	The last thing I remember is deleting a HFS partition (it has
	something to do with my love's Macbook), and then... the partition
	table was gone.

	I tried some tools to recover the partition table, and I finally
	thought that TestDisk got it right... well, it almost did.

	The sizes and positions of the recovered partitions seemed just right,
	but I couldn't mount it. And the type of the partitions in this new
	table was ext3, not ext4.

	After a lot of hexdump's and dd's, I learned a few things about
	partition tables *and* (sort of) discovered the problem:

	    lucas@blackie:~$ sudo dd if=3D/dev/sdc1 of=3D/tmp/with_offset ibs=3D=
1
	skip=3D316 count=3D1048576     /dev/null lucas@blackie:~$ file
	/tmp/with_offset /tmp/with_offset: Linux rev 1.0 ext4 filesystem data,
	UUID=3Dd94f8233-7b02-4d9e-a20a-18831225c990, volume name "todomundo"
	(extents) (large files) (huge files)

	What I'm doing here is copying the the first megabyte of the partition
	with an offset of 316 bytes. The result is recognized as the original
	partition. This happens with all the three ext4 partitions that are in
	the disk.

	But partition tables deal with cylinders and sectors, not bytes. I
	can't put the right address in the table with any of these two units.

	I didn't mess with disk geometry at any point of this story. Anyway, I
	don't know if TestDisk changes the geometry without warnings, so the
	geometry may be wrong. The geometry of the disk *right now* is:

	    255 heads, 63 sectors/track, 121601 cylinders Sector size
	(logical/physical): 512 bytes / 512 bytes

	I downloaded the HD manual, and it says that the default geometry is:

	    Heads: 6 Discs: 3 Bytes per sector: 512 Default sectors per track:
	63 Default read/write heads: 16 Default cylinders 16,383

	But when I try to feed TestDisk with this information, it says that my
	HD has 8455MiB, which is not true.

	I have an intermittent connection with the Internet (I have no
	Internet at home, and I usually have to take a bus or walk ~30min to
	access it), but I did my homework: applied my google fu, flirted with
	hexdump and dd, RTFM... I have no idea what to do.

	### fdisk -l -u: ###

	    Disco /dev/sdc: 1000.2 GB, 1000204886016 bytes 255 heads, 63
	sectors/track, 121601 cylinders, total de 1953525168 setores Unidades
	=3D setores de 1 * 512 =3D 512 bytes Sector size (logical/physical): 5=
12
	bytes / 512 bytes I/O size (minimum/optimal): 512 bytes / 512 bytes
	Identificador do disco: 0x000e09b9
=09
	    Dispositivo Boot In=C3=ADcio Fim Blocos Id Sistema /dev/sdc1
	63  1232731709   616365823+  83  Linux /dev/sdc2   *  1234675575
	1646325134   205824780   83  Linux /dev/sdc3      1646325135
	1953520064   153597465   83  Linux
l
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
