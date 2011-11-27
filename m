From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Ext4 newbie trying to recover its partition table
Date: Sun, 27 Nov 2011 14:16:37 -0500
Message-ID: <CAGpXXZK=AUu=xARVUGfU6mWCRm1FENLvnU89zG4SV0gpFG1Png@mail.gmail.com>
References: <CAEZOgh80gEP=oW=9adxN7HQHVFjHYJHaT=RKRxDyfUXOTfCGJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Lucas Teixeira <lucas@lucasteixeira.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44038 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1K0TRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2011 14:17:09 -0500
Received: by iage36 with SMTP id e36so7726187iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Nov 2011 11:17:09 -0800 (PST)
In-Reply-To: <CAEZOgh80gEP=oW=9adxN7HQHVFjHYJHaT=RKRxDyfUXOTfCGJQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

See interspersed

On Sun, Nov 27, 2011 at 11:06 AM, Lucas Teixeira
<lucas@lucasteixeira.com> wrote:
> Hello,
>
> For more than a year I've been trying to recover data from a harddisk
> of mine. I have really important personal files there, and I would
> like to recover it myself, as I don't know of any recovering service
> that I would trust to analyze ext4 partitions.

x-ways forensics supports ext4, and recovery experts work from a
"image" of your drive, so they should not cause any non-recoverable
damage.

(I do computer forensics for a living.  I use X-Ways primarily to do
my work, but your right, I rarely see a ext4 filesystem to analyse.)

If this is really valuable info, the first thing you should do is make
a "image" of the drive:

You'll need a second disk with enough freespace to hold the entire
original disk, then its just:

dd if=3D/dev/sdx of=3Dimage_file bs=3D4K conv=3Dnoerror,sync

bs=3D4k I just a speed optimization thing
noerror says not to abort on a bad block
sync says if there is a bad block, output nulls to fill it up.  That
is very important.

X-ways can work directly from that image, but it costs about $1K (US)
and further it may not work well for this case.

Once you have that backup, you can try gpart?  I think it is available
in most distros and can try to rebuild a partition table.

