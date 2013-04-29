From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: EXT4 Strange FSCK Behavior
Date: Mon, 29 Apr 2013 01:45:05 +0100
Message-ID: <003801ce4472$cad859e0$60890da0$@ntlworld.com>
Reply-To: <techweb@ntlworld.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:59483 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3D2Aow (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2013 20:44:52 -0400
Received: by mail-wg0-f47.google.com with SMTP id j13so3172606wgh.2
        for <linux-ext4@vger.kernel.org>; Sun, 28 Apr 2013 17:44:51 -0700 (PDT)
References: 
In-Reply-To: 
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I thought I'd reach out to your guys as trawling various forums and docs has
not really got me any further. It may also be a possible bug.

Just rebooted my box today after 200 days uptime and thought I'd request a
volume scan and it found errors! I've never had a power outage etc so am
keen to know what could have caused this file system corruption? Anyu
ideas???

I'm running 4.2.21 on a ReadyNAS Pro6, but ultimately it is a Linux (Debian)
2.6.37.6. based system underneath. 

***** File system check forced at Fri Apr 26 20:08:38 WEST 2013 ***** fsck
1.41.14 (22-Dec-2010) e2fsck 1.42.3 (14-May-2012) Pass 1: Checking inodes,
blocks, and sizes Inode 4195619, i_blocks is 3135728, should be 3135904.
Fix? yes


Running additional passes to resolve blocks claimed by more than one
inode...
Pass 1B: Rescanning for multiply-claimed blocks Multiply-claimed block(s) in
inode 4195619: 167904376 167904377 167904378 167904379 167904380 167904381
167904382 167904383 167904384 167904385 167904386 167949296 167949297
167949298 167949299 167949300 167949301 167949302 167949303 167949304
167949305 167949306 Pass 1C: Scanning directories for inodes with
multiply-claimed blocks Pass 1D: Reconciling multiply-claimed blocks (There
are 1 inodes containing multiply-claimed blocks.)

File /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode
#4195619, mod time Fri Apr 26 20:07:42 2013)
has 22 multiply-claimed block(s), shared with 0 file(s):
Multiply-claimed blocks already reassigned or cloned.

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/c/c: ***** FILE SYSTEM WAS MODIFIED *****
/dev/c/c: 615898/30212096 files (13.6% non-contiguous), 62353456/483393536
blocks

I'm curious to know what this is all about, shared with 0 files!!!!:

File /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode
#4195619, mod time Fri Apr 26 20:07:42 2013)
has 22 multiply-claimed block(s), shared with 0 file(s):
Multiply-claimed blocks already reassigned or cloned.


Every follow on boot with FSCK yields the following:


***** File system check forced at Fri Apr 26 20:21:42 WEST 2013 ***** fsck
1.41.14 (22-Dec-2010) e2fsck 1.42.3 (14-May-2012) Pass 1: Checking inodes,
blocks, and sizes

Running additional passes to resolve blocks claimed by more than one
inode...
Pass 1B: Rescanning for multiply-claimed blocks Multiply-claimed block(s) in
inode 4195619: 167904376 167904377 167904378 167904379 167904380 167904381
167904382 167904383 167904384 167904385 167904386 167949296 167949297
167949298 167949299 167949300 167949301 167949302 167949303 167949304
167949305 167949306 Pass 1C: Scanning directories for inodes with
multiply-claimed blocks Pass 1D: Reconciling multiply-claimed blocks (There
are 1 inodes containing multiply-claimed blocks.)

File /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode
#4195619, mod time Fri Apr 26 20:07:42 2013)
has 22 multiply-claimed block(s), shared with 0 file(s):
Multiply-claimed blocks already reassigned or cloned.

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/c/c: 615898/30212096 files (13.6% non-contiguous), 62353456/483393536
blocks

Still same thing with multiply claimed blocks but to say they are shared
with 0 files makes no sense! And... Surely this should be corrected by FSCK?

Smart logs are all good.... It was one of the first things I checked.

Thanks...

