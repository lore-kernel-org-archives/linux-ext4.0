From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: ext4 metadata corruption bug?
Date: Wed, 23 Apr 2014 09:23:11 +0200
Message-ID: <20140423072311.GD10163@dot.freshdot.net>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:51606 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaDWH7x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2014 03:59:53 -0400
Content-Disposition: inline
In-Reply-To: <20140420163211.GT10985@gradx.cs.jhu.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 20, 2014 at 12:32:12PM -0400, Nathaniel W Filardo wrote:

> We just got
> > [817576.492013] EXT4-fs (vdd): pa ffff88000dea9b90: logic 0, phys. 1934464544, len 32
> > [817576.492468] EXT4-fs error (device vdd):
> > ext4_mb_release_inode_pa:3729: group 59035, free 14, pa_free 12

I'm jumping in on this thread as a co-worker pointed me to it after i
reported somewhere else about a similar ext4 metadata corruption issue
i'm running into.

Quite similar situation to the OP in this thread:
Linux QEMU 2.0.0~rc1+dfsg-0ubuntu3 running on 3.13.0, guest and host
both run Linux 3.13.0, guest has one 'big' volume (10T, 5.5T in use) as
/dev/vdb which in it's entirety is used as an ext4 filesystem. No
partitioning.

The trouble starts with:

| EXT4-fs (vdb): pa ffff880078754c30: logic 274378, phys. 1617823779, len 54
| EXT4-fs error (device vdb): ext4_mb_release_inode_pa:3729: group 49372, free 52, pa_free 50
| Aborting journal on device vdb-8.

After which the system remounts the disk read-only and logs some more
ext4 trouble which i've pasted here: https://8n1.org/9763/4928

The system doesn't crash as this isn't the "OS disk". Running fsck on
the disk reports bitmap corruption and some incorrect free block/inode
counts after which the FS seems to work again.

It only happens to the guest with the large disk. All the other guests
on the same hypervisor and the same backend storage have no issues at
all. No IO errors are logged other than the ext4 errors from the guest.
The workload on this guest is not at all spectacular. A bit of random IO
on a set of files, the rest is mostly archive and rarely touched.

HTH,
-Sander.
-- 
| You dig around for a while but you fail to find any treasure.
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