(I'd separately backup just sector 0 before I tried gpart, then if you
don't like the results you can put it back.)

Also, I personally would install the "sleuthkit" package.  It has lots
of command line tools designed to work with images like the above.

Here's one tool that may help:

http://wiki.sleuthkit.org/index.php?title=3DMmls

sleuthkit is packaged by at least a few of the distros.

> I don't know if anyone here even has the time to read my diagnosis
> (pasted below).
>
> **I would like good resources and tips to learn ext4 structure and
> dive into e2fsprogs source code, in order to recover the files in my
> misteriously lost partitions.**
>
> My C experience is limited to CRUD programs, linked lists and search
> trees (learned at college, before I dropped out), but I am determined
> to learn what is needed.
>
> Thank you very much, and sorry for the sometimes confusing english
> (I'm from Brazil)
>
> I'm pasting here what I said at reddit.com a year ago:
>
>
> =A0 =A0 =A0 =A0TL;DR: The partition table that I recovered with TestD=
isk say that
> =A0 =A0 =A0 =A0my three ext4 partitions begin exactly 316 bytes befor=
e they really
> =A0 =A0 =A0 =A0begin. I don't know how to make a partition table that=
 says exactly
> =A0 =A0 =A0 =A0where it starts. (see fdisk output after the jump
>
> =A0 =A0 =A0 =A0Hello,
>
> =A0 =A0 =A0 =A0I have a Seagate Barracuda ST31000333AS HD (1TB of sto=
rage), and I
> =A0 =A0 =A0 =A0recently bought an external case for it. It was alread=
y formatted with
> =A0 =A0 =A0 =A03 ext4 partitions.
>
> =A0 =A0 =A0 =A0The last thing I remember is deleting a HFS partition =
(it has
> =A0 =A0 =A0 =A0something to do with my love's Macbook), and then... t=
he partition
> =A0 =A0 =A0 =A0table was gone.
>
> =A0 =A0 =A0 =A0I tried some tools to recover the partition table, and=
 I finally
> =A0 =A0 =A0 =A0thought that TestDisk got it right... well, it almost =
did.
>
> =A0 =A0 =A0 =A0The sizes and positions of the recovered partitions se=
emed just right,
> =A0 =A0 =A0 =A0but I couldn't mount it. And the type of the partition=
s in this new
> =A0 =A0 =A0 =A0table was ext3, not ext4.
>
> =A0 =A0 =A0 =A0After a lot of hexdump's and dd's, I learned a few thi=
ngs about
> =A0 =A0 =A0 =A0partition tables *and* (sort of) discovered the proble=
m:
>
> =A0 =A0 =A0 =A0 =A0 =A0lucas@blackie:~$ sudo dd if=3D/dev/sdc1 of=3D/=
tmp/with_offset ibs=3D1
> =A0 =A0 =A0 =A0skip=3D316 count=3D1048576 =A0 =A0 /dev/null lucas@bla=
ckie:~$ file
> =A0 =A0 =A0 =A0/tmp/with_offset /tmp/with_offset: Linux rev 1.0 ext4 =
filesystem data,
> =A0 =A0 =A0 =A0UUID=3Dd94f8233-7b02-4d9e-a20a-18831225c990, volume na=
me "todomundo"
> =A0 =A0 =A0 =A0(extents) (large files) (huge files)
>
> =A0 =A0 =A0 =A0What I'm doing here is copying the the first megabyte =
of the partition
> =A0 =A0 =A0 =A0with an offset of 316 bytes. The result is recognized =
as the original
> =A0 =A0 =A0 =A0partition. This happens with all the three ext4 partit=
ions that are in
> =A0 =A0 =A0 =A0the disk.
>
> =A0 =A0 =A0 =A0But partition tables deal with cylinders and sectors, =
not bytes. I
> =A0 =A0 =A0 =A0can't put the right address in the table with any of t=
hese two units.

cylinders are extremely rarely used anymore.  I think any drive over
4GB cannot be accessed via CHS.  Focus exclusively on sectors.

> =A0 =A0 =A0 =A0I didn't mess with disk geometry at any point of this =
story. Anyway, I
> =A0 =A0 =A0 =A0don't know if TestDisk changes the geometry without wa=
rnings, so the
> =A0 =A0 =A0 =A0geometry may be wrong. The geometry of the disk *right=
 now* is:
>
> =A0 =A0 =A0 =A0 =A0 =A0255 heads, 63 sectors/track, 121601 cylinders =
Sector size
> =A0 =A0 =A0 =A0(logical/physical): 512 bytes / 512 bytes

None of the tools will pay attention to head/cylinders/etc.

Al that matters is sectors from the start of the drive.

> =A0 =A0 =A0 =A0I downloaded the HD manual, and it says that the defau=
lt geometry is:
>
> =A0 =A0 =A0 =A0 =A0 =A0Heads: 6 Discs: 3 Bytes per sector: 512 Defaul=
t sectors per track:
> =A0 =A0 =A0 =A063 Default read/write heads: 16 Default cylinders 16,3=
83

Don't worry about geometry.

> =A0 =A0 =A0 =A0But when I try to feed TestDisk with this information,=
 it says that my
> =A0 =A0 =A0 =A0HD has 8455MiB, which is not true.
>
> =A0 =A0 =A0 =A0I have an intermittent connection with the Internet (I=
 have no
> =A0 =A0 =A0 =A0Internet at home, and I usually have to take a bus or =
walk ~30min to
> =A0 =A0 =A0 =A0access it), but I did my homework: applied my google f=
u, flirted with
> =A0 =A0 =A0 =A0hexdump and dd, RTFM... I have no idea what to do.
>
> =A0 =A0 =A0 =A0### fdisk -l -u: ###
>
> =A0 =A0 =A0 =A0 =A0 =A0Disco /dev/sdc: 1000.2 GB, 1000204886016 bytes=
 255 heads, 63
> =A0 =A0 =A0 =A0sectors/track, 121601 cylinders, total de 1953525168 s=
etores Unidades
> =A0 =A0 =A0 =A0=3D setores de 1 * 512 =3D 512 bytes Sector size (logi=
cal/physical): 512
> =A0 =A0 =A0 =A0bytes / 512 bytes I/O size (minimum/optimal): 512 byte=
s / 512 bytes
> =A0 =A0 =A0 =A0Identificador do disco: 0x000e09b9
>
> =A0 =A0 =A0 =A0 =A0 =A0Dispositivo Boot In=EDcio Fim Blocos Id Sistem=
a /dev/sdc1
> =A0 =A0 =A0 =A063 =A01232731709 =A0 616365823+ =A083 =A0Linux /dev/sd=
c2 =A0 * =A01234675575
> =A0 =A0 =A0 =A01646325134 =A0 205824780 =A0 83 =A0Linux /dev/sdc3 =A0=
 =A0 =A01646325135
> =A0 =A0 =A0 =A01953520064 =A0 153597465 =A0 83 =A0Linux
> l

Good Luck
Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
