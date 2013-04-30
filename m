From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 2nd Attempt - FSCK Errors
Date: Tue, 30 Apr 2013 10:14:41 -0600
Message-ID: <CAFB1F4E-F086-4712-B70D-74F85F3BFDAE@dilger.ca>
References: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "<linux-ext4@vger.kernel.org>" <linux-ext4@vger.kernel.org>
To: "<techweb@ntlworld.com>" <techweb@ntlworld.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36724 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760865Ab3D3QOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Apr 2013 12:14:45 -0400
Received: by mail-pa0-f52.google.com with SMTP id fb10so433850pad.39
        for <linux-ext4@vger.kernel.org>; Tue, 30 Apr 2013 09:14:44 -0700 (PDT)
In-Reply-To: <007b01ce45ab$0ffc24f0$2ff46ed0$@ntlworld.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-30, at 8:00, "Stephen Elliott" <techweb@ntlworld.com> wrote:
> Just rebooted my box today after 200 days uptime and thought I'd request a volume scan and it found errors! I've never had a power outage etc so am keen to know what could have caused this file system corruption? Anyu ideas???
> 
> I'm running 4.2.21 on a ReadyNAS Pro6, but ultimately it is a Linux (Debian) 2.6.37.6. based system underneath. 
> 
> ***** File system check forced at Fri Apr 26 20:08:38 WEST 2013 ***** fsck 1.41.14 (22-Dec-2010) e2fsck 1.42.3 (14-May-2012) Pass 1: Checking inodes, blocks, and sizes Inode 4195619, i_blocks is 3135728, should be 3135904. Fix? yes

This is because the inode shows 176 sectors = 22 filesystem blocks
allocated than expected. Is this perhaps an extent format file? Try
"lsattr {filename}" and look for "e" in the file flags. 

> Running additional passes to resolve blocks claimed by more than one inode...
> Pass 1B: Rescanning for multiply-claimed blocks Multiply-claimed block(s) in inode 4195619: 167904376 167904377 167904378 167904379 167904380 167904381 167904382 167904383 167904384 167904385 167904386 167949296 167949297 167949298 167949299 167949300 167949301 167949302 167949303 167949304 167949305 167949306 Pass 1C: Scanning directories for inodes with multiply-claimed blocks Pass 1D: Reconciling multiply-claimed blocks (There are 1 inodes containing multiply-claimed blocks.

This is consistent with the one inode suddenly growing 22 blocks longer. 

> File /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode #4195619, mod time Fri Apr 26 20:07:42 2013)
> has 22 multiply-claimed block(s), shared with 0 file(s):
> Multiply-claimed blocks already reassigned or cloned.

This could be failing if the duplicate blocks are inside the same file?
I don't know if that is something that e2fsck expects or not?  I wonder
if the extent tree is corrupted in some manner, but it isn't being detected
during the duplicate block scan.

This file looks big and important, so the first thing I would suggest is to
make a backup copy of it ASAP if you haven't already (having a
backup is always a good idea). Then, I'd suggest to update to
the latest e2fsprogs 1.42.7 and try again, since there was a
bug fixed in the e2fsck extent handling.

If that doesn't fix it, please dump the allocated file blocks with
"debugfs -c -R 'stat <4195619>' /dev/c/c" so we can see
what it looks like (probably gzipped
and as an attachment, since
it will be pretty large).

Cheers, Andreas