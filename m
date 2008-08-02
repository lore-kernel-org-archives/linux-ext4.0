From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: (root cause found....may be not)64k Page size + ext3 errors
Date: Fri, 1 Aug 2008 17:07:53 -0700 (PDT)
Message-ID: <632622.79880.qm@web81307.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

After lots of debugging and dumping file system information. I found th=
at=A0 super block is being corrupted=A0 during SATA dma transfer.=A0 I =
am using PCI-E based SATA card to attach hard disks. Looks with 64k pag=
e size SATA DMA seems to be stressed so much compared to 4k page size. =
I used another SATA card which is more stable(it does not use=A0 libata=
). It worked finw with RAID-5 and 64k page size.
=A0 I have used a small C program to create w2GB size file and read it =
back and check the data consistency. So far no errors found. I also use=
d IO meter test , which worked fine too.=20
All thank you very much for the suggestions and responses.
Regards,
Marri



----- Original Message ----
=46rom: Roger Heflin <rogerheflin@gmail.com>
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Monday, July 28, 2008 5:33:34 PM
Subject: Re: 64k Page size + ext3 errors

tirumalareddy marri wrote:
> Hi Roger,
>=A0 =A0 I did sync after I copied the 128MB data. Isn't that should gu=
arantee data is flushed to disk ? I am using "sum" command to check if =
data file is copied to Disk is valid or not.=20

It means it will be flushed to disk, it does not mean that when you rea=
d it back=20
that will come off disk, if it is still in memory then it will come out=
 of=20
memory, and still be wrong on disk.=A0 =A0 If you won't want to to more=
 complicated=20
test it might be best to create the file, csum it and if it is ok umoun=
t the=20
device and remount it and csum it again and see, this should at least f=
orce it=20
to come off of disk again.

How much memory does your test machine have?


> Here is more information.
> setup: Created /dev/md0 of 30GB size , created ext3 files system. The=
n started SAMBA server to export mountded /dev/md0 to a windows machine=
 to run IO and copy files.
> 4K Page size:
> -------------------
> 1. IO Meter Test: Works just fine.

None of the benchmarks I am familiar with actually confirm that the dat=
a is=20
good, the only way one of the benchmarks will fail is if the file table=
 gets=20
corrupted, and they may run in cache.

> 2. Copied 1.8 GB file and check sum is good.
> 3. Performance is not good because of small page size.
> 16k Page size:
> ---------------------
> 1. RAID-5 fails some times with " Attempt to access beyond the end of=
 device"
> 2. Copied 128MB and 385MB file. Checked check sum, they are matching =
check sum.
> 3. Copied 1.8 GB file , this failed checksum test using "sum" command=
=2E I see "EXT3-fs errors".
> 64K Page size:
> ----------------------
> 1. RAID-5 failes some times with "Attempt to access beyond the end of=
 device"
> 2. Able to copy 128MB data and check sum test passed.
> 3. Copying 385MB and 1.8 GB file with EXT3-fs errors.
> Thanks,
> Marri

I would write directly to the /dev/mdx a specific pattern (a stream of =
binary=20
numbers from 1 ... whatever works fine), and then read that back and se=
e how=20
things match or don't.=A0 csum *can* fail, and if you have enough memor=
y then any=20
corruption actually on disk *WON'T* be found until somethings causes it=
 to be=20
ejected from cache, and then later re-read from disk.

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Roger

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
