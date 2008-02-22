From: Bas van Schaik <bas@tuxes.nl>
Subject: e2fsck dies with error "this should never happen!!!"
Date: Fri, 22 Feb 2008 13:07:13 +0100
Message-ID: <47BEBAF1.4090505@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from castor.sshunet.nl ([145.97.192.41]:51756 "EHLO
	castor.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYBVMHN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 07:07:13 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by castor.sshunet.nl (Postfix) with ESMTP id 9A9AE57C025
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 13:07:09 +0100 (CET)
Received: from castor.sshunet.nl ([127.0.0.1])
	by localhost (castor.sshunet.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7D5kap6i-wVQ for <linux-ext4@vger.kernel.org>;
	Fri, 22 Feb 2008 13:07:09 +0100 (CET)
Received: from guust.tuxes.nl (15pc197.sshunet.nl [145.97.197.15])
	by castor.sshunet.nl (Postfix) with ESMTP
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 13:07:09 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by guust.tuxes.nl (Postfix) with ESMTP id 2047FA8094
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 13:07:09 +0100 (CET)
Received: from guust.tuxes.nl ([127.0.0.1])
	by localhost (guust.tuxes.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KpvltXjVIPqE for <linux-ext4@vger.kernel.org>;
	Fri, 22 Feb 2008 13:07:07 +0100 (CET)
Received: from [192.168.101.4] (15pc197.sshunet.nl [145.97.197.15])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by guust.tuxes.nl (Postfix) with ESMTP id 3D70EA807E
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 13:07:07 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Currently, I have a big problem: e2fsck refuses to fix my currupted
filesystem...

The filesystem (about 3TB) is created on an LVM LV, which spans a number
of RAID5 arrays, for which the underlying devices are imported using ATA
over Ethernet. Because of some strange network failure, the filesystem
got corrupted and was remounted read-only.

e2fsck presented me really _a lot_ of errors, especially much duplicated
blocks. After fixing them all, e2fsck restarts the check and after a
while dies with "XXX should never happen!!!". The complete output:

> e2fsck 1.40-WIP (14-Nov-2006)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Directory inode 268451937 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451941 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451945 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451949 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451953 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451957 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451961 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451965 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451969 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451973 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451977 has an unallocated block #1.  Allocate? yes
>
> Directory inode 268451981 has an unallocated block #4.  Allocate? yes
>
> XXX should never happen!!!
> Aborted
>   

Furthermore I'm running the default Debian stable kernel 2.6.18.

When trying to mount the damaged filesystem and removing the directories
which were supposed to have problems (I saw some output about those
directories in earlier e2fsck runs), the filesystem of course reports
problems:

> # dmesg | tail
> kjournald starting.  Commit interval 10 seconds
> EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
> EXT3 FS on loop0, internal journal
> EXT3-fs: mounted filesystem with writeback data mode.
> EXT3-fs error (device loop0): ext3_free_inode: bit already cleared for
> inode 275087393
> Remounting filesystem read-only
>   

Can anyone please help me fix this filesystem? I will be on vacation
next week, so my reply might be a little bit late... Thanks!

Regards,

  -- Bas
