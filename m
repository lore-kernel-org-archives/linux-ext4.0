From: Andres Freund <andres@anarazel.de>
Subject: Re: EXT4 ENOSPC Bug
Date: Mon, 16 Feb 2009 12:37:19 +0100
Message-ID: <49994FEF.2020908@anarazel.de>
References: <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.anarazel.de ([217.115.131.40]:34717 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZBPLru (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2009 06:47:50 -0500
In-Reply-To: <200812100108.04163.andres@anarazel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

"Luckily", to prove that I am not completly mad I recently found this 
problem again. On a more recent kernel:
2.6.29-rc3-andres-00498-g68e80d5
(upstream 2.6.29 + Theodore's ext4 debug patches)

Again I got:
open("/home/andres/tt", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) = -1 
ENOSPC (No space left on device)

When doing `touch /home/andres/tt`

Again df does not show something suspicious:
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/root_crypt
                      19234816  826296 18408520    5% /
tmpfs                 491025       3  491022    1% /lib/init/rw
varrun                491025      96  490929    1% /var/run
varlock               491025       3  491022    1% /var/lock
udev                  491025    5517  485508    2% /dev
tmpfs                 491025       1  491024    1% /dev/shm
/dev/sda2              61312     110   61202    1% /boot

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/root_crypt
                      302855628 202819548 100036080  67% /
tmpfs                  1964100         0   1964100   0% /lib/init/rw
varrun                 1964100       300   1963800   1% /var/run
varlock                1964100         0   1964100   0% /var/lock
udev                   1964100        92   1964008   1% /dev
tmpfs                  1964100         0   1964100   0% /dev/shm
/dev/sda2               964532    634052    281484  70% /boot

Delayed allocations are not showing anything suspicious:
[72586.050538] ext4 debug delalloc of dm-0
[72586.050547] ext4: dirty blocks 22 free blocks 25008749
[72586.050551] s_dirty list:
[72586.050556] ino 534064: 2 2
[72586.050559] ino 539981: 2 2
[72586.050563] ino 524506: 5 2
[72586.050566] ino 184479: 1 2
[72586.050571] ino 167172: 2 2
[72586.050574] ext4 debug delalloc done


Any debugging ideas?

I got this twice in the last two months, so its not really easy to 
reproduce :-(

Andres

PS: All information is taken out of the running kernel while having the 
problem

meminfo:
MemTotal:        3928200 kB
MemFree:           23312 kB
Buffers:          239564 kB
Cached:          2383280 kB
SwapCached:            0 kB
Active:          1490948 kB
Inactive:        2149360 kB
Active(anon):     879880 kB
Inactive(anon):   294356 kB
Active(file):     611068 kB
Inactive(file):  1855004 kB
Unevictable:          52 kB
Mlocked:              52 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                52 kB
Writeback:             4 kB
AnonPages:       1017356 kB
Mapped:           129440 kB
Slab:             123316 kB
SReclaimable:      94512 kB
SUnreclaim:        28804 kB
PageTables:        26936 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1964100 kB
Committed_AS:    1169664 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      341580 kB
VmallocChunk:   34359392035 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       86016 kB
DirectMap2M:     4003840 kB
