From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: ext4 metadata corruption bug bites again
Date: Fri, 21 Aug 2015 11:45:34 +0200
Message-ID: <20150821094534.GD20572@dot.dmz.freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:55429 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbbHUKWR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Aug 2015 06:22:17 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

On April 20th, 2014 there was a thread on this list w. Nathanial W
Filardo, Theodore Tso and myself about ext4 metadata corruption on large
ext4 volumes. See http://marc.info/?l=linux-ext4&m=139878494527370&w=2
and further messages from the archives.

A bit of debugging was done, i fell out of that loop as my problems
seemed to have disappeared with further kernel updates from my distro,
but recently these issues seem to have re-appeared (or they never went
away and i just didn't hit this specific bug-trigger-situation?).

Again i'm getting sporadic fs errors like this most recent one:
(More of these i've pasted at https://8n1.org/10745/cc34)
| [000d00h01m43s] EXT4-fs error (device vdb): ext4_mb_generate_buddy:757:
|   group 79842, block bitmap and bg descriptor inconsistent: 10073 vs 10071
|   free clusters
| [000d00h01m43s] Aborting journal on device vdb-8.

An e2fsck run shows:
| Pass 5: Checking group summary information
| Block bitmap differences:  +(2616281446--2616281447)
| Fix? yes
| 
| Free blocks count wrong (170942497, counted=129906218).
| Fix? yes
| 
| Free inodes count wrong (670863012, counted=670860975).
| Fix? yes

My setup is largely the same, storage wise. Updated kernels here and
there, and the storage device /dev/vdb has grown to 10TiB which i
still use unpartitioned in this VM.

The VM is now running 3.19.0-25-generic #26-Ubuntu SMP Fri Jul 24
21:17:31 UTC 2015 x86_64


I'm able and willing to run patched kernels to trace this further.
Please advise.


With regards,
-Sander.
-- 
| > > Isn't this a stupid question?
| > Isn't this a stupid answer?
| No, it was another stupid question. This is the stupid answer. 
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
