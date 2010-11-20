From: Jordan Russell <jr-list-2010@quo.to>
Subject: Garbage returned in nanosecond component of timestamps
Date: Sat, 20 Nov 2010 00:22:48 -0600
Message-ID: <4CE76938.8050304@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dizzy.i200.net ([74.86.142.210]:57063 "EHLO dizzy.i200.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab0KTGdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Nov 2010 01:33:07 -0500
Received: from webby.quo.to (cpe-76-183-73-96.tx.res.rr.com [76.183.73.96])
	by dizzy.i200.net (Postfix) with ESMTP id 9B1A3530070
	for <linux-ext4@vger.kernel.org>; Sat, 20 Nov 2010 00:22:49 -0600 (CST)
Received: from fishy.local (fishy.local [10.70.77.9])
	by webby.quo.to (Postfix) with ESMTP id 38E5568390
	for <linux-ext4@vger.kernel.org>; Sat, 20 Nov 2010 00:22:49 -0600 (CST)
Received: from [10.70.77.15] (unknown [10.70.77.15])
	by fishy.local (Postfix) with ESMTP id 1E058AE436
	for <linux-ext4@vger.kernel.org>; Sat, 20 Nov 2010 00:22:49 -0600 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Fedora 14 with vendor kernel 2.6.35.6-48.fc14.i686.PAE]

When nanosecond timestamp resolution isn't supported on an ext4
partition (inode size = 128), stat() appears to be returning
uninitialized garbage in the nanosecond component of timestamps.

See the following tests.
Expected: All timestamps should end with '.0000000000'.
Actual: '.0026721629' popping up on a different file each time.

> # tune2fs -l /dev/md0 | fgrep 'Inode size'
> Inode size:               128
> # echo 3 >/proc/sys/vm/drop_caches
> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
> Wed Nov  4 16:53:20.0026721629 2009 - /boot/oldconfigs/config-2.6.27.38-170.2.113.fc10.i686.PAE
> # echo 3 >/proc/sys/vm/drop_caches
> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
> Thu Nov  8 20:38:30.0026721629 2007 - /boot/oldconfigs/config-2.6.23.1-49.fc8PAE
> # echo 3 >/proc/sys/vm/drop_caches
> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
> Thu Aug 12 17:44:51.0026721629 2010 - /lib/firmware/emi26/bitstream.fw
> # echo 3 >/proc/sys/vm/drop_caches
> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
> Thu Aug 12 17:44:51.0026721629 2010 - /lib/firmware/slicoss/gbdownload.sys
> # echo 3 >/proc/sys/vm/drop_caches
> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
> Fri Nov  5 01:16:32.0026721629 2010 - /boot/grub/e2fs_stage1_5


Shouldn't EXT4_INODE_GET_XTIME zero out tv_nsec when EXT4_FITS_IN_INODE
evaluates to false...?

> #define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)                          \
> do {                                                                           \
>         (inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
>         if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
>                 ext4_decode_extra_time(&(inode)->xtime,                        \
>                                        raw_inode->xtime ## _extra);            \
> } while (0)

-- 
Jordan Russell
