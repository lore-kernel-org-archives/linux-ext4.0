From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v5 0/4] crc32c: Add faster algorithm and self-test code
Date: Thu, 6 Oct 2011 13:20:42 -0700
Message-ID: <20111006202042.GD12447@tux1.beaverton.ibm.com>
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46767 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab1JFUUh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Oct 2011 16:20:37 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Thu, 6 Oct 2011 16:20:36 -0400
Content-Disposition: inline
In-Reply-To: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 04, 2011 at 04:53:57PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
> software crc32c implementation.  It requires that all ten of his patches (at
> least the ones dated 31 Aug 2011) be applied.  It removes the crc32c
> implementation in crypto/ in favor of using the stamped-out one in lib/.  There
> is also a change to Kconfig so that the kernel builder can pick an
> implementation best suited for the hardware.
> 
> The motivation for this patchset is that I am working on adding full metadata
> checksumming to ext4.  As far as performance impact of adding checksumming
> goes, I see nearly no change with a standard mail server ffsb simulation.  On a
> test that involves only file creation and deletion and extent tree writes, I
> see a drop of about 50 pcercent with the current kernel crc32c implementation;
> this improves to a drop of about 20 percent with the enclosed crc32c code.
> 
> When metadata is usually a small fraction of total IO, this new implementation
> doesn't help much because metadata is usually a small fraction of total IO.
> However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
> tree), then this patch speeds up the operation substantially.
> 
> Incidentally, given that iscsi, sctp, and btrfs also use crc32c, this patchset
> should improve their speed as well.  I have not yet quantified that, however.

As for Mr. Tjernlund's unresolved questions regarding the v4 patch, I have
tested this new code on x64/x32/ppc32/ppc64 and it seems to work fine, both
with the crc32c selftest and also on a practical level with ext4 metadata
checksumming enabled.  Updating to Bob's newest calculation code brings about a
10-15% speedup on the ppc64 box.  I also see that slice-by-8 is about 20%
faster than slice-by-4 on my ppc32 box.

I did _not_ see any failures on ppc32 when running an extended ext4+checksum
test suite.

Details of the ppc32 box:
root@dyn9047029101:~# cat /proc/cpuinfo 
processor	: 0
cpu		: 740/750
temperature 	: 45 C (uncalibrated)
clock		: 500.000000MHz
revision	: 131.0 (pvr 0008 8300)
bogomips	: 49.86

total bogomips	: 49.86
timebase	: 24934966
platform	: PowerMac
model		: PowerMac1,1
machine		: PowerMac1,1
motherboard	: PowerMac1,1 MacRISC Power Macintosh
detected as	: 66 (Blue&White G3)
pmac flags	: 00000000
L2 cache	: 1024K unified
pmac-generation	: NewWorld
Memory		: 896 MB
root@dyn9047029101:~# gcc --version
gcc-4.4.real (Ubuntu 4.4.3-4ubuntu5) 4.4.3
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
root@dyn9047029101:~# for i in /sys/devices/system/cpu/cpu0/cache/*/*; do echo $i $(cat $i); done
/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size 32
/sys/devices/system/cpu/cpu0/cache/index0/level 1
/sys/devices/system/cpu/cpu0/cache/index0/number_of_sets 128
/sys/devices/system/cpu/cpu0/cache/index0/shared_cpu_map 00000000,00000000,00000000,00000001
/sys/devices/system/cpu/cpu0/cache/index0/size 32K
/sys/devices/system/cpu/cpu0/cache/index0/type Data
/sys/devices/system/cpu/cpu0/cache/index0/ways_of_associativity 8
/sys/devices/system/cpu/cpu0/cache/index1/coherency_line_size 32
/sys/devices/system/cpu/cpu0/cache/index1/level 1
/sys/devices/system/cpu/cpu0/cache/index1/number_of_sets 128
/sys/devices/system/cpu/cpu0/cache/index1/shared_cpu_map 00000000,00000000,00000000,00000001
/sys/devices/system/cpu/cpu0/cache/index1/size 32K
/sys/devices/system/cpu/cpu0/cache/index1/type Instruction
/sys/devices/system/cpu/cpu0/cache/index1/ways_of_associativity 8
/sys/devices/system/cpu/cpu0/cache/index2/coherency_line_size 128
/sys/devices/system/cpu/cpu0/cache/index2/level 2
/sys/devices/system/cpu/cpu0/cache/index2/number_of_sets 4096
/sys/devices/system/cpu/cpu0/cache/index2/shared_cpu_map 00000000,00000000,00000000,00000001
/sys/devices/system/cpu/cpu0/cache/index2/size 1024K
/sys/devices/system/cpu/cpu0/cache/index2/type Unified
/sys/devices/system/cpu/cpu0/cache/index2/ways_of_associativity 2

The ppc64 box:
root@elm3c7:~# cat /proc/cpuinfo 
processor	: 0
cpu		: POWER5+ (gs)
clock		: 1900.098000MHz
revision	: 2.0 (pvr 003b 0200)

(the rest is omitted for brevity)

root@elm3c7:~# gcc --version
gcc-4.4.real (Ubuntu 4.4.3-4ubuntu5) 4.4.3
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

root@elm3c7:~# for i in /sys/devices/system/cpu/cpu0/cache/*/*; do echo $i $(cat $i); done
/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size 128
/sys/devices/system/cpu/cpu0/cache/index0/level 1
/sys/devices/system/cpu/cpu0/cache/index0/number_of_sets 64
/sys/devices/system/cpu/cpu0/cache/index0/shared_cpu_map 00000000,00000000,00000000,00000001
/sys/devices/system/cpu/cpu0/cache/index0/size 32K
/sys/devices/system/cpu/cpu0/cache/index0/type Data
/sys/devices/system/cpu/cpu0/cache/index0/ways_of_associativity 4
/sys/devices/system/cpu/cpu0/cache/index1/coherency_line_size 128
/sys/devices/system/cpu/cpu0/cache/index1/level 1
/sys/devices/system/cpu/cpu0/cache/index1/number_of_sets 256
/sys/devices/system/cpu/cpu0/cache/index1/shared_cpu_map 00000000,00000000,00000000,00000001
/sys/devices/system/cpu/cpu0/cache/index1/size 64K
/sys/devices/system/cpu/cpu0/cache/index1/type Instruction
/sys/devices/system/cpu/cpu0/cache/index1/ways_of_associativity 2
/sys/devices/system/cpu/cpu0/cache/index2/coherency_line_size 128
/sys/devices/system/cpu/cpu0/cache/index2/level 2
/sys/devices/system/cpu/cpu0/cache/index2/number_of_sets 1536
/sys/devices/system/cpu/cpu0/cache/index2/shared_cpu_map 00000000,00000000,00000000,00000005
/sys/devices/system/cpu/cpu0/cache/index2/size 1920K
/sys/devices/system/cpu/cpu0/cache/index2/type Unified
/sys/devices/system/cpu/cpu0/cache/index2/ways_of_associativity 10
/sys/devices/system/cpu/cpu0/cache/index3/coherency_line_size 128
/sys/devices/system/cpu/cpu0/cache/index3/level 3
/sys/devices/system/cpu/cpu0/cache/index3/number_of_sets 1
/sys/devices/system/cpu/cpu0/cache/index3/shared_cpu_map 00000000,00000000,00000000,00000005
/sys/devices/system/cpu/cpu0/cache/index3/size 36864K
/sys/devices/system/cpu/cpu0/cache/index3/type Unified
/sys/devices/system/cpu/cpu0/cache/index3/ways_of_associativity 0

--D

