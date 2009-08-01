From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
Date: Sat, 1 Aug 2009 14:30:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0908011427270.5831@bogon.housecafe.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.GwE.OIObKB@chimera> <alpine.DEB.2.00.0907261628180.17123@chino.kir.corp.google.com> <200907280021.26320.rjw@sisk.pl> <alpine.DEB.2.00.0907300021330.7540@chino.kir.corp.google.com>
 <alpine.DEB.2.01.0908010046430.5831@bogon.housecafe.de> <alpine.DEB.2.00.0908010231560.1019@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZHAVat (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Aug 2009 17:30:49 -0400
In-Reply-To: <alpine.DEB.2.00.0908010231560.1019@chino.kir.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 1 Aug 2009 at 12:56, David Rientjes wrote:
> This is a different issue than bug 13666, this is in the ext4 mount code 
> (which can also probably happen with other filesystems as well).

OK, thanks for clarifying this.

> What are your mount options?  It appears that they are causing the parser 
> to allocate far more memory than it should ever need.

This was the first time I mounted this ext4 fileystem since the reboot 
with the new kernel:

/dev/mapper/wdc0 /mnt/disk0 ext4 rw,nosuid,nodev,noexec,relatime,barrier=1,data=ordered 0 0

Christian.

/proc/meminfo now looks like this, I don't have the output what it loooked 
like right after the WARNING though:

bkp:~$ cat /proc/meminfo 
MemTotal:        1024968 kB
MemFree:           14164 kB
Buffers:           24800 kB
Cached:           864356 kB
SwapCached:          852 kB
Active:           472728 kB
Inactive:         506644 kB
Active(anon):      42780 kB
Inactive(anon):    48164 kB
Active(file):     429948 kB
Inactive(file):   458480 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:        129864 kB
HighFree:            252 kB
LowTotal:         895104 kB
LowFree:           13912 kB
SwapTotal:       1048568 kB
SwapFree:        1046780 kB
Dirty:             89408 kB
Writeback:           100 kB
AnonPages:         89592 kB
Mapped:             7664 kB
Slab:              20476 kB
SReclaimable:      12368 kB
SUnreclaim:         8108 kB
PageTables:         1496 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1561052 kB
Committed_AS:    1043668 kB
VmallocTotal:     122880 kB
VmallocUsed:        3436 kB
VmallocChunk:     108664 kB
DirectMap4k:       12280 kB
DirectMap4M:      897024 kB

-- 
BOFH excuse #159:

Stubborn processes
