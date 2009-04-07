From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 bug and/or e2fsck hole
Date: Tue, 07 Apr 2009 16:13:24 -0700
Message-ID: <20090407231324.GF3204@webber.adilger.int>
References: <20090407204811.GA4495@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33027 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbZDGXNc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 19:13:32 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n37NDRNA024203
	for <linux-ext4@vger.kernel.org>; Tue, 7 Apr 2009 16:13:27 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHR00B0071L7400@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 07 Apr 2009 16:13:27 -0700 (PDT)
In-reply-to: <20090407204811.GA4495@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 08, 2009  06:18 +0930, Kevin Shanahan wrote:
> I have a problem where my ext4 filesystem has been corrupted
> previously[1], but after being repaired by e2fsck problems still
> remain.
> 
> Previously, some corruption occured with the directory entries in this
> directory which e2fsck "fixed" and was happy that the fs was
> consistent, but things didn't quite get back to normal:
> 
> hermes:/srv/samba/local/apps/CIM8/Release-Notes# ls -l
> total 3120
> -rw-rw----+ 1 root          WUM3\it - dataadm   6320 2007-11-12 11:35 rb_200711_02.pdf
> sr-S-----x  1     167085146        3064914020      0 1988-03-09 06:02 rc_200705_01.pdf
> 
> Everything looks okay there except the one file with weird
> permissions, group and owner numbers. Look what happens when I try to
> delete the files from this directory:
> 
> hermes:/srv/samba/local/apps/CIM8/Release-Notes# rm *
> 
> The filesystem was read-write beforehand. Here's what showed up in syslog:
> 
> Apr  8 05:48:58 hermes kernel: attempt to access beyond end of device
> Apr  8 05:48:58 hermes kernel: dm-0: rw=0, want=824255763709960, limit=2147483648
> Apr  8 05:48:58 hermes kernel: EXT4-fs error (device dm-0): ext4_xattr_delete_inode: inode 383: block 103031970463744 read error
> Apr  8 05:48:58 hermes kernel: Aborting journal on device dm-0:8.
> Apr  8 05:48:58 hermes kernel: Remounting filesystem read-only
> Apr  8 05:48:58 hermes kernel: EXT4-fs error (device dm-0) in ext4_free_inode: Journal has aborted
> 
> So now I unmount and run fsck again:
> 
> hermes:~# e2fsck -p -f -v /dev/dm-0
> /dev/dm-0: recovering journal

What version of e2fsprogs is this?  It definitely appears that the
inode is corrupted (bad i_file_acl field), and e2fsck isn't fixing it.

Can you please dump this inode using "debugfs -c -R 'imap 383' /dev/dm-0"
and "dd if=/dev/dm-0 of=/tmp/bad_inode.383.bin bs=4k count=1 skip={blocknr}".

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

