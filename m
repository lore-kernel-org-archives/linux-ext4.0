From: Jim Meyering <jim@meyering.net>
Subject: ext4: 1k-blocksize loopback corruption without removing backing file
Date: Thu, 21 Apr 2011 20:27:25 +0200
Message-ID: <87k4ensbn6.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
To: ext <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:53756 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1DUS1d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Apr 2011 14:27:33 -0400
Received: from mx.meyering.net (unknown [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id DF97594011B
	for <linux-ext4@vger.kernel.org>; Thu, 21 Apr 2011 20:27:26 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Much like this report,

    loopback-mounted ext4 sees hole-filling (on rawhide, but not F15)
    http://thread.gmane.org/gmane.comp.file-systems.ext4/24454

but not requiring that one remove the backing file, this script shows the
same sort of corruption with a loopback-ext4-in-loopback-ext4 file system:
[Note these FS are small enough that they get a blocksize of 1024 by default.
 When I specify -b 2048 or 4096, the problem goes away. ]

=============================================
#!/bin/sh
set -e
dd if=/dev/zero of=blob bs=9k count=1000 >/dev/null 2>&1
mkdir mnt
mkfs -q -t ext4 -F blob
mount -oloop blob mnt

c1=$PWD
cd mnt

dd if=/dev/zero of=blob bs=4k count=1000 >/dev/null 2>&1
mkdir m2
mkfs -q -t ext4 -F blob
mount -oloop blob m2

c2=$PWD
cd m2

# Create a reference file.  Just like the following one,
# but with explicit NULs in place of holes.
perl -e '$n=1024; for (1..71) { print "\0"x$n, chr($_)x$n };' \
  -e 'close *STDOUT or die "$!"' > ref

# Seek 1KB, write 1KB of data, seek 1KB, write 1KB of data, etc....
perl -e '$n = 1 * 1024; *F = *STDOUT;' \
  -e 'for (1..71) { sysseek (*F, $n, 1)' \
  -e '&& syswrite (*F, chr($_)x$n) or die "$!"}' > j1

# filefrag -vs j1

sync
cmp -s ref j1 && fail=0 || fail=1

cd /
umount "$c2/m2" "$c1/mnt"
rm -rf "$c1/blob" "$c1/mnt"

exit $fail
=============================================

This shows that it fails most of the time for me in tmpfs on a rawhide
guest (2.6.39-0.rc3.git2.0.fc16.x86_64) running on an F15 host.  YMWV.

    $ while :; do ./ext4-bug; printf $?; done
    111111110111111110111111011111111110101111111111
    [Exit 130 (INT)]
