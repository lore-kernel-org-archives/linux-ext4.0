From: Drew Reusser <dreusser@gmail.com>
Subject: Re: Issue with bad file system
Date: Mon, 19 Nov 2012 07:23:27 +0000
Message-ID: <CAPAnFc9axLdcQ0xsGKsqQ5jMVs13JjYv7JdJkc_Q6Kdwa56JiQ@mail.gmail.com>
References: <20121119063004.4845.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57569 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2KSHX3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 02:23:29 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so740362lbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Nov 2012 23:23:27 -0800 (PST)
In-Reply-To: <20121119063004.4845.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 6:30 AM, George Spelvin <linux@horizon.com> wrote:
> I'm sorry about your problems, but... a little more information
> please?
>
> Mount is very explicitly telling you that there's probably more
> information in the kernel logs.  It even gives the command to see it.
> WHY DIDN'T YOU INCLUDE IT?  <snark>Was it perhaps too subtle a hint?</snark>
>
> What kernel version are you running?  If it's a distribution kernel,
> what kernel?  What architecture?
>
> What does e2fsck say about the file system?
> What does dumpe4fs -h /dev/md0 show?
>
>
> The one odd thing I can see is that md devices *are* usually listed in
> /proc/partitions, but it's not showing up in yours.
>
> The output of "cat /proc/mdstat" would also be useful.


I did give you the error in the kernel log in the original email .. it
was in quotes (the very last line).  Here is more, along with some
superflous logs.  This was stop and a start of the raid array, and two
attempted mounts of the file system:

[264788.678322] md0: detected capacity change from 1999065055232 to 0
[264788.678330] md: md0 stopped.
[264788.678339] md: unbind<sda1>
[264788.680063] md: export_rdev(sda1)
[264788.680108] md: unbind<sde1>
[264788.684033] md: export_rdev(sde1)
[264788.684055] md: unbind<sdd1>
[264788.688534] md: export_rdev(sdd1)
[264788.688556] md: unbind<sdb1>
[264788.696025] md: export_rdev(sdb1)
[264800.331630] md: md0 stopped.
[264800.333015] md: bind<sdb1>
[264800.334507] md: bind<sdd1>
[264800.334790] md: bind<sde1>
[264800.334977] md: bind<sda1>
[264800.338578] bio: create slab <bio-1> at 1
[264800.341261] md/raid10:md0: active with 4 out of 4 devices
[264800.341293] md0: detected capacity change from 0 to 1999065055232
[264800.343496]  md0: unknown partition table
[264906.870361] EXT4-fs (md0): VFS: Can't find ext4 filesystem
[270145.600580] i2c i2c-0: >sendbytes: NAK bailout.
[270155.620473] i2c i2c-0: >sendbytes: NAK bailout.
[270155.621372] i2c i2c-0: >sendbytes: NAK bailout.
[270155.621948] i2c i2c-0: >sendbytes: NAK bailout.
[270155.622523] i2c i2c-0: >sendbytes: NAK bailout.
[270155.623099] i2c i2c-0: >sendbytes: NAK bailout.
[270155.623138] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a
monitor but no|invalid EDID
[270155.817233] i2c i2c-0: >sendbytes: NAK bailout.
[270155.829516] i2c i2c-0: >sendbytes: NAK bailout.
[270155.841186] i2c i2c-0: >sendbytes: NAK bailout.
[270155.841766] i2c i2c-0: >sendbytes: NAK bailout.
[270155.842342] i2c i2c-0: >sendbytes: NAK bailout.
[270155.842918] i2c i2c-0: >sendbytes: NAK bailout.
[270155.843493] i2c i2c-0: >sendbytes: NAK bailout.
[270155.977230] i2c i2c-0: >sendbytes: NAK bailout.
[270155.989185] i2c i2c-0: >sendbytes: NAK bailout.
[270155.989762] i2c i2c-0: >sendbytes: NAK bailout.
[270155.991786] i2c i2c-0: >sendbytes: NAK bailout.
[270155.992386] i2c i2c-0: >sendbytes: NAK bailout.
[270155.993288] i2c i2c-0: >sendbytes: NAK bailout.
[270155.993864] i2c i2c-0: >sendbytes: NAK bailout.
[270155.994440] i2c i2c-0: >sendbytes: NAK bailout.
[270303.640240] EXT4-fs (md0): VFS: Can't find ext4 filesystem


I am running this on Linux Mint 12 .. I don't know the kernel version
as I cannot boot so I am booting of whatever I downloaded from Mint's
website (13 rc I think) off a pen drive to try and save my data.

mint mnt # uname -a
Linux mint 3.5.0-17-generic #28-Ubuntu SMP Tue Oct 9 19:31:23 UTC 2012
x86_64 x86_64 x86_64 GNU/Linux


I ran the cat of /proc/partitions and copied the data from previous
emails to the linux-raid DL (which forwarded me onto this one).  Must
have gotten it before the raid was working.  Here is an updated one.

mint mnt # cat /proc/partitions
major minor  #blocks  name

   7        0     939820 loop0
   8        0  976762584 sda
   8        1  976760832 sda1
   8       16  976762584 sdb
   8       17  976237568 sdb1
   8       32    1985024 sdc
   8       33    1984960 sdc1
   8       48  976762584 sdd
   8       49  976760832 sdd1
   8       64  976762584 sde
   8       65  976237568 sde1
  11        0    1048575 sr0
   8       80 1953514584 sdf
   8       81 1953512448 sdf1
   9        0 1952211968 md0


mint mnt # cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sda1[0] sde1[3] sdd1[2] sdb1[1]
      1952211968 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]

unused devices: <none>


Can you give me specific e2fsck commands to run which will not ruin my
disks and data?  I have seen people online recommending re-writing the
super blocks but I am now sure I want to write anything until I know
it will not damage something and erase my data.

as for the last command you asked .. can you give me more info on it?

mint mnt # dumpe4fs -h /dev/md0
No command 'dumpe4fs' found, did you mean:
 Command 'dumpe2fs' from package 'e2fsprogs' (main)
dumpe4fs: command not found
mint mnt # apt-get install dume4fs
Reading package lists... Done
Building dependency tree
Reading state information... Done
E: Unable to locate package dume4fs


if you meant dumpe2fs ... here is the output.

mint mnt # dumpe2fs -h /dev/md0
dumpe2fs 1.42.5 (29-Jul-2012)
dumpe2fs: Bad magic number in super-block while trying to open /dev/md0
Couldn't find valid filesystem superblock.
