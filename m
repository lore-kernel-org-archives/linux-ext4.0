From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: RE: 2nd Attempt - FSCK Errors
Date: Tue, 30 Apr 2013 18:58:40 +0100
Message-ID: <008d01ce45cc$5974b9f0$0c5e2dd0$@ntlworld.com>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com> <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca>
Reply-To: <techweb@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-ext4@vger.kernel.org>
To: "'Andreas Dilger'" <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:42193 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760692Ab3D3R6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Apr 2013 13:58:43 -0400
Received: by mail-wg0-f53.google.com with SMTP id z11so759326wgg.32
        for <linux-ext4@vger.kernel.org>; Tue, 30 Apr 2013 10:58:41 -0700 (PDT)
In-Reply-To: 
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

To further add, I ran the debugfs on the backup server but the output was
strange:

chaos:~# ls -i  /c/PREMIER
11141250 Premier Automation Purchase OrdersApp V18.5_Backup.mdb
11141790 Premier Automation Purchase OrdersApp V18.5.ldb
11142379 Premier Automation Purchase OrdersApp V18.5.mdb
11142332 PremierData.ldb
11142439 PremierData.mdb
11141128 Premier Y
11141129 Robots Bakups DO NOT USE SEE PDW
11141130 UpdateDrivers
11141252 Wkb.xwb
11141253 Workbench.xwb

chaos:~# [3Pmount /dev/c/c

chaos:~# debugfs -c -R stat '<11142379>'
/dev/c/c[1P[1@'
debugfs 1.41.14 (22-Dec-2010)
/dev/c/c: catastrophic mode - not reading inode or group bitmaps
Inode: 11142379   Type: bad type    Mode:  0000   Flags: 0x0
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x00000000 -- Thu Jan  1 00:00:00 1970
atime: 0x00000000 -- Thu Jan  1 00:00:00 1970
mtime: 0x00000000 -- Thu Jan  1 00:00:00 1970
Size of extra inode fields: 0
BLOCKS:

I suspect there may be another issue here with this tool on the ReadyNAS
devices.

Many Thanks
Stephen Elliott

-----Original Message-----
From: Stephen Elliott [mailto:techweb@ntlworld.com] 
Sent: 30 April 2013 17:26
To: 'Andreas Dilger'
Cc: '<linux-ext4@vger.kernel.org>'
Subject: RE: 2nd Attempt - FSCK Errors

Hi,

Appreciate the help...

As requested:

despair:/c/PREMIER# lsattr "Premier Automation Purchase OrdersApp V18.5.mdb"
-------------e- Premier Automation Purchase OrdersApp V18.5.mdb

What does this mean???

The file is important as it is an Orders database and is backed up daily :)
So far no actual issues experienced with using the file (MS Access DB)

I can perhaps run that debugfs command but to be clear I assume there is no
risk providing I unmount the FS beforehand? How big is the file generated
likely to be, ball park? 

As for the other options of updating, I am somewhat bound by the FW versions
the ReadyNAS units use, unless I start messing with it, which would likely
void any warranty anyway.

Many Thanks
Stephen Elliott

-----Original Message-----
From: Andreas Dilger [mailto:adilger@dilger.ca]
Sent: 30 April 2013 17:15
To: <techweb@ntlworld.com>
Cc: <linux-ext4@vger.kernel.org>
Subject: Re: 2nd Attempt - FSCK Errors

On 2013-04-30, at 8:00, "Stephen Elliott" <techweb@ntlworld.com> wrote:
> Just rebooted my box today after 200 days uptime and thought I'd request a
volume scan and it found errors! I've never had a power outage etc so am
keen to know what could have caused this file system corruption? Anyu
ideas???
> 
> I'm running 4.2.21 on a ReadyNAS Pro6, but ultimately it is a Linux
(Debian) 2.6.37.6. based system underneath. 
> 
> ***** File system check forced at Fri Apr 26 20:08:38 WEST 2013 ***** 
> fsck 1.41.14 (22-Dec-2010) e2fsck 1.42.3 (14-May-2012) Pass 1:
> Checking inodes, blocks, and sizes Inode 4195619, i_blocks is 3135728, 
> should be 3135904. Fix? yes

This is because the inode shows 176 sectors = 22 filesystem blocks allocated
than expected. Is this perhaps an extent format file? Try "lsattr
{filename}" and look for "e" in the file flags. 

> Running additional passes to resolve blocks claimed by more than one
inode...
> Pass 1B: Rescanning for multiply-claimed blocks Multiply-claimed block(s)
in inode 4195619: 167904376 167904377 167904378 167904379 167904380
167904381 167904382 167904383 167904384 167904385 167904386 167949296
167949297 167949298 167949299 167949300 167949301 167949302 167949303
167949304 167949305 167949306 Pass 1C: Scanning directories for inodes with
multiply-claimed blocks Pass 1D: Reconciling multiply-claimed blocks (There
are 1 inodes containing multiply-claimed blocks.

This is consistent with the one inode suddenly growing 22 blocks longer. 

> File /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode 
> #4195619, mod time Fri Apr 26 20:07:42 2013) has 22 multiply-claimed
block(s), shared with 0 file(s):
> Multiply-claimed blocks already reassigned or cloned.

This could be failing if the duplicate blocks are inside the same file?
I don't know if that is something that e2fsck expects or not?  I wonder if
the extent tree is corrupted in some manner, but it isn't being detected
during the duplicate block scan.

This file looks big and important, so the first thing I would suggest is to
make a backup copy of it ASAP if you haven't already (having a backup is
always a good idea). Then, I'd suggest to update to the latest e2fsprogs
1.42.7 and try again, since there was a bug fixed in the e2fsck extent
handling.

If that doesn't fix it, please dump the allocated file blocks with "debugfs
-c -R 'stat <4195619>' /dev/c/c" so we can see what it looks like (probably
gzipped and as an attachment, since it will be pretty large).

Cheers, Andreas=

