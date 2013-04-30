From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: 2nd Attempt - FSCK Errors
Date: Tue, 30 Apr 2013 15:00:24 +0100
Message-ID: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com>
Reply-To: <techweb@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51495 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758151Ab3D3OA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Apr 2013 10:00:26 -0400
Received: by mail-wg0-f42.google.com with SMTP id m15so3009514wgh.5
        for <linux-ext4@vger.kernel.org>; Tue, 30 Apr 2013 07:00:25 -0700 (PDT)
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2nd Attempt=E2=80=A6

=46rom: Stephen Elliott [mailto:techweb@ntlworld.com]=20
Sent: 26 April 2013 22:37
To: 'linux-ext4@vger.kernel.org'
Subject: FSCK Errors

Hi all,

Just rebooted my box today after 200 days uptime and thought I'd reques=
t a volume scan and it found errors! I've never had a power outage etc =
so am keen to know what could have caused this file system corruption? =
Anyu ideas???

I'm running 4.2.21 on a ReadyNAS Pro6, but ultimately it is a Linux (De=
bian) 2.6.37.6. based system underneath.=20

***** File system check forced at Fri Apr 26 20:08:38 WEST 2013 ***** f=
sck 1.41.14 (22-Dec-2010) e2fsck 1.42.3 (14-May-2012) Pass 1: Checking =
inodes, blocks, and sizes Inode 4195619, i_blocks is 3135728, should be=
 3135904. Fix? yes


Running additional passes to resolve blocks claimed by more than one in=
ode...
Pass 1B: Rescanning for multiply-claimed blocks Multiply-claimed block(=
s) in inode 4195619: 167904376 167904377 167904378 167904379 167904380 =
167904381 167904382 167904383 167904384 167904385 167904386 167949296 1=
67949297 167949298 167949299 167949300 167949301 167949302 167949303 16=
7949304 167949305 167949306 Pass 1C: Scanning directories for inodes wi=
th multiply-claimed blocks Pass 1D: Reconciling multiply-claimed blocks=
 (There are 1 inodes containing multiply-claimed blocks.)

=46ile /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode =
#4195619, mod time Fri Apr 26 20:07:42 2013)
has 22 multiply-claimed block(s), shared with 0 file(s):
Multiply-claimed blocks already reassigned or cloned.

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/c/c: ***** FILE SYSTEM WAS MODIFIED *****
/dev/c/c: 615898/30212096 files (13.6% non-contiguous), 62353456/483393=
536 blocks

I'm curious to know what this is all about, shared with 0 files!!!!:

=46ile /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode =
#4195619, mod time Fri Apr 26 20:07:42 2013)
has 22 multiply-claimed block(s), shared with 0 file(s):
Multiply-claimed blocks already reassigned or cloned.


Every follow on boot with FSCK yields the following:


***** File system check forced at Fri Apr 26 20:21:42 WEST 2013 ***** f=
sck 1.41.14 (22-Dec-2010) e2fsck 1.42.3 (14-May-2012) Pass 1: Checking =
inodes, blocks, and sizes

Running additional passes to resolve blocks claimed by more than one in=
ode...
Pass 1B: Rescanning for multiply-claimed blocks Multiply-claimed block(=
s) in inode 4195619: 167904376 167904377 167904378 167904379 167904380 =
167904381 167904382 167904383 167904384 167904385 167904386 167949296 1=
67949297 167949298 167949299 167949300 167949301 167949302 167949303 16=
7949304 167949305 167949306 Pass 1C: Scanning directories for inodes wi=
th multiply-claimed blocks Pass 1D: Reconciling multiply-claimed blocks=
 (There are 1 inodes containing multiply-claimed blocks.)

=46ile /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode =
#4195619, mod time Fri Apr 26 20:07:42 2013)
  has 22 multiply-claimed block(s), shared with 0 file(s):
Multiply-claimed blocks already reassigned or cloned.

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/c/c: 615898/30212096 files (13.6% non-contiguous), 62353456/483393=
536 blocks

Still same thing with multiply claimed blocks :)=E2=98=B9

Any ideas?

Many Thanks
Stephen Elliott=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
